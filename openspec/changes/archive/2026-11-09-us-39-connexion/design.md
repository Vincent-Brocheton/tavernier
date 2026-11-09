# Design

## Contexte

Supabase Auth gère les comptes : `signInWithPassword`, `resetPasswordForEmail`, puis, une fois le lien suivi, l'événement `passwordRecovery`, `updateUser(password)` et `signOut(scope: others)`. La session est gardée par `supabase_flutter` (stockage local), ce qui la garde valide hors ligne. PowerSync se connecte avec `SupabaseConnector` (T-05).

## Décisions

1. **`AccountGateway`**, une petite classe autour de `GoTrueClient`. Les tests d'écran utilisent un double de test ; les messages d'erreur sont choisis à partir de l'exception, jamais à partir du texte du serveur.
2. **Une erreur de connexion, un message :** quelle que soit l'erreur d'identifiants (`invalid_credentials`, e-mail non confirmé), le message est le même. Une erreur réseau a son propre message.
3. **Réseau** (`connectivity_plus`) : sans interface réseau, le bouton est désactivé avec son bandeau. Aucun identifiant n'est stocké : les champs restent en mémoire de l'écran.
4. **Durée du lien et renvoi :** Supabase vaut par défaut 1 heure (OTP e-mail) et 60 secondes entre deux envois ; l'écran affiche un décompte de 60 s. Le temps restant sur [A3] vient de `recovery_sent_at`.
5. **Règles du mot de passe** (`PasswordPolicy`, pur Dart, testé) :
   - longueur ≥ 10 ;
   - différent de l'e-mail, de sa partie locale et du pseudo, sans tenir compte de la casse ;
   - fuite vérifiée par l'API « range » de Have I Been Pwned (k-anonymat, en-tête `Add-Padding`), après 400 ms sans frappe. Sans réponse, la règle reste « non vérifiée » et l'enregistrement attend, comme pour tout changement de mot de passe, qui demande le réseau ;
   - robustesse de 0 à 4, d'après la longueur et la variété des caractères. C'est une indication : le seul blocage vient des règles.
6. **Pseudo :** celui du profil local, s'il existe.
7. **Configuration par `--dart-define`** (`SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`, `POWERSYNC_URL`) : rien de secret, la clé publique est faite pour les clients. Sans configuration, Supabase n'est pas initialisé : les tests et l'usage local restent hors ligne.
8. **Mise en page :** une colonne sur téléphone ([A1]) ; deux colonnes à partir du format desktop ([A4]), avec l'accroche à gauche et le formulaire à droite.

## Risques

- **Have I Been Pwned hors UE :** il ne reçoit que 5 caractères hexadécimaux d'empreinte, sans e-mail ni adresse IP liée au compte. C'est la décision du porteur de projet (9 novembre 2026).
- **Pas de test de bout en bout de l'e-mail en CI pour l'app.** Le parcours d'e-mail appartient à Supabase ; nos écrans sont testés avec le double.
