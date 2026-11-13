## ADDED Requirements

### Requirement: Fiche d'une table sans MJ
La fiche d'une table dont le MJ a supprimé son compte SHALL s'afficher en lecture seule, y compris pour son propriétaire (EF-CPT-04, décision du 25 octobre 2026). Une fiche dont la table n'est pas encore connue de l'appareil SHALL garder ses droits habituels.

#### Scenario: Table sans MJ
- **WHEN** Hugo ouvre sa fiche de Brumeval, dont le MJ a supprimé son compte
- **THEN** la fiche est en lecture seule
