// Extraction semi-automatique des sorts depuis le texte du PDF officiel en
// ordre de lecture (`pdftotext -enc UTF-8 FR_SRD_CC_v5.2.1.pdf`), décisions 3
// à 6 du change t-04a-sorts-srd. Le texte de règles est copié tel quel :
// seuls les raccords de lignes coupées par une colonne ou une page
// s'appliquent, et chacun est consigné pour la relecture.

/// Lignes nettoyées et raccords effectués.
typedef CleanText = ({List<String> lines, List<String> joins});

final _footer = RegExp(
  r'^(\d+\s+)?Document de Référence du Système 5\.2\.1(\s+\d+)?$',
);
final _pageNumber = RegExp(r'^\d+$');
final _endsSentence = RegExp(r'[.:!?»)…]$');
final _startsLower = RegExp(r'^[a-zàâäéèêëîïôöùûüç]');
final _wordBefore = RegExp(r'(\p{L}+)-$', unicode: true);
final _wordAfter = RegExp(r'^(\p{L}+)', unicode: true);

/// Retire pieds de page, numéros et sauts de page, puis recolle les lignes
/// coupées. Un trait d'union de fin de ligne reste seulement entre deux
/// mots du texte quand le mot recollé n'existe pas (« vous-/même ») ; il
/// disparaît sinon (« mini-/male », « gra-/vés »).
CleanText cleanText(String text) {
  final raw = [
    for (final line in text.replaceAll('\f', '\n').split('\n'))
      if (line.trim().isNotEmpty &&
          !_footer.hasMatch(line.trim()) &&
          !_pageNumber.hasMatch(line.trim()))
        line.trim(),
  ];
  // Vocabulaire du texte, sans les mots coupés en fin de ligne eux-mêmes.
  final unbroken = text.replaceAll(
    RegExp(r'\p{L}+-\s*\n\s*\p{L}+', unicode: true),
    ' ',
  );
  final words = RegExp(
    r'\p{L}+',
    unicode: true,
  ).allMatches(unbroken).map((m) => m[0]!.toLowerCase()).toSet();
  final lines = <String>[];
  final joins = <String>[];
  for (final line in raw) {
    final previous = lines.isEmpty ? null : lines.last;
    if (previous != null && _startsLower.hasMatch(line)) {
      final before = _wordBefore.firstMatch(previous);
      if (before != null) {
        final after = _wordAfter.firstMatch(line)![1]!;
        final merged = '${before[1]}$after'.toLowerCase();
        // Trait d'union réel (« vous-/même ») : les deux moitiés sont des
        // mots et le mot recollé n'existe pas ; sinon c'est une coupure.
        final keepHyphen =
            !words.contains(merged) &&
            words.contains(before[1]!.toLowerCase()) &&
            words.contains(after.toLowerCase());
        lines.last = keepHyphen
            ? '$previous$line'
            : '${previous.substring(0, previous.length - 1)}$line';
        joins.add(
          '${keepHyphen ? 'trait gardé' : 'mot recollé'} : $previous ⏎ $line',
        );
        continue;
      }
      if (!_endsSentence.hasMatch(previous)) {
        lines.last = '$previous $line';
        joins.add('ligne recollée : $previous ⏎ $line');
        continue;
      }
    }
    lines.add(line);
  }
  return (lines: lines, joins: joins);
}

const _schools = {
  'Abjuration': 'abjuration',
  'Divination': 'divination',
  'Enchantement': 'enchantment',
  'Évocation': 'evocation',
  'Illusion': 'illusion',
  'Invocation': 'conjuration',
  'Nécromancie': 'necromancy',
  'Transmutation': 'transmutation',
};

final _header = RegExp(
  '^(${_schools.keys.join('|')}) (?:du (\\d)(?:er|e) niveau|mineure?) '
  r'\((.+)\)$',
);
final _meta = RegExp(
  r'^Temps d’incantation : (.+?) Portée : (.+?) Composantes : (.+?) '
  r'Durée : (.+)$',
);

/// Un sort lu dans le SRD, avant attribution de son slug anglais.
typedef ExtractedSpell = ({
  String name,
  int level,
  String school,
  List<String> classes,
  String castingTime,
  bool ritual,
  Map<String, Object?> range,
  Map<String, Object?> components,
  int? materialCostCp,
  bool materialConsumed,
  String duration,
  bool concentration,
  String text,
});

