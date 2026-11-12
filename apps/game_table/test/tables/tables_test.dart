// Spec tables : « Création d'une table », « Liste des tables » (US-13).
import 'dart:convert';
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
import 'package:game_table/tables/join_page.dart';
import 'package:game_table/tables/table_labels.dart';
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

/// Aldric de [D1], au niveau 1 en acquisition par points.
CharacterInput _aldric() => CharacterInput.fromJson(
  (jsonDecode(
        File('../../packages/dnd_rules/test/fixtures/d1/aldric_n1.json')
            .readAsStringSync(),
      ) as Map<String, Object?>)['input']!
      as Map<String, Object?>,
);

const _hugo = '00000000-0000-0000-0000-00000000000b';

/// Table du MJ connecté, avec Hugo et sa fiche Aldric dans un emplacement.
Future<(TavernierDatabase, String, String)> _withAldric(
  WidgetTester tester, {
  required String status,
  String? message,
  Size size = const Size(1440, 1100),
}) async {
  final (database, id) = await _openTable(tester, size: size);
  await database.customStatement(
    'INSERT INTO table_member (id, table_id, user_id, role, joined_at) '
    "VALUES ('m8', ?, ?, 'player', '2026-11-11T10:00:00Z')",
    [id, _hugo],
  );
  await database.customStatement(
    'INSERT INTO profile (id, pseudonym, locale, settings) VALUES '
    "(?, 'Camille', 'fr', '{}'), (?, 'Hugo', 'fr', '{}')",
    [_gm.id, _hugo],
  );
  await CharacterStore(database).save('c1', _aldric(), tableId: id);
  await database.customStatement(
    'UPDATE character SET owner_user_id = ?, status = ?, submit_message = ? '
    "WHERE id = 'c1'",
    [_hugo, status, message],
  );
  final store = TableStore(database);
  await store.fillSlot(await store.createSlot(id, _hugo), 'c1');
  await tester.pumpAndSettle();
  await _tap(tester, find.text(l10n.tabMembers));
  return (database, id, 'c1');
}

