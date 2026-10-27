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
- Types v1 : `ability`, `skill`, `language`, `condition`, `damage-type`, `mastery`, `weapon`, `armor`, `tool`, `item`, `background`, `species`, `feat`, `class`, `subclass`, `feature`, `spell` (ajouté par T-04).
- `spell` :
  - `level` : 0 pour un sort mineur, jusqu'à 9 ;
  - `school` : `abjuration`, `conjuration`, `divination`, `enchantment`, `evocation`, `illusion`, `necromancy` ou `transmutation` ;
  - `casting_time` et `duration` : texte du SRD, recopié tel quel (les distances d'un déclencheur de réaction y restent en mètres, comme dans le texte de règles) ; `ritual` et `concentration` : booléens ;
  - `range` : `{kind: self | touch | feet | sight | unlimited | special, feet}` (`feet` seulement pour `kind: feet`, en pieds) ;
  - `components` : `{verbal, somatic, material?}` ; `material_cost_cp?` ; `material_consumed`.
  - Un sort ne cite pas ses classes : la classe porte sa liste de sorts.
- `data` : champs propres au type, **tout champ inconnu rend l'entité invalide**.
- `effects` : opérations du DSL v1 uniquement.
- `text.fr` : texte de règles copié du document source ; obligatoire pour `feature`, `condition`, `feat`, `mastery`, `background`, `spell`.
- Le type `resource` est réservé aux clés de ressources (`srd:resource:second-wind`) : ce n'est jamais une entité.

## Contrôles à la construction et à l'import

- identifiants uniques, toute référence résolue dans le pack ou ses dépendances, type de la cible conforme ;
- Historique : exactement 3 caractéristiques ; son don d'origine est de catégorie `origin` (cahier §11.3) ;
- à la lecture de l'archive (`readDndpack`, ENF-09) : archive et chaque fichier décompressé ≤ 20 Mo, `entity_count` exact, identifiants uniques, ≤ 10 000 entités, profondeur JSON ≤ 32, somme de contrôle exacte, `format_version` connue. Un pack n'exécute jamais de code.
- à l'import (M4) : `validatePack(pack, dependencies: …)` vérifie en plus les références, avec les packs dont il dépend.
