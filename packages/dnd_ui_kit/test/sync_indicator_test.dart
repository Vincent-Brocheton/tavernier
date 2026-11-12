// Spec ui-kit : « Indicateur de synchronisation » (COMPOSANTS §2.14).
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Widget _app(Widget child) => MaterialApp(
  theme: AppTheme.dark,
  home: Scaffold(body: Center(child: child)),
);

void main() {
  for (final (state, icon) in [
    (SyncIndicatorState.synced, Icons.cloud_done_outlined),
    (SyncIndicatorState.pending, Icons.cloud_upload_outlined),
    (SyncIndicatorState.offline, Icons.cloud_off_outlined),
    (SyncIndicatorState.conflict, Icons.warning_amber_outlined),
  ]) {
    testWidgets('${state.name} : icône et libellé', (tester) async {
      await tester.pumpWidget(
        _app(SyncIndicator(state: state, label: 'Libellé')),
      );
      expect(find.byIcon(icon), findsOneWidget);
      expect(find.text('Libellé'), findsOneWidget);
    });
  }

  testWidgets('en attente : couleur des PV temporaires', (tester) async {
    await tester.pumpWidget(
      _app(
        const SyncIndicator(
          state: SyncIndicatorState.pending,
          label: '3 modifications en attente',
        ),
      ),
    );
    final context = tester.element(find.byType(SyncIndicator));
    expect(
      tester.widget<Icon>(find.byIcon(Icons.cloud_upload_outlined)).color,
      GameColors.of(context).tempHp,
    );
  });

  testWidgets('compact : icône seule, libellé lu', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      _app(
        const SyncIndicator(
          state: SyncIndicatorState.offline,
          label: 'Hors-ligne',
          compact: true,
        ),
      ),
    );
    expect(find.text('Hors-ligne'), findsNothing);
    expect(find.bySemanticsLabel('Hors-ligne'), findsOneWidget);
    expect(tester.getSize(find.byType(SyncIndicator)).height, 48);
    semantics.dispose();
  });
}
