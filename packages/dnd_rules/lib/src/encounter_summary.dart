// Résumé de fin de rencontre (US-25, EF-LOG-03, [C11]) : la projection du
// journal, sans rien stocker de plus.
import 'combat.dart';

/// Combattant tombé : le round de sa chute et son état à la fin.
typedef FallenCombatant = ({
  String id,
  String label,
  int round,
  bool knockedOut,
  bool dead,
  bool stable,
});

/// Résumé d'une rencontre.
final class EncounterSummary {
  const EncounterSummary._({
    required this.rounds,
    required this.pcs,
    required this.foes,
    required this.fallen,
    required this.downedPcs,
    required this.xpTotal,
    required this.moments,
    required this.awarded,
  });

  final int rounds;

  /// PJ présents à la fin.
  final List<Combatant> pcs;

  /// Adversaires présents à la fin.
  final int foes;

  /// Adversaires tombés (hors de combat, morts ou assommés).
  final List<FallenCombatant> fallen;

  /// PJ tombés à 0 PV pendant la rencontre.
  final List<FallenCombatant> downedPcs;

  /// PX des adversaires encore dans le combat à la fin ([D1]).
  final int xpTotal;

  /// Étude, Influence, Observation, concentration perdue.
  final List<JournalEntry> moments;

  /// PX par PJ retenus à la clôture ; `null` avant.
  final Map<String, int>? awarded;

  /// Part de chaque PJ par défaut : le total divisé par le nombre de PJ.
  int get xpShare => pcs.isEmpty ? 0 : xpTotal ~/ pcs.length;
}

/// Résume [events] ; [xpOf] donne les PX d'un adversaire (son profil).
EncounterSummary summarizeEncounter(
  Iterable<CombatEvent> events, {
  required int Function(Combatant) xpOf,
}) {
  final list = events.toList();
  final state = projectCombat(list);
  final journal = combatJournal(list);

  // Round de la première chute de chaque combattant : à 0 PV, ou à 1 PV
  // par Assommer.
  final fellAt = <String, int>{};
  for (final entry in journal) {
    if (entry.undone || entry.event.type != CombatEventType.damage) continue;
    final knockOut = entry.event.payload['knock_out'] == true;
    for (final MapEntry(key: id, value: h) in entry.hp.entries) {
      final before = h.before ?? 0;
      final fell = before > 0 && (h.after == 0 || (knockOut && h.after == 1));
      if (fell) fellAt.putIfAbsent(id, () => entry.round);
    }
  }

  FallenCombatant fallen(Combatant c) => (
    id: c.id,
    label: c.label,
    round: fellAt[c.id] ?? state.round,
    knockedOut: c.conditions.any((i) => i.knockedOut),
    dead: c.dead,
    stable: c.stable,
  );

  final foes = [
    for (final c in state.combatants)
      if (c.kind != CombatantKind.pc) c,
  ];
  final finished = list.lastWhere(
    (e) => e.type == CombatEventType.encounterFinished,
    orElse: () => const CombatEvent(id: '', type: CombatEventType.undo),
  );
  return EncounterSummary._(
    rounds: state.round,
    pcs: [
      for (final c in state.combatants)
        if (c.kind == CombatantKind.pc) c,
    ],
    foes: foes.length,
    fallen: [
      for (final c in foes)
        if (c.outOfCombat || c.dead || c.conditions.any((i) => i.knockedOut))
          fallen(c),
    ]..sort((a, b) => a.round.compareTo(b.round)),
    downedPcs: [
      for (final c in state.combatants)
        if (c.kind == CombatantKind.pc && fellAt.containsKey(c.id)) fallen(c),
    ],
    xpTotal: foes.fold(0, (sum, c) => sum + xpOf(c)),
    moments: [
      for (final entry in journal)
        if (!entry.undone &&
            switch (entry.event.type) {
              CombatEventType.study ||
              CombatEventType.influence ||
              CombatEventType.observation ||
              CombatEventType.concentrationEnded => true,
              CombatEventType.concentrationCheck =>
                entry.event.payload['success'] != true,
              _ => false,
            })
          entry,
    ],
    awarded: switch (finished.payload['xp']) {
      final Map<Object?, Object?> xp => {
        for (final MapEntry(:key, :value) in xp.entries) '$key': value! as int,
      },
      _ => null,
    },
  );
}

/// PX d'une séance par fiche (EF-SEA-03) : la somme des PX accordés à la
/// clôture de chaque rencontre jouée, déjà partagés entre ses présents. Un
/// absent de toutes les rencontres n'y figure pas.
Map<String, int> sessionXp(Iterable<Map<String, int>?> awarded) {
  final total = <String, int>{};
  for (final xp in awarded) {
    for (final MapEntry(:key, :value) in (xp ?? const {}).entries) {
      total[key] = (total[key] ?? 0) + value;
    }
  }
  return total;
}
