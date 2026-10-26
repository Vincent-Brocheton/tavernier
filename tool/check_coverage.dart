// Vérifie qu'un fichier lcov atteint un seuil de couverture des lignes.
//
// Usage : dart run tool/check_coverage.dart <lcov.info> <seuil en %>
import 'dart:io';

void main(List<String> args) {
  if (args.length != 2) {
    stderr.writeln('Usage : check_coverage.dart <lcov.info> <seuil>');
    exit(64);
  }
  final file = File(args[0]);
  final threshold = double.parse(args[1]);
  if (!file.existsSync()) {
    stderr.writeln('Fichier introuvable : ${args[0]}');
    exit(66);
  }

  // Le code généré (freezed, json_serializable) n'entre pas dans le calcul.
  final generated = RegExp(r'\.(g|freezed)\.dart$');
  var skip = false;
  var found = 0;
  var hit = 0;
  for (final line in file.readAsLinesSync()) {
    if (line.startsWith('SF:')) skip = generated.hasMatch(line);
    if (skip) continue;
    if (line.startsWith('LF:')) found += int.parse(line.substring(3));
    if (line.startsWith('LH:')) hit += int.parse(line.substring(3));
  }

  if (found == 0) {
    stderr.writeln('ÉCHEC ${args[0]} : aucune ligne instrumentée');
    exit(1);
  }
  final percent = hit * 100 / found;
  final label =
      '${args[0]} : ${percent.toStringAsFixed(1)} % '
      '($hit/$found lignes, seuil $threshold %)';
  if (percent < threshold) {
    stderr.writeln('ÉCHEC $label');
    exit(1);
  }
  stdout.writeln('OK $label');
}
