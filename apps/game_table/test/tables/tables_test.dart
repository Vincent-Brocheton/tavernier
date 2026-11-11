// Spec tables : « Création d'une table », « Liste des tables » (US-13).
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
import 'package:game_table/l10n/app_localizations.dart';
import 'package:game_table/tables/create_table_page.dart';
import 'package:game_table/tables/table_page.dart';
import 'package:game_table/tables/tables_tab.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

import '../account/fakes.dart';

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

const _gm = User(
  id: '00000000-0000-0000-0000-00000000000a',
  appMetadata: {},
  userMetadata: {},
  aud: 'authenticated',
  createdAt: '2026-11-11T10:00:00Z',
  email: 'camille@exemple.fr',
);

late AppLocalizations l10n;

Future<TavernierDatabase> _pump(
  WidgetTester tester, {
  Size size = const Size(390, 1800),
  Future<void> Function(TavernierDatabase)? seed,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final database = TavernierDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  await seed?.call(database);
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(body: TablesTab()),
      ),
      GoRoute(
        path: '/tables/nouvelle',
        builder: (_, _) => const CreateTablePage(),
      ),
      GoRoute(
        path: '/tables/:id',
        builder: (_, state) => TablePage(id: state.pathParameters['id']!),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        accountGatewayProvider.overrideWithValue(FakeGateway()),
        currentUserProvider.overrideWith((ref) => Stream.value(_gm)),
        databaseProvider.overrideWithValue(database),
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
  l10n = AppLocalizations.of(tester.element(find.byType(TablesTab)));
  return database;
}

bool _canCreate(WidgetTester tester) =>
    tester
        .widget<FilledButton>(
          find.widgetWithText(FilledButton, l10n.createTable),
        )
        .onPressed !=
    null;

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('aucune table : invitation à en créer une', (tester) async {
    await _pump(tester);
    expect(find.text(l10n.tablesEmpty), findsOneWidget);
    expect(find.text(l10n.newTable), findsOneWidget);
  });

  testWidgets('nom vide : « Créer la table » désactivé', (tester) async {
    await _pump(tester);
    await _tap(tester, find.text(l10n.newTable));
    expect(_canCreate(tester), isFalse);
  });

  testWidgets('création : réglages choisis, MJ, pack SRD figé', (tester) async {
    final database = await _pump(tester);
    await _tap(tester, find.text(l10n.newTable));
    await tester.enterText(
      find.widgetWithText(TextField, l10n.tableNameLabel),
      'Les Marches de Brumeval',
    );
    await tester.enterText(
      find.widgetWithText(TextField, l10n.tableDescriptionLabel),
      'Campagne de frontière.',
    );
    await _tap(tester, find.byTooltip(l10n.levelIncrease));
    await _tap(tester, find.byTooltip(l10n.levelIncrease));
    await _tap(tester, find.text(l10n.methodStandard));
    await _tap(tester, find.text(l10n.longRestHitDice));
    await _tap(tester, find.text(l10n.hpRoll));
    await _tap(tester, find.text(l10n.progressionMilestones));
    expect(_canCreate(tester), isTrue);

    await tester.tap(find.widgetWithText(FilledButton, l10n.createTable));
    await tester.pumpAndSettle();

    // La page de la table, et ce qui est en base.
    expect(find.byType(TablePage), findsOneWidget);
    expect(find.text('Les Marches de Brumeval'), findsOneWidget);
    expect(find.text(l10n.youAreGm.toUpperCase()), findsOneWidget);
    final [table] = await TableStore(database).list(_gm.id);
    expect(
      table.settings,
      const TableSettings(
        name: 'Les Marches de Brumeval',
        description: 'Campagne de frontière.',
        startingLevel: 3,
        statMethod: ScoreMethod.standardArray,
        longRest: LongRestRule.hitDice,
        hpOnLevel: HpOnLevel.roll,
        progression: Progression.milestones,
      ),
    );
    expect(table.role, TableRole.gm);
    final pack = await database
        .customSelect('SELECT pack_id, pinned_version FROM table_pack')
        .getSingle();
    expect(pack.read<String>('pack_id'), _content.packs.single.manifest.id);
    expect(
      pack.read<String>('pinned_version'),
      _content.packs.single.manifest.version,
    );
  });

  testWidgets('liste : la table, avec le rôle, ouvre sa page', (tester) async {
    await _pump(
      tester,
      seed: (database) => TableStore(database).create(
        gmUserId: _gm.id,
        settings: const TableSettings(name: 'Brumeval'),
        packs: const [],
      ),
    );
    expect(find.text('Brumeval'), findsOneWidget);
    expect(find.textContaining(l10n.roleGm), findsOneWidget);
    expect(find.text(l10n.tablesEmpty), findsNothing);
    await _tap(tester, find.text('Brumeval'));
    expect(find.byType(TablePage), findsOneWidget);
  });

  testWidgets('desktop : aperçu de la carte au fil de la saisie [T8]', (
    tester,
  ) async {
    await _pump(tester, size: const Size(1440, 1100));
    await _tap(tester, find.text(l10n.newTable));
    expect(find.text(l10n.previewTitle), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextField, l10n.tableNameLabel),
      'Brumeval',
    );
    await tester.pump();
    // Le nom, dans le champ et dans l'aperçu.
    expect(find.text('Brumeval'), findsNWidgets(2));
  });
}
