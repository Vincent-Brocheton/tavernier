import 'package:dnd_content/dnd_content.dart';

import 'active_content.dart';
import 'character_input.dart';
import 'sheet_spells.dart';

/// Po par niveau de sort pour recopier un sort (SRD, Grimoire).
const copyGoldPerLevel = 50;

/// Heures par niveau de sort pour recopier un sort (SRD, Grimoire).
const copyHoursPerLevel = 2;

/// Sorts préparés qu'une classe peut remplacer d'un coup ; `null` sans limite.
int? changeLimit(ClassData data) =>
    data.preparedChange == PreparedChange.longRestAll ? null : 1;

/// Sorts mineurs qu'une classe peut remplacer d'un coup (SRD, chaque classe).
const cantripChangeLimit = 1;

/// [character] avec, pour [classId], ces sorts préparés et sorts mineurs. Les
/// sorts des autres classes ne bougent pas.
CharacterInput withClassSpells(
  CharacterInput character,
  ActiveContent content,
  String classId, {
  required List<String> prepared,
  required List<String> cantrips,
}) {
  final spells = character.spells;
  final mine = {
    for (final spell in sheetSpells(character, content))
      if (spell.classId == classId && spell.origin == SpellOrigin.classList)
        spell.id,
  };
  return character.copyWith(
    spells: spells.copyWith(
      prepared: [
        ...spells.prepared.where((id) => !mine.contains(id)),
        ...prepared,
      ],
      cantrips: [
        ...spells.cantrips.where((id) => !mine.contains(id)),
        ...cantrips,
      ],
      classes: {
        ...spells.classes,
        for (final id in [...prepared, ...cantrips]) id: classId,
      },
    ),
  );
}

/// [character] après avoir recopié dans son grimoire [spellId], de niveau
/// [level].
CharacterInput copySpell(
  CharacterInput character,
  String spellId,
  int level,
  String classId,
) {
  final spells = character.spells;
  return character.copyWith(
    spells: spells.copyWith(
      spellbook: [...spells.spellbook, spellId],
      classes: {...spells.classes, spellId: classId},
    ),
    coins: {
      ...character.coins,
      'gp': (character.coins['gp'] ?? 0) - copyGoldPerLevel * level,
    },
  );
}
