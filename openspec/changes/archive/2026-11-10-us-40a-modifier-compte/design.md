# Design

## Décisions

1. **Pseudonyme dans la base locale** : `UPDATE profile` dans la base PowerSync. La règle `profile_write` du serveur l'accepte pour son propre profil, et ça marche hors ligne (EF-CPT-09).
2. **E-mail** : `updateUser(email)`, avec retour vers l'app. Toute réponse autre qu'une absence de réseau donne le même message, y compris `email_exists`.
3. **Mot de passe** :
   - le mot de passe actuel est vérifié par une connexion (`signInWithPassword`) ; un échec donne « Mot de passe actuel incorrect » ;
   - le nouveau passe ensuite par `updateUser(password)` et les règles d'EF-CPT-08 (`NewPasswordField`, partagé avec [A3] et [T2]).
4. **Un seul « Enregistrer »** pour l'écran. Il enregistre, dans cet ordre, ce qui a changé : pseudonyme, e-mail, mot de passe. Il s'arrête à la première erreur, et ce qui est déjà enregistré le reste.
5. **Desktop** : la même colonne, centrée sur 640 dp.

## Risques

- **Comportement par défaut de Supabase** : il demande une confirmation sur les deux adresses (« Secure email change »). Tant que le réglage n'est pas changé, l'ancienne adresse doit confirmer aussi. Rien ne se perd, c'est seulement plus strict qu'EF-CPT-09.
