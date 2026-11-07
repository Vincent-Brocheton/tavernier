// Spec character-sheet : « Montée de niveau ».
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
import 'package:game_table/sheet/level_up_draft.dart';
import 'package:game_table/sheet/level_up_page.dart';
import 'package:game_table/sheet/sheet_page.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

CharacterInput _aldric(int level) => CharacterInput(
  name: 'Aldric',
  kind: 'pc',
  speciesId: 'srd:species:human',
  backgroundId: 'srd:background:soldier',
  baseScores: const BaseScores(
    method: ScoreMethod.pointBuy,
    strength: 15,
    dexterity: 13,
    constitution: 14,
    intelligence: 8,
    wisdom: 12,
    charisma: 10,
  ),
  backgroundChoice: const BackgroundChoice(
    distribution: '2-1',
    bonuses: {'str': 2, 'con': 1},
  ),
  classLevels: [
    ClassLevelInput(
      classId: 'srd:class:fighter',
      level: level,
      skillChoices: const ['srd:skill:perception', 'srd:skill:survival'],
    ),
  ],
  feats: const [
    FeatInput(
      featId: 'srd:feat:savage-attacker',
      sourceType: 'background',
      sourceRef: 'srd:background:soldier',
    ),
    FeatInput(
      featId: 'srd:feat:alert',
      sourceType: 'species',
      sourceRef: 'srd:species:human',
    ),
    FeatInput(
      featId: 'srd:feat:defense',
      sourceType: 'class',
      sourceRef: 'srd:class:fighter',
    ),
  ],
  choices: const {
    'skillful': ['srd:skill:insight'],
  },
  weaponMasteries: const [
    WeaponMasteryInput(weaponId: 'srd:weapon:longsword', slotIndex: 0),
    WeaponMasteryInput(weaponId: 'srd:weapon:javelin', slotIndex: 1),
    WeaponMasteryInput(weaponId: 'srd:weapon:battleaxe', slotIndex: 2),
  ],
);

late CharacterStore _store;

Future<void> _open(
  WidgetTester tester,
  double width,
  int level, {
  String id = 'a',
}) async {
  tester.view.physicalSize = Size(width, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final database = TavernierDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  _store = CharacterStore(database);
  await _store.save('a', _aldric(level));
  final router = GoRouter(
    initialLocation: '/level',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(body: Text('fiche')),
        routes: [
          GoRoute(
            path: 'level',
            builder: (_, _) => LevelUpPage(id: id),
          ),
        ],
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        contentProvider.overrideWith((ref) => _content),
        characterStoreProvider.overrideWith((ref) => _store),
      ],
      child: MaterialApp.router(
        theme: AppTheme.dark,
        routerConfig: router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

FilledButton _next(WidgetTester tester) =>
    tester.widget<FilledButton>(find.byType(FilledButton).last);

Future<void> _tapNext(WidgetTester tester) async {
  await tester.tap(find.byType(FilledButton).last);
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, String label) async {
  final target = find.textContaining(label).last;
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

void main() {
  test('adresse de la montée de niveau', () {
    expect(levelUpPath('abc'), '/characters/abc/level-up');
  });

  testWidgets('personnage introuvable : pas de chargement sans fin', (
    tester,
  ) async {
    await _open(tester, 390, 1, id: 'inconnu');
    expect(find.text('Ce personnage est introuvable.'), findsOneWidget);
  });

  group('LevelUpDraft', () {
    test('Amélioration +2 à une valeur', () {
      final draft = const LevelUpDraft()
          .selectFeat(abilityScoreImprovementFeat)
          .toggleBonus('str', 1);
      expect(draft.storedFeatChoices, {'str': 2});
    });

    test('Amélioration +1 à deux valeurs', () {
      final draft = const LevelUpDraft()
          .selectFeat(abilityScoreImprovementFeat)
          .selectMode(ImprovementMode.oneAndOne)
          .toggleBonus('str', 2)
          .toggleBonus('con', 2);
      expect(draft.storedFeatChoices, {'str': 1, 'con': 1});
    });

    test('changer de répartition vide les caractéristiques', () {
      final draft = const LevelUpDraft()
          .selectFeat(abilityScoreImprovementFeat)
          .toggleBonus('str', 1)
          .selectMode(ImprovementMode.oneAndOne);
      expect(draft.bonuses, isEmpty);
    });

    test('changer de don vide ses choix', () {
      final draft = const LevelUpDraft()
          .selectFeat(abilityScoreImprovementFeat)
          .toggleBonus('str', 1)
          .selectFeat('srd:feat:grappler');
      expect(draft.bonuses, isEmpty);
    });
  });

  for (final width in [390.0, 1440.0]) {
    testWidgets('$width dp : niveau 2, sans don', (tester) async {
      await _open(tester, width, 1);
      expect(find.text('Guerrier 1 → 2'), findsOneWidget);
      expect(find.text('+8 PV'), findsOneWidget);
      await _tapNext(tester);
      expect(find.text('Fougue'), findsOneWidget);
      await _tapNext(tester);
      expect(find.text('Enregistrer'), findsOneWidget);
      await _tapNext(tester);
      expect(find.text('fiche'), findsOneWidget);
      final saved = await _store.load('a');
      expect(saved!.classLevels.single.level, 2);
      expect(tester.takeException(), isNull);
    });

    testWidgets('$width dp : niveau 3, sous-classe obligatoire', (
      tester,
    ) async {
      await _open(tester, width, 2);
      await _tapNext(tester);
      expect(_next(tester).onPressed, isNull);
      expect(find.text('Choisissez une sous-classe.'), findsOneWidget);
      await _tap(tester, 'Champion');
      expect(find.text('Critique amélioré'), findsOneWidget);
      expect(_next(tester).onPressed, isNotNull);
      await _tapNext(tester);
      await _tapNext(tester);
      final saved = await _store.load('a');
      expect(saved!.classLevels.single.subclassId, 'srd:subclass:champion');
    });

    testWidgets('$width dp : niveau 4, botte et Amélioration', (tester) async {
      await _open(tester, width, 3);
      await _tapNext(tester);
      expect(find.text('Choisissez votre nouvelle botte.'), findsOneWidget);
      await _tap(tester, 'Épée à deux mains');
      await _tapNext(tester);

      expect(find.text('Choisissez un don.'), findsOneWidget);
      expect(find.text('Déjà obtenu · non répétable'), findsWidgets);
      await _tap(tester, 'Amélioration de caractéristique');
      expect(find.text('Choisissez où porter le bonus.'), findsOneWidget);
      await _tap(tester, 'FOR 17');
      expect(_next(tester).onPressed, isNotNull);
      await _tapNext(tester);
      await _tapNext(tester);

      final saved = await _store.load('a');
      final sheet = computeSheet(saved!, _content);
      expect(sheet.integrityErrors, isEmpty);
      expect(sheet.abilities['str']!.value, 19);
      expect(saved.weaponMasteries, hasLength(4));
    });
  }
}
