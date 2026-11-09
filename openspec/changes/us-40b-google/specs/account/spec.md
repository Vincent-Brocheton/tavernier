## ADDED Requirements

### Requirement: Connexion par Google
L'utilisateur SHALL se connecter ou s'inscrire avec Google. Un compte Google SHALL déclarer sa date de naissance avant tout usage, et être refusé sous 15 ans (EF-CPT-01).

#### Scenario: Première connexion Google
- **WHEN** un nouveau compte Google se connecte
- **THEN** l'écran « Date de naissance » s'affiche avant tout autre

#### Scenario: Moins de 15 ans
- **WHEN** la date déclarée donne moins de 15 ans
- **THEN** le compte est supprimé, l'utilisateur déconnecté, et l'écran explique pourquoi

### Requirement: Méthodes de connexion
Le compte SHALL montrer ses méthodes (Google, mot de passe), permettre de lier Google, d'ajouter un mot de passe, et de retirer une méthode tant qu'il en reste une autre (EF-CPT-10).

#### Scenario: Seule méthode
- **WHEN** Google est la seule méthode du compte
- **THEN** « Retirer » est désactivé, avec l'explication

#### Scenario: E-mail d'un compte Google sans mot de passe
- **WHEN** le compte n'a pas de mot de passe
- **THEN** l'e-mail est verrouillé avec « Fourni par Google. Pour en changer, ajoutez d'abord un mot de passe. »
