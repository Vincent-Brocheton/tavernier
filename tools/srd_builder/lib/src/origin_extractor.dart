// Extraction des espèces et des dons depuis le texte du PDF en ordre de
// lecture (change t-04d-origines). Le texte est copié tel quel ; les effets
// sont saisis à la main, et une nouvelle extraction les garde.

import 'dart:convert';
import 'dart:io';

import 'class_extractor.dart';
import 'spell_extractor.dart';
import 'srd_origins.dart';

/// Commande `extract-origins` : écrit les espèces, leurs traits et les dons
/// dans [sources]. Les effets saisis à la main sont gardés, ainsi que les
/// données d'un trait existant. Renvoie les problèmes.
List<String> extractOrigins({
  required String readingOrder,
  required String sources,
  required StringSink report,
}) {
  final problems = <String>[];
  Map<String, Object?>? read(File file) => file.existsSync()
      ? jsonDecode(file.readAsStringSync()) as Map<String, Object?>
      : null;

  final joins = <String>[];
  final species = extractSpecies(readingOrder, srdSpecies, joins: joins);
  joins.forEach(report.writeln);
  for (final s in species) {
    report.writeln('== ${s.name}');
    final traits = <String>[];
    for (final t in s.traits) {
      final slug = '${s.slug}-${t.slug}';
      traits.add('srd:feature:$slug');
      final created = writeFeature(
        File('$sources/feature/$slug.json'),
        name: t.name,
        text: t.text,
        source: 'srd:species:${s.slug}',
        level: t.level,
      );
      if (created) report.writeln('trait créé : $slug');
    }
    final file = File('$sources/species/${s.slug}.json');
    final existing = read(file);
    writeJson(file, {
      'id': 'srd:species:${s.slug}',
      'type': 'species',
      'name': s.name,
      'data': {...s.data, 'traits': traits},
      'effects': ?existing?['effects'],
    });
  }

  final feats = extractFeats(readingOrder);
  final found = {for (final f in feats) f.name};
  problems.addAll([
    for (final name in srdFeats.keys)
      if (!found.contains(name)) 'don introuvable : $name',
  ]);
  for (final f in feats) {
    final slug = srdFeats[f.name];
    if (slug == null) {
      problems.add('don sans slug : ${f.name}');
      continue;
    }
    final file = File('$sources/feat/$slug.json');
    final existing = read(file);
    if (existing == null) report.writeln('don créé : $slug');
    writeJson(file, {
      'id': 'srd:feat:$slug',
      'type': 'feat',
      'name': f.name,
      'data': f.data,
      'effects': ?existing?['effects'],
      'text': {'fr': f.text},
    });
  }
  return problems;
}

/// Table d'un trait : lignes recopiées du SRD, ajoutées au texte du trait
/// [trait] (la lecture du PDF mêle ses colonnes).
typedef TraitTable = ({String trait, List<List<String>> rows});

/// Configuration d'une espèce : nom du SRD, slug, traits (nom → slug, dans
/// l'ordre du SRD) et tables de trait (titre → table).
typedef SrdSpecies = ({
  String name,
  String slug,
  Map<String, String> traits,
  Map<String, TraitTable> tables,
});

typedef ExtractedTrait = ({String name, String slug, int level, String text});

typedef ExtractedSpecies = ({
  String name,
  String slug,
  Map<String, Object> data,
  List<ExtractedTrait> traits,
});

typedef ExtractedFeat = ({String name, Map<String, Object> data, String text});

const _creatureTypes = {'Humanoïde': 'humanoid'};
const _abilities = {
  'Force': 'str',
  'Dextérité': 'dex',
  'Constitution': 'con',
  'Intelligence': 'int',
  'Sagesse': 'wis',
  'Charisme': 'cha',
};
const _featCategories = {
  'd’origines': 'origin',
  'général': 'general',
  'de Style de combat': 'fighting_style',
  'de faveur épique': 'epic_boon',
};

