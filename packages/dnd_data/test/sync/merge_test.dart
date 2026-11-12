// Spec sync-backend : « Envoi des écritures », « Fusion sans perte »,
// « Fusion entre les comptes d'une table », « Conflits détectés et tracés ».
// Contre Supabase et PowerSync locaux (job CI « Base Supabase ») ; sans
// SUPABASE_URL, SUPABASE_ANON_KEY et POWERSYNC_URL, le test se saute.
import 'dart:io';

import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart' show PowerSyncDatabase;
import 'package:supabase/supabase.dart';
import 'package:test/test.dart';

import '../support.dart';

final _env = Platform.environment;
final _url = _env['SUPABASE_URL'];
final _anonKey = _env['SUPABASE_ANON_KEY'];
final _powerSyncUrl = _env['POWERSYNC_URL'];

/// Un appareil : sa base, sa session Supabase et sa synchronisation.
final class _Device {
  _Device._(this.db, this.powerSync, this.client);

  final TavernierDatabase db;
  final PowerSyncDatabase powerSync;
  final SupabaseClient client;

  CharacterStore get store => CharacterStore(db);

  static Future<_Device> signedIn(String email) async {
    final client = _client();
    await client.auth.signInWithPassword(email: email, password: _password);
    final db = await powerSyncDatabase();
    return _Device._(db, (await db.powerSync)!, client);
  }

  /// Écritures refusées par le serveur.
  final discarded = <String>[];

  Future<void> connect() => powerSync.connect(
    connector: SupabaseConnector(
      client,
      _powerSyncUrl!,
      onDiscarded: (w) =>
          discarded.add('${w.op} ${w.table}/${w.id} : ${w.code} ${w.message}'),
    ),
  );

  Future<void> disconnect() => powerSync.disconnect();

  Future<void> close() async {
    await db.close();
    await client.dispose();
  }
}

const _password = 'mot-de-passe-de-test';

/// Client sans stockage de session : flux direct, sans PKCE.
SupabaseClient _client() => SupabaseClient(
  _url!,
  _anonKey!,
  authOptions: const AuthClientOptions(authFlowType: AuthFlowType.implicit),
);

/// Compte neuf, propre à ce lancement.
Future<String> _newAccount(String who) async {
  final email = '$who-${DateTime.now().microsecondsSinceEpoch}@test.local';
  final client = _client();
  // 15 ans au moins, vérifiés par le serveur (US-12).
  await client.auth.signUp(
    email: email,
    password: _password,
    data: {'pseudonym': who, 'birth_date': '2000-01-01'},
  );
  await client.dispose();
  return email;
}

