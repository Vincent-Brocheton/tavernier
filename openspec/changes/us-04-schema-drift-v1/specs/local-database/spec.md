# Spec Delta

## Purpose

Base SQLite locale de chaque appareil, source de vérité hors-ligne : elle porte le contenu de règles des packs et les données de jeu, permet la recherche dans le compendium et évolue par migrations versionnées.

## ADDED Requirements

### Requirement: Schéma version 1
Une base neuve SHALL contenir, en version de schéma 1, toutes les tables du contenu de règles (cahier §11.1, plus `language`, `tool`, `feature`, `species_trait`) et des données de jeu (cahier §11.2, plus `character_language`, `character_choice`).

#### Scenario: Base neuve
- **WHEN** la base est ouverte pour la première fois
- **THEN** sa version de schéma vaut 1 et chacune des tables attendues existe

### Requirement: Identifiant unique des données synchronisables
Chaque table de données de jeu SHALL avoir une clé primaire `id` textuelle unique, y compris les tables de liaison, pour rester synchronisable en M2.

#### Scenario: Tables de liaison
- **WHEN** la structure des tables `character_*`, `table_member` et `table_pack` est lue
- **THEN** chacune a une clé primaire réduite à la colonne `id`

### Requirement: Intégrité référentielle
La base SHALL refuser une ligne qui cite un parent absent (clés étrangères actives) et supprimer en cascade les lignes dépendantes d'un personnage ou d'un pack supprimé.

#### Scenario: Niveau de classe orphelin
- **WHEN** un niveau de classe est inséré pour un personnage inexistant
- **THEN** l'insertion est refusée

#### Scenario: Suppression d'un personnage
- **WHEN** un personnage est supprimé
- **THEN** ses valeurs de base, niveaux de classe, dons, bottes, objets, langues et choix sont supprimés avec lui

### Requirement: Import et export d'un pack
Un pack SHALL s'écrire dans les tables normalisées et se relire à l'identique (manifeste et entités). Réimporter la même version d'un pack SHALL remplacer ses entités sans les dupliquer.

#### Scenario: Pack SRD aller-retour
- **WHEN** le pack SRD de l'échantillon (188 entités) est importé puis exporté
- **THEN** l'export est égal au pack d'origine, entité par entité

#### Scenario: Réimport
- **WHEN** le même pack est importé deux fois
- **THEN** la base contient une seule fois chacune de ses entités

### Requirement: Recherche plein texte
La base SHALL retrouver les entités de contenu par leur nom ou leur texte de règles (FTS5), sans tenir compte des accents ni de la casse, y compris sur un début de mot.

#### Scenario: Recherche avec ou sans accent
- **WHEN** on cherche « défense » puis « defense »
- **THEN** les deux recherches renvoient le don `srd:feat:defense`

#### Scenario: Début de mot
- **WHEN** on cherche « épé »
- **THEN** les résultats contiennent l'épée longue et l'épée courte

#### Scenario: Texte de règles
- **WHEN** on cherche « Classe d'armure »
- **THEN** les résultats contiennent le don Défense, dont le texte cite la Classe d'armure

### Requirement: Enregistrement d'un personnage
Un personnage stocké (`CharacterInput`) SHALL s'écrire dans les tables `character_*` et se relire à l'identique ; l'enregistrer de nouveau SHALL remplacer ses données sans doublon.

#### Scenario: Aldric aller-retour
- **WHEN** Aldric niveau 1 est enregistré puis relu
- **THEN** le personnage relu est égal à l'entrée de la fixture [D1]

#### Scenario: Modification
- **WHEN** Aldric est enregistré une seconde fois avec une botte de moins
- **THEN** la relecture donne deux bottes

### Requirement: Migrations versionnées
Chaque version du schéma SHALL être figée dans un instantané versionné ; un changement de schéma sans nouvelle version et sans migration testée SHALL faire échouer les tests.

#### Scenario: Instantané à jour
- **WHEN** les tests de migration s'exécutent
- **THEN** le schéma produit par le code est identique à l'instantané de la version 1

### Requirement: Base sur chaque plateforme
L'application SHALL ouvrir une base persistante sur Web (SQLite WASM), Android et iOS : écrire, fermer, rouvrir et relire les mêmes données, et y exécuter une recherche FTS5 (cahier ENF-06).

#### Scenario: Web
- **WHEN** le test d'intégration s'exécute dans Chrome
- **THEN** la base est créée, un pack importé et retrouvé par recherche après réouverture

#### Scenario: Android
- **WHEN** le même test s'exécute sur un émulateur Android
- **THEN** il réussit

#### Scenario: iOS
- **WHEN** le même test s'exécute sur le simulateur iOS du job de CI macOS
- **THEN** il réussit
