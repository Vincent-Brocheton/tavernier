// Déverrouillage de la montée de niveau (EF-SEA-05, change
// us-35a-deverrouillage-niveau).

import 'level_up.dart' show maxCharacterLevel;

/// PX requis pour chaque niveau, du 1 au 20 : table « Évolution du
/// personnage » du SRD 5.2.1.
const xpThresholds = [
  0, 300, 900, 2700, 6500, 14000, 23000, 34000, 48000, 64000, //
  85000, 100000, 120000, 140000, 165000, 195000, 225000, 265000, //
  305000, 355000,
];

/// PX du niveau qui suit [level], `null` au niveau 20.
int? nextXpThreshold(int level) =>
    level < maxCharacterLevel ? xpThresholds[level] : null;

/// Progression d'une table (`game_table.progression_mode`).
enum ProgressionMode {
  xp,
  milestone;

  static ProgressionMode parse(String value) => values.byName(value);
}

/// D'où vient le déverrouillage : seuil de PX, niveau accordé en jalons ou
/// dérogation du MJ.
enum UnlockOrigin { xp, milestone, override }

/// Montée au niveau [level] déverrouillée.
final class LevelUnlock {
  const LevelUnlock({
    required this.level,
    required this.origin,
    this.xp,
    this.by,
    this.reason,
    this.sessionId,
  });

  final int level;
  final UnlockOrigin origin;

  /// Seuil atteint, pour [UnlockOrigin.xp].
  final int? xp;

  /// Utilisateur qui a accordé ou débloqué le niveau.
  final String? by;
  final String? reason;
  final String? sessionId;
}

/// Déverrouillage d'une fiche de table de niveau [level] avec [xp] PX.
/// [granted] est `character.level_unlock` : `{level, origin, by, reason?,
/// session?}`. Un niveau accordé déjà atteint ne compte plus ; un jalon ne
/// compte qu'en jalons, une dérogation dans les deux modes.
LevelUnlock? levelUnlockOf({
  required int level,
  required int xp,
  required ProgressionMode mode,
  Map<String, Object?>? granted,
}) {
  if (level >= maxCharacterLevel) return null;
  if (granted
      case {'level': final int grantedLevel, 'origin': final String origin}
      when grantedLevel > level) {
    final kind = UnlockOrigin.values.asNameMap()[origin];
    final counts = switch (kind) {
      UnlockOrigin.override => true,
      UnlockOrigin.milestone => mode == ProgressionMode.milestone,
      _ => false,
    };
    if (counts) {
      return LevelUnlock(
        level: level + 1,
        origin: kind!,
        by: granted['by'] as String?,
        reason: granted['reason'] as String?,
        sessionId: granted['session'] as String?,
      );
    }
  }
  final threshold = xpThresholds[level];
  if (mode == ProgressionMode.xp && xp >= threshold) {
    return LevelUnlock(
      level: level + 1,
      origin: UnlockOrigin.xp,
      xp: threshold,
    );
  }
  return null;
}
