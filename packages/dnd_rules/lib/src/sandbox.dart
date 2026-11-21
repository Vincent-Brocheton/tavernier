// Bac à sable d'une entité homebrew (US-28, EF-HB-03, [H04]) : un prétiré
// construit à partir du contenu, et la comparaison de sa fiche sans puis
// avec l'entité.
import 'package:dnd_content/dnd_content.dart';

import 'active_content.dart';
import 'character_input.dart';
import 'compute_sheet.dart';
import 'computed_sheet.dart';
import 'suggestions.dart';

/// Bouclier du SRD, porté à la demande.
const sandboxShieldId = 'srd:armor:shield';

/// Prétiré de [classId] au [level], avec les suggestions de la création :
/// tableau standard de la classe, bonus d'Historique 2-1, compétences, don
/// d'origine, option A d'équipement de départ (première armure et première
/// arme portées). La sous-classe vient à son niveau.
CharacterInput sandboxCharacter(
  ActiveContent content, {
  required String classId,
  required int level,
  String? subclassId,
  String speciesId = 'srd:species:human',
  String backgroundId = 'srd:background:soldier',
  bool shield = false,
  List<FeatInput> feats = const [],
  List<ItemInput> items = const [],
}) {
  final data = content.entity(classId)?.data;
  final cls = data is ClassData ? data : null;
  final background = switch (content.entity(backgroundId)?.data) {
    final BackgroundData b => b,
    _ => null,
  };
  final species = switch (content.entity(speciesId)?.data) {
    final SpeciesData s => s,
    _ => null,
  };
  final scores = cls == null
      ? {for (final code in abilityCodes) code: 10}
      : suggestedScores(classId, cls);
  final eligible = {
    for (final id in background?.abilities ?? const <ContentId>[])
      '$id'.split(':').last.substring(0, 3),
  };

  // Équipement A : la première armure et la première arme sont portées.
  var armorWorn = false;
  var weaponWorn = false;
  final starting = [
    for (final q
        in cls?.startingEquipment.firstOrNull?.items ?? const <ItemQuantity>[])
      switch (content.entity('${q.item}')?.data) {
        ArmorData(:final category)
            when category != ArmorCategory.shield && !armorWorn =>
          ItemInput(
            itemId: '${q.item}',
            quantity: q.quantity,
            equipped: armorWorn = true,
          ),
        WeaponData() when !weaponWorn => ItemInput(
          itemId: '${q.item}',
          quantity: q.quantity,
          equipped: weaponWorn = true,
        ),
        _ => ItemInput(itemId: '${q.item}', quantity: q.quantity),
      },
  ];

  return CharacterInput(
    name: content.entity(classId)?.name ?? classId,
    kind: 'pc',
    speciesId: speciesId,
    speciesChoices: {'size': ?species?.sizes.firstOrNull},
    backgroundId: backgroundId,
    baseScores: BaseScores(
      method: ScoreMethod.standardArray,
      strength: scores['str']!,
      dexterity: scores['dex']!,
      constitution: scores['con']!,
      intelligence: scores['int']!,
      wisdom: scores['wis']!,
      charisma: scores['cha']!,
    ),
    backgroundChoice: BackgroundChoice(
      distribution: '2-1',
      bonuses: suggestedBonuses(scores, eligible),
    ),
    classLevels: [
      ClassLevelInput(
        classId: classId,
        level: level,
        subclassId: cls != null && level >= cls.subclassLevel
            ? subclassId
            : null,
        skillChoices: cls == null
            ? const []
            : suggestedSkills(content, cls, [
                for (final s in cls.skillChoices) '$s',
              ], cls.skillChoiceCount),
      ),
    ],
    feats: [
      if (background != null)
        FeatInput(
          featId: '${background.originFeat}',
          sourceType: 'background',
          sourceRef: backgroundId,
        ),
      ...feats,
    ],
    items: [
      ...starting,
      if (shield)
        const ItemInput(itemId: sandboxShieldId, quantity: 1, equipped: true),
      ...items,
    ],
  );
}

/// Valeur comparée de [H04].
enum SheetRowKind {
  armorClass,
  hitPoints,
  initiative,
  speed,
  passivePerception,
  savingThrow,
  skill,
  resource,
  darkvision,
  attacksPerAction,
  spellSlot,
  attack,
}

/// Une ligne : valeur sans l'entité (absente sans fiche « sans »), valeur
/// avec, et les sources de la valeur avec qui n'étaient pas dans la valeur
/// sans (identifiants d'entité ou codes comme `dex`).
final class SheetRow {
  const SheetRow(
    this.kind,
    this.after, {
    this.ref,
    this.before,
    this.sources = const [],
  });

  final SheetRowKind kind;
  final String? ref;
  final String? before;
  final String after;
  final List<String> sources;

