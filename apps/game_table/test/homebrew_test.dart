// Spec homebrew : « Mes packs », « Vérification d'un pack », « Éditeur
// d'effets », « Éditeur de Don », « Éditeur d'Historique » (US-27 lot a,
// [H01] à [H03]).
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/account_providers.dart';
import 'package:game_table/creation/creation_providers.dart';
import 'package:game_table/homebrew/homebrew_page.dart';
import 'package:game_table/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

late TavernierDatabase _db;

Future<void> _open(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  _db = TavernierDatabase(NativeDatabase.memory());
  addTearDown(_db.close);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(_db),
        contentProvider.overrideWith((ref) => _content),
        pseudonymProvider.overrideWith((ref) async => 'Inès'),
      ],
      child: MaterialApp(
        theme: AppTheme.dark,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: HomebrewPage()),
      ),
    ),
  );
  await _settle(tester);
}

/// Laisse la base finir ses écritures, hors du temps simulé du test.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 3; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pumpAndSettle();
  }
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
  await tester.tap(finder.first);
  await _settle(tester);
}

Future<HomebrewDraft> _draft(WidgetTester tester) async =>
    (await tester.runAsync(() => HomebrewStore(_db).watchAll().first))!.single;

/// Démonte l'app avant la fin : drift ferme ses requêtes observées par un
/// minuteur, qui doit partir avant la vérification finale.
void _test(String description, Future<void> Function(WidgetTester) body) =>
    testWidgets(description, (tester) async {
      await body(tester);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

Future<void> _newPack(WidgetTester tester) async {
  await _tap(tester, find.text('Nouveau pack'));
  await tester.enterText(find.byType(TextField), 'Gardiens des Marches');
  await _tap(tester, find.text('Créer'));
}

void main() {
  _test('[H01] : SRD inclus, nouveau pack 0.1.0, types à venir grisés', (
    tester,
  ) async {
    await _open(tester);
    expect(find.text('Aucun pack pour l’instant.'), findsOneWidget);
    expect(find.textContaining('verrouillé'), findsOneWidget);
    final species = tester.widget<ActionChip>(
      find.widgetWithText(ActionChip, 'Espèce'),
    );
    expect(species.onPressed, isNull);

    await _newPack(tester);
    expect(find.text('Gardiens des Marches'), findsOneWidget);
    expect(find.text('Enregistré sur l’appareil'), findsOneWidget);
    final draft = await _draft(tester);
    expect(draft.manifest['namespace'], 'gardiens-des-marches');
    expect(draft.manifest['version'], '0.1.0');
    expect(draft.manifest['author'], 'Inès');
    expect(find.text('Prêt à publier'), findsOneWidget);
  });

  _test('[H03] : un Don d’origine avec +1 CA tant qu’il porte un bouclier', (
    tester,
  ) async {
    await _open(tester);
    await _newPack(tester);
    await _tap(tester, find.widgetWithText(ActionChip, 'Don'));
    await tester.enterText(find.widgetWithText(TextField, 'Nom *'), 'Veilleur');
    await tester.enterText(
      find.widgetWithText(TextField, 'Texte (ce que le joueur lira)'),
      'Vous montez la garde.',
    );
    await _tap(tester, find.text('Catégorie *'));
    await _tap(tester, find.text('Origine').last);

    await _tap(tester, find.text('Ajouter un effet'));
    await _tap(tester, find.text('Modifier la Classe d’armure'));
    await tester.enterText(find.widgetWithText(TextFormField, 'Valeur'), '1');
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Condition'));
    await _tap(tester, find.text('tant que vous portez un bouclier').last);
    expect(
      find.text('+1 à la Classe d’armure tant que vous portez un bouclier'),
      findsOneWidget,
    );
    await _tap(tester, find.text('Enregistrer l’effet'));
    await _tap(tester, find.text('Enregistrer'));

    final feat = (await _draft(tester)).entities.single;
    expect(feat, {
      'id': 'gardiens-des-marches:feat:veilleur',
      'type': 'feat',
      'name': 'Veilleur',
      'data': {'category': 'origin'},
      'effects': [
        {
          'op': 'modify_ac',
          'value': 1,
          'when': {'shield': true},
        },
      ],
      'text': {'fr': 'Vous montez la garde.'},
    });
    expect(find.text('Veilleur'), findsOneWidget);
    expect(find.text('Prêt à publier'), findsOneWidget);
  });

  _test('Historique à 2 caractéristiques : enregistré, signalé', (
    tester,
  ) async {
    await _open(tester);
    await _newPack(tester);
    await _tap(tester, find.widgetWithText(ActionChip, 'Historique'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Nom *'),
      'Sentinelle',
    );
    await _tap(tester, find.widgetWithText(FilterChip, 'Force'));
    await _tap(tester, find.widgetWithText(FilterChip, 'Constitution'));
    expect(
      find.text('Règle 2024 : exactement 3 caractéristiques.'),
      findsOneWidget,
    );
    // Seuls les dons d'origine sont proposés.
    await _tap(tester, find.text('Don d’origine *'));
    expect(find.text('Vigilant').last, findsOneWidget);
    expect(find.text('Lutteur'), findsNothing);
    await _tap(tester, find.text('Vigilant').last);
    await _tap(tester, find.text('Enregistrer'));

    final background = (await _draft(tester)).entities.single;
    expect((background['data']! as Map)['abilities'], [
      'srd:ability:strength',
      'srd:ability:constitution',
    ]);
    // Dans la liste, puis sous chaque problème de la vérification.
    expect(find.text('Sentinelle'), findsWidgets);
    expect(
      find.textContaining('exactement 3 caractéristiques'),
      findsOneWidget,
    );
    expect(find.text('Prêt à publier'), findsNothing);
  });
}
