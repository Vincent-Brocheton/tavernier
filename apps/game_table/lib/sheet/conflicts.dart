// Conflits de synchronisation (US-16, ENF-03, EF-PJ-13) : ceux qui ont
// remplacé une valeur de l'utilisateur, vus ou non, et leurs libellés.
import 'package:dnd_data/dnd_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../account/account_providers.dart';
import '../creation/creation_providers.dart';
import '../l10n/app_localizations.dart';
import '../settings/device_settings.dart';

/// Conflits qui ont remplacé une valeur de l'utilisateur connecté.
final myConflictsProvider = StreamProvider<List<CharacterHistoryEntry>>((ref) {
  final me = ref.watch(currentUserProvider.select((u) => u.value?.id));
  if (me == null) return Stream.value(const []);
  return ref.watch(characterStoreProvider).watchConflicts(me);
});

/// Conflits déjà vus (« OK »), gardés sur l'appareil.
final seenConflictsProvider = NotifierProvider<SeenConflicts, Set<String>>(
  SeenConflicts.new,
);

class SeenConflicts extends Notifier<Set<String>> {
  static const _key = 'seen_conflicts';

  @override
  Set<String> build() => {
    ...?ref.watch(sharedPreferencesProvider)?.getStringList(_key),
  };

  void markSeen(Iterable<String> ids) {
    state = {...state, ...ids};
    ref.read(sharedPreferencesProvider)?.setStringList(_key, [...state]);
  }
}

/// Conflits pas encore vus, le plus récent d'abord.
final unseenConflictsProvider = Provider<List<CharacterHistoryEntry>>((ref) {
  final seen = ref.watch(seenConflictsProvider);
  return [
    for (final conflict
        in ref.watch(myConflictsProvider).value ??
            const <CharacterHistoryEntry>[])
      if (!seen.contains(conflict.id)) conflict,
  ];
});

/// Pseudonyme d'un auteur, s'il est connu de l'appareil.
final pseudonymOfProvider = FutureProvider.autoDispose.family<String?, String>(
  (ref, id) => ref.watch(characterStoreProvider).pseudonymOf(id),
);

extension ConflictLabels on AppLocalizations {
  /// Nom d'un champ suivi ; un autre garde son nom technique.
  String conflictField(Object? field) => switch (field) {
    'hp_current' => fieldHp,
    'exhaustion' => fieldExhaustion,
    'heroic_inspiration' => fieldInspiration,
    'concentration_spell_id' => fieldConcentration,
    'resources' => fieldResources,
    'name' => fieldName,
    'xp' => fieldXp,
    'coins' => fieldCoins,
    'alignment' => fieldAlignment,
    'appearance' => fieldAppearance,
    'personality' => fieldPersonality,
    'backstory' => fieldBackstory,
    _ => '$field',
  };

  /// Valeur telle qu'un joueur la lit.
  String conflictValue(Object? value) => switch (value) {
    null => valueNone,
    true => valueYes,
    false => valueNo,
    _ => '$value',
  };
}
