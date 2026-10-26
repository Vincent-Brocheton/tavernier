import 'package:dnd_content/dnd_content.dart';

import 'active_content.dart';
import 'character_input.dart';
import 'computed_sheet.dart';

const abilityCodes = ['str', 'dex', 'con', 'int', 'wis', 'cha'];

/// SRD p. 22, « Coût des valeurs de caractéristique ».
const _pointBuyCost = {8: 0, 9: 1, 10: 2, 11: 3, 12: 4, 13: 5, 14: 7, 15: 9};

/// SRD p. 22, « Valeurs standard ».
const _standardArray = [15, 14, 13, 12, 10, 8];

/// Effet actif : sa source (entité porteuse), son origine (`species`,
/// `class`, `feat`) et le niveau qui résout ses tables `by_level`.
typedef _Active = ({String source, String origin, Effect effect, int level});

/// Calcule la fiche d'un personnage (cahier §10.3) : fonction pure, sans
/// base, réseau ni Flutter. Les règles enfreintes sont listées dans
/// [ComputedSheet.integrityErrors], jamais levées.
ComputedSheet computeSheet(CharacterInput character, ActiveContent content) {
  final errors = <IntegrityError>[];
  final level = character.classLevels.fold(0, (sum, c) => sum + c.level);
  final pb = _proficiencyBonus(level);

  T? data<T extends EntityData>(String id, String path) {
    final entity = content.entity(id);
    if (entity?.data case final T found) return found;
    errors.add(
      IntegrityError(
        IntegrityRule.reference,
        path,
        'contenu introuvable : $id',
      ),
    );
    return null;
  }

  final species = data<SpeciesData>(character.speciesId, 'species_id');
  final background = data<BackgroundData>(
    character.backgroundId,
    'background_id',
  );
  final classes = [
    for (final (i, c) in character.classLevels.indexed)
      (input: c, data: data<ClassData>(c.classId, 'class_levels[$i].class_id')),
  ];

  final abilities = {
    for (final code in abilityCodes)
      code: AbilityScore([
        Contribution('base', character.baseScores.of(code)),
        if (character.backgroundChoice.bonuses[code] case final bonus?
            when bonus != 0)
          Contribution(character.backgroundId, bonus),
      ]),
  };
  int mod(String code) => abilities[code]!.modifier;

  final active = _activeEffects(character, content, species, classes, level);
  Iterable<_Active> ofOp(String op) => active.where((a) => a.effect.op == op);
  int resolve(Object? value, int atLevel) =>
      _resolve(value, atLevel, pb, abilities);

  // Maîtrises de compétence et jets de sauvegarde.
  final skillIds = {
    ...?background?.skillProficiencies.map((id) => '$id'),
    if (character.classLevels.firstOrNull case final first?)
      ...first.skillChoices,
    for (final a in ofOp('grant_proficiency'))
      if (a.effect.args['kind'] == 'skill') a.effect.args['ref']! as String,
  };
  final saveCodes = {
    for (final id in classes.firstOrNull?.data?.savingThrows ?? <ContentId>[])
      ?_codeOf('$id'),
  };
  final skills = <String, int>{};
  final skillProficiencies = <String>[];
  for (final skill in content.entities.where((e) => e.type == 'skill')) {
    final key = skill.id.slug.replaceAll('-', '_');
    final code = _codeOf('${(skill.data as SkillData).ability}') ?? 'str';
    final proficient = skillIds.contains('${skill.id}');
    skills[key] = mod(code) + (proficient ? pb : 0);
    if (proficient) skillProficiencies.add(key);
  }

  // Équipement porté.
  final equipped = [
    for (final item in character.items)
      if (item.equipped) content.entity(item.itemId),
  ].nonNulls;
  ArmorData? armorData(ContentEntity e) =>
      e.data is ArmorData ? e.data as ArmorData : null;
  final armor = equipped.where((e) {
    final category = armorData(e)?.category;
    return category != null && category != ArmorCategory.shield;
  }).firstOrNull;
  final shield = equipped
      .where((e) => armorData(e)?.category == ArmorCategory.shield)
      .firstOrNull;
  bool applies(Effect effect) {
    final category = armor == null ? null : armorData(armor)!.category;
    final armorOk = switch (effect.when['armor']) {
      'any' => armor != null,
      'none' => armor == null,
      'heavy' => category == ArmorCategory.heavy,
      'not_heavy' => category != ArmorCategory.heavy,
      _ => true,
    };
    final shieldWanted = effect.when['shield'];
    return armorOk &&
        (shieldWanted == null || shieldWanted == (shield != null));
  }

  final armorClass = Computed([
    if (armor != null) ...[
      Contribution('${armor.id}', armorData(armor)!.baseAc),
      if (_dexToAc(armorData(armor)!, mod('dex')) case final dex when dex != 0)
        Contribution('dex', dex),
    ] else ...[
      const Contribution('base', 10),
      Contribution('dex', mod('dex')),
    ],
    if (shield != null) Contribution('${shield.id}', armorData(shield)!.baseAc),
    for (final a in ofOp('modify_ac'))
      if (applies(a.effect))
        Contribution(a.source, resolve(a.effect.args['value'], a.level)),
  ]);

  final initiativeEffects = ofOp('modify_initiative').toList();
  final initiative = Initiative(
    [
      Contribution('dex', mod('dex')),
      for (final a in initiativeEffects)
        if (a.effect.args['add'] case final add?)
          Contribution(a.source, resolve(add, a.level)),
    ],
    advantage: initiativeEffects.any((a) => a.effect.args['advantage'] == true),
  );

  final hitDie = classes.firstOrNull?.data?.hitDie ?? 0;
  final hitPointsMax = Computed([
    for (final (i, c) in classes.indexed)
      if (c.data case final cls?)
        Contribution(
          c.input.classId,
          // SRD p. 24-25 : maximum du dé au niveau 1, puis valeur fixe.
          (i == 0 ? cls.hitDie : 0) +
              (c.input.level - (i == 0 ? 1 : 0)) * (cls.hitDie ~/ 2 + 1),
        ),
    Contribution('con', mod('con') * level),
  ]);

  // Armes maîtrisées : catégories des classes et effets de maîtrise.
  final weaponCategories = {
    for (final c in classes) ...?c.data?.weaponProficiencies,
    for (final a in ofOp('grant_proficiency'))
      if (a.effect.args['kind'] == 'weapon_category')
        a.effect.args['ref']! as String,
  };
  final weaponIds = {
    for (final a in ofOp('grant_proficiency'))
      if (a.effect.args['kind'] == 'weapon') a.effect.args['ref']! as String,
  };
  bool proficientWith(ContentEntity weapon) =>
      weaponIds.contains('${weapon.id}') ||
      weaponCategories.contains((weapon.data as WeaponData).category.name);

  final masterySlots = [
    for (final a in ofOp('grant_mastery_slots'))
      resolve(a.effect.args['count'], a.level),
  ].fold(0, (sum, v) => sum + v);
  final masteries = <String>{};
  if (character.weaponMasteries.length > masterySlots) {
    errors.add(
      IntegrityError(
        IntegrityRule.weaponMastery,
        'weapon_masteries',
        '${character.weaponMasteries.length} bottes pour $masterySlots emplacements',
      ),
    );
  }
  for (final (i, m) in character.weaponMasteries.indexed) {
    final weapon = content.entity(m.weaponId);
    if (weapon?.data is! WeaponData) {
      errors.add(
        IntegrityError(
          IntegrityRule.reference,
          'weapon_masteries[$i]',
          'arme introuvable : ${m.weaponId}',
        ),
      );
    } else if (!proficientWith(weapon!)) {
      errors.add(
        IntegrityError(
          IntegrityRule.weaponMastery,
          'weapon_masteries[$i]',
          '${m.weaponId} : arme non maîtrisée par les classes du personnage',
        ),
      );
    } else {
      masteries.add(m.weaponId);
    }
  }

  // Attaques (SRD p. 97 et p. 189) ; bonus d'attaque des effets
  // `modify_check` (Archerie).
  int attackBonus(String scope) => [
    for (final a in ofOp('modify_check'))
      if (a.effect.args['scope'] == scope)
        resolve(a.effect.args['add'], a.level),
  ].fold(0, (sum, v) => sum + v);
  String withMod(String dice, int mod) =>
      mod == 0 ? dice : '$dice${mod > 0 ? '+' : ''}$mod';
  final attacks = <Attack>[
    for (final id in {for (final item in character.items) item.itemId})
      if (content.entity(id) case final weapon? when weapon.data is WeaponData)
        () {
          final w = weapon.data as WeaponData;
          final ranged = w.kind == WeaponKind.ranged;
          final abilityMod = w.properties.contains('finesse')
              ? [mod('str'), mod('dex')].reduce((a, b) => a > b ? a : b)
              : mod(ranged ? 'dex' : 'str');
          return Attack(
            weaponId: id,
            attackBonus:
                abilityMod +
                (proficientWith(weapon) ? pb : 0) +
                attackBonus(
                  ranged ? 'ranged_weapon_attack' : 'melee_weapon_attack',
                ),
            damage: withMod(w.damage, abilityMod),
            damageType: w.damageType.slug,
            rangeFeet: w.rangeFeet,
            mastery: masteries.contains(id) ? '${w.mastery}' : null,
          );
        }(),
    Attack(
      weaponId: 'unarmed',
      attackBonus: mod('str') + pb,
      damage: '${1 + mod('str')}',
      damageType: 'bludgeoning',
    ),
  ];

  // Cahier §11.3, SRD p. 26 : 13 dans une caractéristique principale de la
  // nouvelle classe et de chaque classe existante.
  bool meetsPrimary(ClassData cls) => cls.primaryAbilities.any(
    (id) => (abilities[_codeOf('$id')]?.value ?? 0) >= 13,
  );
  for (var i = 1; i < classes.length; i++) {
    final involved = [for (final c in classes.take(i + 1)) c.data].nonNulls;
    if (!involved.every(meetsPrimary)) {
      errors.add(
        IntegrityError(
          IntegrityRule.multiclass,
          'class_levels[$i]',
          'multiclassage : 13 requis dans la caractéristique principale de '
              'chaque classe',
        ),
      );
    }
  }

  for (final (i, f) in character.feats.indexed) {
    if (content.entity(f.featId)?.data is! FeatData) {
      errors.add(
        IntegrityError(
          IntegrityRule.reference,
          'feats[$i].feat_id',
          'contenu introuvable : ${f.featId}',
        ),
      );
    }
  }
  for (final (i, item) in character.items.indexed) {
    if (content.entity(item.itemId) == null) {
      errors.add(
        IntegrityError(
          IntegrityRule.reference,
          'items[$i].item_id',
          'contenu introuvable : ${item.itemId}',
        ),
      );
    }
  }

  errors
    ..addAll(_checkGeneration(character.baseScores))
    ..addAll(_checkBackgroundBonus(character, background, abilities))
    ..addAll(_checkFeats(character, content, background, active));

  return ComputedSheet(
    level: level,
    proficiencyBonus: pb,
    abilities: abilities,
    pointBuyCost: character.baseScores.method == ScoreMethod.pointBuy
        ? _cost(character.baseScores)
        : null,
    savingThrows: {
      for (final code in abilityCodes)
        code: mod(code) + (saveCodes.contains(code) ? pb : 0),
    },
    savingThrowProficiencies: [...saveCodes],
    skills: skills,
    skillProficiencies: skillProficiencies,
    passivePerception: 10 + (skills['perception'] ?? 0),
    initiative: initiative,
    armorClass: armorClass,
    speedFeet:
        (species?.speedFeet ?? 0) +
        [
          for (final a in ofOp('modify_speed'))
            if (a.effect.args['mode'] == 'walk' && applies(a.effect))
              resolve(a.effect.args['value'] ?? 0, a.level),
        ].fold(0, (sum, v) => sum + v),
    hitPointsMax: hitPointsMax,
    hitDice: (die: 'd$hitDie', total: level),
    resources: {
      for (final a in ofOp('grant_resource'))
        a.effect.args['id']! as String: resolve(a.effect.args['max'], a.level),
    },
    weaponMasterySlots: masterySlots,
    attacks: attacks,
    integrityErrors: errors,
  );
}

