// Extraction des objets magiques depuis le texte du PDF en ordre de lecture
// (change t-04f-objets-magiques). Le texte est copié tel quel ; les tables,
// dont la lecture mêle les colonnes, viennent de
// `extract/magic_item_tables.json`, vérifié contre le texte en mise en page.

import 'dart:convert';
import 'dart:io';

import 'class_extractor.dart';
import 'origin_extractor.dart';
import 'spell_extractor.dart';

/// Table d'un objet : les lignes du texte de `start` (exclu de la sortie) à
/// `resume` (ou à la fin de l'objet si vide) laissent la place à [rows].
typedef MagicItemTable = ({
  String item,
  String start,
  String resume,
  List<List<String>> rows,
});

typedef ExtractedMagicItem = ({
  String name,
  Map<String, Object> data,
  String text,
});

const _categories = {
  'Objet merveilleux': 'wondrous',
  'Armure': 'armor',
  'Arme': 'weapon',
  'Anneau': 'ring',
  'Baguette': 'wand',
  'Bâton': 'staff',
  'Potion': 'potion',
  'Parchemin': 'scroll',
  'Sceptre': 'rod',
};

const _rarities = {
  'peu courant': 'uncommon',
  'peu courante': 'uncommon',
  'très rare': 'very_rare',
  'courant': 'common',
  'courante': 'common',
  'rare': 'rare',
  'légendaire': 'legendary',
  'artefact': 'artifact',
};

const _rarityWord =
    'rareté variable|peu courante?|très rare|courante?|rare|légendaire|'
    'artefact';

/// Une rareté, avec sa précision éventuelle (« rare (+2) »).
const _rarity = '(?:$_rarityWord)(?: \\((?!Harmonisation)[^)]*\\))?';

/// Ligne de type : catégorie, précision, raretés, harmonisation, puis le
/// début du texte quand il est collé à la ligne (« Tarot mystérieux »).
final _typeLine = RegExp(
  '^(${_categories.keys.join('|')})(?: \\([^)]*\\))?,? '
  '($_rarity(?:(?:,| ou) $_rarity)*)'
  r'(?: \(Harmonisation requise(?: avec ([^)]*))?\))?'
  r'(?: (.*))?$',
  caseSensitive: false,
);

Map<String, Object> _data(RegExpMatch type) {
  final attunement = type[0]!.contains('(Harmonisation requise');
  final rarities = RegExp(
    _rarityWord,
    caseSensitive: false,
  ).allMatches(type[2]!).map((m) => m[0]!.toLowerCase()).toList();
  final rarity = rarities.length == 1
      ? _rarities[rarities.single] ?? 'varies'
      : 'varies';
  final rest = type[4];
  final line = rest == null
      ? type[0]!
      : type[0]!.substring(0, type[0]!.length - rest.length - 1);
  return {
    'category': _categories[type[1]]!,
    'rarity': rarity,
    'type_line': line,
    'attunement': attunement,
    'attunement_by': ?type[3],
  };
}

/// Objets de [text], de « Objets magiques de A à Z » au titre « Monstres ».
/// Une entrée commence au nom qui précède sa ligne de type. Les [tables]
/// remplacent leurs lignes ; [suspects] reçoit les lignes courtes et sans
/// ponctuation restées dans un texte, à relire.
List<ExtractedMagicItem> extractMagicItems(
  String text, {
  List<MagicItemTable> tables = const [],
  List<String>? suspects,
}) {
  final lines = srdSection(text, 'Objets magiques de A à Z', 'Monstres').lines;
  final starts = [
    for (var i = 1; i < lines.length; i++)
      if (_typeLine.hasMatch(lines[i])) i - 1,
  ];
  final names = {for (final s in starts) lines[s]};
  for (final t in tables) {
    if (!names.contains(t.item)) {
      throw FormatException('table d’un objet inconnu : ${t.item}');
    }
  }
  return [
    for (final (k, start) in starts.indexed)
      _item(
        lines[start],
        _typeLine.firstMatch(lines[start + 1])!,
        lines.sublist(
          start + 2,
          k + 1 < starts.length ? starts[k + 1] : lines.length,
        ),
        [
          for (final t in tables)
            if (t.item == lines[start]) t,
        ],
        suspects,
      ),
  ];
}

