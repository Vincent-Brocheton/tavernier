## ADDED Requirements

### Requirement: Journal du combat au serveur
Le serveur SHALL garder le journal de chaque rencontre (`encounter_event`) : rencontre et table (la même), auteur, type non vide, données JSON et date de création. Seul le MJ de la table SHALL lire, recevoir et ajouter des événements, en son nom, sur une table ni archivée ni sans MJ. Le journal SHALL être en ajout seul : un événement ne se modifie pas, et ne se supprime qu'avec sa rencontre.

#### Scenario: Le MJ joue
- **WHEN** Camille ajoute « combat_started » au « Relais du Sel »
- **THEN** l'événement est enregistré à son nom, et elle le reçoit

#### Scenario: Ajout seul
- **WHEN** Camille modifie ou supprime un événement
- **THEN** le serveur refuse

#### Scenario: Les joueurs ne voient pas le journal
- **WHEN** Hugo lit, synchronise ou ajoute un événement
- **THEN** il ne reçoit rien, et le serveur refuse l'ajout

#### Scenario: Rencontre supprimée
- **WHEN** la rencontre est supprimée
- **THEN** son journal l'est aussi