/// Effets actifs : traits d'espèce, dons, aptitudes de classe atteintes,
/// puis options retenues des effets `choice` (design §2 et §3).
List<_Active> _activeEffects(
  CharacterInput character,
  ActiveContent content,
  SpeciesData? species,
  List<({ClassLevelInput input, ClassData? data})> classes,
  int level,
) {
  final active = <_Active>[];
  void addFrom(String id, String origin, int atLevel) {
    for (final effect in content.entity(id)?.effects ?? const <Effect>[]) {
      active.add((source: id, origin: origin, effect: effect, level: atLevel));
    }
  }

  for (final trait in species?.traits ?? const <ContentId>[]) {
    addFrom('$trait', 'species', level);
  }
  for (final feat in character.feats) {
    addFrom(feat.featId, 'feat', level);
  }
  for (final c in classes) {
    for (final row in c.data?.levels ?? const <ClassLevelData>[]) {
      if (row.level > c.input.level) continue;
      for (final feature in row.features) {
        addFrom('$feature', 'class', c.input.level);
      }
    }
  }

  // Un `choice` ajoute les effets des options dont une référence est choisie.
  for (var i = 0; i < active.length; i++) {
    final a = active[i];
    if (a.effect.op != 'choice') continue;
    final picked = character.choices[a.effect.args['id']] ?? const <String>[];
    for (final option in a.effect.args['options']! as List<Object?>) {
      final effects = [
        for (final json in option! as List<Object?>)
          Effect.fromJson(json! as Map<String, Object?>),
      ];
      if (effects.any((e) => effectReferences(e).any(picked.contains))) {
        active.addAll([
          for (final e in effects)
            (source: a.source, origin: a.origin, effect: e, level: a.level),
        ]);
      }
    }
  }
  return active;
}

