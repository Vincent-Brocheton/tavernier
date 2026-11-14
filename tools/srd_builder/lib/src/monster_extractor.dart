// Extraction du bestiaire depuis le texte du PDF en ordre de lecture
// (change t-06b-extracteur-bestiaire). Les nombres sont lus tels
// qu'imprimés ; le texte des traits et actions est copié tel quel.

import 'dart:io';

import 'class_extractor.dart';
import 'magic_item_extractor.dart' show readMagicItemSlugs;
import 'origin_extractor.dart';

typedef ExtractedMonster = ({String name, Map<String, Object?> data});

const _sizes = {
  'TP': 'tiny',
  'P': 'small',
  'M': 'medium',
  'G': 'large',
  'TG': 'huge',
  'Gig': 'gargantuan',
};

const _types = {
  'Aberration': 'aberration',
  'Artificiel': 'construct',
  'Bête': 'beast',
  'Bêtes': 'beast',
  'Céleste': 'celestial',
  'Dragon': 'dragon',
  'Élémentaire': 'elemental',
  'Fée': 'fey',
  'Fiélon': 'fiend',
  'Géant': 'giant',
  'Humanoïde': 'humanoid',
  'Monstruosité': 'monstrosity',
  'Mort-vivant': 'undead',
  'Morts-vivants': 'undead',
  'Plante': 'plant',
  'Vase': 'ooze',
};

const _abilities = {
  'For': 'str',
  'Dex': 'dex',
  'Con': 'con',
  'Int': 'int',
  'Sag': 'wis',
  'Cha': 'cha',
};

const _saveAbilities = {
  'Force': 'str',
  'Dextérité': 'dex',
  'Constitution': 'con',
  'Intelligence': 'int',
  'Sagesse': 'wis',
  'Charisme': 'cha',
};

const _skills = {
  'Acrobaties': 'acrobatics',
  'Arcanes': 'arcana',
  'Athlétisme': 'athletics',
  'Discrétion': 'stealth',
  'Dressage': 'animal-handling',
  'Escamotage': 'sleight-of-hand',
  'Histoire': 'history',
  'Intimidation': 'intimidation',
  'Intuition': 'insight',
  'Investigation': 'investigation',
  'Médecine': 'medicine',
  'Nature': 'nature',
  'Perception': 'perception',
  'Persuasion': 'persuasion',
  'Religion': 'religion',
  'Représentation': 'performance',
  'Survie': 'survival',
  'Tromperie': 'deception',
};

/// Types de dégâts des lignes Résistances et Immunités.
const _damageTypes = {
  'acide': 'acid',
  'contondants': 'bludgeoning',
  'feu': 'fire',
  'force': 'force',
  'foudre': 'lightning',
  'froid': 'cold',
  'nécrotiques': 'necrotic',
  'perforants': 'piercing',
  'poison': 'poison',
  'psychiques': 'psychic',
  'radiants': 'radiant',
  'tonnerre': 'thunder',
  'tranchants': 'slashing',
};

/// Types de dégâts d'une attaque (« dégâts de feu », « dégât perforant »).
const _hitTypes = {
  'contondants': 'bludgeoning',
  'contondant': 'bludgeoning',
  'perforants': 'piercing',
  'perforant': 'piercing',
  'tranchants': 'slashing',
  'tranchant': 'slashing',
  'nécrotiques': 'necrotic',
  'nécrotique': 'necrotic',
  'radiants': 'radiant',
  'radiant': 'radiant',
  'psychiques': 'psychic',
  'psychique': 'psychic',
  'd’acide': 'acid',
  'de feu': 'fire',
  'de force': 'force',
  'de foudre': 'lightning',
  'de froid': 'cold',
  'de poison': 'poison',
  'de tonnerre': 'thunder',
};

