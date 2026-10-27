# local-database Specification

## Purpose
Base SQLite locale de chaque appareil, source de vérité hors-ligne : elle porte le contenu de règles des packs et les données de jeu, permet la recherche dans le compendium et évolue par migrations versionnées.

## Requirements

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
L'application SHALL ouvrir une base persistante sur Web (SQLite WASM), Android et iOS : écrire, fermer, rouvrir et relire les mêmes données, et y exécuter une recherche FTS5 (cahier ENF-06). Sur le Web, cela vaut pour les navigateurs d'ENF-06 : Chrome, Firefox, Safari et Edge.

#### Scenario: Web
- **WHEN** le test d'intégration s'exécute dans Chrome
- **THEN** la base est créée, un pack importé et retrouvé par recherche après réouverture

#### Scenario: Autres navigateurs
- **WHEN** le même test s'exécute dans Firefox, Safari et Edge
- **THEN** il réussit dans chacun

#### Scenario: Android
- **WHEN** le même test s'exécute sur un émulateur Android
- **THEN** il réussit

#### Scenario: iOS
- **WHEN** le même test s'exécute sur le simulateur iOS du job de CI macOS
- **THEN** il réussit

### Requirement: Stockage Web
Sur le Web, la base SHALL utiliser OPFS quand la page est isolée (en-têtes `Cross-Origin-Opener-Policy: same-origin` et `Cross-Origin-Embedder-Policy: require-corp`) et que le navigateur le permet, et SHALL basculer seule sur IndexedDB sinon, sans perte de fonction (cahier §10.1, §14.1). Le stockage retenu SHALL être connu de l'application.

#### Scenario: Page isolée sur Chrome
- **WHEN** la base est ouverte dans Chrome avec les en-têtes COOP/COEP
- **THEN** le stockage retenu est OPFS

#### Scenario: Page non isolée
- **WHEN** la base est ouverte dans Chrome sans ces en-têtes
- **THEN** le stockage retenu est IndexedDB et le test d'intégration réussit quand même

### Requirement: Stockage persistant
Sur le Web, l'application SHALL pouvoir demander au navigateur un stockage persistant et connaître sa réponse (accordé ou refusé), pour avertir l'utilisateur en cas de refus (cahier ENF-07). Hors Web, la demande SHALL répondre « accordé » sans rien faire.

#### Scenario: Demande sur le Web
- **WHEN** l'application demande un stockage persistant dans un navigateur qui répond sans demander à l'utilisateur (Chrome, Edge, Safari)
- **THEN** elle reçoit un booléen, sans erreur, que la demande soit accordée ou non

#### Scenario: Navigateur qui interroge l'utilisateur
- **WHEN** le navigateur affiche une invite (Firefox) et que l'utilisateur n'y répond pas
- **THEN** la demande reste en attente sans bloquer la base ni le reste de l'application

#### Scenario: Demande sur mobile
- **WHEN** l'application demande un stockage persistant sur Android ou iOS
- **THEN** la réponse est « accordé »

### Requirement: Volume de contenu
La base SHALL accepter un pack de 10 000 entités (plafond ENF-09), le restituer en entier et y chercher, sur le Web comme sur mobile. Les durées d'import, de réouverture et de recherche SHALL être mesurées et consignées par navigateur et par stockage.

#### Scenario: Pack de 10 000 entités
- **WHEN** un pack de 10 000 entités est importé, la base fermée puis rouverte
- **THEN** la base compte 10 000 entités pour ce pack, une recherche par nom retrouve une entité précise, et les durées mesurées sont écrites dans la sortie du test

### Requirement: Sorts dans la base
La base SHALL stocker les sorts d'un pack dans la table `spell` (cahier §11.1) et les restituer à l'identique à l'export. La recherche plein texte SHALL trouver un sort par son nom ou son texte.

#### Scenario: Aller-retour
- **WHEN** le pack SRD complet est importé puis exporté
- **THEN** chaque sort exporté est égal au sort d'origine

#### Scenario: Recherche
- **WHEN** on cherche « boule de feu »
- **THEN** le premier résultat est `srd:spell:fireball`, de type `spell`
