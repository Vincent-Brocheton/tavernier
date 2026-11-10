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

### Requirement: Modification du compte
L'utilisateur SHALL modifier son pseudonyme, y compris hors ligne, ainsi que son e-mail et son mot de passe, qui demandent le réseau (EF-CPT-09). Un nouvel e-mail SHALL être confirmé par un lien envoyé à la nouvelle adresse. Un nouveau mot de passe SHALL demander le mot de passe actuel et suivre les règles d'EF-CPT-08.

#### Scenario: Pseudonyme hors ligne
- **WHEN** l'utilisateur change son pseudonyme sans réseau et enregistre
- **THEN** le nouveau pseudonyme s'affiche aussitôt et attend l'envoi

#### Scenario: Nouvel e-mail
- **WHEN** l'utilisateur saisit une nouvelle adresse et enregistre
- **THEN** un message dit qu'un lien de confirmation est envoyé à la nouvelle adresse, et que l'ancienne reste active jusque-là

#### Scenario: Mot de passe actuel faux
- **WHEN** le mot de passe actuel saisi est faux
- **THEN** « Mot de passe actuel incorrect » s'affiche et rien n'est changé

#### Scenario: Sans réseau
- **WHEN** l'utilisateur change son e-mail ou son mot de passe sans réseau
- **THEN** l'écran dit que ces changements demandent le réseau

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
