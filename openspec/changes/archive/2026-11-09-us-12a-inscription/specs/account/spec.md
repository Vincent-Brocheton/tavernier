## ADDED Requirements

### Requirement: Inscription
L'utilisateur SHALL créer un compte avec un pseudonyme, un e-mail, un mot de passe qui respecte les règles d'EF-CPT-08, et sa date de naissance. Sous 15 ans, l'inscription SHALL être refusée avec son explication (EF-CPT-01). Une adresse déjà utilisée SHALL recevoir la même réponse qu'une adresse neuve (EF-CPT-07).

#### Scenario: Moins de 15 ans
- **WHEN** la date de naissance donne moins de 15 ans
- **THEN** « Il faut avoir au moins 15 ans pour créer un compte » s'affiche et « Créer le compte » est désactivé

#### Scenario: Inscription réussie
- **WHEN** tous les champs sont valides
- **THEN** le compte est créé, et l'utilisateur est connecté ou invité à confirmer son e-mail

#### Scenario: Adresse déjà prise
- **WHEN** l'adresse a déjà un compte
- **THEN** l'écran est le même que pour une inscription qui attend confirmation

### Requirement: Session hors ligne
Une fois connecté, l'utilisateur SHALL le rester sans réseau, sans limite de durée tant qu'il ne se déconnecte pas (EF-CPT-02).

#### Scenario: Réouverture en mode avion
- **WHEN** l'app est rouverte sans réseau après une connexion
- **THEN** l'utilisateur est toujours connecté
