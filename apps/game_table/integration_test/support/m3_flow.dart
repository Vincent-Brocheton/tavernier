// Parcours du critère de sortie de M3 (cahier §3) : une rencontre de 30
// combattants menée sur téléphone, hors-ligne. La table est préparée en base
// (les tables demandent un compte) ; tout le reste se joue à l'écran.
// Partagé par le test d'intégration (base réelle, sur chaque plateforme) et
// par un test de widgets (base en mémoire).
import 'package:dnd_data/dnd_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/encounters/combat_page.dart';
import 'package:game_table/encounters/encounter_page.dart';
import 'package:game_table/sessions/session_page.dart';
import 'package:game_table/tables/table_page.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// MJ du parcours.
const m3Gm = '00000000-0000-0000-0000-0000000000a1';
const _player = '00000000-0000-0000-0000-0000000000a2';

/// Dernière action tentée : un échec en CI dit où il s'est arrêté.
String m3LastAction = '';

/// Identifiants préparés par [seedM3].
typedef M3Ids = ({String table, String session, String encounter});

/// Brumeval : Aldric, Mira, Thalia et Brannoc (niveau 5), présents à la
/// séance en cours ; « Le relais du Sel » oppose 20 bandits, 5 loups et un
/// vétéran : 30 combattants.
Future<M3Ids> seedM3(TavernierDatabase db) async {
  final tables = TableStore(db);
  final table = await tables.create(
    gmUserId: m3Gm,
    settings: const TableSettings(name: 'Les Marches de Brumeval'),
    packs: const [],
  );
  await db.customStatement(
    'INSERT INTO table_member (id, table_id, user_id, role, joined_at) '
    "VALUES (?, ?, ?, 'player', '2026-11-20T10:00:00Z')",
    ['m3-joueur', table, _player],
  );
  final characters = CharacterStore(db);
  const pcs = [
    ('m3-aldric', 'Aldric Varenne'),
    ('m3-mira', 'Mira Solen'),
    ('m3-thalia', 'Thalia'),
    ('m3-brannoc', 'Brannoc'),
  ];
  for (final (id, name) in pcs) {
    await characters.publishSummary(
      CharacterSummary(
        id: id,
        tableId: table,
        ownerUserId: _player,
        name: name,
        speciesId: 'srd:species:human',
        classes: const [(classId: 'srd:class:fighter', level: 5)],
        health: Health.unhurt,
      ),
    );
  }
  final session = await SessionStore(db).create(
    tableId: table,
    title: 'Le relais du Sel',
    date: DateTime(2026, 10, 30),
    status: SessionStatus.inProgress,
    present: [for (final (id, _) in pcs) id],
  );
  final encounters = EncounterStore(db);
  final encounter = await encounters.create(
    tableId: table,
    title: 'Le relais du Sel',
    sessionId: session,
  );
  await encounters.update(encounter, status: EncounterStatus.ready);
  for (final (monster, quantity) in [
    ('srd:monster:bandit', 20),
    ('srd:monster:wolf', 5),
    ('srd:monster:veteran', 1),
  ]) {
    await encounters.addGroup(
      encounter,
      kind: 'monster',
      refId: monster,
      quantity: quantity,
    );
  }
  return (table: table, session: session, encounter: encounter);
}