const _conditions = {
  'À terre': 'prone',
  'Agrippé': 'grappled',
  'Assourdi': 'deafened',
  'Aveuglé': 'blinded',
  'Charmé': 'charmed',
  'Effrayé': 'frightened',
  'Empoisonné': 'poisoned',
  'Entravé': 'restrained',
  'Épuisement': 'exhaustion',
  'Étourdi': 'stunned',
  'Inconscient': 'unconscious',
  'Invisible': 'invisible',
  'Neutralisé': 'incapacitated',
  'Paralysé': 'paralyzed',
  'Pétrifié': 'petrified',
};

const _sections = {
  'Traits': 'trait',
  'Actions': 'action',
  'Actions Bonus': 'bonus',
  'Réactions': 'reaction',
  'Actions Légendaires': 'legendary',
  'Actions légendaires': 'legendary',
};

/// Coquilles du PDF, passage fautif → passage corrigé. Un test vérifie que
/// chaque passage fautif est toujours dans le texte.
const monsterTypos = {
  // Jeune dragon blanc (p. 304) : le signe du JS d'Intelligence manque ; le
  // dragon ne maîtrise pas ce JS, qui vaut donc son modificateur.
  'Int 6 −2 2 Sag 11 +0 +3 Cha 12 +1 +1':
      'Int 6 −2 −2 Sag 11 +0 +3 Cha 12 +1 +1',
  // Fanatique de secte (p. 344) : la parenthèse ouvrante manque.
  'Arme spirituelle 2/jour).': 'Arme spirituelle (2/jour).',
  // Archimage (p. 323) : 8 000 PX pour un FP 12, que la table du SRD
  // (p. 268) et le SRD anglais donnent à 8 400.
  'FP 12 (8 000 PX ; BM +4)': 'FP 12 (8 400 PX ; BM +4)',
};

String _fixTypos(String line) {
  for (final MapEntry(:key, :value) in monsterTypos.entries) {
    line = line.replaceFirst(key, value);
  }
  return line;
}

const _sizeCode = 'TP|P|M|G|TG|Gig';

/// Ligne de type : « Géant de taille G, Chaotique Mauvais », « Nuée de
/// taille M de Bêtes de taille TP, non alignée ».
final _typeLine = RegExp(
  '^(?:Nuée de taille ($_sizeCode) de )?(${_types.keys.join('|')})'
  r'(?: \(([^)]*)\))? de taille ((?:'
  '$_sizeCode'
  r')(?: ou (?:'
  '$_sizeCode'
  r'))*), (.+)$',
);

final _minus = RegExp('[−–]');
int _signed(String s) => int.parse(s.replaceAll(_minus, '-'));

/// Mètres imprimés (« 1,50 », « 9 ») en pieds.
int feet(String metres) =>
    (double.parse(metres.replaceAll(',', '.')) / 1.5 * 5).round();

int _number(String s) => int.parse(s.replaceAll(RegExp(r'\s'), ''));

/// Coupe [s] sur [separator] hors des parenthèses.
List<String> _split(String s, RegExp separator) {
  final parts = <String>[];
  var depth = 0;
  var from = 0;
  for (var i = 0; i < s.length; i++) {
    if (s[i] == '(') depth++;
    if (s[i] == ')') depth--;
    if (depth > 0) continue;
    final m = separator.matchAsPrefix(s, i);
    if (m != null) {
      parts.add(s.substring(from, i));
      from = m.end;
      i = m.end - 1;
    }
  }
  parts.add(s.substring(from));
  return [
    for (final p in parts)
      if (p.trim().isNotEmpty) p.trim(),
  ];
}

/// Titre absent du texte : la section va jusqu'à la fin.
const _toTheEnd = '(?!)';

