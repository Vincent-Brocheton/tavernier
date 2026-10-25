# DSL d'effets — version 1 (proposition)

Statut : **proposition à valider** par le porteur de projet (T-02). Elle fixe une partie du format des packs (`dsl_version: 1` dans le manifeste) ; une fois un pack publié, une opération ne change plus de sens, on en ajoute.

Sources : cahier §10.3 (liste fermée, opération inconnue = entité invalide), §14.1 (calculable / compteur / descriptif), inventaire `INVENTAIRE_APTITUDES.md`.

## Principes

1. **Liste fermée.** Le validateur de `dnd_content` rejette toute entité dont un effet porte un `op` absent de cette liste, ou un champ inconnu. Un pack n'exécute jamais de code (ENF-09).
2. **Trois niveaux** pour chaque aptitude :
   - **calculable** : modifie une valeur de la fiche (EF-PJ-02) → opérations « Calcul » ;
   - **compteur** : utilisations à suivre et à récupérer au repos (EF-PJ-11, 12) → `grant_resource` ;
   - **descriptif** : texte seul, affiché sur la fiche, jamais calculé. **Toujours accepté**, y compris en homebrew.
   Une aptitude peut combiner les trois (ex. Second souffle : compteur + texte).
3. **Sources tracées.** Chaque effet appliqué ajoute une contribution `{source, valeur}` à la valeur touchée : c'est la décomposition d'EF-PJ-03. La source est l'entité porteuse (`srd:feat:defense`, `srd:class:fighter`…).
4. **Conditions statiques seulement.** Un effet peut dépendre de l'équipement porté (`armor`, `shield`) ; jamais d'un état de combat (Rage active, sort lancé). Ces bonus conditionnels restent descriptifs en v1 et sont signalés comme tels sur la fiche.
5. **Valeurs** : un entier, ou une expression fermée parmi `{"ref": "proficiency_bonus"}`, `{"ref": "class_level", "class": id}`, `{"ref": "character_level"}`, `{"ref": "ability_mod", "ability": a, "min": n}`, ou une table par niveau `{"by_level": {"1": 2, "4": 3}}` (dernier palier atteint).

## Enveloppe

```json
{ "op": "<opération>", "when": { "level": 3, "armor": "any|none|heavy|not_heavy", "shield": true|false }, ... }
```

`when` est facultatif. `level` = niveau de la classe porteuse (aptitudes de classe) ou du personnage (espèces, dons).

## Opérations

### Caractéristiques et maîtrises

| op | Champs | Exemple SRD |
|---|---|---|
| `ability_bonus` | `ability`, `value`, `max` (20 par défaut) | Champion primitif : FOR +4, CON +4, max 25 |
| `grant_proficiency` | `kind` (`skill`, `tool`, `weapon`, `weapon_category`, `armor`, `saving_throw`, `language`), `ref` | Soldat : `skill` Athlétisme ; Ordre divin Protecteur : `armor` lourdes |
| `grant_expertise` | `ref` (compétence déjà maîtrisée) | Érudition, Expertise |
| `grant_feat` | `feat` ou `category` (`origin`, `general`, `fighting_style`, `epic_boon`) | Style de combat ; Amélioration de caractéristique |

### Défense, vitesse, PV, sens

| op | Champs | Exemple SRD |
|---|---|---|
| `modify_ac` | `value` | Défense : +1, `when.armor: any` |
| `ac_formula` | `base`, `abilities[]`, `allows_shield` | Défense sans armure (Barbare) : 10 + DEX + CON, bouclier permis |
| `modify_speed` | `mode` (`walk`, `climb`, `swim`, `fly`), `value` (pieds) ou `equal_to: walk` | Déplacement rapide : +10 ; Monte-en-l'air : escalade = vitesse |
| `modify_hp_max` | `per_level` et/ou `flat` | Ténacité naine : +1 par niveau ; Résistance draconique : +3 puis +1 par niveau |
| `grant_sense` | `sense` (`darkvision`, `blindsight`, `tremorsense`, `truesight`), `range` (pieds) | Nain : Vision dans le noir 120 |
| `grant_defense` | `kind` (`resistance`, `immunity`), `damage_type` ou `condition` | Résistance naine : poison ; Protégé de dame Nature : immunité Empoisonné |

