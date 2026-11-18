# Proposal

## Why

Carte Trello [US-22](https://trello.com/c/xfAQDteE), lot c et dernier : les rappels de tour à l'écran (**EF-CON-03**, planches [C6] et [1a] ; `TurnReminder` en COMPOSANTS §2.6). Le moteur (lot a) calcule déjà les rappels, et les états se posent depuis le lot b.

## What Changes

- **Fin de tour ([C6])** : « Tour suivant » ouvre le dialogue « Fin du tour · <unité> », s'il y a quelque chose à rappeler pour l'unité active. Sinon, le tour passe directement.
  - **Sauvegarde à refaire** : « JS de Force DD 13 · bonus +3 », avec trois boutons.
    - « Lancer » lance le d20 et ajoute le bonus. Il est absent si le bonus est inconnu.
    - « Échec » et « Réussite » saisissent le résultat. Une réussite retire l'état.
    - Le résultat reste affiché.
  - **État qui expire** : « Effrayé · expire », la durée, et le badge « Retiré ».
  - **Dégâts récurrents « à la fin »** : « Lancer et appliquer » tire les dés et applique les dégâts au porteur.
  - **Sortie** : « Plus tard » ferme sans passer le tour. « Tour suivant : <unité> » passe le tour.
- **Début de tour ([1a])** : un bandeau d'alerte « Début du tour · <unité> » en haut de l'écran de combat.
  - Il liste les états qui viennent d'expirer et ceux qui expirent à la fin de ce tour.
  - Il propose les dégâts récurrents « au début », avec « Lancer et appliquer ».
  - « OK » le masque jusqu'au tour suivant.
- **Puce** : un état qui expire à la fin du tour en cours affiche « · expire » ([1a]).

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `tables` : rappels de début et de fin de tour.

## Impact

- `apps/game_table/lib/encounters/turn_reminders.dart` (nouveau) : dialogue de fin de tour et bandeau de début de tour.
- `apps/game_table/lib/encounters/combat_view.dart` : « Tour suivant » et bandeau.
- `apps/game_table/lib/encounters/condition_sheets.dart` : « expire » sur la puce.
- ARB, et `test/encounters_test.dart`.
- Aucun changement du moteur ni du schéma : une sauvegarde lancée écrit `condition_save`, et des dégâts récurrents écrivent `damage`.

**Hors périmètre :**
- **Rappels de concentration** : US-23.
- **Vue du joueur** et demande de jet au joueur : US-36.
