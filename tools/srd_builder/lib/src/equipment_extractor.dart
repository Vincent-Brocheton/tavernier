// Extraction des outils et du matériel d'aventurier depuis le texte du PDF
// en ordre de lecture (change t-04e-equipement). Le texte est copié tel
// quel ; le poids et le prix des objets viennent de `extract/gear.tsv`,
// recopié du tableau du SRD et vérifié contre le texte en mise en page.

import 'dart:convert';
import 'dart:io';

import 'class_extractor.dart';
import 'origin_extractor.dart';
import 'srd_equipment.dart';

typedef ExtractedTool = ({
  String slug,
  String name,
  Map<String, Object> data,
  String text,
});

/// Ligne de `extract/gear.tsv`.
typedef GearRow = ({
  String slug,
  String name,
  String label,
  String weight,
  String price,
  String description,
});

const _abilityIds = {
  'Force': 'srd:ability:strength',
  'Dextérité': 'srd:ability:dexterity',
  'Constitution': 'srd:ability:constitution',
  'Intelligence': 'srd:ability:intelligence',
  'Sagesse': 'srd:ability:wisdom',
  'Charisme': 'srd:ability:charisma',
};

/// Outils à variantes : nom du SRD → catégorie de leurs variantes.
const _variantParents = {
  'Boîte de jeux': 'gaming_set',
  'Instrument de musique': 'musical_instrument',
};

/// Tables du matériel d'aventurier, mêlées au texte par la lecture du PDF.
const _gearTables = {
  'Matériel d’aventurier',
  'Focaliseurs arcaniques',
  'Focaliseurs druidiques',
  'Munitions',
  'Symboles sacrés',
};

final _toolHeader = RegExp(r'^(.+) \((?:([\d ]+ p[oac])|variable)\)$');
final _toolLabel = RegExp(
  r'^(Caractéristique|Poids|Utilisation|Artisanat|Variantes) :',
);
final _variant = RegExp(r'([^,(]+?) \(([\d ]+ p[oac])(?:, ([\d,]+ k?g))?\)');

/// Poids du SRD en kilogrammes (« 0,5 kg », « 250 g ») ; `null` pour
/// « — » ou « Variable ».
double? parseWeight(String weight) {
  final m = RegExp(r'^([\d,]+) (kg|g)$').firstMatch(weight.trim());
  if (m == null) return null;
  final value = double.parse(m[1]!.replaceAll(',', '.'));
  return m[2] == 'g' ? value / 1000 : value;
}

/// Prix du SRD en pièces de cuivre (« 1 000 po », « 5 pa ») ; `null` pour
/// « Variable ».
int? parsePrice(String price) {
  final m = RegExp(r'^([\d ]+) (po|pa|pc)$').firstMatch(price.trim());
  if (m == null) return null;
  return int.parse(m[1]!.replaceAll(' ', '')) *
      const {'po': 100, 'pa': 10, 'pc': 1}[m[2]]!;
}

/// Outils de [text], d'« Outils d’artisan » à « Matériel d’aventurier ».
/// [slugs] donne le slug de chaque outil et de chaque variante (« luth »).
/// Une variante reçoit le texte de son outil et le nom « Outil : variante ».
List<ExtractedTool> extractTools(String text, Map<String, String> slugs) {
  final lines = srdSection(
    text,
    'Outils d’artisan',
    'Matériel d’aventurier',
  ).lines;
  final blocks =
      <({String name, String? price, bool artisan, List<String> lines})>[];
  var artisan = true;
  for (final line in lines) {
    final header = _toolHeader.firstMatch(line);
    if (header != null &&
        (slugs.containsKey(header[1]) ||
            _variantParents.containsKey(header[1]))) {
      blocks.add((
        name: header[1]!,
        price: header[2],
        artisan: artisan,
        lines: [],
      ));
    } else if (line == 'Autres outils') {
      artisan = false;
    } else if (blocks.isEmpty) {
      continue;
    } else if (_toolLabel.hasMatch(line) || blocks.last.lines.isEmpty) {
      blocks.last.lines.add(line);
    } else {
      // Ligne passée à la suite (« (DD 15), identifier un alcool »).
      blocks.last.lines.last = '${blocks.last.lines.last} $line';
    }
  }

  final tools = <ExtractedTool>[];
  for (final b in blocks) {
    String? field(String label) => b.lines
        .where((l) => l.startsWith('$label : '))
        .firstOrNull
        ?.substring(label.length + 3);
    final ability = _abilityIds[field('Caractéristique')];
    if (ability == null) {
      throw FormatException('caractéristique illisible : ${b.name}');
    }
    final weight = parseWeight(field('Poids') ?? '');
    final text = b.lines.join('\n');
    final parent = _variantParents[b.name];
    if (parent == null) {
      tools.add((
        slug: slugs[b.name]!,
        name: b.name,
        data: {
          'category': b.artisan ? 'artisan' : 'other',
          'ability': ability,
          'weight_kg': ?weight,
          'cost_cp': parsePrice(b.price!)!,
        },
        text: text,
      ));
      continue;
    }
    for (final v in _variant.allMatches(field('Variantes') ?? '')) {
      final name = v[1]!.trim();
      final slug = slugs[name];
      if (slug == null) throw FormatException('variante sans slug : $name');
      final variantWeight = v[3] == null ? weight : parseWeight(v[3]!);
      tools.add((
        slug: slug,
        name: '${b.name} : $name',
        data: {
          'category': parent,
          'ability': ability,
          'weight_kg': ?variantWeight,
          'cost_cp': parsePrice(v[2]!)!,
        },
        text: text,
      ));
    }
  }

  final found = {for (final t in tools) t.slug};
  final missing = [
    for (final MapEntry(:key, :value) in slugs.entries)
      if (!found.contains(value)) key,
  ];
  if (missing.isNotEmpty) {
    throw FormatException('outils introuvables : ${missing.join(', ')}');
  }
  return tools;
}

