// Spec tables : « Onglet des séances », « Créer une séance », « Préparer une
// séance » (US-35, EF-SEA-01, EF-SEA-02, [S1], [S2], [S5], [S6]).
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
import 'package:game_table/l10n/app_localizations.dart';
import 'package:game_table/sessions/session_page.dart';
import 'package:game_table/tables/table_page.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

import '../account/fakes.dart';

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

const _camille = '00000000-0000-0000-0000-00000000000a';
const _hugo = '00000000-0000-0000-0000-00000000000b';
const _ines = '00000000-0000-0000-0000-00000000000c';

User _user(String id) => User(
  id: id,
  appMetadata: const {},
  userMetadata: const {},
  aud: 'authenticated',
  createdAt: '2026-11-11T10:00:00Z',
);

late TavernierDatabase _db;
late String _table;

/// Brumeval de Camille, avec Hugo (Aldric, validé) et Inès (Mira, en
/// création), puis la page de la table vue par [me], sur l'onglet Séances.
Future<void> _open(
  WidgetTester tester, {
  String me = _camille,
  Future<void> Function(SessionStore)? seed,
}) async {
  tester.view.physicalSize = const Size(390, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  _db = TavernierDatabase(NativeDatabase.memory());
  addTearDown(_db.close);
  await tester.runAsync(() async {
    final tables = TableStore(_db);
    _table = await tables.create(
      gmUserId: _camille,
      settings: const TableSettings(name: 'Brumeval'),
      packs: const [],
    );
    for (final (id, user) in [('m1', _hugo), ('m2', _ines)]) {
      await _db.customStatement(
        'INSERT INTO table_member (id, table_id, user_id, role, joined_at) '
        "VALUES (?, ?, ?, 'player', '2026-11-11T10:00:00Z')",
        [id, _table, user],
      );
    }
    await _db.customStatement(
      'INSERT INTO profile (id, pseudonym, locale, settings) VALUES '
      "(?, 'Camille', 'fr', '{}'), (?, 'Hugo', 'fr', '{}'), "
      "(?, 'Inès', 'fr', '{}')",
      [_camille, _hugo, _ines],
    );
    final characters = CharacterStore(_db);
    for (final (id, name, owner, status) in [
      ('aldric', 'Aldric Varenne', _hugo, 'validated'),
      ('mira', 'Mira Solen', _ines, 'draft'),
    ]) {
      await _db.customStatement(
        'INSERT INTO character (id, table_id, owner_user_id, kind, name, '
        "species_id, background_id, status) VALUES (?, ?, ?, 'pc', ?, "
        "'srd:species:human', 'srd:background:soldier', ?)",
        [id, _table, owner, name, status],
      );
      await characters.publishSummary(
        CharacterSummary(
          id: id,
          tableId: _table,
          ownerUserId: owner,
          name: name,
          speciesId: 'srd:species:human',
          classes: const [(classId: 'srd:class:fighter', level: 5)],
          health: Health.unhurt,
        ),
      );
      await tables.fillSlot(await tables.createSlot(_table, owner), id);
    }
    await seed?.call(SessionStore(_db));
  });
  final router = GoRouter(
    initialLocation: '/tables/$_table',
    routes: [
      GoRoute(
        path: '/tables/:id',
        builder: (_, state) => TablePage(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/tables/:id/seances/:session',
        builder: (_, state) => SessionPage(
          tableId: state.pathParameters['id']!,
          id: state.pathParameters['session']!,
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
  await tester.tap(find.text('Séances'));
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Séances de la table, la plus récente d'abord, lues sans flux observé.
Future<List<({String id, String title, DateTime date, SessionStatus status})>>
_sessions(WidgetTester tester) async {
  final rows = await tester.runAsync(
    () => _db
        .customSelect(
          'SELECT id, title, date, status FROM session WHERE table_id = ? '
          'ORDER BY date DESC',
          variables: [Variable.withString(_table)],
        )
        .get(),
  );
  return [
    for (final r in rows!)
      (
        id: r.read<String>('id'),
        title: r.read<String>('title'),
        date: DateTime.parse(r.read<String>('date')),
        status: SessionStatus.parse(r.read<String>('status')),
      ),
  ];
}

Future<Set<String>> _present(WidgetTester tester, String id) async {
  final rows = await tester.runAsync(
    () => _db
        .customSelect(
          'SELECT character_id FROM session_attendance WHERE session_id = ?',
          variables: [Variable.withString(id)],
        )
        .get(),
  );
  return {for (final r in rows!) r.read<String>('character_id')};
}

/// Démonte l'app avant la fin : drift ferme ses requêtes observées par un
/// minuteur, qui doit partir avant la vérification finale.
void _test(String description, Future<void> Function(WidgetTester) body) =>
    testWidgets(description, (tester) async {
      await body(tester);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

Future<void> _twoSessions(SessionStore store) async {
  await store.create(
    tableId: _table,
    title: 'Le gué des Loups',
    date: DateTime(2026, 10, 23),
    status: SessionStatus.closed,
  );
  await store.create(
    tableId: _table,
    title: 'Le relais du Sel',
    date: DateTime(2026, 10, 30),
    present: ['aldric'],
  );
}

void main() {
  _test('aucune séance, vue du MJ [S6]', (tester) async {
    await _open(tester);
    expect(find.text('Aucune séance'), findsOneWidget);
    expect(find.text('Préparer la séance 1'), findsOneWidget);
    expect(find.text('Jouer tout de suite, sans préparation'), findsOneWidget);
    expect(
      find.text(
        '1 joueur sur 2 a une fiche validée. Les autres pourront rejoindre '
        'la séance en cours.',
      ),
      findsOneWidget,
    );
  });

  _test('préparer la séance 1 : tout le groupe prévu, préparation ouverte', (
    tester,
  ) async {
    await _open(tester);
    await _tap(tester, find.text('Préparer la séance 1'));
    final session = (await _sessions(tester)).single;
    expect(
      (session.title, session.status),
      ('Séance 1', SessionStatus.planned),
    );
    expect(await _present(tester, session.id), {'aldric', 'mira'});
    expect(find.text('Préparer la séance'), findsOneWidget);
    expect(find.text('Brumeval · Séance 1'), findsOneWidget);
  });

  _test('jouer tout de suite : séance du jour, en cours', (tester) async {
    await _open(tester);
    await _tap(tester, find.text('Jouer tout de suite, sans préparation'));
    final session = (await _sessions(tester)).single;
    final today = DateTime.now();
    expect(session.status, SessionStatus.inProgress);
    expect(session.date, DateTime(today.year, today.month, today.day));
    expect(find.text('En cours'), findsOneWidget);
    expect(find.text('Préparer la séance'), findsNothing);
  });

  _test('liste : prochaine et passées, avec leur état [S1]', (tester) async {
    await _open(tester, seed: _twoSessions);
    expect(find.text('PROCHAINE'), findsOneWidget);
    expect(find.text('PASSÉES'), findsOneWidget);
    expect(find.text('Séance 2'), findsOneWidget);
    expect(find.text('Le relais du Sel'), findsOneWidget);
    expect(find.text('Préparée'), findsOneWidget);
    expect(find.text('Séance 1'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);
    expect(find.text('OCT.'), findsNWidgets(2));
    expect(find.text('30'), findsOneWidget);
    expect(find.text('Nouvelle séance'), findsOneWidget);
  });

  _test('joueur : personnage attendu, aucun bouton [S5]', (tester) async {
    await _open(tester, me: _hugo, seed: _twoSessions);
    expect(find.text('Personnage attendu : Aldric Varenne'), findsOneWidget);
    expect(find.text('Nouvelle séance'), findsNothing);
    expect(find.textContaining('Jouer tout de suite'), findsNothing);
    await tester.tap(find.text('Le relais du Sel'));
    await tester.pumpAndSettle();
    expect(find.text('Préparer la séance'), findsNothing);
  });

  _test('préparation : titre, date, présences, ouverture [S2]', (tester) async {
    await _open(tester, seed: _twoSessions);
    await _tap(tester, find.text('Le relais du Sel'));
    expect(find.text('vendredi 30/10/2026'), findsOneWidget);
    expect(find.text('Hugo · Guerrier 5'), findsOneWidget);
    expect(find.text('Inès · Guerrier 5'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Le relais du Sel, suite');
    // Enregistré une demi-seconde après la dernière frappe.
    await tester.pump(const Duration(seconds: 1));
    await _tap(tester, find.text('Mira Solen'));
    await _tap(tester, find.text('Aldric Varenne'));
    final id = (await _sessions(tester)).first.id;
    expect(await _present(tester, id), {'mira'});

    await _tap(tester, find.text('vendredi 30/10/2026'));
    await _tap(tester, find.text('31'));
    await _tap(tester, find.text('OK'));
    expect(find.text('samedi 31/10/2026'), findsOneWidget);

    await _tap(tester, find.text('Ouvrir la séance'));
    final session = (await _sessions(tester)).first;
    expect(
      (session.title, session.date, session.status),
      (
        'Le relais du Sel, suite',
        DateTime(2026, 10, 31),
        SessionStatus.inProgress,
      ),
    );
    expect(find.text('Ouvrir la séance'), findsNothing);
  });

  // Spec tables : « Repos de groupe » (US-38, EF-PJ-19, [J9]).
  _test('repos de groupe [J9] : déclenché, suivi, clos', (tester) async {
    await _open(
      tester,
      seed: (store) => store.create(
        tableId: _table,
        title: 'Le relais du Sel',
        date: DateTime(2026, 10, 30),
        status: SessionStatus.inProgress,
        present: ['aldric', 'mira'],
      ),
    );
    await _tap(tester, find.text('Le relais du Sel'));
    expect(find.text('Repos pour le groupe'), findsOneWidget);
    await _tap(tester, find.widgetWithText(OutlinedButton, 'Repos court'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
    final rest = (await tester.runAsync(
      () => GroupRestStore(_db).watchOpen(_table).first,
    ))!.single;
    expect(rest.kind, 'short');
    expect(rest.characters, unorderedEquals(['aldric', 'mira']));
    expect(find.text('Repos court en cours'), findsOneWidget);
    expect(find.text('En attente'), findsNWidgets(2));
    expect(find.text('Faire pour Mira Solen'), findsOneWidget);

    // Hugo termine pour Aldric.
    await tester.runAsync(
      () => GroupRestStore(_db).markDone(
        restId: rest.id,
        tableId: _table,
        characterId: 'aldric',
        authorUserId: _hugo,
        summary: {'hit_dice': 2, 'hp_before': 34, 'hp_after': 49},
      ),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Terminé'), findsOneWidget);
    expect(find.text('2 dés de vie dépensés · PV 34 → 49'), findsOneWidget);

    await _tap(tester, find.text('Clore le repos'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
    expect(
      await tester.runAsync(() => GroupRestStore(_db).watchOpen(_table).first),
      isEmpty,
    );
    expect(find.widgetWithText(OutlinedButton, 'Repos court'), findsOneWidget);
  });

  _test('séance prévue : pas de repos de groupe', (tester) async {
    await _open(tester, seed: _twoSessions);
    await _tap(tester, find.text('Le relais du Sel'));
    expect(find.text('Repos pour le groupe'), findsNothing);
  });
}