final _size = RegExp(r'(?:: |ou )(TP|P|M|G) \(');
final _speed = RegExp(r'Vitesse : (\d+)(?:,(\d+))? m');
final _traitLevel = RegExp(
  r'^(?:Lorsque vous atteignez le|À partir du) niveau de personnage (\d+)',
);
final _featCategory = RegExp(
  '^Don (${_featCategories.keys.join('|')})'
  r'(?: \(prérequis : (.+)\))?$',
);
final _featHeading = RegExp(
  r'^Dons (d’origines|généraux|de Style de combat|de faveur épique)$',
);
final _abilityMin = RegExp(
  '((?:${_abilities.keys.join('|')})(?: ou (?:${_abilities.keys.join('|')}))*)'
  r' (\d+) ou plus',
);

/// Paragraphes de [lines] : dans un trait ou un don, une ligne qui ne
/// termine pas sa phrase se poursuit à la suivante, même quand celle-ci
/// commence par une majuscule (« Votre valeur de / Force »).
String paragraphs(List<String> lines) {
  final out = <String>[];
  for (final line in lines) {
    if (out.isNotEmpty && !endsSentence.hasMatch(out.last)) {
      out.last = '${out.last} $line';
    } else {
      out.add(line);
    }
  }
  return out.join('\n');
}

/// Section de [text] entre la ligne [from] et la ligne [to] qui la suit.
CleanText srdSection(String text, String from, String to) {
  text = text.replaceAll('\r\n', '\n');
  final start = text.indexOf(RegExp('^$from\$', multiLine: true));
  if (start < 0) throw FormatException('section introuvable : $from');
  final end = RegExp(
    '^\\f?$to\$',
    multiLine: true,
  ).allMatches(text, start).firstOrNull;
  return cleanText(text.substring(start, end?.start ?? text.length));
}

/// Espèces de [config] lues dans [text], de « Description des espèces » au
/// titre « Dons ».
List<ExtractedSpecies> extractSpecies(
  String text,
  List<SrdSpecies> config, {
  List<String>? joins,
}) {
  final clean = srdSection(text, 'Description des espèces', 'Dons');
  joins?.addAll(clean.joins);
  final lines = clean.lines;
  // Une espèce commence à son nom seul sur sa ligne, suivi de son en-tête.
  int startOf(String name) {
    for (var i = 0; i + 1 < lines.length; i++) {
      if (lines[i] == name && lines[i + 1].startsWith('Type de créature')) {
        return i;
      }
    }
    throw FormatException('espèce introuvable : $name');
  }

  final starts = {for (final s in config) s.slug: startOf(s.name)};
  final sorted = starts.values.toList()..sort();
  return [
    for (final s in config)
      _species(
        s,
        lines.sublist(
          starts[s.slug]!,
          sorted.firstWhere(
            (i) => i > starts[s.slug]!,
            orElse: () => lines.length,
          ),
        ),
      ),
  ];
}

ExtractedSpecies _species(SrdSpecies config, List<String> lines) {
  final intro = lines.indexWhere((l) => l.startsWith('En tant qu'));
  if (intro < 0) throw FormatException('traits introuvables : ${config.name}');
  final header = lines.sublist(1, intro).join(' ');
  final type = RegExp(r'Type de créature : (\S+)').firstMatch(header)?[1];
  final speed = _speed.firstMatch(header);
  if (!_creatureTypes.containsKey(type) || speed == null) {
    throw FormatException('en-tête illisible : $header');
  }
  final meters = int.parse(speed[1]!) + double.parse('0.${speed[2] ?? 0}');

  final texts = <String, List<String>>{};
  String? current;
  var inTable = false;
  for (final line in lines.skip(intro + 1)) {
    final name = config.traits.keys
        .where((n) => line.startsWith('$n. '))
        .firstOrNull;
    if (name != null) {
      current = name;
      inTable = false;
      texts[name] = [line.substring(name.length + 2)];
    } else if (config.tables.containsKey(line)) {
      // Table mêlée par la lecture : retirée jusqu'au trait suivant.
      inTable = true;
    } else if (!inTable && current != null) {
      texts[current]!.add(line);
    }
  }
  final tables = <String, List<String>>{
    for (final MapEntry(key: title, value: table) in config.tables.entries)
      table.trait: [title, for (final row in table.rows) row.join(' | ')],
  };

  return (
    name: config.name,
    slug: config.slug,
    data: {
      'creature_type': _creatureTypes[type]!,
      'sizes': [for (final m in _size.allMatches(header)) m[1]!],
      'speed_feet': (meters * 10 / 3).round(),
    },
    traits: [
      for (final MapEntry(key: name, value: slug) in config.traits.entries)
        if (texts[name] case final lines?)
          (
            name: name,
            slug: slug,
            level: int.parse(_traitLevel.firstMatch(lines.first)?[1] ?? '1'),
            text: [paragraphs(lines), ...?tables[name]].join('\n'),
          )
        else
          throw FormatException('trait introuvable : ${config.name}, $name'),
    ],
  );
}

