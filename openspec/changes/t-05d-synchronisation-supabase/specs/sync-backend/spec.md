## ADDED Requirements

### Requirement: Envoi des écritures
Les écritures locales SHALL être envoyées au backend avec le jeton de l'utilisateur. Un personnage sans propriétaire SHALL recevoir l'utilisateur connecté, et une écriture refusée définitivement SHALL être écartée sans bloquer les suivantes.

#### Scenario: Personnage créé sans compte
- **WHEN** un personnage créé hors connexion est envoyé
- **THEN** le serveur l'enregistre avec l'utilisateur connecté pour propriétaire

#### Scenario: Écriture refusée
- **WHEN** le serveur refuse une écriture pour des droits insuffisants
- **THEN** les écritures suivantes partent quand même

### Requirement: Fusion sans perte
Des modifications faites hors ligne sur plusieurs appareils SHALL fusionner champ par champ, le dernier écrit gagnant (cahier ENF-03).

#### Scenario: Trois appareils
- **WHEN** trois appareils d'un même compte modifient hors ligne trois points différents d'une fiche, puis se reconnectent
- **THEN** chaque appareil et le serveur ont les trois modifications
