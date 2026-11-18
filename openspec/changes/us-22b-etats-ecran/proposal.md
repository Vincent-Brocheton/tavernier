# Proposal

## Why

Carte Trello [US-22](https://trello.com/c/xfAQDteE), lot b : les écrans pour poser et consulter les états en combat (**EF-CON-01**, **EF-CON-02**, planches [C5], [K4] et [1a] ; `ConditionChip` en COMPOSANTS §2.3). Le moteur est livré au lot a. Les rappels de tour suivent au lot c.

## What Changes

- **Pied de l'écran de combat** : un bouton « État » rejoint Dégâts, Soins et PV temp. ([1a]). Il agit sur les cibles choisies.
- **Feuille « Ajouter un état » ([C5])** :
  - les 15 états du SRD en tuiles, avec icône et libellé, et une 16ᵉ tuile « Autre effet » ;
  - le résumé de la règle de l'état choisi ;
  - la durée : nombre de rounds, jusqu'au début ou à la fin du tour d'un combattant, jusqu'à réussite d'une sauvegarde (DD et caractéristique), ou indéfinie ;
  - « Ajouter Entravé » pose l'état sur chaque cible, en un seul envoi.
- **Cas particuliers de la feuille** :
  - **Épuisement** : un nombre de niveaux remplace la durée ;
  - **Autre effet** : un libellé, et des dégâts récurrents facultatifs (dés, type, début ou fin du tour du porteur) ;
  - **Immunité** : un état auquel toutes les cibles sont immunisées est grisé, avec « Immunité ».
- **Cartes** : les puces d'état (`ConditionChip`) montrent l'icône, le libellé et la durée atténuée : « 2 rd », « fin tour Mira », « JS FOR DD 13 », « Épuisement 2 ».
- **Fiche d'état ([K4])**, au toucher d'une puce :
  - le texte de la règle, et le badge de source ;
  - la ligne « Dans ce combat » : porteur et durée en clair ;
  - les boutons « Retirer l'état » et, pour l'Épuisement, « Retirer un niveau ».
- **Détail d'un combattant** : ses états, et « Ajouter un état ».

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `tables` : ajout d'un état, puces d'état, fiche d'état.

## Impact

- `apps/game_table/lib/encounters/` :
  - `condition_sheets.dart`, nouveau : ajout d'un état, fiche d'état, puce ;
  - `combat_view.dart` ;
  - `combatant_sheet.dart`.
- ARB, et `test/encounters_test.dart`.

**Hors périmètre :**
- **Rappels de début et de fin de tour** : lot c.
- **« Lié à un sort de concentration »** de [C5] : US-23.
- **Icônes dessinées** des états (§2.3) : elles restent à produire. Les icônes Material les remplacent, toujours avec leur libellé.
