/// CLI qui produit le pack SRD 5.2.1 (FR) à partir des sources JSON.
library;

import 'dart:io';

import 'package:args/args.dart';
import 'package:dnd_content/dnd_content.dart';

import 'src/source_loader.dart';

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
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: "Affiche l'aide.")
    ..addCommand('build', build);

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
      ..writeln(build.usage);
    return 0;
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
