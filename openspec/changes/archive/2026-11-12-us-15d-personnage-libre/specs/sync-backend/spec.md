## ADDED Requirements

### Requirement: Une table à la fois
Le serveur SHALL refuser de changer la table d'une fiche déjà rattachée. Le MJ SHALL pouvoir inscrire une dérogation dans l'historique d'une fiche de sa table, et le propriétaire la lire.

#### Scenario: Seconde table
- **WHEN** le propriétaire rattache à une autre table une fiche déjà rattachée
- **THEN** le serveur refuse

#### Scenario: Dérogation
- **WHEN** le MJ inscrit une dérogation
- **THEN** le propriétaire la lit dans l'historique
