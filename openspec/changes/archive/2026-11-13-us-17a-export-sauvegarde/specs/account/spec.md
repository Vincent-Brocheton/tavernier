## ADDED Requirements

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
