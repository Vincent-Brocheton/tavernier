# sync-backend Specification

## Purpose
TBD - created by archiving change t-05a-schema-supabase. Update Purpose after archive.

## Requirements

### Requirement: Schéma des données de jeu
Le backend SHALL porter les tables de jeu du cahier §11.2, avec les mêmes noms et colonnes que la base locale.

#### Scenario: Base vierge
- **WHEN** les migrations sont appliquées à une base vierge
- **THEN** elles réussissent

### Requirement: Droits par table et par rôle
Chaque table SHALL limiter lecture et écriture selon le rôle de l'utilisateur.

#### Scenario: Membre
- **WHEN** un joueur est membre d'une table
- **THEN** il voit la table et ses membres, pas ses invitations

#### Scenario: Inconnu
- **WHEN** un utilisateur n'est pas membre
- **THEN** il ne voit ni la table, ni ses membres, ni ses fiches

#### Scenario: Fiche
- **WHEN** un joueur crée sa fiche
- **THEN** son MJ la lit et la modifie, un autre joueur ne la voit pas

#### Scenario: Fiches visibles
- **WHEN** la table montre les fiches
- **THEN** un autre joueur la lit sans pouvoir la modifier ni la supprimer

#### Scenario: Usurpation
- **WHEN** un utilisateur crée une table ou une fiche au nom d'un autre
- **THEN** l'écriture est refusée

#### Scenario: Historique
- **WHEN** une modification est inscrite à l'historique
- **THEN** elle ne peut plus être corrigée

#### Scenario: Départ
- **WHEN** un joueur quitte une table
- **THEN** il ne la voit plus

### Requirement: Règles de synchronisation
Le service de synchronisation SHALL n'envoyer à un utilisateur que les lignes que les droits de la base lui laissent lire.

#### Scenario: Joueur
- **WHEN** un joueur se connecte
- **THEN** il reçoit son profil, sa fiche et son contenu, ses tables, leurs membres et leurs packs, mais pas les invitations ni la fiche d'un autre joueur

#### Scenario: MJ
- **WHEN** le MJ se connecte
- **THEN** il reçoit en plus les fiches de sa table, leur contenu et les invitations

#### Scenario: Inconnu
- **WHEN** un utilisateur sans table se connecte
- **THEN** il ne reçoit que son profil

#### Scenario: Fiches visibles
- **WHEN** la table montre les fiches complètes
- **THEN** chaque membre reçoit les fiches des autres membres

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

### Requirement: Inscription côté serveur
Le serveur SHALL refuser une inscription sans date de naissance ou de moins de 15 ans, SHALL ne pas conserver la date de naissance, et SHALL créer le profil avec le pseudonyme fourni.

#### Scenario: Quinze ans révolus
- **WHEN** un compte est créé avec une date de naissance de plus de 15 ans
- **THEN** son profil existe avec le pseudonyme, et ses métadonnées ne contiennent plus la date de naissance

#### Scenario: Trop jeune
- **WHEN** un compte est créé avec une date de naissance de moins de 15 ans
- **THEN** la création échoue

### Requirement: Sessions du compte
Un utilisateur SHALL lister ses seules sessions, et SHALL révoquer toute autre de ses sessions que celle en cours ; jamais celle d'un autre utilisateur.

#### Scenario: Liste
- **WHEN** un utilisateur liste ses sessions
- **THEN** il ne voit que les siennes, et celle en cours est signalée

#### Scenario: Révocation
- **WHEN** il révoque une autre de ses sessions
- **THEN** elle est supprimée

#### Scenario: Session d'un autre
- **WHEN** il tente de révoquer la session d'un autre utilisateur
- **THEN** rien n'est supprimé

### Requirement: Âge des comptes sans date à l'inscription
Le serveur SHALL enregistrer la vérification d'âge d'un compte créé sans date de naissance (Google) quand il déclare 15 ans révolus, sans garder la date, et SHALL supprimer le compte sinon.

#### Scenario: Quinze ans
- **WHEN** l'utilisateur déclare une date de 15 ans révolus
- **THEN** ses métadonnées portent `age_checked_at`, sans la date

#### Scenario: Trop jeune
- **WHEN** il déclare une date de moins de 15 ans
- **THEN** son compte est supprimé

### Requirement: Mot de passe défini
Le serveur SHALL dire à l'utilisateur si son compte a un mot de passe, sans rien en révéler d'autre.

#### Scenario: Compte Google
- **WHEN** un compte créé par Google demande s'il a un mot de passe
- **THEN** la réponse est non, puis oui une fois qu'il en a défini un
