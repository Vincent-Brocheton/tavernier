// Lancement d'une rencontre (US-20, EF-INI-01, EF-INI-02, [C3]) : ses
// combattants et les jets automatiques des monstres et des PNJ.
import 'dart:math';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';

/// Fiche calculée d'un personnage et ses PV courants ; `sheet` vaut `null`
/// si la fiche est illisible.
typedef SheetInfo = ({ComputedSheet? sheet, int? hp});

/// PJ présent : sa fiche, son nom, son joueur.
typedef LaunchPc = ({String id, String name, String? owner});

/// Nom du trait qui porte les résistances légendaires (SRD).
const _legendaryResistance = 'Résistance légendaire';

/// Événements du lancement : les PJ présents, puis chaque groupe numéroté,
/// et un jet automatique par unité de monstre ou de PNJ.
List<NewCombatEvent> launchEvents({
  required Encounter encounter,
  required ActiveContent content,
  required List<Npc> npcs,
  required List<LaunchPc> party,
  required Map<String, SheetInfo> sheets,
  required Random random,
}) {
  final added = <NewCombatEvent>[];
  final rolls = <NewCombatEvent>[];

  Map<String, Object?> fromSheet(
    String id,
    String kind,
    String label,
    String characterId, {
    String? owner,
    String? group,
  }) {
    final info = sheets[characterId];
    final sheet = info?.sheet;
    return {
      'id': id,
      'kind': kind,
      'ref_id': characterId,
      'label': label,
      'group_id': ?group,
      'owner': ?owner,
      'bonus': sheet?.initiative.value ?? 0,
      'advantage': sheet?.initiative.advantage ?? false,
      'ac': ?sheet?.armorClass.value,
      'hp': ?(info?.hp ?? sheet?.hitPointsMax.value),
      'hp_max': ?sheet?.hitPointsMax.value,
    };
  }

  for (final pc in party) {
    added.add((
      CombatEventType.combatantAdded,
      fromSheet(pc.id, 'pc', pc.name, pc.id, owner: pc.owner),
    ));
  }

  for (final group in encounter.groups) {
    final npc = group.kind == 'npc'
        ? npcs.where((n) => n.id == group.refId).firstOrNull
        : null;
    final monsterId = npc?.monsterId ?? (npc == null ? group.refId : null);
    final monster = switch (monsterId) {
      final id? => content.entity(id)?.data as MonsterData?,
      null => null,
    };
    final name = npc?.name ?? content.entity(group.refId)?.name;
    if (name == null || (monster == null && npc?.characterId == null)) {
      continue; // Adversaire introuvable : rien à lancer.
    }
    final kind = npc == null ? 'monster' : 'npc';
    final shared = group.sharedInitiative && group.quantity > 1;
    final labels = numberedLabels(name, group.quantity);
    for (final (index, label) in labels.indexed) {
      final id = '${group.id}:${index + 1}';
      final unitGroup = shared ? group.id : null;
      if (monster == null) {
        added.add((
          CombatEventType.combatantAdded,
          fromSheet(id, kind, label, npc!.characterId!, group: unitGroup),
        ));
      } else {
        final hp = encounter.hpMode == HpMode.roll
            ? rollHitPoints(monster.hitDice, random)
            : monster.hp;
        added.add((
          CombatEventType.combatantAdded,
          {
            'id': id,
            'kind': kind,
            'ref_id': group.refId,
            'label': label,
            'group_id': ?unitGroup,
            'bonus': monster.initiative,
            'ac': monster.ac,
            'hp': hp,
            'hp_max': hp,
            'counters': _countersOf(monster),
          },
        ));
      }
      // Un jet par unité : le groupe à initiative commune, ou chacun.
      if (!shared || index == 0) {
        final bonus =
            monster?.initiative ??
            sheets[npc?.characterId]?.sheet?.initiative.value ??
            0;
        final roll = rollInitiative(bonus, RollMode.normal, random);
        rolls.add((
          CombatEventType.initiativeRolled,
          {'unit': unitGroup ?? id, 'dice': roll.dice, 'bonus': bonus},
        ));
      }
    }
  }
  return [...added, ...rolls];
}

/// Compteurs d'un profil : actions légendaires, résistances légendaires et
/// capacités à recharge.
Map<String, int> _countersOf(MonsterData monster) => {
  legendaryActionsCounter: ?monster.legendaryUses,
  for (final action in monster.actions)
    if (action.name == _legendaryResistance && action.uses?.perDay != null)
      'legendary_resistance': action.uses!.perDay!
    else if (action.uses?.recharge != null)
      'recharge:${action.name}': 1,
};
