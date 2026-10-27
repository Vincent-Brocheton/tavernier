// Lecture d'une table de progression de classe dans le texte du SRD en mise
// en page (docs/srd/FR_SRD_CC_v5.2.1.txt), où chaque niveau tient sur une
// ligne : niveau, bonus de maîtrise, aptitudes, puis les colonnes de la
// classe (change t-04b-classes-1, décision 5).

/// Une ligne de la table.
typedef ProgressionRow = ({
  int level,
  int proficiencyBonus,
  List<String> features,

  /// Valeurs entières des colonnes ; « — » est omis.
  Map<String, int> columns,
});

final _row = RegExp(r'^\s*(\d{1,2})\s+\+(\d)\s{2,}(.*?)\s*$');
final _continuation = RegExp(r'^\s{10,}(\S.*?)\s*$');

/// Lit les 20 niveaux de la table [title] ; [columns] nomme ses colonnes
/// dans l'ordre (les emplacements de sort s'appellent `slot_1` à `slot_9`).
/// Un dé (« d8 ») donne son nombre de faces, un bonus (« +2 ») sa valeur.
List<ProgressionRow> parseProgressionTable(
  String layout,
  String title,
  List<String> columns,
) {
  final lines = layout.split('\n');
  final start = lines.indexWhere((l) => l.trim() == title);
  if (start < 0) throw FormatException('table introuvable : $title');
  final rows = <ProgressionRow>[];
  for (var i = start + 1; i < lines.length && rows.length < 20; i++) {
    final m = _row.firstMatch(lines[i]);
    if (m == null || int.parse(m[1]!) != rows.length + 1) continue;
    final pieces = m[3]!.split(RegExp(r'\s{2,}'));
    var features = pieces.first;
    final tokens = pieces.skip(1).join(' ').split(RegExp(r'\s+'));
    // Nom d'aptitude passé à la ligne : la ligne suivante commence par une
    // minuscule, ou la ligne en cours se termine par une virgule.
    final next = i + 1 < lines.length
        ? _continuation.firstMatch(lines[i + 1])
        : null;
    if (next != null &&
        (features.endsWith(',') ||
            RegExp(r'^[a-zàâéèêëîïôöùûüç]').hasMatch(next[1]!))) {
      features = '$features ${next[1]}';
      i++;
    }
    if (tokens.length != columns.length) {
      throw FormatException(
        '$title, niveau ${m[1]} : ${tokens.length} valeurs pour '
        '${columns.length} colonnes (${tokens.join(' ')})',
      );
    }
    rows.add((
      level: int.parse(m[1]!),
      proficiencyBonus: int.parse(m[2]!),
      features: [
        for (final name in features.split(RegExp(r',\s*')))
          if (name.trim() != '—' && name.trim().isNotEmpty) name.trim(),
      ],
      columns: {
        for (final (k, token) in tokens.indexed) columns[k]: ?_value(token),
      },
    ));
  }
  if (rows.length != 20) {
    throw FormatException('$title : ${rows.length} niveaux lus sur 20');
  }
  return rows;
}

int? _value(String token) => switch (token) {
  '—' => null,
  _ when token.startsWith('+') => int.parse(token.substring(1)),
  _ when token.startsWith('d') => int.parse(token.substring(1)),
  _ => int.parse(token),
};
