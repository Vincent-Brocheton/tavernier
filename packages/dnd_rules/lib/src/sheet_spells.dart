import 'package:dnd_content/dnd_content.dart';

import 'active_content.dart';
import 'character_input.dart';
import 'creation_choices.dart';

/// Origine d'un sort de la fiche.
enum SpellOrigin { classList, granted, feat }

/// Un sort de la fiche.
final class SheetSpell {
  const SheetSpell({
    required this.id,
    required this.origin,
    this.classId,
    this.prepared = false,
    this.inSpellbook = false,
  });

  final String id;
  final SpellOrigin origin;

  /// Classe du sort ; vide pour un trait d'espèce ou un don.
  final String? classId;
  final bool prepared;
  final bool inSpellbook;

  /// Accordé par une aptitude, un trait ou un don : hors décompte des préparés.
  bool get alwaysPrepared => origin != SpellOrigin.classList;
}

/// Aptitudes de [entry] atteintes à son niveau, sous-classe comprise.
List<String> _classSources(ClassLevelInput entry, ActiveContent content) => [
  if (content.entity(entry.classId)?.data case final ClassData data)
    for (final row in data.levels)
      if (row.level <= entry.level) ...row.features.map((id) => '$id'),
  if (content.entity(entry.subclassId ?? '')?.data case final SubclassData data)
    for (final id in data.features)
      if (content.entity('$id')?.data case final FeatureData feature)
        if ((feature.level ?? 1) <= entry.level) '$id',
];

/// Sorts de [character] : ceux de ses classes, puis ceux qui lui sont accordés
/// (au niveau de la classe qui les accorde) et ceux de ses dons.
List<SheetSpell> sheetSpells(CharacterInput character, ActiveContent content) {
  final spells = character.spells;
  final caster = character.classLevels
      .where((c) {
        final data = content.entity(c.classId)?.data;
        return data is ClassData && data.spellcastingAbility != null;
      })
      .firstOrNull
      ?.classId;
  String? classOf(String id) => spells.classes[id] ?? caster;

  final found = <String, SheetSpell>{};
  void add(SheetSpell spell) => found.putIfAbsent(spell.id, () => spell);

  for (final id in {
    ...spells.cantrips,
    ...spells.prepared,
    ...spells.spellbook,
  }) {
    add(
      SheetSpell(
        id: id,
        origin: SpellOrigin.classList,
        classId: classOf(id),
        prepared: spells.prepared.contains(id),
        inSpellbook: spells.spellbook.contains(id),
      ),
    );
  }
  for (final entry in character.classLevels) {
    final granted = grantedSpells(
      content,
      _classSources(entry, content),
      character.choices,
      level: entry.level,
    );
    for (final id in granted) {
      add(
        SheetSpell(id: id, origin: SpellOrigin.granted, classId: entry.classId),
      );
    }
  }
  if (content.entity(character.speciesId)?.data case final SpeciesData data) {
    final level = character.classLevels.fold(0, (sum, c) => sum + c.level);
    final granted = grantedSpells(
      content,
      data.traits.map((id) => '$id'),
      character.choices,
      level: level,
    );
    for (final id in granted) {
      add(SheetSpell(id: id, origin: SpellOrigin.granted));
    }
  }
  for (final feat in character.feats) {
    for (final id in [
      ...?(feat.choices?['cantrips'] as List<Object?>?)?.map((id) => '$id'),
      if (feat.choices?['level_1_spell'] case final String spell) spell,
    ]) {
      add(SheetSpell(id: id, origin: SpellOrigin.feat));
    }
  }
  return [...found.values];
}
