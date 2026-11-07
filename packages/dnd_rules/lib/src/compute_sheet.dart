import 'package:dnd_content/dnd_content.dart';

import 'active_content.dart';
import 'character_input.dart';
import 'computed_sheet.dart';
import 'creation_rules.dart';

const abilityCodes = ['str', 'dex', 'con', 'int', 'wis', 'cha'];

/// SRD p. 22, « Valeurs standard ».
const _standardArray = [15, 14, 13, 12, 10, 8];

/// Table « Incantateur multiclassé » (SRD p. 27) : emplacements par niveau de
/// sort, pour chaque niveau de lanceur.
const multiclassSlots = <List<int>>[
  [2],
  [3],
  [4, 2],
  [4, 3],
  [4, 3, 2],
  [4, 3, 3],
  [4, 3, 3, 1],
  [4, 3, 3, 2],
  [4, 3, 3, 3, 1],
  [4, 3, 3, 3, 2],
  [4, 3, 3, 3, 2, 1],
  [4, 3, 3, 3, 2, 1],
  [4, 3, 3, 3, 2, 1, 1],
  [4, 3, 3, 3, 2, 1, 1],
  [4, 3, 3, 3, 2, 1, 1, 1],
  [4, 3, 3, 3, 2, 1, 1, 1],
  [4, 3, 3, 3, 2, 1, 1, 1, 1],
  [4, 3, 3, 3, 3, 1, 1, 1, 1],
  [4, 3, 3, 3, 3, 2, 1, 1, 1],
  [4, 3, 3, 3, 3, 2, 2, 1, 1],
];

/// Valeur requise pour se multiclasser (SRD p. 26).
const multiclassMinimum = 13;

/// Une classe ouverte ou non au multiclassage, et les valeurs qui le disent :
/// celles qui atteignent le minimum si [open], sinon celles qui le ratent.
final class ClassAccess {
  const ClassAccess({required this.open, required this.scores});

  final bool open;
  final List<({String ability, int score})> scores;
}

/// Toutes les principales sont requises, sauf pour une classe où l'une suffit
/// (Guerrier).
ClassAccess classAccess(ClassData cls, Map<String, AbilityScore> abilities) {
  final scores = [
    for (final id in cls.primaryAbilities)
      (ability: '$id', score: abilities[_codeOf('$id')]?.value ?? 0),
  ];
  bool reaches(({String ability, int score}) s) => s.score >= multiclassMinimum;
  final open = cls.primaryAbilitiesAny
      ? scores.any(reaches)
      : scores.every(reaches);
  return ClassAccess(
    open: open,
    scores: [
      for (final s in scores)
        if (reaches(s) == open) s,
    ],
  );
}

