## ADDED Requirements

### Requirement: Résumés des fiches au serveur
Le serveur SHALL laisser les membres d'une table lire les résumés de ses fiches, et seuls le propriétaire et le MJ les écrire, pour la table de la fiche. Les résumés SHALL être synchronisés vers les membres.

#### Scenario: Autre joueur
- **WHEN** un joueur écrit le résumé de la fiche d'un autre
- **THEN** le serveur refuse

#### Scenario: Lecture
- **WHEN** un membre lit les résumés
- **THEN** il voit ceux de sa table, sans PV chiffrés
