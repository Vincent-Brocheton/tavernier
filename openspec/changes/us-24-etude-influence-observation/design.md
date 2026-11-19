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

## Lot b

- **Moteur** (`actions.dart`) :
  - `influenceDc(int?)`, `influenceMode(attitude)` et `influenceChecksFor(content, type)` ;
  - `InfluenceAttempt` et `influenceBlockedUntil(...)` : la fin de l'attente après le dernier échec du même acteur, de la même cible et de la même approche ;
  - `Combatant.attitude` vaut `indifferent` par défaut, puis prend l'`attitude` de la dernière `influence` qui le vise.
- **Données** : `CombatStore.watchTableEvents(tableId, type)` lit les événements de toutes les rencontres de la table, avec leur `created_at`.
- **Écran** : l'onglet Influence affiche :
  - la cible et son attitude, lue sur le PNJ ou, à défaut, sur le combattant ;
  - l'étape 1 (Disposée, Réticente, Hésitante) ;
  - l'étape 2 : les façons d'interagir avec leur bonus, ou l'échec récent ; le DD modifiable, avec son aide ; le mode ; le jet simple avec ce mode ;
  - après un échec, le délai d'attente, modifiable ;
  - l'attitude après l'échange.

  « Enregistrer dans le journal » écrit l'événement et met à jour l'attitude du PNJ.

### Choix

- **La cible de la mémoire est le PNJ** quand il y en a un : un échec reste connu d'une rencontre à l'autre. Pour un simple monstre, la cible est le combattant.
- **Le délai se fixe à l'échec** (`retry_hours`), et non par table : c'est ce que dit le SRD, « ou une autre durée définie par le MJ ».
- **Une réception Disposée ou Réticente n'est pas mémorisée** : sans test, il n'y a pas d'échec au sens du SRD.

