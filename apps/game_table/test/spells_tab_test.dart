// Spec character-sheet : « Onglet Sorts », « Fiche de sort ».
import 'dart:convert';
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/creation/creation_providers.dart';
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

late CharacterStore _store;

Future<void> _open(
  WidgetTester tester,
  CharacterInput character, {
  double width = 1440,
  PlayState? play,
}) async {
  tester.view.physicalSize = Size(width, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final database = TavernierDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  _store = CharacterStore(database);
  await tester.runAsync(() async {
    await _store.save('a', character);
    if (play != null) await _store.saveState('a', play);
  });
  await tester.pumpWidget(
    ProviderScope(
      overrides: [characterStoreProvider.overrideWith((ref) => _store)],
      child: MaterialApp(
        theme: AppTheme.dark,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SpellsTab(
            id: 'a',
            content: _content,
            character: character,
            sheet: computeSheet(character, _content),
          ),
        ),
      ),
    ),
  );
  await _settle(tester);
}

/// La base tourne hors de l'horloge de test.
Future<void> _settle(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 50)),
  );
  await tester.pumpAndSettle();
}

Future<void> _openSpell(WidgetTester tester, String name) async {
  final target = find.text(name);
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Finder get _castButton => find.widgetWithText(FilledButton, 'Lancer');

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

  testWidgets('lancer décompte l\'emplacement choisi', (tester) async {
    await _open(tester, mira);
    await _openSpell(tester, 'Sanctuaire');
    await tester.tap(find.text('2e niveau (3 restants)'));
    await tester.pumpAndSettle();
    await tester.tap(_castButton);
    await _settle(tester);
    expect(find.text('2 / 3'), findsOneWidget);
    expect(find.text('4 / 4'), findsOneWidget);
    expect(
      (await tester.runAsync(() => _store.loadState('a')))!
          .usedOf(slotResource(2)),
      1,
    );
  });

  testWidgets('plus d\'emplacement : Lancer désactivé', (tester) async {
    await _open(tester, mira, play: PlayState(used: {slotResource(3): 2}));
    final row = find.ancestor(
      of: find.text('Esprits gardiens'),
      matching: find.byType(ListTile),
    );
    final button = tester.widget<TextButton>(
      find.descendant(of: row, matching: find.byType(TextButton)),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('sort mineur : pas de choix d\'emplacement', (tester) async {
    await _open(tester, mira);
    await _openSpell(tester, 'Flamme sacrée');
    expect(find.text('Emplacement'), findsNothing);
    await tester.tap(_castButton);
    await _settle(tester);
    expect(find.text('4 / 4'), findsOneWidget);
  });

  testWidgets('lancer ouvre la concentration', (tester) async {
    await _open(tester, mira);
    await _openSpell(tester, 'Bénédiction');
    await tester.tap(_castButton);
    await _settle(tester);
    expect(find.text('Concentration en cours'), findsOneWidget);
    await tester.tap(find.text('Mettre fin'));
    await _settle(tester);
    expect(find.text('Concentration en cours'), findsNothing);
    expect(
      (await tester.runAsync(() => _store.loadState('a')))!
          .concentrationSpellId,
      isNull,
    );
  });

  testWidgets('second sort : confirmation puis remplacement', (tester) async {
    await _open(
      tester,
      mira,
      play: const PlayState(concentrationSpellId: 'srd:spell:bless'),
    );
    await _openSpell(tester, 'Esprits gardiens');
    expect(find.textContaining('Le lancer met fin à'), findsOneWidget);
    await tester.tap(_castButton);
    await tester.pumpAndSettle();
    expect(find.text('Mettre fin à Bénédiction ?'), findsOneWidget);
    await tester.tap(find.text('Lancer quand même'));
    await _settle(tester);
    final state = await tester.runAsync(() => _store.loadState('a'));
    expect(state!.concentrationSpellId, 'srd:spell:spirit-guardians');
    expect(state.usedOf(slotResource(3)), 1);
  });

  testWidgets('confirmation refusée : rien ne change', (tester) async {
    await _open(
      tester,
      mira,
      play: const PlayState(concentrationSpellId: 'srd:spell:bless'),
    );
    await _openSpell(tester, 'Esprits gardiens');
    await tester.tap(_castButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Annuler'));
    await _settle(tester);
    final state = await tester.runAsync(() => _store.loadState('a'));
    expect(state!.concentrationSpellId, 'srd:spell:bless');
    expect(state.used, isEmpty);
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
