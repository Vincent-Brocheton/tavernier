# Proposal

## Why

Carte Trello [US-39](https://trello.com/c/NQ3cEsAM) : « En tant qu'utilisateur, je me connecte, je récupère l'accès à mon compte si j'ai oublié mon mot de passe, et la première connexion hors-ligne m'est expliquée. » Exigences EF-CPT-07, EF-CPT-08 et EF-CPT-11 (cahier §4.1), écrans [A1] à [A4], composant `PasswordRules` (COMPOSANTS 2.58). La synchronisation est prête (T-05) : se connecter suffit désormais pour que les fiches partent vers le serveur.

## What Changes

- **Connexion** ([A1] téléphone, [A4] desktop) : e-mail et mot de passe, avec l'œil pour l'afficher. Une seule erreur possible : « E-mail ou mot de passe incorrect », sans dire lequel.
- **Première connexion sans réseau** : le bouton est désactivé, et un bandeau en donne la raison. Rien n'est enregistré ni mis en file en attendant. Il se réactive dès que le réseau revient.
- **Mot de passe oublié** ([A2]) : le message ne dit jamais si un compte existe (« Si un compte existe pour… »). Le lien est valable 1 heure, et on peut le renvoyer après 60 secondes, avec un décompte.
- **Nouveau mot de passe** ([A3]), ouvert par le lien reçu :
  - les règles se cochent au fil de la saisie : 10 caractères au moins ; différent de l'e-mail et du pseudo ; absent des mots de passe divulgués, vérifié avec Have I Been Pwned par k-anonymat (seuls les 5 premiers caractères de l'empreinte SHA-1 sortent) ;
  - une jauge de robustesse en 4 segments ;
  - une confirmation du mot de passe ;
  - « Déconnecter mes autres appareils », coché par défaut.
- **Session et synchronisation** : une fois connecté, la base PowerSync se connecte avec le connecteur Supabase (T-05). Supabase garde la session, ce qui permet de rester connecté hors ligne.
- **Accès :** l'onglet Tables propose « Se connecter » à un utilisateur non connecté.
- **Kit :** variantes de `StatusBanner` (erreur sans titre, alerte avec icône), et nouveau composant `PasswordRules`.

## Capabilities

### New Capabilities

- `account` : connexion, mot de passe oublié, nouveau mot de passe.

### Modified Capabilities

- `ui-kit` : `StatusBanner` à variantes, `PasswordRules`.

## Impact

- `apps/game_table` : dépendances `supabase_flutter`, `connectivity_plus`, `http`, `crypto` ; dossier `lib/account/` ; routes ; ARB.
- `packages/dnd_ui_kit` : `StatusBanner`, `PasswordRules`.
- **Configuration :** l'URL Supabase, sa clé publique (publishable) et l'URL PowerSync sont passées au build par `--dart-define`. Sans elles, l'app reste entièrement locale, sans écran de connexion actif.

**Hors périmètre :**
- **Inscription** (onglet « Inscription », 15 ans minimum) et déconnexion : US-12.
- **Google et Apple** : US-40.
- **Lien de réinitialisation sur mobile** (liens profonds Android et iOS) : avec la cible téléphone. Ce change le couvre sur le Web.
- **Fournisseur d'e-mails de production** (SMTP, UE) : à créer par le porteur de projet avant l'ouverture au public. Le service d'e-mails par défaut de Supabase suffit pour les tests, car il n'écrit qu'aux membres du projet.
- **Page « Politique de confidentialité »** : le texte de pied de page est là, sans lien tant que la page n'existe pas.
