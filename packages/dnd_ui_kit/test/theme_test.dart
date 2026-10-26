// Spec ui-kit : « Thème sombre par défaut », « Typographie ».

import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('schéma sombre issu des tokens, élévation tonale', () {
    final theme = AppTheme.dark;
    expect(theme.brightness, Brightness.dark);
    expect(theme.colorScheme.surface, const Color(0xFF1A1612));
    expect(theme.colorScheme.primary, const Color(0xFF84D5C4));
    expect(theme.colorScheme.surfaceContainerHighest, const Color(0xFF3D3732));
    expect(theme.colorScheme.surfaceTint, const Color(0x00000000));
    expect(theme.extension<GameColors>(), GameColors.dark);
    expect(theme.materialTapTargetSize, MaterialTapTargetSize.padded);
  });

  test('thème clair (V1.5) issu des tokens', () {
    final theme = AppTheme.light;
    expect(theme.brightness, Brightness.light);
    expect(theme.colorScheme.surface, const Color(0xFFFFF8F3));
    expect(theme.extension<GameColors>(), GameColors.light);
  });

  test('Cinzel pour Display et Headline, Roboto Flex ailleurs', () {
    final text = AppTheme.dark.textTheme;
    expect(text.headlineSmall!.fontFamily, 'packages/dnd_ui_kit/Cinzel');
    expect(text.headlineSmall!.fontSize, 24);
    expect(text.headlineSmall!.height, 32 / 24);
    expect(text.displayLarge!.fontFamily, 'packages/dnd_ui_kit/Cinzel');
    expect(text.bodyMedium!.fontFamily, 'packages/dnd_ui_kit/RobotoFlex');
    expect(text.bodyMedium!.fontSize, 14);
    expect(text.titleMedium!.letterSpacing, 0.15);
    expect(
      text.headlineSmall!.fontVariations,
      contains(const FontVariation('wght', 600)),
    );
  });

  test('style numérique à chiffres tabulaires', () {
    final style = AppTypography.numeric(const TextStyle(fontSize: 16));
    expect(style.fontFeatures, contains(const FontFeature.tabularFigures()));
    expect(style.fontSize, 16);
  });

  testWidgets('un bouton du thème offre une cible de 48 dp', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: Center(
            child: TextButton(onPressed: () {}, child: const Text('Ok')),
          ),
        ),
      ),
    );
    final size = tester.getSize(find.byType(TextButton));
    expect(size.height, greaterThanOrEqualTo(48));
    expect(size.width, greaterThanOrEqualTo(48));
  });

  testWidgets('les licences OFL des polices sont enregistrées', (tester) async {
    registerFontLicenses();
    final entries = await LicenseRegistry.licenses.toList();
    final packages = {for (final e in entries) ...e.packages};
    expect(packages, containsAll(['Cinzel', 'Roboto Flex']));
  });
}