/// Profils de [text], de « Monstres de A à Z » à la fin. [problems] reçoit
/// ce qui empêche d'écrire un profil, [suspects] ce qu'il faut relire.
List<ExtractedMonster> extractMonsters(
  String text, {
  required List<String> problems,
  List<String>? suspects,
}) {
  final lines = [
    for (final l in srdSection(text, r'\f?Monstres de A à Z', _toTheEnd).lines)
      if (l != 'Animaux' && l != 'MOD JS') _fixTypos(l),
  ];
  final starts = [
    for (var i = 1; i < lines.length; i++)
      if (_typeLine.hasMatch(lines[i])) i,
  ];
  return [
    for (final (k, start) in starts.indexed)
      ?_monster(
        lines[start - 1],
        _typeLine.firstMatch(lines[start])!,
        _body(
          lines,
          start + 1,
          k + 1 < starts.length ? starts[k + 1] - 1 : lines.length,
        ),
        problems,
        suspects,
      ),
  ];
}

/// Lignes d'un profil, sans le nom du suivant (imprimé une ou deux fois) ni
/// le titre de groupe qui le précède (« Dragons blancs ») : court, sans
/// chiffre, deux-points ni ponctuation finale (une ligne de sorts
/// « 1/jour : clairvoyance » n'en est pas un).
List<String> _body(List<String> lines, int from, int to) {
  if (to < lines.length && to - 1 > from && lines[to - 1] == lines[to]) to--;
  if (to - 1 > from &&
      lines[to - 1].length < 40 &&
      _groupTitle.hasMatch(lines[to - 1])) {
    to--;
  }
  return lines.sublist(from, to);
}

final _groupTitle = RegExp(r'^\p{Lu}[^:\d.!?»)…]*$', unicode: true);

final _named = RegExp(
  r'(?:^| )(Compétences|Vulnérabilités|Résistances|Immunités|Équipement|'
  r'Sens|Langues|FP) ',
);
final _ac = RegExp(r'CA (\d+)');
final _initiative = RegExp(r'Initiative ([+−–-]\d+) \(\d+\)');
final _hp = RegExp(r'Pv (\d+) \(([^)]*)\)');
final _speed = RegExp(
  r'Vitesse (.+?)(?= (?:For|Dex|Con|Int|Sag|Cha) \d| Initiative | CA \d| '
  r'Pv \d|$)',
);
final _score = RegExp(r'\b(For|Dex|Con|Int|Sag|Cha) (\d+)');
final _signedNumber = RegExp(r'[+−–-]\d+');

