## ADDED Requirements

### Requirement: Consentement aux rapports de crash
Au premier lancement, l'app SHALL demander le consentement aux rapports de plantage, sans aucune donnée de jeu ni mesure d'usage, et SHALL le rendre révocable dans les réglages (EF-CPT-06, ENF-11).

#### Scenario: Premier lancement
- **WHEN** l'app s'ouvre pour la première fois
- **THEN** le dialogue « Envoyer les rapports de plantage ? » s'affiche jusqu'à une réponse

#### Scenario: Révocation
- **WHEN** l'utilisateur coupe « Rapports de plantage » dans les réglages
- **THEN** le consentement est retiré et le dialogue ne revient pas

### Requirement: Réglages d'affichage
L'utilisateur SHALL régler la taille du texte de 85 % à 200 %, appliquée à toute l'app. Le thème sombre SHALL être le seul disponible, avec l'annonce du thème clair (EF-CPT-03).

#### Scenario: Taille du texte
- **WHEN** l'utilisateur règle le texte à 150 %
- **THEN** l'app s'affiche à 150 %, et le réglage est retrouvé au lancement suivant

### Requirement: Déconnexion
La déconnexion SHALL fermer la session sur cet appareil et effacer ses données synchronisées. Si des modifications n'ont pas été envoyées, elle SHALL demander une confirmation qui le dit.

#### Scenario: Rien en attente
- **WHEN** l'utilisateur se déconnecte sans modification en attente
- **THEN** la session est fermée et les fiches synchronisées sont effacées de l'appareil

#### Scenario: Modifications en attente
- **WHEN** des modifications attendent l'envoi
- **THEN** une confirmation en donne le nombre avant de les effacer