ExtractedMagicItem _item(
  String name,
  RegExpMatch type,
  List<String> body,
  List<MagicItemTable> tables,
  List<String>? suspects,
) {
  final lines = [?type[4], ...body];
  final parts = <String>[];
  var at = 0;
  void prose(List<String> chunk) {
    for (final line in chunk) {
      if (!endsSentence.hasMatch(line) &&
          line.length < 70 &&
          !line.startsWith('•')) {
        suspects?.add('$name : $line');
      }
    }
    if (chunk.isNotEmpty) parts.add(paragraphs(chunk));
  }

  for (final t in tables) {
    // Ligne exacte d'abord : « Sort » ne doit pas prendre « Sorts. Le… ».
    final exact = lines.indexOf(t.start, at);
    final from = exact >= 0
        ? exact
        : lines.indexWhere((l) => l.startsWith(t.start), at);
    if (from < 0) {
      throw FormatException('table introuvable : $name, ${t.start}');
    }
    final to = t.resume.isEmpty
        ? lines.length
        : lines.indexWhere((l) => l.startsWith(t.resume), from + 1);
    if (to < 0) {
      throw FormatException('reprise introuvable : $name, ${t.resume}');
    }
    prose(lines.sublist(at, from));
    parts.addAll([for (final row in t.rows) row.join(' | ')]);
    at = to;
  }
  prose(lines.sublist(at));
  return (name: name, data: _data(type), text: parts.join('\n'));
}

/// Objets sans slug et slugs sans objet.
List<String> missingSlugs(
  List<ExtractedMagicItem> items,
  Map<String, String> slugs,
) {
  final names = {for (final i in items) i.name};
  return [
    for (final name in names)
      if (!slugs.containsKey(name)) 'objet sans slug : $name',
    for (final name in slugs.keys)
      if (!names.contains(name)) 'slug sans objet : $name',
  ];
}

/// Lit `extract/magic_item_slugs.tsv` : nom du SRD → slug anglais.
Map<String, String> readMagicItemSlugs(File file) {
  final slugs = <String, String>{};
  for (final line in file.readAsLinesSync()) {
    if (line.trim().isEmpty || line.startsWith('#')) continue;
    final columns = line.split('	');
    if (columns.length != 2) {
      throw FormatException('ligne de slugs invalide : $line');
    }
    slugs[columns[0]] = columns[1];
  }
  return slugs;
}

/// Lit `extract/magic_item_tables.json`.
List<MagicItemTable> readMagicItemTables(File file) => [
  for (final t in jsonDecode(file.readAsStringSync()) as List<Object?>)
    if (t case {
      'item': final String item,
      'start': final String start,
      'resume': final String resume,
      'rows': final List<Object?> rows,
    })
      (
        item: item,
        start: start,
        resume: resume,
        rows: [
          for (final row in rows)
            [for (final cell in row! as List<Object?>) cell! as String],
        ],
      )
    else
      throw FormatException('table invalide : $t'),
];

/// Commande `extract-magic-items` : écrit les objets dans [sources]. Rien
/// n'est écrit s'il manque un slug. Renvoie les problèmes.
List<String> extractMagicItemSources({
  required String readingOrder,
  required Map<String, String> slugs,
  required List<MagicItemTable> tables,
  required String sources,
  required StringSink report,
}) {
  final suspects = <String>[];
  final items = extractMagicItems(
    readingOrder,
    tables: tables,
    suspects: suspects,
  );
  final problems = missingSlugs(items, slugs);
  if (problems.isNotEmpty) return problems;
  suspects.forEach(report.writeln);
  for (final item in items) {
    final slug = slugs[item.name]!;
    final file = File('$sources/magic-item/$slug.json');
    final existing = file.existsSync()
        ? jsonDecode(file.readAsStringSync()) as Map<String, Object?>
        : null;
    writeJson(file, {
      'id': 'srd:magic-item:$slug',
      'type': 'magic-item',
      'name': item.name,
      'data': item.data,
      'effects': ?existing?['effects'],
      'text': {'fr': item.text},
    });
  }
  return problems;
}
