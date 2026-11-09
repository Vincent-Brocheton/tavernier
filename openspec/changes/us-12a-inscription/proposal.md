# Proposal

## Why

Carte Trello [US-12](https://trello.com/c/U3VFXUL3), premier lot : « En tant qu'utilisateur, je crée un compte et je reste connecté hors-ligne. » Exigences EF-CPT-01 et EF-CPT-02 (cahier §4.1), écran [T2]. La connexion existe (US-39), mais personne ne peut encore créer de compte.

## What Changes

- **Onglets Connexion / Inscription** sur l'écran de connexion ([A1], [T2], [A4]).
- **Inscription par e-mail** : pseudonyme affiché, e-mail, mot de passe, date de naissance.
  - Le mot de passe suit les règles d'EF-CPT-08 (`PasswordRules`, comme [A3]).
  - Sous 15 ans, le message est « Il faut avoir au moins 15 ans pour créer un compte » et « Créer le compte » reste désactivé.
  - Une adresse déjà prise reçoit la même réponse qu'une adresse neuve, pour ne pas révéler l'existence d'un compte (EF-CPT-07).
  - Si le projet exige une confirmation, l'écran demande de vérifier sa boîte mail.
- **Côté serveur** (migration, déclencheur sur `auth.users`) :
  - **âge :** l'inscription est refusée sous 15 ans. La date de naissance n'est pas conservée : il ne reste que la date de la vérification ;
  - **profil :** il est créé avec le pseudonyme, puis synchronisé vers l'appareil.
- **Session hors ligne** (EF-CPT-02) : la session gardée par Supabase rouvre l'app connectée sans réseau. Un test le vérifie.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `account` : inscription.
- `sync-backend` : profil créé et âge vérifié à l'inscription.

## Impact

- `backend/supabase/migrations/` : déclencheur d'inscription ; tests pgTAP.
- `apps/game_table/lib/account/` : onglets, formulaire d'inscription, `AccountGateway.signUp` ; ARB ; tests.

**Hors périmètre :**
- **Google :** US-40.
- **Apple :** abandonné, décision du porteur de projet (9 novembre 2026).
- **Profil et réglages** [T5]/[A7], **consentement aux rapports de crash** [T1], **déconnexion** avec effacement des données locales : lot suivant (us-12b).
- **Appareils connectés** : lot us-12c.
- **Lien « Politique de confidentialité »** : quand la page existera.
