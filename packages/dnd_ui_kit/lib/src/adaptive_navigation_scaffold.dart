import 'package:material_ui/material_ui.dart';

import 'layout.dart';

/// Une destination principale de l'application.
final class AdaptiveDestination {
  const AdaptiveDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final Widget icon;
  final Widget selectedIcon;

  /// Libellé affiché et lu ; il vient des ARB de l'application.
  final String label;
}

/// Navigation principale (COMPOSANTS §1) : barre de navigation en bas sur
/// téléphone, rail à gauche à partir de la tablette paysage.
class AdaptiveNavigationScaffold extends StatelessWidget {
  const AdaptiveNavigationScaffold({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
  });

  final List<AdaptiveDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    if (formFactorOf(MediaQuery.sizeOf(context).width) == FormFactor.phone) {
      return Scaffold(
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: [
            for (final d in destinations)
              NavigationDestination(
                icon: d.icon,
                selectedIcon: d.selectedIcon,
                label: d.label,
              ),
          ],
        ),
      );
    }
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: [
              for (final d in destinations)
                NavigationRailDestination(
                  icon: d.icon,
                  selectedIcon: d.selectedIcon,
                  label: Text(d.label),
                  // Libellés longs (« Personnages ») dans 80 dp, comme sur
                  // les maquettes desktop.
                  padding: EdgeInsets.zero,
                ),
            ],
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}
