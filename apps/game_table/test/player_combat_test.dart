// Spec encounters : « Écran En combat du joueur » (US-36, EF-VJ-01 à 06,
// [J1] à [J3]).
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/account_providers.dart';
import 'package:game_table/account/sync_state.dart';
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
  items: [
    ItemInput(itemId: 'srd:weapon:longsword', quantity: 1, equipped: true),
  ],
);

var _next = 0;

CombatEvent _event(CombatEventType type, [Map<String, Object?> p = const {}]) =>
    CombatEvent(
      id: 'e${(_next++).toString().padLeft(4, '0')}',
      type: type,
      payload: p,
    );

CombatEvent _pc(String id, String label, int hp, int max, String owner) =>
    _event(CombatEventType.combatantAdded, {
      'id': id,
      'kind': 'pc',
      'ref_id': id,
      'owner': owner,
      'label': label,
      'hp': hp,
      'hp_max': max,
    });

CombatEvent _foe(String id, String label) =>
    _event(CombatEventType.combatantAdded, {
      'id': id,
      'kind': 'monster',
      'label': label,
      'hp': 11,
      'hp_max': 11,
      'ac': 12,
    });

/// [J1] : round 3, tour du Chef de bande ; Aldric (fiche `a`) joue dans
/// 2 tours, Béni par Mira.
List<CombatEvent> _j1() => [
  _pc('thalia', 'Thalia', 33, 33, 'leo'),
  _foe('chef', 'Chef de bande'),
  _foe('loup', 'Loup 2'),
  _pc('a', 'Aldric Varenne', 41, 49, _hugo),
  _pc('mira', 'Mira Solen', 10, 38, 'ines'),
  for (final (unit, d) in [
    ('thalia', 22),
    ('chef', 18),
    ('loup', 15),
    ('a', 14),
    ('mira', 9),
  ])
    _event(CombatEventType.initiativeRolled, {
      'unit': unit,
      'dice': [d],
    }),
  _event(CombatEventType.combatStarted),
  _event(CombatEventType.tempHp, {
    'targets': ['a'],
    'amount': 5,
  }),
  _event(CombatEventType.concentrationStarted, {
    'combatant': 'mira',
    'spell': 'Bénédiction',
  }),
  _event(CombatEventType.conditionAdded, {
    'combatant': 'a',
    'instance': 'beni',
    'label': 'Béni',
    'duration': {'kind': 'rounds', 'rounds': 10},
    'concentration': 'mira',
  }),
  for (var i = 0; i < 5 * 2 + 1; i++) _event(CombatEventType.turnAdvanced),
];

late TavernierDatabase _db;

