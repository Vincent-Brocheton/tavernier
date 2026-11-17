import 'dart:math';

import 'dice.dart';

/// Types d'événements du journal de combat (cahier §10) : liste fermée.
enum CombatEventType {
  combatantAdded('combatant_added'),
  combatantRemoved('combatant_removed'),
  initiativeRolled('initiative_rolled'),
  orderSet('order_set'),
  combatStarted('combat_started'),
  turnAdvanced('turn_advanced'),
  counterUsed('counter_used'),
  counterRestored('counter_restored'),
  undo('undo');

  const CombatEventType(this.code);

  final String code;

  static final _byCode = {for (final t in values) t.code: t};

  /// Le type de [code] ; une [FormatException] s'il est inconnu.
  static CombatEventType parse(String code) =>
      _byCode[code] ?? (throw FormatException('événement inconnu : $code'));
}

/// Événement du journal : son identifiant (UUID v7, dans l'ordre du
/// journal), son type et ses données.
final class CombatEvent {
  const CombatEvent({
    required this.id,
    required this.type,
    this.payload = const {},
  });

  factory CombatEvent.fromJson(Map<String, Object?> json) => CombatEvent(
    id: json['id']! as String,
    type: CombatEventType.parse(json['type']! as String),
    payload: Map<String, Object?>.from(
      (json['payload'] ?? const <String, Object?>{}) as Map,
    ),
  );

  final String id;
  final CombatEventType type;
  final Map<String, Object?> payload;

  Map<String, Object?> toJson() => {
    'id': id,
    'type': type.code,
    'payload': payload,
  };
}

/// Sorte de combattant.
enum CombatantKind { pc, monster, npc }

/// Jet d'initiative : d20 gardé, d20 écarté (Avantage, Désavantage), bonus.
final class InitiativeRoll {
  const InitiativeRoll({required this.dice, required this.bonus, this.dropped});

  final List<int> dice;
  final int? dropped;
  final int bonus;

  int get total => dice.fold(bonus, (sum, d) => sum + d);
}

/// Réaction : compteur implicite, une par round.
const reactionCounter = 'reaction';

/// Actions légendaires : rendues au début du tour du combattant.
const legendaryActionsCounter = 'legendary_actions';

/// Combattant et ses compteurs, tels que le journal les a laissés.
final class Combatant {
  Combatant._({
    required this.id,
    required this.kind,
    required this.refId,
    required this.label,
    required this.bonus,
    required Map<String, int> counters,
    this.groupId,
    this.owner,
    this.ac,
    this.hp,
    this.hpMax,
  }) : _max = {reactionCounter: 1, ...counters};

  factory Combatant._fromPayload(Map<String, Object?> p) => Combatant._(
    id: p['id']! as String,
    kind: CombatantKind.values.byName(p['kind']! as String),
    refId: p['ref_id'] as String?,
    label: p['label']! as String,
    groupId: p['group_id'] as String?,
    owner: p['owner'] as String?,
    bonus: (p['bonus'] as int?) ?? 0,
    ac: p['ac'] as int?,
    hp: p['hp'] as int?,
    hpMax: p['hp_max'] as int?,
    counters: {
      for (final MapEntry(:key, :value)
          in ((p['counters'] ?? const <String, Object?>{}) as Map).entries)
        '$key': value as int,
    },
  );

  final String id;
  final CombatantKind kind;
  final String? refId;
  final String label;

  /// Groupe à initiative commune ; `null` : le combattant joue seul.
  final String? groupId;

  /// Joueur d'un PJ.
  final String? owner;
  final int bonus;
  final int? ac;
  final int? hp;
  final int? hpMax;

  final Map<String, int> _max;
  final Map<String, int> _used = {};

  InitiativeRoll? initiative;

  /// Unité du tour : le groupe, ou le combattant seul.
  String get unit => groupId ?? id;

  int max(String counter) => _max[counter] ?? 0;

  int remaining(String counter) => max(counter) - (_used[counter] ?? 0);

  void _use(String counter, int amount) =>
      _used[counter] = min(max(counter), (_used[counter] ?? 0) + amount);

  void _restore(String counter) => _used.remove(counter);
}

/// Égalité d'initiative entre unités (SRD, décision 25) : le MJ décide entre
/// monstres et entre un monstre et un PJ ; les joueurs entre leurs PJ.
final class InitiativeTie {
  const InitiativeTie(this.total, this.units, {required this.players});