/// Découpe les sorts de [lines] (sortie de [cleanText]) : un sort commence
/// au nom qui précède son en-tête d'école et s'arrête au nom du suivant.
List<ExtractedSpell> splitSpells(List<String> lines) {
  final starts = [
    for (var i = 1; i < lines.length; i++)
      if (_header.hasMatch(lines[i])) i - 1,
  ];
  return [
    for (final (k, start) in starts.indexed)
      _spell(
        lines.sublist(
          start,
          k + 1 < starts.length ? starts[k + 1] : lines.length,
        ),
      ),
  ];
}

ExtractedSpell _spell(List<String> block) {
  final header = _header.firstMatch(block[1])!;
  // La ligne de métadonnées peut avoir été coupée (page, colonne).
  var metaEnd = 2;
  var meta = block[2];
  while (!_meta.hasMatch(meta) && metaEnd + 1 < block.length) {
    metaEnd++;
    meta = '$meta ${block[metaEnd]}';
  }
  final m = _meta.firstMatch(meta);
  if (m == null) {
    throw FormatException('métadonnées illisibles : ${block[0]}');
  }
  final casting = m[1]!;
  final material = parseComponents(m[3]!);
  final duration = m[4]!;
  return (
    name: block[0],
    level: int.parse(header[2] ?? '0'),
    school: _schools[header[1]]!,
    classes: header[3]!.split(', '),
    castingTime: casting.replaceFirst(RegExp(r' ou rituel$'), ''),
    ritual: casting.endsWith(' ou rituel'),
    range: parseRange(m[2]!),
    components: material.components,
    materialCostCp: material.costCp,
    materialConsumed: material.consumed,
    duration: duration.replaceFirst('Concentration, ', ''),
    concentration: duration.startsWith('Concentration, '),
    text: block.sublist(metaEnd + 1).join('\n'),
  );
}

/// Portée du SRD convertie en pieds (1,50 m = 5 pieds).
Map<String, Object?> parseRange(String range) {
  final kinds = {
    'personnelle': 'self',
    'contact': 'touch',
    'champ de vision': 'sight',
    'illimitée': 'unlimited',
    'spéciale': 'special',
  };
  final kind = kinds[range.trim()];
  if (kind != null) return {'kind': kind};
  final m = RegExp(r'^(\d+(?:,\d+)?) (m|km)$').firstMatch(range.trim());
  if (m == null) throw FormatException('portée illisible : $range');
  final meters =
      double.parse(m[1]!.replaceAll(',', '.')) * (m[2] == 'km' ? 1000 : 1);
  return {'kind': 'feet', 'feet': (meters * 10 / 3).round()};
}

/// Composantes V, S, M : texte du composant matériel, coût en pc, et s'il
/// est consommé par le sort.
({Map<String, Object?> components, int? costCp, bool consumed}) parseComponents(
  String components,
) {
  final paren = components.indexOf('(');
  final letters = (paren < 0 ? components : components.substring(0, paren))
      .split(',')
      .map((c) => c.trim())
      .toSet();
  final material = paren < 0
      ? null
      : components.substring(paren + 1, components.lastIndexOf(')'));
  // « d’une valeur minimale de 500 po », « au moins 25 000 po de diamants »,
  // « deux bagues … d’une valeur de 50 po chacune ».
  final cost = material == null
      ? null
      : RegExp(
          r'(?:valeur (?:minimale )?de|au moins) ([\d\s]+) (po|pa|pc)( chacune)?',
        ).firstMatch(material);
  final rate = {'po': 100, 'pa': 10, 'pc': 1};
  const counts = {'deux': 2, 'trois': 3, 'quatre': 4};
  final each = cost?[3] == null
      ? 1
      : counts[material!.split(' ').first] ??
            (throw FormatException('nombre d’objets illisible : $material'));
  return (
    components: {
      'verbal': letters.contains('V'),
      'somatic': letters.contains('S'),
      'material': ?material,
    },
    costCp: cost == null
        ? null
        : int.parse(cost[1]!.replaceAll(RegExp(r'\s'), '')) *
              rate[cost[2]]! *
              each,
    consumed:
        material != null &&
        RegExp(r'que le sort (détruit|consume)').hasMatch(material),
  );
}
