// Spec character-creation : parcours des étapes Classe, Historique et Espèce
// sur le pack SRD réel, au téléphone et sur grand écran.
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/creation/creation_providers.dart';
import 'package:game_table/main.dart';
import 'package:material_ui/material_ui.dart';

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

Future<void> _open(WidgetTester tester, double width) async {
  tester.view.physicalSize = Size(width, 1300);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [contentProvider.overrideWith((ref) => _content)],
      child: const GameTableApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Personnages').first);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Nouveau personnage'));
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, String text) async {
  final target = find.text(text).first;
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

FilledButton _next(WidgetTester tester) =>
    tester.widget<FilledButton>(find.byType(FilledButton).last);

void main() {
  for (final width in [390.0, 1440.0]) {
    group('$width dp', () {
      testWidgets('étape 1 : Suivant bloqué et expliqué, Guerrier détaillé', (
        tester,
      ) async {
        await _open(tester, width);
        expect(find.text('Classe'), findsWidgets);
        expect(_next(tester).onPressed, isNull);
        expect(
          find.text('Choisissez une classe pour continuer.'),
          findsOneWidget,
        );
        await _tap(tester, 'Guerrier');
        expect(_next(tester).onPressed, isNotNull);
        expect(find.text('Principale : Force ou Dextérité'), findsOneWidget);
        expect(find.text('Principale : Dextérité et Sagesse'), findsWidgets);
        expect(find.text('d10 par niveau'), findsOneWidget);
        expect(find.text('Force et Constitution'), findsOneWidget);
      });

      testWidgets('étape 2 : le Soldat exige de choisir un type de jeu', (
        tester,
      ) async {
        await _open(tester, width);
        await _tap(tester, 'Guerrier');
        await tester.tap(find.byType(FilledButton).last);
        await tester.pumpAndSettle();
        await _tap(tester, 'Soldat');
        expect(find.text('Sauvagerie martiale'), findsOneWidget);
        expect(find.text('Athlétisme, Intimidation'), findsOneWidget);
        expect(
          find.text('Choisissez un outil pour continuer.'),
          findsOneWidget,
        );
        await _tap(tester, 'dés');
        expect(_next(tester).onPressed, isNotNull);
      });

      testWidgets('étape 3 : Humain demande sa taille, Nain non', (
        tester,
      ) async {
        await _open(tester, width);
        await _tap(tester, 'Guerrier');
        await tester.tap(find.byType(FilledButton).last);
        await tester.pumpAndSettle();
        await _tap(tester, 'Criminel');
        await tester.tap(find.byType(FilledButton).last);
        await tester.pumpAndSettle();
        expect(find.text('Goliath'), findsOneWidget);
        expect(find.text('M · 10,50 m'), findsOneWidget);
        await _tap(tester, 'Humain');
        expect(
          find.text('Choisissez une catégorie de taille pour continuer.'),
          findsOneWidget,
        );
        await _tap(tester, 'P');
        expect(_next(tester).onPressed, isNotNull);
        await _tap(tester, 'Nain');
        expect(_next(tester).onPressed, isNotNull);
      });

      testWidgets('Précédent garde le choix', (tester) async {
        await _open(tester, width);
        await _tap(tester, 'Guerrier');
        await tester.tap(find.byType(FilledButton).last);
        await tester.pumpAndSettle();
        await _tap(tester, 'Précédent');
        expect(_next(tester).onPressed, isNotNull);
      });
    });
  }

  testWidgets('ordre alphabétique français : Rôdeur avant Roublard', (
    tester,
  ) async {
    await _open(tester, 1440);
    expect(
      tester.getTopLeft(find.text('Rôdeur')).dx,
      lessThan(tester.getTopLeft(find.text('Roublard')).dx),
    );
  });

  testWidgets('téléphone : la carte ouverte amène son choix à l’écran', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [contentProvider.overrideWith((ref) => _content)],
        child: const GameTableApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Personnages').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nouveau personnage'));
    await tester.pumpAndSettle();
    await _tap(tester, 'Guerrier');
    await tester.tap(find.byType(FilledButton).last);
    await tester.pumpAndSettle();
    await _tap(tester, 'Criminel');
    await tester.tap(find.byType(FilledButton).last);
    await tester.pumpAndSettle();
    await _tap(tester, 'Humain');
    final footer = tester.getTopLeft(find.byType(WizardFooter)).dy;
    expect(
      tester.getBottomLeft(find.byType(SegmentedButton<String>)).dy,
      lessThan(footer),
    );
  });

  testWidgets('filtre Lanceurs de sorts et recherche', (tester) async {
    await _open(tester, 1440);
    await _tap(tester, 'Lanceurs de sorts');
    expect(find.text('Barbare'), findsNothing);
    expect(find.text('Barde'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'bar');
    await tester.pumpAndSettle();
    expect(find.text('Clerc'), findsNothing);
    expect(find.text('Barde'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();
    expect(find.text('Aucun résultat.'), findsOneWidget);
  });

  testWidgets('grand écran : liste des étapes, et retour par la liste', (
    tester,
  ) async {
    await _open(tester, 1440);
    expect(find.byType(WizardSteps), findsOneWidget);
    await _tap(tester, 'Guerrier');
    await tester.tap(find.byType(FilledButton).last);
    await tester.pumpAndSettle();
    expect(find.text('ÉTAPE 2 SUR 9'), findsOneWidget);
    // L'étape Espèce n'est pas atteinte.
    await tester.tap(find.text('Espèce'));
    await tester.pumpAndSettle();
    expect(find.text('ÉTAPE 2 SUR 9'), findsOneWidget);
    await tester.tap(find.text('Classe'));
    await tester.pumpAndSettle();
    expect(find.text('ÉTAPE 1 SUR 9'), findsOneWidget);
  });

  testWidgets('téléphone : progression, pas de liste d’étapes', (tester) async {
    await _open(tester, 390);
    expect(find.text('Étape 1 sur 9'), findsOneWidget);
    expect(find.byType(WizardSteps), findsNothing);
  });

  testWidgets('fermer revient à Personnages', (tester) async {
    await _open(tester, 390);
    await tester.tap(find.byTooltip('Fermer'));
    await tester.pumpAndSettle();
    expect(find.text('Nouveau personnage'), findsOneWidget);
    expect(find.text('Aucun personnage pour l’instant.'), findsOneWidget);
  });
}
