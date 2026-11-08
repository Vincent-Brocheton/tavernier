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
