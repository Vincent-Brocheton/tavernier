import 'computed_sheet.dart';
import 'spell_play.dart';

/// Ressource déclarée par Ingénieux : une Inspiration à chaque Repos long.
const heroicInspirationResource = 'srd:resource:heroic-inspiration';

/// Type de repos.
enum RestKind { short, long }

/// Règle de repos long de la table (EF-TAB-03).
enum LongRestRule { fullHitPoints, hitDice }

/// Clé de `PlayState.used` pour les dés de vie de type [die].
String hitDieResource(String die) => 'hit-die:$die';

/// PV actuels, entre 0 et le maximum.
int hitPoints(PlayState state, ComputedSheet sheet) {
  final max = sheet.hitPointsMax.value;
  final current = state.hpCurrent ?? max;
  return current > max ? max : current;
}

/// [state] avec [delta] PV de plus, entre 0 et le maximum. Au maximum, les PV
/// redeviennent vides pour suivre une prochaine hausse.
PlayState changeHitPoints(PlayState state, ComputedSheet sheet, int delta) {
  final max = sheet.hitPointsMax.value;
  final next = hitPoints(state, sheet) + delta;
  return state.withHitPoints(next >= max ? null : (next < 0 ? 0 : next));
}

/// Un repos demande au moins 1 PV (SRD, Repos court et Repos long).
bool canRest(PlayState state, ComputedSheet sheet) =>
    hitPoints(state, sheet) >= 1;

/// Dés de vie restants du type [die].
int hitDiceLeft(PlayState state, ({String die, int total}) dice) =>
    dice.total - state.usedOf(hitDieResource(dice.die));

/// [state] après avoir dépensé un dé [die] qui a donné [roll] : le dé plus le
/// modificateur de Constitution, minimum 1 (SRD, Repos court).
PlayState spendHitDie(
  PlayState state,
  ComputedSheet sheet,
  String die,
  int roll,
) {
  final resource = hitDieResource(die);
  final healed = roll + sheet.abilities['con']!.modifier;
  return changeHitPoints(
    state.withUsed({...state.used, resource: state.usedOf(resource) + 1}),
    sheet,
    healed < 1 ? 1 : healed,
  );
}

Map<String, int> _recovered(PlayState state, ComputedSheet sheet, String on) {
  final used = {...state.used};
  for (final MapEntry(key: resource, value: entries)
      in sheet.recharges.entries) {
    for (final entry in entries) {
      if (entry.on != on || !used.containsKey(resource)) continue;
      final left = entry.amount == null ? 0 : used[resource]! - entry.amount!;
      used[resource] = left < 0 ? 0 : left;
    }
  }
  return used;
}

/// [state] à la fin d'un repos.
PlayState finishRest(
  PlayState state,
  ComputedSheet sheet,
  RestKind kind, {
  LongRestRule rule = LongRestRule.fullHitPoints,
}) {
  if (kind == RestKind.short) {
    return state.withUsed(
      {..._recovered(state, sheet, 'short_rest')}..remove(pactSlotResource),
    );
  }
  final used = _recovered(state, sheet, 'long_rest')
    ..removeWhere(
      (key, _) =>
          key == pactSlotResource ||
          key.startsWith('spell-slot:') ||
          key.startsWith('hit-die:'),
    );
  return PlayState(
    used: used,
    hpCurrent: rule == LongRestRule.fullHitPoints ? null : state.hpCurrent,
    exhaustion: state.exhaustion > 0 ? state.exhaustion - 1 : 0,
    heroicInspiration:
        state.heroicInspiration ||
        sheet.resources.containsKey(heroicInspirationResource),
  );
}
