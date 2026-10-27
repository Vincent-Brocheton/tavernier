# Proposal

## Why

Carte Trello [T-04 · Saisie SRD : classes, sous-classes, sorts, objets](https://trello.com/c/DsZNVvZy/27-t-04-saisie-srd-classes-sous-classes-sorts-objets), **lot 2/5** (lot 1, les 339 sorts, fusionné : PR #10). La création de personnage (US-05) doit proposer toutes les classes du SRD. Le pack n'a que le Guerrier, complet depuis M0.

Ce lot apporte six classes : Barbare, Barde, Clerc, Druide, Ensorceleur et Magicien, avec leur sous-classe du SRD : Voie du Berserker, Collège du Savoir, Domaine de la Vie, Cercle de la Terre, Sorcellerie draconique, Évocateur. Le lot 3 apportera Moine, Occultiste, Paladin, Rôdeur et Roublard.

## What Changes

- **Données de classe** (format `.dndpack` v1, ajout compatible) :
  - `spell_list` : liste des sorts de la classe, références vers les sorts du lot 1. Elle comble ce que le lot 1 a laissé de côté : un sort ne cite pas ses classes.
  - `spellcasting_ability` : caractéristique d'incantation, facultative.
  - Colonnes de la table de classe, en entiers (`ClassLevelData.columns`) :
    - pour les lanceurs de sorts : `cantrips`, `prepared_spells`, `slot_1` à `slot_9` ;
    - colonnes propres : `rages`, `rage_damage`, `bardic_die` (faces du dé), `channel_divinity`, `wild_shape`, `sorcery_points`, `weapon_mastery`.
- **Aptitudes** : une entité `feature` par aptitude de classe et de sous-classe, avec son texte copié du PDF. Les effets du DSL v1 suivent `docs/dsl/INVENTAIRE_APTITUDES.md`, l'inventaire de M0 qui classe chaque aptitude en calculable, compteur ou descriptive.
- **Extraction des textes** : `srd_builder extract-features --class <nom>`.
  - **Découpage :** l'outil découpe la section d'une classe et de sa sous-classe en aptitudes « Niveau N : Nom ».
  - **Écriture :** il écrit ou met à jour `sources/feature/<slug>.json`. Il ne réécrit que `name` et `text` : les `data` et `effects` saisis à la main sont gardés.
  - **Slugs :** ils viennent d'une table relue (`extract/feature_slugs.tsv`).
- **Classes et sous-classes** : `sources/class/<slug>.json` (traits de base, table de progression des 20 niveaux, liste de sorts) et `sources/subclass/<slug>.json`.
  - **Table de progression :** elle est saisie depuis le texte en mise en page du SRD (`docs/srd/FR_SRD_CC_v5.2.1.txt`), où les tableaux sont lisibles ligne par ligne.
  - **Liste de sorts :** elle est construite depuis les en-têtes de sort relevés au lot 1 (`extract/spell_classes.tsv`), puis comparée par test.
- **Tests de contenu** : chaque classe est vérifiée contre le PDF, page citée :
  - traits de base ;
  - colonnes témoins (Rages du Barbare, dé bardique, emplacements de sorts d'un lanceur complet au niveau 20) ;
  - nombre de sorts de chaque liste ;
  - une aptitude calculable par classe.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `content-pack` : la classe porte sa liste de sorts et sa caractéristique d'incantation ; six classes du SRD et leurs sous-classes entrent dans le pack.

## Impact

- `packages/dnd_content` : `ClassData.spellList`, `ClassData.spellcastingAbility`, et la validation des références de la liste de sorts. `build_runner` est régénéré.
- `packages/dnd_data` : la table `spell_class` est remplie depuis `spell_list` ; l'aller-retour des classes est conservé. Pas de changement de schéma.
- `tools/srd_builder` : commande `extract-features`, `extract/feature_slugs.tsv`, sources des 6 classes, 6 sous-classes et de leurs aptitudes (environ 130 entités), tests.
- `docs/packs/FORMAT_DNDPACK.md` : champs de classe documentés.

**Écarts relevés dans le SRD français, signalés sans être tranchés :**
- Table « Aptitudes du Barbare », niveau 7 : « Bond agressif », alors que l'aptitude s'intitule « Bond instinctif ». L'aptitude garde le titre de sa section.
- Quatre sorts citent une classe dans leur en-tête mais manquent dans la « Liste des sorts » de cette classe : Force fantasmagorique (Barde, Ensorceleur, Magicien), Épine mentale (Ensorceleur), Invocation d'élémentaires mineurs (Magicien). L'en-tête du sort fait foi (décision 6) ; un test fige ces quatre cas.

**Hors périmètre :**
- **Équipement de départ des classes :** il cite des paquetages et objets encore absents du pack. Il arrive avec le lot 4 (équipement), pour toutes les classes.
- **Calcul des emplacements, sorts préparés et incantation par le moteur :** US-09. Ce lot fournit les données.
- **Options de Métamagie de l'Ensorceleur :** elles sont saisies comme texte de l'aptitude Métamagie ; leur choix sur la fiche arrive avec US-08 (montée de niveau).
