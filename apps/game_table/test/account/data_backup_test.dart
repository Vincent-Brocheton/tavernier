// Spec account : « Mes données », « Rappel de sauvegarde » (US-17, ENF-10,
// ENF-12).
import 'dart:convert';
import 'dart:typed_data';

import 'package:dnd_data/dnd_data.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/data_backup.dart';
import 'package:game_table/creation/creation_providers.dart';
import 'package:game_table/settings/device_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _now = DateTime.utc(2026, 11, 13, 12);

Future<ProviderContainer> _container({
  Map<String, Object> prefs = const {},
  DateTime? lastSync,
  bool withCharacter = true,
  List<(String, Uint8List)>? saved,
  bool cancel = false,
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final preferences = await SharedPreferences.getInstance();
  final database = TavernierDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  if (withCharacter) {
    await database.customStatement(
      'INSERT INTO character (id, name, kind, species_id, background_id, status) '
      "VALUES ('a', 'Aldric', 'pc', 'srd:species:human', 'srd:background:soldier', 'draft')",
    );
  }
  final container = ProviderContainer(
    overrides: <Override>[
      sharedPreferencesProvider.overrideWithValue(preferences),
      databaseProvider.overrideWithValue(database),
      clockProvider.overrideWithValue(() => _now),
      lastSyncedAtProvider.overrideWith((ref) => Stream.value(lastSync)),
      saveFileProvider.overrideWithValue((name, bytes, _) async {
        saved?.add((name, bytes));
        return !cancel;
      }),
    ],
  );
  addTearDown(container.dispose);
  // Laisse les flux livrer leur première valeur.
  container
    ..listen(lastSyncedAtProvider, (_, _) {})
    ..listen(hasUserDataProvider, (_, _) {});
  await container.read(lastSyncedAtProvider.future);
  await container.read(hasUserDataProvider.future);
  return container;
}

String _ago(int days) => _now.subtract(Duration(days: days)).toIso8601String();

void main() {
  test('32 jours sans synchronisation ni export : rappel', () async {
    final container = await _container(
      prefs: {'last_export_at': _ago(40), 'first_launch_at': _ago(90)},
      lastSync: _now.subtract(const Duration(days: 32)),
    );
    expect(container.read(backupReminderProvider), 32);
  });

  test('synchronisé hier : pas de rappel', () async {
    final container = await _container(
      prefs: {'first_launch_at': _ago(90)},
      lastSync: _now.subtract(const Duration(days: 1)),
    );
    expect(container.read(backupReminderProvider), isNull);
  });

  test('rien à sauvegarder : pas de rappel', () async {
    final container = await _container(
      prefs: {'first_launch_at': _ago(90)},
      withCharacter: false,
    );
    expect(container.read(backupReminderProvider), isNull);
  });

  test('jamais sauvegardé : compté depuis le premier lancement', () async {
    final container = await _container(prefs: {'first_launch_at': _ago(31)});
    expect(container.read(backupReminderProvider), 31);
  });

  test('premier lancement : la date est posée, pas de rappel', () async {
    final container = await _container(withCharacter: false);
    expect(container.read(backupReminderProvider), isNull);
    expect(
      container.read(sharedPreferencesProvider)!.getString('first_launch_at'),
      _now.toIso8601String(),
    );
  });

  test('« Plus tard » : masqué', () async {
    final container = await _container(prefs: {'first_launch_at': _ago(40)});
    container.read(backupSnoozedProvider.notifier).snooze();
    expect(container.read(backupReminderProvider), isNull);
  });

  test('export : fichier JSON daté, date retenue, rappel levé', () async {
    final saved = <(String, Uint8List)>[];
    final container = await _container(
      prefs: {'first_launch_at': _ago(40)},
      saved: saved,
    );
    await container.read(dataBackupProvider).export();
    final (name, bytes) = saved.single;
    expect(name, 'tavernier-export-2026-11-13.json');
    final json = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    expect(json['format'], 'tavernier-export');
    expect(
      ((json['tables'] as Map)['character'] as List).single,
      containsPair('name', 'Aldric'),
    );
    expect(container.read(lastExportProvider), _now);
    expect(container.read(backupReminderProvider), isNull);
  });

  test('partage refermé : pas compté comme sauvegarde', () async {
    final container = await _container(
      prefs: {'first_launch_at': _ago(40)},
      cancel: true,
    );
    await container.read(dataBackupProvider).export();
    expect(container.read(lastExportProvider), isNull);
    expect(container.read(backupReminderProvider), 40);
  });

  test('date d’export illisible : ignorée', () async {
    final container = await _container(
      prefs: {'last_export_at': 'n’importe quoi', 'first_launch_at': _ago(5)},
    );
    expect(container.read(lastExportProvider), isNull);
    expect(container.read(backupReminderProvider), isNull);
  });
}
