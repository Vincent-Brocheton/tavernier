// Spec character-creation : parcours des étapes Classe, Historique et Espèce
// sur le pack SRD réel, au téléphone et sur grand écran.
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/creation/creation_providers.dart';
import 'package:game_table/main.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

late CharacterStore _store;

Future<void> _open(WidgetTester tester, double width) async {
  tester.view.physicalSize = Size(width, 1300);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final database = TavernierDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  _store = CharacterStore(database);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        contentProvider.overrideWith((ref) => _content),
        characterStoreProvider.overrideWith((ref) => _store),
      ],
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

Finder _bonus(String label) =>
    find.byWidgetPredicate((w) => w is BonusToggle && w.semanticLabel == label);

Future<void> _tapBonus(WidgetTester tester, String label) async {
  await tester.ensureVisible(_bonus(label));
  await tester.pumpAndSettle();
  await tester.tap(_bonus(label));
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

  testWidgets('grand écran : un premier choix ne déplace pas les cartes', (
    tester,
  ) async {
    await _open(tester, 1440);
    final before = tester.getTopLeft(find.text('Clerc'));
    await _tap(tester, 'Guerrier');
    expect(tester.getTopLeft(find.text('Clerc')), before);
  });

  testWidgets('écran bas : l’introduction laisse la place à la liste', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(844, 390);
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
    expect(find.textContaining('Votre classe décide'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  group('étapes Langues et Caractéristiques', () {
    Future<void> toLanguages(WidgetTester tester, double width) async {
      await _open(tester, width);
      await _tap(tester, 'Guerrier');
      await tester.tap(find.byType(FilledButton).last);
      await tester.pumpAndSettle();
      await _tap(tester, 'Criminel');
      await tester.tap(find.byType(FilledButton).last);
      await tester.pumpAndSettle();
      await _tap(tester, 'Nain');
      await tester.tap(find.byType(FilledButton).last);
      await tester.pumpAndSettle();
    }

    Future<void> tapRepeated(
      WidgetTester tester,
      String tooltip,
      int times,
    ) async {
      final target = find.byTooltip(tooltip);
      await tester.ensureVisible(target);
      await tester.pumpAndSettle();
      for (var i = 0; i < times; i++) {
        await tester.tap(target);
        await tester.pump();
      }
      await tester.pumpAndSettle();
    }

    Future<void> toAbilities(WidgetTester tester, double width) async {
      await toLanguages(tester, width);
      await _tap(tester, 'Orc');
      await _tap(tester, 'Elfique');
      await tester.tap(find.byType(FilledButton).last);
      await tester.pumpAndSettle();
    }

    Future<void> spendAllPoints(WidgetTester tester) async {
      await tapRepeated(tester, 'Augmenter Force', 7);
      await tapRepeated(tester, 'Augmenter Dextérité', 5);
      await tapRepeated(tester, 'Augmenter Constitution', 6);
      await tapRepeated(tester, 'Augmenter Sagesse', 4);
      await tapRepeated(tester, 'Augmenter Charisme', 2);
    }

    for (final width in [390.0, 1440.0]) {
      testWidgets('$width dp : langues, compteur et plafond', (tester) async {
        await toLanguages(tester, width);
        expect(find.text('Commun'), findsWidgets);
        expect(find.text('Gigant'), findsNothing);
        expect(find.text('Géant'), findsOneWidget);
        expect(find.text('Abyssal'), findsNothing);
        expect(
          find.text('Choisissez encore 2 langues pour continuer.'),
          findsOneWidget,
        );
        await _tap(tester, 'Orc');
        expect(find.text('1 / 2'), findsOneWidget);
        expect(
          find.text('Choisissez encore 1 langue pour continuer.'),
          findsOneWidget,
        );
        await _tap(tester, 'Elfique');
        expect(_next(tester).onPressed, isNotNull);
        final gnome = find.widgetWithText(CheckboxListTile, 'Gnome');
        expect(tester.widget<CheckboxListTile>(gnome).onChanged, isNull);
      });

      testWidgets('$width dp : points puis bonus jusqu’à Suivant', (
        tester,
      ) async {
        await toAbilities(tester, width);
        expect(find.text('0 / 27 points'), findsOneWidget);
        expect(find.text('Il reste 27 points à dépenser.'), findsOneWidget);
        await spendAllPoints(tester);
        expect(find.text('27 / 27 points'), findsOneWidget);
        expect(
          find.text('Placez vos bonus d’Historique pour continuer.'),
          findsOneWidget,
        );
        expect(find.text('Non éligible pour Criminel'), findsNWidgets(3));
        await _tapBonus(tester, '+2 sur Constitution');
        await _tapBonus(tester, '+1 sur Dextérité');
        expect(find.text('Le +1 doit aller ailleurs'), findsOneWidget);
        expect(find.text('Le +2 doit aller ailleurs'), findsOneWidget);
        expect(_next(tester).onPressed, isNotNull);
        expect(tester.takeException(), isNull);
      });
    }

    for (final width in [390.0, 1440.0]) {
      testWidgets('$width dp : valeurs standard, échange, Suivant', (
        tester,
      ) async {
        await toAbilities(tester, width);
        await _tap(tester, 'Valeurs standard');
        expect(find.text('15, 14, 13, 12, 10, 8 à répartir'), findsOneWidget);
        expect(find.byType(DropdownButtonFormField<int>), findsNWidgets(6));
        final charisma = find.widgetWithText(
          DropdownButtonFormField<int>,
          'Charisme',
        );
        await tester.ensureVisible(charisma);
        await tester.pumpAndSettle();
        await tester.tap(charisma);
        await tester.pumpAndSettle();
        await tester.tap(find.text('15').last);
        await tester.pumpAndSettle();
        int valueOf(String ability) => tester
            .widget<DropdownButtonFormField<int>>(
              find.widgetWithText(DropdownButtonFormField<int>, ability),
            )
            .initialValue!;
        expect(valueOf('Charisme'), 15);
        expect(valueOf('Force'), 8);
        await _tapBonus(tester, '+2 sur Constitution');
        await _tapBonus(tester, '+1 sur Dextérité');
        expect(_next(tester).onPressed, isNotNull);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('génération aléatoire : bloquée, puis jets saisis', (
      tester,
    ) async {
      await toAbilities(tester, 1440);
      await _tap(tester, 'Génération aléatoire');
      expect(
        find.text(
          'Lancez les dés ou saisissez vos jets pour obtenir vos six valeurs.',
        ),
        findsOneWidget,
      );
      expect(find.byType(DropdownButtonFormField<int>), findsNothing);

      await _tap(tester, 'Saisir mes jets');
      final validate = find.widgetWithText(FilledButton, 'Valider');
      for (final (i, value) in ['16', '9', '13', '11', '7', '19'].indexed) {
        await tester.enterText(find.byType(TextField).at(i), value);
      }
      await tester.pump();
      expect(tester.widget<FilledButton>(validate).onPressed, isNull);
      await tester.enterText(find.byType(TextField).at(5), '14');
      await tester.pump();
      await tester.tap(validate);
      await tester.pumpAndSettle();
      expect(find.text('Jets : 16, 9, 13, 11, 7, 14'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<int>), findsNWidgets(6));
    });

    testWidgets('génération aléatoire : Lancer tire six jets', (tester) async {
      await toAbilities(tester, 1440);
      await _tap(tester, 'Génération aléatoire');
      await _tap(tester, 'Lancer');
      expect(find.textContaining('Jets : '), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<int>), findsNWidgets(6));
    });

    testWidgets('Suggérer : 27 points, bonus posés, tout Suivant', (
      tester,
    ) async {
      await toAbilities(tester, 1440);
      await tester.tap(find.widgetWithText(OutlinedButton, 'Suggérer'));
      await tester.pumpAndSettle();
      expect(find.text('27 / 27 points'), findsOneWidget);
      expect(find.text('Suggestion appliquée, modifiable'), findsOneWidget);
      expect(find.textContaining('Force en tête'), findsOneWidget);
      expect(_next(tester).onPressed, isNotNull);
      await tester.tap(find.byType(FilledButton).last);
      await tester.pumpAndSettle();

      final buttons = find.widgetWithText(OutlinedButton, 'Suggérer');
      await tester.ensureVisible(buttons.first);
      await tester.pumpAndSettle();
      await tester.tap(buttons.first);
      await tester.pumpAndSettle();
      expect(find.text('Suggestion appliquée, modifiable'), findsOneWidget);
    });

    testWidgets('Force non éligible : pas de bonus, explication', (
      tester,
    ) async {
      await toAbilities(tester, 1440);
      final toggle = find.bySemanticsLabel('+2 sur Force');
      expect(toggle, findsOneWidget);
      await tester.tap(toggle, warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('Bonus à refaire'), findsNothing);
      expect(
        tester.widget<BonusToggle>(_bonus('+2 sur Force')).state,
        BonusToggleState.blocked,
      );
    });

    testWidgets('changer d’Historique signale le bonus à refaire', (
      tester,
    ) async {
      await toAbilities(tester, 1440);
      await spendAllPoints(tester);
      await _tapBonus(tester, '+2 sur Intelligence');
      await _tapBonus(tester, '+1 sur Constitution');
      await tester.tap(find.byType(FilledButton).last);
      await tester.pumpAndSettle();
      expect(find.text('ÉTAPE 6 SUR 9'), findsOneWidget);
      await tester.tap(find.text('Historique'));
      await tester.pumpAndSettle();
      await _tap(tester, 'Soldat');
      await _tap(tester, 'dés');
      // L'étape à reprendre le dit dans la liste, avant même d'y aller.
      expect(find.text('À refaire'), findsOneWidget);
      await tester.tap(find.text('Caractéristiques'));
      await tester.pumpAndSettle();
      expect(find.text('Bonus à refaire'), findsOneWidget);
      expect(
        find.textContaining('Le bonus placé sur Intelligence'),
        findsOneWidget,
      );
      expect(
        find.text(
          'Placez vos bonus sur des caractéristiques éligibles pour '
          'continuer.',
        ),
        findsOneWidget,
      );
      expect(
        tester.widget<BonusToggle>(_bonus('+2 sur Intelligence')).state,
        BonusToggleState.invalid,
      );
      await _tapBonus(tester, '+2 sur Intelligence');
      expect(find.text('Bonus à refaire'), findsNothing);
    });

    for (final width in [390.0, 1440.0]) {
      testWidgets('$width dp : sous-choix du Guerrier jusqu’à Équipement', (
        tester,
      ) async {
        await toAbilities(tester, width);
        // Au téléphone, comme un lien direct : rien à dépiler à la fin.
        final direct = width == 390;
        if (direct) {
          GoRouter.of(tester.element(find.byType(WizardFooter)))
              .go('/characters/new');
          await tester.pumpAndSettle();
        }
        await spendAllPoints(tester);
        await _tapBonus(tester, '+2 sur Constitution');
        await _tapBonus(tester, '+1 sur Dextérité');
        await tester.tap(find.byType(FilledButton).last);
        await tester.pumpAndSettle();
        expect(find.text('Compétences de Guerrier'), findsWidgets);
        expect(
          find.text('À compléter : Compétences de Guerrier.'),
          findsOneWidget,
        );
        await _tap(tester, 'Perception');
        await _tap(tester, 'Survie');
        await _tap(tester, 'Épée longue · Sape');
        await _tap(tester, 'Javeline · Ralentissement');
        await _tap(tester, 'Hache d’armes · Renversement');
        await _tap(tester, 'Défense');
        expect(_next(tester).onPressed, isNotNull);
        await tester.tap(find.byType(FilledButton).last);
        await tester.pumpAndSettle();

        // Équipement.
        expect(_next(tester).onPressed, isNull);
        expect(find.text('Choisissez un lot de classe.'), findsOneWidget);
        await _tap(tester, 'Lot A');
        expect(
          find.text('Choisissez le lot de l’Historique ou son or.'),
          findsOneWidget,
        );
        await tester.ensureVisible(find.text('Lot B').last);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Lot B').last);
        await tester.pumpAndSettle();
        expect(find.text('CA avec cet équipement'), findsOneWidget);
        expect(find.text('54 po'), findsOneWidget);
        await tester.tap(find.byType(FilledButton).last);
        await tester.pumpAndSettle();

        // Détails.
        expect(_next(tester).onPressed, isNull);
        await tester.enterText(find.byType(TextFormField).first, 'Aldric');
        await tester.pumpAndSettle();
        await tester.tap(find.byType(FilledButton).last);
        await tester.pumpAndSettle();

        // Récapitulatif.
        expect(find.text('Aldric'), findsOneWidget);
        expect(find.text('Vérification des règles'), findsOneWidget);
        expect(find.text('Botte sur une arme absente'), findsOneWidget);
        expect(find.text('Mains nues'), findsOneWidget);
        expect(find.text('unarmed'), findsNothing);
        expect(find.text('Enregistrer'), findsOneWidget);
        expect(_next(tester).onPressed, isNotNull);
        await tester.tap(find.byType(FilledButton).last);
        await tester.pumpAndSettle();

        // Retour à la liste : le personnage est enregistré et affiché.
        final saved = await _store.list();
        expect(saved.single.character.name, 'Aldric');
        if (direct) await _tap(tester, 'Personnages');
        expect(find.text('Aldric'), findsOneWidget);
        expect(find.text('Nain · Guerrier 1 · Criminel'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('+1, +1 et +1 : trois bonus, une seule colonne', (
      tester,
    ) async {
      await toAbilities(tester, 1440);
      await spendAllPoints(tester);
      await _tap(tester, '+1, +1 et +1');
      expect(_bonus('+2 sur Dextérité'), findsNothing);
      await _tapBonus(tester, '+1 sur Dextérité');
      await _tapBonus(tester, '+1 sur Constitution');
      expect(_next(tester).onPressed, isNull);
      await _tapBonus(tester, '+1 sur Intelligence');
      expect(_next(tester).onPressed, isNotNull);
    });
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
