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
/// Un bonus (« +2 ») donne sa valeur. Le suffixe du nom de colonne dit lire
/// un dé : `_die` en garde les faces (« d8 », « 1d6 » → 8, 6), `_dice` le
/// nombre (« 2d6 » → 2) ; `_feet` convertit des mètres (« +3 m ») en pieds.
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
    // L'unité « m » suit sa valeur : ce n'est pas une colonne.
    var tokens = [
      for (final t in pieces.skip(1).join(' ').split(RegExp(r'\s+')))
        if (t != 'm' && t.isNotEmpty) t,
    ];
    // Exposant (« 7e ») qui repousse les valeurs sur une ligne suivante :
    // la lettre seule est sautée, la ligne de valeurs seules est reprise.
    if (tokens.isEmpty) {
      var j = i + 1;
      while (j < lines.length && RegExp(r'^\s*[a-z]?\s*$').hasMatch(lines[j])) {
        j++;
      }
      if (j < lines.length && RegExp(r'^[\s\d—+d]+$').hasMatch(lines[j])) {
        tokens = lines[j].trim().split(RegExp(r'\s+'));
        i = j;
      }
    }
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
        for (final (k, token) in tokens.indexed)
          columns[k]: ?_value(token, columns[k]),
      },
    ));
  }
  if (rows.length != 20) {
    throw FormatException('$title : ${rows.length} niveaux lus sur 20');
  }
  return rows;
}

final _dice = RegExp(r'^(\d*)d(\d+)$');

int? _value(String token, String column) {
  if (token == '—') return null;
  final dice = _dice.firstMatch(token);
  if (dice != null) {
    return column.endsWith('_dice')
        ? int.parse(dice[1]!.isEmpty ? '1' : dice[1]!)
        : int.parse(dice[2]!);
  }
  final number = token.startsWith('+') ? token.substring(1) : token;
  if (column.endsWith('_feet')) {
    // Mètres du SRD français → pieds (1,50 m = 5 pieds).
    return (double.parse(number.replaceAll(',', '.')) * 10 / 3).round();
  }
  return int.parse(number);
}
