# Proposal

## Why

Carte Trello [US-20](https://trello.com/c/unGA2o4Y), lot c : le MJ lance la rencontre et règle l'initiative (**EF-INI-01** à **04**, planche [C3]). Le moteur (lot a) et le journal (lot b) sont prêts.

## What Changes

- **« Lancer la rencontre »** sur la préparation (US-19). Il crée les combattants et lance automatiquement les jets des monstres et des PNJ, puis ouvre l'écran d'initiative.
  - **PJ présents** : nom, joueur, bonus et Avantage d'initiative de leur fiche calculée, CA, PV.
  - **Monstres et PNJ** : numérotés (« Vétéran 1 », « Vétéran 2 »), avec l'initiative commune de leur groupe, la CA et les PV (moyens, ou tirés selon le réglage de la rencontre). Leurs compteurs viennent du profil : actions légendaires, « Résistance légendaire » et capacités à recharge.
- **Écran d'initiative** ([C3], `/tables/:id/rencontres/:rencontre/combat`) :
  - **« Surprise »** : une puce par unité (PJ, PNJ, groupe). Une unité surprise a le Désavantage, et un monstre surpris est relancé.
  - **Tableau** : combattant (« PJ · Hugo », « PNJ », « Initiative commune »), bonus et « Avantage » ou « Désavantage », jet (« 15 (11) »), total, puis l'origine : « Jet automatique », ou un champ où le MJ saisit le dé gardé d'un PJ.
  - **« Ordre du tour »** : total et nom par unité, « Égalité · le MJ décide » ou « Égalité · Inès et Sam décident », explication de chaque égalité, et réordonnancement par glisser-déposer.
  - **Pied** : « L'ordre par défaut suit le bonus d'initiative, par commodité : ce n'est pas une règle. Entre un monstre et un PJ à égalité, vous tranchez. »
  - **En-tête** : « Tous les jets sont saisis » quand c'est le cas, puis « Commencer le round 1 ».
- **Moteur** : `combatant_added` garde l'Avantage d'initiative, et `initiative_rolled` garde le mode et la surprise.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `encounters` : Avantage d'initiative, mode et surprise d'un jet.
- `tables` : lancement d'une rencontre, écran d'initiative.

## Impact

- `packages/dnd_rules/lib/src/combat.dart` et ses tests.
- `apps/game_table/lib/encounters/` :
  - `launch.dart` (nouveau) : combattants et jets d'une rencontre ;
  - `combat_page.dart` (nouveau) : initiative ;
  - `encounter_page.dart` : « Lancer la rencontre » ;
  - providers.
- Route, ARB et tests.

**Hors périmètre :**
- **Rounds et tours** (après « Commencer le round 1 ») : lot d. L'écran affiche le round et l'unité active, en attendant.
- **Saisie du jet par le joueur** ([C5]) : US-36. « Saisi par Hugo » devient ici « Saisi par le MJ ».
- **Échange d'initiative (Vigilant)** : US-37.
