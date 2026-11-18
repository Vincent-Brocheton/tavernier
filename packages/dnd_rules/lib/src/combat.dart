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
  damage('damage'),
  heal('heal'),
  tempHp('temp_hp'),
  deathSave('death_save'),
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
  const InitiativeRoll({
    required this.dice,
    required this.bonus,
    this.dropped,
    this.mode = RollMode.normal,
    this.surprised = false,
  });

  final List<int> dice;
  final int? dropped;
  final int bonus;

  /// Avantage ou Désavantage du jet.
  final RollMode mode;

  /// Combattant surpris (Désavantage, SRD).
  final bool surprised;

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
    this.advantage = false,
    this.groupId,
    this.owner,
    this.ac,
    this.hp,
    this.hpMax,
    this.resistances = const {},
    this.vulnerabilities = const {},
    this.immunities = const {},
  }) : _max = {reactionCounter: 1, ...counters};

  factory Combatant._fromPayload(Map<String, Object?> p) => Combatant._(
    id: p['id']! as String,
    kind: CombatantKind.values.byName(p['kind']! as String),
    refId: p['ref_id'] as String?,
    label: p['label']! as String,
    groupId: p['group_id'] as String?,
    owner: p['owner'] as String?,
    bonus: (p['bonus'] as int?) ?? 0,
    advantage: (p['advantage'] as bool?) ?? false,
    ac: p['ac'] as int?,
    hp: p['hp'] as int?,
    hpMax: p['hp_max'] as int?,
    resistances: _ids(p['resistances']),
    vulnerabilities: _ids(p['vulnerabilities']),
    immunities: _ids(p['immunities']),
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

  /// Avantage au jet d'initiative (don, aptitude).
  final bool advantage;
  final int? ac;

  /// PV courants ; `null` si inconnus (fiche illisible).
  int? hp;
  final int? hpMax;
  int tempHp = 0;

  /// Types de dégâts (`srd:damage-type:…`) de son profil.
  final Set<String> resistances;
  final Set<String> vulnerabilities;
  final Set<String> immunities;

  /// Jets contre la mort d'un PJ à 0 PV.
  int deathSuccesses = 0;
  int deathFailures = 0;
  bool stable = false;
  bool dead = false;

  /// PJ à 0 PV, vivant : Inconscient.
  bool get unconscious => kind == CombatantKind.pc && hp == 0 && !dead;

  /// Monstre ou PNJ à 0 PV : hors de combat, gardé dans l'ordre.
  bool get outOfCombat => kind != CombatantKind.pc && hp == 0;

  void _resetDeathSaves() {
    deathSuccesses = 0;
    deathFailures = 0;
    stable = false;
  }

  void _fail(int count) {
    deathFailures = min(3, deathFailures + count);
    stable = false;
    if (deathFailures >= 3) dead = true;
  }

  void _takeDamage(
    int amount,
    String type, {
    required bool critical,
    required bool half,
    required bool double,
  }) {
    if (hp == null || dead) return;
    final wasDown = hp == 0;
    final result = resolveDamage(
      this,
      amount,
      type,
      half: half,
      double: double,
    );
    tempHp = result.tempAfter;
    hp = result.hpAfter;
    // Dégâts subis à 0 PV : un échec, deux sur un coup critique.
    if (kind == CombatantKind.pc && wasDown && result.taken > 0) {
      _fail(critical ? 2 : 1);
    } else if (kind == CombatantKind.pc && !wasDown && hp == 0) {
      _resetDeathSaves();
    }
  }

  void _heal(int amount) {
    if (hp == null || dead) return;
    final wasDown = hp == 0;
    hp = min(hpMax ?? hp! + amount, hp! + amount);
    if (wasDown && hp! > 0) _resetDeathSaves();
  }

  void _deathSave(String outcome) {
    if (!unconscious || stable) return;
    switch (outcome) {
      case 'success':
        deathSuccesses++;
        if (deathSuccesses >= 3) stable = true;
      case 'failure':
        _fail(1);
      case 'nat1':
        _fail(2);
      case 'nat20':
        hp = 1;
        _resetDeathSaves();
    }
  }

  final Map<String, int> _max;
  final Map<String, int> _used = {};

  InitiativeRoll? initiative;

  /// Unité du tour : le groupe, ou le combattant seul.
  String get unit => groupId ?? id;

  /// Compteurs suivis, la réaction d'abord.
  Iterable<String> get counters => _max.keys;

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
  final undone = _undone(list);
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
          mode: RollMode.values.asNameMap()[p['mode']] ?? RollMode.normal,
          surprised: (p['surprised'] as bool?) ?? false,
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
      case CombatEventType.damage:
        for (final id in p['targets']! as List) {
          find(id as String)?._takeDamage(
            p['amount']! as int,
            (p['type'] as String?) ?? '',
            critical: (p['critical'] as bool?) ?? false,
            half: (p['half'] as bool?) ?? false,
            double: (p['double'] as bool?) ?? false,
          );
        }
      case CombatEventType.heal:
        for (final id in p['targets']! as List) {
          find(id as String)?._heal(p['amount']! as int);
        }
      case CombatEventType.tempHp:
        for (final id in p['targets']! as List) {
          final c = find(id as String);
          if (c == null) continue;
          final amount = p['amount']! as int;
          c.tempHp = (p['replace'] as bool?) ?? false
              ? amount
              : max(c.tempHp, amount);
        }
      case CombatEventType.deathSave:
        find(p['combatant']! as String)?._deathSave(p['outcome']! as String);
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

/// Événements annulés : une annulation annulée ne compte plus, d'où le
/// parcours du plus récent au plus ancien.
Set<String> _undone(List<CombatEvent> events) {
  final undone = <String>{};
  for (final e in events.reversed) {
    if (e.type == CombatEventType.undo && !undone.contains(e.id)) {
      undone.add(e.payload['event']! as String);
    }
  }
  return undone;
}

/// Dernier événement encore effectif (ni annulation, ni annulé), que
/// « Annuler » vise ; `null` s'il n'y en a pas.
String? lastUndoable(Iterable<CombatEvent> events) {
  final list = events.toList();
  final undone = _undone(list);
  return list.reversed
      .where((e) => e.type != CombatEventType.undo && !undone.contains(e.id))
      .firstOrNull
      ?.id;
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

Set<String> _ids(Object? json) => {
  for (final id in (json ?? const <Object?>[]) as List) id as String,
};

/// Dégâts subis par une cible, et ses PV avant et après.
typedef DamageResult = ({
  int taken,
  int hpBefore,
  int hpAfter,
  int tempBefore,
  int tempAfter,
});

/// Dégâts de [type] sur [target] (SRD) : l'Immunité les annule ; la
/// Résistance (du profil ou [half]) les divise par deux, arrondi à
/// l'inférieur, puis la Vulnérabilité (du profil ou [double]) les double.
/// Les PV temporaires sont consommés d'abord ; les PV restent ≥ 0. Rien
/// n'est écrit : sert aussi d'aperçu.
DamageResult resolveDamage(
  Combatant target,
  int amount,
  String type, {
  bool half = false,
  bool double = false,
}) {
  var taken = amount;
  if (target.immunities.contains(type)) {
    taken = 0;
  } else {
    if (half || target.resistances.contains(type)) taken ~/= 2;
    if (double || target.vulnerabilities.contains(type)) taken *= 2;
  }
  final hp = target.hp ?? 0;
  final absorbed = min(target.tempHp, taken);
  return (
    taken: taken,
    hpBefore: hp,
    hpAfter: max(0, hp - (taken - absorbed)),
    tempBefore: target.tempHp,
    tempAfter: target.tempHp - absorbed,
  );
}
