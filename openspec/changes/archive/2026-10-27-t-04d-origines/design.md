# Design

## Context

- **Modèle de M0 :** `species/human.json` porte `creature_type`, `sizes`, `speed_feet` et ses `traits`. Chaque trait est une entité `feature` (`source` : l'espèce, `level` : 1). Les dons de M0 portent `category`, `prerequisites` et `repeatable`.
- **Inventaire :** `docs/dsl/INVENTAIRE_APTITUDES.md` prévoit les effets des traits et des dons.
- **Texte en ordre de lecture (pdftotext) :**
  - les traits sont des paragraphes « Nom. Texte » ;
  - un don est un titre suivi d'une ligne « Don d’origines », « Don général (prérequis : …) », etc. ;
  - les tables des traits y sont mêlées.

Motivation : proposal.md.

## Goals / Non-Goals

**Goals:**
- Textes extraits, jamais retapés ; effets saisis à la main.
- Une extraction relançable sans perdre les effets.

**Non-Goals:**
- Pas de nouvelle opération du DSL ni de calcul nouveau dans `dnd_rules`.

## Decisions

1. **Section des espèces :** de « Description des espèces » au titre « Dons » qui suit. Une espèce commence à son nom seul sur sa ligne, nom donné par la configuration.
2. **En-tête d'espèce :** les lignes entre le nom et « En tant que … » sont jointes.
   - Type de créature : « Humanoïde » → `humanoid`.
   - Tailles : chaque lettre de taille lue après « Catégorie de taille : » ou « ou » (`M`, `P`).
   - Vitesse : « 9 m » → 30 pieds (×10/3, comme `_feet`).
3. **Traits :** un trait commence à une ligne qui débute par « Nom. », avec un nom donné par la configuration de l'espèce. Les noms de la configuration évitent les faux départs : « Gnome des forêts. » appartient au trait Lignage gnome.
   - Une table du trait (titre donné par la configuration) est retirée jusqu'au trait suivant.
   - Ses lignes, recopiées dans la configuration, sont ajoutées au texte du trait. Un test vérifie que chaque cellule figure dans `docs/srd/FR_SRD_CC_v5.2.1.txt`.
4. **Dons :** de « Dons d’origines » au titre « Équipement ».
   - Un don commence à la ligne qui précède une ligne `^Don (d’origines|général|de Style de combat|de faveur épique)`.
   - Les intertitres « Dons généraux »… sont ignorés.
   - Catégorie, prérequis et « Répétable » sont lus dans le texte :
     - « niveau N » → `min_level` ;
     - « Force ou Dextérité 13 ou plus » → `ability_min_any` ;
     - « aptitude Style de combat » → `feature: fighting_style` ;
     - « aptitude Sorts » → `feature: spellcasting`.
5. **Fusion :** comme `extract-classes`. Un fichier existant garde ses `effects`, et pour un trait aussi ses `data`. Un fichier nouveau est créé sans effet. Pour un don, `data` est toujours réécrit : le diff montre tout écart avec la saisie de M0.
6. **Slugs :** dans la configuration (`srd_origins.dart`), un nom → un slug anglais. Les traits sont préfixés par l'espèce (`dwarf-dwarven-toughness`), comme `human-skillful`.
7. **Effets :** saisis selon l'inventaire, avec les choix de modélisation de la proposal.

## Risks / Trade-offs

- **Lignes de table recopiées à la main** → le test de concordance avec le texte en mise en page.
- **Paragraphe coupé par un saut de page** (Souffle) → `cleanText` recolle les lignes ; le test du Drakéide vérifie le texte complet.
