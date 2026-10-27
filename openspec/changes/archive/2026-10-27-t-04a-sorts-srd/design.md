# Design

## Context

Les entités sont des classes freezed (`EntityData`, classe scellée) lues par `dataReaders` ; tout type ajouté fait échouer la compilation de `PackStore.importPack` tant qu'il n'est pas stocké (switch exhaustif). La table `spell` existe depuis US-04 (`level`, `school`, `casting_time`, `range`, `components`, `material_cost_cp`, `material_consumed`, `duration`, `concentration`, `ritual`). Le texte du SRD est disponible :
- en mise en page à deux colonnes (`docs/srd/FR_SRD_CC_v5.2.1.txt`), où les colonnes sont mêlées ligne à ligne ;
- en ordre de lecture avec `pdftotext` sans `-layout`, où chaque paragraphe tient sur une ligne. C'est la base retenue.

Les 339 en-têtes de sort suivent tous la forme `<École> du <n>e niveau (<classes>)` ou `<École> mineure (<classes>)`, suivie de `Temps d’incantation : … Portée : … Composantes : … Durée : …`. Motivation : proposal.md.

## Goals / Non-Goals

**Goals:**
- Une extraction reproductible et relue, qui ne demande aucune retouche manuelle des 339 fichiers.
- Des données de sort utilisables par la fiche (US-09) : niveau, école, rituel, concentration, portée en pieds, composante coûteuse.

**Non-Goals:**
- Pas d'effets DSL sur les sorts (dégâts, jets) : M3.
- Pas de listes de classes dans le sort (voir décision 2).

## Decisions

1. **`SpellData`.** Champs JSON en snake_case :
   - `level` : 0 à 9 ;
   - `school` : `abjuration`, `conjuration`, `divination`, `enchantment`, `evocation`, `illusion`, `necromancy` ou `transmutation` ;
   - `casting_time` et `duration` : chaînes du SRD ;
   - `ritual`, `concentration` ;
   - `range` : `{kind: self | touch | feet | sight | unlimited | special, feet?}` ;
   - `components` : `{verbal, somatic, material?}` ;
   - `material_cost_cp?`, `material_consumed`.

   Le temps d'incantation et la durée restent en texte : leurs 20 formes, dont les déclencheurs de réaction, n'ont pas besoin d'être calculées avant le combat (M3). La portée, elle, passe en pieds (CLAUDE.md : distances stockées en pieds) : `m × 10 / 3`, arrondi au pied (1,50 m → 5 ; 18 m → 60 ; 1,5 km → 5 000).
2. **La classe porte la liste de sorts.** Les classes, les lignages d'espèce, les dons et les objets citent des sorts. Si les sorts citaient aussi leurs classes, les références formeraient un cycle, et aucun lot ne pourrait se construire seul. `ClassData.spell_list` (lots 2 et 3) alimentera la table `spell_class`. Le SRD donne d'ailleurs ces listes par classe (« Liste des sorts de Barde »). L'extracteur garde la liste de classes lue dans l'en-tête, mais seulement pour le test qui la comparera aux listes des classes, aux lots 2 et 3. Il l'écrit dans `tools/srd_builder/extract/spell_classes.tsv`.
3. **Extraction en Dart, à partir de `pdftotext`.**
   - **Commande :** `srd_builder extract-spells --text <fichier> --out sources/spell`. Le fichier est produit par `pdftotext -enc UTF-8 FR_SRD_CC_v5.2.1.pdf`.
   - **Nettoyage :** l'outil retire :
     - les lignes de pied de page `<n> Document de Référence du Système 5.2.1` ;
     - les numéros de page seuls ;
     - les sauts de page.
   - **Raccords :** il recolle une ligne à la suivante si elle se termine par un trait d'union suivi d'une minuscule (« mini-/male » devient « minimale »), ou si elle ne se termine pas par une ponctuation de fin de phrase et que la suivante commence par une minuscule.
   - **Découpage :** un sort commence au nom qui précède l'en-tête d'école et s'arrête au nom du sort suivant ; le dernier s'arrête au titre de la section suivante.
   - **Rapport :** l'outil écrit la liste des raccords effectués dans un rapport, pour la relecture.
   - **Alternative écartée :** découper les colonnes du fichier à mise en page par position de caractère, trop fragile (colonnes de largeur variable).
4. **Slugs anglais par table.** `tools/srd_builder/extract/spell_slugs.tsv` associe chaque nom français au slug du nom officiel anglais du SRD 5.2.1 (`Boule de feu → fireball`). Elle est écrite et relue une fois. L'extraction échoue si un sort n'y figure pas, ou si un slug est en double.
5. **Composants matériels.** Le coût est lu dans « d’une valeur minimale de N po » (ou pa, pc) et converti en pc. « que le sort détruit » ou « consumé » donne `material_consumed: true`.
6. **Texte.** `text.fr` reprend tout ce qui suit la ligne de métadonnées, paragraphes séparés par `\n`, y compris « Emplacement de niveau supérieur. » et « Amélioration de sort mineur. ». Il est copié sans retouche : seuls les raccords de la décision 3 s'appliquent.
7. **Base.** `PackStore` écrit `range` et `components` en JSON dans la table `spell`, le reste en colonnes ; l'export reconstruit `SpellData`. Pas de changement de schéma, donc pas de nouvelle version.

## Risks / Trade-offs

- [Raccord erroné (deux paragraphes collés, ou un mot composé dont le trait d'union tombe en fin de ligne)] → le rapport de raccords est relu. Des sorts témoins sont vérifiés mot pour mot contre le PDF : Boule de feu, Bénédiction, Rappel à la vie, Souhait, Aspersion acide, Bouclier. Une erreur reste corrigeable en relançant l'extraction.
- [Slug anglais erroné] → c'est un identifiant, pas un texte de règles : une erreur ne change aucun calcul. La table est triée par niveau et école pour faciliter la relecture.
- [Taille du pack] → environ 339 textes, soit 300 à 400 Ko de JSON ; l'archive reste très en dessous de 20 Mo.
