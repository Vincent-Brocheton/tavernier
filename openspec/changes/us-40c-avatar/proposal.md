# Proposal

## Why

Carte Trello [US-40](https://trello.com/c/NavKVI5d), troisième et dernier lot : l'avatar. Exigences EF-CPT-03 (profil : avatar optionnel) et EF-CPT-09 (le pseudonyme et l'avatar se modifient hors ligne), écran [A5] : « Image carrée, compressée à 200 Ko. Visible des membres de vos tables. » Aujourd'hui, la ligne « Avatar » de [A5] ne fait rien, et partout l'avatar n'est que l'initiale du pseudonyme.

## What Changes

- **Choisir un avatar** dans « Modifier le compte » [A5] : un toucher sur la ligne « Avatar » ouvre le sélecteur d'images de l'appareil. L'image est recadrée au carré (centre), réduite à 256 px et compressée en JPEG sur l'appareil, sous 200 Ko. L'aperçu s'affiche aussitôt ; « Enregistrer » l'écrit, hors ligne compris.
- **Retirer l'avatar** : l'initiale du pseudonyme revient.
- **Stockage** : l'image va dans la colonne `profile.avatar`, déjà synchronisée, sous forme de data URI. Les membres des tables la reçoivent avec le profil, sans réseau au moment de l'affichage.
- **Affichage** : un seul composant d'avatar (image, sinon initiale, sinon icône), dans la barre de l'app, le profil, « Modifier le compte » et la liste des membres d'une table.
- **Serveur** : une contrainte refuse un avatar qui n'est pas une image en data URI ou qui dépasse 200 Ko. L'opération refusée est écartée, comme toute écriture invalide, sans bloquer la file d'envoi.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `account` : avatar du profil.
- `sync-backend` : contrainte sur l'avatar.

## Impact

- `backend/supabase/migrations/` : contrainte `profile_avatar_check` ; test pgTAP.
- `apps/game_table/` : dépendances `image_picker` (sélection) et `image` (recadrage, compression en Dart pur) ; `account/avatar.dart` (compression, composant `ProfileAvatar`) ; `SessionActions.setAvatar` ; `avatarProvider` ; écran [A5] ; barre de l'app, profil, membres ; ARB ; tests.
- `packages/dnd_data/` : `TableMemberInfo.avatar`.

**Hors périmètre :**
- Stockage de fichiers Supabase (Storage) : il demanderait le réseau à l'envoi, contraire à EF-CPT-09.
- Recadrage manuel : le centre de l'image est gardé.
- Avatars des PNJ et des personnages.
