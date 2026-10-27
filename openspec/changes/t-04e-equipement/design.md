# Design

## Context

- **Modèle existant :**
  - `ToolData` : `category`, `ability`, `weight_kg`, `cost_cp` ;
  - `ItemData` : `weight_kg`, `cost_cp` ;
  - l'Historique porte déjà son équipement : `equipment_a` (liste d'`ItemQuantity`), `gold_a` et `gold_b`.
- **Base locale :** `PackStore` fait l'aller-retour de chaque champ. L'équipement d'Historique est dans `background_equipment_option`.
- **Texte en ordre de lecture :**
  - un outil est décrit par « Nom (prix) », puis « Caractéristique : X Poids : Y », « Utilisation : … » et « Artisanat : … » ;
  - un objet est décrit par « Nom (prix) » et son paragraphe.
- **Texte en mise en page :** les poids des objets ne sont que dans le tableau « Matériel d'aventurier », sur deux colonnes, avec quelques noms coupés.

Motivation : proposal.md.

## Goals / Non-Goals

**Goals:**
- Textes extraits, jamais retapés. Les données recopiées à la main sont vérifiées contre le SRD par un test.
- Équipement de départ exploitable par la création de personnage.

**Non-Goals:**
- Pas de calcul nouveau dans `dnd_rules`.
- Pas de contenu des paquetages comme données : il reste dans le texte.

## Decisions

1. **`StartingEquipmentOption`** : `items` (liste d'`ItemQuantity`), `tool_choice` (catégories d'outil, un outil à choisir parmi elles, vide par défaut) et `gold` (po).
   - `ClassData.starting_equipment` est une liste d'options, vide par défaut. Les options suivent l'ordre du SRD (A, B, C).
   - Le modèle de l'Historique ne change pas.
2. **Base :** table `class_equipment_option` (`class_id`, `option`, `items` JSON, `tool_choice` JSON, `gold`), sur le modèle de `background_equipment_option`.
3. **Outils extraits.**
   - **Section :** de « Outils d'artisan » à « Matériel d'aventurier ».
   - **Découpage :** un outil commence à une ligne « Nom (prix) » dont le nom figure dans la configuration.
   - **Données :** la caractéristique et le poids sont lus sur la ligne « Caractéristique : X Poids : Y », le prix dans le titre.
   - **Variantes :** les boîtes de jeux et les instruments lisent leur prix et leur poids dans la ligne « Variantes : nom (prix, poids), … ». Un poids absent vient du titre de l'outil (« Poids : — » pour les boîtes de jeux).
4. **Objets.**
   - **Données :** `extract/gear.tsv` donne slug, nom, libellé du tableau, poids et prix pour chaque objet.
   - **Vérification :** le test cherche, dans le texte en mise en page, le libellé suivi sur sa ligne du poids puis du prix (« Acide  0,5 kg  25 po »). Le libellé peut passer à la ligne (« Parchemin de sort (1 niveau) »).
   - **Texte :** la description « Nom (prix) » de la section « Matériel d'aventurier », jusqu'au titre suivant.
     - Une variante (Baguette, Orbe…) reçoit le texte de son objet parent.
     - Une colonne de `gear.tsv` dit de quelle description vient le texte.
5. **Équipement de départ saisi à la main** dans les traits de base des classes, comme le reste de ces traits.
   - « Hachettes » × 4 donne `quantity: 4`.
   - « 20 flèches » donne `srd:item:arrows` × 1 : l'objet est le lot « Flèches (20) ».
   - Un test relit chaque phrase « Choisissez … » dans le SRD et y retrouve l'or de chaque option.
6. **Slugs anglais** dans la configuration et `gear.tsv`. Les 7 outils et 10 objets de M0 gardent leurs slugs.

## Risks / Trade-offs

- **Lignes de `gear.tsv` recopiées** → test ligne à ligne contre le texte en page.
- **Libellé de description différent du nom du tableau** (« Bouteille, verre ») → colonne dédiée dans `gear.tsv`.