/// Résout une expression de valeur du DSL (docs/dsl/DSL_V1.md, principe 5).
int _resolve(
  Object? value,
  int level,
  int pb,
  Map<String, AbilityScore> abilities,
) {
  switch (value) {
    case int():
      return value;
    case {'by_level': final Map<String, Object?> table}:
      final reached = [
        for (final key in table.keys)
          if (int.parse(key) <= level) int.parse(key),
      ];
      return reached.isEmpty
          ? 0
          : table['${reached.reduce((a, b) => a > b ? a : b)}']! as int;
    case {'ref': final String ref}:
      final map = value as Map<String, Object?>;
      final base = switch (ref) {
        'proficiency_bonus' => pb,
        'ability_mod' => abilities[map['ability']]!.modifier,
        _ => level,
      };
      final min = map['min'] as int?;
      final floored = min != null && base < min ? min : base;
      return floored * ((map['times'] as int?) ?? 1);
    default:
      return 0;
  }
}

/// Part de la Dextérité dans la CA d'une armure (SRD p. 98).
int _dexToAc(ArmorData armor, int dex) =>
    armor.dexCap == null ? dex : (dex < armor.dexCap! ? dex : armor.dexCap!);

String? _codeOf(String abilityId) =>
    abilityIdByCode.entries.where((e) => e.value == abilityId).firstOrNull?.key;

