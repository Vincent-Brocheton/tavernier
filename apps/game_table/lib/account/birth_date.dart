// Date de naissance déclarée à l'inscription (EF-CPT-01) : 15 ans au moins.

/// Âge minimal pour créer un compte.
const minimumAge = 15;

/// Date saisie au format `JJ/MM/AAAA`, ou `null` si elle n'existe pas.
DateTime? parseBirthDate(String text) {
  final match = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(text.trim());
  if (match == null) return null;
  final [day, month, year] = [
    for (var i = 1; i <= 3; i++) int.parse(match[i]!),
  ];
  final date = DateTime(year, month, day);
  // 31/02 deviendrait le 3 mars : on le refuse.
  if (date.day != day || date.month != month || date.year != year) return null;
  return date;
}

/// Vrai si [birth] donne au moins [minimumAge] ans le jour [today].
bool oldEnough(DateTime birth, DateTime today) => !DateTime(
  birth.year + minimumAge,
  birth.month,
  birth.day,
).isAfter(DateTime(today.year, today.month, today.day));