Future<TavernierDatabase> _pump(
  WidgetTester tester, {
  Size size = const Size(390, 1800),
  Future<void> Function(TavernierDatabase)? seed,
  String initialLocation = '/',
  FakeGateway? gateway,
  bool online = true,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final database = TavernierDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  await seed?.call(database);
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(body: TablesTab()),
      ),
      GoRoute(
        path: '/tables/nouvelle',
        builder: (_, _) => const CreateTablePage(),
      ),
      GoRoute(path: '/rejoindre', builder: (_, _) => const JoinPage()),
      GoRoute(
        path: '/rejoindre/:code',
        builder: (_, state) => JoinPage(code: state.pathParameters['code']),
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
        accountGatewayProvider.overrideWithValue(gateway ?? FakeGateway()),
        onlineProvider.overrideWith((ref) => Stream.value(online)),
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
  l10n = AppLocalizations.of(tester.element(find.byType(Scaffold).first));
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

const _brumeval = TableSettings(
  name: 'Brumeval',
  statMethod: ScoreMethod.standardArray,
);

/// Une table de [gm], ouverte sur sa page ; rend la base et l'identifiant.
Future<(TavernierDatabase, String)> _openTable(
  WidgetTester tester, {
  String gm = '00000000-0000-0000-0000-00000000000a',
  Size size = const Size(390, 1800),
}) async {
  late String id;
  final database = await _pump(
    tester,
    size: size,
    seed: (database) async {
      id = await TableStore(database)
          .create(gmUserId: gm, settings: _brumeval, packs: const []);
      if (gm != _gm.id) {
        await database.customStatement(
          'INSERT INTO table_member (id, table_id, user_id, role, joined_at) '
          "VALUES ('m9', ?, ?, 'player', '2026-11-11T10:00:00Z')",
          [id, _gm.id],
        );
      }
    },
  );
  // L'identifiant n'est connu qu'après la graine : on y navigue ensuite.
  GoRouter.of(tester.element(find.byType(TablesTab))).go('/tables/$id');
  await tester.pumpAndSettle();
  return (database, id);
}

Future<void> _choose<T>(WidgetTester tester, String label) async {
  await _tap(tester, find.byType(DropdownButtonFormField<T>).first);
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

/// [testWidgets], qui démonte l'app avant la fin : drift ferme ses requêtes
/// observées par un minuteur, qui doit partir avant la vérification finale.
void _testTable(String description, Future<void> Function(WidgetTester) body) =>
    testWidgets(description, (tester) async {
      await body(tester);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(Duration.zero);
    });

void main() {
  _testTable('aucune table : invitation à en créer une', (tester) async {
    await _pump(tester);
    expect(find.text(l10n.tablesEmpty), findsOneWidget);
    expect(find.text(l10n.newTable), findsOneWidget);
  });

  _testTable('nom vide : « Créer la table » désactivé', (tester) async {
    await _pump(tester);
    await _tap(tester, find.text(l10n.newTable));
    expect(_canCreate(tester), isFalse);
  });

  _testTable('création : réglages choisis, MJ, pack SRD figé', (tester) async {
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

  _testTable('liste : la table, avec le rôle, ouvre sa page', (tester) async {
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

  _testTable('desktop : aperçu de la carte au fil de la saisie [T8]', (
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
  _testTable('configuration : changement signalé, enregistré, daté', (
    tester,
  ) async {
    final (database, id) = await _openTable(tester);
    await _tap(tester, find.text(l10n.tabConfiguration));
    expect(find.text(l10n.unsavedTitle), findsNothing);

    await _choose<ScoreMethod>(tester, l10n.statMethod(ScoreMethod.pointBuy));
    expect(find.text(l10n.methodChangeTitle), findsOneWidget);
    expect(find.text(l10n.unsavedTitle), findsOneWidget);
    expect(
      find.text(
        l10n.changeLine(
          l10n.fieldMethod,
          l10n.statMethod(ScoreMethod.standardArray),
          l10n.statMethod(ScoreMethod.pointBuy),
        ),
      ),
      findsOneWidget,
    );

    await _tap(tester, find.widgetWithText(FilledButton, l10n.accountSave));
    expect(find.text(l10n.unsavedTitle), findsNothing);
    final table = await TableStore(database).load(id, _gm.id);
    expect(table!.settings.statMethod, ScoreMethod.pointBuy);

    // L'activité, dans la vue d'ensemble.
    await _tap(tester, find.text(l10n.tabOverview));
    expect(
      find.text(
        l10n.changeLine(
          l10n.fieldMethod,
          l10n.statMethod(ScoreMethod.standardArray),
          l10n.statMethod(ScoreMethod.pointBuy),
        ),
      ),
      findsOneWidget,
    );
    expect(find.text(l10n.activityEmpty), findsNothing);
  });

  _testTable('configuration : « Annuler » rend la configuration enregistrée', (
    tester,
  ) async {
    final (database, id) = await _openTable(tester);
    await _tap(tester, find.text(l10n.tabConfiguration));
    await _choose<ScoreMethod>(tester, l10n.statMethod(ScoreMethod.pointBuy));
    await _tap(tester, find.widgetWithText(TextButton, l10n.cancel));
    expect(find.text(l10n.unsavedTitle), findsNothing);
    expect(find.text(l10n.methodChangeTitle), findsNothing);
    expect(
      (await TableStore(database).load(id, _gm.id))!.settings.statMethod,
      ScoreMethod.standardArray,
    );
    expect(await TableStore(database).activity(id), isEmpty);
  });

  _testTable('archivage : lecture seule, puis restauration', (tester) async {
    final (database, id) = await _openTable(tester);
    await _tap(tester, find.text(l10n.tabConfiguration));
    await _tap(tester, find.widgetWithText(OutlinedButton, l10n.archiveAction));
    expect(find.text(l10n.archivedBanner), findsOneWidget);
    expect(
      tester
          .widget<DropdownButtonFormField<ScoreMethod>>(
            find.byType(DropdownButtonFormField<ScoreMethod>),
          )
          .onChanged,
      isNull,
    );
    expect((await TableStore(database).load(id, _gm.id))!.archived, isTrue);

    await _tap(tester, find.widgetWithText(OutlinedButton, l10n.restoreAction));
    expect(find.text(l10n.archivedBanner), findsNothing);
    expect((await TableStore(database).activity(id)).map((a) => a.kind), [
      'restored',
      'archived',
    ]);
  });

  _testTable('joueur : pas d\'onglet Configuration', (tester) async {
    await _openTable(tester, gm: '00000000-0000-0000-0000-00000000000b');
    expect(find.text(l10n.youArePlayer.toUpperCase()), findsOneWidget);
    expect(find.text(l10n.tabOverview), findsOneWidget);
    expect(find.text(l10n.tabConfiguration), findsNothing);
    expect(find.text(l10n.activityEmpty), findsOneWidget);
  });

  _testTable('desktop : configuration et panneau côte à côte', (tester) async {
    await _openTable(tester, size: const Size(1440, 1100));
    await _tap(tester, find.text(l10n.tabConfiguration));
    await _choose<ScoreMethod>(tester, l10n.statMethod(ScoreMethod.pointBuy));
    expect(find.text(l10n.unsavedTitle), findsOneWidget);
    expect(find.text(l10n.whoIsNotifiedTitle), findsOneWidget);
  });
  _testTable('membres : invitation créée, code, 7 jours, révocation', (
    tester,
  ) async {
    final (database, id) = await _openTable(
      tester,
      size: const Size(1440, 1100),
    );
    await _tap(tester, find.text(l10n.tabMembers));
    await _tap(tester, find.text(l10n.inviteCreate));
    final invite = (await TableStore(database).watchInvite(id).first)!;
    expect(find.text(invite.code), findsOneWidget);
    expect(find.text(l10n.inviteExpires(7)), findsOneWidget);

    await _tap(tester, find.text(l10n.inviteRevoke));
    expect(find.text(invite.code), findsNothing);
    expect(find.text(l10n.inviteCreate), findsOneWidget);
  });

  _testTable('membres : pseudonymes, le MJ retire un joueur', (tester) async {
    final (database, id) = await _openTable(tester);
    await database.customStatement(
      'INSERT INTO table_member (id, table_id, user_id, role, joined_at) '
      "VALUES ('m8', ?, '00000000-0000-0000-0000-00000000000b', 'player', "
      "'2026-11-11T10:00:00Z')",
      [id],
    );
    await database.customStatement(
      'INSERT INTO profile (id, pseudonym, locale, settings) VALUES '
      "(?, 'Camille', 'fr', '{}'), "
      "('00000000-0000-0000-0000-00000000000b', 'Hugo', 'fr', '{}')",
      [_gm.id],
    );
    await _tap(tester, find.text(l10n.tabMembers));
    expect(find.text(l10n.membersCount(2)), findsOneWidget);
    expect(find.text(l10n.memberYou(l10n.roleGm)), findsOneWidget);
    expect(find.text('Hugo'), findsOneWidget);

    await _tap(tester, find.byType(PopupMenuButton<void>).last);
    await _tap(tester, find.text(l10n.removeMember));
    expect(find.text(l10n.removeMemberTitle('Hugo')), findsOneWidget);
    await _tap(tester, find.widgetWithText(FilledButton, l10n.removeAction));
    expect(find.text('Hugo'), findsNothing);
    expect(find.text(l10n.membersCount(1)), findsOneWidget);
  });

  _testTable('membres, téléphone : l\'invitation dans une feuille', (
    tester,
  ) async {
    await _openTable(tester);
    await _tap(tester, find.text(l10n.tabMembers));
    await _tap(tester, find.text(l10n.inviteTitle));
    expect(find.text(l10n.inviteHint), findsOneWidget);
    await _tap(tester, find.text(l10n.inviteCreate));
    expect(find.text(l10n.inviteExpires(7)), findsOneWidget);
  });

  _testTable('membres, joueur : ni invitation ni retrait', (tester) async {
    await _openTable(tester, gm: '00000000-0000-0000-0000-00000000000b');
    await _tap(tester, find.text(l10n.tabMembers));
    expect(find.text(l10n.inviteTitle), findsNothing);
    expect(find.byType(PopupMenuButton<void>), findsNothing);
    expect(find.text(l10n.removeNote), findsNothing);
  });
  _testTable('rejoindre par le lien : la table s\'ouvre', (tester) async {
    late String id;
    final gateway = FakeGateway();
    await _pump(
      tester,
      gateway: gateway,
      seed: (database) async {
        id = await TableStore(database).create(
          gmUserId: '00000000-0000-0000-0000-00000000000b',
          settings: _brumeval,
          packs: const [],
        );
        await database.customStatement(
          'INSERT INTO table_member (id, table_id, user_id, role, joined_at) '
          "VALUES ('m9', ?, ?, 'player', '2026-11-11T10:00:00Z')",
          [id, _gm.id],
        );
      },
    );
    gateway.joinReply = (_) => (tableId: id, error: null);
    GoRouter.of(tester.element(find.byType(TablesTab))).go('/rejoindre/k7q4zp');
    await tester.pumpAndSettle();
    expect(gateway.joins, ['K7Q4ZP']);
    expect(find.byType(TablePage), findsOneWidget);
    expect(find.text(l10n.youArePlayer.toUpperCase()), findsOneWidget);
  });

  _testTable('rejoindre, code saisi refusé : le motif', (tester) async {
    final gateway = FakeGateway()
      ..joinReply = (_) => (tableId: null, error: 'expired_code');
    await _pump(tester, gateway: gateway);
    await _tap(tester, find.text(l10n.joinTable));
    expect(find.byType(JoinPage), findsOneWidget);
    final join = find.widgetWithText(FilledButton, l10n.joinTable);
    expect(tester.widget<FilledButton>(join).onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'k7q4z');
    await tester.pump();
    expect(tester.widget<FilledButton>(join).onPressed, isNull);
    await tester.enterText(find.byType(TextField), 'k7q4zp');
    await tester.pump();
    expect(find.text('Z'), findsOneWidget);
    await _tap(tester, join);
    expect(gateway.joins, ['K7Q4ZP']);
    expect(find.text(l10n.joinErrorExpired), findsOneWidget);
  });

  _testTable('rejoindre hors ligne : en attente du réseau', (tester) async {
    final gateway = FakeGateway();
    await _pump(tester, gateway: gateway, online: false);
    GoRouter.of(tester.element(find.byType(TablesTab))).go('/rejoindre/K7Q4ZP');
    await tester.pumpAndSettle();
    expect(find.text(l10n.joinOfflineTitle), findsOneWidget);
    expect(find.text(l10n.joinWaiting), findsOneWidget);
    expect(find.text(l10n.joinWaitingHint), findsOneWidget);
    expect(gateway.joins, isEmpty);
  });
  _testTable('emplacements : le MJ en attribue, en retire un vide', (
    tester,
  ) async {
    final (database, id) = await _openTable(tester);
    await database.customStatement(
      'INSERT INTO table_member (id, table_id, user_id, role, joined_at) '
      "VALUES ('m8', ?, '00000000-0000-0000-0000-00000000000b', 'player', "
      "'2026-11-11T10:00:00Z')",
      [id],
    );
    await database.customStatement(
      'INSERT INTO profile (id, pseudonym, locale, settings) VALUES '
      "('00000000-0000-0000-0000-00000000000b', 'Hugo', 'fr', '{}')",
    );
    await _tap(tester, find.text(l10n.tabMembers));
    await _tap(tester, find.byType(PopupMenuButton<void>).last);
    await _tap(tester, find.text(l10n.assignSlot));
    expect(find.text(l10n.slotEmpty), findsOneWidget);
    final [slot] = await TableStore(database).watchSlots(id).first;
    expect(slot.playerUserId, '00000000-0000-0000-0000-00000000000b');

    await _tap(tester, find.byTooltip(l10n.removeSlot));
    expect(find.text(l10n.slotEmpty), findsNothing);
  });

  _testTable('mon personnage : créer, puis envoyer au MJ et reprendre', (
    tester,
  ) async {
    final (database, id) = await _openTable(
      tester,
      gm: '00000000-0000-0000-0000-00000000000b',
    );
    final store = TableStore(database);
    final slot = await store.createSlot(id, _gm.id);
    await tester.pumpAndSettle();
    expect(find.text(l10n.myCharacterTitle), findsOneWidget);
    expect(find.text(l10n.createMySheet), findsOneWidget);

    await database.customStatement(
      'INSERT INTO character (id, table_id, kind, name, species_id, '
      "background_id, status) VALUES ('c1', ?, 'pc', 'Aldric', "
      "'srd:species:human', 'srd:background:soldier', 'draft')",
      [id],
    );
    await store.fillSlot(slot, 'c1');
    await tester.pumpAndSettle();
    expect(find.text('Aldric'), findsOneWidget);
    expect(
      find.text(l10n.sheetLevelStatus(1, l10n.statusDraft)),
      findsOneWidget,
    );

    await _tap(tester, find.text(l10n.submitToGm));
    await _tap(tester, find.widgetWithText(FilledButton, l10n.submitAction));
    expect(await CharacterStore(database).status('c1'), 'submitted');
    expect(find.text(l10n.withdrawSheet), findsOneWidget);
    await _tap(tester, find.text(l10n.withdrawSheet));
    expect(await CharacterStore(database).status('c1'), 'draft');
  });

  _testTable('mon personnage : niveau de départ à atteindre avant l\'envoi', (
    tester,
  ) async {
    late String id;
    await _pump(
      tester,
      seed: (database) async {
        id = await TableStore(database).create(
          gmUserId: '00000000-0000-0000-0000-00000000000b',
          settings: _brumeval.copyWith(startingLevel: 3),
          packs: const [],
        );
        await database.customStatement(
          'INSERT INTO table_member (id, table_id, user_id, role, joined_at) '
          "VALUES ('m9', ?, ?, 'player', '2026-11-11T10:00:00Z')",
          [id, _gm.id],
        );
        await database.customStatement(
          'INSERT INTO character (id, table_id, kind, name, species_id, '
          "background_id, status) VALUES ('c1', ?, 'pc', 'Aldric', "
          "'srd:species:human', 'srd:background:soldier', 'draft')",
          [id],
        );
        final slot = await TableStore(database).createSlot(id, _gm.id);
        await TableStore(database).fillSlot(slot, 'c1');
      },
    );
    GoRouter.of(tester.element(find.byType(TablesTab))).go('/tables/$id');
    await tester.pumpAndSettle();
    expect(find.text(l10n.reachStartingLevel(3)), findsOneWidget);
    expect(find.text(l10n.submitToGm), findsNothing);
  });
  _testTable('revue : contrôles, message, corrections avec commentaire', (
    tester,
  ) async {
    final (database, _, character) = await _withAldric(
      tester,
      status: 'submitted',
      message: 'Je garde l\'épée longue.',
    );
    expect(find.text(l10n.reviewTitle), findsOneWidget);
    expect(
      find.text(l10n.checkMethod(l10n.statMethod(ScoreMethod.pointBuy))),
      findsNothing,
    );
    // La table impose les valeurs standard : Aldric est en points.
    expect(
      find.text(
        l10n.checkMethodWrong(
          l10n.statMethod(ScoreMethod.pointBuy),
          l10n.statMethod(ScoreMethod.standardArray),
        ),
      ),
      findsOneWidget,
    );
    expect(find.text(l10n.checkLevel(1)), findsOneWidget);
    expect(find.text(l10n.checkRules), findsOneWidget);
    expect(
      find.text(l10n.playerMessage('Hugo', 'Je garde l\'épée longue.')),
      findsOneWidget,
    );

    final changes = find.widgetWithText(OutlinedButton, l10n.requestChanges);
    expect(tester.widget<OutlinedButton>(changes).onPressed, isNull);
    await tester.enterText(
      find.widgetWithText(TextField, l10n.reviewCommentLabel),
      'Passe aux valeurs standard.',
    );
    await tester.pump();
    await _tap(tester, changes);
    expect(
      await CharacterStore(database).status(character),
      'changes_requested',
    );
    expect(find.text(l10n.reviewTitle), findsNothing);
  });

  _testTable('revue : le MJ valide', (tester) async {
    final (database, _, character) = await _withAldric(
      tester,
      status: 'submitted',
    );
    await _tap(tester, find.widgetWithText(FilledButton, l10n.validateSheet));
    expect(await CharacterStore(database).status(character), 'validated');
    expect(
      find.text(l10n.slotLineOf('Aldric Varenne', l10n.statusValidated)),
      findsOneWidget,
    );
  });

  _testTable('transfert : l\'emplacement et la fiche passent au MJ', (
    tester,
  ) async {
    final (database, id, _) = await _withAldric(tester, status: 'draft');
    await _tap(tester, find.byTooltip(l10n.transferSlot));
    expect(find.text(l10n.transferTitle('Aldric Varenne')), findsOneWidget);
    await _tap(tester, find.text('Camille').last);
    final [slot] = await TableStore(database).watchSlots(id).first;
    expect(slot.playerUserId, _gm.id);
  });

  _testTable('joueur : envoi avec message, puis commentaire du MJ', (
    tester,
  ) async {
    final (database, id) = await _openTable(
      tester,
      gm: '00000000-0000-0000-0000-00000000000b',
    );
    await CharacterStore(database).save('c1', _aldric(), tableId: id);
    final store = TableStore(database);
    await store.fillSlot(await store.createSlot(id, _gm.id), 'c1');
    await tester.pumpAndSettle();

    await _tap(tester, find.text(l10n.submitToGm));
    await tester.enterText(
      find.widgetWithText(TextField, l10n.submitMessageLabel),
      'Prêt pour la séance 1.',
    );
    await _tap(tester, find.widgetWithText(FilledButton, l10n.submitAction));
    final [submitted] = await store.watchSlots(id).first;
    expect(submitted.status, 'submitted');
    expect(submitted.submitMessage, 'Prêt pour la séance 1.');

    await CharacterStore(database)
        .review('c1', validated: false, comment: 'Remplace la botte.');
    await tester.pumpAndSettle();
    expect(find.text(l10n.correctionsTitle), findsOneWidget);
    expect(find.text('Remplace la botte.'), findsOneWidget);
    expect(find.text(l10n.submitToGm), findsOneWidget);
  });
}