### Jets et attaques

| op | Champs | Exemple SRD |
|---|---|---|
| `modify_initiative` | `add` (valeur), `advantage` | Vigilant : `add: {ref: proficiency_bonus}` ; Athlète accompli : `advantage: true` |
| `grant_advantage` | `on` (`saving_throw:<a>`, `skill:<s>`, `initiative`, `death_saves`), `except_condition` | Sens du danger : JS DEX, sauf état Neutralisé |
| `modify_check` | `scope` (`unproficient_ability_checks`, `skill:<s>`), `add` | Touche-à-tout : moitié de la maîtrise ; Ordre divin Thaumaturge : SAG à Arcanes et Religion |
| `set_attacks_per_action` | `count` | Attaque supplémentaire : 2 |
| `set_crit_range` | `min` | Critique amélioré : 19 |
| `grant_mastery_slots` | `count` (souvent `by_level`) | Guerrier : 3, puis 4 au niv. 4… |
| `modify_damage` | `value`, `scope` (`melee_weapon`, `unarmed`, `cantrip:<liste>`), `damage_type` | Frappes radiantes : +1d8 radiants au corps à corps |

### Ressources, sorts, objets

| op | Champs | Exemple SRD |
|---|---|---|
| `grant_resource` | `id`, `max` (valeur), `recharge` (`short_rest`, `long_rest`, `short_rest_partial`, `initiative`, `dawn`), `die` facultatif | Second souffle : `by_level {1:2, 4:3, 10:4}`, repos court (1) / long (tout) |
| `grant_spell` | `spell`, `always_prepared`, `free_casts` `{count, recharge}`, `ability` | Initié à la magie ; Châtiment de paladin ; lignage haut-elfe |
| `grant_spell_list_access` | `class_lists[]`, `count`, `max_level` | Secrets magiques, Découvertes magiques |
| `modify_attunement_slots` | `value` | Utilisation d'objets magiques : 4 |

### Choix

| op | Champs | Exemple SRD |
|---|---|---|
| `choice` | `id`, `count`, `options[]` (chaque option est une liste d'effets ou une référence), `replaceable_on` (`level_up`, `long_rest`, `short_rest`) | Compétent (1 compétence), Sens aiguisés, Ordre divin, Proie du chasseur |

Les incantations de classe (emplacements, sorts mineurs, préparés, magie de pacte, niveau de lanceur en multiclassage) ne passent **pas** par le DSL : ce sont des colonnes de `class_level` (cahier §11.1), calculées par le moteur.

## Hors v1 (descriptif, candidats v2)

Effets dépendant d'un état de combat (Rage, Sorcellerie innée active, Arme sacrée) ; remplacement de jet (Puissance indomptable, Savoir-faire) ; réactions ; transformations (Forme sauvage) ; tours supplémentaires (Réflexes de voleur). Ils sont affichés, et leurs utilisations suivies par `grant_resource` quand ils en ont.

## Couverture (inventaire SRD 5.2.1)

Voir `INVENTAIRE_APTITUDES.md` : 243 lignes (aptitudes de classe et de sous-classe, traits d'espèce, éléments d'Historique, dons). 116 ont une partie calculable, 53 une partie compteur, 87 sont uniquement descriptives. Toutes les parties calculables s'expriment avec les 22 opérations ci-dessus ou avec les colonnes de `class_level`, sous réserve des trois points à trancher en fin d'inventaire (Archerie, bonus liés à un état de combat, valeurs portées par la table de classe).
