# Proposal

## Why

Carte Trello [US-18](https://trello.com/c/0XIAKPIF), lot c. Le MJ associe à un PNJ des **informations cachées** par palier de DD, que l'action Étude révélera (**EF-PNJ-03**, cahier §6.4, planche [C2]). Il range aussi ses PNJ dans des dossiers et les renomme (**EF-PNJ-02**). Le stockage existe depuis le lot a ; ce lot ajoute les écrans.

## What Changes

- **Section « Informations cachées »** sur la fiche d'un PNJ ([C2]), sous-titrée « Révélées par l'Étude » :
  - un palier par ligne, du plus bas au plus haut DD : « DD 10 », le texte, puis « Révélée » ou « Cachée » (icône et libellé) ;
  - « Ajouter un palier » ouvre une feuille avec le DD (nombre entier de 1 à 30) et le texte (obligatoire) ;
  - toucher un palier ouvre la même feuille pour le modifier ou le supprimer ;
  - un palier modifié garde son état de révélation.
- **« Modifier »** dans l'en-tête de la fiche : une feuille avec le nom (obligatoire) et le dossier. Un dossier vide sort le PNJ de son dossier.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `tables` : informations cachées d'un PNJ, renommage et dossier.

## Impact

- `apps/game_table/lib/npcs/` : `npc_page.dart` et une nouvelle feuille `hidden_info_sheet.dart` ;
- ARB ;
- tests de widgets.

**Hors périmètre :**
- **Révélation par l'Étude** et ligne « Révélée séance 12 · Thalia, Histoire 16 » : avec US-22, qui la trace.
- **Ordre libre des paliers** : ils restent triés par DD, comme dans [C2].
- **Informations cachées d'un monstre de rencontre** : avec US-19 et US-22.
