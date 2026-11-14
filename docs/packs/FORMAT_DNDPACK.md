# Format des packs de contenu (`.dndpack`) — version 1

Statut : **validé** par le porteur de projet le 25 octobre 2026 (US-02). Une fois un pack publié, un champ ne change plus de sens ; une évolution incompatible passe par `format_version: 2`.

Sources : cahier §7, §10.3, §11.1, ENF-09 ; DSL des effets : `docs/dsl/DSL_V1.md`.

## Sources d'un pack (dépôt)

```
tools/srd_builder/sources/
  pack.json                 métadonnées du manifeste (sans entity_count ni checksum ;
                            format et format_version facultatifs)
  <type>/<slug>.json        une entité par fichier ; le dossier = son type, le nom = son slug
```

## Archive

Un `.dndpack` est une archive zip qui contient exactement :

| Fichier | Contenu |
|---|---|
| `manifest.json` | le manifeste ci-dessous |
| `entities.json` | la liste des entités, triée par identifiant |

L'archive est **déterministe** : mêmes sources, mêmes octets (ordre des fichiers et horodatage fixes, JSON indenté de 2 espaces).

## Manifeste

| Champ | Type | Règle |
|---|---|---|
| `format` | chaîne | toujours `dndpack` |
| `format_version` | entier | `1` |
| `id` | UUID | stable d'une version à l'autre du même pack |
| `namespace` | chaîne | préfixe des identifiants du pack (`srd`, `ines`…) |
| `name` | chaîne | nom affiché |
| `version` | semver | `1.0.0` |
| `origin` | `srd` / `local` / `imported` | cahier §11.1 |
| `author` | chaîne | |
| `licence` | chaîne | obligatoire (cahier §1.3) ; `CC-BY-4.0` pour le SRD |
| `attribution` | chaîne | pour `origin: srd`, déclaration du cahier §1.3 **mot pour mot** |
| `dsl_version` | entier | `1` |
| `locale` | chaîne | `fr` |
| `dependencies` | liste | `{id, version_range}` (cahier §11.1 `pack_dependency`) |
| `entity_count` | entier | calculé au build |
| `checksum` | chaîne | `sha256:<hex>` des octets de `entities.json` |

La signature Ed25519 (`signature`, `author_public_key`) arrive en M4 (EF-HB-05).

## Entité

```json
{
  "id": "srd:feat:defense",
  "type": "feat",
  "name": "Défense",
  "extends_id": null,
  "data": { "category": "fighting_style", "prerequisites": { "feature": "fighting_style" }, "repeatable": false },
  "effects": [ { "op": "modify_ac", "value": 1, "when": { "armor": "any" } } ],
  "text": { "fr": "Tant que vous portez une armure légère, intermédiaire ou lourde, vous recevez un bonus de +1 à la Classe d'armure." }
}
```

- `id` : `{namespace}:{type}:{slug}` ; le `type` de l'id est celui de l'entité. Les slugs `con`, `prn`, `aux`, `nul`, `com1`-`com9`, `lpt1`-`lpt9` sont interdits (noms réservés sous Windows).
- Types v1 : `ability`, `skill`, `language`, `condition`, `rule`, `damage-type`, `mastery`, `weapon`, `armor`, `tool`, `item`, `magic-item`, `background`, `species`, `feat`, `class`, `subclass`, `feature`, `spell`, `monster` (`spell` et `magic-item` ajoutés par T-04, `monster` par T-06).
- `magic-item` :
  - `category` : `wondrous`, `armor`, `weapon`, `ring`, `wand`, `staff`, `potion`, `scroll` ou `rod` ;
  - `rarity` : `common`, `uncommon`, `rare`, `very_rare`, `legendary`, `artifact`, ou `varies` quand elle dépend de la variante ;
  - `type_line` : ligne de type du SRD, recopiée telle quelle ;
  - `attunement` : harmonisation requise ; `attunement_by?` : créature exigée (« un Magicien »).
- `spell` :
  - `level` : 0 pour un sort mineur, jusqu'à 9 ;
  - `school` : `abjuration`, `conjuration`, `divination`, `enchantment`, `evocation`, `illusion`, `necromancy` ou `transmutation` ;
  - `casting_time` et `duration` : texte du SRD, recopié tel quel (les distances d'un déclencheur de réaction y restent en mètres, comme dans le texte de règles) ; `ritual` et `concentration` : booléens ;
  - `range` : `{kind: self | touch | feet | sight | unlimited | special, feet}` (`feet` seulement pour `kind: feet`, en pieds) ;
  - `components` : `{verbal, somatic, material?}` ; `material_cost_cp?` ; `material_consumed`.
  - Un sort ne cite pas ses classes : la classe porte sa liste de sorts.
- `monster` : profil de jeu, recopié tel qu'imprimé (rien n'est recalculé), distances en pieds :
  - `sizes` : `tiny`, `small`, `medium`, `large`, `huge`, `gargantuan` (une liste, pour « de taille M ou P ») ; `swarm_size?` : taille des créatures d'une nuée (« Nuée de taille G de Bêtes de taille TP » : `sizes` = `[large]`, `swarm_size` = `tiny`) ;
  - `creature_type` : `aberration`, `beast`, `celestial`, `construct`, `dragon`, `elemental`, `fey`, `fiend`, `giant`, `humanoid`, `monstrosity`, `ooze`, `plant` ou `undead` ; `type_tags` : texte entre parenthèses (« Démon ») ; `alignment` : texte ;
  - `ac`, `ac_note?` (texte qui suit la CA), `initiative` (bonus), `hp`, `hit_dice` (« 2d8 + 2 ») ;
  - `speed` : `{walk?, swim?, fly?, climb?, burrow?}` ; `hover` : vol stationnaire ; `speed_note?` : partie imprimée de la ligne Vitesse que les nombres ne portent pas (« 12 m (forme de loup uniquement) ») ;
  - `abilities` et `saving_throws` : les six clés `str`, `dex`, `con`, `int`, `wis`, `cha` (valeurs, puis JS imprimés) ;
  - `skills` : `{id de compétence: bonus}` ;
  - `vulnerabilities`, `resistances`, `immunities` : types de dégâts ; `condition_immunities` : états ; `gear` : ligne « Équipement », une entrée par objet ;
  - `senses` : `{darkvision?, blindsight?, blind_beyond?, tremorsense?, truesight?}` ; `senses_note?` : précision imprimée d'un sens (« Vision dans le noir 36 m (perce les Ténèbres magiques) ») ; `passive_perception` ; `languages` : ligne « Langues », en texte ;
  - `cr` : chaîne (`"0"`, `"1/8"`, `"1/4"`, `"1/2"`, `"1"`…`"30"`) ; `xp`, `xp_lair?`, `proficiency_bonus` ; `legendary_uses?`, `legendary_uses_lair?` ;
  - `actions` : liste ordonnée de `{kind, name, uses?, attack?, save?, text}`, avec `kind` = `trait`, `action`, `bonus`, `reaction` ou `legendary` ; `uses` = `{per_day, per_day_lair?}`, `{recharge: "5-6"}` ou `{rest: "short_or_long"}` ; `attack` = `{kind: melee | ranged | melee_or_ranged, bonus, reach?, range?: [normale] ou [normale, longue], damage: [{average, dice?, type}]}` ; `save` = `{ability, dc}`. `text` reste la référence de règles.