  @override
  String toString() => '${kind.name} $ref : $before → $after $sources';
}

/// Lignes de la comparaison, et règles enfreintes qu'ajoute l'entité.
final class SheetComparison {
  const SheetComparison(this.rows, this.addedErrors);

  final List<SheetRow> rows;
  final List<IntegrityError> addedErrors;
}

String _signed(int v) => v < 0 ? '$v' : '+$v';

String _attack(Attack a) => '${_signed(a.attackBonus)} · ${a.damage}';

/// Compare la fiche [before] (sans l'entité, ou `null`) à [after] (avec).
SheetComparison compareSheets(ComputedSheet? before, ComputedSheet after) {
  final rows = <SheetRow>[];
  List<String> added(Computed? old, Computed now) {
    final known = {
      for (final c in old?.sources ?? const <Contribution>[]) c.label,
    };
    return {
      for (final c in now.sources)
        if (!known.contains(c.label) && c.value != 0) c.label,
    }.toList();
  }

  void always(
    SheetRowKind kind,
    Computed? old,
    Computed now, {
    bool sign = false,
  }) {
    String show(int v) => sign ? _signed(v) : '$v';
    rows.add(
      SheetRow(
        kind,
        show(now.value),
        before: old == null ? null : show(old.value),
        sources: added(old, now),
      ),
    );
  }

  /// Ligne d'une valeur sans détail, seulement si elle change.
  void changed(SheetRowKind kind, String ref, int? old, int now) {
    if (before != null && (old ?? 0) == now) return;
    if (before == null && now == 0) return;
    rows.add(
      SheetRow(
        kind,
        '$now',
        ref: ref,
        before: before == null ? null : '${old ?? 0}',
      ),
    );
  }

  always(SheetRowKind.armorClass, before?.armorClass, after.armorClass);
  always(SheetRowKind.hitPoints, before?.hitPointsMax, after.hitPointsMax);
  always(
    SheetRowKind.initiative,
    before?.initiative,
    after.initiative,
    sign: true,
  );
  always(SheetRowKind.speed, before?.speed, after.speed);
  rows.add(
    SheetRow(
      SheetRowKind.passivePerception,
      '${after.passivePerception}',
      before: before == null ? null : '${before.passivePerception}',
    ),
  );

  for (final (kind, now, old) in [
    (SheetRowKind.savingThrow, after.saveBreakdown, before?.saveBreakdown),
    (SheetRowKind.skill, after.skillBreakdown, before?.skillBreakdown),
  ]) {
    for (final MapEntry(key: ref, value: value) in now.entries) {
      final previous = old?[ref];
      if (before != null && previous?.value == value.value) continue;
      if (before == null) continue;
      rows.add(
        SheetRow(
          kind,
          _signed(value.value),
          ref: ref,
          before: previous == null ? null : _signed(previous.value),
          sources: added(previous, value),
        ),
      );
    }
  }
  for (final id in {...?before?.resources.keys, ...after.resources.keys}) {
    changed(
      SheetRowKind.resource,
      id,
      before?.resources[id],
      after.resources[id] ?? 0,
    );
  }
  changed(
    SheetRowKind.darkvision,
    'darkvision',
    before?.darkvisionFeet,
    after.darkvisionFeet,
  );
  if (before == null || before.attacksPerAction != after.attacksPerAction) {
    rows.add(
      SheetRow(
        SheetRowKind.attacksPerAction,
        '${after.attacksPerAction}',
        before: before == null ? null : '${before.attacksPerAction}',
      ),
    );
  }
  final slots = before?.spellSlots ?? const <int>[];
  for (var i = 0; i < after.spellSlots.length || i < slots.length; i++) {
    changed(
      SheetRowKind.spellSlot,
      '${i + 1}',
      slots.elementAtOrNull(i),
      after.spellSlots.elementAtOrNull(i) ?? 0,
    );
  }
  for (final a in after.attacks) {
    final old = before?.attacks
        .where((b) => b.weaponId == a.weaponId)
        .firstOrNull;
    final known = {
      for (final c in old?.sources ?? const <Contribution>[]) c.label,
    };
    rows.add(
      SheetRow(
        SheetRowKind.attack,
        _attack(a),
        ref: a.weaponId,
        before: old == null ? null : _attack(old),
        sources: [
          for (final c in a.sources)
            if (!known.contains(c.label) && c.value != 0) c.label,
        ],
      ),
    );
  }

  String key(IntegrityError e) => '${e.rule.name}|${e.path}|${e.message}';
  final known = {
    for (final e in before?.integrityErrors ?? const <IntegrityError>[]) key(e),
  };
  return SheetComparison(rows, [
    for (final e in after.integrityErrors)
      if (!known.contains(key(e))) e,
  ]);
}
