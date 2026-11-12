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
final myTablesProvider = StreamProvider<List<TableSummary>>((ref) {
  final userId = ref.watch(currentUserProvider.select((u) => u.value?.id));
  if (userId == null) return Stream.value(const []);
  return ref.watch(tableStoreProvider).watchList(userId);
});

/// Une table vue par l'utilisateur connecté, tenue à jour.
final tableProvider = StreamProvider.family<TableSummary?, String>((ref, id) {
  final userId = ref.watch(currentUserProvider.select((u) => u.value?.id));
  if (userId == null) return Stream.value(null);
  return ref.watch(tableStoreProvider).watch(id, userId);
});

/// Membres d'une table, le MJ d'abord.
final tableMembersProvider =
    StreamProvider.family<List<TableMemberInfo>, String>(
      (ref, id) => ref.watch(tableStoreProvider).watchMembers(id),
    );

/// Invitation en cours d'une table, pour son MJ.
final tableInviteProvider = StreamProvider.family<TableInvite?, String>(
  (ref, id) => ref.watch(tableStoreProvider).watchInvite(id),
);

/// Activité d'une table, la plus récente d'abord (EF-TAB-11).
final tableActivityProvider =
    FutureProvider.family<List<TableActivity>, String>(
      (ref, id) => ref.watch(tableStoreProvider).activity(id),
    );

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
