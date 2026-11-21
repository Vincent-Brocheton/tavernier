## ADDED Requirements

### Requirement: Niveaux des aptitudes de sous-classe
Une `class` SHALL pouvoir porter `subclass_feature_levels`, les niveaux où sa sous-classe accorde ses aptitudes, en commençant par `subclass_level`. L'extracteur du SRD SHALL les lire dans les lignes « Aptitude de sous-classe » de la table de chaque classe. Chaque sous-classe du SRD SHALL avoir ses aptitudes à ces niveaux, et à tous. Un pack sans ce champ SHALL se lire comme avant.

#### Scenario: Guerrier du SRD
- **WHEN** le pack SRD est construit
- **THEN** le Guerrier a pour niveaux de sous-classe 3, 7, 10, 15 et 18, ceux des aptitudes du Champion

#### Scenario: Pack antérieur
- **WHEN** un pack dont les classes n'ont pas `subclass_feature_levels` est lu
- **THEN** il se lit sans problème, avec une liste vide
