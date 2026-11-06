# Design

## Context

- **Chapitre :** « Objets magiques de A à Z » va jusqu'au titre « Monstres ». Une entrée est un nom seul sur sa ligne, suivi d'une ligne de type (« Anneau, rare (Harmonisation requise) »).
- **Tables :** 41 objets contiennent une table ou une liste. La lecture du PDF en mêle souvent les colonnes. Le texte en mise en page les donne ligne par ligne.
- **Précédent :** les tables de trait des espèces (`srd_origins.dart`) sont recopiées et vérifiées par `missingTableCells`.

Motivation : proposal.md.

## Goals / Non-Goals

**Goals:**
- Textes extraits, jamais retapés, sauf les lignes de table, vérifiées contre le SRD.
- Une table reste à sa place dans le texte de l'objet.

**Non-Goals:**
- Pas d'effet d'objet, pas de calcul nouveau dans `dnd_rules`.

## Decisions

1. **`MagicItemData`** : `category`, `rarity`, `type_line`, `attunement` (faux par défaut), `attunement_by` (facultatif).
2. **Découpage :** une entrée commence à la ligne qui précède une ligne de type. La ligne de type commence par une catégorie et contient une rareté, sans tenir compte de la casse (« Artefact »).
   - Le premier mot donne la catégorie.
   - Une seule rareté dans la ligne donne cette rareté. « rareté variable » ou plusieurs raretés donnent `varies`.
   - « Harmonisation requise » donne `attunement`, et « Harmonisation requise avec X » donne `attunement_by: X`.
3. **Ligne de type collée au texte :** « Objet merveilleux, légendaire Généralement rangé… » (Tarot mystérieux). La ligne de type s'arrête après la rareté et l'harmonisation, et le reste rejoint le texte.
4. **Tables :** `extract/magic_item_tables.json` est une liste de `{item, start, resume, rows}`.
   - `start` : début de la ligne où commence la table dans le texte nettoyé ;
   - `resume` : début de la ligne où le texte reprend, vide si la table finit l'objet ;
   - `rows` : les lignes de la table, cellule par cellule.

   Les lignes entre `start` et `resume` sont remplacées par les lignes de `rows`, jointes par « | ». Un `start` ou un `resume` introuvable est une erreur.

   Seules les 26 tables dont les colonnes sont mêlées passent par ce fichier. Dans les autres (tables à d100 aux effets longs, blocs de profil), la lecture garde les lignes dans l'ordre : le numéro et son effet se recollent sur une ligne.
5. **Slugs :** `extract/magic_item_slugs.tsv` (nom du SRD, slug anglais). Une entrée sans slug, ou un slug sans entrée, est une erreur.
6. **Fusion :** comme les autres extractions, un fichier existant garde ses `effects`.
7. **Base :** table `magic_item`, ajoutée à `_tableOf`. Les colonnes `category`, `rarity`, `type_line`, `attunement` et `attunement_by` y font l'aller-retour.

## Risks / Trade-offs

- **Lignes de table recopiées** → `missingTableCells` les vérifie contre le texte en page.
- **Tables non recensées** → le rapport d'extraction liste les lignes courtes sans ponctuation restées dans un texte, à relire.
