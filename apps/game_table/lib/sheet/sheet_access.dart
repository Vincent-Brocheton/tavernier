// Fiche modifiable ou en lecture seule (US-15) : la fiche d'un autre joueur,
// ouverte quand le MJ a ouvert les fiches complètes, ou une fiche archivée.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../account/account_providers.dart';
import '../creation/creation_providers.dart';

/// Vrai si l'utilisateur peut modifier la fiche [id] : elle est à lui (ou
/// pas encore envoyée), ou il est le MJ de sa table, et elle n'est pas
/// archivée. Mêmes règles que le serveur (`can_write_character`).
final sheetEditableProvider = FutureProvider.autoDispose.family<bool, String>((
  ref,
  id,
) async {
  final me = ref.watch(currentUserProvider.select((u) => u.value?.id));
  final access = await ref.watch(characterStoreProvider).access(id);
  if (access == null) return true;
  if (access.status == 'archived') return false;
  return access.ownerUserId == null ||
      access.ownerUserId == me ||
      (me != null && access.gmUserId == me);
});

/// Transmet aux onglets de la fiche si elle se modifie.
class SheetAccess extends InheritedWidget {
  const SheetAccess({super.key, required this.editable, required super.child});

  final bool editable;

  /// Modifiable hors d'une fiche (feuilles ouvertes à part) : le serveur
  /// garde de toute façon les droits.
  static bool editableOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SheetAccess>()?.editable ??
      true;

  @override
  bool updateShouldNotify(SheetAccess oldWidget) =>
      editable != oldWidget.editable;
}
