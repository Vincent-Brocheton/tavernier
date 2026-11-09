## ADDED Requirements

### Requirement: Appareils connectés
Le profil SHALL lister les appareils connectés au compte, avec leur nom lisible et leur dernière activité, et SHALL permettre de déconnecter à distance chacun des autres (EF-CPT-05).

#### Scenario: Liste
- **WHEN** l'utilisateur ouvre son profil avec le réseau
- **THEN** il voit cet appareil, marqué « Cet appareil · actif maintenant », puis les autres avec leur dernière activité

#### Scenario: Déconnexion à distance
- **WHEN** il appuie sur « Déconnecter » à côté d'un autre appareil
- **THEN** cet appareil disparaît de la liste et ne peut plus prolonger sa connexion

#### Scenario: Sans réseau
- **WHEN** l'utilisateur ouvre son profil sans réseau
- **THEN** la section dit que la liste demande le réseau
