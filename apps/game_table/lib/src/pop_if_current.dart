import 'package:material_ui/material_ui.dart';

/// Ferme la route de [context] (feuille, dialogue) après une écriture, mais
/// seulement si elle est encore au-dessus de la pile. Refermée entre-temps
/// (voile touché, retour), elle se trouve en cours d'animation de sortie :
/// un `Navigator.pop` retirerait alors la page d'en dessous, par exemple la
/// page de combat.
void popIfCurrent<T extends Object?>(BuildContext context, [T? result]) {
  if (!context.mounted) return;
  if (ModalRoute.of(context)?.isCurrent ?? false) {
    Navigator.of(context).pop(result);
  }
}
