import 'dart:math';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';

import 'draft_input.dart';
import 'subchoices.dart';

/// Nombre d'étapes de la création (cahier §5.1).
const creationStepCount = 9;

/// Choix obligatoire encore absent d'une étape ; l'interface le traduit.
enum MissingChoice {
  classChoice,
  background,
  tool,
  species,
  size,
  languages,
  points,

  /// Un bonus porte sur une caractéristique que l'Historique n'autorise pas.
  bonusInvalid,
  bonus,
  subchoices,
  classEquipment,
  backgroundEquipment,
  equipmentTool,
  name,

  /// `computeSheet` signale une erreur d'intégrité.
  rules,
}

/// Répartitions des bonus d'Historique (SRD p. 87).
const bonusDistributions = ['2-1', '1-1-1'];

/// Brouillon de création : les choix déjà faits et la position dans
/// l'assistant. `CharacterInput` exige un personnage complet ; un brouillon
/// peut être incomplet.
final class CreationDraft {
  const CreationDraft({
    this.step = 0,
    this.reached = 0,
    this.classId,
    this.backgroundId,
    this.toolChoice,
    this.speciesId,
    this.size,
    this.languages = const [],
    this.scores = const {
      'str': 8,
      'dex': 8,
      'con': 8,
      'int': 8,
      'wis': 8,
      'cha': 8,
    },
    this.distribution = '2-1',
    this.bonuses = const {},
    this.classSkills = const [],
    this.classTools = const [],
    this.masteries = const [],
    this.fightingStyle,
    this.originFeat,
    this.choices = const {},
    this.classEquipment,
    this.backgroundEquipment,
    this.equipmentTool,
    this.name = '',
    this.alignment,
    this.appearance = '',
    this.personality = '',
    this.backstory = '',
  });

  /// Étape affichée (à partir de 0).
  final int step;

  /// Dernière étape atteinte.
  final int reached;
  final String? classId;
  final String? backgroundId;
  final String? toolChoice;
  final String? speciesId;
  final String? size;

  /// Langues choisies, sans le Commun.
  final List<String> languages;

  /// Valeurs achetées, avant bonus.
  final Map<String, int> scores;

  /// `2-1` ou `1-1-1`.
  final String distribution;

  /// Bonus d'Historique par caractéristique.
  final Map<String, int> bonuses;

  /// Compétences choisies dans la liste de la classe.
  final List<String> classSkills;

  /// Outils choisis dans la catégorie de la classe (Barde).
  final List<String> classTools;

  /// Armes dont la botte est choisie.
  final List<String> masteries;
  final String? fightingStyle;

  /// Don d'origines accordé par l'espèce (Humain, Polyvalent).
  final String? originFeat;

  /// Sélections des effets `choice`, par identifiant de choix.
  final Map<String, List<String>> choices;

  /// Rang du lot de classe.
  final int? classEquipment;

  /// 0 : le lot de l'Historique, 1 : son or.
  final int? backgroundEquipment;

  /// Outil à choisir dans le lot de classe.
  final String? equipmentTool;
  final String name;
  final String? alignment;
  final String appearance;
  final String personality;
  final String backstory;

  int get remainingPoints => pointBuyBudget - pointBuySpent(scores);

  /// Une autre classe efface ses sous-choix : leurs options ne sont plus
  /// les mêmes.
  CreationDraft selectClass(String id) => id == classId
      ? this
      : _with(
          classId: id,
          classSkills: const [],
          classTools: const [],
          masteries: const [],
          clearFightingStyle: true,
          choices: _without(classSpellsPrefix),
          clearClassEquipment: true,
        );

  /// Un autre Historique efface l'outil et les sorts de son don : leurs
  /// options ne sont plus les mêmes.
  /// Les bonus restent : le joueur voit ce qui est devenu invalide.
  CreationDraft selectBackground(String id) => id == backgroundId
      ? this
      : _with(
          backgroundId: id,
          clearTool: true,
          choices: _without(initiateKey(InitiatePlace.background, '')),
          clearBackgroundEquipment: true,
        );

