# tables Specification

## Purpose
TBD - created by archiving change us-13a-creer-table. Update Purpose after archive.

## Requirements

### Requirement: Création d'une table
Un MJ connecté SHALL créer une table avec un nom, une description, un niveau de départ de 1 à 20, une méthode de caractéristiques, une règle de repos long, un mode de PV à la montée de niveau et une progression en PX ou en jalons (EF-TAB-01 à 03, EF-TAB-10). Le pack SRD SHALL y être actif (EF-TAB-04).

#### Scenario: Création
- **WHEN** le MJ remplit le nom et crée la table
- **THEN** la table existe avec ses réglages, il en est le MJ et membre, et le pack SRD y est actif

#### Scenario: Nom obligatoire
- **WHEN** le nom est vide
- **THEN** « Créer la table » est désactivé

#### Scenario: Hors ligne
- **WHEN** le MJ crée une table sans réseau
- **THEN** elle apparaît dans sa liste et part au serveur à la reconnexion

### Requirement: Liste des tables
L'onglet Tables SHALL lister, à un utilisateur connecté, les tables dont il est MJ ou membre, et proposer « Nouvelle table ».

#### Scenario: Après création
- **WHEN** le MJ revient à l'onglet Tables
- **THEN** sa nouvelle table y figure avec le rôle « MJ »

### Requirement: Configuration d'une table
Le MJ SHALL modifier la méthode de caractéristiques, le niveau de départ, le repos long, les PV à la montée de niveau, la progression et la visibilité des fiches complètes. Avant l'enregistrement, l'écran SHALL lister les modifications ; un changement de méthode SHALL rappeler qu'il ne touche pas les fiches existantes (EF-TAB-11).

#### Scenario: Changement de méthode
- **WHEN** le MJ choisit une autre méthode de caractéristiques
- **THEN** le bandeau « Ce changement ne touche pas les fiches existantes » s'affiche, et le panneau liste « Méthode : ancienne → nouvelle »

#### Scenario: Enregistrement
- **WHEN** le MJ enregistre
- **THEN** la table prend la nouvelle configuration, et chaque changement est daté dans l'activité

#### Scenario: Annulation
- **WHEN** le MJ annule
- **THEN** le formulaire revient à la configuration enregistrée

### Requirement: Activité de la table
Chaque changement de configuration et chaque archivage SHALL être daté, avec son auteur, dans l'activité de la table, visible des membres.

#### Scenario: Vue d'ensemble
- **WHEN** un membre ouvre la vue d'ensemble
- **THEN** il voit les derniers changements, datés

### Requirement: Archivage
Le MJ SHALL archiver la table, qui passe en lecture seule pour tous, et SHALL pouvoir la restaurer (EF-TAB-07).

#### Scenario: Archivée
- **WHEN** la table est archivée
- **THEN** la configuration est verrouillée, et seul « Restaurer » reste disponible

### Requirement: Membres d'une table
L'app SHALL montrer à chaque membre la liste des membres de la table, avec leur pseudonyme et leur rôle, le MJ en premier. Le MJ SHALL pouvoir retirer un joueur après confirmation ; sa fiche est archivée, pas supprimée (EF-TAB-06).

#### Scenario: Liste
- **WHEN** un membre ouvre l'onglet « Membres »
- **THEN** il voit chaque membre, son pseudonyme et son rôle

#### Scenario: Retrait
- **WHEN** le MJ retire un joueur et confirme
- **THEN** le joueur n'est plus membre de la table

#### Scenario: Joueur
- **WHEN** un joueur ouvre l'onglet « Membres »
- **THEN** il ne voit ni l'invitation ni l'action de retrait

### Requirement: Invitation
Le MJ SHALL pouvoir créer une invitation valable 7 jours, avec un code de 6 caractères sans caractère ambigu, un lien et un QR code de ce lien. Il SHALL pouvoir copier le lien, le partager et révoquer l'invitation (EF-TAB-05). Créer une invitation SHALL révoquer celle en cours.

#### Scenario: Création
- **WHEN** le MJ crée une invitation
- **THEN** l'app montre le code, le QR du lien et « Expire dans 7 jours »

#### Scenario: Révocation
- **WHEN** le MJ révoque l'invitation
- **THEN** elle n'est plus proposée, et l'app offre d'en créer une autre

#### Scenario: Expiration
- **WHEN** l'invitation a plus de 7 jours
- **THEN** elle n'est plus proposée

### Requirement: Rejoindre une table
L'utilisateur SHALL pouvoir rejoindre une table par le lien d'une invitation ou en saisissant son code de 6 caractères. Rejoindre exige le réseau et un compte : sinon, la demande SHALL être gardée sur l'appareil et partir d'elle-même au retour du réseau ou à la connexion (EF-TAB-08). Un refus du serveur SHALL être expliqué selon son motif.

#### Scenario: Lien
- **WHEN** l'utilisateur connecté, en ligne, ouvre le lien d'une invitation valide
- **THEN** il devient joueur de la table et la page de la table s'ouvre

#### Scenario: Hors ligne
- **WHEN** l'utilisateur saisit un code sans réseau
- **THEN** l'app affiche « En attente du réseau… », garde le code, et la demande part au retour du réseau

#### Scenario: Sans compte
- **WHEN** l'utilisateur ouvre le lien sans être connecté
- **THEN** l'app garde le code et propose de se connecter ; la demande part à la connexion

#### Scenario: Code refusé
- **WHEN** le serveur refuse le code (inconnu, expiré, table archivée, trop d'essais)
- **THEN** l'app affiche le motif et oublie le code
