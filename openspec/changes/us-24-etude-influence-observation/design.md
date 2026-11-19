# Design

## Lot a

### Format et pack

- **`RuleData`** (`dnd_content`) remplace `EmptyData` pour le type `rule` :
  - `study_skills` : `Map<CreatureType, ContentId>` ;
  - `influence_checks` : `List<InfluenceCheck>`, où `InfluenceCheck` porte `{id, ability, skill, creature_types}`.

  Les deux tables sont vides par défaut. Leurs ids sont relevés par le parcours des références de `validatePack`, avec les types `skill` et `ability`.
- **Sources** : `rule/study.json` et `rule/influence.json`.
  - Leur texte est celui du glossaire du SRD (« Étude [Action] » et « Influence [Action] »).
  - Leurs données recopient les tables « Domaines de savoir » et « Tests d'Influence ».
  - Les ids des façons d'interagir sont `intimidate`, `persuade`, `perform`, `deceive` et `handle`.
- **`FORMAT_DNDPACK.md`** décrit les `data` d'une `rule`.
- **Base locale, schéma v2**, décision du porteur de projet du 19 novembre : la colonne nullable `rule_term.data` (JSON) garde les tables à l'import et les rend à l'export.
  - Première migration Drift : `addColumn`, l'instantané `drift_schema_v2.json` et le test de montée v1 → v2.
  - La table est locale et non synchronisée.

### Moteur (`dnd_rules`, `actions.dart`)

- **Lecture des tables** : `studySkills(ActiveContent)` et `influenceChecks(ActiveContent)` lisent les tables de la dernière entité `rule` du contenu actif qui en porte. Un pack homebrew remplace ainsi l'entité du SRD.
- **Suggestion** : `suggestedStudySkill(content, CreatureType?)`.
- **Paliers** : `reachedTiers(List<int> dcs, int total)` rend les indices des paliers atteints.
- **Événements** : `study`, `influence` et `observation` s'ajoutent à `CombatEventType`. La projection les ignore : ce sont des traces pour le journal (US-25).

### Écran (`action_assistant.dart`)

- **Ouverture** : une icône dans la barre du combat, « Étude · Influence · Observation », ouvre une feuille à onglets. Le lot a ne remplit que l'onglet Étude.
- **Acteur** : un PJ du combat, par défaut le PJ actif, sinon le premier.
- **Cible** : un combattant non PJ, par défaut la cible sélectionnée.
- **Bonus** : la fiche de l'acteur est relue (`characterStore.load`, puis `computeSheet` avec son Épuisement) pour lire `skills`.
- **Type de créature** de la cible : le profil du monstre (`refId`), ou celui du PNJ (`monsterId`).
- **Résultat** : `SimpleRoll` sur `d20 + bonus`.
- **Paliers** : ceux du PNJ (`Npc.hiddenInfo`), avec « Atteint : sera révélée » ou « Non atteint : reste cachée ».
- **Valider** écrit l'événement `study`, puis `NpcStore.update(hiddenInfo:)` marque les paliers atteints.

## Choix

- **Tables dans une entité `rule`** : c'est la décision du porteur de projet. Un type de plus aurait alourdi la validation à l'import (M4).
- **Événements sans effet sur la projection** : l'état du combat ne dépend pas d'une Étude. Le journal les lira, et l'annulation n'a pas lieu d'être.
- **Révélation écrite sur le PNJ** : elle persiste hors du combat, et la fiche du PNJ la montre déjà (US-18).
