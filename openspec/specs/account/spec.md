# account Specification

## Purpose
TBD - created by archiving change us-39-connexion. Update Purpose after archive.

## Requirements

### Requirement: Connexion
L'utilisateur SHALL se connecter par e-mail et mot de passe. Toute erreur d'identifiants SHALL donner le seul message « E-mail ou mot de passe incorrect », sans dire lequel (EF-CPT-07).

#### Scenario: Identifiants refusés
- **WHEN** l'e-mail est inconnu ou le mot de passe faux
- **THEN** le même message s'affiche dans les deux cas

#### Scenario: Connexion réussie
- **WHEN** les identifiants sont bons
- **THEN** l'utilisateur est connecté et ses fiches se synchronisent

### Requirement: Première connexion sans réseau
Sans réseau, le bouton de connexion SHALL être désactivé avec son explication, et aucun identifiant ne SHALL être stocké ni mis en file (EF-CPT-11).

#### Scenario: Hors ligne
- **WHEN** l'appareil n'a pas de réseau
- **THEN** « Se connecter » est désactivé et le bandeau « Pas de connexion internet » l'explique

#### Scenario: Retour du réseau
- **WHEN** le réseau revient
- **THEN** le bouton se réactive sans rien perdre de la saisie

### Requirement: Mot de passe oublié
La demande de réinitialisation SHALL répondre « Si un compte existe pour … », que le compte existe ou non. Le lien SHALL rester valable 1 heure, et son renvoi SHALL être possible après 60 secondes (EF-CPT-07, EF-CPT-08).

#### Scenario: Demande
- **WHEN** l'utilisateur demande un lien pour une adresse
- **THEN** l'écran confirme sans dire si le compte existe, et le renvoi est désactivé avec un décompte de 60 s

### Requirement: Nouveau mot de passe
Le nouveau mot de passe SHALL compter 10 caractères au moins, différer de l'e-mail et du pseudo, et être absent des listes de mots de passe divulgués. Une jauge de robustesse et les règles, cochées au fil de la saisie, SHALL l'accompagner. « Déconnecter mes autres appareils » SHALL être coché par défaut (EF-CPT-08).

#### Scenario: Règles au fil de la saisie
- **WHEN** l'utilisateur saisit un mot de passe de 8 caractères
- **THEN** la règle des 10 caractères est marquée non respectée et l'enregistrement est désactivé

#### Scenario: Mot de passe divulgué
- **WHEN** le mot de passe figure dans Have I Been Pwned
- **THEN** la règle des listes divulguées est marquée non respectée

#### Scenario: Enregistrement
- **WHEN** toutes les règles sont respectées et la confirmation identique
- **THEN** le mot de passe est changé, les autres appareils déconnectés si l'option est cochée, et l'utilisateur est connecté

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
