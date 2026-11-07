// Spec character-sheet : « Termes cliquables ».
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/l10n/app_localizations.dart';
import 'package:game_table/sheet/rule_text.dart';
import 'package:material_ui/material_ui.dart';

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

Future<void> _open(WidgetTester tester, String text) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: RuleText(text, content: _content)),
    ),
  );
  await tester.pumpAndSettle();
}

/// Lien annoncé au lecteur d'écran.
Finder _link(String label) => find.byWidgetPredicate(
  (w) =>
      w is Semantics &&
      w.properties.label == label &&
      (w.properties.link ?? false),
);

void main() {
  testWidgets('Désavantage ouvre sa définition', (tester) async {
    await _open(tester, 'La cible subit le Désavantage à son jet.');
    await tester.tap(find.text('Désavantage'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('ne retenez que le résultat le plus faible'),
      findsOneWidget,
    );
    expect(find.text('Glossaire · SRD 5.2.1'), findsOneWidget);
  });

  testWidgets('un état ouvre son texte', (tester) async {
    await _open(tester, 'La cible subit l’état À terre.');
    await tester.tap(find.text('À terre'));
    await tester.pumpAndSettle();
    expect(find.text('À terre'), findsWidgets);
    expect(find.text('Fermer'), findsOneWidget);
  });

  testWidgets('nom composé en milieu de phrase', (tester) async {
    await _open(tester, 'Par une action Bonus, buvez.');
    expect(_link('Action Bonus, définition'), findsOneWidget);
  });

  testWidgets('minuscule : pas de lien', (tester) async {
    await _open(tester, 'Vous avez un avantage certain.');
    expect(_link('Avantage, définition'), findsNothing);
  });

  testWidgets('dans un autre mot : pas de lien', (tester) async {
    await _open(tester, 'Avantages divers.');
    expect(_link('Avantage, définition'), findsNothing);
  });

  testWidgets('deux termes, sans perdre le texte', (tester) async {
    await _open(tester, 'Avantage puis Réaction, fin.');
    expect(_link('Avantage, définition'), findsOneWidget);
    expect(_link('Réaction, définition'), findsOneWidget);
    expect(find.textContaining(', fin.', findRichText: true), findsOneWidget);
  });
}
