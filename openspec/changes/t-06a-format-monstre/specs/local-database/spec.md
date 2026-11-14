## ADDED Requirements

### Requirement: Monstres chargés depuis les packs
L'import d'un pack SHALL remplir `monster` (type de créature, FP, PX, Intelligence, profil complet) et `monster_action` (actions dans l'ordre, avec leur type et leur recharge).

#### Scenario: Ogre importé
- **WHEN** le pack SRD est importé
- **THEN** la base contient l'Ogre, FP 2, 450 PX, et ses actions dans l'ordre du profil
