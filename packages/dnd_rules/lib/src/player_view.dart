// Vue du combat du joueur (US-36, EF-VJ-02 à 04) : ce que l'appareil du MJ
// publie, sans journal, ni Étude, ni PV ou CA des adversaires, ni
// adversaires masqués (EF-VJ-03, EF-ACT-07).
import 'dart:math';

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
          // Rounds restants, comme sur la puce du MJ.
          'rounds': ?switch (i.duration.rounds) {
            final rounds? => max(1, i.round + rounds - state.round),
            null => null,
          },
          'of': ?state.combatant(i.duration.combatant ?? '')?.label,
          'ability': ?i.duration.ability,
          'dc': ?i.duration.dc,
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

/// Événements à ajouter au journal pour la demande [id] du joueur de la
/// fiche [character] (US-36, EF-VJ-05, 06). La demande ne vise que son PJ :
/// - `damage` (`amount`, `type`), `heal` et `temp_hp` (`amount` > 0) ;
/// - `death_save` (`outcome`), s'il est à terre et instable ;
/// - `concentration_check` (`success`), si un test est en attente ;
/// - `concentration_started` (`spell`, son nom) et `concentration_ended`,
///   s'il est concentré ;
/// - `turn_advanced`, si c'est son tour.
///
/// Tout le reste, ou une demande dépassée par l'état du MJ, ne donne rien :
/// la version du MJ prime.
List<(CombatEventType, Map<String, Object?>)> requestEvents(
  CombatState state, {
  required String id,
  required String character,
  required String type,
  required Map<String, Object?> payload,
}) {
  final c = state.combatants
      .where((c) => c.kind == CombatantKind.pc && c.refId == character)
      .firstOrNull;
  if (c == null) return const [];
  final amount = switch (payload['amount']) {
    final int n when n > 0 => n,
    _ => null,
  };
  final spell = switch (payload['spell']) {
    final String s when s.isNotEmpty => s,
    _ => null,
  };
  final event = switch ((type, amount)) {
    ('damage', final amount?) => (
      CombatEventType.damage,
      {
        'targets': [c.id],
        'amount': amount,
        if (payload['type'] case final String t) 'type': t,
      },
    ),
    ('heal', final amount?) => (
      CombatEventType.heal,
      {
        'targets': [c.id],
        'amount': amount,
      },
    ),
    ('temp_hp', final amount?) => (
      CombatEventType.tempHp,
      {
        'targets': [c.id],
        'amount': amount,
      },
    ),
    ('death_save', _)
        when c.unconscious &&
            !c.stable &&
            !c.dead &&
            _deathOutcomes.contains(payload['outcome']) =>
      (
        CombatEventType.deathSave,
        {'combatant': c.id, 'outcome': payload['outcome']},
      ),
    ('concentration_check', _)
        when c.concentrationChecks.isNotEmpty && payload['success'] is bool =>
      (
        CombatEventType.concentrationCheck,
        {'combatant': c.id, 'success': payload['success']},
      ),
    ('concentration_started', _) when spell != null => (
      CombatEventType.concentrationStarted,
      {'combatant': c.id, 'spell': spell},
    ),
    ('concentration_ended', _) when c.concentration != null => (
      CombatEventType.concentrationEnded,
      {'combatant': c.id},
    ),
    ('turn_advanced', _) when state.active == c.unit => (
      CombatEventType.turnAdvanced,
      <String, Object?>{},
    ),
    _ => null,
  };
  if (event == null) return const [];
  return [
    (event.$1, {...event.$2, 'request': id}),
  ];
}

const _deathOutcomes = {'success', 'failure', 'nat1', 'nat20'};

/// Issue d'un jet contre la mort pour le d20 [d20] (SRD) : 1 compte deux
/// échecs, 20 rend 1 PV, 10 ou plus est une réussite.
String deathSaveOutcome(int d20) => switch (d20) {
  1 => 'nat1',
  20 => 'nat20',
  >= 10 => 'success',
  _ => 'failure',
};
