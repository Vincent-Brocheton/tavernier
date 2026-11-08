// Outils partagés des tests de dnd_data.
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:drift/native.dart';
import 'package:srd_builder/srd_builder.dart';

/// Base en mémoire, en tables ordinaires (tests rapides).
TavernierDatabase memoryDatabase() =>
    TavernierDatabase(NativeDatabase.memory());

/// Base ouverte comme sur un appareil : PowerSync, dans un dossier
/// temporaire.
Future<TavernierDatabase> powerSyncDatabase() async =>
    openPowerSyncTavernierDatabase(
      Directory.systemTemp
          .createTemp('tavernier')
          .then((dir) => '${dir.path}/tavernier.db'),
    );

/// Noms des tables (hors tables internes de SQLite).
Future<Set<String>> tableNames(TavernierDatabase db) async => {
  for (final row
      in await db
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type = 'table' "
            "AND name NOT LIKE 'sqlite_%' AND name NOT LIKE 'content_search_%'",
          )
          .get())
    row.read<String>('name'),
};

/// Colonnes de la clé primaire d'une table.
Future<List<String>> primaryKey(TavernierDatabase db, String table) async => [
  for (final row
      in await db
          .customSelect("SELECT name, pk FROM pragma_table_info('$table')")
          .get())
    if (row.read<int>('pk') > 0) row.read<String>('name'),
];

/// Pack SRD de l'échantillon M0, chargé depuis ses sources.
final ContentPack srdPack = () {
  final dir = Directory.fromUri(
    Isolate.resolvePackageUriSync(Uri.parse('package:dnd_data/'))!
        .resolve('../../../tools/srd_builder/sources/'),
  );
  final loaded = loadSources(dir);
  return loaded.pack ?? (throw StateError('${loaded.issues}'));
}();

/// Entrée d'Aldric niveau 1, fixture [D1] de dnd_rules.
Map<String, Object?> aldricJson() {
  final file = File.fromUri(
    Isolate.resolvePackageUriSync(Uri.parse('package:dnd_rules/'))!
        .resolve('../test/fixtures/d1/aldric_n1.json'),
  );
  final json = jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
  return json['input']! as Map<String, Object?>;
}
