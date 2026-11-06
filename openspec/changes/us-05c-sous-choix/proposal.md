# Proposal

## Why

Carte Trello [US-05](https://trello.com/c/NRrTNP2B), lot 2, seconde partie. Les étapes 1 à 5 sont livrées. L'étape 6, Sous-choix (cahier §5.1, maquette [P5]), rassemble ce que la classe, l'Historique et l'espèce laissent ouvert.

Elle est livrée en deux pull requests :
1. **Ce change :** tout, sauf les sorts.
2. **Le suivant :** sorts de départ et options de l'Initié à la magie, qui demandent un champ nouveau dans `CharacterInput` et dans la base.

## What Changes

- **Étape 6, Sous-choix [P5]**, composée selon le personnage :
  - compétences de classe, celles déjà maîtrisées grisées avec la règle ;
  - bottes d'arme ;
  - style de combat (don) ;
  - don d'origines de l'Humain (Polyvalent), un don non répétable déjà obtenu grisé ;
  - instruments du Barde ;
  - tous les effets `choice` de niveau 1 : Ordre divin, Ordre primitif, lignages, Ascendance draconique, Héritage fiélon, Compétent, Sens aiguisés, Expertise, langue du Roublard, Doué.
- **Panneau « À compléter »** : l'état de chaque choix.
- **DSL :** `choice` reçoit `labels`, le nom de chaque option (« Protecteur », « Drow »).
  - Il sert d'étiquette à l'écran.
  - Il permet au moteur de retenir une option qui ne cite aucune entité. Sans lui, l'Ordre divin et l'Ordre primitif ne pouvaient pas être choisis.
- **Correction de règle :** les bottes du Barbare sont réservées aux armes de corps à corps (SRD p. 31). `grant_mastery_slots` reçoit `melee_only`, que le moteur applique.
- **`dnd_rules` :** `openChoices` liste les choix ouverts au niveau 1.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-creation` : étape Sous-choix.
- `character-sheet` : options nommées, bottes de corps à corps.
- `content-pack` : noms des options.

## Impact

- `packages/dnd_content` : schémas du DSL.
- `packages/dnd_rules` : `compute_sheet.dart`, `creation_choices.dart`.
- `tools/srd_builder/sources/feature/` : 7 aptitudes, pack régénéré.
- `apps/game_table/lib/creation/subchoices_step.dart`, brouillon, ARB.
- `docs/dsl/DSL_V1.md`.

**Hors périmètre :**
- **Sorts de départ et options de l'Initié à la magie :** change suivant. D'ici là, un lanceur de sorts passe l'étape sans choisir ses sorts.
- **Manifestations occultes (Occultiste) :** elles ne sont pas des entités du pack (décision de T-04, lot 3).
- **Outils de l'Humain avec Doué :** l'effet `skilled` ne propose que des compétences, alors que le SRD dit « compétences ou outils ». Écart à reprendre sur le contenu.
- **Outil du Moine :** descriptif depuis T-04, un choix entre deux catégories n'est pas exprimable.
