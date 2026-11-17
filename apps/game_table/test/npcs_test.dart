// Spec tables : « Onglet des PNJ », « Nouveau PNJ en bloc de stats »,
// « Fiche d'un PNJ en bloc de stats » (US-18, EF-PNJ-01, EF-PNJ-02,
// EF-ACT-06, [F4], [G5], [C2]).
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
import 'package:game_table/l10n/app_localizations.dart';
import 'package:game_table/npcs/new_npc_page.dart';
import 'package:game_table/npcs/npc_page.dart';
import 'package:game_table/npcs/stat_block_view.dart';
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

/// Brumeval de Camille, avec Hugo ; ouvre [location] (par défaut la table)
/// vue par [me].
Future<void> _open(
  WidgetTester tester, {
  String me = _camille,
  Future<void> Function(NpcStore)? seed,
  String Function(String table)? location,
}) async {
  tester.view.physicalSize = const Size(390, 2400);
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
    await seed?.call(NpcStore(_db));
  });
  final router = GoRouter(
    initialLocation: location?.call(_table) ?? '/tables/$_table',
    routes: [
      GoRoute(
        path: '/tables/:id',
        builder: (_, state) => TablePage(id: state.pathParameters['id']!),
      ),
      // Assistant et fiche de personnage : ce que le PNJ y envoie.
      GoRoute(
        path: '/characters/new',
        builder: (_, state) => Scaffold(body: Text('assistant ${state.uri}')),
      ),
      GoRoute(
        path: '/characters/:id',
        builder: (_, state) =>
            Scaffold(body: Text('fiche ${state.pathParameters['id']}')),
      ),
      GoRoute(
        path: '/tables/:id/pnj/nouveau',
        builder: (_, state) => NewNpcPage(tableId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/tables/:id/pnj/:npc',
        builder: (_, state) => NpcPage(
          tableId: state.pathParameters['id']!,
          id: state.pathParameters['npc']!,
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
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// PNJ de la table, lus sans flux observé : (nom, dossier, monstre, attitude).
Future<List<(String, String?, String?, String)>> _npcs(
  WidgetTester tester,
) async {
  final rows = await tester.runAsync(
    () => _db
        .customSelect(
          'SELECT name, folder, monster_id, attitude FROM npc_statblock '
          'WHERE table_id = ? ORDER BY name',
          variables: [Variable.withString(_table)],
        )
        .get(),
  );
  return [
    for (final r in rows!)
      (
        r.read<String>('name'),
        r.readNullable<String>('folder'),
        r.readNullable<String>('monster_id'),
        r.read<String>('attitude'),
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

Future<void> _brumevalNpcs(NpcStore store) async {
  await store.create(
    tableId: _table,
    name: 'Varga la Balafrée',
    folder: 'Guilde du Sel',
    monsterId: 'srd:monster:bandit-captain',
    attitude: Attitude.hostile,
  );
  await store.create(
    tableId: _table,
    name: 'Sergent Varel',
    monsterId: 'srd:monster:veteran',
  );
}

MonsterData _monster(String slug) =>
    _content.entity('srd:monster:$slug')!.data as MonsterData;

Future<void> _pumpStatBlock(WidgetTester tester, String slug) async {
  tester.view.physicalSize = const Size(390, 3000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: StatBlockView(monster: _monster(slug), content: _content),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('profil du chef de bande, tel qu\'imprimé [C2]', (tester) async {
    await _pumpStatBlock(tester, 'bandit-captain');
    for (final shown in [
      'Humanoïde de taille M ou P, Neutre',
      '15',
      '+3 (13)',
      '52 (8d8 + 16)',
      '9 m',
      'FOR 15',
      'JS +4',
      'DEX 16',
      'JS +5',
    ]) {
      expect(find.text(shown), findsWidgets, reason: shown);
    }
    String rich(String start) => tester
        .widgetList<RichText>(find.byType(RichText))
        .map((r) => r.text.toPlainText())
        .firstWhere((t) => t.startsWith(start), orElse: () => '');
    expect(rich('Compétences'), 'Compétences Athlétisme +4, Tromperie +4');
    expect(rich('Sens'), 'Sens Perception passive 10');
    expect(rich('Langues'), 'Langues argot des voleurs, commun');
    expect(rich('FP'), 'FP 2 (450 PX ; BM +2)');
    expect(find.text('Réactions'), findsOneWidget);
    expect(rich('Parade'), startsWith('Parade. Déclencheur'));
  });

  testWidgets('dragon noir adulte : antre, recharge, légendaires', (
    tester,
  ) async {
    await _pumpStatBlock(tester, 'adult-black-dragon');
    String rich(String start) => tester
        .widgetList<RichText>(find.byType(RichText))
        .map((r) => r.text.toPlainText())
        .firstWhere((t) => t.startsWith(start), orElse: () => '');
    expect(
      find.text('Dragon (Chromatique) de taille TG, Chaotique Mauvais'),
      findsOneWidget,
    );
    expect(find.text('12 m, nage 12 m, vol 24 m'), findsOneWidget);
    expect(
      rich('Sens'),
      'Sens Vision aveugle 18 m, Vision dans le noir 36 m ; '
      'Perception passive 21',
    );
    expect(rich('FP'), 'FP 14 (11 500 PX, ou 13 000 dans son antre ; BM +5)');
    expect(
      rich('Souffle d’acide'),
      startsWith('Souffle d’acide (recharge 5–6). '),
    );
    expect(
      rich('Résistance légendaire'),
      startsWith('Résistance légendaire (3/jour, ou 4/jour dans son antre). '),
    );
    expect(find.text('Actions Légendaires'), findsOneWidget);
    expect(
      find.text('Utilisations d’action Légendaire : 3 (4 dans son antre).'),
      findsOneWidget,
    );
  });

  _test('onglet du MJ : dossiers, monstre, attitude, filtres [F4]', (
    tester,
  ) async {
    await _open(tester, seed: _brumevalNpcs);
    await _tap(tester, find.text('PNJ'));
    expect(find.text('GUILDE DU SEL'), findsOneWidget);
    expect(find.text('SANS DOSSIER'), findsOneWidget);
    expect(find.text('Chef de bande · FP 2 · SRD'), findsOneWidget);
    expect(find.text('Hostile'), findsOneWidget);
    expect(find.text('Tous · 2'), findsOneWidget);
    await _tap(tester, find.text('Hostiles · 1'));
    expect(find.text('Varga la Balafrée'), findsOneWidget);
    expect(find.text('Sergent Varel'), findsNothing);
  });

  _test('joueur : pas d\'onglet PNJ', (tester) async {
    await _open(tester, me: _hugo, seed: _brumevalNpcs);
    expect(find.text('PNJ'), findsNothing);
  });

  _test('nouveau PNJ : monstre cherché, dossier, attitude, fiche [G5]', (
    tester,
  ) async {
    await _open(tester, location: (t) => '/tables/$t/pnj/nouveau');
    bool canCreate() =>
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Créer le PNJ'),
            )
            .onPressed !=
        null;
    expect(canCreate(), isFalse);
    await tester.enterText(
      find.widgetWithText(TextField, 'Nom *'),
      'Varga la Balafrée',
    );
    await tester.pump();
    expect(canCreate(), isFalse);

    await _tap(tester, find.text('Choisir un monstre'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Rechercher un monstre'),
      'chef de BANDE',
    );
    await tester.pumpAndSettle();
    expect(find.text('FP 2 · SRD 5.2.1'), findsOneWidget);
    await _tap(tester, find.text('Chef de bande'));
    expect(find.text('Chef de bande · SRD 5.2.1'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Dossier'),
      'Guilde du Sel',
    );
    await _tap(tester, find.text('Hostile'));
    await _tap(tester, find.text('Créer le PNJ'));

    expect(await _npcs(tester), [
      (
        'Varga la Balafrée',
        'Guilde du Sel',
        'srd:monster:bandit-captain',
        'hostile',
      ),
    ]);
    expect(find.text('PNJ · Brumeval'), findsOneWidget);
    expect(
      find.text('Variante de « Chef de bande » · SRD 5.2.1'),
      findsOneWidget,
    );
  });

  _test('fiche : attitude enregistrée, duplication', (tester) async {
    await _open(tester, seed: _brumevalNpcs);
    await _tap(tester, find.text('PNJ'));
    await _tap(tester, find.text('Sergent Varel'));
    expect(find.text('Attitude envers le groupe'), findsOneWidget);

    await _tap(tester, find.text('Amical'));
    expect(
      (await _npcs(tester)).firstWhere((n) => n.$1 == 'Sergent Varel').$4,
      'friendly',
    );

    await _tap(tester, find.text('Dupliquer'));
    expect(find.text('Sergent Varel (copie)'), findsOneWidget);
    expect(
      [for (final n in await _npcs(tester)) n.$1],
      ['Sergent Varel', 'Sergent Varel (copie)', 'Varga la Balafrée'],
    );
  });

  _test('informations cachées : ajout trié, validation, état gardé [C2]', (
    tester,
  ) async {
    late String varga;
    await _open(
      tester,
      seed: (store) async {
        varga = await store.create(
          tableId: _table,
          name: 'Varga la Balafrée',
          monsterId: 'srd:monster:bandit-captain',
          hiddenInfo: const [
            HiddenInfo(
              dc: 15,
              text: 'Porte le sceau de la Guilde du Sel.',
              revealed: true,
            ),
          ],
        );
      },
      location: (t) => '/tables/$t/pnj/$varga',
    );
    expect(find.text('Informations cachées'), findsOneWidget);
    expect(find.text('Révélée'), findsOneWidget);

    Future<void> fill(String dc, String info) async {
      await tester.enterText(find.widgetWithText(TextField, 'DD'), dc);
      await tester.enterText(
        find.widgetWithText(TextField, 'Information'),
        info,
      );
      await tester.pump();
    }

    bool canSave() =>
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Enregistrer'),
            )
            .onPressed !=
        null;

    await _tap(tester, find.text('Ajouter un palier'));
    await fill('0', 'Est la sœur cadette du bourgmestre Hesse.');
    expect(canSave(), isFalse);
    await fill('20', '   ');
    expect(canSave(), isFalse);
    await fill('20', 'Est la sœur cadette du bourgmestre Hesse.');
    await _tap(tester, find.text('Enregistrer'));

    await _tap(tester, find.text('Ajouter un palier'));
    await fill('10', 'Ancienne sergente de la garde de Brumeval.');
    await _tap(tester, find.text('Enregistrer'));

    Future<List<HiddenInfo>> stored() async {
      // L'écriture de la base finit hors du temps simulé du test.
      for (var i = 0; i < 3; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 20)),
        );
        await tester.pump();
      }
      return (await tester.runAsync(
        () => NpcStore(_db).watchList(_table).first,
      ))!.single.hiddenInfo;
    }

    expect([for (final h in await stored()) h.dc], [10, 15, 20]);
    expect(find.text('Cachée'), findsNWidgets(2));

    // Modifié, le palier révélé le reste.
    await _tap(tester, find.text('Porte le sceau de la Guilde du Sel.'));
    await fill('16', 'Porte le sceau de la Guilde du Sel.');
    await _tap(tester, find.text('Enregistrer'));
    expect(
      [for (final h in await stored()) (h.dc, h.revealed)],
      [(10, false), (16, true), (20, false)],
    );

    await _tap(tester, find.text('Est la sœur cadette du bourgmestre Hesse.'));
    await _tap(tester, find.text('Supprimer'));
    expect([for (final h in await stored()) h.dc], [10, 16]);
  });

  _test('modifier : nom et dossier, puis sans dossier', (tester) async {
    await _open(tester, seed: _brumevalNpcs);
    await _tap(tester, find.text('PNJ'));
    await _tap(tester, find.text('Sergent Varel'));

    await _tap(tester, find.byTooltip('Modifier'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Nom *'),
      'Sergent Varel de la garde',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Dossier'),
      'Brumeval',
    );
    await _tap(tester, find.text('Enregistrer'));
    expect(find.text('Sergent Varel de la garde'), findsOneWidget);

    GoRouter.of(tester.element(find.byType(NpcPage))).pop();
    await tester.pumpAndSettle();
    expect(find.text('BRUMEVAL'), findsOneWidget);

    await _tap(tester, find.text('Varga la Balafrée'));
    await _tap(tester, find.byTooltip('Modifier'));
    await tester.enterText(find.widgetWithText(TextField, 'Dossier'), '');
    await _tap(tester, find.text('Enregistrer'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    expect(
      (await _npcs(tester)).firstWhere((n) => n.$1 == 'Varga la Balafrée').$2,
      isNull,
    );
  });

  _test('nouveau PNJ en fiche complète : vers l\'assistant [G5]', (
    tester,
  ) async {
    await _open(tester, location: (t) => '/tables/$t/pnj/nouveau');
    await _tap(tester, find.text('Fiche complète'));
    expect(find.text('Choisir un monstre'), findsNothing);
    await tester.enterText(
      find.widgetWithText(TextField, 'Nom *'),
      'Maître Odran',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Dossier'),
      'Relais du Sel',
    );
    await _tap(tester, find.text('Amical'));
    await _tap(tester, find.text('Créer le PNJ'));
    final uri = Uri.parse(
      tester
          .widget<Text>(find.textContaining('assistant '))
          .data!
          .substring('assistant '.length),
    );
    expect(uri.path, '/characters/new');
    expect(uri.queryParameters, {
      'pnj': _table,
      'nom': 'Maître Odran',
      'dossier': 'Relais du Sel',
      'attitude': 'friendly',
    });
  });

  _test('PNJ en fiche complète : niveau, « Ouvrir la fiche », pas de copie', (
    tester,
  ) async {
    late String odran;
    await _open(
      tester,
      seed: (store) async {
        final input = CharacterInput.fromJson(
          (jsonDecode(
                File(
                  '../../packages/dnd_rules/test/fixtures/d1/'
                  'aldric_n1.json',
                ).readAsStringSync(),
              ) as Map<String, Object?>)['input']!
              as Map<String, Object?>,
        );
        await CharacterStore(_db)
            .save('odran', input.copyWith(kind: 'npc_full'), tableId: _table);
        odran = await store.create(
          tableId: _table,
          name: 'Maître Odran',
          characterId: 'odran',
        );
      },
    );
    await _tap(tester, find.text('PNJ'));
    expect(find.text('Fiche complète · niveau 1'), findsOneWidget);
    await _tap(tester, find.text('Maître Odran'));
    expect(odran, isNotEmpty);
    expect(find.text('Dupliquer'), findsNothing);
    expect(find.text('Attitude envers le groupe'), findsOneWidget);
    await _tap(tester, find.text('Ouvrir la fiche'));
    expect(find.text('fiche odran'), findsOneWidget);
  });
}
