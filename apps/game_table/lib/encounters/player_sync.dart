// Liaison du combat avec les téléphones des joueurs (US-36, EF-VJ-03, 06),
// côté MJ : la vue filtrée est publiée à chaque changement, et les demandes
// des joueurs passent au journal.
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../account/account_providers.dart';
import '../creation/creation_providers.dart';
import 'encounters_providers.dart';

/// Seule voie d'écriture de la vue des joueurs (cahier §10).
final combatViewStoreProvider = Provider<CombatViewStore>(
  (ref) => CombatViewStore(ref.watch(databaseProvider)),
);

/// Seule voie d'écriture des demandes des joueurs (cahier §10).
final combatRequestStoreProvider = Provider<CombatRequestStore>(
  (ref) => CombatRequestStore(ref.watch(databaseProvider)),
);

/// Demandes prises en charge : une demande ne s'applique qu'une fois, même
/// si le journal change avant que son retrait ne soit lu. Une erreur la
/// rend à la prochaine lecture.
final _applying = <String>{};

/// Tant qu'il est écouté (la page du combat du MJ), publie la vue de la
/// rencontre en cours et applique les demandes de ses joueurs.
final combatPlayerSyncProvider = Provider.autoDispose
    .family<void, ({String tableId, String encounterId})>((ref, key) {
      final encounter = ref
          .watch(tableEncountersProvider(key.tableId))
          .value
          ?.where((e) => e.id == key.encounterId)
          .firstOrNull;
      final state = ref.watch(combatStateProvider(key.encounterId)).value;
      if (encounter?.status != EncounterStatus.running || state == null) {
        return;
      }
      ref
          .read(combatViewStoreProvider)
          .publish(
            encounterId: key.encounterId,
            tableId: key.tableId,
            // Le joueur ne lit pas les rencontres : le titre vient avec.
            payload: {...playerCombatView(state), 'title': encounter!.title},
          );
      final requests = ref.watch(combatRequestsProvider(key.encounterId)).value;
      final combat = ref.read(combatStoreProvider);
      final store = ref.read(combatRequestStoreProvider);
      final author = ref.read(currentUserProvider).value?.id;
      for (final request in requests ?? const <CombatRequest>[]) {
        if (_applying.add(request.id)) {
          _apply(
            combat,
            store,
            author,
            state,
            request,
          ).catchError((Object _) => _applying.remove(request.id));
        }
      }
    });

/// Demandes des joueurs pour [encounterId], dans l'ordre d'envoi.
final combatRequestsProvider = StreamProvider.autoDispose
    .family<List<CombatRequest>, String>(
      (ref, encounterId) =>
          ref.watch(combatRequestStoreProvider).watch(encounterId),
    );

/// Passe [request] au journal, avec sa référence, puis la retire. Une
/// demande refusée ou dépassée est retirée sans rien écrire : la version du
/// MJ prime (EF-VJ-06).
Future<void> _apply(
  CombatStore combat,
  CombatRequestStore store,
  String? author,
  CombatState state,
  CombatRequest request,
) async {
  final events = requestEvents(
    state,
    id: request.id,
    character: request.characterId,
    type: request.type,
    payload: request.payload,
  );
  if (events.isNotEmpty) {
    await combat.append(request.encounterId, events, authorUserId: author);
  }
  await store.remove(request.id);
}