ExtractedMonster? _monster(
  String name,
  RegExpMatch type,
  List<String> body,
  List<String> problems,
  List<String>? suspects,
) {
  void fail(String message) => problems.add('$name : $message');
  final section = body.indexWhere(_sections.containsKey);
  if (section < 0) {
    fail('aucune rubrique');
    return null;
  }
  final head = body.sublist(0, section).join(' ');
  final cut = _named.firstMatch(head);
  final stats = cut == null ? head : head.substring(0, cut.start);
  final named = <String, String>{};
  if (cut != null) {
    final rest = head.substring(cut.start);
    final keys = _named.allMatches(rest).toList();
    for (final (i, m) in keys.indexed) {
      named[m[1]!] = rest
          .substring(m.end, i + 1 < keys.length ? keys[i + 1].start : null)
          .trim();
    }
  }

  final ac = _ac.firstMatch(stats);
  final initiative = _initiative.firstMatch(stats);
  final hp = _hp.firstMatch(stats);
  final speed = _speed.firstMatch(stats);
  final fp = RegExp(
    r'^(\S+) \((?:PX )?([\d\s]+?)(?: PX)?(?:, ou ([\d\s]+?) dans son antre)?'
    r' ; BM \+(\d+)\)$',
  ).firstMatch(named['FP'] ?? '');
  if (ac == null || initiative == null || hp == null || speed == null) {
    fail('CA, Initiative, Pv ou Vitesse illisible : $stats');
    return null;
  }
  if (fp == null) {
    fail('FP illisible : ${named['FP']}');
    return null;
  }

  // Valeurs dans l'ordre d'impression ; les nombres signés restants vont par
  // paires (modificateur, JS) dans ce même ordre.
  var scoresText = stats;
  for (final m in [ac, initiative, hp, speed]) {
    scoresText = scoresText.replaceFirst(m[0]!, ' ');
  }
  final scores = _score.allMatches(scoresText).toList();
  final signed = [
    for (final m in _signedNumber.allMatches(
      scoresText.replaceAll(_score, ' '),
    ))
      _signed(m[0]!),
  ];
  if (scores.length != 6 || signed.length != 12) {
    fail('caractéristiques illisibles : $scoresText');
    return null;
  }
  final abilities = <String, int>{};
  final saves = <String, int>{};
  for (final (i, m) in scores.indexed) {
    final value = int.parse(m[2]!);
    if (signed[2 * i] != ((value - 10) / 2).floor()) {
      fail('modificateur de ${m[1]} ${signed[2 * i]} pour $value');
      return null;
    }
    abilities[_abilities[m[1]]!] = value;
    saves[_abilities[m[1]]!] = signed[2 * i + 1];
  }
  // Ordre du format, et non celui de l'impression.
  Map<String, int> ordered(Map<String, int> map) => {
    for (final key in _abilities.values) key: map[key]!,
  };

  final speedData = _speedOf(speed[1]!);
  final senses = _sensesOf(named['Sens'] ?? '', fail);
  final ids = <String, List<String>>{
    for (final key in ['Vulnérabilités', 'Résistances']) key: [],
    'Immunités': [],
    'États': [],
  };
  for (final key in ['Vulnérabilités', 'Résistances', 'Immunités']) {
    for (final item in _split(named[key] ?? '', RegExp(r', | et | ; '))) {
      // « Charmé (sauf par son maître vampire) » : l'état, précision au texte.
      final bare = item.replaceFirst(RegExp(r' \(.*\)$'), '');
      if (_damageTypes[bare] case final slug?) {
        ids[key]!.add('srd:damage-type:$slug');
      } else if (key == 'Immunités' && _conditions[bare] != null) {
        ids['États']!.add('srd:condition:${_conditions[bare]}');
      } else {
        suspects?.add('$name : $key non repris : $item');
        continue;
      }
      if (bare != item) {
        suspects?.add('$name : $key, précision non reprise : $item');
      }
    }
  }
  final skills = <String, int>{};
  for (final item in _split(named['Compétences'] ?? '', RegExp(', '))) {
    final m = RegExp(r'^(.+) ([+−–-]\d+)$').firstMatch(item);
    final slug = _skills[m?[1]];
    if (slug == null) {
      fail('compétence inconnue : $item');
    } else {
      skills['srd:skill:$slug'] = _signed(m![2]!);
    }
  }

  final actions = _actions(name, body.sublist(section), fail, suspects);
  final cr = fp[1]!;
  return (
    name: name,
    data: {
      // Une nuée a sa taille ; celle de ses créatures va dans swarm_size.
      'sizes': [
        for (final s in (type[1] ?? type[4]!).split(' ou ')) _sizes[s]!,
      ],
      'creature_type': _types[type[2]]!,
      'swarm_size': ?(type[1] == null ? null : _sizes[type[4]]),
      'type_tags': type[3] == null
          ? <String>[]
          : _split(type[3]!, RegExp(', ')),
      'alignment': type[5]!,
      'ac': int.parse(ac[1]!),
      'initiative': _signed(initiative[1]!),
      'hp': int.parse(hp[1]!),
      'hit_dice': hp[2]!,
      'speed': speedData.speed,
      'speed_note': ?speedData.note,
      'hover': speedData.hover,
      'abilities': ordered(abilities),
      'saving_throws': ordered(saves),
      'skills': skills,
      'vulnerabilities': ids['Vulnérabilités'],
      'resistances': ids['Résistances'],
      'immunities': ids['Immunités'],
      'condition_immunities': ids['États'],
      'gear': _split(named['Équipement'] ?? '', RegExp(', ')),
      'senses': senses.senses,
      'senses_note': ?senses.note,
      'passive_perception': senses.passive,
      'languages': (named['Langues'] ?? '').replaceAll(
        RegExp(r'\bgigant\b'),
        'géant',
      ),
      'cr': cr,
      'xp': _number(fp[2]!),
      'xp_lair': ?(fp[3] == null ? null : _number(fp[3]!)),
      'proficiency_bonus': int.parse(fp[4]!),
      'legendary_uses': ?actions.legendary,
      'legendary_uses_lair': ?actions.legendaryLair,
      'actions': actions.list,
    },
  );
}

