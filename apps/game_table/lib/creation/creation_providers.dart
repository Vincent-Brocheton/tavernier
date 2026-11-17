import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../account/account_providers.dart';
import '../database.dart';
import '../tables/tables_providers.dart';
import 'creation_draft.dart';
import 'draft_input.dart';

/// Contenu actif : le pack SRD embarqué, lu sans réseau.
final contentProvider = FutureProvider<ActiveContent>(
  (ref) async => ActiveContent([await loadSrdPack()]),
);

/// Base locale, ouverte au premier usage.
final databaseProvider = Provider<TavernierDatabase>((ref) {
  final database = openTavernierDatabase();
  ref.onDispose(database.close);
  return database;
});

/// Seule voie d'écriture des personnages (cahier §10).
final characterStoreProvider = Provider<CharacterStore>(
  (ref) => CharacterStore(ref.watch(databaseProvider)),
);

/// Personnages de l'utilisateur ; un MJ reçoit aussi ceux de ses joueurs,
/// qui n'y figurent pas.
final charactersProvider = FutureProvider((ref) {
  final userId = ref.watch(currentUserProvider.select((u) => u.value?.id));
  return ref.watch(characterStoreProvider).list(ownerUserId: userId);
});

/// Brouillon de création, libéré quand on quitte l'assistant.
final creationProvider =
    NotifierProvider.autoDispose<CreationNotifier, CreationDraft>(
      CreationNotifier.new,
    );

/// PNJ en fiche complète que l'assistant crée (US-18, EF-PNJ-01) : sa
/// table, son dossier et son attitude.
typedef NpcTarget = ({String tableId, String? folder, Attitude attitude});

class CreationNotifier extends Notifier<CreationDraft> {
  @override
  CreationDraft build() => const CreationDraft();

  /// Avec une cible, l'assistant crée une fiche de PNJ du MJ, sans
  /// contrainte de méthode, puis le PNJ lié.
  NpcTarget? npc;

  /// L'identifiant ne change pas : réessayer après un échec ne crée pas de
  /// doublon.
  final _id = uuidV7();
  Future<bool>? _saving;

  void update(CreationDraft Function(CreationDraft) change) =>
      state = change(state);

  /// Enregistre le personnage ; `false` si l'écriture échoue. Un second appui
  /// pendant l'écriture rejoint le premier.
  Future<bool> save(ActiveContent content) =>
      _saving ??= _write(content).whenComplete(() => _saving = null);

  Future<bool> _write(ActiveContent content) async {
    final table = state.table;
    final npc = this.npc;
    try {
      final input = toCharacterInput(state, content);
      if (npc != null) {
        // La fiche et son PNJ ensemble : jamais une fiche de PNJ orpheline.
        final database = ref.read(databaseProvider);
        await database.transaction(() async {
          await ref
              .read(characterStoreProvider)
              .save(
                _id,
                input.copyWith(kind: 'npc_full'),
                tableId: npc.tableId,
              );
          await NpcStore(database).create(
            tableId: npc.tableId,
            name: input.name,
            folder: npc.folder,
            attitude: npc.attitude,
            characterId: _id,
          );
        });
        return true;
      }
      await ref
          .read(characterStoreProvider)
          .save(_id, input, tableId: table?.tableId);
      if (table != null) {
        await ref.read(tableStoreProvider).fillSlot(table.slotId, _id);
      }
    } on Exception {
      return false;
    }
    ref.invalidate(charactersProvider);
    return true;
  }
}
