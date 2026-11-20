# Proposal

## Why

Carte Trello [US-25](https://trello.com/c/GhAzwSV1) : le journal de combat, l'annulation et la fin de rencontre. Exigences : **EF-LOG-01** à **EF-LOG-03** ; cahier §6.2 ; planches Combat-Desktop (panneau Journal), [TB1] (journal en onglet) et [C11] (résumé de fin).

Depuis US-20 :
- chaque action de combat est un événement daté du journal (EF-LOG-01) ;
- l'annulation remonte le journal événement par événement, sans limite, ce qui couvre les 20 annulations minimum (EF-LOG-02) ;
- « Terminer la rencontre » existe, mais sans résumé.

Il manque :
- un journal lisible par le MJ ;
- le résumé de fin, conservé dans la séance (EF-LOG-03).

La carte est livrée en deux lots, chacun avec sa PR, dans ce change.

## What Changes

### Lot a : journal lisible

- **Moteur** : `combatJournal(events)` rend chaque événement dans l'ordre, avec :
  - son round ;
  - son état (annulé ou non) ;
  - pour les dégâts et les soins, les PV avant et après de chaque cible, et sa chute éventuelle (0 PV, hors de combat, mort).
- **Données** : le journal lu avec la date d'écriture de chaque événement.
- **Écran** : une icône « Journal » dans la barre du combat ouvre le journal, du plus récent au plus ancien. Chaque ligne porte une phrase et « R3 · 21:42 ». On y trouve :
  - les filtres Tout, PV, États et Étude ;
  - « n actions annulables » ;
  - les événements annulés, barrés.

### Lot b : résumé de fin ([C11], EF-LOG-03)

- « Terminer la rencontre » ouvre le résumé :
  - les rounds, les PX au total et les adversaires tombés ;
  - les PX gagnés par PJ, modifiables avant de clore ;
  - les combattants tombés, avec leur round ;
  - les moments notés : Étude, Influence, Observation, concentration perdue.
- « Clore et ranger dans la séance » écrit un événement `encounter_finished` (rounds, PX par PJ), puis termine la rencontre. Le résumé reste lisible ensuite depuis la rencontre.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `encounters` : journal lisible, résumé de fin.

## Impact

- **`dnd_rules`** : `combat.dart`, avec `combatJournal`, puis le résumé au lot b.
- **`dnd_data`** : `CombatStore.watchLog`.
- **App** : `encounters/` (nouveaux `combat_journal.dart`, puis `encounter_summary.dart`) et l'ARB.
- **Données** : pas de changement de schéma. Le résumé est la projection du journal, et les PX retenus vont dans l'événement de clôture.

## Hors périmètre

- **Attribution des PX aux fiches** : elle se fait à la clôture de la séance, au lot d de US-35, qui lira `encounter_finished`.
- **Mentions « a fui » et « capturée »** de [C11] : le journal n'a pas d'événement pour la fuite ou la capture.
- **« Garder comme PNJ » et « Repos du groupe »** : ils relèvent de US-18 et de US-38.
- **Auteur des dégâts** (« Chef de bande → Mira ») : le pavé ne connaît pas l'attaquant.
- **Journal en onglet sur tablette** ([TB1]) : il s'ouvre en feuille sur toutes les largeurs au MVP.
