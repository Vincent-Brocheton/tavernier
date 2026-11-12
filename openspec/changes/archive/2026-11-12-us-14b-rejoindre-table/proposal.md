# Proposal

## Why

Carte Trello [US-14](https://trello.com/c/Z9mbaNBc), second lot. Exigences EF-TAB-05 (rejoindre par lien ou code) et EF-TAB-08 (rejoindre exige le réseau ; hors ligne, la demande est mise en file et part à la reconnexion), ENF-01. Écrans [T4] (« Rejoindre ») et [T12] (rejoindre hors ligne). Le serveur (`join_table`) et l'invitation côté MJ existent (us-14a).

## What Changes

- **Page « Rejoindre une table » [T12]**, à l'adresse `/rejoindre` ou `/rejoindre/<code>` (le lien de l'invitation et son QR y mènent). Le code se saisit dans 6 cases de 56 dp, en majuscules, puis « Rejoindre ».
- **Demande mise en file** : le code est gardé sur l'appareil tant que la demande n'a pas abouti. Elle part d'elle-même au retour du réseau ou à la connexion du compte, même si la page a été fermée.
  - Hors ligne : bandeau « Pas de réseau », bouton « En attente du réseau… », et l'invitation à créer un personnage libre en attendant ;
  - sans compte : le code est gardé, « Se connecter » ;
  - refus du serveur : message selon le motif (code inconnu, expiré ou révoqué, table archivée, trop d'essais), et le code est oublié ;
  - réussite : la page de la table s'ouvre ; elle se remplit à l'arrivée de la synchronisation.
- **« Rejoindre »** à côté de « Nouvelle table » dans l'onglet Tables.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `tables` : rejoindre une table, file d'attente hors ligne.

## Impact

- `apps/game_table` : `AccountGateway.joinTable`, demande en attente (`shared_preferences`), page et route, bouton dans l'onglet Tables ; ARB ; tests.

**Hors périmètre :**
- **Scanner le QR dans l'app** : l'appareil photo du téléphone ouvre le lien ; le scanner intégré viendra avec les apps mobiles.
