// Spec character-sheet : « Proposition du MJ reçue » (US-34, EF-PJ-16, [F4b]).
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
import 'package:game_table/sheet/history_page.dart';
import 'package:game_table/sheet/sheet_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

const _alert = FeatInput(
  featId: 'srd:feat:alert',
  sourceType: 'species',
  sourceRef: 'srd:species:human',
);

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
  feats: [_alert],
);

User _user(String id) => User(
  id: id,
  appMetadata: const {},
  userMetadata: const {},
  aud: 'authenticated',
  createdAt: '2026-11-09T10:00:00Z',
);

late CharacterStore _store;

Future<void> _open(
  WidgetTester tester, {
  String me = 'hugo',
  bool propose = true,
  bool accepted = false,
  Map<String, Object?>? change,
  Widget? home,
}) async {
  tester.view.physicalSize = const Size(390, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final database = TavernierDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  _store = CharacterStore(database);
  // Les flux de Drift ont besoin du vrai temps.
  await tester.runAsync(() async {
    await _store.save('a', _aldric, tableId: 't');
    await _store.saveState('a', const PlayState(hpCurrent: 7));
    await database.customStatement(
      "UPDATE character SET owner_user_id = 'hugo' WHERE id = 'a'",
    );
    await database.customStatement(
      "INSERT INTO profile (id, pseudonym) VALUES ('camille', 'Camille')",
    );
    if (propose) {
      await _store.propose(
        characterId: 'a',
        tableId: 't',
        authorUserId: 'camille',
        kind: 'feat',
        change:
            change ??
            {
              'feats': [
                const FeatInput(
                  featId: 'srd:feat:skilled',
                  sourceType: 'species',
                  sourceRef: 'srd:species:human',
                  choices: {
                    'skilled': [
                      'srd:skill:history',
                      'srd:skill:medicine',
                      'srd:skill:animal-handling',
                    ],
                  },
                ).toJson(),
              ],
            },
        reason: 'Ton passé à la garde des Marches.',
      );
      if (accepted) {
        final [proposal] = await _store.watchPendingProposals('a').first;
        await _store.acceptProposal(proposal, playerUserId: 'hugo');
      }
    }
  });
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        contentProvider.overrideWith((ref) => _content),
        characterStoreProvider.overrideWith((ref) => _store),
        myConflictsProvider.overrideWith((ref) => Stream.value(const [])),
        currentUserProvider.overrideWith((ref) => Stream.value(_user(me))),
      ],
      child: MaterialApp(
        theme: AppTheme.dark,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: home ?? const SheetPage(id: 'a'),
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

const _title = 'Camille propose : remplacer le don Vigilant par Doué';

void main() {
  _test('[F4b] : motif, aperçu avant et après', (tester) async {
    await _open(tester);
    expect(find.text(_title), findsOneWidget);
    expect(
      find.text('Motif : « Ton passé à la garde des Marches. »'),
      findsOneWidget,
    );
    // Vigilant ajoute le bonus de maîtrise à l'Initiative (SRD) : +3 → +1.
    expect(find.text('Initiative'), findsWidgets);
    expect(find.text('+3'), findsWidgets);
    // Soldat (Athlétisme, Intimidation) et Guerrier (Perception, Survie).
    expect(find.text('4 compétences'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) =>
            w is Text &&
            '${w.data}'.startsWith('+ ') &&
            ['Histoire', 'Médecine', 'Dressage'].every(w.data!.contains),
      ),
      findsOneWidget,
    );
    expect(find.text('Accepter'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  _test('accepter : don remplacé, PV gardés', (tester) async {
    await _open(tester);
    await tester.tap(find.text('Accepter'));
    await tester.pumpAndSettle();
    expect(find.text(_title), findsNothing);
    final saved = (await _store.load('a'))!;
    expect(saved.feats.single.featId, 'srd:feat:skilled');
    expect((await _store.loadState('a')).hpCurrent, 7);
  });

  _test('historique : proposition acceptée, auteur et motif', (tester) async {
    await _open(tester, accepted: true, home: const HistoryPage(id: 'a'));
    expect(
      find.text('Proposition acceptée : remplacer le don Vigilant par Doué'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Proposée par Camille · Motif : « Ton passé à la garde des Marches. »',
      ),
      findsOneWidget,
    );
  });

  _test('refuser avec un message : fiche inchangée', (tester) async {
    await _open(tester);
    await tester.enterText(find.byType(TextField), 'Je garde Vigilant.');
    await tester.tap(find.text('Refuser'));
    await tester.pumpAndSettle();
    expect(find.text(_title), findsNothing);
    expect(await _store.load('a'), _aldric);
  });

  _test('modification illisible : fiche affichée, refus seul', (tester) async {
    await _open(
      tester,
      change: {
        'feats': [
          {'feat_id': 3},
        ],
      },
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Camille propose : modifier la fiche'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Accepter'))
          .onPressed,
      isNull,
    );
    expect(find.text('Refuser'), findsOneWidget);
  });

  _test('vue par le MJ : pas d\'encadré', (tester) async {
    await _open(tester, me: 'camille');
    expect(find.text(_title), findsNothing);
  });
}
