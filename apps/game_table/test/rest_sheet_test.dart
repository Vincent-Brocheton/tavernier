// Spec character-sheet : « Repos court », « Repos long », « Suivi des PV et des
// ressources ».
import 'dart:convert';
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/creation/creation_providers.dart';
import 'package:game_table/l10n/app_localizations.dart';
import 'package:game_table/sheet/sheet_page.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

const _secondWind = 'srd:resource:second-wind';

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

/// Guerrier 1, Aldric niveau 1 de [D1] : 12 PV, CON +2.
CharacterInput _aldric(int level) {
  const dir = '../../packages/dnd_rules/test/fixtures/d1';
  final data = jsonDecode(
    File('$dir/aldric_n1.json').readAsStringSync(),
  ) as Map<String, Object?>;
  final character = CharacterInput.fromJson(
    data['input']! as Map<String, Object?>,
  );
  return character.copyWith(
    classLevels: [character.classLevels.single.copyWith(level: level)],
  );
}

late CharacterStore _store;

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 3; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pumpAndSettle();
  }
}

Future<void> _open(
  WidgetTester tester,
  PlayState play, {
  int level = 3,
  double width = 1440,
}) async {
  tester.view.physicalSize = Size(width, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final database = TavernierDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  _store = CharacterStore(database);
  await tester.runAsync(() async {
    await _store.save('a', _aldric(level));
    await _store.saveState('a', play);
  });
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const SheetPage(id: 'a'),
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        contentProvider.overrideWith((ref) => _content),
        characterStoreProvider.overrideWith((ref) => _store),
      ],
      child: MaterialApp.router(
        theme: AppTheme.dark,
        routerConfig: router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await _settle(tester);
}

Future<PlayState> _saved(WidgetTester tester) async =>
    (await tester.runAsync(() => _store.loadState('a')))!;

Future<void> _rest(WidgetTester tester, String label) async {
  await tester.tap(find.widgetWithText(OutlinedButton, label));
  await tester.pumpAndSettle();
}

void main() {
  // Guerrier 3 : 10 + 2 × 6 + 3 × 2 = 28 PV, 3 d10.
  testWidgets('PV actuels modifiables', (tester) async {
    await _open(tester, const PlayState());
    expect(find.text('PV 28 / 28'), findsOneWidget);
    await tester.tap(find.byTooltip('Perdre 1 PV'));
    await _settle(tester);
    expect(find.text('PV 27 / 28'), findsOneWidget);
    expect((await _saved(tester)).hpCurrent, 27);
  });

  testWidgets('repos court : un dé saisi', (tester) async {
    await _open(tester, const PlayState(hpCurrent: 10));
    await _rest(tester, 'Repos court');
    expect(find.text('restants : 3 / 3 d10'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '7');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dépenser le d10'));
    await tester.pumpAndSettle();
    expect(find.text('10 → 19 / 28'), findsOneWidget);
    expect(find.text('restants : 2 / 3 d10'), findsOneWidget);
    await tester.tap(find.text('Terminer le repos court'));
    await _settle(tester);
    final state = await _saved(tester);
    expect(state.hpCurrent, 19);
    expect(state.usedOf(hitDieResource('d10')), 1);
  });

  testWidgets('jet hors du dé : refusé', (tester) async {
    await _open(tester, const PlayState(hpCurrent: 10));
    await _rest(tester, 'Repos court');
    await tester.enterText(find.byType(TextField), '11');
    await tester.pumpAndSettle();
    final button = tester.widget<OutlinedButton>(
      find.widgetWithText(OutlinedButton, 'Dépenser le d10'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('lancer un dé : soigne', (tester) async {
    await _open(tester, const PlayState(hpCurrent: 10));
    await _rest(tester, 'Repos court');
    await tester.tap(find.widgetWithText(OutlinedButton, 'Lancer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dépenser le d10'));
    await tester.pumpAndSettle();
    expect(find.text('restants : 2 / 3 d10'), findsOneWidget);
  });

  testWidgets('annuler : rien ne change', (tester) async {
    await _open(tester, const PlayState(hpCurrent: 10));
    await _rest(tester, 'Repos court');
    await tester.tap(find.widgetWithText(OutlinedButton, 'Lancer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dépenser le d10'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Annuler'));
    await _settle(tester);
    final state = await _saved(tester);
    expect(state.hpCurrent, 10);
    expect(state.used, isEmpty);
  });

  testWidgets('repos court : ressource récupérée', (tester) async {
    await _open(tester, const PlayState(used: {_secondWind: 2}));
    await _rest(tester, 'Repos court');
    expect(find.text('Second souffle'), findsOneWidget);
    expect(find.text('0 → 1 / 2'), findsOneWidget);
    await tester.tap(find.text('Terminer le repos court'));
    await _settle(tester);
    expect((await _saved(tester)).usedOf(_secondWind), 1);
  });

  testWidgets('0 PV : repos bloqué', (tester) async {
    await _open(tester, const PlayState(hpCurrent: 0));
    await _rest(tester, 'Repos long');
    expect(find.text('Il faut au moins 1 PV pour se reposer.'), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Terminer le repos'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('repos long [P13]', (tester) async {
    await _open(
      tester,
      PlayState(
        hpCurrent: 20,
        exhaustion: 1,
        used: {hitDieResource('d10'): 2},
        concentrationSpellId: 'srd:spell:bless',
      ),
    );
    await _rest(tester, 'Repos long');
    expect(find.text('20 → 28 / 28'), findsOneWidget);
    expect(find.text('1 → 3 d10'), findsOneWidget);
    expect(find.text('1 → 0'), findsOneWidget);
    expect(find.text('Concentration terminée'), findsOneWidget);
    await tester.tap(find.text('Terminer le repos'));
    await _settle(tester);
    final state = await _saved(tester);
    expect(state.hpCurrent, isNull);
    expect(state.used[hitDieResource('d10')], isNull);
    expect(state.exhaustion, 0);
    expect(state.concentrationSpellId, isNull);
  });

  testWidgets('ressource dépensée depuis Aptitudes', (tester) async {
    await _open(tester, const PlayState());
    await tester.tap(find.text('Aptitudes'));
    await tester.pumpAndSettle();
    final tile = find.ancestor(
      of: find.text('Second souffle'),
      matching: find.byType(ListTile),
    );
    await tester.tap(
      find.descendant(of: tile, matching: find.text('Utiliser')),
    );
    await _settle(tester);
    expect((await _saved(tester)).usedOf(_secondWind), 1);
  });

  testWidgets('Inspiration : recevoir puis utiliser', (tester) async {
    await _open(tester, const PlayState());
    expect(find.text('Pas d’Inspiration héroïque'), findsOneWidget);
    await tester.tap(find.text('Recevoir'));
    await _settle(tester);
    expect((await _saved(tester)).heroicInspiration, isTrue);
    await tester.tap(find.text('Utiliser'));
    await _settle(tester);
    expect((await _saved(tester)).heroicInspiration, isFalse);
  });

  testWidgets('repos long d\'un humain : Inspiration obtenue', (tester) async {
    await _open(tester, const PlayState());
    await _rest(tester, 'Repos long');
    expect(find.text('Obtenue'), findsOneWidget);
  });

  testWidgets('format téléphone', (tester) async {
    await _open(tester, const PlayState(hpCurrent: 10), width: 390);
    await _rest(tester, 'Repos court');
    expect(tester.takeException(), isNull);
  });
}
