# Design

## Décisions

1. **Onglets dans `SignInPage`** (`SegmentedButton`) plutôt que deux routes : [A1] et [T2] partagent l'en-tête, le pied de page et le bandeau hors ligne.
2. **Date de naissance** saisie au clavier, au format `JJ/MM/AAAA`. Le contrôle est immédiat : date invalide, date future, ou moins de 15 ans au jour de la saisie.
3. **Vérification serveur de l'âge**, avec un déclencheur `before insert` sur `auth.users`. Il lit `birth_date` dans les métadonnées d'inscription. Sous 15 ans ou sans date, il refuse (`check_violation`). Sinon, il remplace la date par `age_checked_at` : la date de naissance d'un utilisateur, parfois mineur, n'est jamais stockée.
4. **Profil créé par le serveur** (déclencheur `after insert`) avec le pseudonyme des métadonnées. Le client n'écrit pas de profil avant d'avoir une session ; PowerSync l'apporte ensuite.
5. **Réponse neutre pour une adresse déjà prise :** `user_already_exists` donne le même écran « Vérifiez votre boîte mail » qu'une inscription qui attend confirmation. Avec la confirmation par e-mail active (projet hébergé), Supabase répond déjà de façon neutre.
6. **Règles du mot de passe partagées avec [A3]** : on reprend `PasswordPolicy` et `PasswordRules`. La règle d'identité compare avec l'e-mail et le pseudonyme saisis.
7. **Session hors ligne :** rien à écrire, `supabase_flutter` garde la session. Un test de passerelle vérifie qu'un utilisateur déjà connecté est rendu sans appel réseau.

## Risques

- **Âge déclaré, pas prouvé :** c'est ce que demande le cahier (« date de naissance déclarée »).