/// Dons lus dans [text], de « Description des dons » au titre
/// « Équipement » : un don commence au titre qui précède sa ligne de
/// catégorie.
List<ExtractedFeat> extractFeats(String text) {
  final lines = srdSection(text, 'Description des dons', 'Équipement').lines;
  final starts = [
    for (var i = 1; i < lines.length; i++)
      if (_featCategory.hasMatch(lines[i])) i - 1,
  ];
  return [
    for (final (k, start) in starts.indexed)
      _feat(lines[start], _featCategory.firstMatch(lines[start + 1])!, [
        for (final line in lines.sublist(
          start + 2,
          k + 1 < starts.length ? starts[k + 1] : lines.length,
        ))
          if (!_featHeading.hasMatch(line)) line,
      ]),
  ];
}

ExtractedFeat _feat(String name, RegExpMatch category, List<String> lines) {
  final requires = category[2] ?? '';
  final abilities = _abilityMin.firstMatch(requires);
  final prerequisites = <String, Object>{
    if (RegExp(r'niveau (\d+)').firstMatch(requires) case final m?)
      'min_level': int.parse(m[1]!),
    if (abilities != null)
      'ability_min_any': {
        for (final a in abilities[1]!.split(' ou '))
          _abilities[a]!: int.parse(abilities[2]!),
      },
    if (requires.contains('aptitude Style de combat'))
      'feature': 'fighting_style',
    if (requires.contains('aptitude Sorts')) 'feature': 'spellcasting',
  };
  return (
    name: name,
    data: {
      'category': _featCategories[category[1]]!,
      if (prerequisites.isNotEmpty) 'prerequisites': prerequisites,
      if (lines.any((l) => l.startsWith('Répétable.'))) 'repeatable': true,
    },
    text: paragraphs(lines),
  );
}

/// Cellules de [rows] absentes de la table [title] du texte en mise en
/// page [layout]. Une ligne de table va de sa première cellule à la
/// première cellule d'une autre ligne qui la suit (la table du Drakéide
/// a deux colonnes de dragons) ; les mots de chaque cellule doivent s'y
/// suivre, les colonnes voisines pouvant s'intercaler. La ligne d'en-tête
/// part du titre. Une cellule recopiée dans la mauvaise ligne manque donc.
List<String> missingTableCells(
  String layout,
  String title,
  List<List<String>> rows,
) {
  // Le titre en tête de ligne, seul dans sa colonne, pas sa mention dans le
  // texte (« table « Lignages elfiques » »).
  final at = layout.indexOf(
    RegExp('^\\s*${RegExp.escape(title)}(\\s{2,}|\$)', multiLine: true),
  );
  final block = at < 0
      ? const <String>[]
      : layout
            .substring(at)
            .split('\n')
            .take(25)
            .join(' ')
            .split(RegExp(r'\s+'));
  final starts = [
    for (final row in rows) block.indexOf(row.first.split(' ').first),
  ];
  bool found(String cell, List<String> window) {
    var i = 0;
    for (final word in cell.split(' ')) {
      while (i < window.length && window[i] != word) {
        i++;
      }
      if (i++ >= window.length) return false;
    }
    return true;
  }

  return [
    for (final (k, row) in rows.indexed)
      for (final cell in row)
        if (starts[k] < 0 ||
            !found(
              cell,
              block.sublist(
                k == 0 ? 0 : starts[k],
                [
                  for (final (j, s) in starts.indexed)
                    if (j != k && s > starts[k]) s,
                ].fold<int>(block.length, (a, b) => a < b ? a : b),
              ),
            ))
          cell,
  ];
}
