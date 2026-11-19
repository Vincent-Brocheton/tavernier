# Proposal

## Why

Carte Trello [US-37](https://trello.com/c/j8Ft0C81) : automatismes de combat. Exigences : **EF-PV-05**, **EF-PV-06**, **EF-CON-06**, **EF-CON-07**, **EF-INI-08** et **EF-INI-09** ; cahier §6.2 et §6.3 ; planches [F2a], [F2b], [F2c], [F3a], [F3b] et [C3].

Une partie d'EF-PV-05 existe depuis US-21 : Inconscient à 0 PV, jets contre la mort, échec à chaque dégât subi, soin qui relève. Il manque :
- les dégâts massifs ;
- Assommer ;
- le Soutien ;
- la fin automatique de la concentration ;
- l'épuisement appliqué aux valeurs ;
- la réaction des PJ ;
- Vigilant.

La carte touche trois écrans : le pavé de dégâts, la fiche de personnage et le lancement de l'initiative. Elle est donc livrée en trois lots, chacun avec sa PR. Ce change les porte tous et est archivé après le dernier.

## What Changes

### Lot a : 0 PV et concentration

- **Mort sur le coup** (EF-PV-05, SRD « Dégâts massifs ») :
  - un PJ meurt sur le coup quand l'excédent de dégâts au-delà de 0 PV est au moins égal à ses PV max ;
  - à 0 PV, des dégâts au moins égaux à ses PV max le tuent ;
  - l'aperçu du pavé l'annonce avant validation ([F2a]).
- **Assommer** (EF-PV-06, [F2b], SRD « Assommer une créature ») :
  - quand une cible unique tomberait à 0 PV, le pavé propose « Assommer », pour une attaque de corps à corps ;
  - la cible reste à 1 PV, avec l'état Inconscient ;
  - le moindre soin lui retire cet état.
- **Soutien** ([F2c]) : un PJ à 0 PV stabilisé par un allié (Sagesse (Médecine) DD 10) est Stabilisé.
- **Fin automatique de la concentration** (EF-CON-06) :
  - la concentration d'un combattant prend fin quand il tombe à 0 PV ou meurt, ou reçoit l'état Neutralisé ou un état qui l'inclut (Inconscient, Paralysé, Pétrifié, Étourdi) ;
  - ses effets liés sont retirés ;
  - la confirmation se fait avant d'écrire : l'aperçu du pavé et la pose d'état ([C5]) nomment le sort et les effets retirés ;
  - l'annulation du journal reste possible.

### Lot b : Épuisement (EF-CON-07, [F3a], [F3b])

- Chaque niveau retire 2 à tous les tests d20 et 1,50 m à la Vitesse. La pénalité apparaît dans les décompositions et en puce sur la fiche et sur la carte de combat.
- Passer au niveau 6 demande une confirmation, puis le personnage meurt.

### Lot c : Réactions et Vigilant

- **Réaction des PJ** (EF-INI-08) : « Réaction disponible / utilisée » sur la carte d'un PJ, réinitialisée au début de son tour.
- **Vigilant** (EF-INI-09, [C3]) : juste après le jet d'initiative, un PJ qui a ce don échange son initiative avec un allié consentant, sauf si l'un des deux est Neutralisé.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `encounters` : dégâts massifs, Assommer, Soutien, fin automatique de la concentration, réaction des PJ, Vigilant.
- `character-sheet` : épuisement appliqué (lot b).

## Impact

- **Moteur** : `packages/dnd_rules/lib/src/combat.dart`, avec de nouveaux tests, puis le calcul de la fiche au lot b.
- **App** : `damage_keypad.dart`, `condition_sheets.dart` et `combatant_sheet.dart`, la fiche (lot b) et l'initiative (lot c), plus les nouvelles clés ARB.
- **Données** : aucun changement de schéma. Les nouveaux champs d'événement (`knock_out`, issue `stabilized`) passent dans le JSON libre du journal.

## Hors périmètre

- **Fin de l'état Inconscient d'une créature assommée après un Repos court** : le combat ne gère pas de repos. Le MJ retire l'état à la main.
- **Jets demandés au téléphone du joueur** : ils relèvent de la vue combat du joueur.
