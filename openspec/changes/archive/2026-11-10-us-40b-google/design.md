# Design

## Décisions

1. **OAuth sur le Web par redirection** (`signInWithOAuth`, `linkIdentity`, flux PKCE de `supabase_flutter`) : retour à l'origine de la page, la session arrive par l'événement de connexion.
2. **Âge après coup pour Google** : le déclencheur d'inscription (us-12a) ne vérifie que les comptes e-mail. Pour les autres, le compte est créé sans `age_checked_at`.
   - Tant que l'utilisateur connecté n'a pas `age_checked_at`, le routeur l'envoie sur « Date de naissance ».
   - `confirm_age(birth_date)` (`security definer`, pour `auth.uid()`) :
     - à 15 ans révolus, il écrit `age_checked_at` dans les métadonnées et rend vrai ;
     - sinon, il supprime le compte (jamais valide) et rend faux. L'app se déconnecte alors et l'explique.
3. **Mot de passe défini ?** `has_password()` lit `encrypted_password` du compte. Les identités de Supabase ne le disent pas : un compte Google qui ajoute un mot de passe ne reçoit pas d'identité `email`.
4. **Ajouter un mot de passe** (compte Google) : `updateUser(password)`, sans mot de passe actuel, avec les règles d'EF-CPT-08.
5. **Retirer Google** : `unlinkIdentity`. Il est permis seulement s'il reste une autre méthode, c'est-à-dire un mot de passe défini.
6. **E-mail verrouillé** tant qu'un compte n'a pas de mot de passe (EF-CPT-10).

## Risques

- **Liaison manuelle :** sans « Allow manual linking » dans Supabase, « Lier » échoue. L'écran affiche alors le message générique.
- **Âge non garanti par les règles RLS** : un client modifié pourrait sauter l'écran. Cela reste dans la logique d'EF-CPT-01, où l'âge est déclaré.
