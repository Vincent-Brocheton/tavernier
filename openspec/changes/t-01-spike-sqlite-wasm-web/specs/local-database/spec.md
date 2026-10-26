## MODIFIED Requirements

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

## ADDED Requirements

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
- **WHEN** l'application demande un stockage persistant dans un navigateur
- **THEN** elle reçoit un booléen, sans erreur, que la demande soit accordée ou non

#### Scenario: Demande sur mobile
- **WHEN** l'application demande un stockage persistant sur Android ou iOS
- **THEN** la réponse est « accordé »

### Requirement: Volume de contenu
La base SHALL accepter un pack de 10 000 entités (plafond ENF-09), le restituer en entier et y chercher, sur le Web comme sur mobile. Les durées d'import, de réouverture et de recherche SHALL être mesurées et consignées par navigateur et par stockage.

#### Scenario: Pack de 10 000 entités
- **WHEN** un pack de 10 000 entités est importé, la base fermée puis rouverte
- **THEN** la base compte 10 000 entités pour ce pack, une recherche par nom retrouve une entité précise, et les durées mesurées sont écrites dans la sortie du test
