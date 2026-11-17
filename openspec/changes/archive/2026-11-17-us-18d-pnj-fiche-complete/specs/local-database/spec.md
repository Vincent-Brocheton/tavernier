## ADDED Requirements

### Requirement: Fiche de PNJ hors parcours des joueurs
Une fiche de PNJ (`kind = 'npc_full'`) SHALL monter de niveau librement : `CharacterStore.access` SHALL ne rendre aucun mode de progression pour elle. `CharacterStore.list` SHALL l'écarter des personnages de l'utilisateur. L'app SHALL ne pas publier son résumé au groupe.

#### Scenario: Progression
- **WHEN** l'app lit l'accès à la fiche d'Odran, PNJ d'une table en jalons
- **THEN** aucun mode de progression n'est rendu, et la montée de niveau est libre

#### Scenario: Mes personnages
- **WHEN** Camille liste ses personnages
- **THEN** Odran n'y est pas