({Map<String, int> speed, String? note, bool hover}) _speedOf(String line) {
  const kinds = {
    'nage': 'swim',
    'vol': 'fly',
    'escalade': 'climb',
    'fouissement': 'burrow',
  };
  final speed = <String, int>{};
  final notes = <String>[];
  var hover = false;
  for (final (i, part) in _split(line, RegExp(', ')).indexed) {
    final walk = RegExp(r'^([\d,]+) m$').firstMatch(part);
    final other = RegExp(
      '^(${kinds.keys.join('|')}) ([\\d,]+) m( \\(vol stationnaire\\))?\$',
    ).firstMatch(part);
    if (i == 0 && walk != null) {
      speed['walk'] = feet(walk[1]!);
    } else if (other != null) {
      speed[kinds[other[1]]!] = feet(other[2]!);
      hover = hover || other[3] != null;
    } else {
      notes.add(part);
    }
  }
  return (
    speed: speed,
    note: notes.isEmpty ? null : notes.join(', '),
    hover: hover,
  );
}

({Map<String, Object> senses, String? note, int passive}) _sensesOf(
  String line,
  void Function(String) fail,
) {
  const kinds = {
    'Vision dans le noir': 'darkvision',
    'Vision aveugle': 'blindsight',
    'Perception des vibrations': 'tremorsense',
    'Vision lucide': 'truesight',
  };
  final senses = <String, Object>{};
  final notes = <String>[];
  var passive = 0;
  for (final part in _split(line, RegExp(', | ; '))) {
    final sense = RegExp(
      '^(${kinds.keys.join('|')}) ([\\d,]+) m(?: \\((.*)\\))?\$',
    ).firstMatch(part);
    final pp = RegExp(r'^Perception passive (\d+)$').firstMatch(part);
    if (sense != null) {
      senses[kinds[sense[1]]!] = feet(sense[2]!);
      if (sense[3] == 'aveugle au-delà') {
        senses['blind_beyond'] = true;
      } else if (sense[3] != null) {
        notes.add(part);
      }
    } else if (pp != null) {
      passive = int.parse(pp[1]!);
    } else {
      fail('sens inconnu : $part');
    }
  }
  // Ordre du format : darkvision, blindsight, blind_beyond, tremorsense,
  // truesight.
  const order = [
    'darkvision',
    'blindsight',
    'blind_beyond',
    'tremorsense',
    'truesight',
  ];
  return (
    senses: {for (final k in order) k: ?senses[k]},
    note: notes.isEmpty ? null : notes.join(', '),
    passive: passive,
  );
}

/// Mots qui ouvrent une phrase et non un nom d'action.
const _sentenceStarts = {
  'Le', 'La', 'L’', 'Les', 'Si', 'Tant', 'Quand', 'Chaque', 'Un', 'Une', //
  'Il', 'Elle', 'Ils', 'Elles', 'Lorsque', 'En', 'Au', 'Après', 'Pour',
  'Sa', 'Son', 'Ses', 'Cette', 'Ce', 'Ces', 'Dans', 'De', 'Du', 'Des',
};

final _entry = RegExp(r'^(.+?)(?: \(([^()]*)\))?\.(?: (.*))?$');

