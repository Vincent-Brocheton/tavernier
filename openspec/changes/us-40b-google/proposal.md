# Proposal

## Why

Carte Trello [US-40](https://trello.com/c/NavKVI5d), deuxième lot. Exigences EF-CPT-01 (inscription et connexion par Google, 15 ans minimum) et EF-CPT-10 (méthodes liées ; « Retirer » désactivé sur la dernière ; un compte Google sans mot de passe en ajoute un avant de changer son e-mail). Écrans [A1], [T2], [A4] (bouton Google) et [A6]. **Apple est abandonné**, sur décision du porteur de projet (9 novembre 2026).

## What Changes

- **« Continuer avec Google »** sur les écrans de connexion et d'inscription, sous un séparateur « ou ».
- **15 ans pour les comptes Google** : à la première connexion, l'app demande la date de naissance avant tout le reste. Le serveur la vérifie sans la garder (`confirm_age`). Sous 15 ans, le compte est supprimé et l'utilisateur déconnecté, avec l'explication.
- **Méthodes de connexion [A6]**, dans « Modifier le compte » :
  - Google : Active, avec l'adresse, ou « Non liée » et « Lier » ;
  - Mot de passe : « Active », ou « Aucun pour l'instant » et « Ajouter » ;
  - « Retirer » est désactivé sur la seule méthode qui reste, avec l'explication.
- **E-mail d'un compte Google sans mot de passe** : verrouillé, avec « Fourni par Google. Pour en changer, ajoutez d'abord un mot de passe. »
- **Serveur** : `confirm_age(birth_date)` et `has_password()`.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `account` : Google, âge des comptes Google, méthodes de connexion.
- `sync-backend` : âge vérifié après coup, mot de passe défini.

## Impact

- `backend/supabase/migrations/`, `backend/supabase/tests/`.
- `apps/game_table/lib/account/` : passerelle (Google, identités, âge), bouton Google, écran d'âge, section Méthodes ; routes ; ARB ; tests.

**À faire par le porteur de projet** (comptes et secrets) :
- un client OAuth Google, de type application Web, avec l'URI de redirection `https://mtreifjwfadiyvatldux.supabase.co/auth/v1/callback` ;
- dans Supabase, le fournisseur Google activé avec ce client, et « Allow manual linking » coché.

**Hors périmètre :**
- **Apple :** abandonné.
- **Google sur Android et iOS** (liens profonds) : avec la cible téléphone. Ce lot couvre le Web.
- **Garde côté serveur sur l'âge pour les données :** l'app bloque tout avant la date, mais les règles RLS ne testent pas l'âge.
