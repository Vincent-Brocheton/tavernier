// Spec account : « Mes données », « Rappel de sauvegarde » (US-17, [A7], [G6]).
import 'dart:convert';
import 'dart:typed_data';

import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/backup_widgets.dart';
import 'package:game_table/account/data_backup.dart';
import 'package:game_table/creation/creation_providers.dart';
import 'package:game_table/l10n/app_localizations.dart';
import 'package:game_table/settings/device_settings.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _now = DateTime.utc(2026, 11, 13, 12);

late TavernierDatabase _database;

Future<List<String>> _pump(
  WidgetTester tester,
  Widget child, {
  Uint8List? open,
}) async {
  SharedPreferences.setMockInitialValues({
    'first_launch_at': _now
        .subtract(const Duration(days: 32))
        .toIso8601String(),
  });
  final prefs = await SharedPreferences.getInstance();
  final database = _database = TavernierDatabase(NativeDatabase.memory());
  final saved = <String>[];
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(database),
        clockProvider.overrideWithValue(() => _now),
        lastSyncedAtProvider.overrideWith((ref) => Stream.value(null)),
        hasUserDataProvider.overrideWith((ref) async => true),
        openFileProvider.overrideWithValue(() async => open),
        saveFileProvider.overrideWithValue((
          String name,
          Uint8List _,
          String _,
        ) async {
          saved.add(name);
          return true;
        }),
      ],
      child: MaterialApp(
        theme: AppTheme.dark,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: Column(children: [child])),
      ),
    ),
  );
  await tester.pumpAndSettle();
  addTearDown(() async {
    // Démonte avant de fermer la base (minuteurs de drift).
    await tester.pumpWidget(const SizedBox());
    await database.close();
  });
  return saved;
}

void main() {
  testWidgets('Mes données : export, puis date du dernier export', (
    tester,
  ) async {
    final saved = await _pump(tester, const MyDataSection());
    expect(find.text('Aucun export sur cet appareil.'), findsOneWidget);
    await tester.runAsync(() async {
      await tester.tap(find.text('Exporter mes données'));
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    await tester.pumpAndSettle();
    expect(saved, ['tavernier-export-2026-11-13.json']);
    expect(find.textContaining('Dernier export :'), findsOneWidget);
  });

  testWidgets('rappel : 32 jours, « Plus tard » le masque', (tester) async {
    await _pump(tester, const BackupReminderBanner());
    expect(find.text('Aucune sauvegarde depuis 32 jours'), findsOneWidget);
    await tester.tap(find.text('Plus tard'));
    await tester.pumpAndSettle();
    expect(find.text('Aucune sauvegarde depuis 32 jours'), findsNothing);
  });

  testWidgets('rappel : « Exporter maintenant » exporte et le lève', (
    tester,
  ) async {
    final saved = await _pump(tester, const BackupReminderBanner());
    await tester.runAsync(() async {
      await tester.tap(find.text('Exporter maintenant'));
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    await tester.pumpAndSettle();
    expect(saved, hasLength(1));
    expect(find.text('Aucune sauvegarde depuis 32 jours'), findsNothing);
  });

  group('import', () {
    final export = utf8.encode(
      jsonEncode({
        'format': 'tavernier-export',
        'version': 1,
        'tables': {
          'character': [
            {
              'id': 'a',
              'name': 'Aldric',
              'kind': 'pc',
              'species_id': 'srd:species:human',
              'background_id': 'srd:background:soldier',
              'status': 'draft',
            },
          ],
        },
      }),
    );

    Future<int> characters() async =>
        (await _database.customSelect('SELECT id FROM character').get()).length;

    Future<void> importAndAnswer(WidgetTester tester, String answer) async {
      await tester.tap(find.text('Importer une sauvegarde'));
      await tester.pumpAndSettle();
      expect(find.text('Importer cette sauvegarde ?'), findsOneWidget);
      await tester.runAsync(() async {
        await tester.tap(find.text(answer));
        await Future<void>.delayed(const Duration(milliseconds: 200));
      });
      await tester.pumpAndSettle();
    }

    testWidgets('confirmé : ajouté, et compté', (tester) async {
      await _pump(tester, const MyDataSection(), open: export);
      await importAndAnswer(tester, 'Importer');
      expect(
        find.text('1 élément ajouté, aucun déjà présent.'),
        findsOneWidget,
      );
      expect(await tester.runAsync(characters), 1);
    });

    testWidgets('annulé : rien importé', (tester) async {
      await _pump(tester, const MyDataSection(), open: export);
      await importAndAnswer(tester, 'Annuler');
      expect(find.byType(SnackBar), findsNothing);
      expect(await tester.runAsync(characters), 0);
    });

    testWidgets('fichier refusé : dit pourquoi', (tester) async {
      await _pump(
        tester,
        const MyDataSection(),
        open: utf8.encode('{"format": "autre"}'),
      );
      await importAndAnswer(tester, 'Importer');
      expect(
        find.text('Ce fichier n’est pas une sauvegarde de Tavernier.'),
        findsOneWidget,
      );
    });

    testWidgets('aucun fichier choisi : pas de confirmation', (tester) async {
      await _pump(tester, const MyDataSection());
      await tester.tap(find.text('Importer une sauvegarde'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