({List<Map<String, Object?>> list, int? legendary, int? legendaryLair})
_actions(
  String monster,
  List<String> lines,
  void Function(String) fail,
  List<String>? suspects,
) {
  final list = <Map<String, Object?>>[];
  final texts = <List<String>>[];
  int? legendary;
  int? legendaryLair;
  var kind = 'trait';
  for (final line in lines) {
    if (_sections[line] case final k?) {
      kind = k;
      continue;
    }
    final uses = RegExp(
      r'^Utilisations d’action Légendaire : (\d+)(?: \((\d+) dans son antre\))?\.',
    ).firstMatch(line);
    if (uses != null) {
      legendary = int.parse(uses[1]!);
      legendaryLair = uses[2] == null ? null : int.parse(uses[2]!);
      continue;
    }
    final m = _entry.firstMatch(line);
    final name = m?[1];
    final words = name?.split(' ') ?? const <String>[];
    // Fin de phrase reportée à la ligne suivante : « … Touché : ⏎ 8 (1d8
    // + 4) … » (Vampire), « … (Athlétisme) ⏎ DD 13. » (Mante obscure).
    final continues =
        (texts.lastOrNull?.lastOrNull?.endsWith('Touché :') ?? false) ||
        line.startsWith(RegExp(r'DD \d'));
    final isEntry =
        !continues &&
        m != null &&
        !name!.contains(RegExp('[,:;]')) &&
        words.length <= 8 &&
        !_sentenceStarts.contains(words.first) &&
        !words.first.startsWith('L’') &&
        RegExp(r'^\p{Lu}', unicode: true).hasMatch(name);
    if (isEntry) {
      final usesOf = _usesOf(m[2]);
      if (usesOf == null &&
          (m[2] ?? '').contains(
            RegExp('/jour|recharge', caseSensitive: false),
          )) {
        suspects?.add('$monster : usage non lu : $name (${m[2]})');
      }
      list.add({
        'kind': kind,
        'name': usesOf == null && m[2] != null ? '$name (${m[2]})' : name,
        'uses': ?usesOf,
      });
      texts.add([?m[3]]);
    } else if (texts.isEmpty) {
      fail('ligne hors d’une entrée : $line');
    } else if (continues) {
      texts.last.last = '${texts.last.last} $line';
    } else {
      texts.last.add(line);
      // Forme d'un nom d'entrée écartée : à relire.
      if (m != null && line.indexOf('. ') < 80) {
        suspects?.add('$monster : suite de « ${list.last['name']} » : $line');
      }
    }
  }
  for (final (i, action) in list.indexed) {
    // Une ligne de sorts par fréquence, même collée à la précédente dans le
    // PDF (« … rayon ardent 1/jour chacun : … »).
    final text = paragraphs(texts[i])
        .replaceAll(RegExp(r' (?=\d+/jour(?: chacun)? : )'), '\n');
    final attack = _attackOf(text, (m) => suspects?.add('$monster : $m'));
    final save = RegExp('^JS (${_saveAbilities.keys.join('|')}) : DD (\\d+)')
        .firstMatch(text);
    action
      ..['attack'] = attack
      ..['save'] = save == null
          ? null
          : {'ability': _saveAbilities[save[1]]!, 'dc': int.parse(save[2]!)}
      ..['text'] = text
      ..removeWhere((_, v) => v == null);
  }
  return (list: list, legendary: legendary, legendaryLair: legendaryLair);
}

Map<String, Object>? _usesOf(String? paren) {
  if (paren == null) return null;
  final perDay = RegExp(r'^(\d+)/jour(?:, ou (\d+)/jour dans son antre)?$')
      .firstMatch(paren);
  if (perDay != null) {
    return {
      'per_day': int.parse(perDay[1]!),
      'per_day_lair': ?(perDay[2] == null ? null : int.parse(perDay[2]!)),
    };
  }
  final recharge = RegExp(
    r'^recharge (\d)(?:[–-](\d))?$',
    caseSensitive: false,
  ).firstMatch(paren);
  if (recharge != null) {
    return {
      'recharge': [recharge[1]!, ?recharge[2]].join('-'),
    };
  }
  return switch (paren.toLowerCase()) {
    'recharge après un repos court ou long' => {'rest': 'short_or_long'},
    'recharge après un repos long' => {'rest': 'long'},
    _ => null,
  };
}