/// Attend que [ok] soit vrai, au plus 30 s.
Future<void> _until(Future<bool> Function() ok, String what) async {
  for (var i = 0; i < 150; i++) {
    if (await ok()) return;
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
  fail('délai dépassé : $what');
}

void main() {
  // Journaux de PowerSync et du connecteur (écritures écartées) en console.
  // ignore: avoid_print
  Logger.root.onRecord.listen((r) => print('[${r.loggerName}] ${r.message}'));
  final skip = _url == null || _anonKey == null || _powerSyncUrl == null
      ? 'backend absent (SUPABASE_URL, SUPABASE_ANON_KEY, POWERSYNC_URL)'
      : null;

  test(
    'trois appareils, trois modifications hors ligne : rien ne se perd',
    () async {
      final email = await _newAccount('fusion');
      final devices = [
        for (var i = 0; i < 3; i++) await _Device.signedIn(email),
      ];
      addTearDown(() async {
        for (final d in devices) {
          await d.close();
        }
      });
      final [a, b, c] = devices;
      final id = uuidV7();
      final aldric = CharacterInput.fromJson(aldricJson());

      // Créé sans connexion, donc sans propriétaire ; l'envoi le lui donne.
      await a.store.save(id, aldric);
      for (final d in devices) {
        await d.connect();
      }
      final server = a.client.from('character');
      await _until(
        () async =>
            (await server.select('owner_user_id').eq('id', id)).isNotEmpty,
        'personnage sur le serveur',
      );
      final row = await server.select('owner_user_id').eq('id', id).single();
      expect(row['owner_user_id'], a.client.auth.currentUser!.id);
      for (final d in [b, c]) {
        await _until(
          () async => await d.store.load(id) == aldric,
          'copie reçue',
        );
      }

      // Hors ligne, chacun change un point différent.
      for (final d in devices) {
        await d.disconnect();
      }
      final items = [...aldric.items];
      items[3] = items[3].copyWith(quantity: 2);
      await a.store.save(id, aldric.copyWith(items: items));
      await b.store.save(id, aldric.copyWith(name: 'Aldric le Brave'));
      await c.store.save(
        id,
        aldric.copyWith(
          languages: [...aldric.languages, 'srd:language:dwarvish'],
        ),
      );

      for (final d in devices) {
        await d.connect();
      }
      final merged = aldric.copyWith(
        name: 'Aldric le Brave',
        items: items,
        languages: [...aldric.languages, 'srd:language:dwarvish'],
      );
      for (final (i, d) in devices.indexed) {
        await _until(
          () async => await d.store.load(id) == merged,
          'fusion sur $i',
        );
      }
      final name = await server.select('name').eq('id', id).single();
      expect(name['name'], 'Aldric le Brave');
      for (final d in devices) {
        expect(d.discarded, isEmpty);
      }
    },
    skip: skip,
    timeout: const Timeout(Duration(minutes: 3)),
  );

  test(
    'MJ et deux joueurs, trois comptes, hors ligne : rien ne se perd',
    () async {
      final [gm, p1, p2] = [
        for (final who in ['mj', 'joueur1', 'joueur2'])
          await _Device.signedIn(await _newAccount(who)),
      ];
      addTearDown(() async {
        for (final d in [gm, p1, p2]) {
          await d.close();
        }
      });
      for (final d in [gm, p1, p2]) {
        await d.connect();
      }

      // Le MJ crée la table et son invitation.
      final tables = TableStore(gm.db);
      final tableId = await tables.create(
        gmUserId: gm.client.auth.currentUser!.id,
        settings: const TableSettings(name: 'Brumeval'),
        packs: const [],
      );
      final invite = await tables.createInvite(tableId);
      await _until(
        () async =>
            (await gm.client
                    .from('table_invite')
                    .select('id')
                    .eq('id', invite.id))
                .isNotEmpty,
        'invitation sur le serveur',
      );

      // Les joueurs rejoignent, puis créent leur fiche dans la table.
      final aldric = CharacterInput.fromJson(aldricJson());
      final ids = <_Device, String>{};
      for (final player in [p1, p2]) {
        final joined = await player.client.rpc<Map<String, dynamic>>(
          'join_table',
          params: {'code': invite.code},
        );
        expect(joined['table_id'], tableId);
        final me = player.client.auth.currentUser!.id;
        await _until(
          () async => await TableStore(player.db).load(tableId, me) != null,
          'table reçue par le joueur',
        );
        final id = uuidV7();
        ids[player] = id;
        await player.store.save(id, aldric, tableId: tableId);
      }
      for (final id in ids.values) {
        await _until(
          () async => await gm.store.load(id) == aldric,
          'fiche reçue par le MJ',
        );
      }

      // Hors ligne : le MJ change un réglage, chaque joueur sa fiche.
      for (final d in [gm, p1, p2]) {
        await d.disconnect();
      }
      final gmId = gm.client.auth.currentUser!.id;
      await tables.update(
        tableId,
        authorUserId: gmId,
        settings: const TableSettings(name: 'Brumeval', startingLevel: 3),
        fullSheetsVisible: false,
      );
      await p1.store.save(ids[p1]!, aldric.copyWith(name: 'Aldric le Brave'));
      await p2.store.saveState(ids[p2]!, const PlayState(hpCurrent: 4));

      for (final d in [gm, p1, p2]) {
        await d.connect();
      }
      for (final player in [p1, p2]) {
        final me = player.client.auth.currentUser!.id;
        await _until(
          () async =>
              (await TableStore(
                player.db,
              ).load(tableId, me))?.settings.startingLevel ==
              3,
          'réglage du MJ reçu par le joueur',
        );
      }
      await _until(
        () async => (await gm.store.load(ids[p1]!))?.name == 'Aldric le Brave',
        'fiche du joueur 1 reçue par le MJ',
      );
      await _until(
        () async => (await gm.store.loadState(ids[p2]!)).hpCurrent == 4,
        'PV du joueur 2 reçus par le MJ',
      );
      final server = await gm.client
          .from('game_table')
          .select('starting_level')
          .eq('id', tableId)
          .single();
      expect(server['starting_level'], 3);
      // Fiches fermées : un joueur ne reçoit pas celle de l'autre.
      expect(await p1.store.load(ids[p2]!), isNull);
      for (final d in [gm, p1, p2]) {
        expect(d.discarded, isEmpty);
      }
    },
    skip: skip,
    timeout: const Timeout(Duration(minutes: 4)),
  );

  test(
    'PV changés hors ligne par le MJ et le joueur : la version du MJ prime',
    () async {
      final gm = await _Device.signedIn(await _newAccount('mj-conflit'));
      final player = await _Device.signedIn(
        await _newAccount('joueur-conflit'),
      );
      addTearDown(() async {
        await gm.close();
        await player.close();
      });
      for (final d in [gm, player]) {
        await d.connect();
      }
      final tables = TableStore(gm.db);
      final tableId = await tables.create(
        gmUserId: gm.client.auth.currentUser!.id,
        settings: const TableSettings(name: 'Brumeval'),
        packs: const [],
      );
      final invite = await tables.createInvite(tableId);
      await _until(
        () async =>
            (await gm.client
                    .from('table_invite')
                    .select('id')
                    .eq('id', invite.id))
                .isNotEmpty,
        'invitation sur le serveur',
      );
      await player.client.rpc<Map<String, dynamic>>(
        'join_table',
        params: {'code': invite.code},
      );
      final me = player.client.auth.currentUser!.id;
      await _until(
        () async => await TableStore(player.db).load(tableId, me) != null,
        'table reçue',
      );
      final id = uuidV7();
      await player.store.save(
        id,
        CharacterInput.fromJson(aldricJson()),
        tableId: tableId,
      );
      await player.store.saveState(id, const PlayState(hpCurrent: 29));
      await _until(
        () async => (await gm.store.loadState(id)).hpCurrent == 29,
        'état reçu par le MJ',
      );

      // Hors ligne tous deux : le MJ règle les PV à 34, le joueur à 39.
      await gm.disconnect();
      await player.disconnect();
      await gm.store.saveState(id, const PlayState(hpCurrent: 34));
      await player.store.saveState(id, const PlayState(hpCurrent: 39));
      await gm.connect();
      final state = gm.client.from('character_state');
      await _until(
        () async =>
            (await state
                .select('hp_current')
                .eq('id', id)
                .single())['hp_current'] ==
            34,
        'PV du MJ sur le serveur',
      );
      await player.connect();
      await _until(
        () async =>
            (await player.store.history(id))
                .any((e) => e.detail['kind'] == 'conflict'),
        'conflit reçu par le joueur',
      );
      await _until(
        () async => (await player.store.loadState(id)).hpCurrent == 34,
        'PV du MJ reçus par le joueur',
      );
      final [conflict] = [
        for (final e in await player.store.history(id))
          if (e.detail['kind'] == 'conflict') e.detail,
      ];
      expect(conflict['field'], 'hp_current');
      expect(conflict['kept'], 34);
      expect(conflict['replaced'], 39);
      expect(conflict['replaced_by'], me);
      for (final d in [gm, player]) {
        expect(d.discarded, isEmpty);
      }
    },
    skip: skip,
    timeout: const Timeout(Duration(minutes: 3)),
  );

  test(
    'une écriture refusée ne bloque pas les suivantes',
    () async {
      final email = await _newAccount('refus');
      final device = await _Device.signedIn(email);
      addTearDown(device.close);
      // Une table au nom d'un autre MJ : les droits la refusent (42501).
      await device.db.customStatement(
        'INSERT INTO game_table (id, gm_user_id, name, stat_method, '
        'long_rest_rule, hp_on_level_rule, progression_mode) VALUES '
        "(?, '00000000-0000-0000-0000-000000000001', 'Usurpée', 'point_buy', "
        "'full', 'average', 'xp')",
        [uuidV7()],
      );
      final id = uuidV7();
      await device.store.save(id, CharacterInput.fromJson(aldricJson()));
      await device.connect();
      await _until(
        () async =>
            (await device.client.from('character').select('id').eq('id', id))
                .isNotEmpty,
        'personnage envoyé après le refus',
      );
      expect(device.discarded, [startsWith('PUT game_table/')]);
      expect(device.discarded.single, contains('42501'));
    },
    skip: skip,
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