  CreationDraft selectTool(String id) => _with(toolChoice: id);

  /// Une seule taille possible est retenue d'office ; sinon elle reste à
  /// choisir.
  CreationDraft selectSpecies(String id, List<String> sizes) => id == speciesId
      ? this
      : _with(
          speciesId: id,
          size: sizes.length == 1 ? sizes.single : null,
          clearSize: sizes.length != 1,
          clearOriginFeat: true,
          choices: _without(initiateKey(InitiatePlace.species, '')),
        );

  CreationDraft selectSize(String value) => _with(size: value);

  /// Coche ou décoche une langue ; on ne dépasse pas le nombre permis.
  CreationDraft toggleLanguage(String id) {
    if (languages.contains(id)) {
      return _with(languages: [...languages]..remove(id));
    }
    return languages.length < startingLanguageChoices
        ? _with(languages: [...languages, id])
        : this;
  }

  /// Complète au hasard les places libres parmi [options].
  CreationDraft drawLanguages(List<String> options, [Random? random]) {
    final free = options.where((id) => !languages.contains(id)).toList()
      ..shuffle(random);
    final missing = startingLanguageChoices - languages.length;
    return _with(languages: [...languages, ...free.take(missing)]);
  }

  /// `true` si [code] peut encore augmenter : valeur et budget le permettent.
  bool canRaise(String code) {
    final cost = pointBuyCosts[scores[code]! + 1];
    return cost != null &&
        cost - pointBuyCosts[scores[code]!]! <= remainingPoints;
  }

  bool canLower(String code) => pointBuyCosts.containsKey(scores[code]! - 1);

  CreationDraft raiseScore(String code) => canRaise(code)
      ? _with(scores: {...scores, code: scores[code]! + 1})
      : this;

  CreationDraft lowerScore(String code) => canLower(code)
      ? _with(scores: {...scores, code: scores[code]! - 1})
      : this;

  /// Changer de répartition vide les bonus : ils n'ont plus le même sens.
  CreationDraft setDistribution(String value) => value == distribution
      ? this
      : _with(distribution: value, bonuses: const {});

  /// Pose ou retire un bonus. En `2-1`, chaque valeur n'existe qu'une fois :
  /// la poser ailleurs la déplace.
  CreationDraft setBonus(String code, int value) {
    final next = {...bonuses};
    if (next[code] == value) {
      next.remove(code);
    } else {
      if (distribution == '2-1') next.removeWhere((_, v) => v == value);
      next[code] = value;
    }
    return _with(bonuses: next);
  }

  CreationDraft toggleClassSkill(String id, int count) =>
      _with(classSkills: _toggled(classSkills, id, count));

  CreationDraft toggleClassTool(String id, int count) =>
      _with(classTools: _toggled(classTools, id, count));

  CreationDraft toggleMastery(String id, int count) =>
      _with(masteries: _toggled(masteries, id, count));

  CreationDraft selectFightingStyle(String id) => _with(fightingStyle: id);

  CreationDraft selectOriginFeat(String id) => id == originFeat
      ? this
      : _with(
          originFeat: id,
          choices: _without(initiateKey(InitiatePlace.species, '')),
        );

  /// Un autre lot efface l'outil qu'il demandait.
  CreationDraft selectClassEquipment(int index) => index == classEquipment
      ? this
      : _with(classEquipment: index, clearEquipmentTool: true);

  CreationDraft selectBackgroundEquipment(int index) =>
      _with(backgroundEquipment: index);

  CreationDraft selectEquipmentTool(String id) => _with(equipmentTool: id);

  CreationDraft withDetails({
    String? name,
    String? alignment,
    String? appearance,
    String? personality,
    String? backstory,
  }) => _with(
    name: name,
    alignment: alignment,
    appearance: appearance,
    personality: personality,
    backstory: backstory,
  );

  /// Une autre liste efface les sorts de cette place.
  CreationDraft selectInitiateList(InitiatePlace place, String list) =>
      choices[initiateKey(place, 'list')]?.contains(list) ?? false
      ? this
      : _with(
          choices: {
            ...choices,
            initiateKey(place, 'list'): [list],
            initiateKey(place, 'cantrips'): const [],
            initiateKey(place, 'spell'): const [],
          },
        );