/// Effet actif : sa source (entité porteuse), son origine (`species`,
/// `class`, `feat`), le niveau qui résout ses tables `by_level`, et où lire
/// les sélections de ses effets `choice`.
typedef _Active = ({
  String source,
  String origin,
  Effect effect,
  int level,
  Map<String, Object?> picks,
  String picksPath,
});

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

  final active = _activeEffects(
    character,
    content,
    species,
    classes,
    level,
    errors,
  );
  final abilities = {
    for (final code in abilityCodes)
      code: _abilityScore(
        code,
        character,
        active.where(
          (a) =>
              a.effect.op == 'ability_bonus' &&
              a.effect.args['ability'] == code,
        ),
      ),
  };
  int mod(String code) => abilities[code]!.modifier;

  final classLevels = {
    for (final c in character.classLevels) c.classId: c.level,
  };
  Iterable<_Active> ofOp(String op) => active.where((a) => a.effect.op == op);
  int resolve(Object? value, int atLevel) =>
      _resolve(value, atLevel, level, classLevels, pb, abilities);

  // Maîtrises de compétence et jets de sauvegarde.
  final skillIds = {
    ...?background?.skillProficiencies.map((id) => '$id'),
    for (final c in character.classLevels) ...c.skillChoices,
    for (final a in ofOp('grant_proficiency'))
      if (a.effect.args['kind'] == 'skill') a.effect.args['ref']! as String,
  };
  final saveCodes = {
    for (final id in classes.firstOrNull?.data?.savingThrows ?? <ContentId>[])
      ?_codeOf('$id'),
  };
  final expertiseIds = {
    for (final c in character.classLevels) ...c.expertise,
    for (final a in ofOp('grant_expertise')) a.effect.args['ref']! as String,
  };
  final skills = <String, int>{};
  final skillBreakdown = <String, Computed>{};
  final skillProficiencies = <String>[];
  for (final skill in content.entities.where((e) => e.type == 'skill')) {
    final key = skill.id.slug.replaceAll('-', '_');
    final code = _codeOf('${(skill.data as SkillData).ability}') ?? 'str';
    final proficient = skillIds.contains('${skill.id}');
    final breakdown = Computed([
      Contribution(code, mod(code)),
      if (proficient) Contribution('proficiency', pb),
      // SRD, Glossaire : l'Expertise double le bonus de maîtrise.
      if (expertiseIds.contains('${skill.id}')) Contribution('expertise', pb),
      for (final a in ofOp('modify_check'))
        if (a.effect.args['scope'] == 'skill:${skill.id.slug}')
          Contribution(a.source, resolve(a.effect.args['add'], a.level)),
    ]);
    skillBreakdown[key] = breakdown;
    skills[key] = breakdown.value;
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

  // SRD p. 27 : une seule méthode de calcul s'applique, la meilleure ici.
  int formulaValue(Map<String, Object?> args) =>
      (args['abilities']! as List<Object?>).fold(
        args['base']! as int,
        (sum, code) => sum + mod(code! as String),
      );
  final formula =
      [
        for (final a in ofOp('ac_formula'))
          if (applies(a.effect)) a.effect.args,
      ].fold<Map<String, Object?>?>(
        null,
        (best, args) =>
            formulaValue(args) >
                (best == null ? 10 + mod('dex') : formulaValue(best))
            ? args
            : best,
      );

  final armorClass = Computed([
    if (formula != null) ...[
      Contribution('base', formula['base']! as int),
      for (final code in formula['abilities']! as List<Object?>)
        Contribution('$code', mod('$code')),
    ] else if (armor != null) ...[
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

  // SRD p. 26 : les dés de même type se regroupent.
  final hitDice = <int, int>{};
  for (final c in classes) {
    if (c.data case final cls?) {
      hitDice.update(
        cls.hitDie,
        (total) => total + c.input.level,
        ifAbsent: () => c.input.level,
      );
    }
  }
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

  // Armes maîtrisées : classe de départ, traits de multiclassage des suivantes
  // et effets de maîtrise.
  final weaponCategories = {
    for (final (i, c) in classes.indexed)
      ...?(i == 0
          ? c.data?.weaponProficiencies
          : c.data?.multiclass.weaponProficiencies),
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
      coversWeapon(weaponCategories, weapon.data as WeaponData);

  final masterySlots = [
    for (final a in ofOp('grant_mastery_slots'))
      resolve(a.effect.args['count'], a.level),
  ].fold(0, (sum, v) => sum + v);
  final masteries = <String>{};
  final meleeOnly = ofOp('grant_mastery_slots')
      .every((a) => a.effect.args['melee_only'] == true);
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
    } else if (meleeOnly &&
        (weapon.data as WeaponData).kind != WeaponKind.melee) {
      errors.add(
        IntegrityError(
          IntegrityRule.weaponMastery,
          'weapon_masteries[$i]',
          '${m.weaponId} : botte réservée aux armes de corps à corps',
        ),
      );
    } else {
      masteries.add(m.weaponId);
    }
  }

  // Attaques (SRD p. 97 et p. 189) ; bonus d'attaque des effets
  // `modify_check` (Archerie).
  List<Contribution> attackEffects(String scope) => [
    for (final a in ofOp('modify_check'))
      if (a.effect.args['scope'] == scope)
        Contribution(a.source, resolve(a.effect.args['add'], a.level)),
  ];
  String withMod(String dice, int mod) =>
      mod == 0 ? dice : '$dice${mod > 0 ? '+' : ''}$mod';
  final attacks = <Attack>[
    for (final id in {for (final item in character.items) item.itemId})
      if (content.entity(id) case final weapon? when weapon.data is WeaponData)
        () {
          final w = weapon.data as WeaponData;
          final ranged = w.kind == WeaponKind.ranged;
          final abilityCode = w.properties.contains('finesse')
              ? (mod('dex') > mod('str') ? 'dex' : 'str')
              : (ranged ? 'dex' : 'str');
          final abilityMod = mod(abilityCode);
          final bonus = Computed([
            Contribution(abilityCode, abilityMod),
            if (proficientWith(weapon)) Contribution('proficiency', pb),
            ...attackEffects(
              ranged ? 'ranged_weapon_attack' : 'melee_weapon_attack',
            ),
          ]);
          return Attack(
            weaponId: id,
            attackBonus: bonus.value,
            sources: bonus.sources,
            damage: withMod(w.damage, abilityMod),
            damageType: w.damageType.slug,
            rangeFeet: w.rangeFeet,
            mastery: masteries.contains(id) ? '${w.mastery}' : null,
          );
        }(),
    Attack(
      weaponId: 'unarmed',
      attackBonus: mod('str') + pb,
      sources: [
        Contribution('str', mod('str')),
        Contribution('proficiency', pb),
      ],
      damage: '${1 + mod('str')}',
      damageType: 'bludgeoning',
    ),
  ];

  // Cahier §11.3, SRD p. 26 : 13 dans la caractéristique principale de la
  // nouvelle classe et de chaque classe existante.
  for (var i = 1; i < classes.length; i++) {
    final involved = [for (final c in classes.take(i + 1)) c.data].nonNulls;
    if (!involved.every((cls) => classAccess(cls, abilities).open)) {
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

  Map<String, int> columnsOf(({ClassLevelInput input, ClassData? data}) c) =>
      c.data?.levels
          .where((l) => l.level == c.input.level)
          .firstOrNull
          ?.columns ??
      const {};

  final spellcasting = <String, ClassCasting>{
    for (final c in classes)
      if (_codeOf('${c.data?.spellcastingAbility}') case final code?)
        c.input.classId: ClassCasting(
          ability: code,
          saveDc: Computed([
            const Contribution('dc_base', 8),
            Contribution('proficiency', pb),
            Contribution(code, mod(code)),
          ]),
          attackBonus: Computed([
            Contribution('proficiency', pb),
            Contribution(code, mod(code)),
          ]),
          cantripsKnown: columnsOf(c)['cantrips'] ?? 0,
          preparedMax: columnsOf(c)['prepared_spells'] ?? 0,
        ),
  };

  // SRD p. 27 : la table du multiclassage ne sert qu'à partir de deux classes
  // à emplacements, l'Occultiste à part.
  List<int> slotsOf(Map<String, int> columns) => [
    for (var n = 1; columns['slot_$n'] != null; n++) columns['slot_$n']!,
  ];
  final slotClasses = [
    for (final c in classes)
      if (slotsOf(columnsOf(c)).isNotEmpty) c,
  ];
  int? casterLevel;
  if (slotClasses.length > 1) {
    int levelsAt(int divisor) => classes
        .where((c) => c.data?.multiclass.casterDivisor == divisor)
        .fold(0, (sum, c) => sum + c.input.level);
    casterLevel = levelsAt(1) + (levelsAt(2) + 1) ~/ 2;
  }
  final pact = classes.map(columnsOf).where((c) => c['pact_slots'] != null);

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

  final saveBreakdown = {
    for (final code in abilityCodes)
      code: Computed([
        Contribution(code, mod(code)),
        if (saveCodes.contains(code)) Contribution('proficiency', pb),
      ]),
  };

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
      for (final MapEntry(:key, :value) in saveBreakdown.entries)
        key: value.value,
    },
    saveBreakdown: saveBreakdown,
    savingThrowProficiencies: [...saveCodes],
    skills: skills,
    skillBreakdown: skillBreakdown,
    skillProficiencies: skillProficiencies,
    passivePerception: 10 + (skills['perception'] ?? 0),
    initiative: initiative,
    armorClass: armorClass,
    speed: Computed([
      Contribution(character.speciesId, species?.speedFeet ?? 0),
      for (final a in ofOp('modify_speed'))
        if (a.effect.args['mode'] == 'walk' && applies(a.effect))
          Contribution(a.source, resolve(a.effect.args['value'] ?? 0, a.level)),
    ]),
    hitPointsMax: hitPointsMax,
    hitDice: [
      for (final MapEntry(:key, :value) in hitDice.entries)
        (die: 'd$key', total: value),
    ],
    spellcasting: spellcasting,
    casterLevel: casterLevel,
    spellSlots: switch (casterLevel) {
      final int reached when reached > 0 =>
        multiclassSlots[reached.clamp(1, multiclassSlots.length) - 1],
      _ =>
        slotClasses.isEmpty ? const [] : slotsOf(columnsOf(slotClasses.first)),
    },
    pactMagic: pact.isEmpty
        ? null
        : PactMagic(
            slots: pact.first['pact_slots']!,
            slotLevel: pact.first['pact_slot_level']!,
          ),
    proficientWeapons: {
      for (final entity in content.entities)
        if (entity.data is WeaponData && proficientWith(entity)) '${entity.id}',
    },
    resources: {
      for (final a in ofOp('grant_resource'))
        a.effect.args['id']! as String: resolve(a.effect.args['max'], a.level),
    },
    weaponMasterySlots: masterySlots,
    attacks: attacks,
    integrityErrors: errors,
  );
}

/// Valeur d'une caractéristique : base, bonus d'Historique, puis `ability_bonus`
/// plafonnés par leur `max`.
AbilityScore _abilityScore(
  String code,
  CharacterInput character,
  Iterable<_Active> bonuses,
) {
  final sources = [
    Contribution('base', character.baseScores.of(code)),
    if (character.backgroundChoice.bonuses[code] case final bonus?
        when bonus != 0)
      Contribution(character.backgroundId, bonus),
  ];
  for (final a in bonuses) {
    final total = sources.fold(0, (sum, c) => sum + c.value);
    final max = a.effect.args['max'] as int? ?? abilityScoreCap;
    final room = max - total;
    final value = a.effect.args['value']! as int;
    if (room > 0) {
      sources.add(Contribution(a.source, value < room ? value : room));
    }
  }
  return AbilityScore(sources);
}

/// Rang de l'option dont les `ability_bonus` valent exactement [bonuses].
int _optionOfBonuses(List<List<Effect>> options, Map<String, int> bonuses) =>
    options.indexWhere((option) {
      final grants = option.where((e) => e.op == 'ability_bonus');
      return grants.length == bonuses.length &&
          grants.every((e) => bonuses[e.args['ability']] == e.args['value']);
    });

/// Effets actifs : traits d'espèce, dons, aptitudes de classe atteintes,
/// puis options retenues des effets `choice` (design §2 et §3). Un effet
/// dont `when.level` dépasse son niveau n'est pas actif.
List<_Active> _activeEffects(
  CharacterInput character,
  ActiveContent content,
  SpeciesData? species,
  List<({ClassLevelInput input, ClassData? data})> classes,
  int level,
  List<IntegrityError> errors,
) {
  final active = <_Active>[];
  void add(
    String source,
    String origin,
    Iterable<Effect> effects,
    int atLevel,
    Map<String, Object?> picks,
    String picksPath,
  ) {
    for (final effect in effects) {
      if ((effect.when['level'] as int? ?? 1) > atLevel) continue;
      active.add((
        source: source,
        origin: origin,
        effect: effect,
        level: atLevel,
        picks: picks,
        picksPath: picksPath,
      ));
    }
  }

  Iterable<Effect> effectsOf(String id) =>
      content.entity(id)?.effects ?? const <Effect>[];

  for (final trait in species?.traits ?? const <ContentId>[]) {
    add(
      '$trait',
      'species',
      effectsOf('$trait'),
      level,
      character.choices,
      'choices',
    );
  }
  for (final (i, feat) in character.feats.indexed) {
    add(
      feat.featId,
      'feat',
      effectsOf(feat.featId),
      level,
      feat.choices ?? const {},
      'feats[$i].choices',
    );
  }
  for (final c in classes) {
    for (final row in c.data?.levels ?? const <ClassLevelData>[]) {
      if (row.level > c.input.level) continue;
      for (final feature in row.features) {
        add(
          '$feature',
          'class',
          effectsOf('$feature'),
          c.input.level,
          character.choices,
          'choices',
        );
      }
    }
    final subclass = content.entity(c.input.subclassId ?? '')?.data;
    for (final feature
        in subclass is SubclassData ? subclass.features : const <ContentId>[]) {
      final data = content.entity('$feature')?.data;
      if (data is FeatureData && (data.level ?? 1) <= c.input.level) {
        add(
          '$feature',
          'class',
          effectsOf('$feature'),
          c.input.level,
          character.choices,
          'choices',
        );
      }
    }
  }

  // Un `choice` reçoit exactement `count` sélections, chacune désignant une
  // option ; les effets des options retenues deviennent actifs.
  for (var i = 0; i < active.length; i++) {
    final a = active[i];
    if (a.effect.op != 'choice') continue;
    final id = a.effect.args['id']! as String;
    final picked = [
      for (final p in (a.picks[id] as List<Object?>?) ?? const []) '$p',
    ];
    final options = [
      for (final option in a.effect.args['options']! as List<Object?>)
        [
          for (final json in option! as List<Object?>)
            Effect.fromJson(json! as Map<String, Object?>),
        ],
    ];
    // Répartition d'une Amélioration de caractéristique, format [D1] :
    // `{"str": 1, "con": 1}` à la place d'une liste de sélections.
    final bonuses = {
      for (final code in abilityCodes)
        if (a.picks[code] case final int value) code: value,
    };
    if (bonuses.isNotEmpty) {
      final index = _optionOfBonuses(options, bonuses);
      if (index < 0) {
        errors.add(
          IntegrityError(
            IntegrityRule.choice,
            '${a.picksPath}.$id',
            '${a.source} : répartition inconnue',
          ),
        );
      } else {
        add(a.source, a.origin, options[index], a.level, a.picks, a.picksPath);
      }
      continue;
    }
    final labels = [
      for (final label in (a.effect.args['labels'] as List<Object?>?) ?? [])
        '$label',
    ];
    // Une sélection nomme l'option, ou cite une entité qu'elle accorde.
    bool cites(int index, String pick) =>
        (index < labels.length && labels[index] == pick) ||
        options[index].any((e) => effectReferences(e).contains(pick));
    final retained = [
      for (final (i, option) in options.indexed)
        if (picked.any((pick) => cites(i, pick))) option,
    ];
    final count = a.effect.args['count']! as int;
    if (picked.length != count ||
        picked.any((pick) => !options.indexed.any((o) => cites(o.$1, pick)))) {
      errors.add(
        IntegrityError(
          IntegrityRule.choice,
          '${a.picksPath}.$id',
          '${a.source} : $count sélection(s) parmi les options attendue(s)',
        ),
      );
      continue;
    }
    for (final option in retained) {
      add(a.source, a.origin, option, a.level, a.picks, a.picksPath);
    }
  }
  return active;
}

/// Résout une expression de valeur du DSL (docs/dsl/DSL_V1.md, principe 5)
/// au niveau [level] de l'effet.
int _resolve(
  Object? value,
  int level,
  int characterLevel,
  Map<String, int> classLevels,
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
        'character_level' => characterLevel,
        _ => map['class'] == null ? level : classLevels[map['class']] ?? 0,
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
    // Un don général accepte tout don : il passe après les autres, pour ne pas
    // prendre le style de combat qu'une autre aptitude réclame.
    final grants = active
        .where((a) => a.origin == origin && a.effect.op == 'grant_feat')
        .toList();
    final ordered = [
      ...grants.where((a) => a.effect.args['category'] != 'general'),
      ...grants.where((a) => a.effect.args['category'] == 'general'),
    ];
    for (final a in ordered) {
      final grant = a.effect.args;
      final match = chosen.where((id) {
        final feat = content.entity(id)?.data;
        // SRD, Amélioration de caractéristique : le don accordé peut être
        // « un autre don de votre choix pour lequel vous remplissez les
        // conditions ».
        return grant['feat'] == id ||
            grant['category'] == 'general' && feat is FeatData ||
            (feat is FeatData &&
                featCategoryName(feat.category) == grant['category']);
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
String featCategoryName(FeatCategory category) => category.name
    .replaceAllMapped(RegExp('[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

/// SRD p. 24, « Progression des personnages ».
int _proficiencyBonus(int level) => 2 + (level - 1) ~/ 4;

int _cost(BaseScores scores) =>
    pointBuySpent({for (final c in abilityCodes) c: scores.of(c)});

List<IntegrityError> _checkGeneration(BaseScores scores) {
  final values = [for (final c in abilityCodes) scores.of(c)]..sort();
  String? problem;
  switch (scores.method) {
    case ScoreMethod.pointBuy:
      if (values.any((v) => v < 8 || v > 15)) {
        problem = 'acquisition par points : valeurs de 8 à 15';
      } else if (_cost(scores) != pointBuyBudget) {
        problem =
            'acquisition par points : ${_cost(scores)} points au lieu de $pointBuyBudget';
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
      if (character.baseScores.of(e.key) + e.value > 20)
        IntegrityError(
          IntegrityRule.backgroundBonus,
          'background_choice.bonuses.${e.key}',
          'le bonus d\'Historique ne peut pas dépasser 20',
        ),
  ];
}

/// `true` si les maîtrises d'armes [categories] couvrent [weapon] : une
/// catégorie entière (`simple`, `martial`), ou une partie des armes de
/// guerre (`martial_light` du Moine, `martial_finesse_or_light` du
/// Roublard).
bool coversWeapon(Set<String> categories, WeaponData weapon) {
  if (categories.contains(weapon.category.name)) return true;
  if (weapon.category != WeaponCategory.martial) return false;
  final light = weapon.properties.contains('light');
  final finesse = weapon.properties.contains('finesse');
  return (categories.contains('martial_light') && light) ||
      (categories.contains('martial_finesse_or_light') && (light || finesse));
}