/// Cahier §11.3 : chaque don correspond à un don accordé par sa source, dans
/// la catégorie exigée ; le don d'un Historique est son don d'origines.
List<IntegrityError> _checkFeats(
  CharacterInput character,
  ActiveContent content,
  BackgroundData? background,
  List<_Active> active,
) {
  final errors = <IntegrityError>[];
  void error(String message) =>
      errors.add(IntegrityError(IntegrityRule.featGrant, 'feats', message));

  final fromBackground = [
    for (final f in character.feats)
      if (f.sourceType == 'background') f.featId,
  ];
  if (background != null &&
      (fromBackground.length != 1 ||
          fromBackground.single != '${background.originFeat}')) {
    error("le don d'Historique doit être ${background.originFeat}");
  }

  for (final origin in ['species', 'class']) {
    final chosen = [
      for (final f in character.feats)
        if (f.sourceType == origin ||
            (origin == 'class' && f.sourceType == 'class_level'))
          f.featId,
    ];
    for (final a in active) {
      if (a.origin != origin || a.effect.op != 'grant_feat') continue;
      final grant = a.effect.args;
      final match = chosen.where((id) {
        final feat = content.entity(id)?.data;
        return grant['feat'] == id ||
            (feat is FeatData &&
                _categoryName(feat.category) == grant['category']);
      }).firstOrNull;
      if (match == null) {
        error(
          '${a.source} accorde un don ${grant['feat'] ?? grant['category']} non choisi',
        );
      } else {
        chosen.remove(match);
      }
    }
    for (final extra in chosen) {
      error('$extra : aucune aptitude ($origin) n\'accorde ce don');
    }
  }
  return errors;
}

