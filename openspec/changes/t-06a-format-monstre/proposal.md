# Proposal

## Why

Carte Trello [T-06](https://trello.com/c/SB1Cryrw), premier lot sur trois : le bestiaire du SRD 5.2.1 français (profils de jeu). C'est la base des rencontres (US-19), de l'initiative (US-20) et du combat de M3. Le format `.dndpack` n'a pas encore de type pour un monstre. Les tables `monster` et `monster_action` de la base locale existent (cahier §11.1), mais rien ne les remplit.

Découpage de la carte :
- **lot a** (ce change) : le type `monster` du format, sa validation, son chargement dans la base, et les monstres de [D1] saisis à la main ;
- **lot b** : l'extracteur `extract-monsters`, qui lit le PDF et écrit tous les monstres et animaux ;
- **lot c** : les contrôles de cohérence (FP, PX, bonus de maîtrise, modificateurs et JS) et la liste des profils à relire contre le PDF.

## What Changes

- **Format `.dndpack`, type `monster`** : un profil de jeu complet, décrit dans `docs/packs/FORMAT_DNDPACK.md` et `design.md`. Il contient :
  - taille, type de créature, alignement ;
  - CA, Initiative, PV et dés de vie, Vitesses ;
  - caractéristiques et JS, compétences ;
  - vulnérabilités, résistances et immunités, sens, langues ;
  - FP, PX (et PX dans l'antre), bonus de maîtrise ;
  - traits, actions, actions Bonus, Réactions et actions Légendaires, avec leurs usages (X/jour, Recharge X–Y, après un repos) et, pour une attaque, son bonus, son allonge ou sa portée et ses dégâts.
- **Modèle** : `MonsterData` dans `dnd_content`. Tout champ inconnu rend l'entité invalide, comme pour les autres types.
- **Contrôles à la construction** : références (types de dégâts, états, compétences) résolues. FP, PX et bonus de maîtrise doivent concorder avec la table du SRD.
- **Base locale** : l'import d'un pack remplit `monster` et `monster_action`.
- **Pack SRD** : les six monstres de [D1], saisis à la main depuis le PDF : Bandit, Loup, Loup sanguinaire, Chef de bande, Ogre et Vétéran. Les tests retrouvent leurs PX de [D1] (25, 50, 200, 450, 450, 700).

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `content-pack` : type `monster`.
- `local-database` : monstres chargés depuis les packs.

## Impact

- `packages/dnd_content/` : `MonsterData`, lecteur, validation, tests.
- `packages/dnd_data/` : import des monstres dans `monster` et `monster_action`.
- `tools/srd_builder/sources/monster/` : six fichiers.
- Pack SRD de l'app, régénéré.
- `docs/packs/FORMAT_DNDPACK.md`.

**Hors périmètre :**
- **Tous les autres monstres et animaux** : lot b.
- **Contrôles de relecture** : lot c.
- **Informations d'Étude** (`study_reveal`) : avec US-24.
- **Sorts d'un monstre** : l'action « Incantation » garde son texte, et la liste de sorts n'est pas reliée aux entités `spell`. À relier avec le combat, si le besoin apparaît.
