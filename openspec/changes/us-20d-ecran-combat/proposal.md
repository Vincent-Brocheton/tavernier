# Proposal

## Why

Carte Trello [US-20](https://trello.com/c/unGA2o4Y), lot d, le dernier. Le MJ mène les tours (**EF-INI-05** à **07**, planches [1a] et [C8]) :
- compteur de rounds ;
- combattant actif mis en évidence ;
- « Tour suivant » toujours accessible ;
- ajout et retrait en cours de combat ;
- compteurs d'un monstre.

Le moteur (lot a), le journal (lot b) et l'initiative (lot c) sont prêts.

## What Changes

- **Écran de combat** (`CombatPage` à partir du round 1, [1a]) :
  - **En-tête** : titre de la rencontre, « Annuler » (le dernier événement) et un menu (« Ajouter un combattant », « Terminer la rencontre ») ;
  - **Résumé** : « Round 3 » et « 10 combattants » ;
  - **Ordre d'initiative** : par combattant, son initiative, son nom, « PJ · Guerrier 5 » ou « Humanoïde · FP 2 », sa CA et ses PV (« 31 / 52 ») ;
  - **Unité active** : contour et badge « En cours » ;
  - **Groupe** : en-tête « Loups sanguinaires · initiative commune » ;
  - **Pied** : « Tour suivant », toujours visible.
- **Rappel de début de tour** : quand l'unité active a une capacité à recharge utilisée, une carte affiche « Début du tour · Capitaine des Marches : lancez 1d6 pour Cri de ralliement (recharge 5–6). », avec :
  - « Lancer 1d6 » : rend la capacité sur un résultat de la plage, et dit le résultat ;
  - « Rechargé » : la rend sans jet.
- **Détail d'un combattant** (feuille, [C8]) :
  - CA, PV, et profil du monstre (`StatBlockView`) ;
  - **compteurs** : « Actions légendaires 3 / 3 », « Résistance légendaire 2 / 3 par jour », « Réaction · Disponible », et chaque recharge. Toucher un pion utilise ou rend une unité ;
  - « Retirer du combat ».
- **Ajouter un combattant** : un monstre ou un PNJ, choisi avec le sélecteur de la préparation. Il est numéroté après ses semblables (« Loup sanguinaire 4 »), son jet d'initiative est lancé aussitôt, et il entre à sa place.
- **Terminer la rencontre** : elle passe « Terminée », et l'écran revient à la préparation.
- **Moteur** : `lastUndoable(events)` désigne le dernier événement encore effectif, que « Annuler » vise.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `encounters` : dernier événement annulable.
- `tables` : écran de combat, rappel de recharge, détail et compteurs, ajout et retrait, fin.

## Impact

- `packages/dnd_rules/lib/src/combat.dart` et ses tests.
- `apps/game_table/lib/encounters/` :
  - `combat_page.dart` (combat) et `combatant_sheet.dart` (nouveau) ;
  - `launch.dart` (combattant d'un profil, partagé avec l'ajout) ;
  - `foe_picker.dart` (rappel d'ajout).
- ARB et tests.

**Hors périmètre :**
- **Dégâts, soins, PV temporaires** : US-21. Les PV sont affichés, pas modifiés.
- **États et rappels d'états** : US-22.
- **Concentration** : US-23.
- **Hors-ligne** affiché dans l'en-tête : l'indicateur de synchronisation viendra avec la vue du joueur (US-36).
- **Résumé de fin de rencontre** ([C11]) et partage des PX : clôture de séance (US-35, lot d).