/// Nom JSON d'une catégorie de don (`fighting_style`…).
String _categoryName(FeatCategory category) => category.name.replaceAllMapped(
  RegExp('[A-Z]'),
  (m) => '_${m[0]!.toLowerCase()}',
);

/// SRD p. 24, « Progression des personnages ».
int _proficiencyBonus(int level) => 2 + (level - 1) ~/ 4;

int _cost(BaseScores scores) =>
    abilityCodes.fold(0, (sum, c) => sum + (_pointBuyCost[scores.of(c)] ?? 99));

List<IntegrityError> _checkGeneration(BaseScores scores) {
  final values = [for (final c in abilityCodes) scores.of(c)]..sort();
  String? problem;
  switch (scores.method) {
    case ScoreMethod.pointBuy:
      if (values.any((v) => v < 8 || v > 15)) {
        problem = 'acquisition par points : valeurs de 8 à 15';
      } else if (_cost(scores) != 27) {
        problem =
            'acquisition par points : ${_cost(scores)} points au lieu de 27';
      }
    case ScoreMethod.standardArray:
      if ('$values' != '${[..._standardArray]..sort()}') {
        problem = 'valeurs standard : 15, 14, 13, 12, 10 et 8 attendues';
      }
    case ScoreMethod.random:
      final rolls = [...?scores.rolls]..sort();
      if (rolls.any((r) => r < 3 || r > 18) || '$rolls' != '$values') {
        problem = 'génération aléatoire : les valeurs doivent être les jets';
      }
  }
  return [
    if (problem != null)
      IntegrityError(IntegrityRule.abilityGeneration, 'base_scores', problem),
  ];
}

/// Cahier §11.3 : bonus sur les 3 caractéristiques de l'Historique, en 2-1
/// ou 1-1-1, sans dépasser 20 (SRD p. 87).
List<IntegrityError> _checkBackgroundBonus(
  CharacterInput character,
  BackgroundData? background,
  Map<String, AbilityScore> abilities,
) {
  final choice = character.backgroundChoice;
  final eligible = {
    for (final id in background?.abilities ?? const <ContentId>[])
      ?_codeOf('$id'),
  };
  final bonuses = choice.bonuses.entries.where((e) => e.value != 0);
  final values = [for (final e in bonuses) e.value]..sort();
  final expected = switch (choice.distribution) {
    '2-1' => [1, 2],
    '1-1-1' => [1, 1, 1],
    _ => null,
  };
  return [
    if (expected == null || '$values' != '$expected')
      const IntegrityError(
        IntegrityRule.backgroundBonus,
        'background_choice.bonuses',
        'répartition +2/+1 ou +1/+1/+1 attendue',
      ),
    for (final e in bonuses)
      if (!eligible.contains(e.key))
        IntegrityError(
          IntegrityRule.backgroundBonus,
          'background_choice.bonuses.${e.key}',
          'caractéristique non proposée par l\'Historique',
        ),
    for (final e in bonuses)
      if (abilities[e.key]!.value > 20)
        IntegrityError(
          IntegrityRule.backgroundBonus,
          'background_choice.bonuses.${e.key}',
          'le bonus d\'Historique ne peut pas dépasser 20',
        ),
  ];
}
