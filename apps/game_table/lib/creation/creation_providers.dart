import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database.dart';
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

/// Personnages enregistrés.
final charactersProvider = FutureProvider(
  (ref) => ref.watch(characterStoreProvider).list(),
);

/// Brouillon de création, libéré quand on quitte l'assistant.
final creationProvider =
    NotifierProvider.autoDispose<CreationNotifier, CreationDraft>(
      CreationNotifier.new,
    );

class CreationNotifier extends Notifier<CreationDraft> {
  @override
  CreationDraft build() => const CreationDraft();

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
    try {
      await ref
          .read(characterStoreProvider)
          .save(_id, toCharacterInput(state, content));
    } on Exception {
      return false;
    }
    ref.invalidate(charactersProvider);
    return true;
  }
}
