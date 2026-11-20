// Vue du combat du joueur (US-36, EF-VJ-02 à 04) : ce que l'appareil du MJ
// publie, sans journal, ni Étude, ni PV ou CA des adversaires, ni
// adversaires masqués (EF-VJ-03, EF-ACT-07).
import 'combat.dart';

/// État de santé qualitatif d'un PJ (EF-TAB-09), et sa chute.
String _health(Combatant c) {
  final (hp, max) = (c.hp, c.hpMax);
  if (c.dead) return 'dead';
  if (hp == null || max == null || max <= 0) return 'unhurt';
  if (hp == 0) return 'down';
  return hp >= max
      ? 'unhurt'
      : hp * 2 > max
      ? 'wounded'
      : 'badly';
}

/// Vue filtrée de [state], en JSON :
/// - `round` et `active` (l'unité dont c'est le tour) ;
/// - `order` : les combattants visibles dans l'ordre du tour, un adversaire
///   sous son seul nom, un PJ avec sa santé qualitative ;
/// - `pcs` : pour chaque PJ (par sa fiche), PV, PV temporaires, états,
///   concentration, réaction, jets contre la mort et tests en attente.
Map<String, Object?> playerCombatView(CombatState state) {
  Map<String, Object?> pc(Combatant c) => {
    'combatant': c.id,
    'label': c.label,
    'hp': c.hp,
    'hp_max': c.hpMax,
    'temp_hp': c.tempHp,
    'conditions': [
      for (final i in c.conditions)
        {
          'instance': i.id,
          'condition': ?i.condition,
          'label': ?i.label,
          'levels': i.levels,
          'duration': i.duration.kind.code,
          'rounds': ?i.duration.rounds,
          'concentration': ?switch (i.concentration) {
            final caster? => state.combatant(caster)?.label,
            null => null,
          },
        },
    ],
    'concentration': c.concentration,
    'reaction': c.remaining(reactionCounter) > 0,
    if (c.unconscious || c.dead)
      'death': {
        'successes': c.deathSuccesses,
        'failures': c.deathFailures,
        'stable': c.stable,
        'dead': c.dead,
      },
    'checks': [
      for (final check in c.concentrationChecks)
        {'dc': check.dc, 'damage': check.damage},
    ],
  };

  return {
    'round': state.round,
    'active': state.active,
    'order': [
      for (final unit in state.order)
        for (final c in state.members(unit))
          if (c.kind == CombatantKind.pc)
            {
              'id': c.id,
              'unit': unit,
              'label': c.label,
              'kind': 'pc',
              'character': c.refId,
              'owner': c.owner,
              'health': _health(c),
              'active': unit == state.active,
            }
          else if (!c.hidden)
            {
              'id': c.id,
              'unit': unit,
              'label': c.label,
              'kind': 'foe',
              'active': unit == state.active,
            },
    ],
    'pcs': {
      for (final c in state.combatants)
        if (c.kind == CombatantKind.pc) c.refId ?? c.id: pc(c),
    },
  };
}

/// Tours avant celui du PJ [character] dans [view] : 0 si c'est le sien,
/// `null` s'il n'y est pas ou si le combat n'a pas commencé.
int? turnsUntil(Map<String, Object?> view, String character) {
  final order = [
    for (final o in (view['order'] as List?) ?? const [])
      o as Map<String, Object?>,
  ];
  // Un tour par unité : les membres d'un groupe jouent ensemble.
  final units = <Object?>{for (final o in order) o['unit']}.toList();
  final mine = order.where((o) => o['character'] == character).firstOrNull;
  final active = units.indexOf(view['active']);
  if (mine == null || active < 0) return null;
  return (units.indexOf(mine['unit']) - active) % units.length;
}
