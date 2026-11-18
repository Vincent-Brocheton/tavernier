# Proposal

## Why

Carte Trello [US-22](https://trello.com/c/xfAQDteE), lot a : le moteur des états en combat (**EF-CON-01** à **03**, cahier §6.3, SRD « États »). Le journal (US-20, US-21) porte les combattants, leurs PV et leurs tours. Ce lot y ajoute les états, leurs durées, leur expiration et les rappels de tour. L'écran suit aux lots b (ajout d'un état [C5], puces, fiche d'état [K4]) et c (rappels [C6] et bandeau de début de tour [1a]).

## What Changes

- **Nouveaux événements** :
  - `condition_added` : porteur, identifiant de l'instance, état (`srd:condition:…`) ou libellé libre (« Autre effet »), durée, niveaux d'Épuisement, dégâts récurrents facultatifs ;
  - `condition_removed` : l'instance, ou des niveaux d'Épuisement ;
  - `condition_save` : réussite ou échec de la sauvegarde à refaire. Une réussite retire l'état.
- **Durées** (EF-CON-02) :
  - un nombre de rounds ;
  - jusqu'au début ou jusqu'à la fin du tour d'un combattant ;
  - jusqu'à réussite d'une sauvegarde (DD et caractéristique), à refaire à la fin de chacun des tours du porteur ;
  - indéfinie.
- **Expiration** : calculée par la projection quand les tours passent, donc annulable avec « Annuler ».
- **SRD** :
  - un état ne se cumule pas avec lui-même : chaque source garde sa propre instance et sa durée ;
  - l'Épuisement gagne un niveau à chaque fois, jusqu'à 6 ;
  - un combattant immunisé contre un état ne le reçoit pas.
- **Rappels** (EF-CON-03) : `turnReminders` donne, pour le début ou la fin du tour actif :
  - les états qui expirent ou viennent d'expirer ;
  - les sauvegardes à refaire, avec le bonus du porteur ;
  - les dégâts récurrents.
- **Lancement et renforts** : les bonus de sauvegarde (du profil ou de la fiche) et les immunités d'état d'un monstre passent dans `combatant_added`.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `encounters` : états, durées, expiration et rappels de tour.

## Impact

- `packages/dnd_rules/lib/src/combat.dart` et ses tests.
- `apps/game_table/lib/encounters/launch.dart` (sauvegardes, immunités d'état) et son test.
- Aucune migration : le type d'un événement est un texte libre côté serveur.

**Hors périmètre :**
- **Écrans** : lots b et c.
- **Effets mécaniques de l'Épuisement** et mort au niveau 6 (EF-CON-07) : US-37.
- **Lien avec un sort de concentration** et retrait des effets liés : US-23.
- **Sauvegarde au début du tour** : le SRD et [C5] la placent à la fin du tour ; un MJ qui en a besoin la retire à la main.
