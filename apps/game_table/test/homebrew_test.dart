// Spec homebrew : « Mes packs », « Vérification d'un pack », « Éditeur
// d'effets », « Éditeur de Don », « Éditeur d'Historique » (US-27 lot a,
// [H01] à [H03]) ; « Éditeur de Sort », « Éditeur d'Objet », « Variante
// d'une entité du SRD » (lot b, [H05]) ; « Éditeur d'Espèce », ressource et
// choix imbriqué (lot b2) ; « Éditeur de Sous-classe » ([H02]) et
// « Éditeur de Classe » (lot c) ; « Éditeur de Monstre » (lot d) ;
// « Bac à sable d'une entité » (US-28, [H04]).
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
import 'package:game_table/creation/step_layout.dart';
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
  _test('[H01] : SRD inclus, nouveau pack 0.1.0, les 8 types éditables', (
    tester,
  ) async {
    await _open(tester);
    expect(find.text('Aucun pack pour l’instant.'), findsOneWidget);
    expect(find.textContaining('verrouillé'), findsOneWidget);
    for (final chip in tester.widgetList<ActionChip>(find.byType(ActionChip))) {
      expect(chip.onPressed, isNotNull);
    }

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

  _test('Sort : niveau, école, portée et listes de classes', (tester) async {
    await _open(tester);
    await _newPack(tester);
    await _tap(tester, find.widgetWithText(ActionChip, 'Sort'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Nom *'),
      'Lanterne de brume',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Texte (ce que le joueur lira)'),
      'Une lueur pâle.',
    );
    await _tap(tester, find.text('Niveau *'));
    await _tap(tester, find.text('1er niveau').last);
    await _tap(tester, find.text('École *'));
    await _tap(tester, find.text('Illusion').last);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Temps d’incantation * (ex. action)'),
      'action',
    );
    await _tap(tester, find.text('Portée *'));
    await _tap(tester, find.text('Distance').last);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Distance en pieds (5 pieds = 1,5 m)'),
      '60',
    );
    await _tap(tester, find.widgetWithText(FilterChip, 'Verbale'));
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Durée * (ex. 1 heure)'),
      '1 heure',
    );
    await tester.pumpAndSettle();
    // Seules les classes qui ont une liste de sorts sont proposées.
    expect(find.widgetWithText(FilterChip, 'Guerrier'), findsNothing);
    await _tap(tester, find.widgetWithText(FilterChip, 'Magicien'));
    await _tap(tester, find.text('Enregistrer'));

    final spell = (await _draft(tester)).entities.single;
    expect(spell['data'], {
      'ritual': false,
      'components': {'verbal': true, 'somatic': false},
      'material_consumed': false,
      'concentration': false,
      'level': 1,
      'school': 'illusion',
      'casting_time': 'action',
      'range': {'kind': 'feet', 'feet': 60},
      'duration': '1 heure',
      'classes': ['srd:class:wizard'],
    });
    expect(find.text('Prêt à publier'), findsOneWidget);
  });

  _test('[H05] : variante de la Hache d’armes, peu courante, harmonisée', (
    tester,
  ) async {
    await _open(tester);
    await _newPack(tester);
    await _tap(tester, find.text('Dériver d’une entité du SRD'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Rechercher dans le SRD'),
      'hache d’armes',
    );
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Hache d’armes'));
    expect(
      find.text(
        'Variante de Hache d’armes (SRD) · l’original n’est pas modifié',
      ),
      findsOneWidget,
    );
    // Le genre d'une variante ne se change pas.
    expect(find.text('Type *'), findsNothing);
    await tester.enterText(
      find.widgetWithText(TextField, 'Nom *'),
      'Hache des Marches',
    );
    await _tap(tester, find.text('Rareté'));
    await _tap(tester, find.text('Peu courant').last);
    await _tap(tester, find.text('Harmonisation requise'));
    await _tap(tester, find.text('Enregistrer'));

    final axe = (await _draft(tester)).entities.single;
    expect(axe['id'], 'gardiens-des-marches:weapon:hache-des-marches');
    expect(axe['extends_id'], 'srd:weapon:battleaxe');
    expect(axe['data'], containsPair('mastery', 'srd:mastery:topple'));
    expect(axe['data'], containsPair('rarity', 'uncommon'));
    expect(axe['data'], containsPair('attunement', true));
    expect(find.text('Prêt à publier'), findsOneWidget);
    // L'original n'est pas modifié.
    expect(
      (_content.entity('srd:weapon:battleaxe')!.data as WeaponData).rarity,
      isNull,
    );
  });

  _test('Arme neuve sans botte : enregistrée, signalée', (tester) async {
    await _open(tester);
    await _newPack(tester);
    await _tap(tester, find.widgetWithText(ActionChip, 'Objet'));
    expect(find.text('Arme'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextField, 'Nom *'), 'Fléau');
    expect(
      find.text('Règle 2024 : une arme a toujours une botte d’arme.'),
      findsOneWidget,
    );
    await _tap(tester, find.text('Enregistrer'));
    expect((await _draft(tester)).entities.single['type'], 'weapon');
    expect(find.text('une arme a toujours une botte d’arme'), findsOneWidget);
    expect(find.text('Prêt à publier'), findsNothing);
  });

  _test('[H03] : ressource égale au bonus de maîtrise, par Repos long', (
    tester,
  ) async {
    await _open(tester);
    await _newPack(tester);
    await _tap(tester, find.widgetWithText(ActionChip, 'Don'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Nom *'),
      'Rempart vivant',
    );
    await _tap(tester, find.text('Catégorie *'));
    await _tap(tester, find.text('Général').last);
    await _tap(tester, find.text('Ajouter un effet'));
    await _tap(tester, find.text('Ressource à utilisations'));
    await _tap(tester, find.text('Utilisations : calcul'));
    await _tap(tester, find.text('Bonus de maîtrise').last);
    expect(
      find.text(
        'Utilisations : bonus de maîtrise ; récupération : toutes au Repos long',
      ),
      findsOneWidget,
    );
    await _tap(tester, find.text('Enregistrer l’effet'));
    await _tap(tester, find.text('Enregistrer'));

    final feat = (await _draft(tester)).entities.single;
    expect(feat['effects'], [
      {
        'op': 'grant_resource',
        'id': 'gardiens-des-marches:resource:rempart-vivant',
        'max': {'ref': 'proficiency_bonus'},
        'recharge': [
          {'on': 'long_rest', 'amount': 'all'},
        ],
      },
    ]);
  });

  _test('Espèce : taille, Vitesse, un trait et une sous-lignée à choix', (
    tester,
  ) async {
    final spells = [
      for (final e in _content.entities)
        if (e.type == 'spell') e,
    ]..sort((a, b) => foldAccents(a.name).compareTo(foldAccents(b.name)));
    final firstSpell = spells.first;
    await _open(tester);
    await _newPack(tester);
    await _tap(tester, find.widgetWithText(ActionChip, 'Espèce'));
    await tester.enterText(find.widgetWithText(TextField, 'Nom *'), 'Brumelin');
    await _tap(tester, find.widgetWithText(FilterChip, 'Petite (P)'));
    expect(
      find.textContaining('viennent de l’Historique (règles 2024)'),
      findsOneWidget,
    );

    // Un trait simple.
    await _tap(tester, find.text('Ajouter un trait'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Nom *'),
      'Vision brumeuse',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Texte (ce que le joueur lira)'),
      'Vous voyez dans la brume.',
    );
    await _tap(tester, find.text('Ajouter un effet'));
    await _tap(tester, find.text('Accorder un sens'));
    await _tap(tester, find.text('Sens'));
    await _tap(tester, find.text('Vision dans le noir').last);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Distance en pieds (5 pieds = 1,5 m)'),
      '60',
    );
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Enregistrer l’effet'));
    await _tap(tester, find.text('Enregistrer le trait'));
    expect(find.text('Vision brumeuse'), findsOneWidget);

    // Une sous-lignée : un trait à choix, dont une option accorde un sort
    // au niveau 3.
    await _tap(tester, find.text('Ajouter un trait'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Nom *'),
      'Lignage brumeux',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Texte (ce que le joueur lira)'),
      'Choisissez un lignage.',
    );
    await _tap(tester, find.text('Ajouter un effet'));
    await _tap(tester, find.text('Choix'));
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Titre du choix (facultatif)'),
      'Lignage',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nom de l’option 1'),
      'Brume grise',
    );
    await tester.pumpAndSettle();
    // Sous la feuille du choix : le bouton du trait, puis ceux des options.
    await _tap(tester, find.text('Ajouter un effet').at(1));
    await _tap(tester, find.text('Accorder un sort'));
    await _tap(tester, find.text('Sort'));
    await _tap(tester, find.text(firstSpell.name).last);
    await tester.enterText(
      find
          .widgetWithText(TextFormField, 'À partir du niveau (facultatif)')
          .last,
      '3',
    );
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Enregistrer l’effet').last);
    expect(
      find.text('Lignage : 1 parmi Brume grise / Option 2'),
      findsOneWidget,
    );
    await _tap(tester, find.text('Enregistrer l’effet'));
    await _tap(tester, find.text('Enregistrer le trait'));
    await _tap(tester, find.text('Enregistrer'));

    final entities = (await _draft(tester)).entities;
    expect(entities.map((e) => e['id']), [
      'gardiens-des-marches:species:brumelin',
      'gardiens-des-marches:feature:brumelin-vision-brumeuse',
      'gardiens-des-marches:feature:brumelin-lignage-brumeux',
    ]);
    expect(entities[0]['data'], {
      'creature_type': 'humanoid',
      'speed_feet': 30,
      'sizes': ['P'],
      'traits': [
        'gardiens-des-marches:feature:brumelin-vision-brumeuse',
        'gardiens-des-marches:feature:brumelin-lignage-brumeux',
      ],
    });
    expect(entities[1], {
      'id': 'gardiens-des-marches:feature:brumelin-vision-brumeuse',
      'name': 'Vision brumeuse',
      'text': {'fr': 'Vous voyez dans la brume.'},
      'effects': [
        {'op': 'grant_sense', 'sense': 'darkvision', 'range': 60},
      ],
      'type': 'feature',
      'data': {'source': 'gardiens-des-marches:species:brumelin', 'level': 1},
    });
    expect((entities[2]['effects']! as List).single, {
      'op': 'choice',
      'id': 'choix-1',
      'count': 1,
      'options': [
        [
          {
            'op': 'grant_spell',
            'spell': '${firstSpell.id}',
            'when': {'level': 3},
          },
        ],
        <Object?>[],
      ],
      'labels': ['Brume grise', 'Option 2'],
      'title': 'Lignage',
    });
    // Les traits vivent dans leur espèce, pas dans la liste du pack.
    expect(find.text('Lignage brumeux'), findsNothing);
    expect(find.text('Prêt à publier'), findsOneWidget);
  });

  _test('Variante de l’Elfe : traits du SRD gardés, un retiré', (tester) async {
    await _open(tester);
    await _newPack(tester);
    await _tap(tester, find.text('Dériver d’une entité du SRD'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Rechercher dans le SRD'),
      'elfe',
    );
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Elfe'));
    expect(find.text('Trait du SRD'), findsNWidgets(5));
    await tester.enterText(
      find.widgetWithText(TextField, 'Nom *'),
      'Elfe des brumes',
    );
    await _tap(tester, find.byTooltip('Retirer le trait').last);
    await _tap(tester, find.text('Enregistrer'));

    final elf = (await _draft(tester)).entities.single;
    expect(elf['extends_id'], 'srd:species:elf');
    expect((elf['data']! as Map)['traits'], [
      'srd:feature:elf-fey-ancestry',
      'srd:feature:elf-elven-lineage',
      'srd:feature:elf-keen-senses',
      'srd:feature:elf-trance',
    ]);
    expect(find.text('Prêt à publier'), findsOneWidget);
    expect(
      (_content.entity('srd:species:elf')!.data as SpeciesData).traits,
      hasLength(5),
    );
  });

  Future<void> addFeature(WidgetTester tester, int level, String name) async {
    await _tap(tester, find.text('Ajouter une aptitude au niveau $level'));
    await tester.enterText(find.widgetWithText(TextField, 'Nom *'), name);
    await tester.enterText(
      find.widgetWithText(TextField, 'Texte (ce que le joueur lira)'),
      '$name : texte.',
    );
    await _tap(tester, find.text('Enregistrer l’aptitude'));
  }

  _test('[H02] Sous-classe du Guerrier : aptitudes aux niveaux du parent', (
    tester,
  ) async {
    await _open(tester);
    await _newPack(tester);
    await _tap(tester, find.widgetWithText(ActionChip, 'Sous-classe'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Nom *'),
      'Gardien du rempart',
    );
    await _tap(tester, find.text('Classe parente *'));
    await _tap(tester, find.text('Guerrier').last);
    expect(
      find.text(
        'Niveaux de sous-classe de la classe Guerrier : 3, 7, 10, 15, 18',
      ),
      findsOneWidget,
    );
    await addFeature(tester, 3, 'Rempart vivant');
    await addFeature(tester, 7, 'Pas de la sentinelle');
    expect(find.text('Rempart vivant'), findsOneWidget);

    // Sous le Magicien (3, 6, 10, 14), l'aptitude du niveau 7 est mal
    // placée : elle se déplace au niveau suivant qu'il réserve.
    await _tap(tester, find.text('Classe parente *'));
    await _tap(tester, find.text('Magicien').last);
    expect(
      find.text(
        'La classe Magicien n’accorde pas d’aptitude de sous-classe au '
        'niveau 7.',
      ),
      findsOneWidget,
    );
    await _tap(tester, find.text('Déplacer au niveau 10'));
    expect(find.textContaining('n’accorde pas'), findsNothing);
    await _tap(tester, find.text('Classe parente *'));
    await _tap(tester, find.text('Guerrier').last);
    await _tap(tester, find.text('Enregistrer'));

    final entities = (await _draft(tester)).entities;
    const id = 'gardiens-des-marches:subclass:gardien-du-rempart';
    expect(entities.map((e) => e['id']), [
      id,
      'gardiens-des-marches:feature:gardien-du-rempart-rempart-vivant',
      'gardiens-des-marches:feature:gardien-du-rempart-pas-de-la-sentinelle',
    ]);
    expect(entities[0]['data'], {
      'parent_class': 'srd:class:fighter',
      'features': [entities[1]['id'], entities[2]['id']],
    });
    expect(entities[1]['data'], {'source': id, 'level': 3});
    expect(entities[2]['data'], {'source': id, 'level': 10});
    // EF-HB-11 : incomplète, elle s'enregistre ; la publication attend.
    expect(
      find.text(
        'progression incomplète : aucune aptitude aux niveaux 7, 15, 18',
      ),
      findsOneWidget,
    );
  });

  _test('Classe : progression 1 à 20, emplacements repris du Magicien', (
    tester,
  ) async {
    await _open(tester);
    await _newPack(tester);
    await _tap(tester, find.widgetWithText(ActionChip, 'Classe'));
    await tester.enterText(find.widgetWithText(TextField, 'Nom *'), 'Veilleur');
    await _tap(tester, find.text('Dé de vie *'));
    await _tap(tester, find.text('d10').last);
    await _tap(tester, find.widgetWithText(FilterChip, '7'));
    await _tap(tester, find.text('Caractéristique d’incantation'));
    await _tap(tester, find.text('Sagesse').last);
    await _tap(
      tester,
      find.text('Reprendre les emplacements et sorts connus de…'),
    );
    await _tap(tester, find.text('Magicien').last);
    expect(find.text('Emplacements de niveau 9'), findsOneWidget);
    expect(find.text('Niveau 5 · bonus de maîtrise +3'), findsOneWidget);
    await addFeature(tester, 1, 'Œil du guet');
    await _tap(tester, find.text('Enregistrer'));

    final entities = (await _draft(tester)).entities;
    const id = 'gardiens-des-marches:class:veilleur';
    expect(entities.map((e) => e['id']), [
      id,
      'gardiens-des-marches:feature:veilleur-oeil-du-guet',
    ]);
    final data = entities[0]['data']! as Map<String, Object?>;
    expect(data['hit_die'], 10);
    expect(data['subclass_feature_levels'], [3, 7]);
    expect(data['spellcasting_ability'], 'srd:ability:wisdom');
    expect(data['prepared_change'], 'long_rest_all');
    expect(data['multiclass'], {'caster_divisor': 1});
    final levels = data['levels']! as List<Object?>;
    expect(levels, hasLength(20));
    expect(levels[0], {
      'level': 1,
      'proficiency_bonus': 2,
      'features': ['gardiens-des-marches:feature:veilleur-oeil-du-guet'],
      'columns': {'cantrips': 3, 'prepared_spells': 4, 'slot_1': 2},
    });
    expect(levels[4], {
      'level': 5,
      'proficiency_bonus': 3,
      'features': <Object?>[],
      'columns': {
        'cantrips': 4,
        'prepared_spells': 9,
        'slot_1': 4,
        'slot_2': 3,
        'slot_3': 2,
      },
    });
    expect(entities[1]['data'], {'source': id, 'level': 1});
  });

  _test('Monstre : CA portée, FP, PV moyens et paliers d’Étude', (
    tester,
  ) async {
    await _open(tester);
    await _newPack(tester);
    await _tap(tester, find.widgetWithText(ActionChip, 'Monstre'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Nom *'),
      'Loup des brumes',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Alignement *'),
      'Non aligné',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Dextérité'),
      '15',
    );
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Armure portée'));
    await _tap(tester, find.text('Armure de cuir clouté').last);
    await _tap(tester, find.widgetWithText(SwitchListTile, 'Bouclier'));
    expect(
      find.text('CA 16 (Armure de cuir clouté, Bouclier)'),
      findsOneWidget,
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Dés de vie (ex. 10d8 + 20) *'),
      '2d8 + 2',
    );
    await tester.pumpAndSettle();
    expect(find.text('PV moyens : 11'), findsOneWidget);
    await _tap(tester, find.widgetWithText(FilterChip, 'Perception'));
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Langues *'),
      'aucune',
    );
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Facteur de puissance *'));
    await _tap(tester, find.text('1/4').last);
    expect(find.text('50 PX · bonus de maîtrise +2'), findsOneWidget);

    // Une attaque : ses dégâts moyens se calculent.
    await _tap(tester, find.text('Ajouter un trait ou une action'));
    await tester.enterText(find.widgetWithText(TextField, 'Nom *'), 'Morsure');
    await tester.enterText(
      find.widgetWithText(TextField, 'Texte (ce que le joueur lira)'),
      'Corps à corps : +4, allonge 1,50 m.',
    );
    await _tap(tester, find.text('Jet d’attaque'));
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Bonus d’attaque'),
      '4',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Dégâts (ex. 2d6 + 3)'),
      '1d6 + 2',
    );
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Type de dégâts *'));
    await _tap(tester, find.text('Perforants').last);
    expect(find.text('Dégâts moyens : 5'), findsOneWidget);
    await _tap(tester, find.text('Enregistrer'));
    expect(find.text('Morsure'), findsOneWidget);

    // Un palier d'Étude.
    await _tap(tester, find.text('Ajouter un palier'));
    await tester.enterText(
      find.widgetWithText(TextField, 'DD du palier'),
      '10',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Ce qu’il révèle'),
      'Il chasse en meute dans la brume.',
    );
    await _tap(tester, find.widgetWithText(FilledButton, 'Ajouter un palier'));
    expect(find.text('DD 10'), findsOneWidget);
    await _tap(tester, find.text('Enregistrer'));

    final monster = (await _draft(tester)).entities.single;
    expect(monster['id'], 'gardiens-des-marches:monster:loup-des-brumes');
    final data = monster['data']! as Map<String, Object?>;
    expect(data['ac'], 16);
    expect(data['ac_note'], 'Armure de cuir clouté, Bouclier');
    expect(data['hp'], 11);
    expect(data['initiative'], 2);
    expect(data['xp'], 50);
    expect(data['proficiency_bonus'], 2);
    expect(data['skills'], {'srd:skill:perception': 2});
    expect(data['passive_perception'], 12);
    expect((data['saving_throws']! as Map)['dex'], 2);
    expect(data['study_reveals'], [
      {'dc': 10, 'text': 'Il chasse en meute dans la brume.'},
    ]);
    expect((data['actions']! as List).single, {
      'kind': 'action',
      'name': 'Morsure',
      'text': 'Corps à corps : +4, allonge 1,50 m.',
      'attack': {
        'kind': 'melee',
        'bonus': 4,
        'reach': 5,
        'damage': [
          {'dice': '1d6 + 2', 'type': 'srd:damage-type:piercing', 'average': 5},
        ],
      },
    });
    expect(find.text('Prêt à publier'), findsOneWidget);
  });

  /// Une ligne du bac à sable : ses textes.
  List<String> sandboxRow(WidgetTester tester, String label) => [
    for (final t in tester.widgetList<Text>(
      find.descendant(
        of: find.ancestor(
          of: find.text(label),
          matching: find.byType(ListTile),
        ),
        matching: find.byType(Text),
      ),
    ))
      t.data ?? '',
  ];

  _test('[H04] Gardien du rempart : +1 CA bouclier porté, sans fiche réelle', (
    tester,
  ) async {
    await _open(tester);
    await _newPack(tester);
    await _tap(tester, find.widgetWithText(ActionChip, 'Sous-classe'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Nom *'),
      'Gardien du rempart',
    );
    await _tap(tester, find.text('Classe parente *'));
    await _tap(tester, find.text('Guerrier').last);
    await _tap(tester, find.text('Ajouter une aptitude au niveau 3'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Nom *'),
      'Rempart vivant',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Texte (ce que le joueur lira)'),
      '+1 CA tant que vous portez un bouclier.',
    );
    await _tap(tester, find.text('Ajouter un effet'));
    await _tap(tester, find.text('Modifier la Classe d’armure'));
    await tester.enterText(find.widgetWithText(TextFormField, 'Valeur'), '1');
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Condition'));
    await _tap(tester, find.text('tant que vous portez un bouclier').last);
    await _tap(tester, find.text('Enregistrer l’effet'));
    await _tap(tester, find.text('Enregistrer l’aptitude'));

    // Testée sans être enregistrée.
    await _tap(tester, find.byTooltip('Tester sur un personnage'));
    expect(find.text('Tester « Gardien du rempart »'), findsOneWidget);
    expect(
      find.text('Bac à sable : aucune fiche réelle n’est modifiée'),
      findsOneWidget,
    );
    expect(find.text('Guerrier prétiré (Humain, Soldat)'), findsOneWidget);
    expect(find.text('5'), findsWidgets);
    // Cotte de mailles 16 + bouclier 2, puis Rempart vivant.
    expect(sandboxRow(tester, 'Classe d’armure'), [
      'Classe d’armure',
      'Source : Rempart vivant',
      '18',
      '19',
    ]);
    expect(
      find.text('Toutes les valeurs se calculent sans erreur au niveau 5.'),
      findsOneWidget,
    );
    expect(
      find.text(
        '· progression incomplète : aucune aptitude aux niveaux 7, 10, 15, 18',
      ),
      findsOneWidget,
    );

    await _tap(tester, find.text('Porte un bouclier'));
    expect(sandboxRow(tester, 'Classe d’armure'), [
      'Classe d’armure',
      '',
      '16',
      '16',
    ]);
    await _tap(tester, find.text('Retour à l’éditeur'));
    expect(find.text('Rempart vivant'), findsOneWidget);
    expect((await _draft(tester)).entities, isEmpty);
  });

  _test('[H04] monstre : aperçu de son profil', (tester) async {
    await _open(tester);
    await _newPack(tester);
    final draft = await _draft(tester);
    final wolf = _content.entity('srd:monster:wolf')!.toJson();
    await tester.runAsync(
      () => HomebrewStore(_db).save(
        draft.id,
        manifest: draft.manifest,
        entities: [
          {
            ...wolf,
            'id': 'gardiens-des-marches:monster:loup-des-brumes',
            'name': 'Loup des brumes',
          },
        ],
      ),
    );
    await _settle(tester);
    await _tap(tester, find.text('Loup des brumes'));
    await _tap(tester, find.byTooltip('Tester sur un personnage'));
    expect(find.text('Tester « Loup des brumes »'), findsOneWidget);
    expect(find.textContaining('Morsure', findRichText: true), findsWidgets);
  });
}