  final int total;
  final List<String> units;

  /// Joueurs qui décident ; vide : le MJ.
  final Set<String> players;

  bool get gmDecides => players.isEmpty;
}

/// État d'un combat : la projection de son journal.
final class CombatState {
  CombatState._(
    this._combatants,
    this.order,
    this.round,
    this.active,
    this.ties,
  );

  final List<Combatant> _combatants;

  /// Combattants présents, dans l'ordre d'ajout.
  List<Combatant> get combatants => List.unmodifiable(_combatants);

  /// Unités du tour, dans l'ordre d'initiative.
  final List<String> order;

  /// 0 avant le début du combat.
  final int round;

  /// Unité dont c'est le tour.
  final String? active;

  /// Égalités encore à trancher : l'ordre par défaut est proposé.
  final List<InitiativeTie> ties;

  Combatant? combatant(String id) =>
      _combatants.where((c) => c.id == id).firstOrNull;

  /// Membres d'une unité, dans l'ordre d'ajout.
  List<Combatant> members(String unit) => [
    for (final c in _combatants)
      if (c.unit == unit) c,
  ];
}

/// Projette le journal [events] : les annulations d'abord, puis les autres
/// événements dans l'ordre.
CombatState projectCombat(Iterable<CombatEvent> events) {
  final list = events.toList();
  // Une annulation annulée ne compte plus : du plus récent au plus ancien.
  final undone = <String>{};
  for (final e in list.reversed) {
    if (e.type == CombatEventType.undo && !undone.contains(e.id)) {
      undone.add(e.payload['event']! as String);
    }
  }
  final combatants = <Combatant>[];
  final rolls = <String, InitiativeRoll>{};
  List<String>? chosen;
  var rolledAfterChoice = false;
  var round = 0;
  String? active;

  Combatant? find(String id) => combatants.where((c) => c.id == id).firstOrNull;
  List<String> currentOrder() => _order(combatants, rolls, chosen);
  void startTurn(String? unit) {
    active = unit;
    for (final c in combatants) {
      if (c.unit == unit) {
        c
          .._restore(reactionCounter)
          .._restore(legendaryActionsCounter);
      }
    }
  }

  /// Passe à l'unité suivante de [order], au round suivant après la
  /// dernière.
  void advance(List<String> order, String? from) {
    if (order.isEmpty) return startTurn(null);
    final index = from == null ? -1 : order.indexOf(from);
    if (index + 1 >= order.length) {
      round++;
      startTurn(order.first);
    } else {
      startTurn(order[index + 1]);
    }
  }

  for (final e in list) {
    if (undone.contains(e.id) || e.type == CombatEventType.undo) continue;
    final p = e.payload;
    switch (e.type) {
      case CombatEventType.combatantAdded:
        final c = Combatant._fromPayload(p);
        c.initiative = rolls[c.unit];
        combatants.add(c);
      case CombatEventType.combatantRemoved:
        final c = find(p['combatant']! as String);
        if (c == null) break;
        final order = currentOrder();
        final alone = combatants.where((o) => o.unit == c.unit).length == 1;
        if (alone && active == c.unit) {
          final next = order.indexOf(c.unit) + 1;
          combatants.remove(c);
          if (next >= order.length) {
            round++;
            startTurn(currentOrder().firstOrNull);
          } else {
            startTurn(order[next]);
          }
        } else {
          combatants.remove(c);
        }
      case CombatEventType.initiativeRolled:
        final roll = InitiativeRoll(
          dice: [for (final d in p['dice']! as List) d as int],
          dropped: p['dropped'] as int?,
          bonus: (p['bonus'] as int?) ?? 0,
        );
        final unit = p['unit']! as String;
        rolls[unit] = roll;
        for (final c in combatants) {
          if (c.unit == unit) c.initiative = roll;
        }
        if (chosen != null) rolledAfterChoice = true;
      case CombatEventType.orderSet:
        chosen = [for (final u in p['order']! as List) u as String];
        rolledAfterChoice = false;
      case CombatEventType.combatStarted:
        round = 1;
        startTurn(currentOrder().firstOrNull);
      case CombatEventType.turnAdvanced:
        advance(currentOrder(), active);
      case CombatEventType.counterUsed:
        find(p['combatant']! as String)
            ?._use(p['counter']! as String, (p['amount'] as int?) ?? 1);
      case CombatEventType.counterRestored:
        find(p['combatant']! as String)?._restore(p['counter']! as String);
      case CombatEventType.undo:
        break;
    }
  }
  final order = currentOrder();
  return CombatState._(
    combatants,
    order,
    round,
    active,
    chosen == null || rolledAfterChoice ? _ties(combatants, order, rolls) : [],
  );
}

