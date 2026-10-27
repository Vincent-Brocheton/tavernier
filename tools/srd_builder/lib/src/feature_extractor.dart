// Extraction des textes d'aptitude de classe et de sous-classe depuis le
// texte du PDF en ordre de lecture (change t-04b-classes-1, décision 3). Le
// texte est copié tel quel ; seules les données (`data`, `effects`) sont
// saisies à la main, et une nouvelle extraction les garde.

import 'spell_extractor.dart';

/// Une aptitude lue dans le SRD.
typedef ExtractedFeature = ({
  int level,
  String name,
  String text,

  /// `true` pour une aptitude de la sous-classe.
  bool subclass,
});

/// Section d'une classe : ses aptitudes, sa sous-classe et le texte
/// d'introduction de celle-ci.
typedef ClassSection = ({
  List<ExtractedFeature> features,
  String? subclassName,
  String subclassText,
  List<String> joins,
});

final _feature = RegExp(r'^Niveau (\d+) : (.+)$');
final _subclass = RegExp(r'^Sous-classe d(?:e |’)(.+?) : (.+)$');

/// Titres qui terminent une aptitude sans en commencer une.
final _sectionBreak = RegExp(r'^(Liste des sorts d|Options de )');

/// Section de la classe [className] dans [text] : de « Traits de base
/// du … » à la classe suivante (ou aux origines des personnages).
/// [tableTitle] est le titre de sa table de progression (« Aptitudes du
/// Barbare »), retirée quand elle s'intercale dans le texte d'une aptitude.
/// [appendSections] rattache une section interne à une aptitude, par
/// exemple `{'Options de Métamagie': 'Métamagie'}`.
ClassSection extractClassSection(
  String text,
  String className, {
  required String tableTitle,
  Map<String, String> appendSections = const {},
  Map<String, ({int lines, String to})> sidebars = const {},
  List<String> dropTables = const [],
}) {
  // pdftotext sous Windows termine les lignes par CRLF.
  text = text.replaceAll('\r\n', '\n');
  final start = text.indexOf(
    RegExp('^Traits de base d(?:u |e l’)$className\$', multiLine: true),
  );
  if (start < 0) throw FormatException('classe introuvable : $className');
  final next = RegExp(
    // « Origines des / personnages » : titre coupé en deux lignes, souvent
    // précédé d'un saut de page.
    r'^\f?(Traits de base d(?:u |e l’)\S+|Origines des\s+personnages)$',
    multiLine: true,
  ).allMatches(text, start + 1).firstOrNull;
  var end = next?.start ?? text.length;
  // La section suivante commence à son titre de classe, seul sur sa ligne,
  // parfois suivi de « Devenir … » avant ses « Traits de base ».
  final nextName = next?[1]?.replaceFirst(
    RegExp(r'^Traits de base d(?:u |e l’)'),
    '',
  );
  if (nextName != null && next![1]!.startsWith('Traits')) {
    final title = text.lastIndexOf(
      RegExp('\n\f?${RegExp.escape(nextName)}\n'),
      end,
    );
    if (title > start) end = title + 1;
  }
  final clean = cleanText(text.substring(start, end));
  var lines = _dropTable(clean.lines, tableTitle);
  // Tables internes dont les valeurs sont portées par les effets. Des
  // tables consécutives partent ensemble avec la première.
  for (final title in dropTables) {
    if (!clean.lines.contains(title)) {
      throw FormatException('table introuvable : $title');
    }
    lines = _dropTable(lines, title);
  }
  // Le titre de la classe suivante précède ses « Traits de base ».
  final nextClass = next?[1]?.replaceFirst(
    RegExp(r'^Traits de base d(?:u |e l’)'),
    '',
  );
  if (lines.isNotEmpty && lines.last == nextClass) {
    lines = lines.sublist(0, lines.length - 1);
  }
  // Encadrés intercalés par la lecture : déplacés vers leur aptitude.
  final moved = <String, List<String>>{};
  for (final MapEntry(key: title, value: sidebar) in sidebars.entries) {
    final at = lines.indexOf(title);
    if (at < 0) throw FormatException('encadré introuvable : $title');
    final end = at + sidebar.lines;
    moved[sidebar.to] = lines.sublist(at, end);
    // Phrase coupée par l'encadré : ses deux moitiés se recollent.
    final before = at > 0 ? lines[at - 1] : null;
    final after = end < lines.length ? lines[end] : null;
    if (before != null &&
        after != null &&
        !RegExp(r'[.:!?»)…]$').hasMatch(before) &&
        RegExp(r'^[a-zàâéèêëîïôöùûüç]').hasMatch(after)) {
      lines = [
        ...lines.sublist(0, at - 1),
        '$before $after',
        ...lines.sublist(end + 1),
      ];
    } else {
      lines = [...lines.sublist(0, at), ...lines.sublist(end)];
    }
  }

  final features = <ExtractedFeature>[];
  String? subclassName;
  final subclassText = <String>[];
  String? current;
  int? level;
  var body = <String>[];
  var inSubclass = false;
  String? appendTo;
  // Sections rattachées et encadrés : ajoutés au texte de leur aptitude.
  final attached = moved;

  void flush() {
    if (current case final name?) {
      features.add((
        level: level!,
        name: name,
        text: body.join('\n'),
        subclass: inSubclass,
      ));
    }
    current = null;
    body = [];
  }

  for (final line in lines) {
    final f = _feature.firstMatch(line);
    final s = _subclass.firstMatch(line);
    if (f != null) {
      flush();
      appendTo = null;
      level = int.parse(f[1]!);
      current = f[2]!.trim();
    } else if (s != null && s[1] == className) {
      flush();
      appendTo = null;
      inSubclass = true;
      subclassName = s[2]!.trim();
    } else if (_sectionBreak.hasMatch(line)) {
      flush();
      appendTo = appendSections[line];
      if (appendTo case final target?) {
        attached.putIfAbsent(target, () => []).add(line);
      }
    } else if (appendTo case final target?) {
      attached[target]!.add(line);
    } else if (current != null) {
      body.add(line);
    } else if (inSubclass) {
      subclassText.add(line);
    }
  }
  flush();

  return (
    features: [
      for (final f in features)
        (
          level: f.level,
          name: f.name,
          text: [f.text, ...?attached[f.name]].join('\n'),
          subclass: f.subclass,
        ),
    ],
    subclassName: subclassName,
    subclassText: subclassText.join('\n'),
    joins: clean.joins,
  );
}

/// Retire la table de progression [title] : du titre à la première ligne
/// de texte courant (une phrase terminée) ou au premier titre d'aptitude.
List<String> _dropTable(List<String> lines, String title) {
  final at = lines.indexOf(title);
  if (at < 0) return lines;
  var end = at + 1;
  while (end < lines.length &&
      !_isProse(lines[end]) &&
      !_feature.hasMatch(lines[end])) {
    end++;
  }
  return [...lines.sublist(0, at), ...lines.sublist(end)];
}

bool _isProse(String line) =>
    line.length > 40 &&
    RegExp(r'[.:!?»)]$').hasMatch(line) &&
    RegExp(r'\p{L}{3,} \p{L}{3,} \p{L}{3,}', unicode: true).hasMatch(line) &&
    !_feature.hasMatch(line);
