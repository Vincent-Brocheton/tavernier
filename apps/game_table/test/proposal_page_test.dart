// Spec character-sheet : « Proposition du MJ envoyée » (US-34, EF-PJ-16, [F4a]).
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
import 'package:game_table/sheet/conflicts.dart';
import 'package:game_table/sheet/proposal_page.dart';
import 'package:game_table/sheet/sheet_page.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

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
  feats: [
    FeatInput(
      featId: 'srd:feat:alert',
      sourceType: 'species',
      sourceRef: 'srd:species:human',
    ),
  ],
);

late CharacterStore _store;

Future<void> _open(
  WidgetTester tester, {
  String me = 'camille',
  Widget home = const SheetPage(id: 'a'),
  Future<void> Function()? before,
}) async {
  tester.view.physicalSize = const Size(390, 3000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final database = TavernierDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  _store = CharacterStore(database);
  // Les flux de Drift ont besoin du vrai temps.
  await tester.runAsync(() async {
    await _store.save('a', _aldric, tableId: 't');
    await database.customStatement(
      "UPDATE character SET owner_user_id = 'hugo' WHERE id = 'a'",
    );
    await database.customStatement(
      'INSERT INTO game_table (id, gm_user_id, name, stat_method, '
      'long_rest_rule, hp_on_level_rule, progression_mode) VALUES '
      "('t', 'camille', 'Brumeval', 'pointBuy', 'fullHitPoints', 'average', "
      "'xp')",
    );
    await database.customStatement(
      "INSERT INTO profile (id, pseudonym) VALUES ('hugo', 'Hugo')",
    );
    await before?.call();
  });
  final router = GoRouter(
    initialLocation: '/x',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(body: Text('accueil')),
      ),
      GoRoute(path: '/x', builder: (_, _) => home),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        contentProvider.overrideWith((ref) => _content),
        characterStoreProvider.overrideWith((ref) => _store),
        myConflictsProvider.overrideWith((ref) => Stream.value(const [])),
        currentUserProvider.overrideWith(
          (ref) => Stream.value(
            User(
              id: me,
              appMetadata: const {},
              userMetadata: const {},
              aud: 'authenticated',
              createdAt: '2026-11-09T10:00:00Z',
            ),
          ),
        ),
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

/// Démonte l'app avant la fin : drift ferme ses requêtes observées par un
/// minuteur, qui doit partir avant la vérification finale.
void _test(String description, Future<void> Function(WidgetTester) body) =>
    testWidgets(description, (tester) async {
      await body(tester);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(Duration.zero);
    });

Future<void> _proposeSkilled() => _store.propose(
  characterId: 'a',
  tableId: 't',
  authorUserId: 'camille',
  kind: 'feat',
  change: const {'feats': <Object?>[]},
  reason: 'Motif',
);

void main() {
  _test('fiche d\'un joueur : le MJ peut proposer', (tester) async {
    await _open(tester);
    expect(find.text('Proposer une modification'), findsOneWidget);
  });

  _test('sa propre fiche : pas de proposition', (tester) async {
    await _open(tester, me: 'hugo');
    expect(find.text('Proposer une modification'), findsNothing);
  });

  _test('dons proposables : même catégorie, pas déjà pris', (tester) async {
    final [alert] = replaceableFeats(_content, _aldric);
    final eligible = {
      for (final e in eligibleFeats(_content, _aldric, alert)) '${e.id}',
    };
    expect(eligible, contains('srd:feat:skilled'));
    expect(eligible, isNot(contains('srd:feat:alert')));
    expect(eligible, isNot(contains('srd:feat:magic-initiate')));
    expect(eligible, isNot(contains('srd:feat:archery')));
  });

  _test('[F4a] : don, choix, aperçu, motif, envoi', (tester) async {
    await _open(tester, home: const ProposalPage(id: 'a'));
    expect(find.text('Proposer une modification à Hugo'), findsOneWidget);
    expect(find.text('Vigilant (Humain)'), findsOneWidget);

    await tester.tap(find.text('Par'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Doué').last);
    await tester.pumpAndSettle();
    expect(find.text('Choisir 3 (0/3)'), findsOneWidget);
    for (final skill in ['Histoire', 'Médecine', 'Dressage']) {
      await tester.ensureVisible(find.widgetWithText(FilterChip, skill));
      await tester.tap(find.widgetWithText(FilterChip, skill));
      await tester.pump();
    }
    expect(find.text('Choisir 3 (3/3)'), findsOneWidget);
    // Vigilant ajoute le bonus de maîtrise à l'Initiative : +3 → +1.
    expect(find.text('+3'), findsOneWidget);
    expect(find.text('+1'), findsOneWidget);

    bool canSend() =>
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Envoyer la proposition'),
            )
            .onPressed !=
        null;
    expect(canSend(), isFalse, reason: 'motif obligatoire');
    await tester.enterText(
      find.widgetWithText(TextField, 'Motif (obligatoire, visible du joueur)'),
      'Ton passé à la garde des Marches.',
    );
    await tester.pump();
    expect(canSend(), isTrue);

    await tester.ensureVisible(find.text('Envoyer la proposition'));
    await tester.tap(find.text('Envoyer la proposition'));
    await tester.pumpAndSettle();
    expect(find.text('Proposition envoyée à Hugo.'), findsOneWidget);
    final [proposal] = await tester.runAsync(
      () => _store.watchPendingProposals('a').first,
    ) as List<CharacterProposal>;
    expect(proposal.authorUserId, 'camille');
    expect(proposal.tableId, 't');
    expect(proposal.reason, 'Ton passé à la garde des Marches.');
    final [feat] = proposal.applyTo(_aldric).feats;
    expect(feat.featId, 'srd:feat:skilled');
    expect(feat.sourceRef, 'srd:species:human');
    expect(feat.choices, {
      'skilled': [
        'srd:skill:history',
        'srd:skill:medicine',
        'srd:skill:animal-handling',
      ],
    });
  });

  _test('en attente : le MJ le voit sur la fiche', (tester) async {
    await _open(tester, before: _proposeSkilled);
    expect(
      find.text('Proposition envoyée à Hugo : en attente de sa réponse.'),
      findsOneWidget,
    );
  });

  _test('refusée : le MJ lit le message', (tester) async {
    await _open(
      tester,
      before: () async {
        await _proposeSkilled();
        final [p] = await _store.watchPendingProposals('a').first;
        await _store.refuseProposal(p.id, 'Je garde Vigilant.');
      },
    );
    expect(find.text('Hugo a refusé votre proposition'), findsOneWidget);
    expect(find.text('Je garde Vigilant.'), findsOneWidget);
  });
}
