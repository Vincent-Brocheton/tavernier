# Proposal

## Why

Carte Trello [T-04 · Saisie SRD : classes, sous-classes, sorts, objets](https://trello.com/c/DsZNVvZy/27-t-04-saisie-srd-classes-sous-classes-sorts-objets), **lot 4/5, première partie (origines)**. Les lots 1 à 3 (sorts, 12 classes) sont fusionnés. La création de personnage (US-05) doit proposer les 9 espèces et tous les dons du SRD. Le pack n'a que l'Humain et 10 dons sur 17.

Le lot 4 est livré en deux pull requests pour rester relisible :
- **origines** (ce change) : espèces et dons ;
- **équipement** (change suivant) : outils, matériel d'aventurier, montures, équipement de départ des classes.

## What Changes

- **Huit espèces** (SRD p. 88-91) : Drakéide, Elfe, Gnome, Goliath, Halfelin, Nain, Orc et Tieffelin. Chacune a :
  - son type de créature, ses tailles et sa Vitesse, lus dans l'en-tête ;
  - un trait (entité `feature`) par paragraphe « Nom. Texte », avec le texte copié du PDF ;
  - les effets prévus par `docs/dsl/INVENTAIRE_APTITUDES.md`.
- **Sept dons de faveur épique** (SRD p. 93-94). Les 10 dons déjà présents depuis M0 sont relus par la même extraction.
- **Nouvelle commande `extract-origins`** de `srd_builder` : elle réécrit le nom, le texte et l'en-tête des espèces, ainsi que le nom, le texte, la catégorie, les prérequis et « Répétable » des dons. Les effets saisis à la main sont gardés. L'Humain et les dons de M0 passent par elle.
- **Tables des traits** (Ancêtres draconiques, Lignages elfiques, Héritages fiélons) : la lecture du PDF mêle leurs colonnes. Leurs lignes sont recopiées dans la configuration de l'extracteur, puis ajoutées au texte du trait. Un test vérifie que chaque cellule figure dans le texte en mise en page du SRD.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `content-pack` : les espèces et les dons du SRD entrent dans le pack.

## Impact

- `tools/srd_builder` :
  - `lib/src/origin_extractor.dart` (nouveau) ;
  - `lib/src/srd_origins.dart` (configuration) ;
  - commande `extract-origins` ;
  - sources des espèces, de leurs traits et des dons ;
  - tests.
- Pack SRD régénéré dans l'app.
- `CLAUDE.md` : la commande `extract-origins`.

**Choix de modélisation :**
- **Ascendance draconique :** le choix porte sur les cinq types de dégâts (acide, feu, foudre, froid, poison) plutôt que sur les dix dragons. Deux dragons de même type de dégâts ont les mêmes effets. Le moteur retient une option par la référence qu'elle cite, et dix options citeraient chacune un type déjà cité par une autre.
- **Ascendance gigante (Goliath) :** une ressource commune (`srd:resource:giant-ancestry`, bonus de maîtrise par Repos long) suit les utilisations. Le bénéfice choisi reste descriptif : ses six options ne citent aucune entité qui les distinguerait, et le moteur retient une option par la référence qu'elle cite.
- **Lignages :**
  - les lignages d'Elfe, de Gnome et de Tieffelin sont des `choice` dont chaque option donne ses sorts (`grant_spell`, avec `when.level` 3 et 5 pour l'Elfe et le Tieffelin) ;
  - la caractéristique d'incantation (Intelligence, Sagesse ou Charisme) reste descriptive : elle se choisit avec les sorts (US-09).
- **Restent descriptifs :** Transe, Agilité halfeline, Chance, Discrétion naturelle, Forte carrure, et les effets des Faveurs épiques au-delà de l'augmentation de caractéristique, de la Vision lucide et des utilisations de la Faveur du destin.
- **Écart avec l'inventaire :** l'inventaire prévoit une ressource « 1 / repos long » pour la Faveur de mémoire magique. Le SRD (p. 93) n'en donne pas : chaque emplacement de 1er à 4e niveau lance 1d4, sans limite. Aucune ressource n'est créée, et la ligne de l'inventaire est corrigée.

**Hors périmètre :**
- l'équipement (change suivant) ;
- le calcul des augmentations de caractéristique des dons par le moteur (fiche, US-07).
