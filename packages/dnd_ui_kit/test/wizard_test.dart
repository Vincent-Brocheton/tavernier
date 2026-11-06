// Spec ui-kit : « Composants de l'assistant », « Distances en mètres ».
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

const _steps = [
  WizardStep(label: 'Classe', detail: 'Guerrier'),
  WizardStep(label: 'Historique', detail: 'Soldat'),
  WizardStep(label: 'Espèce', detail: 'À choisir'),
];

Widget _app(Widget child) => MaterialApp(
  theme: AppTheme.dark,
  home: Scaffold(body: child),
);

void main() {
  group('WizardSteps', () {
    testWidgets('étape passée cochée, étape courante annoncée', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(
          WizardSteps(
            steps: _steps,
            current: 1,
            reached: 1,
            onSelected: (_) {},
          ),
        ),
      );
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(
        tester.getSemantics(find.widgetWithText(InkWell, 'Historique')),
        isSemantics(isSelected: true, isButton: true),
      );
      handle.dispose();
    });

    testWidgets('une étape atteinte se touche, pas la suivante', (
      tester,
    ) async {
      final taps = <int>[];
      await tester.pumpWidget(
        _app(
          WizardSteps(
            steps: _steps,
            current: 1,
            reached: 1,
            onSelected: taps.add,
          ),
        ),
      );
      await tester.tap(find.text('Classe'));
      await tester.tap(find.text('Espèce'));
      expect(taps, [0]);
    });

    testWidgets('chaque étape fait au moins 48 dp', (tester) async {
      await tester.pumpWidget(
        _app(
          WizardSteps(
            steps: _steps,
            current: 0,
            reached: 0,
            onSelected: (_) {},
          ),
        ),
      );
      expect(
        tester.getSize(find.widgetWithText(InkWell, 'Espèce')).height,
        greaterThanOrEqualTo(48),
      );
    });
  });

  testWidgets('WizardProgress : libellé et barre de 4 dp', (tester) async {
    await tester.pumpWidget(
      _app(const WizardProgress(label: 'Étape 3 sur 9', value: 3 / 9)),
    );
    expect(find.text('Étape 3 sur 9'), findsOneWidget);
    expect(tester.getSize(find.byType(LinearProgressIndicator)).height, 4);
  });

  group('WizardFooter', () {
    testWidgets('bloqué : Suivant désactivé, raison au-dessus', (tester) async {
      await tester.pumpWidget(
        _app(
          WizardFooter(
            previousLabel: 'Précédent',
            nextLabel: 'Suivant',
            onPrevious: () {},
            onNext: () {},
            blockedReason: 'Choisissez une classe.',
          ),
        ),
      );
      final next = find.widgetWithText(FilledButton, 'Suivant');
      expect(tester.widget<FilledButton>(next).onPressed, isNull);
      expect(find.text('Choisissez une classe.'), findsOneWidget);
      expect(
        tester
            .widget<Semantics>(
              find
                  .ancestor(
                    of: find.text('Choisissez une classe.'),
                    matching: find.byType(Semantics),
                  )
                  .first,
            )
            .properties
            .liveRegion,
        isTrue,
      );
      expect(
        tester.getTopLeft(find.text('Choisissez une classe.')).dy,
        lessThan(tester.getTopLeft(next).dy),
      );
    });

    testWidgets('libre : Suivant actif, pas de Précédent à l’étape 1', (
      tester,
    ) async {
      var next = 0;
      await tester.pumpWidget(
        _app(
          WizardFooter(
            previousLabel: 'Précédent',
            nextLabel: 'Suivant',
            onNext: () => next++,
          ),
        ),
      );
      expect(find.text('Précédent'), findsNothing);
      await tester.tap(find.text('Suivant'));
      expect(next, 1);
    });
  });

  testWidgets('WizardFooter sur téléphone : boutons à parts égales', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      _app(
        WizardFooter(
          previousLabel: 'Précédent',
          nextLabel: 'Suivant',
          onPrevious: () {},
          onNext: () {},
        ),
      ),
    );
    expect(
      tester.getSize(find.byType(FilledButton)).width,
      tester.getSize(find.byType(OutlinedButton)).width,
    );
    expect(tester.getSize(find.byType(FilledButton)).width, greaterThan(150));
  });

  group('SelectionCard', () {
    testWidgets('sélectionnée : coche et état annoncé', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(
          SelectionCard(
            title: 'Guerrier',
            subtitle: 'Principale : Force ou Dextérité',
            selected: true,
            onTap: () {},
          ),
        ),
      );
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(
        tester.getSemantics(find.widgetWithText(InkWell, 'Guerrier')),
        isSemantics(isSelected: true, isButton: true),
      );
      handle.dispose();
    });

    testWidgets('le contenu ouvert a ses commandes, hors de la zone tactile', (
      tester,
    ) async {
      var card = 0;
      var inner = 0;
      await tester.pumpWidget(
        _app(
          SelectionCard(
            title: 'Humain',
            selected: true,
            onTap: () => card++,
            child: Column(
              children: [
                TextButton(
                  onPressed: () => inner++,
                  child: const Text('Taille M'),
                ),
                const SizedBox(height: 60, child: Text('Trait')),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.text('Taille M'));
      await tester.tap(find.text('Trait'));
      expect((card, inner), (0, 1));
      await tester.tap(find.text('Humain'));
      expect(card, 1);
    });

    testWidgets('non sélectionnée : pas de coche, 48 dp, touchable', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        _app(SelectionCard(title: 'Barde', onTap: () => taps++)),
      );
      expect(find.byIcon(Icons.check_circle), findsNothing);
      expect(
        tester.getSize(find.byType(SelectionCard)).height,
        greaterThanOrEqualTo(48),
      );
      await tester.tap(find.text('Barde'));
      expect(taps, 1);
    });
  });

  testWidgets('SourceBadge : le nom de la source', (tester) async {
    await tester.pumpWidget(_app(const SourceBadge('SRD 5.2.1')));
    expect(find.text('SRD 5.2.1'), findsOneWidget);
  });

  test('formatFeet : pieds stockés, mètres affichés', () {
    expect(formatFeet(5), '1,50 m');
    expect(formatFeet(30), '9 m');
    expect(formatFeet(35), '10,50 m');
    expect(formatFeet(120), '36 m');
  });
}
