# Proposal

## Why

Carte Trello [US-17](https://trello.com/c/VDVUxvnl), premier lot : l'export des données et le rappel de sauvegarde. Exigences ENF-10 (export complet des données de l'utilisateur en JSON), ENF-12 (export manuel de l'ensemble des données locales ; rappel de sauvegarde si aucune synchronisation ni export depuis 30 jours) et EF-CPT-04 (export proposé avant la suppression du compte). Écrans [A7] (« Mes données ») et [G6] (bandeau « Aucune sauvegarde depuis 32 jours »).

## What Changes

- **Export JSON** de toutes les données de l'utilisateur dans la base de l'appareil :
  - profil, tables, membres, emplacements, personnages et tout leur détail, historique ;
  - données de M3 déjà présentes (PNJ, séances, rencontres, notes) ;
  - liste des packs de contenu installés (identifiant, version), sans leur contenu.

  Le fichier porte un format (`tavernier-export`) et une version (1), pour l'import du lot b.
- **« Mes données »** dans le profil [A7] : « Exporter mes données » et la date du dernier export. Sur le Web, le fichier se télécharge. Sur téléphone, il passe par la feuille de partage du système (« Enregistrer dans Fichiers »…).
- **Rappel de sauvegarde [G6]** sur l'accueil :
  - **quand** : après 30 jours sans synchronisation ni export sur cet appareil, s'il y a au moins un personnage ou une table ;
  - **ce qu'il propose** : « Plus tard » le masque jusqu'au prochain lancement, « Exporter maintenant » lance l'export ;
  - **point de départ** quand rien n'a jamais été synchronisé ni exporté : le premier lancement de l'app sur l'appareil.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `local-database` : export des données de l'utilisateur.
- `account` : « Mes données », rappel de sauvegarde.

## Impact

- `packages/dnd_data/` : `exportUserData` ; tests.
- `apps/game_table/` : `account/data_backup.dart` (export, enregistrement du fichier selon la plateforme, dates, rappel) ; section « Mes données » du profil ; bandeau de l'accueil ; ARB ; tests.

**Hors périmètre :**
- **Import** de l'export (ENF-12, « que vous pourrez réimporter ») : lot us-17b.
- **Suppression du compte** [T15] (EF-CPT-04, ENF-10) : lot us-17c.
- **Bandeau « Stockage persistant refusé »** de [G6] : il relève de T-01 et du stockage Web, pas de cette carte.
- **Export côté serveur** des données qui ne sont pas sur l'appareil : la synchronisation y amène déjà toutes les données de l'utilisateur.
