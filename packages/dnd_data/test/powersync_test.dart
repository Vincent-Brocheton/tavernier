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

  test('tables synchronisées : celles de la publication Supabase', () {
    final migrations = Directory.fromUri(
      Isolate.resolvePackageUriSync(Uri.parse('package:dnd_data/'))!
          .resolve('../../../backend/supabase/migrations/'),
    );
    final sql = migrations
        .listSync()
        .whereType<File>()
        .map((f) => f.readAsStringSync())
        .firstWhere((s) => s.contains('create publication powersync'));
    final published = RegExp(r'public\.(\w+)')
        .allMatches(sql.substring(sql.indexOf('create publication')))
        .map((m) => m[1]!)
        .toSet();
    expect(published, syncedTables);
  });
}
