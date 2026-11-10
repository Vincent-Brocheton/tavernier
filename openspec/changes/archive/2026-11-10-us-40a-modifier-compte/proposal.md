# Proposal

## Why

Carte Trello [US-40](https://trello.com/c/NavKVI5d), premier lot : « je change mon e-mail en toute sécurité ». Exigences EF-CPT-09 (changement d'e-mail confirmé par lien ; l'e-mail et le mot de passe demandent le réseau, le pseudonyme se modifie hors ligne) et EF-CPT-08 (règles du mot de passe), écran [A5]. Le profil existe (US-12), mais rien ne s'y modifie.

## What Changes

- **« Modifier le compte » [A5]**, ouvert par « Modifier » dans l'en-tête du profil, avec « Enregistrer » en barre d'application :
  - **Pseudonyme affiché** : il s'enregistre dans la base locale, même hors ligne, et part à la synchronisation ;
  - **E-mail** : le changement envoie un lien de confirmation à la nouvelle adresse. L'ancienne reste active jusque-là. Il demande le réseau ;
  - **Changer le mot de passe** : le mot de passe actuel est vérifié, puis le nouveau suit les règles d'EF-CPT-08 (`NewPasswordField`). Il demande le réseau ;
  - mention « L'e-mail et le mot de passe demandent le réseau : ils sont vérifiés par le serveur ».
- **Réponse neutre** : une adresse déjà prise reçoit le même message de lien envoyé qu'une adresse libre.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `account` : modification du compte.

## Impact

- `apps/game_table/lib/account/` : `edit_account_page.dart`, `AccountGateway` (e-mail, mot de passe), route, bouton « Modifier » du profil ; ARB ; tests.

**Hors périmètre :**
- **Avatar** (envoi d'une image compressée à 200 Ko) : lot us-40c.
- **Méthodes de connexion et Google** [A6], règle « ajouter un mot de passe avant de changer d'e-mail » : lot us-40b.
- **« Modifié il y a 4 mois »** sous « Changer le mot de passe » : Supabase ne donne pas la date du dernier changement.
- **Réglages du projet hébergé** (à faire par le porteur de projet dans le tableau de bord) : « Secure email change » désactivé, pour que seule la nouvelle adresse confirme ; avertissement de changement d'e-mail à l'ancienne adresse activé.
