// Export des données et rappel de sauvegarde (US-17, ENF-10, ENF-12).
import 'dart:convert';
import 'dart:typed_data';

import 'package:dnd_data/dnd_data.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../creation/creation_providers.dart';
import '../settings/device_settings.dart';
import '../src/save_file_io.dart'
    if (dart.library.js_interop) '../src/save_file_web.dart'
    as platform;

/// Heure courante, remplacée dans les tests.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Enregistre un fichier : téléchargement sur le Web, partage ailleurs ;
/// faux si l'utilisateur y a renoncé.
final saveFileProvider =
    Provider<Future<bool> Function(String name, Uint8List bytes, String type)>(
      (ref) => platform.saveFile,
    );

/// Choisit un fichier JSON et rend son contenu ; `null` si l'utilisateur a
/// renoncé.
final openFileProvider = Provider<Future<Uint8List?> Function()>(
  (ref) => () async {
    final file = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(
          label: 'JSON',
          extensions: ['json'],
          mimeTypes: ['application/json'],
          uniformTypeIdentifiers: ['public.json'],
        ),
      ],
    );
    return file?.readAsBytes();
  },
);

/// Au-delà, l'accueil rappelle de sauvegarder (ENF-12).
const backupReminderDays = 30;

const _lastExportKey = 'last_export_at';
const _firstLaunchKey = 'first_launch_at';

DateTime? _date(String? value) =>
    value == null ? null : DateTime.tryParse(value)?.toUtc();

/// Date du dernier export fait sur cet appareil.
final lastExportProvider = NotifierProvider<LastExport, DateTime?>(
  LastExport.new,
);

class LastExport extends Notifier<DateTime?> {
  @override
  DateTime? build() =>
      _date(ref.watch(sharedPreferencesProvider)?.getString(_lastExportKey));

  void record(DateTime at) {
    state = at;
    ref
        .read(sharedPreferencesProvider)
        ?.setString(_lastExportKey, at.toIso8601String());
  }
}

/// Premier lancement de l'app sur l'appareil, posé la première fois : point de
/// départ du rappel quand rien n'a jamais été sauvegardé.
final firstLaunchProvider = Provider<DateTime>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final known = _date(prefs?.getString(_firstLaunchKey));
  if (known != null) return known;
  final now = ref.watch(clockProvider)();
  prefs?.setString(_firstLaunchKey, now.toIso8601String());
  return now;
});

/// Dernière synchronisation complète, gardée par PowerSync entre deux
/// lancements ; `null` sans synchronisation.
final lastSyncedAtProvider = StreamProvider<DateTime?>((ref) async* {
  final powerSync = ref.watch(databaseProvider).powerSync;
  if (powerSync == null) {
    yield null;
    return;
  }
  final db = await powerSync;
  yield db.currentStatus.lastSyncedAt;
  yield* db.statusStream.map((s) => s.lastSyncedAt).distinct();
});

/// Vrai s'il existe au moins un personnage ou une table à sauvegarder. Lu une
/// fois : le rappel ne concerne que le lancement.
final hasUserDataProvider = FutureProvider<bool>((ref) async {
  final row = await ref
      .watch(databaseProvider)
      .customSelect(
        'SELECT EXISTS (SELECT 1 FROM character) '
        'OR EXISTS (SELECT 1 FROM game_table) AS any',
      )
      .getSingle();
  return row.read<bool>('any');
});

/// « Plus tard » : le rappel est masqué jusqu'au prochain lancement.
final backupSnoozedProvider = NotifierProvider<BackupSnoozed, bool>(
  BackupSnoozed.new,
);

class BackupSnoozed extends Notifier<bool> {
  @override
  bool build() => false;

  void snooze() => state = true;
}

/// Jours sans synchronisation ni export, quand le rappel doit s'afficher ;
/// `null` sinon.
final backupReminderProvider = Provider<int?>((ref) {
  // Lu d'abord : la date du premier lancement se pose dès l'accueil.
  final firstLaunch = ref.watch(firstLaunchProvider);
  if (ref.watch(backupSnoozedProvider)) return null;
  if (ref.watch(hasUserDataProvider).value != true) return null;
  final last = [
    ref.watch(lastExportProvider),
    ref.watch(lastSyncedAtProvider).value,
    firstLaunch,
  ].nonNulls.reduce((a, b) => a.isAfter(b) ? a : b);
  final days = ref.watch(clockProvider)().difference(last).inDays;
  return days >= backupReminderDays ? days : null;
});

/// Export des données de l'utilisateur dans un fichier JSON.
final dataBackupProvider = Provider<DataBackup>(DataBackup.new);

class DataBackup {
  DataBackup(this._ref);

  final Ref _ref;

  Future<void> export() async {
    final now = _ref.read(clockProvider)();
    final data = await exportUserData(_ref.read(databaseProvider), now: now);
    final day = now.toIso8601String().substring(0, 10);
    final saved = await _ref.read(saveFileProvider)(
      'tavernier-export-$day.json',
      utf8.encode(const JsonEncoder.withIndent('  ').convert(data)),
      'application/json',
    );
    // Partage refermé sans rien enregistrer : pas une sauvegarde.
    if (saved) _ref.read(lastExportProvider.notifier).record(now);
  }

  /// Importe un export : ajoute ce qui manque, garde ce qui est déjà là.
  /// Lève une [FormatException] si le fichier n'est pas un export lisible.
  Future<UserDataImport> import(Uint8List bytes) async {
    final data = jsonDecode(utf8.decode(bytes));
    if (data is! Map<String, Object?>) {
      throw const FormatException('pas un export Tavernier');
    }
    return importUserData(_ref.read(databaseProvider), data);
  }
}
