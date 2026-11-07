// Spec character-sheet : « Onglet Sorts », « Fiche de sort ».
import 'dart:convert';
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/l10n/app_localizations.dart';
import 'package:game_table/sheet/spells_tab.dart';
import 'package:material_ui/material_ui.dart';

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

CharacterInput _fixture(String name) {
  final path = '../../packages/dnd_rules/test/fixtures/d1/$name.json';
  final data =
      jsonDecode(File(path).readAsStringSync()) as Map<String, Object?>;
  return CharacterInput.fromJson(data['input']! as Map<String, Object?>);
}

Future<void> _open(
  WidgetTester tester,
  CharacterInput character, {
  double width = 1440,
}) async {
  tester.view.physicalSize = Size(width, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SpellsTab(
          content: _content,
          character: character,
          sheet: computeSheet(character, _content),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  final mira = _fixture('mira_n5');

  testWidgets('Mira [P14] : valeurs, emplacements, préparés', (tester) async {
    await _open(tester, mira);
    expect(find.text('14'), findsOneWidget);
    expect(find.text('+6'), findsOneWidget);
    expect(find.text('4 / 4'), findsOneWidget);
    expect(find.text('Préparés : 9 / 9'), findsOneWidget);
    expect(find.text('Plus 9 sorts toujours préparés'), findsOneWidget);
    expect(find.text('SORTS MINEURS'), findsOneWidget);
    expect(find.text('1ER NIVEAU'), findsOneWidget);
    expect(find.text('Sanctuaire'), findsOneWidget);
  });

  testWidgets('format téléphone', (tester) async {
    await _open(tester, mira, width: 390);
    expect(tester.takeException(), isNull);
  });

  testWidgets('filtre Concentration', (tester) async {
    await _open(tester, mira);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Concentration'));
    await tester.pumpAndSettle();
    expect(find.text('Bénédiction'), findsOneWidget);
    expect(find.text('Sanctuaire'), findsNothing);
  });

  testWidgets('filtre Rituels', (tester) async {
    await _open(tester, mira);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Rituels'));
    await tester.pumpAndSettle();
    expect(find.text('Détection de la magie'), findsOneWidget);
    expect(find.text('Sanctuaire'), findsNothing);
  });

  testWidgets('fiche de sort', (tester) async {
    await _open(tester, mira);
    await tester.tap(find.text('Bénédiction'));
    await tester.pumpAndSettle();
    expect(find.text('Enchantement du 1er niveau'), findsOneWidget);
    expect(find.text('9 m'), findsOneWidget);
    expect(
      find.textContaining('Concentration, jusqu’à 1 minute'),
      findsOneWidget,
    );
    expect(find.textContaining('un symbole sacré'), findsOneWidget);
    await tester.tap(find.text('Fermer'));
    await tester.pumpAndSettle();
    expect(find.text('Enchantement du 1er niveau'), findsNothing);
  });

  testWidgets('décomposition du DD', (tester) async {
    await _open(tester, mira);
    await tester.tap(find.text('14'));
    await tester.pumpAndSettle();
    expect(find.text('DD des sorts'), findsOneWidget);
    expect(find.text('+3'), findsNWidgets(2));
  });

  testWidgets('Aldric [P17] : aucun sort', (tester) async {
    await _open(tester, _fixture('aldric_n1'));
    expect(find.text('Aucun sort'), findsOneWidget);
  });

  testWidgets('Orin [F5b] : emplacements combinés', (tester) async {
    await _open(
      tester,
      mira.copyWith(
        classLevels: const [
          ClassLevelInput(classId: 'srd:class:cleric', level: 3),
          ClassLevelInput(classId: 'srd:class:paladin', level: 4),
        ],
      ),
    );
    expect(find.text('Emplacements combinés'), findsOneWidget);
    expect(
      find.text('Clerc 3 + Paladin 4 ÷ 2 (arrondi supérieur) = 5'),
      findsOneWidget,
    );
    expect(find.text('Clerc'), findsOneWidget);
    expect(find.text('Paladin'), findsOneWidget);
  });

  testWidgets('Sélène [F5a] : magie de pacte', (tester) async {
    await _open(
      tester,
      mira.copyWith(
        classLevels: const [
          ClassLevelInput(classId: 'srd:class:warlock', level: 5),
        ],
      ),
    );
    expect(find.text('Magie de pacte'), findsOneWidget);
    expect(find.text('2 emplacements du 3e niveau'), findsOneWidget);
    expect(find.text('Récupérés au repos court.'), findsOneWidget);
  });
}
