// Spec local-database : « Base locale PowerSync ».
import 'dart:io';
import 'dart:isolate';

import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:test/test.dart';

import 'support.dart';

Future<String?> _type(TavernierDatabase db, String name) async =>
    (await db
            .customSelect(
              'SELECT type FROM sqlite_master WHERE name = ?',
              variables: [Variable.withString(name)],
            )
            .getSingleOrNull())
        ?.read<String>('type');

void main() {
  late TavernierDatabase db;
  setUp(() async => db = await powerSyncDatabase());
  tearDown(() => db.close());

  test('tables synchronisées en vues, contenu de règles en tables', () async {
    for (final table in syncedTables) {
      expect(await _type(db, table), 'view', reason: table);
    }
    for (final table in ['content_pack', 'spell', 'class_level', 'encounter']) {
      expect(await _type(db, table), 'table', reason: table);
    }
  });

  test('écriture hors ligne : relue, et en attente dans la file', () async {
    final store = CharacterStore(db);
    final aldric = CharacterInput.fromJson(aldricJson());
    await store.save('a', aldric);
    expect(await store.load('a'), aldric);
    final queued = await db
        .customSelect('SELECT count(*) AS n FROM ps_crud')
        .getSingle();
    expect(queued.read<int>('n'), greaterThan(0));
  });

  test('PV modifiés : la valeur remplacée part avec la modification', () async {
    final store = CharacterStore(db);
    await store.save('a', CharacterInput.fromJson(aldricJson()));
    await store.saveState('a', const PlayState(hpCurrent: 29));
    await store.saveState('a', const PlayState(hpCurrent: 39));
    final powerSync = (await db.powerSync)!;
    final entries = (await powerSync.getCrudBatch(limit: 1000))!.crud;
    final patch = entries.lastWhere(
      (e) => e.table == 'character_state' && e.opData?['hp_current'] == 39,
    );
    expect(patch.previousValues, {'hp_current': 29});
  });

  group('enregistrement par différence', () {
    late CharacterStore store;
    late CharacterInput aldric;
    Future<List<String>> queue() async => [
      for (final row
          in await db
              .customSelect('SELECT data FROM ps_crud ORDER BY id')
              .get())
        row.read<String>('data'),
    ];

    setUp(() async {
      store = CharacterStore(db);
      aldric = CharacterInput.fromJson(aldricJson());
      await store.save('a', aldric);
      await db.customStatement('DELETE FROM ps_crud');
    });

    test('rien ne change : file vide', () async {
      await store.save('a', aldric);
      expect(await queue(), isEmpty);
    });

    test('un objet change : seule sa quantité part', () async {
      final items = [...aldric.items];
      items[3] = items[3].copyWith(quantity: 2);
      await store.save('a', aldric.copyWith(items: items));
      expect(await queue(), [
        '{"op":"PATCH","id":"a:character_item:3","type":"character_item",'
            '"data":{"quantity":2}}',
      ]);
      expect(await store.load('a'), aldric.copyWith(items: items));
    });

    test('un objet de moins : sa ligne seule est supprimée', () async {
      final items = [...aldric.items]..removeLast();
      await store.save('a', aldric.copyWith(items: items));
      expect(await queue(), [
        '{"op":"DELETE","id":"a:character_item:5","type":"character_item"}',
      ]);
      expect(await store.load('a'), aldric.copyWith(items: items));
    });
  });

  test('dates en texte ISO 8601, comme les transporte PowerSync', () async {
    await db.customStatement(
      'INSERT INTO game_table (id, name, stat_method, long_rest_rule, '
      'hp_on_level_rule, progression_mode) '
      "VALUES ('t', 'T', 'point_buy', 'full', 'average', 'xp')",
    );
    // Forme reçue de Postgres (timestamptz).
    await db.customStatement(
      'INSERT INTO table_member (id, table_id, user_id, role, joined_at) '
      "VALUES ('m', 't', 'u', 'gm', '2026-11-08 17:38:43.123Z')",
    );
    final member = await db.select(db.tableMembers).getSingle();
    expect(member.joinedAt.toUtc(), DateTime.utc(2026, 11, 8, 17, 38, 43, 123));
  });

  test(
    'une séance (M3, locale) se rattache à une table synchronisée',
    () async {
      await db.customStatement(
        'INSERT INTO game_table (id, name, stat_method, long_rest_rule, '
        'hp_on_level_rule, progression_mode) '
        "VALUES ('t', 'T', 'point_buy', 'full', 'average', 'xp')",
      );
      await db.customStatement(
        'INSERT INTO session (id, table_id, date, title) '
        "VALUES ('s', 't', '2026-11-08', 'Séance 1')",
      );
      final session = await db.select(db.sessions).getSingle();
      expect(session.tableId, 't');
    },
  );

  test('tables synchronisées : celles de la publication Supabase', () {
    final migrations = Directory.fromUri(
      Isolate.resolvePackageUriSync(Uri.parse('package:dnd_data/'))!
          .resolve('../../../backend/supabase/migrations/'),
    );
    final sql = migrations
        .listSync()
        .whereType<File>()
        .map((f) => f.readAsStringSync())
        .join('\n');
    // La publication d'origine, puis les tables ajoutées par la suite.
    final created = sql.substring(sql.indexOf('create publication powersync'));
    final published = {
      for (final m in RegExp(
        r'public\.(\w+)',
      ).allMatches(created.substring(0, created.indexOf(';'))))
        m[1]!,
      for (final m in RegExp(
        r'alter publication powersync add table public\.(\w+)',
      ).allMatches(sql))
        m[1]!,
    };
    expect(published, syncedTables);
  });
}
