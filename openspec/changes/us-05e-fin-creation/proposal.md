# Proposal

## Why

Carte Trello [US-05](https://trello.com/c/NRrTNP2B), lot 3. Les étapes 1 à 6 sont livrées, mais l'assistant s'arrête à l'Équipement et rien n'est enregistré. Ce change termine la création : un joueur va au bout des 9 étapes, hors-ligne, et retrouve son personnage après avoir fermé l'application.

## What Changes

- **Étape 7, Équipement [P6] :** un lot de classe et un lot d'Historique, ou leur valeur en or, avec l'outil à choisir quand le lot en demande un. Le panneau montre la CA et l'or.
- **Étape 8, Détails [P7] :** nom obligatoire, alignement, apparence, personnalité, histoire.
- **Étape 9, Récapitulatif [P8] :** fiche calculée par `computeSheet`, alertes et vérifications. Les erreurs de règle bloquent, pas les alertes (cahier §5.1).
- **Enregistrement :** le brouillon devient un `CharacterInput`, écrit par `CharacterStore`.
- **`CharacterInput` :** reçoit `spells`, `coins`, `alignment`, `appearance`, `personality` et `backstory`.
- **Personnages :** la page liste les personnages enregistrés.
- **Identifiants :** UUID v7, générés par `dnd_data` sans dépendance nouvelle.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-creation` : étapes 7 à 9 et enregistrement.
- `local-database` : sorts, monnaie et détails du personnage, liste.

## Impact

- `packages/dnd_rules` : `character_input.dart`, code généré, alignements.
- `packages/dnd_data` : `game_tables.dart`, `character_store.dart`, schéma v1 régénéré (non publié).
- `apps/game_table/lib/creation/` : brouillon, conversion, trois étapes, ARB.
- `apps/game_table/lib/main.dart` : liste des personnages.

**Hors périmètre :**
- **Envoi au MJ et écran [P9] :** tables et comptes arrivent en M2. Le bouton de l'étape 9 enregistre un personnage libre.
- **Portrait :** il demande un sélecteur de fichiers et un stockage, à reprendre avec la fiche.
- **Fiche détaillée et décomposition au toucher :** US-07.
- **Reprise d'un brouillon interrompu :** le brouillon reste en mémoire tant que l'assistant est ouvert.
- **Armes et armures maîtrisées au récapitulatif, décomposition de la CA à l'étape 7 :** à reprendre avec la fiche, US-07.
