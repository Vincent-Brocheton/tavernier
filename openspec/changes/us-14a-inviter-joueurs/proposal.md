# Proposal

## Why

Carte Trello [US-14](https://trello.com/c/Z9mbaNBc), premier lot. Exigences EF-TAB-05 (invitation par lien, code à 6 caractères ou QR code, qui expire après 7 jours et peut être révoquée) et EF-TAB-06 (le MJ retire un joueur ; la fiche du joueur est archivée, pas supprimée). Écrans [T10] (membres et invitation, desktop) et [T11] (inviter, téléphone). Le serveur reçoit aussi de quoi rejoindre une table (EF-TAB-08), pour que le lot b ne touche que l'app.

## What Changes

- **Onglet « Membres »** de la table, pour tous les membres : la liste des membres avec leur pseudonyme et leur rôle. Le MJ peut retirer un joueur, après confirmation ; la note « Retirer un joueur archive sa fiche, sans la supprimer » l'accompagne.
- **Carte « Inviter des joueurs »** (MJ seul) : QR code du lien, code à 6 caractères, « Copier le lien », « Partager… », « Expire dans N jours » et « Révoquer ». Sans invitation en cours, un bouton en crée une. Une invitation vaut 7 jours.
- **Codes** : 6 caractères tirés au hasard (générateur sûr), sans les caractères qu'on confond (0, O, 1, I, L).
- **Lien** : `<origine de l'app>/#/rejoindre/<code>`, ouvert par l'appareil photo du téléphone quand on scanne le QR.
- **Serveur** :
  - `join_table(code)` : rejoint la table d'une invitation valide (ni révoquée, ni expirée, table non archivée), comme joueur ; rend l'identifiant de la table. Un code inconnu, expiré ou révoqué est refusé, avec un motif distinct. Au-delà de 10 échecs en une heure, le compte est freiné, contre la recherche de codes au hasard.
  - Retrait d'un membre : ses fiches de la table passent au statut `archived`, en lecture seule, sans être supprimées.
- **Listes réactives** : la liste des tables, une table et ses membres se mettent à jour d'eux-mêmes, synchronisation comprise.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `tables` : membres, invitation, retrait.
- `sync-backend` : `join_table`, freinage, archivage des fiches au retrait.
- `local-database` : invitations et membres dans `TableStore`, requêtes réactives.

## Impact

- `backend/supabase/migrations/`, `backend/supabase/tests/`.
- `packages/dnd_data` : `TableStore` (invitations, membres, retrait, `watch…`).
- `apps/game_table` : onglet Membres, carte d'invitation, dépendances `qr_flutter` et `share_plus` (citée au cahier §10) ; ARB ; tests.

**Hors périmètre :**
- **Rejoindre** (lien, saisie du code en 6 cases, file d'attente hors ligne, [T12]) : lot b.
- **Scanner le QR dans l'app** : l'appareil photo du téléphone ouvre le lien. Le scanner intégré viendra avec les apps mobiles.
- **Fiche de chaque membre** (« Aldric Varenne (à valider) ») et la fiche à valider de [T10] : US-15.
