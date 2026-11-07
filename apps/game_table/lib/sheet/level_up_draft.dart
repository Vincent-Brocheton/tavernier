import 'package:dnd_rules/dnd_rules.dart';

/// Répartition d'une Amélioration de caractéristique.
enum ImprovementMode { two, oneAndOne }

/// Choix d'une montée de niveau, le temps de l'assistant.
final class LevelUpDraft {
  const LevelUpDraft({
    this.subclassId,
    this.choices = const {},
    this.masteries = const [],
    this.feat,
    this.mode = ImprovementMode.two,
    this.bonuses = const [],
    this.featChoices = const {},
  });

  final String? subclassId;
  final Map<String, List<String>> choices;
  final List<String> masteries;
  final String? feat;
  final ImprovementMode mode;

  /// Caractéristiques retenues pour l'Amélioration ou pour un don à +1.
  final List<String> bonuses;

  /// Sélections d'un `choice` du don.
  final Map<String, List<String>> featChoices;

  LevelUpDraft copyWith({
    String? subclassId,
    Map<String, List<String>>? choices,
    List<String>? masteries,
  }) => LevelUpDraft(
    subclassId: subclassId ?? this.subclassId,
    choices: choices ?? this.choices,
    masteries: masteries ?? this.masteries,
    feat: feat,
    mode: mode,
    bonuses: bonuses,
    featChoices: featChoices,
  );

  /// Un autre don vide ce qui avait été choisi pour le précédent.
  LevelUpDraft selectFeat(String id) => id == feat
      ? this
      : LevelUpDraft(
          subclassId: subclassId,
          choices: choices,
          masteries: masteries,
          feat: id,
        );

  LevelUpDraft selectMode(ImprovementMode value) => value == mode
      ? this
      : LevelUpDraft(
          subclassId: subclassId,
          choices: choices,
          masteries: masteries,
          feat: feat,
          mode: value,
        );

  LevelUpDraft toggleBonus(String code, int count) => LevelUpDraft(
    subclassId: subclassId,
    choices: choices,
    masteries: masteries,
    feat: feat,
    mode: mode,
    bonuses: _toggled(bonuses, code, count),
    featChoices: featChoices,
  );

  LevelUpDraft toggleFeatChoice(String id, String pick, int count) =>
      LevelUpDraft(
        subclassId: subclassId,
        choices: choices,
        masteries: masteries,
        feat: feat,
        mode: mode,
        bonuses: bonuses,
        featChoices: {
          ...featChoices,
          id: _toggled(featChoices[id] ?? const [], pick, count),
        },
      );

  LevelUpDraft togglePick(String id, String pick, int count) => copyWith(
    choices: {...choices, id: _toggled(choices[id] ?? const [], pick, count)},
  );

  LevelUpDraft toggleMastery(String id, int count) =>
      copyWith(masteries: _toggled(masteries, id, count));

  static List<String> _toggled(List<String> list, String id, int count) {
    if (list.contains(id)) return [...list]..remove(id);
    if (count == 1) return [id];
    return list.length < count ? [...list, id] : list;
  }

  /// Choix du don au format stocké : `{"str": 1, "con": 1}` pour une
  /// Amélioration ou un don à +1.
  Map<String, Object?>? get storedFeatChoices {
    if (feat == null) return null;
    final value = mode == ImprovementMode.two ? 2 : 1;
    final abilities = feat == abilityScoreImprovementFeat
        ? {for (final code in bonuses) code: value}
        : {for (final code in bonuses) code: 1};
    final merged = {...abilities, ...featChoices};
    return merged.isEmpty ? null : merged;
  }

  LevelChoices toChoices() => LevelChoices(
    subclassId: subclassId,
    feat: feat,
    featChoices: storedFeatChoices,
    choices: choices,
    masteries: masteries,
  );
}
