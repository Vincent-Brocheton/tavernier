// Commande `extract-classes` (change t-04b-classes-1) : écrit les aptitudes,
// la sous-classe, la table de progression et la liste de sorts de chaque
// classe du lot. Les traits de base de la classe et les effets des
// aptitudes sont saisis à la main : une nouvelle extraction les garde.

import 'dart:convert';
import 'dart:io';

import 'feature_extractor.dart';
import 'progression_table.dart';
import 'srd_classes.dart';

const _encoder = JsonEncoder.withIndent('  ');

/// Table des slugs d'aptitude : (classe, nom, niveau) → slug. Un nom de
/// la table de progression qui diffère de son titre de section y figure
/// aussi (alias).
typedef FeatureSlugs = Map<(String, String, int), String>;

FeatureSlugs readFeatureSlugs(File file) {
  final slugs = <(String, String, int), String>{};
  for (final line in file.readAsLinesSync()) {
    if (line.trim().isEmpty || line.startsWith('#')) continue;
    final columns = line.split('\t');
    if (columns.length != 4) {
      throw FormatException('ligne de slugs invalide : $line');
    }
    slugs[(columns[0], columns[1], int.parse(columns[2]))] = columns[3];
  }
  return slugs;
}

/// Slug de l'aptitude [name] de [classSlug] au niveau [level], ou à défaut
/// sous ce nom à un autre niveau (Amélioration de caractéristique, reprise
/// aux niveaux 8, 12, 16).
String? featureSlug(
  FeatureSlugs slugs,
  String classSlug,
  String name,
  int level,
) {
  final exact = slugs[(classSlug, name, level)];
  if (exact != null) return exact;
  final byName = {
    for (final MapEntry(:key, :value) in slugs.entries)
      if (key.$1 == classSlug && key.$2 == name) value,
  };
  return byName.length == 1 ? byName.single : null;
}

/// Extrait les classes [only] (toutes si vide). Renvoie les problèmes.
List<String> extractClasses({
  required String readingOrder,
  required String layout,
  required FeatureSlugs slugs,
  required Map<String, List<String>> spellClasses,
  required String sources,
  required StringSink report,
  Set<String> only = const {},
}) {
  final problems = <String>[];
  for (final c in srdClasses) {
    if (only.isNotEmpty && !only.contains(c.slug)) continue;
    final section = extractClassSection(
      readingOrder,
      c.name,
      tableTitle: c.table,
      appendSections: c.appendSections,
      sidebars: c.sidebars,
      dropTables: c.dropTables,
    );
    report.writeln('== ${c.name}');
    section.joins.forEach(report.writeln);

    // Aptitudes : nom et texte réécrits, données et effets gardés.
    final subclassFeatures = <String>[];
    for (final f in section.features) {
      final slug = f.subclass
          ? slugs[(c.subclassSlug, f.name, f.level)]
          : slugs[(c.slug, f.name, f.level)];
      if (slug == null) {
        problems.add(
          'slug manquant : ${f.subclass ? c.subclassSlug : c.slug}\t'
          '${f.name}\t${f.level}',
        );
        continue;
      }
      if (f.subclass) subclassFeatures.add('srd:feature:$slug');
      final created = writeFeature(
        File('$sources/feature/$slug.json'),
        name: f.name,
        text: f.text,
        source: f.subclass
            ? 'srd:subclass:${c.subclassSlug}'
            : 'srd:class:${c.slug}',
        level: f.level,
      );
      if (created) report.writeln('créée : $slug');
    }

    // Sous-classe : régénérée entièrement.
    _write(File('$sources/subclass/${c.subclassSlug}.json'), {
      'id': 'srd:subclass:${c.subclassSlug}',
      'type': 'subclass',
      'name': section.subclassName,
      'data': {
        'parent_class': 'srd:class:${c.slug}',
        'features': subclassFeatures,
      },
      'text': {'fr': section.subclassText},
    });

    // Classe : niveaux et liste de sorts réécrits, traits de base gardés.
    final classFile = File('$sources/class/${c.slug}.json');
    if (!classFile.existsSync()) {
      problems.add(
        'classe à créer à la main (traits de base) : ${classFile.path}',
      );
      continue;
    }
    final json =
        jsonDecode(classFile.readAsStringSync()) as Map<String, Object?>;
    final data = json['data']! as Map<String, Object?>;
    final levels = <Map<String, Object?>>[];
    // Le moteur applique une aptitude à chaque niveau où elle figure : seule
    // une aptitude qui accorde un don (Amélioration de caractéristique) se
    // répète ; les autres (Expertise, Métamagie) gardent leur premier niveau
    // et leurs paliers passent par `when.level`.
    final listed = <String>{};
    for (final row in parseProgressionTable(layout, c.table, c.columns)) {
      final features = <String>[];
      for (final name in row.features) {
        if (name == 'Aptitude de sous-classe') continue;
        final slug = featureSlug(slugs, c.slug, name, row.level);
        if (slug == null) {
          problems.add(
            'aptitude de table sans slug : ${c.slug}\t$name\t${row.level}',
          );
        } else if (listed.add(slug) ||
            _grantsFeat('$sources/feature/$slug.json')) {
          features.add('srd:feature:$slug');
        }
      }
      levels.add({
        'level': row.level,
        'proficiency_bonus': row.proficiencyBonus,
        'features': features,
        'columns': row.columns,
      });
    }
    data['levels'] = levels;
    final spells = spellClasses[c.name] ?? const [];
    if (spells.isEmpty) {
      data.remove('spell_list');
    } else {
      data['spell_list'] = [for (final s in spells) 'srd:spell:$s'];
    }
    _write(classFile, json);
  }
  return problems;
}

/// Écrit l'aptitude [file] : nom et texte réécrits, `data` et `effects`
/// saisis à la main gardés. Renvoie `true` si le fichier est nouveau.
bool writeFeature(
  File file, {
  required String name,
  required String text,
  required String source,
  required int level,
}) {
  final existing = file.existsSync()
      ? jsonDecode(file.readAsStringSync()) as Map<String, Object?>
      : null;
  final slug = file.uri.pathSegments.last.replaceFirst('.json', '');
  _write(file, {
    'id': 'srd:feature:$slug',
    'type': 'feature',
    'name': name,
    'data': existing?['data'] ?? {'source': source, 'level': level},
    'effects': ?existing?['effects'],
    'text': {'fr': text},
  });
  return existing == null;
}

/// Classes citées par l'en-tête de chaque sort : nom de classe → slugs.
Map<String, List<String>> readSpellClasses(File file) {
  final result = <String, List<String>>{};
  for (final line in file.readAsLinesSync()) {
    if (line.trim().isEmpty || line.startsWith('#')) continue;
    final columns = line.split('\t');
    if (columns.length != 2) {
      throw FormatException('ligne de spell_classes.tsv invalide : $line');
    }
    final [slug, classes] = columns;
    for (final c in classes.split(', ')) {
      result.putIfAbsent(c, () => []).add(slug);
    }
  }
  for (final list in result.values) {
    list.sort();
  }
  return result;
}

void _write(File file, Object json) {
  file.parent.createSync(recursive: true);
  file.writeAsStringSync('${_encoder.convert(json)}\n');
}

/// `true` si l'aptitude [path] accorde un don, et peut donc se répéter.
bool _grantsFeat(String path) {
  final json =
      jsonDecode(File(path).readAsStringSync()) as Map<String, Object?>;
  final effects = (json['effects'] as List<Object?>?) ?? const [];
  return effects.any((e) => (e! as Map<String, Object?>)['op'] == 'grant_feat');
}
