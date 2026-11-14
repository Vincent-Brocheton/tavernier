# Proposal

## Why

Carte Trello [T-06](https://trello.com/c/SB1Cryrw), lot b sur trois. Le lot a a livré le type `monster` et six monstres saisis à la main. Les rencontres (US-19) et le combat de M3 ont besoin de tout le bestiaire du SRD 5.2.1 français : 330 profils dans « Monstres de A à Z » et « Animaux ». Saisir ces profils à la main n'est ni fiable ni relisible.

## What Changes

- **Commande `extract-monsters`** du `srd_builder`. Elle lit le texte du PDF en ordre de lecture (`pdftotext` sans `-layout`) et écrit un fichier `sources/monster/<slug>.json` par profil, comme les extracteurs de T-04. Elle remplit tous les champs du format :
  - **en-tête** : taille, type, étiquettes, alignement ;
  - **défense** : CA, Initiative, PV, Vitesses (mètres convertis en pieds) ;
  - **caractéristiques** : valeurs et JS ;
  - **lignes du profil** : compétences, vulnérabilités, résistances, immunités (dégâts et états), équipement, sens, langues, FP, PX et bonus de maîtrise ;
  - **traits et actions**, dans l'ordre et par rubrique, avec leurs usages, le jet d'attaque et ses dégâts, et le jet de sauvegarde.
- **Slugs anglais** : `extract/monster_slugs.tsv`. Il manque un slug, ou un fichier n'a plus de monstre : la commande échoue sans rien écrire.
- **Fichier de relecture** : `build/extract-monsters.txt` liste ce que l'outil n'a pas su lire avec certitude, à relire au lot c. Exemples : une attaque aux dégâts non reconnus, une ligne qui pourrait être un nom d'action.
- **Format `.dndpack`, trois champs optionnels** sur `monster` (choix du porteur de projet, 14 nov. 2026). Les packs existants restent valides.
  - `swarm_size` : taille des créatures d'une nuée (« Nuée de taille G de Bêtes de taille TP ») ;
  - `speed_note` : précision imprimée que les nombres ne portent pas, par exemple « 12 m (forme de loup uniquement) » ou « escalade ou vol 6 m (au choix du MJ) » ;
  - `senses_note` : même chose pour les sens, par exemple « Vision dans le noir 36 m (perce les Ténèbres magiques) ».
- **Pack SRD** : les 330 profils. Les six monstres du lot a sont désormais extraits ; l'outil doit les retrouver à l'identique.
- **Écart volontaire du 25 oct. 2026** : « gigant » s'écrit « géant » dans les langues.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `content-pack` : champs de nuée et de précisions, bestiaire complet du pack SRD.

## Impact

- `tools/srd_builder/` : `monster_extractor.dart`, la commande, `extract/monster_slugs.tsv`, les tests, `sources/monster/` (330 fichiers).
- `packages/dnd_content/` : trois champs sur `MonsterData`, code généré.
- `docs/packs/FORMAT_DNDPACK.md`, `CLAUDE.md` (commande d'extraction).
- Pack SRD de l'app, régénéré.

**Hors périmètre :**
- **Contrôles de cohérence** (modificateurs et JS contre les valeurs, bonus d'attaque) et **liste des profils à relire contre le PDF** : lot c. Le lot b vérifie déjà qu'un modificateur lu concorde avec sa valeur, car c'est ce qui valide la lecture des caractéristiques.
- **Sorts d'un monstre** : l'action « Incantation » garde son texte, comme au lot a.
- **Informations d'Étude** : avec US-24.
