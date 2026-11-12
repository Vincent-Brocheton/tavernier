## ADDED Requirements

### Requirement: Valeurs remplacées envoyées
Les modifications de la fiche et de son état de jeu SHALL partir avec les valeurs qu'elles remplacent sur l'appareil, pour que le serveur reconnaisse un conflit.

#### Scenario: PV modifiés
- **WHEN** l'appareil passe les PV de 29 à 39
- **THEN** l'envoi porte 39 et la valeur remplacée 29