Future<void> _open(
  WidgetTester tester,
  List<CombatEvent> events, {
  String me = _hugo,
  SyncIndicatorState sync = SyncIndicatorState.synced,
}) async {
  tester.view.physicalSize = const Size(390, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  _db = TavernierDatabase(NativeDatabase.memory());
  addTearDown(_db.close);
  await CharacterStore(_db).save('a', _aldric);
  await _db.customStatement(
    "UPDATE character SET owner_user_id = ? WHERE id = 'a'",
    [_hugo],
  );
  await CombatViewStore(_db).publish(
    encounterId: 'embuscade',
    tableId: 't',
    payload: {
      ...playerCombatView(projectCombat(events)),
      'title': 'Embuscade sur la route',
    },
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        contentProvider.overrideWith((ref) => _content),
        databaseProvider.overrideWith((ref) => _db),
        myConflictsProvider.overrideWith((ref) => Stream.value(const [])),
        syncIndicatorProvider.overrideWith((ref) => (state: sync, pending: 0)),
        currentUserProvider.overrideWith(
          (ref) => Stream.value(
            User(
              id: me,
              appMetadata: const {},
              userMetadata: const {},
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

Future<List<CombatRequest>> _requests(WidgetTester tester) async =>
    (await tester.runAsync(
      () => CombatRequestStore(_db).watch('embuscade').first,
    ))!;

/// Démonte l'app avant la fin : drift ferme ses requêtes observées par un
/// minuteur, qui doit partir avant la vérification finale.
void _test(String description, Future<void> Function(WidgetTester) body) =>
    testWidgets(description, (tester) async {
      await body(tester);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

void main() {
  _test('[J1] : bandeau, PV, Béni, ordre simplifié', (tester) async {
    await _open(tester, _j1());
    expect(find.text('Embuscade sur la route · round 3'), findsOneWidget);
    expect(
      find.text('Tour : Chef de bande · vous jouez dans 2 tours'),
      findsOneWidget,
    );
    expect(find.text('41 / 49'), findsOneWidget);
    expect(find.text('+5 PV temp.'), findsOneWidget);
    expect(find.text('Réaction disponible'), findsOneWidget);
    expect(find.text('Béni'), findsOneWidget);
    expect(find.text('de Mira Solen · concentration'), findsOneWidget);
    expect(find.text('8 rd'), findsOneWidget);
    expect(find.text('Adversaire'), findsNWidgets(2));
    expect(find.text('joue en ce moment'), findsOneWidget);
    expect(find.text('vous'), findsOneWidget);
    expect(find.text('Indemne'), findsOneWidget);
    expect(find.text('Gravement blessé'), findsOneWidget);
    expect(find.text('Finir mon tour'), findsNothing);
  });

  _test('dégâts envoyés au MJ, en attente', (tester) async {
    await _open(tester, _j1());
    await _tap(tester, find.widgetWithText(FilledButton, 'Dégâts'));
    await tester.enterText(find.byType(TextField), '7');
    await _tap(tester, find.text('Envoyer au MJ'));
    final requests = await _requests(tester);
    expect(requests.single.type, 'damage');
    expect(requests.single.payload, {'amount': 7});
    expect(requests.single.characterId, 'a');
    expect(requests.single.authorUserId, _hugo);
    expect(find.text('1 changement en attente du MJ'), findsOneWidget);
  });

  _test('Fiche complète, puis retour au combat', (tester) async {
    await _open(tester, _j1());
    await _tap(tester, find.text('Fiche complète'));
    expect(find.text('En combat · Embuscade sur la route'), findsOneWidget);
    expect(find.text('Principal'), findsOneWidget);
    await _tap(tester, find.text('Revenir au combat'));
    expect(find.text('41 / 49'), findsOneWidget);
  });

  _test('[J2] : son tour, économie d\'actions, Finir mon tour', (tester) async {
    await _open(tester, [
      ..._j1(),
      _event(CombatEventType.turnAdvanced),
      _event(CombatEventType.turnAdvanced),
    ]);
    expect(find.text('C’est votre tour'), findsOneWidget);
    await _tap(tester, find.widgetWithText(FilterChip, 'Déplacement'));
    expect(
      tester
          .widget<FilterChip>(find.widgetWithText(FilterChip, 'Déplacement'))
          .selected,
      isTrue,
    );
    await _tap(tester, find.text('Finir mon tour'));
    expect((await _requests(tester)).single.type, 'turn_advanced');
  });

  _test('[J5] : test de concentration demandé, réussite envoyée', (
    tester,
  ) async {
    await _open(tester, [
      ..._j1(),
      _event(CombatEventType.concentrationStarted, {
        'combatant': 'a',
        'spell': 'Bouclier de la foi',
      }),
      _event(CombatEventType.damage, {
        'targets': ['a'],
        'amount': 12,
        'type': 'srd:damage-type:slashing',
      }),
    ]);
    expect(find.text('Jet de sauvegarde demandé'), findsOneWidget);
    expect(
      find.text('Concentration sur Bouclier de la foi · DD 10'),
      findsOneWidget,
    );
    // Guerrier : JS de CON maîtrisé, +2 +2 ; 6 + 4 = 10.
    await tester.enterText(find.byType(TextField), '6');
    await _tap(tester, find.text('Envoyer au MJ'));
    final request = (await _requests(tester)).single;
    expect(request.type, 'concentration_check');
    expect(request.payload, {'success': true});
  });

  _test('jet contre la mort : 20 envoyé', (tester) async {
    await _open(tester, [
      ..._j1(),
      _event(CombatEventType.damage, {
        'targets': ['a'],
        'amount': 46,
        'type': 'srd:damage-type:slashing',
      }),
    ]);
    expect(find.text('Jets contre la mort'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '20');
    await _tap(tester, find.text('Envoyer au MJ'));
    expect((await _requests(tester)).single.payload, {'outcome': 'nat20'});
  });

  _test('[J3] : hors-ligne, dernier état connu', (tester) async {
    await _open(tester, _j1(), sync: SyncIndicatorState.offline);
    expect(
      find.textContaining('Hors-ligne : dites vos changements au MJ.'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Embuscade sur la route · round 3 · dernier état'),
      findsOneWidget,
    );
    expect(find.textContaining('vous jouez dans'), findsNothing);
  });

  _test('le MJ qui ouvre la fiche reste sur la fiche', (tester) async {
    await _open(tester, _j1(), me: 'camille');
    expect(find.text('Principal'), findsOneWidget);
    expect(
      find.text('Tour : Chef de bande · vous jouez dans 2 tours'),
      findsNothing,
    );
  });
}
