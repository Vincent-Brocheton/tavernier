# Proposal

## Why

Carte Trello [US-24](https://trello.com/c/lSrstJxf) : l'assistant Étude, Influence, Observation du MJ. Exigences : **EF-ACT-01** à **EF-ACT-07** ; cahier §6.4 ; planches [C9], [C10] et [F3]. Règles : glossaire du SRD 5.2.1, entrées « Étude [Action] », avec la table « Domaines de savoir », et « Influence [Action] », avec la table « Tests d'Influence ».

L'attitude et les informations cachées des PNJ existent depuis US-18, et le journal de rencontre, réservé au MJ (RLS `is_table_gm`), depuis US-20. Il manque :
- les assistants ;
- les tables de règles qu'ils consultent, modifiables par pack (EF-ACT-05) ;
- les événements qui gardent leurs résultats.

Comme US-37, la carte est livrée en trois lots, chacun avec sa PR, dans ce change unique.

## What Changes

### Lot a : données de règles et Étude

- **Format `.dndpack`** (EF-ACT-05), décision du porteur de projet du 19 nov. 2026 : une entité `rule` peut porter des `data`, au lieu d'en être privée.
  - `study_skills` : type de créature → compétence suggérée pour l'Étude.
  - `influence_checks` : façons d'interagir, chacune avec sa caractéristique, sa compétence et, au besoin, les types de créature visés.
  - C'est une extension compatible du format v1 : une entité `rule` sans `data` reste valide.
- **Pack SRD** : `srd:rule:study` et `srd:rule:influence`, avec le texte du glossaire et les tables du SRD.
- **Moteur** :
  - suggestion de compétence selon le type de créature ;
  - paliers atteints par un résultat ;
  - événement `study`.
- **Assistant** ([C9]) :
  - un bouton « Étude · Influence · Observation » dans le combat ;
  - le choix du personnage qui agit et de la cible ;
  - les cinq compétences d'Intelligence avec ses bonus, la compétence suggérée, le résultat (dé saisi ou lancé) et les paliers préparés du PNJ ;
  - « Révéler n informations » : les paliers atteints sont marqués révélés sur le PNJ et inscrits au journal (EF-ACT-01, EF-ACT-07).

### Lot b : Influence ([C10], EF-ACT-02, 03, 06)

- **Étape 1** : la cible est Disposée, Réticente ou Hésitante.
- **Étape 2** : le test se choisit selon la façon d'interagir ;
  - le DD vaut 15, ou l'Intelligence de la cible si elle est plus élevée ;
  - Avantage contre une cible Amicale, Désavantage contre une cible Hostile.
- **Échec** : il est mémorisé par personnage et par approche, et signalé pendant 24 heures (délai modifiable).
- **Attitude** : l'attitude après l'échange est enregistrée sur le PNJ.

### Lot c : Observation ([F3], EF-ACT-04)

- Les quatre compétences de Sagesse avec leur aide, le DD fixé par le MJ et le résultat.
- La découverte, rédigée par le MJ, peut être liée à un PNJ.
- Le tout est consigné au journal.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `content-pack` : données d'une entité `rule`, tables de l'Étude et de l'Influence.
- `encounters` : assistants et événements `study`, `influence`, `observation`.
- `local-database` : schéma v2, tables d'une règle en base.

## Impact

- **`dnd_content`** : `RuleData`, et les références de ses tables, contrôlées par `validatePack`.
- **Pack et documentation** : `tools/srd_builder/sources/rule/`, `docs/packs/FORMAT_DNDPACK.md`, puis le pack de l'app, à régénérer.
- **`dnd_rules`** : suggestions et paliers, nouveaux types d'événement.
- **App** : `encounters/` (nouvel `action_assistant.dart`) et l'ARB.
- **Données** :
  - schéma local v2 (`rule_term.data`), décidé par le porteur de projet, sans rien côté serveur ;
  - le type d'événement du journal est un texte libre ;
  - les informations cachées et l'attitude du PNJ existent déjà.

## Hors périmètre

- **Affichage du journal** : il relève de US-25. Les événements sont écrits ici, et le journal les montrera.
- **« Créer une note » de l'Observation** : les notes relèvent de US-26.
- **Écran d'édition des tables** : EF-ACT-05 se satisfait d'un pack, sans écran au MVP (CONFORMITE, « ⚙️ »).
- **Assistant hors combat** : il s'ouvre depuis une rencontre en cours. Une Étude ou une Influence en dehors d'une rencontre attendra.