/// Pages du MJ, de la table au combat.
GoRouter m3Router(String table) => GoRouter(
  initialLocation: '/tables/$table',
  routes: [
    GoRoute(
      path: '/tables/:id',
      builder: (_, state) => TablePage(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/tables/:id/rencontres/:encounter/combat',
      builder: (_, state) => CombatPage(
        tableId: state.pathParameters['id']!,
        id: state.pathParameters['encounter']!,
      ),
    ),
    GoRoute(
      path: '/tables/:id/rencontres/:encounter',
      builder: (_, state) => EncounterPage(
        tableId: state.pathParameters['id']!,
        id: state.pathParameters['encounter']!,
      ),
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

Future<void> _settle(WidgetTester tester) async {
  // La base répond hors de l'horloge du test : on lui laisse le temps.
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.pumpAndSettle();
}

/// Attend que [target] apparaisse, après une écriture en base.
Future<void> _waitFor(WidgetTester tester, Finder target) async {
  m3LastAction = 'Attente de $target';
  for (var i = 0; i < 100 && target.evaluate().isEmpty; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.pumpAndSettle();
  expect(target, findsWidgets);
}

/// Fait défiler la liste verticale jusqu'à [target] : les listes de 30
/// combattants ne construisent que ce qui est à l'écran.
Future<void> _reveal(WidgetTester tester, Finder target) async {
  final list = find.byWidgetPredicate(
    (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
  );
  // Vers le bas, puis vers le haut si la cible était au-dessus.
  for (final dy in [-300.0, 300.0]) {
    for (var i = 0; i < 30 && target.evaluate().isEmpty; i++) {
      await tester.drag(list.first, Offset(0, dy));
      await tester.pumpAndSettle();
    }
  }
}

Future<void> _tap(WidgetTester tester, Finder target) async {
  m3LastAction = '$target';
  await _reveal(tester, target);
  await tester.ensureVisible(target.first);
  await tester.pumpAndSettle();
  await tester.tap(target.first);
  await _settle(tester);
}

Future<void> _keys(WidgetTester tester, String digits) async {
  for (final d in digits.split('')) {
    await _tap(tester, find.widgetWithText(OutlinedButton, d));
  }
}

/// La rencontre de 30 combattants, de son lancement à la clôture de la
/// séance, sans réseau.
Future<void> playM3(WidgetTester tester) async {
  await _waitFor(tester, find.text('Rencontres'));
  await _tap(tester, find.text('Rencontres'));
  await _tap(tester, find.text('Ouvrir'));
  await _tap(tester, find.text('Lancer la rencontre'));
  await _waitFor(tester, find.text('Commencer le round 1'));

  // Les monstres ont leur jet automatique ; le MJ saisit ceux des 4 PJ.
  for (final d20 in ['15', '12', '9', '6']) {
    m3LastAction = 'Initiative d’un PJ : $d20';
    final field = find.widgetWithText(TextField, 'd20');
    await _reveal(tester, field);
    await tester.ensureVisible(field.first);
    await tester.pumpAndSettle();
    // Sur le Web sans fenêtre, enterText n'atteint pas le champ : on écrit
    // par le champ lui-même, puis on valide, comme le ferait le clavier.
    final input = tester.widget<TextField>(field.first);
    input.controller!.text = d20;
    input.onSubmitted!(d20);
    await _settle(tester);
  }
  expect(find.text('Tous les jets sont saisis'), findsOneWidget);
  await _tap(tester, find.text('Commencer le round 1'));
  await _waitFor(tester, find.text('30 combattants'));
  expect(find.text('Round 1'), findsWidgets);

  // Dégâts sur deux cibles : un bandit et un loup.
  await _tap(tester, find.text('Bandit 1'));
  m3LastAction = 'Second ciblage : Loup 1';
  await _reveal(tester, find.text('Loup 1'));
  await tester.ensureVisible(find.text('Loup 1').first);
  await tester.pumpAndSettle();
  await tester.longPress(find.text('Loup 1').first);
  await tester.pumpAndSettle();
  expect(find.textContaining('Cibles : Bandit 1, Loup 1'), findsOneWidget);
  await _tap(tester, find.byTooltip('Dégâts'));
  await _keys(tester, '5');
  await _tap(tester, find.text('Appliquer 5 dégâts tranchants'));

  // Un état sur le vétéran.
  await _tap(tester, find.text('Vétéran'));
  await _tap(tester, find.byTooltip('État'));
  await _tap(tester, find.text('À terre'));
  // Un round par défaut : il expirerait pendant le round joué.
  await _tap(tester, find.text('Indéfinie'));
  await _tap(tester, find.text('Ajouter À terre'));

  // Un round entier, unité par unité, puis on annule le dernier tour.
  for (var turn = 0; turn < 40; turn++) {
    if (find.text('Round 2').evaluate().isNotEmpty) break;
    await _tap(tester, find.widgetWithText(FilledButton, 'Tour suivant'));
    // Un rappel de fin de tour se ferme sans rien décider.
    final close = find.widgetWithText(TextButton, 'Fermer');
    if (close.evaluate().isNotEmpty) await _tap(tester, close);
  }
  expect(find.text('Round 2'), findsWidgets);
  await _tap(tester, find.byTooltip('Annuler'));
  expect(find.text('Round 1'), findsWidgets);
  await _tap(tester, find.widgetWithText(FilledButton, 'Tour suivant'));

  // Fin de la rencontre, puis clôture de la séance.
  await _tap(tester, find.byType(PopupMenuButton<String>));
  await _tap(tester, find.text('Terminer la rencontre'));
  await _waitFor(tester, find.text('Clore et ranger dans la séance'));
  await _tap(tester, find.text('Clore et ranger dans la séance'));
  await _waitFor(tester, find.text('Résumé de la rencontre'));
  m3LastAction = 'Retour à la table';
  GoRouter.of(tester.element(find.byType(Navigator).first)).pop();
  await _settle(tester);
  await _tap(tester, find.text('Séances'));
  await _tap(tester, find.text('Le relais du Sel'));
  await _tap(tester, find.text('Clore la séance'));
  await _waitFor(
    tester,
    find.widgetWithText(FilledButton, 'Clore la séance 1'),
  );
  await _tap(tester, find.widgetWithText(FilledButton, 'Clore la séance 1'));
}
