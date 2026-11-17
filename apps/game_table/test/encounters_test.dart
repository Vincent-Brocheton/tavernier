// Spec tables : « Onglet des rencontres », « Créer, dupliquer et ranger une
// rencontre », « Budget de la prochaine séance » (US-19, EF-REN-01, 03, 05,
// [F5]).
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
import 'package:game_table/encounters/encounter_page.dart';
import 'package:game_table/encounters/foe_picker.dart';
import 'package:game_table/l10n/app_localizations.dart';
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
}