final _attack = RegExp(
  // « +5 (avec Avantage si …) » : la précision reste dans le texte.
  r'^(Corps à corps ou à distance|Corps à corps|À distance) : ([+−–-]\d+)'
  r'(?: \([^)]*\))?, '
  r'(.*?)\. Touché : (.*)$',
  dotAll: true,
);
final _damage = RegExp(
  // « 1d4 +4 » aussi : l'espace manque parfois dans le PDF.
  r'^(\d+)(?: \((\d+d\d+(?: [+−–-] ?\d+)?)\))? dégâts? '
  '(${(_hitTypes.keys.toList()..sort((a, b) => b.length - a.length)).join('|')})'
  r'\b',
);

Map<String, Object?>? _attackOf(String text, void Function(String) suspect) {
  final m = _attack.firstMatch(text);
  if (m == null) return null;
  final kind = switch (m[1]) {
    'Corps à corps' => 'melee',
    'À distance' => 'ranged',
    _ => 'melee_or_ranged',
  };
  final reach = RegExp(r'allonge ([\d,]+) m').firstMatch(m[3]!);
  // « portée 9/36 m », ou une seule portée pour un sort (« portée 36 m »).
  final range = RegExp(r'portée ([\d,]+)(?:/([\d,]+))? m').firstMatch(m[3]!);
  final damage = <Map<String, Object>>[];
  var hit = m[4]!;
  while (true) {
    final d = _damage.firstMatch(hit);
    if (d == null) break;
    damage.add({
      'average': int.parse(d[1]!),
      'dice': ?d[2],
      'type': 'srd:damage-type:${_hitTypes[d[3]]!}',
    });
    hit = hit.substring(d.end);
    if (!hit.startsWith(' plus ')) break;
    hit = hit.substring(' plus '.length);
  }
  if (damage.isEmpty) suspect('dégâts non lus : ${m[4]}');
  return {
    'kind': kind,
    'bonus': _signed(m[2]!),
    'reach': ?(reach == null ? null : feet(reach[1]!)),
    'range': ?(range == null
        ? null
        : [
            for (final r in [range[1], ?range[2]]) feet(r!),
          ]),
    'damage': damage,
  };
}

/// Profils sans slug et slugs sans profil.
List<String> missingMonsterSlugs(
  List<ExtractedMonster> monsters,
  Map<String, String> slugs,
) {
  final names = {for (final m in monsters) m.name};
  return [
    for (final name in names)
      if (!slugs.containsKey(name)) 'monstre sans slug : $name',
    for (final name in slugs.keys)
      if (!names.contains(name)) 'slug sans monstre : $name',
    if (names.length != monsters.length) 'nom de monstre en double',
  ];
}

/// Lit `extract/monster_slugs.tsv` : nom du SRD → slug anglais.
Map<String, String> readMonsterSlugs(File file) => readMagicItemSlugs(file);

/// Commande `extract-monsters` : écrit les profils dans [sources]. Rien
/// n'est écrit en cas de problème. Renvoie les problèmes.
List<String> extractMonsterSources({
  required String readingOrder,
  required Map<String, String> slugs,
  required String sources,
  required StringSink report,
}) {
  final problems = <String>[];
  final suspects = <String>[];
  final monsters = extractMonsters(
    readingOrder,
    problems: problems,
    suspects: suspects,
  );
  final folder = Directory('$sources/monster');
  final known = slugs.values.toSet();
  problems.addAll([
    ...missingMonsterSlugs(monsters, slugs),
    if (folder.existsSync())
      for (final file in folder.listSync().whereType<File>())
        if (!known.contains(
          file.uri.pathSegments.last.replaceFirst('.json', ''),
        ))
          'source orpheline : ${file.path}',
  ]);
  if (problems.isNotEmpty) return problems;
  suspects.forEach(report.writeln);
  for (final m in monsters) {
    final slug = slugs[m.name]!;
    writeJson(File('${folder.path}/$slug.json'), {
      'id': 'srd:monster:$slug',
      'type': 'monster',
      'name': m.name,
      'data': m.data,
    });
  }
  return problems;
}
