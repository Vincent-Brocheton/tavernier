/// CLI qui produit le pack SRD 5.2.1 (FR) à partir des sources JSON.
library;

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:dnd_content/dnd_content.dart';

import 'src/source_loader.dart';
import 'src/spell_extractor.dart';

export 'src/source_loader.dart';

const defaultSources = 'tools/srd_builder/sources';
const defaultOut = 'build/srd-5.2.1-fr.dndpack';

/// Point d'entrée testable de la CLI. Renvoie le code de sortie :
/// 0 succès, 1 contenu invalide, 64 usage.
int run(List<String> arguments, StringSink out, StringSink err) {
  final build = ArgParser()
    ..addOption(
      'sources',
      defaultsTo: defaultSources,
      help: 'Dossier des sources JSON.',
    )
    ..addOption(
      'out',
      defaultsTo: defaultOut,
      help: 'Archive .dndpack produite.',
    );
  final extractSpells = ArgParser()
    ..addOption(
      'text',
      mandatory: true,
      help: 'Texte du PDF en ordre de lecture (pdftotext -enc UTF-8).',
    )
    ..addOption(
      'slugs',
      defaultsTo: 'tools/srd_builder/extract/spell_slugs.tsv',
      help: 'Correspondance nom français → slug anglais.',
    )
    ..addOption(
      'out',
      defaultsTo: '$defaultSources/spell',
      help: 'Dossier des sources de sorts.',
    )
    ..addOption(
      'classes-out',
      defaultsTo: 'tools/srd_builder/extract/spell_classes.tsv',
      help: 'Classes lues dans les en-têtes, pour vérifier les listes.',
    )
    ..addOption(
      'report',
      defaultsTo: 'build/extract-spells.txt',
      help: 'Raccords de lignes effectués, à relire.',
    );
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: "Affiche l'aide.")
    ..addCommand('build', build)
    ..addCommand('extract-spells', extractSpells);

  final ArgResults results;
  try {
    results = parser.parse(arguments);
  } on FormatException catch (e) {
    err
      ..writeln(e.message)
      ..writeln(parser.usage);
    return 64;
  }

  final command = results.command;
  if (results.flag('help') || command == null) {
    out
      ..writeln(
        'Usage : srd_builder build [--sources <dossier>] [--out <fichier>]',
      )
      ..writeln(build.usage)
      ..writeln('       srd_builder extract-spells --text <fichier>')
      ..writeln(extractSpells.usage);
    return 0;
  }
  if (command.name == 'extract-spells') {
    return _extractSpells(command, out, err);
  }

  final loaded = loadSources(Directory(command.option('sources')!));
  final pack = loaded.pack;
  if (pack == null) {
    for (final issue in loaded.issues) {
      err.writeln(issue);
    }
    err.writeln('Build en échec : ${loaded.issues.length} problème(s).');
    return 1;
  }

  final target = File(command.option('out')!)
    ..parent.createSync(recursive: true);
  target.writeAsBytesSync(writeDndpack(pack));
  out.writeln('${target.path} : ${pack.entities.length} entités.');
  return 0;
}

int _extractSpells(ArgResults command, StringSink out, StringSink err) {
  final text = File(command.option('text')!).readAsStringSync();
  // Titres seuls sur leur ligne : le sommaire les cite aussi.
  final start = text.indexOf(
    RegExp(r'^Description des sorts$', multiLine: true),
  );
  final end = text.indexOf(
    RegExp(r'^\f?Glossaire de règles$', multiLine: true),
    start < 0 ? 0 : start,
  );
  if (start < 0 || end < 0) {
    err.writeln('section « Description des sorts » introuvable');
    return 1;
  }
  final clean = cleanText(text.substring(start, end));
  final spells = splitSpells(clean.lines);

  final slugs = <String, String>{};
  for (final line in File(command.option('slugs')!).readAsLinesSync()) {
    if (line.trim().isEmpty || line.startsWith('#')) continue;
    final [name, slug] = line.split('\t');
    slugs[name] = slug;
  }
  final missing = [
    for (final s in spells)
      if (!slugs.containsKey(s.name)) s.name,
  ];
  final duplicates = [
    for (final MapEntry(:key, :value) in {
      for (final slug in slugs.values)
        slug: slugs.values.where((v) => v == slug).length,
    }.entries)
      if (value > 1) key,
  ];
  if (missing.isNotEmpty || duplicates.isNotEmpty) {
    for (final name in missing) {
      err.writeln('slug manquant : $name');
    }
    for (final slug in duplicates) {
      err.writeln('slug en double : $slug');
    }
    return 1;
  }

  final dir = Directory(command.option('out')!)..createSync(recursive: true);
  const encoder = JsonEncoder.withIndent('  ');
  final classes = StringBuffer('# sort\tclasses (en-tête du SRD)\n');
  for (final s in spells) {
    final slug = slugs[s.name]!;
    final json = {
      'id': 'srd:spell:$slug',
      'type': 'spell',
      'name': s.name,
      'data': {
        'level': s.level,
        'school': s.school,
        'casting_time': s.castingTime,
        'ritual': s.ritual,
        'range': s.range,
        'components': s.components,
        'material_cost_cp': ?s.materialCostCp,
        'material_consumed': s.materialConsumed,
        'duration': s.duration,
        'concentration': s.concentration,
      },
      'text': {'fr': s.text},
    };
    File('${dir.path}/$slug.json')
        .writeAsStringSync('${encoder.convert(json)}\n');
    classes.writeln('$slug\t${s.classes.join(', ')}');
  }
  File(command.option('classes-out')!)
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(classes.toString());
  File(command.option('report')!)
    ..parent.createSync(recursive: true)
    ..writeAsStringSync('${clean.joins.join('\n')}\n');
  out.writeln(
    '${spells.length} sorts écrits dans ${dir.path} ; '
    '${clean.joins.length} raccords à relire dans ${command.option('report')}.',
  );
  return 0;
}
