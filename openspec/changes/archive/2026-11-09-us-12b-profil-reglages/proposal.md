# Proposal

## Why

Carte Trello [US-12](https://trello.com/c/U3VFXUL3), deuxième lot. Exigences EF-CPT-03 (profil : langue, taille du texte, thème), EF-CPT-06 (consentement explicite et révocable aux rapports de crash, demandé au premier lancement) et ENF-11. Écrans [T1], [T5], [A7]. On peut s'inscrire et se connecter, mais pas encore se déconnecter ni régler l'affichage.

## What Changes

- **Consentement au premier lancement** ([T1]) : « Envoyer les rapports de plantage ? », avec « Refuser » et « Accepter ». La réponse est gardée sur l'appareil et reste modifiable dans les réglages.
- **Profil et réglages** ([T5] téléphone, [A7] desktop), ouverts par l'avatar : en bas du rail sur desktop, en haut à droite sur téléphone.
  - En-tête : initiale, pseudonyme et e-mail.
  - Affichage :
    - langue : Français, la seule langue au MVP ;
    - taille du texte : de 85 % à 200 %, appliquée à toute l'app ;
    - thème : Sombre ; Clair et Système sont désactivés, avec « Le thème clair arrive dans une prochaine version ».
  - Confidentialité : interrupteur des rapports de plantage.
  - Se déconnecter.
- **Déconnexion** : la session est fermée, et les données synchronisées de l'appareil sont effacées. Le compte suivant ne voit donc rien du précédent. Si des modifications n'ont pas encore été envoyées, on demande d'abord une confirmation : elles seraient perdues.
- **Kit :** `AdaptiveNavigationScaffold` reçoit une entrée de compte facultative.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `account` : réglages d'affichage, consentement, déconnexion.
- `ui-kit` : entrée de compte de la navigation.

## Impact

- `apps/game_table` : `lib/settings/` (réglages de l'appareil, `shared_preferences`), `lib/account/profile_page.dart`, consentement, déconnexion, `main.dart` (taille du texte appliquée) ; ARB ; tests.
- `packages/dnd_ui_kit` : `AdaptiveNavigationScaffold`.

**Hors périmètre :**
- **Section Compte** de [A7]/[A5] (avatar, pseudonyme, e-mail, mot de passe, méthodes de connexion) : US-40.
- **Appareils connectés** : lot us-12c.
- **Mes données** (export, sauvegarde, suppression du compte) : US-17.
- **Envoi réel des rapports de crash** (Sentry) : seul le consentement est recueilli ici, et aucun rapport ne part tant que l'outil n'est pas intégré.
- **Thème clair** : une version ultérieure, comme l'annonce la planche.
