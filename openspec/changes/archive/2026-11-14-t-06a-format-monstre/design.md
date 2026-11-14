## Context

Le SRD 5.2.1 français présente chaque profil de jeu ainsi (exemple : l'Aboleth, p. 272) :

- **En-tête** : « Aberration de taille G, Loyale Mauvaise ».
- **Défense et déplacement** : « CA 17 », « Initiative +7 (17) », « Pv 150 (20d10 + 40) », « Vitesse 3 m, nage 12 m ».
- **Caractéristiques** : un tableau For / Dex / Con / Int / Sag / Cha, avec valeur, MOD et JS.
- **Lignes facultatives** : Compétences, Vulnérabilités, Résistances, Immunités (dégâts, puis états), Équipement, Sens (et Perception passive), Langues.
- **Niveau** : « FP 10 (5 900 PX, ou 7 200 dans son antre ; BM +4) ».
- **Sections** : Traits, Actions, Actions Bonus, Réactions, Actions Légendaires (« Utilisations d'action Légendaire : 3 (4 dans son antre) »).
- **Usages** : « (2/jour) », « (Recharge 5–6) », « (Recharge après un Repos court ou long) ».
- **Attaques** : « Corps à corps : +9, allonge 4,50 m. Touché : 12 (2d6 + 5) dégâts contondants. ».
- **Effets à JS** : « JS Sagesse : DD 16 ».

Le cahier (§11.1, §11.3) prévoit `monster` (profil, type de créature, FP, PX, Intelligence) et `monster_action` (actions, légendaires, recharge). L'Intelligence est obligatoire, car elle sert au DD d'Influence.

## Decisions

Distances en pieds (1,5 m = 5 pieds), comme partout dans les packs. Références par identifiant de contenu quand une entité existe (`damage-type`, `condition`, `skill`).

```json
{
  "id": "srd:monster:aboleth",
  "type": "monster",
  "name": "Aboleth",
  "data": {
    "sizes": ["large"],
    "creature_type": "aberration",
    "type_tags": [],
    "alignment": "Loyale Mauvaise",
    "ac": 17,
    "ac_note": null,
    "initiative": 7,
    "hp": 150,
    "hit_dice": "20d10 + 40",
    "speed": { "walk": 10, "swim": 40 },
    "hover": false,
    "abilities": { "str": 21, "dex": 9, "con": 15, "int": 18, "wis": 15, "cha": 18 },
    "saving_throws": { "str": 5, "dex": 3, "con": 6, "int": 8, "wis": 6, "cha": 4 },
    "skills": { "srd:skill:history": 12, "srd:skill:perception": 10 },
    "vulnerabilities": [],
    "resistances": [],
    "immunities": [],
    "condition_immunities": [],
    "gear": [],
    "senses": { "darkvision": 120 },
    "passive_perception": 20,
    "languages": "profond ; télépathie 36 m",
    "cr": "10",
    "xp": 5900,
    "xp_lair": 7200,
    "proficiency_bonus": 4,
    "legendary_uses": 3,
    "legendary_uses_lair": 4,
    "actions": [
      { "kind": "trait", "name": "Résistance légendaire",
        "uses": { "per_day": 3, "per_day_lair": 4 },
        "text": "Si l'aboleth rate un jet de sauvegarde, il peut décider de le réussir tout de même." },
      { "kind": "action", "name": "Tentacule",
        "attack": { "kind": "melee", "bonus": 9, "reach": 15,
                    "damage": [ { "average": 12, "dice": "2d6 + 5", "type": "srd:damage-type:bludgeoning" } ] },
        "text": "Corps à corps : +9, allonge 4,50 m. Touché : 12 (2d6 + 5) dégâts contondants. Si la cible …" },
      { "kind": "action", "name": "Domination d'esprit",
        "uses": { "per_day": 2 },
        "save": { "ability": "wis", "dc": 16 },
        "text": "JS Sagesse : DD 16, une créature …" }
    ]
  },
  "text": { "fr": "…" }
}
```

- **Valeurs du profil, recopiées telles qu'imprimées** : JS des six caractéristiques, Initiative, Perception passive, PV moyens. On ne les recalcule pas : le lot c vérifiera leur cohérence (modificateur + BM), et un écart volontaire du SRD reste lisible.
- **`sizes`** : une liste, pour « de taille M ou P ». Valeurs : `tiny`, `small`, `medium`, `large`, `huge`, `gargantuan`.
- **`creature_type`** : `aberration`, `beast`, `celestial`, `construct`, `dragon`, `elemental`, `fey`, `fiend`, `giant`, `humanoid`, `monstrosity`, `ooze`, `plant`, `undead`. `type_tags` reprend le texte entre parenthèses (« Gobelinoïde »).
- **`ac_note`** : le texte qui suit la CA (« armure de cuir clouté, bouclier »). Le calcul de la CA d'un monstre homebrew ([E8]) viendra avec M4.
- **`cr`** : une chaîne (`"1/8"`, `"1/4"`, `"1/2"`, `"0"`…`"30"`). `xp` et `proficiency_bonus` sont imprimés ; la validation les compare à la table du SRD.
- **`actions`** : une liste ordonnée qui remplit `monster_action` (`position`, `kind`, `name`, `recharge`, `data`).
  - `kind` : `trait`, `action`, `bonus`, `reaction`, `legendary`.
  - `uses` : `per_day` (et `per_day_lair`), `recharge` (`"5-6"`) ou `rest` (`"short_or_long"`).
  - `attack` : facultatif, `kind` (`melee`, `ranged` ou `melee_or_ranged`), `bonus`, `reach` ou `range` (`[normale, longue]`) en pieds, et `damage` (moyenne, dés, type).
  - `save` : facultatif, `ability` et `dc`.
  - `text` reste la référence de règles : `attack` et `save` ne servent qu'aux automatismes du combat.
- **Hors `data`** : `text.fr` pour l'éventuelle description qui précède le profil. Il est facultatif.
- **Base locale** : `monster` reçoit `creature_type`, `cr`, `xp`, `intelligence` et le profil complet en JSON (`stat_block`). `monster_action` reçoit les actions, avec `recharge` en clair (`5-6`, `1/day`, `short_or_long`).
- **Validation** :
  - `cr`, `xp` et `proficiency_bonus` doivent concorder avec la table « Points d'expérience par FP » du SRD ;
  - les références de dégâts, d'états et de compétences doivent se résoudre ;
  - une action Légendaire exige `legendary_uses`.
- **Saisie manuelle des six monstres de [D1]** : elle fixe le format sur des cas réels (Ogre, Chef de bande avec Parade, Loup sanguinaire avec Tactique de meute) avant l'extracteur.

## Risks / Trade-offs

- **Format** : ajouter un type au format `.dndpack` est un engagement durable, puisque des packs homebrew le reprendront en M4. Les champs sont ceux du profil imprimé, sans calcul caché, pour rester stables.
- **Langues** : la ligne est gardée en texte (`languages`) et n'est pas reliée aux entités `language`. Elle mêle des langues, la télépathie et des mentions (« comprend … mais ne parle pas »). Une langue n'a pas d'effet de règle sur un monstre.
