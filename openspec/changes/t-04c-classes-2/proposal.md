# Proposal

## Why

Carte Trello [T-04 · Saisie SRD : classes, sous-classes, sorts, objets](https://trello.com/c/DsZNVvZy/27-t-04-saisie-srd-classes-sous-classes-sorts-objets), **lot 3/5**. Les lots 1 (sorts) et 2 (six classes) sont fusionnés. Il manque cinq classes du SRD 5.2.1 pour que la création de personnage (US-05) les propose toutes ; le Guerrier est complet depuis M0.

## What Changes

- **Cinq classes** avec leur sous-classe du SRD : Moine (Credo de la Paume), Occultiste (Protecteur Fiélon), Paladin (Serment de Dévotion), Rôdeur (Chasseur) et Roublard (Voleur). Chacune a :
  - ses traits de base ;
  - sa table de progression sur 20 niveaux ;
  - sa liste de sorts (Occultiste, Paladin, Rôdeur) ;
  - une aptitude par entrée « Niveau N : … », avec le texte copié du PDF.
- **Effets** : les aptitudes calculables ou à utilisations reçoivent les effets prévus par `docs/dsl/INVENTAIRE_APTITUDES.md` (53 aptitudes).
- **Lecture des tables, nouvelles formes de valeur :**
  - dé « 1d6 » (Arts martiaux, faces) et « 2d6 » (Attaque sournoise, nombre de dés), selon le suffixe de colonne `_die` ou `_dice` ;
  - mètres convertis en pieds (Déplacement sans armure, colonne `_feet`) ;
  - valeurs repoussées sur la ligne suivante par un exposant (« 7e », table de l'Occultiste).
- **Découpage des sections :**
  - la section se termine au titre de la classe suivante, seul sur sa ligne, même précédé d'un saut de page ;
  - le titre « Origines des personnages », coupé en deux lignes, est reconnu ;
  - les fins de ligne CRLF de `pdftotext` sous Windows sont normalisées ;
  - un encadré qui coupe une phrase (« Rompre votre serment ») est déplacé et la phrase recollée.
- **Nouvelles colonnes de table** (entiers, conventions du lot 2) :
  - Moine : `martial_arts_die`, `focus_points`, `unarmored_movement_feet` ;
  - Occultiste : `invocations`, `pact_slots`, `pact_slot_level` ;
  - Rôdeur : `favored_enemy` ;
  - Roublard : `sneak_attack_dice`.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `content-pack` : cinq classes du SRD et leurs sous-classes entrent dans le pack.

## Impact

- `tools/srd_builder` :
  - `progression_table.dart` (dés, mètres, exposants) ;
  - `feature_extractor.dart` (fin de section, encadrés, CRLF) ;
  - `srd_classes.dart` (5 classes) et `extract/feature_slugs.tsv` ;
  - sources des 5 classes, 5 sous-classes et 111 aptitudes ;
  - tests.
- Pack SRD régénéré dans l'app (760 entités).

**Choix de modélisation à valider :**
- **Armes du Moine et du Roublard :** seule une partie des armes de guerre est concernée (« dotées de la propriété Légère », « Finesse ou Légère »). `weapon_proficiencies` reçoit deux valeurs explicites, `martial_light` et `martial_finesse_or_light`. Le moteur les interprète d'après la catégorie et les propriétés de l'arme (`coversWeapon`).
- **Outils du Moine :** « un type d'outils d'artisan ou d'instrument de musique ». Un choix entre deux catégories n'est pas exprimable : il reste descriptif.
- **Restent descriptifs** (choix libres, ou entités pas encore modélisées) :
  - Manifestations occultes ;
  - Arcanum mystique ;
  - Proie du chasseur ;
  - Tactiques défensives ;
  - Arts martiaux (le dé est dans la colonne de la table) ;
  - Attaque sournoise (les dés sont dans la colonne de la table).

**Hors périmètre :** les manifestations occultes comme entités (avec l'Occultiste niveau 2+, US-08) ; l'équipement de départ (lot 4).