/// Ordre des unités : celui choisi par le MJ, les autres insérées selon
/// l'ordre par défaut (total, puis bonus, puis ajout) ; sans jet, à la fin.
List<String> _order(
  List<Combatant> combatants,
  Map<String, InitiativeRoll> rolls,
  List<String>? chosen,
) {
  final units = <String, Combatant>{};
  for (final c in combatants) {
    units.putIfAbsent(c.unit, () => c);
  }
  final keys = units.keys.toList();
  int compare(String a, String b) {
    final ra = rolls[a];
    final rb = rolls[b];
    if (ra == null || rb == null) {
      if (ra == rb) return keys.indexOf(a).compareTo(keys.indexOf(b));
      return ra == null ? 1 : -1;
    }
    final byTotal = rb.total.compareTo(ra.total);
    if (byTotal != 0) return byTotal;
    final byBonus = units[b]!.bonus.compareTo(units[a]!.bonus);
    if (byBonus != 0) return byBonus;
    return keys.indexOf(a).compareTo(keys.indexOf(b));
  }

  final defaultOrder = [...keys]..sort(compare);
  if (chosen == null) return defaultOrder;
  final order = [
    for (final u in chosen)
      if (units.containsKey(u)) u,
  ];
  for (final u in defaultOrder) {
    if (order.contains(u)) continue;
    final at = order.indexWhere((o) => compare(u, o) < 0);
    order.insert(at < 0 ? order.length : at, u);
  }
  return order;
}

/// Égalités entre unités de même total, dans l'ordre proposé.
List<InitiativeTie> _ties(
  List<Combatant> combatants,
  List<String> order,
  Map<String, InitiativeRoll> rolls,
) {
  final byTotal = <int, List<String>>{};
  for (final unit in order) {
    if (rolls[unit] case final roll?) {
      (byTotal[roll.total] ??= []).add(unit);
    }
  }
  return [
    for (final MapEntry(key: total, value: units) in byTotal.entries)
      if (units.length > 1)
        InitiativeTie(
          total,
          units,
          players: () {
            final members = [
              for (final c in combatants)
                if (units.contains(c.unit)) c,
            ];
            return members.every((c) => c.kind == CombatantKind.pc)
                ? {for (final c in members) ?c.owner}
                : <String>{};
          }(),
        ),
  ];
}

/// Mode du jet d'initiative : la surprise donne le Désavantage ; Avantage et
/// Désavantage s'annulent (SRD).
RollMode combineRollModes({
  bool advantage = false,
  bool disadvantage = false,
  bool surprised = false,
}) {
  final down = disadvantage || surprised;
  return advantage == down
      ? RollMode.normal
      : advantage
      ? RollMode.advantage
      : RollMode.disadvantage;
}

/// Jet d'initiative : un d20 (deux avec Avantage ou Désavantage) + [bonus].
InitiativeRoll rollInitiative(int bonus, RollMode mode, Random random) {
  final roll = rollDice(DiceFormula(1, 20, mode: mode), random);
  return InitiativeRoll(dice: roll.dice, dropped: roll.dropped, bonus: bonus);
}

/// « Vétéran 1 », « Vétéran 2 » ; un seul exemplaire garde son nom.
List<String> numberedLabels(String name, int quantity) =>
    quantity == 1 ? [name] : [for (var i = 1; i <= quantity; i++) '$name $i'];

/// PV tirés d'après les dés de vie (« 8d8 + 16 »), au moins 1.
int rollHitPoints(String hitDice, Random random) =>
    max(1, rollDice(DiceFormula.parse(hitDice), random).total);

/// Le d6 de recharge [roll] rend-il une capacité « 5-6 » ou « 6 » ?
bool rechargeSucceeds(String range, int roll) {
  final bounds = range.split(RegExp('[-–]'));
  return roll >= int.parse(bounds.first) && roll <= int.parse(bounds.last);
}
