// Spec ui-kit : « Planche golden du kit » (cahier §12.1). Comparée sous Linux
// seulement : le rendu des polices varie d'un système à l'autre. Références
// régénérées par le job CI « checks » lancé à la main avec update_goldens.
@Tags(['golden'])
library;

import 'dart:io';

import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Comparé sous Linux (CI) seulement.
final _skip = !Platform.isLinux;

Widget _swatch(String name, Color color) => Padding(
  padding: const EdgeInsets.all(2),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(width: 64, height: 32, color: color),
      SizedBox(
        width: 64,
        child: Text(name, style: const TextStyle(fontSize: 8), maxLines: 1),
      ),
    ],
  ),
);

Widget _iconRow(String title, Iterable<GameIconData> icons) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 4),
  child: Row(
    children: [
      SizedBox(width: 120, child: Text(title)),
      for (final icon in icons)
        Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              GameIcon(icon),
              Text(icon.name, style: const TextStyle(fontSize: 8)),
            ],
          ),
        ),
    ],
  ),
);

class _Sheet extends StatelessWidget {
  const _Sheet();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final game = GameColors.of(context);
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                for (final MapEntry(:key, :value)
                    in AppTokens.darkColors.entries)
                  _swatch(key, value),
                for (final MapEntry(:key, :value)
                    in AppTokens.darkGameColors.entries)
                  _swatch(key, value),
              ],
            ),
            const SizedBox(height: 8),
            Text('Tavernier', style: text.displaySmall),
            Text('Aldric Varenne', style: text.headlineSmall),
            Text('Classe d’armure 19 · Initiative +3', style: text.titleMedium),
            Text(
              'Vous recevez les bénéfices suivants : maîtrise de l’Initiative.',
              style: text.bodyMedium,
            ),
            Text(
              '41 / 49 PV',
              style: AppTypography.numeric(text.titleLarge!)
                  .copyWith(color: game.hpBar(41, 49)),
            ),
            const SizedBox(height: 8),
            _iconRow('États', GameIcons.conditions.values),
            _iconRow('Dégâts', GameIcons.damageTypes.values),
            _iconRow('Écoles', GameIcons.schools.values),
            _iconRow('Actions', [
              ...GameIcons.actionEconomy.values,
              ...GameIcons.navigation.values,
            ]),
          ],
        ),
      ),
    );
  }
}

Widget _shell(int selected) => AdaptiveNavigationScaffold(
  selectedIndex: selected,
  onDestinationSelected: (_) {},
  destinations: [
    for (final (key, label) in [
      ('home', 'Accueil'),
      ('tables', 'Tables'),
      ('characters', 'Personnages'),
      ('compendium', 'Compendium'),
      ('homebrew', 'Homebrew'),
    ])
      AdaptiveDestination(
        icon: GameIcon(GameIcons.navigation[key]!),
        selectedIcon: GameIcon(GameIcons.navigation[key]!),
        label: label,
      ),
  ],
  body: Center(
    child: Builder(
      builder: (context) => Text(
        'Personnages',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    ),
  ),
);

Future<void> _pump(WidgetTester tester, Size size, Widget home) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: home,
    ),
  );
}

void main() {
  testWidgets('planche du kit', skip: _skip, (tester) async {
    await _pump(tester, const Size(1440, 1000), const _Sheet());
    await expectLater(
      find.byType(_Sheet),
      matchesGoldenFile('goldens/planche_kit.png'),
    );
  });

  for (final (name, size) in [
    ('telephone', const Size(390, 844)),
    ('tablette', const Size(960, 600)),
    ('desktop', const Size(1440, 900)),
  ]) {
    testWidgets('navigation $name', skip: _skip, (tester) async {
      await _pump(tester, size, _shell(2));
      await expectLater(
        find.byType(AdaptiveNavigationScaffold),
        matchesGoldenFile('goldens/navigation_$name.png'),
      );
    });
  }
}
