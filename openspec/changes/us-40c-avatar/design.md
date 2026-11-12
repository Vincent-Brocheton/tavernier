## Context

`profile.avatar` (texte, nullable) existe déjà côté serveur et en local, et se synchronise avec le profil vers les membres des tables (règles de `sync-config.yaml`). Rien ne l'écrit encore. EF-CPT-09 demande que l'avatar se modifie hors ligne.

## Goals / Non-Goals

**Goals :** avatar choisi, compressé et enregistré hors ligne ; affiché partout où l'initiale l'est aujourd'hui.

**Non-Goals :** Supabase Storage, recadrage manuel, avatars de personnages.

## Decisions

- **Data URI dans `profile.avatar`** plutôt que Supabase Storage : l'écriture reste locale et part à la synchronisation comme le pseudonyme ; aucune nouvelle règle PowerSync. Coût : environ 15 à 40 Ko par profil (JPEG 256 px), multiplié par les partenaires de table, ce qui reste faible. Le plafond de 200 Ko (≈ 273 000 caractères en base64) est vérifié par l'app et par une contrainte `check` du serveur.
- **`image_picker`** pour choisir l'image (Web, Android, iOS ; caméra possible sur téléphone), avec `maxWidth`/`maxHeight` 1024 pour que la plateforme réduise d'abord les grosses photos. **`image`** (Dart pur) pour le recadrage au centre, la réduction à 256 × 256 et l'encodage JPEG ; la qualité descend de 85 par paliers si l'image dépasse 200 Ko.
- **`ProfileAvatar`** (game_table) : `CircleAvatar` avec `MemoryImage` décodé du data URI (mis en cache par chaîne), sinon initiale, sinon icône. Un data URI invalide retombe sur l'initiale.
- **Écriture** : `SessionActions.setAvatar` fait un `customUpdate` qui prévient les requêtes observées (`profile`), puis invalide `avatarProvider`. L'avatar est enregistré par « Enregistrer », avec le pseudonyme.
- **Membres** : `watchMembers` lit aussi `p.avatar` ; `TableMemberInfo.avatar`.

## Risks / Trade-offs

- Décodage d'une grande photo en Dart sur le Web : lent. Atténué par la réduction préalable d'`image_picker` à 1024 px.
- Un avatar refusé par le serveur (appareil modifié) est écarté par `apply_crud` ; la ligne locale sera remplacée à la synchronisation suivante.
