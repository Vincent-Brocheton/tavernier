## ADDED Requirements

### Requirement: État de synchronisation affiché
Avec un compte connecté, l'écran principal SHALL montrer l'état de synchronisation (ENF-02) : hors ligne sans réseau ou sans connexion au service de synchronisation, avec le nombre de modifications en attente s'il y en a ; en attente quand des modifications partent ; synchronisé sinon. Sans compte, il SHALL ne rien montrer.

#### Scenario: Hors ligne avec modifications
- **WHEN** l'appareil est hors ligne avec 3 modifications en attente
- **THEN** l'indicateur affiche « Hors-ligne · 3 modifications en attente »

#### Scenario: Synchronisé
- **WHEN** l'appareil est connecté sans modification en attente
- **THEN** l'indicateur affiche « Synchronisé »
