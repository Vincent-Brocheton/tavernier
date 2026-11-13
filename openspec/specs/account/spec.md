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

### Requirement: État de synchronisation affiché
Avec un compte connecté, l'écran principal SHALL montrer l'état de synchronisation (ENF-02) : hors ligne sans réseau ou sans connexion au service de synchronisation, avec le nombre de modifications en attente s'il y en a ; en attente quand des modifications partent ; synchronisé sinon. Sans compte, il SHALL ne rien montrer.

#### Scenario: Hors ligne avec modifications
- **WHEN** l'appareil est hors ligne avec 3 modifications en attente
- **THEN** l'indicateur affiche « Hors-ligne · 3 modifications en attente »

#### Scenario: Synchronisé
- **WHEN** l'appareil est connecté sans modification en attente
- **THEN** l'indicateur affiche « Synchronisé »

### Requirement: Conflit dans l'indicateur
L'indicateur de synchronisation SHALL passer à « Conflit résolu » tant qu'un conflit qui a remplacé une valeur de l'utilisateur n'a pas été vu, avant tout autre état.

#### Scenario: Conflit non vu
- **WHEN** un conflit a remplacé une valeur de l'utilisateur et n'a pas été vu
- **THEN** l'indicateur affiche « Conflit résolu »

### Requirement: Avatar du profil
L'utilisateur SHALL pouvoir choisir une image comme avatar, y compris hors ligne (EF-CPT-03, EF-CPT-09). L'image SHALL être recadrée au carré et compressée sur l'appareil sous 200 Ko avant d'être enregistrée. Sans avatar, l'initiale du pseudonyme SHALL s'afficher. L'avatar SHALL s'afficher dans la barre de l'app, le profil et la liste des membres des tables de l'utilisateur.

#### Scenario: Image choisie
- **WHEN** l'utilisateur choisit une photo rectangulaire de plusieurs mégaoctets
- **THEN** l'aperçu montre une image carrée, et l'avatar enregistré pèse moins de 200 Ko

#### Scenario: Hors ligne
- **WHEN** l'utilisateur choisit un avatar sans réseau et enregistre
- **THEN** l'avatar s'affiche aussitôt et attend l'envoi

#### Scenario: Retirer l'avatar
- **WHEN** l'utilisateur retire son avatar et enregistre
- **THEN** l'initiale de son pseudonyme s'affiche de nouveau

#### Scenario: Membres d'une table
- **WHEN** un membre de la table a un avatar
- **THEN** la liste des membres affiche son image à la place de son initiale

#### Scenario: Fichier illisible
- **WHEN** le fichier choisi n'est pas une image lisible
- **THEN** un message le dit et l'avatar ne change pas

### Requirement: Mes données
Le profil SHALL proposer « Exporter mes données », qui enregistre l'export JSON dans un fichier (téléchargement sur le Web, feuille de partage sur téléphone), et SHALL afficher la date du dernier export fait sur l'appareil (ENF-10, ENF-12).

#### Scenario: Export depuis le profil
- **WHEN** l'utilisateur touche « Exporter mes données »
- **THEN** un fichier `tavernier-export-<date>.json` est proposé, et la date du dernier export s'affiche

### Requirement: Rappel de sauvegarde
L'accueil SHALL afficher « Aucune sauvegarde depuis N jours » lorsque, sur cet appareil, il n'y a eu ni synchronisation ni export depuis 30 jours et qu'il existe au moins un personnage ou une table (ENF-12, [G6]). « Plus tard » SHALL masquer le bandeau jusqu'au prochain lancement ; « Exporter maintenant » SHALL lancer l'export.

#### Scenario: 32 jours sans sauvegarde
- **WHEN** la dernière synchronisation et le dernier export datent de 32 jours et qu'un personnage existe
- **THEN** l'accueil affiche « Aucune sauvegarde depuis 32 jours »

#### Scenario: Synchronisé récemment
- **WHEN** la dernière synchronisation date d'hier
- **THEN** aucun rappel ne s'affiche

#### Scenario: Rien à sauvegarder
- **WHEN** l'appareil n'a ni personnage ni table
- **THEN** aucun rappel ne s'affiche

### Requirement: Importer une sauvegarde
« Mes données » SHALL proposer « Importer une sauvegarde » (ENF-12). Après le choix d'un fichier, une confirmation SHALL dire que les éléments absents de l'appareil seront ajoutés et que ceux déjà présents seront gardés. Une fois l'import fait, l'app SHALL afficher le nombre d'éléments ajoutés et déjà présents. Un fichier refusé SHALL être signalé, sans rien changer.

#### Scenario: Import confirmé
- **WHEN** l'utilisateur choisit un export puis confirme
- **THEN** les éléments manquants sont ajoutés et l'app affiche combien l'ont été

#### Scenario: Import annulé
- **WHEN** l'utilisateur ferme le choix du fichier ou annule la confirmation
- **THEN** rien n'est importé

#### Scenario: Fichier refusé
- **WHEN** le fichier choisi n'est pas un export de Tavernier
- **THEN** un message le dit et rien n'est importé
