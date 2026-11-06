# Proposal

## Why

Carte Trello [T-04 · Saisie SRD : classes, sous-classes, sorts, objets](https://trello.com/c/DsZNVvZy/27-t-04-saisie-srd-classes-sous-classes-sorts-objets), **lot 4/5, seconde partie (équipement)**. Les origines (espèces, dons) sont fusionnées.

Deux étapes ont besoin de tout l'équipement du SRD :
- l'équipement de départ de la création de personnage (US-05, cahier §5.1 étape 7) ;
- l'inventaire (US-10, EF-PJ-10).

Le pack n'a que 7 outils et 10 objets, et les classes n'ont pas d'équipement de départ.

## What Changes

- **Les 37 outils du SRD** (p. 98-100) : 17 outils d’artisan, les 4 boîtes de jeux, les 10 instruments de musique et 6 autres outils. Chacun a :
  - sa catégorie, sa caractéristique, son poids et son prix ;
  - son texte copié du PDF (Utilisation, Artisanat).
- **Le matériel d'aventurier** (p. 100-105), avec le texte de chaque objet copié du PDF :
  - les objets du tableau ;
  - les variantes de munitions, de focaliseurs arcaniques et druidiques, et de symboles sacrés ;
  - les paquetages ;
  - le grimoire du Magicien.
- **Équipement de départ des classes :** nouveau champ `starting_equipment` de `class` (ajout compatible au format v1). Chaque option donne :
  - ses objets et leurs quantités ;
  - les catégories d'outil à choisir (« instrument de musique de votre choix ») ;
  - ses pièces d'or.

  Les 12 classes le reçoivent (option A, B, et C pour le Guerrier).
- **Base locale :** la table `class_equipment_option` stocke ces options. Le schéma v1 n'est pas publié, son instantané est régénéré.
- **Nouvelle commande `extract-equipment`** de `srd_builder` :
  - elle écrit le nom, le texte et les données des outils, lus dans leur description ;
  - elle écrit le texte des objets.

  Le poids et le prix des objets viennent de `extract/gear.tsv`, recopié du tableau « Matériel d'aventurier ». Un test vérifie chaque ligne contre le texte en mise en page.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `content-pack` : outils, matériel d'aventurier et équipement de départ des classes.
- `local-database` : options d'équipement de départ des classes.

## Impact

- `packages/dnd_content` : `ClassData.startingEquipment`, `StartingEquipmentOption` ; code généré.
- `packages/dnd_data` : table `class_equipment_option`, aller-retour dans `PackStore`, instantané du schéma.
- `tools/srd_builder` :
  - `lib/src/equipment_extractor.dart` et sa configuration ;
  - `extract/gear.tsv` ;
  - sources des outils, des objets et des 12 classes ;
  - tests.
- `docs/packs/FORMAT_DNDPACK.md`, `CLAUDE.md`.
- Pack SRD régénéré dans l'app.

**Écart dans le SRD français, signalé et non corrigé :** l'équipement de départ du Rôdeur (p. 80) cite un « focaliseur druidique (branche de gui) ». La table « Focaliseurs druidiques » (p. 102) nomme cet objet « Branche de houx ». Le Rôdeur reçoit l'objet de la table, `srd:item:druidic-focus-sprig-of-mistletoe`, dont le nom reste celui de la table.

**Hors périmètre :**
- montures, harnachement et véhicules (p. 106-107) : biens de la table plutôt que d'un personnage, avec la gestion de table (M3) si besoin ;
- hébergement, nourriture et services ;
- l'outil choisi dans l'équipement de l'Historique (Soldat : « boîte de jeux du même type »), inchangé depuis M0.
