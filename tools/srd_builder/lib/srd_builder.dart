/// CLI qui produit le pack SRD 5.2.1 (FR) à partir des sources JSON.
library;

import 'package:args/args.dart';

/// Point d'entrée testable de la CLI. Renvoie le code de sortie.
int run(List<String> arguments, StringSink out, StringSink err) {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: "Affiche l'aide.")
    ..addCommand('build');

  final ArgResults results;
  try {
    results = parser.parse(arguments);
  } on FormatException catch (e) {
    err
      ..writeln(e.message)
      ..writeln(parser.usage);
    return 64;
  }

  if (results.flag('help') || results.command == null) {
    out
      ..writeln('Usage : srd_builder build')
      ..writeln(parser.usage);
    return 0;
  }

  // Le build du pack arrive avec US-02.
  err.writeln('La commande build n\'est pas encore implémentée.');
  return 1;
}
