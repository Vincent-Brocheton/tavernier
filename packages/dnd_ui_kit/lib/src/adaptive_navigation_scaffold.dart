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
    this.account,
  });

  final List<AdaptiveDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;

  /// Entrée du compte (avatar) : en bas du rail [A7], en haut à droite du
  /// contenu sur téléphone.
  final Widget? account;

  @override
  Widget build(BuildContext context) {
    if (formFactorOf(MediaQuery.sizeOf(context).width) == FormFactor.phone) {
      final account = this.account;
      return Scaffold(
        body: account == null
            ? body
            : Stack(
                fit: StackFit.expand,
                children: [
                  body,
                  Positioned(
                    top: 0,
                    right: 0,
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.xs),
                        child: account,
                      ),
                    ),
                  ),
                ],
              ),
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
          // Le rail longe le bord gauche : il évite l'encoche en paysage.
          SafeArea(
            right: false,
            child: NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              labelType: NavigationRailLabelType.all,
              trailing: account == null
                  ? null
                  : Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: AppSpacing.md),
                          child: account,
                        ),
                      ),
                    ),
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
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}