  /// Un sort retiré du grimoire n'est plus préparé.
  CreationDraft toggleSpellbook(String id, int count) {
    final book = _toggled(choices[spellbookKey] ?? const [], id, count);
    return _with(
      choices: {
        ...choices,
        spellbookKey: book,
        preparedKey: [
          for (final spell in choices[preparedKey] ?? const <String>[])
            if (book.contains(spell)) spell,
        ],
      },
    );
  }

  Map<String, List<String>> _without(String prefix) => {
    for (final entry in choices.entries)
      if (!entry.key.startsWith(prefix)) entry.key: entry.value,
  };

  /// Sélectionne ou retire [id] dans [section].
  CreationDraft toggleOption(Subchoice section, String id) {
    final count = section.count;
    return switch (section.kind) {
      SubchoiceKind.classSkills => toggleClassSkill(id, count),
      SubchoiceKind.classTools => toggleClassTool(id, count),
      SubchoiceKind.masteries => toggleMastery(id, count),
      SubchoiceKind.fightingStyle => selectFightingStyle(id),
      SubchoiceKind.originFeat => selectOriginFeat(id),
      SubchoiceKind.spellbook => toggleSpellbook(id, count),
      SubchoiceKind.initiateList => selectInitiateList(section.place!, id),
      _ => togglePick(section.choiceId!, id, count),
    };
  }

  /// Sélection d'un effet `choice` ou d'un sort.
  CreationDraft togglePick(String choiceId, String pick, int count) => _with(
    choices: {
      ...choices,
      choiceId: _toggled(choices[choiceId] ?? const [], pick, count),
    },
  );

  /// À une place, une autre option remplace la précédente ; à plusieurs, on
  /// ne dépasse pas [count].
  static List<String> _toggled(List<String> list, String id, int count) {
    if (list.contains(id)) return [...list]..remove(id);
    if (count == 1) return [id];
    return list.length < count ? [...list, id] : list;
  }

  /// Va à une étape atteinte. Vers l'avant, toutes les étapes franchies
  /// doivent être complètes : un retour en arrière peut invalider un choix.
  CreationDraft goTo(int target, ActiveContent content) {
    if (target > reached) return this;
    for (var s = step; s < target; s++) {
      if (missingAt(this, s, content) != null) return this;
    }
    return _with(step: target);
  }

  CreationDraft previous() => step == 0 ? this : _with(step: step - 1);

  /// Passe à l'étape suivante si celle-ci est complète.
  CreationDraft next(ActiveContent content) {
    if (missingChoice(this, content) != null || step == creationStepCount - 1) {
      return this;
    }
    final target = step + 1;
    return _with(step: target, reached: target > reached ? target : reached);
  }

