// Spec tables : « Repos de groupe » (US-38, EF-PJ-19, [J10]) : le joueur
// reçoit le repos sur sa fiche.
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
import 'package:game_table/sheet/sheet_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

const _hugo = 'hugo';

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
);

late TavernierDatabase _db;

/// Fiche d'Aldric (12 PV max), à 4 PV, ouverte par Hugo.
Future<void> _open(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  _db = TavernierDatabase(NativeDatabase.memory());
  addTearDown(_db.close);
  final store = CharacterStore(_db);
  await store.save('a', _aldric);
  await store.saveState(
    'a',
    changeHitPoints(const PlayState(), computeSheet(_aldric, _content), -8),
  );
  await _db.customStatement(
    "UPDATE character SET owner_user_id = ? WHERE id = 'a'",
    [_hugo],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        contentProvider.overrideWith((ref) => _content),
        databaseProvider.overrideWith((ref) => _db),
        myConflictsProvider.overrideWith((ref) => Stream.value(const [])),
        currentUserProvider.overrideWith(
          (ref) => Stream.value(
            const User(
              id: _hugo,
              appMetadata: {},
              userMetadata: {},
              aud: 'authenticated',
              createdAt: '2026-11-20T10:00:00Z',
            ),
          ),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.dark,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SheetPage(id: 'a'),
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
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await _settle(tester);
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
  _test('[J10] : repos reçu, un dé dépensé, fin signalée', (tester) async {
    await _open(tester);
    expect(find.text('Faire le repos'), findsNothing);

    final rest = (await tester.runAsync(
      () => GroupRestStore(
        _db,
      ).start(tableId: 't', sessionId: null, kind: 'short', characters: ['a']),
    ))!;
    await _settle(tester);
    expect(
      find.text('Le MJ lance un repos court pour le groupe.'),
      findsOneWidget,
    );

    await _tap(tester, find.text('Faire le repos'));
    expect(find.text('Aldric Varenne · demandé par Le MJ'), findsOneWidget);
    // d10 de 6 + CON 2 : 4 → 12 PV.
    await tester.enterText(find.byType(TextField).last, '6');
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Dépenser le d10'));
    await _tap(tester, find.text('Terminer le repos court'));

    final done = (await tester.runAsync(
      () => GroupRestStore(_db).watchDone(rest).first,
    ))!;
    expect(done, {
      'a': {'hit_dice': 1, 'hp_before': 4, 'hp_after': 12},
    });
    expect(find.text('Faire le repos'), findsNothing);
  });
}
