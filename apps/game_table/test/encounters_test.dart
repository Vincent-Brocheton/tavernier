// Spec tables : « Onglet des rencontres », « Créer, dupliquer et ranger une
// rencontre », « Budget de la prochaine séance » (US-19, EF-REN-01, 03, 05,
// [F5]).
import 'dart:convert';
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/account_providers.dart';
import 'package:game_table/creation/creation_providers.dart';
import 'package:game_table/encounters/combat_page.dart';
import 'package:game_table/encounters/combat_view.dart';
import 'package:game_table/encounters/encounter_page.dart';
import 'package:game_table/encounters/foe_picker.dart';
import 'package:game_table/l10n/app_localizations.dart';
import 'package:game_table/sheet/simple_roll.dart';
import 'package:game_table/tables/table_page.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

import 'account/fakes.dart';

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

const _camille = '00000000-0000-0000-0000-00000000000a';
const _hugo = '00000000-0000-0000-0000-00000000000b';

User _user(String id) => User(
  id: id,
  appMetadata: const {},
  userMetadata: const {},
  aud: 'authenticated',
  createdAt: '2026-11-11T10:00:00Z',
);

late TavernierDatabase _db;
late String _table;
late String _s12;
late String _relais;

/// Brumeval : Aldric et Mira (niveau 5) ; séance 11 close, séance 12 avec
/// les deux prévus et « Le relais du Sel » (2 vétérans, prête) ;
/// « Embuscade » (1 bandit) en réserve. Ouvre la page de la table vue par
/// [me], sur l'onglet Rencontres pour le MJ.
Future<void> _open(
  WidgetTester tester, {
  String me = _camille,
  Size size = const Size(390, 2000),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  _db = TavernierDatabase(NativeDatabase.memory());
  addTearDown(_db.close);
  await tester.runAsync(() async {
    _table = await TableStore(_db).create(
      gmUserId: _camille,
      settings: const TableSettings(name: 'Brumeval'),
      packs: const [],
    );
    await _db.customStatement(
      'INSERT INTO table_member (id, table_id, user_id, role, joined_at) '
      "VALUES ('m1', ?, ?, 'player', '2026-11-11T10:00:00Z')",
      [_table, _hugo],
    );
    final characters = CharacterStore(_db);
    for (final (id, name) in [('aldric', 'Aldric'), ('mira', 'Mira')]) {
      await characters.publishSummary(
        CharacterSummary(
          id: id,
          tableId: _table,
          ownerUserId: _hugo,
          name: name,
          speciesId: 'srd:species:human',
          classes: const [(classId: 'srd:class:fighter', level: 5)],
          health: Health.unhurt,
        ),
      );
    }
    final sessions = SessionStore(_db);
    await sessions.create(
      tableId: _table,
      title: 'Le gué des Loups',
      date: DateTime(2026, 10, 23),
      status: SessionStatus.closed,
    );
    _s12 = await sessions.create(
      tableId: _table,
      title: 'Le relais du Sel',
      date: DateTime(2026, 10, 30),
      present: ['aldric', 'mira'],
    );
    final encounters = EncounterStore(_db);
    _relais = await encounters.create(
      tableId: _table,
      title: 'Le relais du Sel',
      sessionId: _s12,
    );
    await encounters.update(_relais, status: EncounterStatus.ready);
    await encounters.addGroup(
      _relais,
      kind: 'monster',
      refId: 'srd:monster:veteran',
      quantity: 2,
    );
    final ambush = await encounters.create(tableId: _table, title: 'Embuscade');
    await encounters.addGroup(
      ambush,
      kind: 'monster',
      refId: 'srd:monster:bandit',
    );
  });
  final router = GoRouter(
    initialLocation: '/tables/$_table',
    routes: [
      GoRoute(
        path: '/tables/:id',
        builder: (_, state) => TablePage(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/tables/:id/rencontres/:encounter/combat',
        builder: (_, state) => CombatPage(
          tableId: state.pathParameters['id']!,
          id: state.pathParameters['encounter']!,
        ),
      ),
      GoRoute(
        path: '/tables/:id/rencontres/:encounter',
        builder: (_, state) => EncounterPage(
          tableId: state.pathParameters['id']!,
          id: state.pathParameters['encounter']!,
        ),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        accountGatewayProvider.overrideWithValue(FakeGateway()),
        onlineProvider.overrideWith((ref) => Stream.value(true)),
        currentUserProvider.overrideWith((ref) => Stream.value(_user(me))),
        databaseProvider.overrideWithValue(_db),
        contentProvider.overrideWith((ref) => _content),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        theme: AppTheme.dark,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await tester.pumpAndSettle();
  if (me == _camille) await _tap(tester, find.text('Rencontres'));
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
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

/// Rencontres de la table : (titre, séance, état).
Future<List<(String, String?, String)>> _encounters(WidgetTester tester) async {
  final rows = await tester.runAsync(
    () => _db
        .customSelect(
          'SELECT title, session_id, status FROM encounter '
          'WHERE table_id = ? ORDER BY title',
          variables: [Variable.withString(_table)],
        )
        .get(),
  );
  return [
    for (final r in rows!)
      (
        r.read<String>('title'),
        r.readNullable<String>('session_id'),
        r.read<String>('status'),
      ),
  ];
}

/// Démonte l'app avant la fin : drift ferme ses requêtes observées par un
/// minuteur, qui doit partir avant la vérification finale.
void _test(String description, Future<void> Function(WidgetTester) body) =>
    testWidgets(description, (tester) async {
      await body(tester);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

void main() {
  _test('liste : séance, réserve, adversaires, PX, difficulté, état [F5]', (
    tester,
  ) async {
    await _open(tester);
    expect(find.textContaining('SÉANCE 2', findRichText: true), findsOneWidget);
    expect(
      find.textContaining('SANS SÉANCE', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('Le relais du Sel'), findsOneWidget);
    expect(find.text('Vétéran ×2 · 1 400 PX · Faible'), findsOneWidget);
    expect(find.text('Prête'), findsOneWidget);
    expect(find.text('Embuscade'), findsOneWidget);
    expect(find.text('Bandit · 25 PX · sous le budget faible'), findsOneWidget);
    expect(find.text('Brouillon'), findsOneWidget);
    // La séance close n'a pas de rencontre : pas de section.
    expect(find.textContaining('SÉANCE 1', findRichText: true), findsNothing);
  });

  _test('filtres et recherche', (tester) async {
    await _open(tester);
    expect(find.text('À jouer · 2'), findsOneWidget);
    await _tap(tester, find.text('Terminées'));
    expect(find.text('Aucune rencontre'), findsOneWidget);
    await _tap(tester, find.text('Toutes'));
    await tester.enterText(find.byType(TextField), 'veteran');
    await tester.pumpAndSettle();
    expect(find.text('Le relais du Sel'), findsOneWidget);
    expect(find.text('Embuscade'), findsNothing);
  });

  _test('joueur : pas d\'onglet Rencontres', (tester) async {
    await _open(tester, me: _hugo);
    expect(find.text('Rencontres'), findsNothing);
  });

  _test('nouvelle rencontre : titre, séance, page ouverte', (tester) async {
    await _open(tester);
    await _tap(tester, find.text('Nouvelle rencontre'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Titre'),
      'Les chiens de Varga',
    );
    await tester.pump();
    await _tap(tester, find.text('Créer la rencontre'));
    await _settle(tester);
    expect(
      (await _encounters(tester))
          .firstWhere((e) => e.$1 == 'Les chiens de Varga'),
      ('Les chiens de Varga', _s12, 'draft'),
    );
    expect(find.text('Brumeval · Séance 2'), findsOneWidget);
    expect(find.text('Aucun adversaire'), findsOneWidget);
    expect(find.text('sous le budget faible'), findsOneWidget);
  });

  _test('dupliquer, puis ranger la réserve dans une séance', (tester) async {
    await _open(tester);
    await _tap(tester, find.text('Dupliquer').first);
    await _settle(tester);
    expect(find.text('Le relais du Sel (copie)'), findsOneWidget);

    await _tap(tester, find.text('Ranger dans une séance'));
    await _tap(tester, find.text('Séance 2 · Le relais du Sel'));
    await _settle(tester);
    expect(
      find.textContaining('SANS SÉANCE', findRichText: true),
      findsNothing,
    );
    expect(
      (await _encounters(tester)).firstWhere((e) => e.$1 == 'Embuscade').$2,
      _s12,
    );
  });

  _test('grand écran : budget de la prochaine séance', (tester) async {
    await _open(tester, size: const Size(1440, 1200));
    expect(find.text('Budget de difficulté'), findsOneWidget);
    expect(find.text('1 000 PX'), findsOneWidget);
    expect(find.text('1 500 PX'), findsOneWidget);
    expect(find.text('2 200 PX'), findsOneWidget);
    expect(
      find.text('2 personnages de niveau 5, selon les présences prévues.'),
      findsOneWidget,
    );
  });

  test('FP : « 1/8 » vaut 0,125, et « 2 » plus que « 1/2 »', () {
    expect(crValue('1/8'), 0.125);
    expect(crValue('2'), greaterThan(crValue('1/2')));
    expect(crValue('30'), 30);
  });

  _test('préparation : jauge, présents, numérotation [C1]', (tester) async {
    await _open(tester);
    await _tap(tester, find.text('Ouvrir').first);
    expect(find.text('Difficulté'), findsOneWidget);
    expect(find.text('1 400 PX'), findsWidgets);
    expect(find.text('Faible'), findsWidgets);
    expect(find.text('2 PJ de niveau 5'), findsOneWidget);
    expect(find.text('Aldric · Guerrier 5'), findsOneWidget);
    expect(find.text('FP 3 · numérotés Vétéran 1 à 2'), findsOneWidget);

    await _tap(tester, find.byTooltip('Un de plus'));
    await _settle(tester);
    expect(find.text('FP 3 · numérotés Vétéran 1 à 3'), findsOneWidget);
    expect(find.text('Modérée'), findsWidgets);
    expect(find.text('2 100 PX'), findsWidgets);

    for (var i = 0; i < 3; i++) {
      await _tap(tester, find.byTooltip('Un de moins'));
      await _settle(tester);
    }
    expect(find.text('Aucun adversaire'), findsOneWidget);
  });

  _test('préparation : mode de PV, « Prête à jouer »', (tester) async {
    await _open(tester);
    await _tap(tester, find.text('Ouvrir').first);
    await _tap(tester, find.text('Jet au lancement'));
    await _tap(tester, find.text('Prête à jouer'));
    await _settle(tester);
    final row = await tester.runAsync(
      () => _db
          .customSelect(
            'SELECT status, hp_mode FROM encounter WHERE id = ?',
            variables: [Variable.withString(_relais)],
          )
          .getSingle(),
    );
    expect(
      (row!.read<String>('status'), row.read<String>('hp_mode')),
      ('draft', 'roll'),
    );

    // « Dupliquer » ouvre la copie.
    await _tap(tester, find.text('Dupliquer'));
    await _settle(tester);
    expect(find.text('Le relais du Sel (copie)'), findsOneWidget);
  });

  _test('ajout : monstre cherché, puis PNJ [C1]', (tester) async {
    await _open(tester);
    await tester.runAsync(
      () => NpcStore(_db).create(
        tableId: _table,
        name: 'Varga la Balafrée',
        monsterId: 'srd:monster:bandit-captain',
      ),
    );
    await _tap(tester, find.text('Ouvrir').first);
    await _tap(tester, find.text('Ajouter un adversaire'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Bestiaire, PNJ'),
      'loup SANGUINAIRE',
    );
    await tester.pumpAndSettle();
    expect(find.text('Bête · FP 1 · 200 PX'), findsOneWidget);
    await _tap(tester, find.byTooltip('Ajouter Loup sanguinaire'));
    await _settle(tester);

    await tester.enterText(
      find.widgetWithText(TextField, 'Bestiaire, PNJ'),
      '',
    );
    await _tap(tester, find.text('PNJ').last);
    expect(find.text('Chef de bande · FP 2 · 450 PX'), findsOneWidget);
    await _tap(tester, find.byTooltip('Ajouter Varga la Balafrée'));
    await _settle(tester);

    Navigator.of(tester.element(find.byType(FoePicker))).pop();
    await tester.pumpAndSettle();
    expect(find.text('Loup sanguinaire'), findsOneWidget);
    expect(find.text('Varga la Balafrée'), findsOneWidget);
    // 1 400 + 200 + 450.
    expect(find.text('2 050 PX'), findsWidgets);
  });

  _test('préparation, grand écran : ajout en colonne, sans feuille', (
    tester,
  ) async {
    await _open(tester, size: const Size(1440, 1200));
    await _tap(tester, find.text('Ouvrir').first);
    expect(find.byType(FoePicker), findsOneWidget);
    expect(find.text('Ajouter un adversaire'), findsNothing);
    expect(find.text('Bestiaire, PNJ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  _test('lancer : en cours, jets des monstres, saisie des PJ, round 1', (
    tester,
  ) async {
    await _open(tester);
    await _tap(tester, find.text('Ouvrir').first);
    await _tap(tester, find.text('Lancer la rencontre'));
    await _settle(tester);
    expect(find.text('Le relais du Sel · lancement'), findsOneWidget);
    expect(find.text('Initiative'), findsOneWidget);
    final status = await tester.runAsync(
      () => _db
          .customSelect(
            'SELECT status FROM encounter WHERE id = ?',
            variables: [Variable.withString(_relais)],
          )
          .getSingle(),
    );
    expect(status!.read<String>('status'), 'running');
    // Les vétérans ont leur jet automatique ; les PJ attendent la saisie.
    expect(find.text('Vétéran 1–2'), findsWidgets);
    expect(find.text('Jet automatique'), findsOneWidget);
    bool canStart() =>
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Commencer le round 1'),
            )
            .onPressed !=
        null;
    expect(canStart(), isFalse);

    final dice = find.widgetWithText(TextField, 'd20');
    expect(dice, findsNWidgets(2));
    await tester.enterText(dice.first, '15');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await _settle(tester);
    await tester.enterText(find.widgetWithText(TextField, 'd20'), '8');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await _settle(tester);
    expect(find.text('Saisi par le MJ'), findsNWidgets(2));
    expect(find.text('Tous les jets sont saisis'), findsOneWidget);

    await _tap(tester, find.text('Commencer le round 1'));
    await _settle(tester);
    // Écran de combat : le round, et l'unité active « En cours ».
    expect(find.text('Round 1'), findsWidgets);
    // Le premier peut être le groupe des vétérans : un badge par membre.
    expect(find.text('En cours'), findsWidgets);
  });

  _test('initiative : égalités et qui décide, surprise d\'un monstre [C3]', (
    tester,
  ) async {
    await _open(tester);
    await tester.runAsync(() async {
      await _db.customStatement(
        'INSERT INTO profile (id, pseudonym, locale, settings) VALUES '
        "(?, 'Hugo', 'fr', '{}'), ('ines', 'Inès', 'fr', '{}')",
        [_hugo],
      );
      await _db.customStatement(
        'INSERT INTO table_member (id, table_id, user_id, role, joined_at) '
        "VALUES ('m2', ?, 'ines', 'player', '2026-11-11T10:00:00Z')",
        [_table],
      );
      Map<String, Object?> added(
        String id,
        String label,
        String kind, {
        String? owner,
        String? group,
        int bonus = 0,
      }) => {
        'id': id,
        'kind': kind,
        'label': label,
        'owner': ?owner,
        'group_id': ?group,
        'bonus': bonus,
      };
      await CombatStore(_db).launch(_relais, authorUserId: _camille, [
        (
          CombatEventType.combatantAdded,
          added('brannoc', 'Brannoc', 'pc', owner: _hugo, bonus: 2),
        ),
        (
          CombatEventType.combatantAdded,
          added('mira', 'Mira Solen', 'pc', owner: 'ines'),
        ),
        (
          CombatEventType.combatantAdded,
          added('v1', 'Vétéran 1', 'monster', group: 'vets', bonus: 3),
        ),
        (
          CombatEventType.combatantAdded,
          added('v2', 'Vétéran 2', 'monster', group: 'vets', bonus: 3),
        ),
        (
          CombatEventType.combatantAdded,
          added('ogre', 'Ogre', 'monster', bonus: -1),
        ),
        (
          CombatEventType.initiativeRolled,
          {
            'unit': 'brannoc',
            'dice': [6],
            'bonus': 2,
          },
        ),
        (
          CombatEventType.initiativeRolled,
          {
            'unit': 'mira',
            'dice': [8],
            'bonus': 0,
          },
        ),
        (
          CombatEventType.initiativeRolled,
          {
            'unit': 'vets',
            'dice': [12],
            'bonus': 3,
          },
        ),
        (
          CombatEventType.initiativeRolled,
          {
            'unit': 'ogre',
            'dice': [16],
            'bonus': -1,
          },
        ),
      ]);
    });
    await _tap(tester, find.text('Ouvrir').first);
    await _tap(tester, find.text('Reprendre le combat'));
    await _settle(tester);
    expect(find.text('Égalité · le MJ décide'), findsNWidgets(2));
    expect(find.text('Égalité · Hugo et Inès décident'), findsNWidgets(2));
    expect(
      find.text(
        'Égalité à 15 : vous choisissez l’ordre. Glissez pour le changer.',
      ),
      findsOneWidget,
    );

    await _tap(tester, find.widgetWithText(FilterChip, 'Ogre'));
    await _settle(tester);
    expect(find.text('Désavantage'), findsOneWidget);
    // L'ogre, monstre seul, n'a que « surpris » en sous-titre.
    expect(find.text('surpris'), findsOneWidget);
  });

  /// Bouton « Détail » de la carte de [label].
  Finder detailOf(String label) => find.descendant(
    of: find.ancestor(of: find.text(label), matching: find.byType(Card)).first,
    matching: find.byTooltip('Détail'),
  );

  /// Combat lancé et commencé : le dragon (22, souffle déjà utilisé),
  /// Aldric (19), l'ogre (9).
  Future<void> openCombat(WidgetTester tester) async {
    await _open(tester);
    await tester.runAsync(() async {
      await CombatStore(_db).launch(_relais, authorUserId: _camille, [
        (
          CombatEventType.combatantAdded,
          {
            'id': 'dragon',
            'kind': 'monster',
            'ref_id': 'srd:monster:adult-black-dragon',
            'label': 'Dragon noir adulte',
            'bonus': 6,
            'ac': 19,
            'hp': 195,
            'hp_max': 195,
            'saves': {'str': 6, 'dex': 7},
            'counters': {
              'legendary_actions': 3,
              'legendary_resistance': 3,
              'recharge:Souffle d’acide': 1,
            },
          },
        ),
        (
          CombatEventType.combatantAdded,
          {
            'id': 'aldric',
            'kind': 'pc',
            'ref_id': 'aldric',
            'label': 'Aldric',
            'bonus': 4,
            'ac': 18,
            'hp': 41,
            'hp_max': 49,
          },
        ),
        (
          CombatEventType.combatantAdded,
          {
            'id': 'ogre',
            'kind': 'monster',
            'ref_id': 'srd:monster:ogre',
            'label': 'Ogre',
            'bonus': -1,
            'hp': 59,
            'hp_max': 59,
          },
        ),
        (
          CombatEventType.initiativeRolled,
          {
            'unit': 'dragon',
            'dice': [16],
            'bonus': 6,
          },
        ),
        (
          CombatEventType.initiativeRolled,
          {
            'unit': 'aldric',
            'dice': [15],
            'bonus': 4,
          },
        ),
        (
          CombatEventType.initiativeRolled,
          {
            'unit': 'ogre',
            'dice': [10],
            'bonus': -1,
          },
        ),
        (
          CombatEventType.counterUsed,
          {'combatant': 'dragon', 'counter': 'recharge:Souffle d’acide'},
        ),
        (CombatEventType.combatStarted, const <String, Object?>{}),
      ]);
    });
    await _tap(tester, find.text('Ouvrir').first);
    await _tap(tester, find.text('Reprendre le combat'));
    await _settle(tester);
  }

  _test('combat : round, en cours, tour suivant, annuler [1a]', (tester) async {
    await openCombat(tester);
    expect(find.text('Round 1'), findsWidgets);
    expect(find.text('3 combattants'), findsOneWidget);
    expect(find.text('Dragon · FP 14'), findsOneWidget);
    expect(find.text('PJ · Guerrier 5'), findsOneWidget);
    expect(find.text('41 / 49'), findsOneWidget);
    Finder activeCard() =>
        find.ancestor(of: find.text('En cours'), matching: find.byType(Card));
    expect(
      find.descendant(
        of: activeCard(),
        matching: find.text('Dragon noir adulte'),
      ),
      findsOneWidget,
    );

    await _tap(tester, find.text('Tour suivant'));
    await _settle(tester);
    expect(
      find.descendant(of: activeCard(), matching: find.text('Aldric')),
      findsOneWidget,
    );

    await _tap(tester, find.byTooltip('Annuler'));
    await _settle(tester);
    expect(
      find.descendant(
        of: activeCard(),
        matching: find.text('Dragon noir adulte'),
      ),
      findsOneWidget,
    );
  });

  _test('recharge : rappel au début du tour, « Rechargé » [C8]', (
    tester,
  ) async {
    await openCombat(tester);
    expect(
      find.text(
        'Début du tour · Dragon noir adulte : lancez 1d6 pour Souffle '
        'd’acide (recharge 5–6).',
      ),
      findsOneWidget,
    );
    await _tap(tester, find.text('Rechargé'));
    await _settle(tester);
    expect(find.textContaining('lancez 1d6'), findsNothing);
  });

  _test('détail : actions légendaires, retrait [C8]', (tester) async {
    await openCombat(tester);
    await _tap(tester, detailOf('Dragon noir adulte'));
    expect(find.text('Actions légendaires'), findsWidgets);
    expect(find.text('3 / 3'), findsWidgets);
    expect(find.text('Disponible'), findsOneWidget);
    await _tap(
      tester,
      find.bySemanticsLabel('Utiliser : Actions légendaires').first,
    );
    await _settle(tester);
    expect(find.text('2 / 3'), findsOneWidget);
    Navigator.of(tester.element(find.text('2 / 3'))).pop();
    await tester.pumpAndSettle();

    await _tap(tester, detailOf('Ogre'));
    await _tap(tester, find.text('Retirer du combat'));
    await _settle(tester);
    expect(find.text('Ogre'), findsNothing);
    expect(find.text('2 combattants'), findsOneWidget);
  });

  _test('renfort numéroté, puis fin de la rencontre', (tester) async {
    await openCombat(tester);
    await _tap(tester, find.byType(PopupMenuButton<String>));
    await _tap(tester, find.text('Ajouter un combattant'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Bestiaire, PNJ'),
      'ogre',
    );
    await tester.pumpAndSettle();
    await _tap(tester, find.byTooltip('Ajouter Ogre'));
    await _settle(tester);
    expect(find.text('Ogre 2'), findsOneWidget);
    expect(find.textContaining('Ogre 2 entre dans le combat'), findsOneWidget);

    await _tap(tester, find.byType(PopupMenuButton<String>));
    await _tap(tester, find.text('Terminer la rencontre'));
    // Le résumé [C11] tient lieu de confirmation.
    await _settle(tester);
    await _tap(tester, find.text('Clore et ranger dans la séance'));
    await _settle(tester);
    final status = await tester.runAsync(
      () => _db
          .customSelect(
            'SELECT status FROM encounter WHERE id = ?',
            variables: [Variable.withString(_relais)],
          )
          .getSingle(),
    );
    expect(status!.read<String>('status'), 'finished');
  });

  Future<void> keys(WidgetTester tester, String digits) async {
    for (final d in digits.split('')) {
      await _tap(tester, find.widgetWithText(OutlinedButton, d));
    }
  }

  _test(
    'pavé : 12 dégâts tranchants sur Aldric, aperçu puis application [1b]',
    (tester) async {
      await openCombat(tester);
      await _tap(tester, find.text('Aldric'));
      expect(find.textContaining('Cible : Aldric'), findsOneWidget);
      await _tap(tester, find.byTooltip('Dégâts'));
      await keys(tester, '12');
      expect(find.text('41 → 29 / 49 PV'), findsOneWidget);
      await _tap(tester, find.text('Appliquer 12 dégâts tranchants'));
      await _settle(tester);
      expect(find.text('29 / 49'), findsOneWidget);
    },
  );

  _test('pavé : addition de dés, puis soins plafonnés', (tester) async {
    await openCombat(tester);
    await _tap(tester, find.text('Aldric'));
    await _tap(tester, find.byTooltip('Dégâts'));
    await keys(tester, '7');
    await _tap(tester, find.widgetWithText(OutlinedButton, '+'));
    await keys(tester, '5');
    expect(find.text('Appliquer 12 dégâts tranchants'), findsOneWidget);
    await _tap(tester, find.widgetWithText(OutlinedButton, 'Soins'));
    expect(find.text('41 → 49 / 49 PV'), findsOneWidget);
    await _tap(tester, find.text('Soigner de 12 PV'));
    await _settle(tester);
    expect(find.text('49 / 49'), findsOneWidget);
  });

  _test('PV temporaires : le plus haut, ou remplacés au choix', (tester) async {
    await openCombat(tester);
    await _tap(tester, find.text('Aldric'));
    await _tap(tester, find.byTooltip('PV temp.'));
    await keys(tester, '8');
    await _tap(tester, find.text('Donner 8 PV temporaires'));
    await _settle(tester);
    expect(find.text('+8 PV temp.'), findsOneWidget);
    await _tap(tester, find.byTooltip('PV temp.'));
    await keys(tester, '5');
    expect(find.text('PV temp. 8 → 8'), findsOneWidget);
    await _tap(tester, find.text('Remplacer les PV temporaires actuels'));
    expect(find.text('PV temp. 8 → 5'), findsOneWidget);
    await _tap(tester, find.text('Donner 5 PV temporaires'));
    await _settle(tester);
    expect(find.text('+5 PV temp.'), findsOneWidget);
  });

  _test('deux cibles, « Résistance ½ » : chacune perd 5', (tester) async {
    await openCombat(tester);
    await _tap(tester, find.text('Aldric'));
    await tester.longPress(find.text('Ogre'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Cibles : Aldric, Ogre'), findsOneWidget);
    await _tap(tester, find.byTooltip('Dégâts'));
    await keys(tester, '10');
    await _tap(tester, find.widgetWithText(ChoiceChip, 'Feu'));
    await _tap(tester, find.widgetWithText(OutlinedButton, 'Résistance ½'));
    await _tap(tester, find.text('Appliquer 10 dégâts feu'));
    await _settle(tester);
    expect(find.text('36 / 49'), findsOneWidget);
    expect(find.text('54 / 59'), findsOneWidget);
  });

  _test(
    '0 PV : Aldric Inconscient, jets contre la mort ; ogre hors de combat',
    (tester) async {
      await openCombat(tester);
      await _tap(tester, find.text('Aldric'));
      await tester.longPress(find.text('Ogre'));
      await tester.pumpAndSettle();
      await _tap(tester, find.byTooltip('Dégâts'));
      await keys(tester, '60');
      await _tap(tester, find.text('Appliquer 60 dégâts tranchants'));
      await _settle(tester);
      expect(find.text('Inconscient'), findsOneWidget);
      expect(find.text('Hors de combat'), findsOneWidget);
      expect(find.byType(DeathSavesRow), findsOneWidget);

      await _tap(tester, detailOf('Aldric'));
      await _tap(tester, find.text('Échec'));
      await _settle(tester);
      expect(
        tester
            .widget<DeathSavesRow>(find.byType(DeathSavesRow).last)
            .combatant
            .deathFailures,
        1,
      );
    },
  );

  Finder chip(String text) => find.text(text, findRichText: true);

  _test("état : Entravé jusqu'à une sauvegarde, fiche, retrait [C5] [K4]", (
    tester,
  ) async {
    await openCombat(tester);
    await _tap(tester, find.text('Ogre'));
    await _tap(tester, find.byTooltip('État'));
    expect(find.text('Cible : Ogre'), findsOneWidget);
    await _tap(tester, find.widgetWithText(OutlinedButton, 'Entravé'));
    expect(
      find.textContaining('Vitesse 0', findRichText: true),
      findsOneWidget,
    );
    await _tap(tester, find.text("Jusqu'à réussite d'une sauvegarde"));
    await tester.enterText(find.widgetWithText(TextField, 'DD'), '13');
    await _tap(tester, find.text('Ajouter Entravé'));
    await _settle(tester);
    expect(chip('Entravé · JS FOR DD 13'), findsOneWidget);

    await _tap(tester, chip('Entravé · JS FOR DD 13'));
    expect(
      find.text(
        "Ogre · jusqu'à réussite d'un JS de Force DD 13, refait à la fin de "
        'chacun de ses tours',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('Vitesse 0'), findsOneWidget);
    await _tap(tester, find.text("Retirer l'état"));
    await _settle(tester);
    expect(chip('Entravé · JS FOR DD 13'), findsNothing);
  });

  _test('état : Effrayé 2 rounds sur deux cibles', (tester) async {
    await openCombat(tester);
    await _tap(tester, find.text('Aldric'));
    await tester.longPress(find.text('Ogre'));
    await tester.pumpAndSettle();
    await _tap(tester, find.byTooltip('État'));
    expect(find.text('Cibles : Aldric, Ogre'), findsOneWidget);
    await _tap(tester, find.widgetWithText(OutlinedButton, 'Effrayé'));
    await _tap(tester, find.byTooltip('Un round de plus'));
    await _tap(tester, find.text('Ajouter Effrayé'));
    await _settle(tester);
    expect(chip('Effrayé · 2 rd'), findsNWidgets(2));
  });

  _test('état : Épuisement 2, puis un niveau retiré', (tester) async {
    await openCombat(tester);
    await _tap(tester, find.text('Aldric'));
    await _tap(tester, find.byTooltip('État'));
    await _tap(tester, find.widgetWithText(OutlinedButton, 'Épuisement'));
    expect(find.text('Nombre de rounds'), findsNothing);
    await _tap(tester, find.byTooltip('Un niveau de plus'));
    await _tap(tester, find.text('Ajouter Épuisement'));
    await _settle(tester);
    expect(
      chip('Épuisement 2 · −4 aux tests d20 · Vitesse −3 m'),
      findsOneWidget,
    );
    await _tap(tester, chip('Épuisement 2 · −4 aux tests d20 · Vitesse −3 m'));
    await _tap(tester, find.text('Retirer un niveau'));
    await _settle(tester);
    // La puce, et le titre de la fiche restée ouverte.
    expect(
      chip('Épuisement 1 · −2 aux tests d20 · Vitesse −1,50 m'),
      findsNWidgets(2),
    );
  });

  _test('état : autre effet « En feu », 1d4 de feu à chaque début de tour', (
    tester,
  ) async {
    await openCombat(tester);
    await _tap(tester, find.text('Ogre'));
    await _tap(tester, find.byTooltip('État'));
    await _tap(tester, find.widgetWithText(OutlinedButton, 'Autre effet'));
    expect(find.text('Ajouter Autre effet'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextField, "Libellé de l'effet"),
      'En feu',
    );
    await _tap(tester, find.text('Indéfinie'));
    await _tap(tester, find.text('Dégâts récurrents'));
    await _tap(tester, find.text('Ajouter En feu'));
    await _settle(tester);
    expect(chip('En feu'), findsOneWidget);
    await _tap(tester, chip('En feu'));
    expect(
      find.text(
        'Ogre · durée indéfinie\n'
        '1d4 dégâts feu au début de chacun de ses tours',
      ),
      findsOneWidget,
    );
  });

  _test('état : un squelette ne peut pas être Empoisonné', (tester) async {
    await openCombat(tester);
    await tester.runAsync(
      () => CombatStore(_db).append(_relais, authorUserId: _camille, [
        (
          CombatEventType.combatantAdded,
          {
            'id': 'squelette',
            'kind': 'monster',
            'label': 'Squelette',
            'hp': 13,
            'hp_max': 13,
            'condition_immunities': [
              'srd:condition:poisoned',
              'srd:condition:exhaustion',
            ],
          },
        ),
      ]),
    );
    await _settle(tester);
    await _tap(tester, find.text('Squelette'));
    await _tap(tester, find.byTooltip('État'));
    final poisoned = tester.widget<OutlinedButton>(
      find.widgetWithText(OutlinedButton, 'Empoisonné'),
    );
    expect(poisoned.onPressed, isNull);
    expect(
      tester
          .widget<OutlinedButton>(
            find.widgetWithText(OutlinedButton, 'Aveuglé'),
          )
          .onPressed,
      isNotNull,
    );
  });

  _test('détail : états et « Ajouter un état »', (tester) async {
    await openCombat(tester);
    await _tap(tester, detailOf('Ogre'));
    expect(find.text('États et effets'), findsOneWidget);
    await _tap(tester, find.text('Ajouter un état'));
    expect(find.text('Cible : Ogre'), findsOneWidget);
  });

  /// États posés directement au journal de la rencontre.
  Future<void> pose(
    WidgetTester tester,
    List<Map<String, Object?>> conditions,
  ) async {
    await tester.runAsync(
      () => CombatStore(_db).append(_relais, authorUserId: _camille, [
        for (final (i, c) in conditions.indexed)
          (CombatEventType.conditionAdded, {'instance': 'i$i', ...c}),
      ]),
    );
    await _settle(tester);
  }

  Future<void> nextTurnButton(WidgetTester tester) =>
      _tap(tester, find.widgetWithText(FilledButton, 'Tour suivant'));

  _test('fin de tour [C6] : sauvegarde réussie, Effrayé expire', (
    tester,
  ) async {
    await openCombat(tester);
    await pose(tester, [
      {
        'combatant': 'dragon',
        'condition': 'srd:condition:restrained',
        'duration': {'kind': 'save', 'dc': 13, 'ability': 'str'},
      },
      {
        'combatant': 'dragon',
        'condition': 'srd:condition:frightened',
        'duration': {'kind': 'turn_end', 'combatant': 'dragon'},
      },
    ]);
    await nextTurnButton(tester);
    expect(find.text('Fin du tour · Dragon noir adulte'), findsOneWidget);
    expect(find.text('Entravé · sauvegarde à refaire'), findsOneWidget);
    expect(find.text('JS de Force DD 13 · bonus +6'), findsOneWidget);
    // Le rappel, et la puce de la carte derrière le dialogue.
    expect(find.text('Effrayé · expire'), findsNWidgets(2));
    expect(find.text('Retiré'), findsOneWidget);
    await _tap(tester, find.widgetWithText(FilledButton, 'Réussite'));
    await _settle(tester);
    expect(find.widgetWithText(FilledButton, 'Réussite'), findsNothing);
    expect(chip('Entravé · JS FOR DD 13'), findsNothing);
    await _tap(tester, find.text('Tour suivant : Aldric'));
    await _settle(tester);
    expect(find.text('Fin du tour · Dragon noir adulte'), findsNothing);
    expect(chip('Effrayé · expire'), findsNothing);
    expect(find.textContaining('Effrayé', findRichText: true), findsNothing);
  });

  _test('fin de tour : « Lancer » d20 + 6 contre DD 13', (tester) async {
    await openCombat(tester);
    await pose(tester, [
      {
        'combatant': 'dragon',
        'condition': 'srd:condition:restrained',
        'duration': {'kind': 'save', 'dc': 13, 'ability': 'str'},
      },
    ]);
    await nextTurnButton(tester);
    await _tap(tester, find.text('Lancer'));
    await _settle(tester);
    expect(find.textContaining(RegExp(r'^(Réussite|Échec) · \d+$')), findsOne);
  });

  _test('fin de tour : « Plus tard » ne passe pas le tour', (tester) async {
    await openCombat(tester);
    await pose(tester, [
      {
        'combatant': 'dragon',
        'condition': 'srd:condition:restrained',
        'duration': {'kind': 'save', 'dc': 13, 'ability': 'str'},
      },
    ]);
    await nextTurnButton(tester);
    await _tap(tester, find.text('Plus tard'));
    expect(find.text('Fin du tour · Dragon noir adulte'), findsNothing);
    await nextTurnButton(tester);
    expect(find.text('Fin du tour · Dragon noir adulte'), findsOneWidget);
  });

  _test('début de tour [1a] : Empoisonné expire à la fin de ce tour ; OK', (
    tester,
  ) async {
    await openCombat(tester);
    await pose(tester, [
      {
        'combatant': 'aldric',
        'condition': 'srd:condition:poisoned',
        'duration': {'kind': 'turn_end', 'combatant': 'aldric'},
      },
      {
        'combatant': 'ogre',
        'condition': 'srd:condition:restrained',
        'duration': {'kind': 'turn_start', 'combatant': 'aldric'},
      },
    ]);
    await nextTurnButton(tester);
    await _settle(tester);
    expect(find.text('Début du tour · Aldric'), findsOneWidget);
    expect(find.text('Empoisonné expire à la fin de ce tour.'), findsOneWidget);
    expect(find.text('Entravé (Ogre) a pris fin.'), findsOneWidget);
    expect(chip('Empoisonné · expire'), findsOneWidget);
    await _tap(tester, find.text('OK'));
    expect(find.text('Début du tour · Aldric'), findsNothing);
  });

  _test('début de tour : « En feu », 1d4 de feu lancés et appliqués', (
    tester,
  ) async {
    await openCombat(tester);
    await pose(tester, [
      {
        'combatant': 'ogre',
        'label': 'En feu',
        'recurring': {
          'dice': '1d4',
          'type': 'srd:damage-type:fire',
          'at': 'start',
        },
      },
    ]);
    await nextTurnButton(tester);
    await _settle(tester);
    await nextTurnButton(tester);
    await _settle(tester);
    expect(find.text('Début du tour · Ogre'), findsOneWidget);
    expect(find.text('En feu : 1d4 dégâts feu'), findsOneWidget);
    await _tap(tester, find.text('Lancer et appliquer'));
    await _settle(tester);
    expect(find.textContaining(RegExp(r'^[1-4] dégâts appliqués$')), findsOne);
    expect(find.textContaining(RegExp(r'^5[5-8] / 59$')), findsOne);
  });

  /// Événements écrits directement au journal de la rencontre.
  Future<void> log(WidgetTester tester, List<NewCombatEvent> events) async {
    await tester.runAsync(
      () => CombatStore(_db).append(_relais, authorUserId: _camille, events),
    );
    await _settle(tester);
  }

  const blessing = (
    CombatEventType.concentrationStarted,
    {'combatant': 'aldric', 'spell': 'Bénédiction'},
  );

  _test('concentration [1c] : aperçu, alerte DD 10, réussite', (tester) async {
    await openCombat(tester);
    await log(tester, [blessing]);
    expect(chip('Concentration · Bénédiction'), findsOneWidget);
    await _tap(tester, find.text('Aldric'));
    await _tap(tester, find.byTooltip('Dégâts'));
    await keys(tester, '12');
    expect(find.text('Concentration : JS de CON DD 10'), findsOneWidget);
    await _tap(tester, find.text('Appliquer 12 dégâts tranchants'));
    await _settle(tester);
    expect(find.text('Jet de concentration · Aldric'), findsOneWidget);
    expect(find.text('Constitution DD 10'), findsOneWidget);
    expect(
      find.text('12 dégâts subis → DD 10 (la moitié, 6, est plus basse).'),
      findsOneWidget,
    );
    expect(find.text('Échec : Bénédiction prend fin.'), findsOneWidget);
    await _tap(tester, find.widgetWithText(FilledButton, 'Réussite'));
    await _settle(tester);
    expect(find.text('Jet de concentration · Aldric'), findsNothing);
    expect(chip('Concentration · Bénédiction'), findsOneWidget);
  });

  _test('concentration : échec confirmé, Béni retiré de l\'ogre', (
    tester,
  ) async {
    await openCombat(tester);
    await log(tester, [
      blessing,
      (
        CombatEventType.conditionAdded,
        {
          'combatant': 'ogre',
          'instance': 'béni',
          'label': 'Béni',
          'concentration': 'aldric',
        },
      ),
      // PV temporaires : Aldric reste debout, sa concentration aussi.
      (
        CombatEventType.tempHp,
        {
          'targets': ['aldric'],
          'amount': 10,
        },
      ),
      (
        CombatEventType.damage,
        {
          'targets': ['aldric'],
          'amount': 45,
          'type': 'srd:damage-type:slashing',
        },
      ),
    ]);
    expect(find.text('Constitution DD 22'), findsOneWidget);
    expect(
      find.text('45 dégâts subis → DD 22 (la moitié des dégâts).'),
      findsOneWidget,
    );
    expect(
      find.text('Échec : Bénédiction prend fin. Effets retirés : Béni (Ogre).'),
      findsOneWidget,
    );
    await _tap(tester, find.widgetWithText(OutlinedButton, 'Échec'));
    expect(find.text('Mettre fin à Bénédiction ?'), findsOneWidget);
    await _tap(tester, find.widgetWithText(FilledButton, 'Mettre fin'));
    await _settle(tester);
    expect(find.text('Jet de concentration · Aldric'), findsNothing);
    expect(chip('Concentration · Bénédiction'), findsNothing);
    expect(chip('Béni'), findsNothing);
  });

  _test('concentration : se concentrer, lier un effet [C5], mettre fin', (
    tester,
  ) async {
    await openCombat(tester);
    await _tap(tester, detailOf('Aldric'));
    await _tap(tester, find.text('Se concentrer'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Sort'),
      'Bénédiction',
    );
    await _tap(tester, find.widgetWithText(FilledButton, 'Se concentrer'));
    await _settle(tester);
    expect(chip('Concentration · Bénédiction'), findsNWidgets(2));
    await tester.tapAt(const Offset(10, 10));
    await _settle(tester);

    await _tap(tester, find.text('Ogre'));
    await _tap(tester, find.byTooltip('État'));
    await _tap(tester, find.widgetWithText(OutlinedButton, 'Autre effet'));
    await tester.enterText(
      find.widgetWithText(TextField, "Libellé de l'effet"),
      'Béni',
    );
    await _tap(tester, find.text('Aucun'));
    await _tap(tester, find.text('Aldric · Bénédiction').last);
    await _tap(tester, find.text('Ajouter Béni'));
    await _settle(tester);
    await _tap(tester, chip('Béni · 1 rd'));
    expect(
      find.textContaining('Lié à la concentration · Aldric · Bénédiction'),
      findsOneWidget,
    );
    await _tap(tester, find.text('Fermer'));

    await _tap(tester, detailOf('Aldric'));
    await _tap(tester, find.widgetWithText(OutlinedButton, 'Mettre fin'));
    expect(
      find.text('Bénédiction prend fin. Effets retirés : Béni (Ogre).'),
      findsOneWidget,
    );
    await _tap(tester, find.widgetWithText(FilledButton, 'Mettre fin'));
    await _settle(tester);
    expect(chip('Béni · 1 rd'), findsNothing);
    expect(chip('Concentration · Bénédiction'), findsNothing);
  });

  _test('0 PV [F2a] : mort sur le coup annoncée, puis appliquée', (
    tester,
  ) async {
    await openCombat(tester);
    await _tap(tester, find.text('Aldric'));
    await _tap(tester, find.byTooltip('Dégâts'));
    await keys(tester, '9');
    expect(find.textContaining('Mort sur le coup'), findsNothing);
    await keys(tester, '0');
    expect(
      find.text('Mort sur le coup · excédent 49 ≥ PV max 49 (dégâts massifs)'),
      findsOneWidget,
    );
    await _tap(tester, find.text('Appliquer : Aldric meurt'));
    await _settle(tester);
    expect(find.text('Mort'), findsWidgets);
  });

  _test('Assommer [F2b] : l\'ogre reste à 1 PV, Inconscient', (tester) async {
    await openCombat(tester);
    await _tap(tester, find.text('Ogre'));
    await _tap(tester, find.byTooltip('Dégâts'));
    await keys(tester, '20');
    expect(find.text('Assommer'), findsNothing);
    await _tap(tester, find.byTooltip('Effacer'));
    await _tap(tester, find.byTooltip('Effacer'));
    await keys(tester, '70');
    await _tap(tester, find.text('Assommer'));
    await _tap(tester, find.text('Appliquer : assommer Ogre'));
    await _settle(tester);
    expect(find.text('1 / 59'), findsOneWidget);
    expect(find.textContaining('Inconscient'), findsWidgets);
  });

  _test('concentration : fin annoncée quand Aldric tombe, puis Soutien', (
    tester,
  ) async {
    await openCombat(tester);
    await log(tester, [blessing]);
    await _tap(tester, find.text('Aldric'));
    await _tap(tester, find.byTooltip('Dégâts'));
    await keys(tester, '41');
    expect(find.text('Concentration : Bénédiction prend fin.'), findsOneWidget);
    await _tap(tester, find.text('Appliquer 41 dégâts tranchants'));
    await _settle(tester);
    expect(chip('Concentration · Bénédiction'), findsNothing);

    await _tap(tester, detailOf('Aldric'));
    await _tap(tester, find.widgetWithText(OutlinedButton, 'Soutien réussi'));
    await _settle(tester);
    expect(find.text('Inconscient · stabilisé'), findsWidgets);
  });

  _test('[C5] : Étourdi annonce la fin de la concentration', (tester) async {
    await openCombat(tester);
    await log(tester, [blessing]);
    await _tap(tester, find.text('Aldric'));
    await _tap(tester, find.byTooltip('État'));
    await _tap(tester, find.widgetWithText(OutlinedButton, 'Étourdi'));
    expect(
      find.text('Met fin à la concentration : Bénédiction prend fin.'),
      findsOneWidget,
    );
    await _tap(tester, find.text('Ajouter Étourdi'));
    await _settle(tester);
    expect(chip('Concentration · Bénédiction'), findsNothing);
  });

  _test('réaction d\'un PJ : disponible, utilisée, rendue', (tester) async {
    await openCombat(tester);
    await _tap(tester, find.text('Réaction disponible'));
    await _settle(tester);
    expect(find.text('Réaction utilisée'), findsOneWidget);
    await _tap(tester, find.text('Réaction utilisée'));
    await _settle(tester);
    expect(find.text('Réaction disponible'), findsOneWidget);
  });

  _test('Vigilant [C3] : Aldric échange son initiative avec Mira', (
    tester,
  ) async {
    await _open(tester);
    await tester.runAsync(() async {
      await CombatStore(_db).launch(_relais, authorUserId: _camille, [
        for (final (id, label, alert) in [
          ('aldric', 'Aldric', true),
          ('mira', 'Mira', false),
        ])
          (
            CombatEventType.combatantAdded,
            {
              'id': id,
              'kind': 'pc',
              'label': label,
              'hp': 30,
              'hp_max': 30,
              'alert': alert,
            },
          ),
        for (final (unit, die) in [('aldric', 19), ('mira', 8)])
          (
            CombatEventType.initiativeRolled,
            {
              'unit': unit,
              'dice': [die],
            },
          ),
      ]);
    });
    await _tap(tester, find.text('Ouvrir').first);
    await _tap(tester, find.text('Reprendre le combat'));
    await _settle(tester);
    expect(find.textContaining('Vigilant · Aldric'), findsOneWidget);
    expect(find.text('Mira : échanger…'), findsNothing);
    await _tap(tester, find.text('Aldric : échanger…'));
    await _tap(tester, find.text('8 ↔ 19'));
    await _settle(tester);
    final state = await tester.runAsync(
      () => CombatStore(_db).watchEvents(_relais).first.then(projectCombat),
    );
    expect(state!.combatant('aldric')!.initiative!.total, 8);
    expect(state.order, ['mira', 'aldric']);
  });

  _test('Étude [C9] : Thalia, Histoire 16 sur Varga, 2 paliers révélés', (
    tester,
  ) async {
    await _open(tester);
    late String varga;
    await tester.runAsync(() async {
      varga = await NpcStore(_db).create(
        tableId: _table,
        name: 'Varga la Balafrée',
        monsterId: 'srd:monster:bandit-captain',
        hiddenInfo: const [
          HiddenInfo(dc: 10, text: 'Ancienne sergente de la garde.'),
          HiddenInfo(dc: 15, text: 'Porte le sceau de la Guilde du Sel.'),
          HiddenInfo(dc: 20, text: 'Sœur cadette du bourgmestre Hesse.'),
        ],
      );
    });
    // Une écriture à la fois : l'écran relit la base entre deux.
    await _settle(tester);
    await tester.runAsync(() async {
      await CombatStore(_db).launch(_relais, authorUserId: _camille, [
        (
          CombatEventType.combatantAdded,
          {
            'id': 'thalia',
            'kind': 'pc',
            'ref_id': 'thalia',
            'label': 'Thalia',
            'hp': 33,
            'hp_max': 33,
          },
        ),
        (
          CombatEventType.combatantAdded,
          {
            'id': 'varga',
            'kind': 'npc',
            'ref_id': varga,
            'label': 'Varga la Balafrée',
            'hp': 52,
            'hp_max': 52,
          },
        ),
        for (final unit in ['thalia', 'varga'])
          (
            CombatEventType.initiativeRolled,
            {
              'unit': unit,
              'dice': [10],
            },
          ),
        (CombatEventType.combatStarted, const <String, Object?>{}),
      ]);
    });
    await _settle(tester);
    await tester.runAsync(() async {
      final fixture = jsonDecode(
        File('../../packages/dnd_rules/test/fixtures/d1/thalia_n5.json')
            .readAsStringSync(),
      ) as Map<String, Object?>;
      await CharacterStore(_db).save(
        'thalia',
        CharacterInput.fromJson(fixture['input']! as Map<String, Object?>),
      );
    });
    await _tap(tester, find.text('Ouvrir').first);
    await _tap(tester, find.text('Reprendre le combat'));
    await _settle(tester);

    await _tap(tester, find.byTooltip('Étude · Influence · Observation'));
    await _settle(tester);
    expect(find.text('Varga la Balafrée · Humanoïde'), findsOneWidget);
    expect(
      tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Histoire +1'))
          .selected,
      isTrue,
    );
    expect(
      find.text('Suggérée : Histoire, le domaine des Humanoïdes et Géants.'),
      findsOneWidget,
    );
    await tester.enterText(
      find.descendant(
        of: find.byType(SimpleRoll),
        matching: find.byType(TextField),
      ),
      '15',
    );
    await tester.pumpAndSettle();
    expect(find.text('Atteint : sera révélée'), findsNWidgets(2));
    expect(find.text('Non atteint : reste cachée'), findsOneWidget);
    await _tap(tester, find.text('Révéler 2 informations'));
    await _settle(tester);

    final (npc, events) = (await tester.runAsync(
      () async => (
        (await NpcStore(_db).watchList(_table).first).single,
        await CombatStore(_db).watchEvents(_relais).first,
      ),
    ))!;
    expect([for (final h in npc.hiddenInfo) h.revealed], [true, true, false]);
    final study = events.last;
    expect(study.type, CombatEventType.study);
    expect(study.payload, {
      'actor': 'thalia',
      'target': 'varga',
      'skill': 'srd:skill:history',
      'total': 16,
      'revealed': [10, 15],
    });
  });

  /// Aldric (niveau 1 de [D1]) face à Varga, PNJ Hostile, INT 14.
  Future<String> influenceSetup(WidgetTester tester) async {
    await _open(tester);
    late String varga;
    await tester.runAsync(() async {
      varga = await NpcStore(_db).create(
        tableId: _table,
        name: 'Varga la Balafrée',
        monsterId: 'srd:monster:bandit-captain',
        attitude: Attitude.hostile,
      );
    });
    await _settle(tester);
    await tester.runAsync(() async {
      await CombatStore(_db).launch(_relais, authorUserId: _camille, [
        (
          CombatEventType.combatantAdded,
          {
            'id': 'aldric',
            'kind': 'pc',
            'ref_id': 'aldric',
            'label': 'Aldric',
            'hp': 12,
            'hp_max': 12,
          },
        ),
        (
          CombatEventType.combatantAdded,
          {
            'id': 'varga',
            'kind': 'npc',
            'ref_id': varga,
            'label': 'Varga la Balafrée',
            'hp': 52,
            'hp_max': 52,
          },
        ),
        for (final unit in ['aldric', 'varga'])
          (
            CombatEventType.initiativeRolled,
            {
              'unit': unit,
              'dice': [10],
            },
          ),
        (CombatEventType.combatStarted, const <String, Object?>{}),
      ]);
    });
    await _settle(tester);
    await tester.runAsync(() async {
      final fixture = jsonDecode(
        File('../../packages/dnd_rules/test/fixtures/d1/aldric_n1.json')
            .readAsStringSync(),
      ) as Map<String, Object?>;
      await CharacterStore(_db).save(
        'aldric',
        CharacterInput.fromJson(fixture['input']! as Map<String, Object?>),
      );
    });
    await _settle(tester);
    // [C10] : Aldric a échoué à convaincre Varga il y a 2 h.
    await tester.runAsync(
      () => _db.customStatement(
        'INSERT INTO encounter_event (id, encounter_id, table_id, '
        'author_user_id, type, payload, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [
          '00000000-0000-7000-8000-000000000001',
          _relais,
          _table,
          _camille,
          'influence',
          jsonEncode({
            'actor': 'aldric',
            'target': 'varga',
            'npc': varga,
            'reception': 'hesitant',
            'approach': 'persuade',
            'success': false,
            'retry_hours': 24,
          }),
          DateTime.now()
              .toUtc()
              .subtract(const Duration(hours: 2, minutes: 5))
              .toIso8601String(),
        ],
      ),
    );
    await _tap(tester, find.text('Ouvrir').first);
    await _tap(tester, find.text('Reprendre le combat'));
    await _settle(tester);
    await _tap(tester, find.byTooltip('Étude · Influence · Observation'));
    await _settle(tester);
    await _tap(tester, find.widgetWithText(Tab, 'Influence'));
    await _settle(tester);
    return varga;
  }

  _test('Influence [C10] : Hostile, Désavantage, échec mémorisé', (
    tester,
  ) async {
    final varga = await influenceSetup(tester);
    expect(find.text('Attitude : Hostile'), findsOneWidget);
    await _tap(tester, find.text('Hésitante'));
    expect(find.text('Hésitante : un test est nécessaire.'), findsOneWidget);
    expect(
      find.text(
        'Aldric a échoué il y a 2 h : attendre 24 h pour la même approche',
      ),
      findsOneWidget,
    );
    expect(find.text('Charisme (Intimidation)'), findsOneWidget);
    await _tap(tester, find.text('Intimider'));
    expect(
      find.text(
        'DD : 15, ou l’Intelligence de la cible si elle est plus élevée '
        '(ici 14).',
      ),
      findsOneWidget,
    );
    expect(find.text('Désavantage · Hostile'), findsOneWidget);
    await tester.enterText(
      find.descendant(
        of: find.byType(SimpleRoll),
        matching: find.byType(TextField),
      ),
      '9',
    );
    await tester.pumpAndSettle();
    expect(find.text('Échec'), findsOneWidget);
    expect(find.text('Reste Hostile'), findsOneWidget);
    await _tap(tester, find.text('Enregistrer dans le journal'));
    await _settle(tester);

    final events = (await tester.runAsync(
      () => CombatStore(_db).watchEvents(_relais).first,
    ))!;
    expect(events.last.type, CombatEventType.influence);
    expect(events.last.payload, {
      'actor': 'aldric',
      'target': 'varga',
      'npc': varga,
      'reception': 'hesitant',
      'approach': 'intimidate',
      'skill': 'srd:skill:intimidation',
      'dc': 15,
      'mode': 'disadvantage',
      'total': 11,
      'success': false,
      'attitude': 'hostile',
      'retry_hours': 24,
    });
  });

  _test('Influence : disposée, Varga devient Amicale', (tester) async {
    await influenceSetup(tester);
    await _tap(tester, find.text('Disposée'));
    expect(find.text('Disposée : elle accepte sans test.'), findsOneWidget);
    await _tap(tester, find.text('Amical'));
    await _tap(tester, find.text('Enregistrer dans le journal'));
    await _settle(tester);
    final npc = (await tester.runAsync(
      () async => (await NpcStore(_db).watchList(_table).first).single,
    ))!;
    expect(npc.attitude, Attitude.friendly);
  });

  _test('Observation [F3] : Perception 13 + 3 contre DD 15, liée à Varga', (
    tester,
  ) async {
    final varga = await influenceSetup(tester);
    await _tap(tester, find.widgetWithText(Tab, 'Observation'));
    await _settle(tester);
    expect(
      tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Perception +3'))
          .selected,
      isTrue,
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Ce qui est cherché'),
      'Des traces autour de l’écurie du relais',
    );
    await tester.enterText(
      find.descendant(
        of: find.byType(SimpleRoll),
        matching: find.byType(TextField),
      ),
      '13',
    );
    await tester.enterText(find.widgetWithText(TextField, 'DD (MJ)'), '15');
    await tester.pumpAndSettle();
    expect(find.text('Réussite'), findsOneWidget);
    // Sans découverte rédigée, rien à consigner.
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Consigner'))
          .onPressed,
      isNull,
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Ce qui est découvert'),
      'Des ornières de chariots lourds partent vers le gué.',
    );
    await _tap(tester, find.text('Aucun'));
    await _tap(tester, find.text('Varga la Balafrée').last);
    await _tap(tester, find.widgetWithText(FilledButton, 'Consigner'));
    await _settle(tester);

    final events = (await tester.runAsync(
      () => CombatStore(_db).watchEvents(_relais).first,
    ))!;
    expect(events.last.type, CombatEventType.observation);
    expect(events.last.payload, {
      'actor': 'aldric',
      'sought': 'Des traces autour de l’écurie du relais',
      'skill': 'srd:skill:perception',
      'total': 16,
      'dc': 15,
      'success': true,
      'discovery': 'Des ornières de chariots lourds partent vers le gué.',
      'npc': varga,
    });
  });

  _test('journal : phrases, rounds, filtres, annulé barré (US-25)', (
    tester,
  ) async {
    await openCombat(tester);
    await log(tester, [
      (
        CombatEventType.damage,
        {
          'targets': ['aldric'],
          'amount': 12,
          'type': 'srd:damage-type:slashing',
        },
      ),
      (
        CombatEventType.damage,
        {
          'targets': ['ogre'],
          'amount': 59,
          'type': 'srd:damage-type:bludgeoning',
        },
      ),
    ]);
    await _tap(tester, find.byTooltip('Annuler'));
    await _settle(tester);
    await _tap(tester, find.byTooltip('Journal'));
    await _settle(tester);
    expect(find.text('12 dégâts tranchants : Aldric (41 → 29)'), findsOne);
    // Annulés, des dégâts n'ont pas d'effet sur les PV : la cible seule.
    final ogre = find.text('59 dégâts contondants : Ogre');
    expect(ogre, findsOneWidget);
    expect(
      tester.widget<Text>(ogre).style?.decoration,
      TextDecoration.lineThrough,
    );
    expect(find.text('Action annulée'), findsOneWidget);
    expect(find.textContaining(RegExp(r'^R1 · \d\d:\d\d$')), findsWidgets);
    // 8 événements au lancement, 2 dégâts, dont 1 annulé.
    expect(find.text('9 actions annulables'), findsOneWidget);

    await _tap(tester, find.widgetWithText(ChoiceChip, 'PV'));
    expect(find.text('Dragon noir adulte entre dans le combat'), findsNothing);
    expect(find.text('12 dégâts tranchants : Aldric (41 → 29)'), findsOne);
    await _tap(tester, find.widgetWithText(ChoiceChip, 'Tout'));
    expect(find.text('Dragon noir adulte entre dans le combat'), findsOne);
  });

  _test('fin [C11] : résumé, PX modifiés, clôture, résumé relu', (
    tester,
  ) async {
    await openCombat(tester);
    await log(tester, [
      (
        CombatEventType.damage,
        {
          'targets': ['ogre'],
          'amount': 59,
          'type': 'srd:damage-type:bludgeoning',
        },
      ),
    ]);
    await _tap(tester, find.byType(PopupMenuButton<String>));
    await _tap(tester, find.text('Terminer la rencontre'));
    await _settle(tester);
    expect(find.text('Fin de rencontre'), findsOneWidget);
    // Dragon noir adulte 11 500 + Ogre 450, encore dans le combat.
    expect(find.text('11 950'), findsOneWidget);
    expect(find.text('1 / 2'), findsOneWidget);
    expect(find.text('round 1'), findsOneWidget);
    expect(
      find.text(
        '11 950 PX pour la rencontre, répartis entre 1 personnage. '
        'Modifiable avant de clore.',
      ),
      findsOneWidget,
    );
    await tester.enterText(find.widgetWithText(TextField, '11950'), '700');
    await _tap(tester, find.text('Clore et ranger dans la séance'));
    await _settle(tester);

    final events = (await tester.runAsync(
      () => CombatStore(_db).watchEvents(_relais).first,
    ))!;
    expect(events.last.type, CombatEventType.encounterFinished);
    expect(events.last.payload, {
      'rounds': 1,
      'xp_total': 11950,
      'xp': {'aldric': 700},
    });
    expect(find.text('Résumé de la rencontre'), findsOneWidget);
    await _tap(tester, find.text('Résumé de la rencontre'));
    await _settle(tester);
    expect(find.text('+700 PX'), findsOneWidget);
    expect(find.text('Clore et ranger dans la séance'), findsNothing);
  });

  // Spec encounters : « Vue des joueurs publiée », « Demandes des joueurs
  // appliquées », « Masquer aux joueurs » (US-36, EF-VJ-03, 06).
  Future<Map<String, Object?>?> view(WidgetTester tester) async =>
      (await tester.runAsync(() => CombatViewStore(_db).watch(_relais).first))
          ?.payload;

  List<Object?> labels(Map<String, Object?>? view) => [
    for (final o in view!['order']! as List) (o as Map)['label'],
  ];

  _test('vue des joueurs : publiée, demande appliquée, retirée à la fin', (
    tester,
  ) async {
    await openCombat(tester);
    expect(labels(await view(tester)), contains('Dragon noir adulte'));

    String? request;
    await tester.runAsync(() async {
      request = await CombatRequestStore(_db).send(
        encounterId: _relais,
        tableId: _table,
        characterId: 'aldric',
        authorUserId: _hugo,
        type: 'damage',
        payload: {
          'targets': ['dragon'],
          'amount': 5,
          'type': 'srd:damage-type:slashing',
        },
      );
    });
    await _settle(tester);
    final events = (await tester.runAsync(
      () => CombatStore(_db).watchEvents(_relais).first,
    ))!;
    expect(events.last.type, CombatEventType.damage);
    expect(events.last.payload, {
      'targets': ['aldric'],
      'amount': 5,
      'type': 'srd:damage-type:slashing',
      'request': request,
    });
    final pending = await tester.runAsync(
      () => CombatRequestStore(_db).watch(_relais).first,
    );
    expect(pending, isEmpty);
    final pcs = (await view(tester))!['pcs']! as Map<String, Object?>;
    expect((pcs['aldric']! as Map)['hp'], 36);

    // Une demande refusée est retirée sans rien écrire.
    await tester.runAsync(
      () => CombatRequestStore(_db).send(
        encounterId: _relais,
        tableId: _table,
        characterId: 'aldric',
        authorUserId: _hugo,
        type: 'undo',
        payload: {'event': events.last.id},
      ),
    );
    await _settle(tester);
    final after = (await tester.runAsync(
      () => CombatStore(_db).watchEvents(_relais).first,
    ))!;
    expect(after.length, events.length);
    expect(
      await tester.runAsync(() => CombatRequestStore(_db).watch(_relais).first),
      isEmpty,
    );

    await _tap(tester, find.byType(PopupMenuButton<String>));
    await _tap(tester, find.text('Terminer la rencontre'));
    await _settle(tester);
    await _tap(tester, find.text('Clore et ranger dans la séance'));
    await _settle(tester);
    expect(await view(tester), isNull);
  });

  _test('Masquer aux joueurs : le dragon quitte la vue, puis revient', (
    tester,
  ) async {
    await openCombat(tester);
    await _tap(tester, detailOf('Dragon noir adulte'));
    await _tap(tester, find.text('Masquer aux joueurs'));
    await _settle(tester);
    expect(labels(await view(tester)), isNot(contains('Dragon noir adulte')));
    await _tap(tester, find.text('Masquer aux joueurs'));
    await _settle(tester);
    expect(labels(await view(tester)), contains('Dragon noir adulte'));
  });
}
