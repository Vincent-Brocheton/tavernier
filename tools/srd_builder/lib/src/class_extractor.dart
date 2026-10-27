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
      final file = File('$sources/feature/$slug.json');
      final existing = file.existsSync()
          ? jsonDecode(file.readAsStringSync()) as Map<String, Object?>
          : null;
      if (existing == null) report.writeln('créée : $slug');
      _write(file, {
        'id': 'srd:feature:$slug',
        'type': 'feature',
        'name': f.name,
        'data':
            existing?['data'] ??
            {
              'source': f.subclass
                  ? 'srd:subclass:${c.subclassSlug}'
                  : 'srd:class:${c.slug}',
              'level': f.level,
            },
        'effects': ?existing?['effects'],
        'text': {'fr': f.text},
      });
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
    for (final row in parseProgressionTable(layout, c.table, c.columns)) {
      final features = <String>[];
      for (final name in row.features) {
        if (name == 'Aptitude de sous-classe') continue;
        final slug = featureSlug(slugs, c.slug, name, row.level);
        if (slug == null) {
          problems.add(
            'aptitude de table sans slug : ${c.slug}\t$name\t${row.level}',
          );
        } else {
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
    if (spells.isNotEmpty) {
      data['spell_list'] = [for (final s in spells) 'srd:spell:$s'];
    }
    _write(classFile, json);
  }
  return problems;
}

/// Classes citées par l'en-tête de chaque sort : nom de classe → slugs.
Map<String, List<String>> readSpellClasses(File file) {
  final result = <String, List<String>>{};
  for (final line in file.readAsLinesSync()) {
    if (line.trim().isEmpty || line.startsWith('#')) continue;
    final [slug, classes] = line.split('\t');
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
