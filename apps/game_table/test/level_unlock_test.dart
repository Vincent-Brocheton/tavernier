// Spec character-sheet : « Bandeau de montée de niveau » et « Dérogation du
// MJ » (US-35, EF-SEA-05, [S9]).
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
  String? mode = 'xp',
  int xp = 0,
  bool granted = false,
  Widget home = const SheetPage(id: 'a'),
  bool leveledUp = false,
}) async {
  tester.view.physicalSize = const Size(390, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final database = TavernierDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  _store = CharacterStore(database);
  await tester.runAsync(() async {
    if (mode != null) {
      await database.customStatement(
        'INSERT INTO game_table (id, gm_user_id, name, stat_method, '
        'long_rest_rule, hp_on_level_rule, progression_mode) '
        "VALUES ('t', 'camille', 'Brumeval', 'point_buy', 'full', "
        "'average', ?)",
        [mode],
      );
    }
    await _store.save(
      'a',
      _aldric.copyWith(xp: xp),
      tableId: mode == null ? null : 't',
    );
    await database.customStatement(
      "UPDATE character SET owner_user_id = 'hugo', status = 'validated' "
      "WHERE id = 'a'",
    );
    await database.customStatement(
      "INSERT INTO profile (id, pseudonym) VALUES ('camille', 'Camille')",
    );
    if (granted) {
      await _store.grantLevel(
        'a',
        level: 2,
        origin: 'milestone',
        byUserId: 'camille',
        reason: 'Varga capturée, le relais du Sel libéré',
      );
    }
    if (leveledUp) {
      await _store.recordLevelUp(
        'a',
        byUserId: 'hugo',
        from: 1,
        to: 2,
        unlock: const LevelUnlock(level: 2, origin: UnlockOrigin.milestone),
      );
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
        home: home,
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
      await tester.pump(const Duration(seconds: 1));
    });

void main() {
  _test('table en PX sous le seuil : progression, pas de bouton', (
    tester,
  ) async {
    await _open(tester, xp: 100);
    expect(find.text('100 / 300 PX'), findsOneWidget);
    expect(find.text('Monter au niveau 2'), findsNothing);
  });

  _test('seuil atteint : bandeau, « Plus tard » en puce et retour', (
    tester,
  ) async {
    await _open(tester, xp: 300);
    expect(find.text('Seuil de 300 PX atteint'), findsOneWidget);
    expect(find.text('Monter au niveau 2'), findsOneWidget);
    await tester.tap(find.text('Plus tard'));
    await tester.pumpAndSettle();
    expect(find.text('Seuil de 300 PX atteint'), findsNothing);
    expect(find.text('Monter au niveau 2'), findsNothing);
    await tester.tap(find.text('Niveau 2'));
    await tester.pumpAndSettle();
    expect(find.text('Monter au niveau 2'), findsOneWidget);
  });

  _test('table en jalons sans niveau accordé : rien, même avec des PX', (
    tester,
  ) async {
    await _open(tester, mode: 'milestone', xp: 9999);
    expect(find.textContaining(' PX'), findsNothing);
    expect(find.text('Monter au niveau 2'), findsNothing);
  });

  _test('niveau accordé en jalons : origine et motif', (tester) async {
    await _open(tester, mode: 'milestone', granted: true);
    expect(find.text('Niveau 2 accordé par Camille'), findsOneWidget);
    expect(
      find.text('Jalon : « Varga capturée, le relais du Sel libéré »'),
      findsOneWidget,
    );
    expect(find.text('Monter au niveau 2'), findsOneWidget);
  });

  _test('fiche hors table : montée libre', (tester) async {
    await _open(tester, mode: null);
    expect(find.text('Monter au niveau 2'), findsOneWidget);
    expect(find.textContaining(' PX'), findsNothing);
  });

  _test('dérogation du MJ : débloquée, inscrite dans l’historique', (
    tester,
  ) async {
    await _open(tester, me: 'camille', mode: 'milestone');
    await tester.tap(find.text('Débloquer le niveau 2'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Retard de création');
    await tester.tap(find.text('Débloquer'));
    await tester.pumpAndSettle();
    expect(
      find.text('Niveau 2 débloqué par Camille (dérogation)'),
      findsOneWidget,
    );
    expect(find.text('Débloquer le niveau 2'), findsNothing);
    final history = await tester.runAsync(() => _store.history('a'));
    expect(history!.single.detail, {
      'kind': 'level_grant',
      'level': 2,
      'origin': 'override',
      'reason': 'Retard de création',
    });
  });

  _test('historique : niveau accordé avec son motif, montée', (tester) async {
    await _open(
      tester,
      mode: 'milestone',
      granted: true,
      home: const HistoryPage(id: 'a'),
      leveledUp: true,
    );
    expect(find.text('Montée au niveau 2'), findsOneWidget);
    expect(find.text('Niveau 2 accordé'), findsOneWidget);
    expect(
      find.text('Jalon : « Varga capturée, le relais du Sel libéré »'),
      findsOneWidget,
    );
  });
}
