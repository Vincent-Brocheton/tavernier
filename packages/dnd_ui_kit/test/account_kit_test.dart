// Spec ui-kit : « Variantes du bandeau d'état », « Règles du mot de passe ».
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Widget _app(Widget child) => MaterialApp(
  theme: AppTheme.dark,
  // Dans une liste, comme sur les écrans : les nœuds ne doivent pas fusionner.
  home: Scaffold(body: ListView(children: [child])),
);

void main() {
  group('StatusBanner', () {
    testWidgets('erreur sans titre : icône et message', (tester) async {
      await tester.pumpWidget(
        _app(const StatusBanner(message: 'E-mail ou mot de passe incorrect.')),
      );
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('E-mail ou mot de passe incorrect.'), findsOneWidget);
    });

    testWidgets('alerte : couleur d\'alerte, icône donnée', (tester) async {
      await tester.pumpWidget(
        _app(
          const StatusBanner(
            kind: StatusBannerKind.alert,
            icon: Icons.cloud_off,
            title: 'Pas de connexion internet',
            message: 'La première connexion demande le réseau.',
          ),
        ),
      );
      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
      expect(find.text('Pas de connexion internet'), findsOneWidget);
      final context = tester.element(find.byType(StatusBanner));
      final box = tester.widget<Container>(
        find.descendant(
          of: find.byType(StatusBanner),
          matching: find.byType(Container),
        ),
      );
      expect(
        (box.decoration! as BoxDecoration).color,
        GameColors.of(context).alertContainer,
      );
    });
  });

  testWidgets('StatusBanner information : primaryContainer et icône', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const StatusBanner(
          kind: StatusBannerKind.info,
          title: 'Vérifiez votre boîte mail',
          message: 'Un lien vient d’être envoyé.',
        ),
      ),
    );
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
    final context = tester.element(find.byType(StatusBanner));
    final box = tester.widget<Container>(
      find.descendant(
        of: find.byType(StatusBanner),
        matching: find.byType(Container),
      ),
    );
    expect(
      (box.decoration! as BoxDecoration).color,
      Theme.of(context).colorScheme.primaryContainer,
    );
  });

  group('PasswordRules', () {
    Widget rules(int strength) => _app(
      PasswordRules(
        strength: strength,
        strengthLabel: 'Robustesse : correcte',
        rules: const [
          (label: '10 caractères au moins', state: PasswordRuleState.met),
          (label: 'Différent de votre e-mail', state: PasswordRuleState.unmet),
          (label: 'Absent des listes', state: PasswordRuleState.pending),
        ],
        metLabel: 'Respecté',
        unmetLabel: 'Non respecté',
        pendingLabel: 'Vérification…',
      ),
    );

    testWidgets('jauge : 4 segments, mesure avec son libellé', (tester) async {
      await tester.pumpWidget(rules(3));
      expect(find.text('Robustesse : correcte'), findsOneWidget);
      final meter = tester.getSemantics(find.byKey(PasswordRules.meterKey));
      expect(meter.label, 'Robustesse : correcte');
      expect(meter.value, '3/4');
    });

    testWidgets('règles : état visible et lu', (tester) async {
      await tester.pumpWidget(rules(1));
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byIcon(Icons.hourglass_empty), findsOneWidget);
      expect(
        tester.getSemantics(find.text('10 caractères au moins')).label,
        '10 caractères au moins, Respecté',
      );
      expect(
        tester.getSemantics(find.text('Différent de votre e-mail')).label,
        'Différent de votre e-mail, Non respecté',
      );
    });
  });
}
