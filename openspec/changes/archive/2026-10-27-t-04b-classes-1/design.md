# Design

## Context

Les sources du Guerrier (M0) donnent le modèle :
- **Classe :** `class/fighter.json` porte les traits de base et 20 niveaux (`proficiency_bonus`, `features`, `columns`).
- **Aptitudes :** chacune est une entité `feature`, avec `source` (classe ou sous-classe), `level`, `effects` et `text.fr`.
- **Sous-classe :** `subclass/champion.json` cite ses aptitudes.

L'inventaire de M0 (`docs/dsl/INVENTAIRE_APTITUDES.md`) prévoit les effets de chaque aptitude. Le lot 1 a laissé `extract/spell_classes.tsv` : les classes lues dans l'en-tête de chacun des 339 sorts.

Le texte du PDF est utilisé sous deux formes :
- **en ordre de lecture :** il donne bien les paragraphes des aptitudes, mais mêle les colonnes des tableaux ;
- **en mise en page (`docs/srd/FR_SRD_CC_v5.2.1.txt`) :** il donne les tableaux ligne par ligne.

Motivation : proposal.md.

## Goals / Non-Goals

**Goals:**
- Textes d'aptitude extraits, jamais retapés ; effets saisis à la main et relus contre l'inventaire et le SRD.
- Une extraction relançable sans perdre les effets saisis.

**Non-Goals:**
- Pas de calcul nouveau dans `dnd_rules` : les colonnes d'incantation sont des données pour US-09.
- Pas d'équipement de départ (lot 4).

## Decisions

1. **`ClassData`** gagne `spell_list` (liste de `ContentId`, vide par défaut) et `spellcasting_ability` (`ContentId?`). Une référence de `spell_list` doit viser un `spell` : le contrôle de type des références de `validatePack` l'impose déjà, la règle est déclarée avec les autres.
2. **Colonnes entières, conventions de nommage.**
   - **Valeurs :** `ClassLevelData.columns` reste `Map<String, int>`, pour ne pas toucher le moteur (`dnd_rules` lit `weapon_mastery`). Un dé est stocké par son nombre de faces, avec le suffixe `_die` : `bardic_die: 8`. Un bonus est stocké par sa valeur : `rage_damage: 2`.
   - **Colonnes propres :** `rages`, `rage_damage`, `weapon_mastery`, `bardic_die`, `channel_divinity`, `wild_shape`, `sorcery_points`.
   - **Lanceurs de sorts :** `cantrips`, `prepared_spells` et `slot_1` à `slot_9`. Un emplacement absent (« — ») n'est pas écrit.
3. **Extraction des aptitudes : `extract-features`.**
   - **Section :** elle va du titre de la classe (« Barbare », seul sur sa ligne après « Classes ») à la classe suivante.
   - **Aptitudes :** une aptitude commence à une ligne `Niveau N : Nom` et s'arrête à la suivante, ou au titre « Sous-classe de … : … ». La sous-classe suit la même règle.
   - **Nettoyage :** l'outil réutilise `cleanText` du lot 1 (pieds de page, raccords consignés).
   - **Slugs :** `extract/feature_slugs.tsv` (`classe<TAB>niveau<TAB>nom<TAB>slug`) donne le slug. Une aptitude qui revient sous le même nom à deux niveaux (Coup brutal amélioré, 13 et 17) se distingue par son niveau.
   - **Fusion :** si le fichier de l'aptitude existe, seuls `name` et `text` sont remplacés, et `data` et `effects` sont gardés. S'il est nouveau, il est créé avec `data: {source, level}` et sans effet.
   - **Rapport :** un rapport liste les aptitudes créées et les raccords effectués.
4. **Effets saisis à la main**, selon l'inventaire.
   - **Ce qui est saisi :** seules les parties calculables (C) et à utilisations (R) portent des effets ; les parties descriptives restent du texte.
   - **Formes répétées :** les aptitudes répétées d'une classe à l'autre gardent la forme du Guerrier, par exemple Amélioration de caractéristique : `grant_feat` `category: general`, `when.level`.
   - **Valeurs non représentables :** une valeur que le DSL v1 ne sait pas exprimer reste descriptive. Exemple : un maximum égal au modificateur de Charisme, si `max` ne prend pas `ability_mod`. Elle est listée dans le rapport de PR, sans opération inventée.
5. **Table de progression saisie depuis la mise en page.** Pour chaque classe, les 20 lignes de la table (bonus de maîtrise, aptitudes, colonnes) sont relues dans le texte en mise en page, puis écrites dans `class/<slug>.json`. Les emplacements des cinq lanceurs complets du lot suivent la même table du SRD. Un test vérifie la table complète d'un lanceur (Magicien), et le niveau 20 de chacun.
6. **Liste de sorts depuis les en-têtes.** `spell_list` de chaque classe est écrite depuis `extract/spell_classes.tsv` (classes citées par l'en-tête de chaque sort). Un test vérifie que les deux concordent pour chaque classe, et donc que chaque sort de la classe apparaît dans sa liste.
7. **Base.** `PackStore` écrit `spell_list` dans la table `spell_class(spell_id, class_id)` (§11.1) et la relit à l'export, triée par identifiant. `spellcasting_ability` va dans une nouvelle colonne nullable `spellcasting_ability_id` de `player_class`. Le schéma v1 n'est pas encore publié (aucune base utilisateur) : la colonne s'ajoute à la v1, et l'instantané `drift_schemas` est régénéré, comme pour `entity_count` en US-04.

## Risks / Trade-offs

- [Volume : environ 130 aptitudes à relire] → les textes sont extraits, pas retapés. Les effets sont relus aptitude par aptitude contre l'inventaire, et des tests vérifient une aptitude calculable par classe.
- [Table de progression mal recopiée] → un test vérifie les colonnes témoins par classe, et le niveau 20 de chaque lanceur.
- [Écarts du SRD français (titres différents entre table et section)] → l'aptitude prend le titre de sa section, et l'écart est signalé dans la PR.
