# Design

## Context

- `_activeEffects` retient une option de `choice` quand un choix cite une entité de l'option (`effectReferences`). Une option sans entité (Protecteur : armes de guerre, armures lourdes) ne peut pas être choisie.
- Les choix de `CharacterInput` sont `choices` (par identifiant de `choice`), `classLevels[].skillChoices`, `feats` et `weaponMasteries`.

Motivation : proposal.md.

## Goals / Non-Goals

**Goals:**
- Une seule logique de choix : ce qui vient du pack, homebrew compris, s'affiche sans code propre à une classe.

**Non-Goals:**
- Pas de sorts dans ce change.

## Decisions

1. **`labels` de `choice`** : liste facultative de noms, une par option. Le moteur retient une option si un choix vaut son nom, ou s'il cite une de ses entités. Le nom d'une option sans `labels` vient de l'entité qu'elle cite.
2. **`openChoices(content, sources)`** (`dnd_rules`) : parcourt les effets des entités `sources` dont `when.level` est atteint au niveau 1, et renvoie chaque `choice` (`OpenChoice` : id, source, nombre, options `{pick, label, expertise}`).
3. **Sources :** aptitudes de niveau 1 de la classe, traits de l'espèce, don d'origines choisi pour Polyvalent.
4. **Déjà acquis :** l'étape calcule les entités connues (compétences de l'Historique et de la classe, Commun et langues choisies).
   - Une option qui accorde une maîtrise déjà acquise est grisée.
   - Une option d'Expertise exige au contraire la compétence.
5. **Brouillon :** `classSkills`, `classTools`, `masteries`, `fightingStyle`, `originFeat`, `choices`. Changer de classe efface les choix de la classe, changer d'espèce efface le don de Polyvalent : leurs options ne sont plus les mêmes, et l'étape repasse « À refaire ». Changer d'Historique les garde : `Subchoice.invalid` signale une maîtrise devenue doublon.
6. **Bottes :** `masterySlots(content, classId)` lit `grant_mastery_slots` au niveau 1. Une arme est proposée si `coversWeapon` l'accepte et si `melee_only` ne l'exclut pas.
7. **Disposition :** sections empilées, panneau « À compléter » à droite sur grand écran. Sur téléphone, la raison du blocage donne le choix manquant.

## Risks / Trade-offs

- **Noms français comme valeurs de choix** → un nom d'option change avec le pack ; acceptable, le pack est versionné et le schéma v1 n'est pas publié.
- **Étape longue pour un Roublard humain** → sections repliées hors périmètre, à revoir à l'usage.
