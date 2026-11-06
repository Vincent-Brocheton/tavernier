# Proposal

## Why

Carte Trello [T-04 · Saisie SRD : classes, sous-classes, sorts, objets](https://trello.com/c/DsZNVvZy/27-t-04-saisie-srd-classes-sous-classes-sorts-objets), **lot 5/5, le dernier**. Les sorts, les classes, les origines et l'équipement sont fusionnés. L'inventaire (US-10, EF-PJ-10) et le compendium ont besoin des objets magiques du SRD, et [D1] cite déjà `srd:magic-item:cloak-of-protection`, qui n'existe pas encore.

## What Changes

- **Nouveau type d'entité `magic-item`** (ajout compatible au format v1), avec :
  - sa catégorie (objet merveilleux, arme, armure, anneau, baguette, bâton, potion, parchemin, sceptre) ;
  - sa rareté, dont `varies` pour une rareté qui dépend de la variante ;
  - la ligne de type du SRD, recopiée telle quelle (« Arme (courante ou de guerre), peu courante (+1), rare (+2) ou très rare (+3) ») ;
  - l'harmonisation, et la créature qu'elle exige (« avec un Magicien ») ;
  - son texte, obligatoire.
- **Les 258 objets magiques du SRD** (p. 220-266), une entité par entrée, avec le texte copié du PDF.
- **Tables des objets :** la lecture du PDF mêle leurs colonnes. Leurs lignes sont recopiées dans `extract/magic_item_tables.json` et replacées à leur position dans le texte. Un test vérifie chaque cellule contre le texte en mise en page.
- **Nouvelle commande `extract-magic-items`** de `srd_builder`. Les slugs anglais sont dans `extract/magic_item_slugs.tsv`.
- **Base locale :** nouvelle table `magic_item`. Le schéma v1 n'est pas publié, son instantané est régénéré.

La carte T-04 passe dans « Fait » avec ce lot.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `content-pack` : type `magic-item` et objets magiques du SRD.
- `local-database` : stockage des objets magiques.

## Impact

- `packages/dnd_content` : `MagicItemData`, `MagicItemCategory`, `Rarity` ; code généré.
- `packages/dnd_data` : table `magic_item`, aller-retour dans `PackStore`, instantané du schéma.
- `tools/srd_builder` : `lib/src/magic_item_extractor.dart`, `extract/magic_item_slugs.tsv`, `extract/magic_item_tables.json`, sources, tests.
- `docs/packs/FORMAT_DNDPACK.md`, `CLAUDE.md`.
- Pack SRD régénéré dans l'app.

**Choix de modélisation :**
- **Une entité par entrée du SRD.** « Arme +1, +2 ou +3 » reste une entrée, de rareté `varies`. Les variantes ne sont pas dépliées : leurs valeurs sont dans le texte et la ligne de type.
- **Potions de guérison et Parchemin de sort** figurent aussi au matériel d'aventurier, où ils ont un prix. `srd:item:potion-of-healing`, cité par [D1], reste en place, et l'entrée du chapitre devient une entité `magic-item` à part.
- **Table `magic_item` distincte :** [D1] impose le type `magic-item`, et chaque type a sa table. Les colonnes `rarity` et `attunement` de `item` restent en place, inutilisées, comme dans le cahier §11.1.

**Hors périmètre :**
- **Effets des objets :** le moteur n'applique pas encore d'effet d'objet ni l'harmonisation. Ils arrivent avec l'inventaire (US-10) : les objets de ce lot n'ont que leur texte.
- Règles de fabrication et objets intelligents (p. 217-219) : ce sont des règles du chapitre, pas des objets.