- `data` : champs propres au type, **tout champ inconnu rend l'entité invalide**.
- `effects` : opérations du DSL v1 uniquement.
- `class` (champs ajoutés par T-04 et US-05) :
  - `primary_abilities_any` : l'une des `primary_abilities` suffit (Guerrier : Force ou Dextérité) ; faux par défaut, toutes sont alors requises (Moine : Dextérité et Sagesse) ;
  - `spell_list` : identifiants des sorts de la classe ;
  - `spellcasting_ability` : caractéristique d'incantation ;
  - `tool_proficiencies` : outils maîtrisés d'office ;
  - `tool_choice_count` et `tool_choice_category` : outils à choisir dans une catégorie.
  - `prepared_change` : façon de changer ses sorts préparés, `long_rest_all`, `long_rest_one` ou `level_up_one`.
  - `multiclass` : ce que reçoit un personnage dont ce n'est pas la classe de départ, en plus du dé de vie et des aptitudes de niveau 1 : `weapon_proficiencies`, `armor_training`, `tool_proficiencies`, `skill_choice_count`, `tool_choice_count` et `caster_divisor` (1 : tous les niveaux comptent dans le niveau de lanceur, 2 : la moitié, 0 : aucun). Absent, le bloc n'accorde rien.
  - `weapon_proficiencies` : `simple`, `martial`, ou une partie des armes de guerre : `martial_light` (Moine) ou `martial_finesse_or_light` (Roublard).
  - `starting_equipment` : options d'équipement de départ dans l'ordre du SRD (A, B, C). Chaque option porte :
    - `items` : `{item, quantity}`, où `item` est une arme, une armure, un outil ou un objet (« 20 flèches » donne l'objet « Flèches (20) » × 1) ;
    - `tool_choice` : catégories d'outil, dans lesquelles on choisit un outil (`musical_instrument` pour le Barde) ;
    - `gold` : pièces d'or.

  Dans `levels[].columns`, toutes les valeurs sont des entiers. Le suffixe de la colonne dit comment lire la case de la table :
  - `_die` : le nombre de faces d'un dé (`bardic_die: 8`, `martial_arts_die: 6`) ;
  - `_dice` : le nombre de dés (`sneak_attack_dice: 2`) ;
  - `_feet` : une distance en pieds (`unarmored_movement_feet: 10` pour « +3 m »).

  Un bonus est noté par sa valeur (`rage_damage: 2`). Les emplacements de sort sont `slot_1` à `slot_9`, avec `cantrips` et `prepared_spells`. Une case « — » de la table n'est pas écrite.
- `text.fr` : texte de règles copié du document source ; obligatoire pour `feature`, `condition`, `rule`, `feat`, `mastery`, `background`, `spell`, `magic-item`.
- Le type `resource` est réservé aux clés de ressources (`srd:resource:second-wind`) : ce n'est jamais une entité.

## Contrôles à la construction et à l'import

- identifiants uniques, toute référence résolue dans le pack ou ses dépendances, type de la cible conforme ;
- Historique : exactement 3 caractéristiques ; son don d'origine est de catégorie `origin` (cahier §11.3) ;
- Monstre : `cr`, `xp` et `proficiency_bonus` concordent avec les tables « Points d'expérience par facteur de puissance » et « Bonus de maîtrise par facteur de puissance » du SRD ; une action `legendary` exige `legendary_uses` ; un `uses` porte un seul usage ; une attaque au corps à corps a une allonge, une attaque à distance une portée `[normale, longue]` ;
- à la lecture de l'archive (`readDndpack`, ENF-09) : archive et chaque fichier décompressé ≤ 20 Mo, `entity_count` exact, identifiants uniques, ≤ 10 000 entités, profondeur JSON ≤ 32, somme de contrôle exacte, `format_version` connue. Un pack n'exécute jamais de code.
- à l'import (M4) : `validatePack(pack, dependencies: …)` vérifie en plus les références, avec les packs dont il dépend.
