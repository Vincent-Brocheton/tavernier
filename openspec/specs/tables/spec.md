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
