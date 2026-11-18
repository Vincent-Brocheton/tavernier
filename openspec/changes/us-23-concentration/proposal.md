# Proposal

## Why

Carte Trello [US-23](https://trello.com/c/nf2wYI3A) : tests de concentration en combat (**EF-CON-04**, **EF-CON-05**, cahier §6.3, SRD glossaire « Concentration »). Le journal porte déjà les dégâts (US-21) et les états (US-22), mais pas la concentration. [C5] prévoit « Lié à un sort de concentration », que US-22 a laissé de côté.

## What Changes

- **Moteur**, avec trois nouveaux événements :
  - `concentration_started` : un combattant se concentre sur un sort, désigné par son nom. Commencer une autre concentration met fin à la précédente (SRD).
  - `concentration_check` : réussite ou échec du JS de Constitution en attente. Un échec met fin à la concentration.
  - `concentration_ended` : le MJ y met fin.
- **Fin de concentration** : les états posés avec le lien `concentration` (le lanceur) sont retirés de tous les combattants (EF-CON-05).
- **Test en attente** (EF-CON-04) : chaque événement `damage` qui inflige des dégâts à un combattant concentré ajoute un test. Son DD vaut 10 ou la moitié des dégâts subis (arrondie à l'inférieur), le plus élevé des deux, plafonné à 30 (SRD).
- **Écran** :
  - **Carte** : puce « Concentration · <sort> » (couleur concentration, icône, libellé).
  - **Alerte de concentration** ([1c], COMPOSANTS §2.5) : pour chaque test en attente, une carte dans le combat avec :
    - « Jet de concentration · <combattant> · Constitution DD n » ;
    - l'explication du DD et le bonus de JS de Constitution ;
    - ce qu'un échec retire ;
    - les boutons Échec et Réussite.

    Un échec demande confirmation avant d'écrire (EF-CON-05).
  - **Détail du combattant** : section « Concentration ».
    - Sans concentration en cours : « Se concentrer », avec le nom du sort à saisir (suggestions parmi les sorts à concentration du contenu actif).
    - Pendant une concentration : le sort, ses effets liés et « Mettre fin », avec confirmation.
  - **[C5]** : liste « Lié à un sort de concentration », avec « Aucun » et les combattants concentrés.
  - **Fiche d'état [K4]** : la ligne « Lié à la concentration de <lanceur> (<sort>) ».
  - **Pavé de dégâts** (COMPOSANTS §2.4) : l'aperçu d'une cible concentrée annonce « Concentration : JS de CON DD n ».

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `encounters` : concentration, tests de concentration et effets liés.

## Impact

- `packages/dnd_rules/lib/src/combat.dart` et ses tests.
- `apps/game_table/lib/encounters/` :
  - `combat_view.dart` : puce et alerte ;
  - `combatant_sheet.dart` ;
  - `condition_sheets.dart` : lien [C5] et fiche [K4] ;
  - `damage_keypad.dart` ;
  - ARB et tests de widgets.
- Aucune migration : le type d'un événement est un texte libre côté serveur.

**Hors périmètre :**
- **Fin automatique de la concentration** quand le lanceur devient Inconscient ou Neutralisé, ou meurt (EF-CON-06) : US-37. Le MJ y met fin à la main.
- **Concentration venue de la fiche du PJ** (`concentration_spell_id`) au lancement, et **demande de jet sur le téléphone du joueur** (EF-VJ-04, 05) : vue combat du joueur.
- **Durée maximale du sort** (1 minute…) : le MJ y met fin à la main.
- **Bouton « Lancer »** dans l'alerte : [1c] ne propose qu'Échec et Réussite.
