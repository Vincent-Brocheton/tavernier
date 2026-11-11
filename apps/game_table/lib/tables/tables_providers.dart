// Tables de jeu (US-13) : dépôt et listes, au-dessus de la base de l'appareil.
import 'package:dnd_data/dnd_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../account/account_providers.dart';
import '../creation/creation_providers.dart';

/// Seule voie d'écriture des tables (cahier §10).
final tableStoreProvider = Provider<TableStore>(
  (ref) => TableStore(ref.watch(databaseProvider)),
);

/// Tables de l'utilisateur connecté, MJ ou membre ; vide sans compte.
final myTablesProvider = FutureProvider<List<TableSummary>>((ref) async {
  final userId = ref.watch(currentUserProvider.select((u) => u.value?.id));
  if (userId == null) return const [];
  return ref.watch(tableStoreProvider).list(userId);
});

/// Une table vue par l'utilisateur connecté.
final tableProvider = FutureProvider.family<TableSummary?, String>((
  ref,
  id,
) async {
  final userId = ref.watch(currentUserProvider.select((u) => u.value?.id));
  if (userId == null) return null;
  return ref.watch(tableStoreProvider).load(id, userId);
});

/// Packs actifs d'une nouvelle table : le contenu de l'app, à sa version
/// (EF-TAB-04). Au MVP, le pack SRD seul.
final defaultTablePacksProvider = FutureProvider<List<TablePackRef>>((
  ref,
) async {
  final content = await ref.watch(contentProvider.future);
  return [
    for (final pack in content.packs)
      (packId: pack.manifest.id, version: pack.manifest.version),
  ];
});
