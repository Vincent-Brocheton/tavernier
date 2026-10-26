# Design

## Context

`dnd_rules` ne contient qu'un test de fumée et les fixtures [D1]. `dnd_content` fournit déjà les entités typées (`ContentEntity`, `ClassData`, `WeaponData`…), le DSL v1 validé (`Effect`, `abilityIdByCode`) et le chargement des sources (`srd_builder` : `loadSources`). Le pack SRD de l'échantillon contient tout ce que cite `aldric_n1.json`. Motivation : voir proposal.md.

## Goals / Non-Goals

**Goals:**
- Un seul point d'entrée `computeSheet(CharacterInput, ActiveContent) → ComputedSheet`, sans `dart:io`.
- La fiche sérialisée a la forme du bloc `expected` des fixtures, pour que le test compare directement.

**Non-Goals:**
- Pas de moteur générique de règles : seules les opérations du DSL utilisées au niveau 1 sont interprétées (voir proposal.md).
- Pas de persistance du personnage (US-04 et M1).

## Decisions

1. **Entrée = format `input` des fixtures.** `CharacterInput` (freezed + json_serializable, champs inconnus refusés, comme `dnd_content`) lit exactement ce que stockera la base : bases, répartition d'Historique, niveaux de classe, dons et leur source, bottes, objets, choix. Alternative écartée : un modèle propre au moteur et un convertisseur, une couche de plus sans besoin.
2. **Choix stockés par identifiant de choix** : `choices: {"skillful": ["srd:skill:insight"]}` pour l'espèce et la classe ; les choix d'un don dans son instance (`feats[].choices`), pour les dons répétables. L'option retenue est celle dont les effets citent l'identifiant choisi. Les choix sans référence (Amélioration de caractéristique) arrivent avec la montée de niveau (M1). Conséquence : `aldric_n1.json` remplace `species_choices.skillful_skill` par `choices.skillful`, et la ressource « Inspiration héroïque » prend sa clé `srd:resource:heroic-inspiration` ; les valeurs attendues ne changent pas.
3. **Effets actifs = liste `(source, Effect)`** collectée une fois : traits de l'espèce, dons du personnage, aptitudes de classe jusqu'au niveau atteint, options de `choice` retenues. Chaque calcul filtre cette liste par opération et par condition `when` (armure, bouclier, niveau). La source devient le libellé de la contribution (EF-PJ-03).
4. **Valeur calculée = `Computed(value, sources)`** où `sources` est la liste `(libellé, valeur)` ; la somme des contributions égale la valeur. Les libellés suivent les fixtures : `base`, code de caractéristique (`dex`, `con`), sinon l'identifiant de l'entité.
5. **Codes de caractéristique** : le DSL et la fiche parlent en codes (`str`…), le contenu en identifiants ; la correspondance unique est `abilityIdByCode` de `dnd_content`.
6. **Erreurs d'intégrité, jamais d'exception** : `IntegrityError(rule, path, message)` avec `rule` ∈ `abilityGeneration`, `backgroundBonus`, `featGrant`, `weaponMastery`, `multiclass`, `choice`, `reference`. La fiche reste calculée avec ce qui est lisible ; une référence introuvable neutralise seulement la contribution concernée.
7. **Contenu actif** : `ActiveContent` indexe par identifiant les entités d'une liste de `ContentPack` (cahier §11.2 `table_pack`). Les tests chargent le vrai pack SRD depuis `tools/srd_builder/sources` via `loadSources` (dépendance de test seulement), et construisent en mémoire les quelques entités absentes de l'échantillon (seconde classe pour le multiclassage, classe sans armes de guerre).

## Risks / Trade-offs

- [Interpréteur partiel du DSL] → une opération non interprétée est ignorée sans erreur ; un test vérifie que chaque opération utilisée par l'échantillon M0 a un effet sur la fiche, pour qu'aucune ne soit oubliée en silence.
- [Format d'entrée figé par les fixtures avant la base Drift] → US-04 reprend ces champs pour `character_*` (§11.2) ; un écart se corrigera dans la fixture, jamais dans les valeurs attendues.
- [Libellés de décomposition en identifiants] → l'interface traduira les identifiants en noms (M1, US-07) ; le moteur ne porte aucun texte d'interface (règle « aucune chaîne en dur »).