/// Texte de chaque description « Nom (prix) » de [descriptions], lu dans la
/// section « Matériel d’aventurier » de [text]. Les tables mêlées au texte
/// sont retirées jusqu'à la description suivante.
Map<String, String> extractGearTexts(String text, List<String> descriptions) {
  final lines = srdSection(
    text,
    'Matériel d’aventurier',
    'Montures et véhicules',
  ).lines;
  final texts = <String, List<String>>{};
  String? current;
  var inTable = false;
  for (final line in lines) {
    final header = descriptions
        .where((d) => line.startsWith('$d (') && line.endsWith(')'))
        .firstOrNull;
    if (header != null) {
      current = header;
      inTable = false;
      texts[header] = [];
    } else if (_gearTables.contains(line)) {
      inTable = true;
    } else if (!inTable && current != null) {
      texts[current]!.add(line);
    }
  }
  final missing = descriptions.where((d) => !texts.containsKey(d));
  if (missing.isNotEmpty) {
    throw FormatException('descriptions introuvables : ${missing.join(', ')}');
  }
  return {
    for (final MapEntry(:key, :value) in texts.entries) key: paragraphs(value),
  };
}

/// `true` si le tableau en page [layout] montre [label] suivi, sur sa ligne
/// (ou sur la suivante quand le libellé la termine), de [weight] puis de
/// [price].
bool gearRowInLayout(
  String layout,
  String label,
  String weight,
  String price,
) => RegExp(
  '${[for (final w in label.split(' ')) RegExp.escape(w)].join(r'\s+')}'
  // Un exposant (« 1er ») peut se glisser seul sur la ligne suivante.
  r'(?=\s)[^\n]*?\s+(?:[a-z]{1,2}\s+)?'
  '${RegExp.escape(weight)}'
  r'\s+'
  '${RegExp.escape(price)}'
  r'(?!\d)',
).hasMatch(layout);

/// Lit `extract/gear.tsv`.
List<GearRow> readGear(File file) => [
  for (final line in file.readAsLinesSync())
    if (line.trim().isNotEmpty && !line.startsWith('#'))
      switch (line.split('\t')) {
        [
          final slug,
          final name,
          final label,
          final weight,
          final price,
          final description,
        ] =>
          (
            slug: slug,
            name: name,
            label: label,
            weight: weight,
            price: price,
            description: description,
          ),
        _ => throw FormatException('ligne de gear.tsv invalide : $line'),
      },
];

/// Commande `extract-equipment` : écrit les outils et les objets de
/// [gear] dans [sources]. Les effets éventuels sont gardés.
void extractEquipment({
  required String readingOrder,
  required List<GearRow> gear,
  required String sources,
  required StringSink report,
}) {
  Map<String, Object?>? read(File file) => file.existsSync()
      ? jsonDecode(file.readAsStringSync()) as Map<String, Object?>
      : null;
  void write(String type, String slug, Map<String, Object?> entity) {
    final file = File('$sources/$type/$slug.json');
    final existing = read(file);
    if (existing == null) report.writeln('$type créé : $slug');
    writeJson(file, {
      'id': 'srd:$type:$slug',
      'type': type,
      ...entity,
      'effects': ?existing?['effects'],
      'text': entity['text'],
    });
  }

  for (final t in extractTools(readingOrder, srdTools)) {
    write('tool', t.slug, {
      'name': t.name,
      'data': t.data,
      'text': {'fr': t.text},
    });
  }
  final texts = extractGearTexts(readingOrder, [
    ...{for (final g in gear) g.description},
  ]);
  for (final g in gear) {
    write('item', g.slug, {
      'name': g.name,
      'data': {
        'weight_kg': ?parseWeight(g.weight),
        'cost_cp': ?parsePrice(g.price),
      },
      'text': {'fr': texts[g.description]},
    });
  }
}
