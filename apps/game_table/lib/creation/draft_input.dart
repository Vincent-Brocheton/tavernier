import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';

import 'creation_draft.dart';
import 'subchoices.dart';

/// Clé des outils de classe dans `CharacterInput.choices`.
const classToolsKey = 'class-tools';

/// Lots retenus : la classe et l'Historique, avec l'outil éventuel.
List<ItemInput> _items(CreationDraft draft, ActiveContent content) {
  final cls = content.entity(draft.classId!)!.data as ClassData;
  final background =
      content.entity(draft.backgroundId!)!.data as BackgroundData;
  final quantities = <String, int>{};
  void add(String id, int quantity) =>
      quantities[id] = (quantities[id] ?? 0) + quantity;

  for (final item in cls.startingEquipment[draft.classEquipment!].items) {
    add('${item.item}', item.quantity);
  }
  if (draft.equipmentTool case final tool?) add(tool, 1);
  if (draft.backgroundEquipment == 0) {
    for (final item in background.equipmentA) {
      add('${item.item}', item.quantity);
    }
  }
  return [
    for (final MapEntry(key: id, value: quantity) in quantities.entries)
      ItemInput(
        itemId: id,
        quantity: quantity,
        // Armure et bouclier sont portés d'office [P8].
        equipped: content.entity(id)?.data is ArmorData,
      ),
  ];
}

int _gold(CreationDraft draft, ActiveContent content) {
  final cls = content.entity(draft.classId!)!.data as ClassData;
  final background =
      content.entity(draft.backgroundId!)!.data as BackgroundData;
  return cls.startingEquipment[draft.classEquipment!].gold +
      (draft.backgroundEquipment == 0 ? background.goldA : background.goldB);
}

/// Choix d'un Initié à la magie, au format des fixtures [D1].
Map<String, Object?> _initiate(Iterable<Subchoice> all) {
  List<String> chosen(SubchoiceKind kind) =>
      all.where((s) => s.kind == kind).firstOrNull?.chosen ?? const [];
  final ability = chosen(SubchoiceKind.initiateAbility).firstOrNull;
  return {
    'spell_list': all
        .firstWhere((s) => s.kind == SubchoiceKind.initiateCantrips)
        .listId,
    // `srd:ability:wisdom` devient `wis`.
    'ability': abilityIdByCode.entries
        .firstWhere((e) => e.value == ability)
        .key,
    'cantrips': chosen(SubchoiceKind.initiateCantrips),
    'level_1_spell': chosen(SubchoiceKind.initiateSpell).firstOrNull,
  };
}

/// Convertit un brouillon complet. Seules les sections ouvertes comptent : une
/// sélection restée dans `choices` après un changement de classe n'est pas
/// enregistrée.
CharacterInput toCharacterInput(CreationDraft draft, ActiveContent content) {
  final sections = subchoiceSections(draft, content);
  List<String> chosen(SubchoiceKind kind) =>
      sections.where((s) => s.kind == kind).firstOrNull?.chosen ?? const [];
  Map<String, Object?>? initiate(InitiatePlace place) {
    final own = sections.where((s) => s.place == place);
    return own.isEmpty ? null : _initiate(own);
  }

  final effects = sections.where((s) => s.kind == SubchoiceKind.effect);
  bool isFeat(Subchoice s) => content.entity(s.sourceId!)?.data is FeatData;
  Map<String, Object?>? featChoices(String featId, InitiatePlace place) {
    final own = {
      for (final s in effects)
        if (s.sourceId == featId) s.choiceId!: s.chosen,
    };
    final merged = {...own, ...?initiate(place)};
    return merged.isEmpty ? null : merged;
  }

  final background =
      content.entity(draft.backgroundId!)!.data as BackgroundData;
  String? optional(String text) => text.trim().isEmpty ? null : text.trim();
  final s = draft.scores;

  return CharacterInput(
    name: draft.name.trim(),
    kind: 'pc',
    speciesId: draft.speciesId!,
    speciesChoices: {'size': draft.size!},
    backgroundId: draft.backgroundId!,
    baseScores: BaseScores(
      method: ScoreMethod.pointBuy,
      strength: s['str']!,
      dexterity: s['dex']!,
      constitution: s['con']!,
      intelligence: s['int']!,
      wisdom: s['wis']!,
      charisma: s['cha']!,
    ),
    backgroundChoice: BackgroundChoice(
      distribution: draft.distribution,
      bonuses: draft.bonuses,
      toolChoice: draft.toolChoice,
    ),
    classLevels: [
      ClassLevelInput(
        classId: draft.classId!,
        level: 1,
        skillChoices: draft.classSkills,
      ),
    ],
    feats: [
      FeatInput(
        featId: '${background.originFeat}',
        sourceType: 'background',
        sourceRef: draft.backgroundId!,
        choices: featChoices(
          '${background.originFeat}',
          InitiatePlace.background,
        ),
      ),
      if (draft.originFeat case final feat?)
        FeatInput(
          featId: feat,
          sourceType: 'species',
          sourceRef: draft.speciesId!,
          choices: featChoices(feat, InitiatePlace.species),
        ),
      if (draft.fightingStyle case final feat?)
        FeatInput(featId: feat, sourceType: 'class', sourceRef: draft.classId!),
    ],
    choices: {
      for (final section in effects)
        if (!isFeat(section)) section.choiceId!: section.chosen,
      if (draft.classTools.isNotEmpty) classToolsKey: draft.classTools,
    },
    languages: [startingLanguageId, ...draft.languages],
    weaponMasteries: [
      for (final (i, weapon) in draft.masteries.indexed)
        WeaponMasteryInput(weaponId: weapon, slotIndex: i),
    ],
    items: _items(draft, content),
    spells: SpellsInput(
      cantrips: chosen(SubchoiceKind.cantrips),
      prepared: chosen(SubchoiceKind.preparedSpells),
      spellbook: chosen(SubchoiceKind.spellbook),
    ),
    coins: {'gp': _gold(draft, content)},
    alignment: draft.alignment,
    appearance: optional(draft.appearance),
    personality: optional(draft.personality),
    backstory: optional(draft.backstory),
  );
}

/// Armes dont le personnage a choisi la botte sans les posséder : une alerte
/// du Récapitulatif, qui ne bloque pas [P8].
List<String> masteriesWithoutWeapon(CharacterInput character) {
  final owned = {for (final item in character.items) item.itemId};
  return [
    for (final mastery in character.weaponMasteries)
      if (!owned.contains(mastery.weaponId)) mastery.weaponId,
  ];
}
