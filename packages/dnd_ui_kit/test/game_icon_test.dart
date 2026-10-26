// Spec ui-kit : « Icônes de jeu ».
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_parsing/path_parsing.dart';

/// Lit un tracé SVG ; échoue sur une commande invalide.
void _parse(String path) {
  writeSvgPathDataToPath(path, _NoopProxy());
}

final class _NoopProxy extends PathProxy {
  @override
  void close() {}
  @override
  void cubicTo(
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
  ) {}
  @override
  void lineTo(double x, double y) {}
  @override
  void moveTo(double x, double y) {}
}

void main() {
  test('jeux complets, identifiants du pack SRD', () {
    expect(GameIcons.conditions.keys, [
      'blinded', 'charmed', 'deafened', 'exhaustion', 'frightened', //
      'grappled', 'incapacitated', 'invisible', 'paralyzed', 'petrified',
      'poisoned', 'prone', 'restrained', 'stunned', 'unconscious',
    ]);
    expect(GameIcons.damageTypes.keys, [
      'acid', 'bludgeoning', 'cold', 'fire', 'force', 'lightning', //
      'necrotic', 'piercing', 'poison', 'psychic', 'radiant', 'slashing',
      'thunder',
    ]);
    expect(GameIcons.actionEconomy.keys, ['action', 'bonus', 'reaction']);
    expect(GameIcons.schools.keys, [
      'abjuration', 'conjuration', 'divination', 'enchantment', //
      'evocation', 'illusion', 'necromancy', 'transmutation',
    ]);
  });

  test('chaque tracé est lisible', () {
    for (final icon in GameIcons.all) {
      expect(() => _parse(icon.path), returnsNormally, reason: icon.name);
      expect(icon.path.trim(), isNotEmpty, reason: icon.name);
    }
  });

  Widget host(Widget child) => MaterialApp(
    home: Center(
      child: IconTheme(
        data: const IconThemeData(size: 32, color: Color(0xFF84D5C4)),
        child: child,
      ),
    ),
  );

  testWidgets('taille de l’IconTheme et libellé lu', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      host(
        GameIcon(
          GameIcons.conditions['poisoned']!,
          semanticLabel: 'Empoisonné',
        ),
      ),
    );
    expect(tester.getSize(find.byType(GameIcon)), const Size(32, 32));
    expect(find.bySemanticsLabel('Empoisonné'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('sans libellé, l’icône est décorative', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      host(GameIcon(GameIcons.damageTypes['fire']!, size: 18)),
    );
    expect(tester.getSize(find.byType(GameIcon)), const Size(18, 18));
    expect(tester.getSemantics(find.byType(GameIcon)).label, isEmpty);
    semantics.dispose();
  });

  testWidgets('se peint sans erreur dans les deux styles', (tester) async {
    await tester.pumpWidget(
      host(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GameIcon(GameIcons.actionEconomy['action']!),
            GameIcon(GameIcons.actionEconomy['reaction']!),
          ],
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
