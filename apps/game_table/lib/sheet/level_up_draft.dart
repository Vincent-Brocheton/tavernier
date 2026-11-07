import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';

/// Sections de sorts de `LevelUpDraft.spells`.
const spellCantrips = 'cantrips';
const spellBook = 'book';
const spellPrepared = 'prepared';
const spellAccess = 'access';

/// Sélections d'un Initié à la magie dans `LevelUpDraft.featChoices`.
const initiateList = 'list';
const initiateAbility = 'ability';
const initiateCantrips = 'cantrips';
const initiateSpell = 'spell';

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
    this.spells = const {},
  });

  final String? subclassId;
  final Map<String, List<String>> choices;
  final List<String> masteries;
  final String? feat;
  final ImprovementMode mode;

  /// Caractéristiques retenues pour l'Amélioration ou pour un don à +1.
  final List<String> bonuses;

  /// Sélections d'un `choice` du don, ou d'un Initié à la magie.
  final Map<String, List<String>> featChoices;

  /// Sorts gagnés, par section ([spellCantrips]…).
  final Map<String, List<String>> spells;

  LevelUpDraft copyWith({
    String? subclassId,
    Map<String, List<String>>? choices,
    List<String>? masteries,
    Map<String, List<String>>? spells,
  }) => LevelUpDraft(
    subclassId: subclassId ?? this.subclassId,
    choices: choices ?? this.choices,
    masteries: masteries ?? this.masteries,
    feat: feat,
    mode: mode,
    bonuses: bonuses,
    featChoices: featChoices,
    spells: spells ?? this.spells,
  );

  LevelUpDraft toggleSpell(String section, String id, int count) => copyWith(
    spells: {
      ...spells,
      section: _toggled(spells[section] ?? const [], id, count),
    },
  );

  /// Un sort retiré du grimoire n'est plus préparé.
  LevelUpDraft toggleSpellbook(String id, int count) {
    final book = _toggled(spells[spellBook] ?? const [], id, count);
    return copyWith(
      spells: {
        ...spells,
        spellBook: book,
        spellPrepared: [
          for (final spell in spells[spellPrepared] ?? const <String>[])
            if (book.contains(spell) ||
                !(spells[spellBook] ?? const []).contains(spell))
              spell,
        ],
      },
    );
  }

  /// Un autre don vide ce qui avait été choisi pour le précédent.
  LevelUpDraft selectFeat(String id) => id == feat
      ? this
      : LevelUpDraft(
          subclassId: subclassId,
          choices: choices,
          masteries: masteries,
          feat: id,
          spells: spells,
        );

  LevelUpDraft selectMode(ImprovementMode value) => value == mode
      ? this
      : LevelUpDraft(
          subclassId: subclassId,
          choices: choices,
          masteries: masteries,
          feat: feat,
          mode: value,
          spells: spells,
        );

  LevelUpDraft toggleBonus(String code, int count) => LevelUpDraft(
    subclassId: subclassId,
    choices: choices,
    masteries: masteries,
    feat: feat,
    mode: mode,
    bonuses: _toggled(bonuses, code, count),
    featChoices: featChoices,
    spells: spells,
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
        spells: spells,
      );

  /// Une autre liste de l'Initié efface ses sorts.
  LevelUpDraft selectInitiateList(String list) =>
      featChoices[initiateList]?.contains(list) ?? false
      ? this
      : LevelUpDraft(
          subclassId: subclassId,
          choices: choices,
          masteries: masteries,
          feat: feat,
          mode: mode,
          bonuses: bonuses,
          featChoices: {
            ...featChoices,
            initiateList: [list],
            initiateCantrips: const [],
            initiateSpell: const [],
          },
          spells: spells,
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
    if (feat == magicInitiateFeat) {
      return {
        'spell_list': featChoices[initiateList]?.firstOrNull,
        'ability': abilityIdByCode.entries
            .where((e) => e.value == featChoices[initiateAbility]?.firstOrNull)
            .firstOrNull
            ?.key,
        'cantrips': featChoices[initiateCantrips] ?? const <String>[],
        'level_1_spell': featChoices[initiateSpell]?.firstOrNull,
      };
    }
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
    spells: SpellsInput(
      cantrips: [...?spells[spellCantrips], ...?spells[spellAccess]],
      prepared: spells[spellPrepared] ?? const [],
      spellbook: spells[spellBook] ?? const [],
    ),
  );
}