  CreationDraft _with({
    int? step,
    int? reached,
    String? classId,
    String? backgroundId,
    String? toolChoice,
    bool clearTool = false,
    String? speciesId,
    String? size,
    bool clearSize = false,
    List<String>? languages,
    Map<String, int>? scores,
    String? distribution,
    Map<String, int>? bonuses,
    List<String>? classSkills,
    List<String>? classTools,
    List<String>? masteries,
    String? fightingStyle,
    bool clearFightingStyle = false,
    String? originFeat,
    bool clearOriginFeat = false,
    Map<String, List<String>>? choices,
    int? classEquipment,
    bool clearClassEquipment = false,
    int? backgroundEquipment,
    bool clearBackgroundEquipment = false,
    String? equipmentTool,
    bool clearEquipmentTool = false,
    String? name,
    String? alignment,
    String? appearance,
    String? personality,
    String? backstory,
  }) => CreationDraft(
    step: step ?? this.step,
    reached: reached ?? this.reached,
    classId: classId ?? this.classId,
    backgroundId: backgroundId ?? this.backgroundId,
    toolChoice: clearTool ? null : toolChoice ?? this.toolChoice,
    speciesId: speciesId ?? this.speciesId,
    size: clearSize ? null : size ?? this.size,
    languages: languages ?? this.languages,
    scores: scores ?? this.scores,
    distribution: distribution ?? this.distribution,
    bonuses: bonuses ?? this.bonuses,
    classSkills: classSkills ?? this.classSkills,
    classTools: classTools ?? this.classTools,
    masteries: masteries ?? this.masteries,
    fightingStyle: clearFightingStyle
        ? null
        : fightingStyle ?? this.fightingStyle,
    originFeat: clearOriginFeat ? null : originFeat ?? this.originFeat,
    choices: choices ?? this.choices,
    classEquipment: clearClassEquipment
        ? null
        : classEquipment ?? this.classEquipment,
    backgroundEquipment: clearBackgroundEquipment
        ? null
        : backgroundEquipment ?? this.backgroundEquipment,
    equipmentTool: clearEquipmentTool || clearClassEquipment
        ? null
        : equipmentTool ?? this.equipmentTool,
    name: name ?? this.name,
    alignment: alignment ?? this.alignment,
    appearance: appearance ?? this.appearance,
    personality: personality ?? this.personality,
    backstory: backstory ?? this.backstory,
  );
}

/// Caractéristiques que l'Historique du brouillon autorise à augmenter.
Set<String> eligibleAbilities(CreationDraft draft, ActiveContent content) {
  final id = draft.backgroundId;
  final data = id == null ? null : content.entity(id)?.data;
  if (data is! BackgroundData) return const {};
  final ids = {for (final a in data.abilities) '$a'};
  return {
    for (final code in abilityCodes)
      if (ids.contains(abilityIdByCode[code])) code,
  };
}

/// Choix manquant de l'étape affichée, ou `null` si elle est complète.
MissingChoice? missingChoice(CreationDraft draft, ActiveContent content) =>
    missingAt(draft, draft.step, content);

/// Choix manquant de l'étape [step], ou `null` si elle est complète.
MissingChoice? missingAt(CreationDraft draft, int step, ActiveContent content) {
  switch (step) {
    case 0:
      return draft.classId == null ? MissingChoice.classChoice : null;
    case 1:
      if (draft.backgroundId == null) return MissingChoice.background;
      final background =
          content.entity(draft.backgroundId!)?.data as BackgroundData?;
      return background?.toolChoiceCategory != null && draft.toolChoice == null
          ? MissingChoice.tool
          : null;
    case 2:
      if (draft.speciesId == null) return MissingChoice.species;
      return draft.size == null ? MissingChoice.size : null;
    case 3:
      return draft.languages.length < startingLanguageChoices
          ? MissingChoice.languages
          : null;
    case 4:
      if (draft.remainingPoints != 0) return MissingChoice.points;
      final eligible = eligibleAbilities(draft, content);
      if (draft.bonuses.keys.any((code) => !eligible.contains(code))) {
        return MissingChoice.bonusInvalid;
      }
      final values = draft.bonuses.values.toList()..sort();
      final expected = draft.distribution == '2-1' ? [1, 2] : [1, 1, 1];
      return '$values' == '$expected' ? null : MissingChoice.bonus;
    case 5:
      return subchoiceSections(draft, content).every((s) => s.complete)
          ? null
          : MissingChoice.subchoices;
    case 6:
      final cls = content.entity(draft.classId ?? '')?.data as ClassData?;
      final index = draft.classEquipment;
      if (cls == null || index == null) return MissingChoice.classEquipment;
      final lot = cls.startingEquipment[index];
      if (draft.backgroundEquipment == null) {
        return MissingChoice.backgroundEquipment;
      }
      return lot.toolChoice.isNotEmpty && draft.equipmentTool == null
          ? MissingChoice.equipmentTool
          : null;
    case 7:
      return draft.name.trim().isEmpty ? MissingChoice.name : null;
    case 8:
      final sheet = computeSheet(toCharacterInput(draft, content), content);
      return sheet.integrityErrors.isEmpty ? null : MissingChoice.rules;
    default:
      return null;
  }
}
