import 'package:dnd_rules/dnd_rules.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database.dart';
import 'creation_draft.dart';

/// Contenu actif : le pack SRD embarqué, lu sans réseau.
final contentProvider = FutureProvider<ActiveContent>(
  (ref) async => ActiveContent([await loadSrdPack()]),
);

/// Brouillon de création, libéré quand on quitte l'assistant.
final creationProvider =
    NotifierProvider.autoDispose<CreationNotifier, CreationDraft>(
      CreationNotifier.new,
    );

class CreationNotifier extends Notifier<CreationDraft> {
  @override
  CreationDraft build() => const CreationDraft();

  void update(CreationDraft Function(CreationDraft) change) =>
      state = change(state);
}
