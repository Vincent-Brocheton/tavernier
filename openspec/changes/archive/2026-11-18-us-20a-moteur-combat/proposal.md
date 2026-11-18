# Proposal

## Why

Carte Trello [US-20](https://trello.com/c/unGA2o4Y), lot a : le moteur du combat (**EF-INI-01** à **07**, cahier §6.2). Le cahier (§10) pose que le combat est un **journal d'événements**, et que l'état se déduit du journal par projection, ce qui donne l'annulation et la fusion à la synchronisation. Ce lot écrit ce journal et sa projection dans `dnd_rules` : du Dart pur, testé contre la planche [C3]. Les données (lot b), le lancement (lot c) et l'écran de combat (lot d) suivent. Le découpage et le schéma sont validés par le porteur de projet.

## What Changes

- **Événements de combat** (liste fermée, `CombatEvent`) :
  - `combatant_added` et `combatant_removed` ;
  - `initiative_rolled` : dés gardés, dé écarté, bonus ;
  - `order_set` (ordre choisi par le MJ) ;
  - `combat_started`, `turn_advanced` ;
  - `counter_used` et `counter_restored` ;
  - `undo`.

  Un type inconnu rend l'événement invalide.
- **Projection** `projectCombat(events) → CombatState` : les combattants avec leur initiative, les unités du tour (un groupe à initiative commune joue ensemble), l'ordre, le round, l'unité active et les compteurs.
- **Initiative** :
  - jet d'un d20 avec Avantage ou Désavantage ;
  - la surprise donne le Désavantage, et Avantage et Désavantage s'annulent (SRD) ;
  - un groupe à initiative commune n'a qu'un jet.
- **Ordre par défaut** : total décroissant, puis bonus décroissant. C'est une commodité, pas une règle.
- **Égalités** (SRD, décision 25) : chaque égalité entre unités est signalée avec qui décide.
  - Entre monstres, ou entre un monstre et un PJ : le MJ.
  - Entre PJ seulement : leurs joueurs.

  `order_set` fixe l'ordre choisi.
- **Tours** :
  - `combat_started` ouvre le round 1 sur la première unité ;
  - `turn_advanced` passe à la suivante, et après la dernière au round suivant ;
  - au début du tour d'une unité, sa réaction et ses actions légendaires reviennent.
- **Ajout et retrait en cours de combat** : un combattant ajouté entre à sa place d'initiative. Le retrait du combattant actif passe le tour à l'unité suivante.
- **Compteurs par combattant** :
  - `reaction` ;
  - `legendary_actions`, rendues au début de son tour ;
  - `legendary_resistance`, par jour, jamais rendue pendant la rencontre ;
  - `recharge:<action>`, rendue par `counter_restored` après un d6 réussi.
- **Aides** :
  - `numberedLabels("Vétéran", 2)` donne « Vétéran 1 » et « Vétéran 2 » ;
  - `rollHitPoints(hitDice, random)` tire les PV pour le mode « Jet au lancement » ;
  - `rechargeSucceeds("5-6", roll)` dit si une recharge réussit.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `encounters` : journal et projection du combat, initiative, égalités, tours, compteurs.

## Impact

- `packages/dnd_rules/lib/src/combat.dart` (nouveau) et son export.
- `packages/dnd_rules/test/combat_test.dart` (nouveau), avec les valeurs de [C3].

**Hors périmètre :**
- **Stockage et synchronisation du journal** : lot b.
- **Écrans** : lots c et d.
- **Dégâts, soins, états, concentration** : US-21 à US-23. Les PV et la CA sont portés par `combatant_added`, sans règle de dégâts.
- **Jet saisi par le joueur depuis son téléphone** ([C5]) : US-36.
- **Échange d'initiative (Vigilant)** : US-37.
