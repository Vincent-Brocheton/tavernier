// Parcours du critère de sortie de M1 (cahier §3) : un PJ complet créé puis
// monté au niveau 5, sans réseau. Partagé par le test d'intégration (base
// réelle, sur chaque plateforme) et par un test de widgets (base en mémoire).
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Nom du personnage du parcours.
const m1Name = 'Brunhild';

/// Dernière action tentée : un échec en CI dit où il s'est arrêté.
String m1LastAction = '';

Future<void> _settle(WidgetTester tester) async {
  // La base répond hors de l'horloge du test : on lui laisse le temps.
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder target) async {
  m1LastAction = '$target';
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await _settle(tester);
}

Future<void> _tapText(WidgetTester tester, String text) =>
    _tap(tester, find.text(text).first);

Future<void> _next(WidgetTester tester) =>
    _tap(tester, find.byType(FilledButton).last);

Future<void> _raise(WidgetTester tester, String ability, int times) async {
  m1LastAction = 'Augmenter $ability';
  final target = find.byTooltip('Augmenter $ability');
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  for (var i = 0; i < times; i++) {
    await tester.tap(target);
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

Future<void> _bonus(WidgetTester tester, String label) => _tap(
  tester,
  find.byWidgetPredicate((w) => w is BonusToggle && w.semanticLabel == label),
);

/// Crée une Guerrière naine Criminelle, puis la monte au niveau 5. La page
/// d'accueil doit être affichée.
Future<void> createAndReachLevel5(WidgetTester tester) async {
  await _settle(tester);
  await _tapText(tester, 'Personnages');
  await _tapText(tester, 'Nouveau personnage');

  // Classe, Historique, Espèce, Langues.
  await _tapText(tester, 'Guerrier');
  await _next(tester);
  await _tapText(tester, 'Criminel');
  await _next(tester);
  await _tapText(tester, 'Nain');
  await _next(tester);
  await _tapText(tester, 'Orc');
  await _tapText(tester, 'Elfique');
  await _next(tester);

  // Caractéristiques : 27 points, bonus d'Historique.
  await _raise(tester, 'Force', 7);
  await _raise(tester, 'Dextérité', 5);
  await _raise(tester, 'Constitution', 6);
  await _raise(tester, 'Sagesse', 4);
  await _raise(tester, 'Charisme', 2);
  expect(find.text('27 / 27 points'), findsOneWidget);
  await _bonus(tester, '+2 sur Constitution');
  await _bonus(tester, '+1 sur Dextérité');
  await _next(tester);

  // Sous-choix.
  await _tapText(tester, 'Perception');
  await _tapText(tester, 'Survie');
  await _tapText(tester, 'Épée longue · Sape');
  await _tapText(tester, 'Javeline · Ralentissement');
  await _tapText(tester, 'Hache d’armes · Renversement');
  await _tapText(tester, 'Défense');
  await _next(tester);

  // Équipement.
  await _tapText(tester, 'Lot A');
  await _tap(tester, find.text('Lot B').last);
  await _next(tester);

  // Détails, puis enregistrement.
  // Sur le Web sans fenêtre, enterText n'atteint pas le champ : on écrit
  // par le champ lui-même, comme le ferait le clavier.
  m1LastAction = 'Nom';
  final name = tester.widget<TextField>(
    find.descendant(
      of: find.byType(TextFormField).first,
      matching: find.byType(TextField),
    ),
  );
  name.controller!.text = m1Name;
  name.onChanged!(m1Name);
  await tester.pumpAndSettle();
  await _next(tester);
  m1LastAction = 'Récapitulatif de création';
  expect(find.text('Enregistrer'), findsOneWidget);
  await _next(tester);

  // La fiche, depuis la liste.
  await _tapText(tester, m1Name);
  expect(find.text('Monter au niveau 2'), findsOneWidget);

  for (var level = 2; level <= 5; level++) {
    await _tapText(tester, 'Monter au niveau $level');
    await _next(tester); // Classe : on reste Guerrière.
    await _next(tester); // Points de vie.
    if (level == 3) await _tapText(tester, 'Champion');
    if (level == 4) await _tapText(tester, 'Épée à deux mains');
    await _next(tester); // Aptitudes.
    if (level == 4) {
      await _tap(tester, find.widgetWithText(OutlinedButton, 'Suggérer'));
      await _next(tester); // Don.
    }
    m1LastAction = 'Récapitulatif du niveau $level';
    expect(find.text('Enregistrer'), findsOneWidget);
    await _next(tester);
    expect(
      find.text(level < 20 ? 'Monter au niveau ${level + 1}' : ''),
      findsOneWidget,
    );
  }
  expect(find.textContaining('Guerrier 5'), findsWidgets);
}
