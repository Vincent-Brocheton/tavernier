// Spec sync-backend : « Envoi des écritures », « Fusion sans perte ».
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
  await client.auth.signUp(email: email, password: _password);
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
