// Spec character-sheet : « Fiche du personnage ».
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
import 'package:game_table/sheet/sheet_page.dart';
import 'package:material_ui/material_ui.dart';

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

const _aldric = CharacterInput(
  name: 'Aldric Varenne',
  kind: 'pc',
  speciesId: 'srd:species:human',
  backgroundId: 'srd:background:soldier',
  baseScores: BaseScores(
    method: ScoreMethod.pointBuy,
    strength: 15,
    dexterity: 13,
    constitution: 14,
    intelligence: 8,
    wisdom: 12,
    charisma: 10,
  ),
  backgroundChoice: BackgroundChoice(
    distribution: '2-1',
    bonuses: {'str': 2, 'con': 1},
  ),
  classLevels: [
    ClassLevelInput(
      classId: 'srd:class:fighter',
      level: 1,
      skillChoices: ['srd:skill:perception', 'srd:skill:survival'],
    ),
  ],
  alignment: 'LB',
  feats: [
    FeatInput(
      featId: 'srd:feat:alert',
      sourceType: 'species',
      sourceRef: 'srd:species:human',
    ),
  ],
  weaponMasteries: [
    WeaponMasteryInput(weaponId: 'srd:weapon:longsword', slotIndex: 0),
  ],
  items: [
    ItemInput(itemId: 'srd:weapon:longsword', quantity: 1, equipped: true),
    ItemInput(itemId: 'srd:weapon:javelin', quantity: 8),
    ItemInput(itemId: 'srd:armor:chain-mail', quantity: 1, equipped: true),
    ItemInput(itemId: 'srd:armor:shield', quantity: 1, equipped: true),
  ],
);

Future<void> _open(
  WidgetTester tester,
  double width, {
  String id = 'a',
  int level = 1,
  String? subclass,
}) async {
  tester.view.physicalSize = Size(width, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final database = TavernierDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  final store = CharacterStore(database);
  await store.save(
    'a',
    _aldric.copyWith(
      classLevels: [
        _aldric.classLevels.single.copyWith(level: level, subclassId: subclass),
      ],
    ),
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        contentProvider.overrideWith((ref) => _content),
        characterStoreProvider.overrideWith((ref) => store),
      ],
      child: MaterialApp(
        theme: AppTheme.dark,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: SheetPage(id: id),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final width in [390.0, 1440.0]) {
    testWidgets('$width dp : en-tête, 7 onglets, valeurs de [D1]', (
      tester,
    ) async {
      await _open(tester, width);
      expect(find.text('Aldric Varenne'), findsOneWidget);
      expect(
        find.text('Humain · Guerrier 1 · Soldat · Loyal Bon'),
        findsOneWidget,
      );
      expect(find.byType(Tab), findsNWidgets(7));
      // CA 18 : cotte de mailles 16 + bouclier 2, sans le don Défense ici.
      expect(find.text('18'), findsOneWidget);
      expect(find.text('9 m'), findsOneWidget);
      expect(find.byType(AbilityTile), findsNWidgets(6));
      expect(tester.takeException(), isNull);
    });

    testWidgets('$width dp : décomposition de la Force', (tester) async {
      await _open(tester, width);
      await tester.tap(find.byType(AbilityTile).first);
      await tester.pumpAndSettle();
      expect(find.byType(ValueBreakdown), findsOneWidget);
      expect(find.text('Valeur de base'), findsOneWidget);
      expect(find.text('Soldat'), findsOneWidget);
      expect(find.textContaining('(17 − 10) ÷ 2'), findsOneWidget);
      expect(find.text('Athlétisme +5'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Fermer'));
      await tester.pumpAndSettle();
      expect(find.byType(ValueBreakdown), findsNothing);
    });

    testWidgets('$width dp : compétences et décomposition', (tester) async {
      await _open(tester, width);
      await tester.tap(find.text('Compétences'));
      await tester.pumpAndSettle();
      expect(find.text('Athlétisme'), findsOneWidget);
      await tester.tap(find.text('Athlétisme'));
      await tester.pumpAndSettle();
      expect(find.text('Modificateur de Force'), findsOneWidget);
      expect(find.text('Bonus de maîtrise'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  for (final width in [390.0, 1440.0]) {
    testWidgets('$width dp : onglet Combat', (tester) async {
      await _open(tester, width);
      await tester.ensureVisible(find.text('Combat'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Combat'));
      await tester.pumpAndSettle();
      expect(find.text('Épée longue'), findsOneWidget);
      expect(find.text('Mains nues'), findsOneWidget);
      expect(find.text('1d8 + 3'), findsOneWidget);
      expect(find.text('Botte : Sape'), findsOneWidget);
      expect(find.textContaining('Désavantage'), findsOneWidget);
      expect(find.text('Javeline · Ralentissement'), findsNothing);
      expect(find.text('Second souffle'), findsOneWidget);
      expect(find.byType(ResourcePips), findsWidgets);
      expect(find.text('Épée longue · Sape'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('toucher').first);
      await tester.pumpAndSettle();
      expect(find.text('Modificateur de Force'), findsOneWidget);
      expect(find.text('Bonus de maîtrise'), findsOneWidget);
    });

    testWidgets('$width dp : onglet Aptitudes et filtres', (tester) async {
      await _open(tester, width);
      final tab = find.text('Aptitudes');
      await tester.ensureVisible(tab);
      await tester.pumpAndSettle();
      await tester.tap(tab);
      await tester.pumpAndSettle();
      expect(find.text('Guerrier 1'), findsOneWidget);
      expect(find.text('Humain'), findsOneWidget);
      expect(find.text('Second souffle'), findsOneWidget);
      expect(find.text('Vigilant'), findsOneWidget);
      // Attaque supplémentaire arrive au niveau 5.
      expect(find.text('Attaque supplémentaire'), findsNothing);

      await tester.tap(find.text('Avec utilisations'));
      await tester.pumpAndSettle();
      expect(find.text('Second souffle'), findsOneWidget);
      expect(find.text('Vigilant'), findsNothing);
      expect(find.text('repos court'), findsOneWidget);

      await tester.tap(find.text('Dons').first);
      await tester.pumpAndSettle();
      expect(find.text('Vigilant'), findsOneWidget);
      expect(find.text('Second souffle'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('toutes les valeurs se décomposent', (tester) async {
    await _open(tester, 1440);
    for (final label in [
      'CA',
      'Initiative',
      'Vitesse',
      'Maîtrise',
      'Percep. passive',
      'PV max',
    ]) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(find.byType(ValueBreakdown), findsOneWidget, reason: label);
      await tester.tap(find.text('Fermer'));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('aptitudes de sous-classe atteintes', (tester) async {
    await _open(tester, 1440, level: 3, subclass: 'srd:subclass:champion');
    await tester.tap(find.text('Aptitudes'));
    await tester.pumpAndSettle();
    expect(find.text('Champion'), findsOneWidget);
    expect(find.text('Critique amélioré'), findsOneWidget);
    expect(find.text('Survivant'), findsNothing);
  });

  testWidgets('bouton de montée de niveau', (tester) async {
    await _open(tester, 390);
    expect(find.text('Monter au niveau 2'), findsOneWidget);
  });

  testWidgets('niveau 20 : plus de bouton', (tester) async {
    await _open(tester, 390, level: 20);
    expect(find.textContaining('Monter au niveau'), findsNothing);
  });

  testWidgets('personnage introuvable', (tester) async {
    await _open(tester, 390, id: 'inconnu');
    expect(find.text('Ce personnage est introuvable.'), findsOneWidget);
    expect(find.text('Retour'), findsOneWidget);
  });
}
