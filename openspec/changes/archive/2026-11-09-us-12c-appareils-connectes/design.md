# Design

## Décisions

1. **Sessions de Supabase Auth** (`auth.sessions`), lues par des fonctions `security definer` limitées à `auth.uid()`. Le client n'a pas accès au schéma `auth`.
2. **Appareil courant** : la revendication `session_id` du jeton.
3. **Dernière activité** : `refreshed_at`, à défaut `updated_at`, puis `created_at`. Une session se rafraîchit au plus toutes les heures environ : « actif maintenant » vaut pour l'appareil courant, et pour les autres sous 5 minutes.
4. **Révocation** : supprimer la session supprime en cascade ses jetons de rafraîchissement. L'appareil ne peut plus prolonger sa connexion.
5. **Libellé** (`deviceLabel`, pur, testé) tiré du `User-Agent` :
   - un navigateur donne « Chrome sur Windows », « Firefox sur macOS », « Safari sur iPhone » ;
   - une app native donne « Téléphone Android », « iPhone », « iPad », « Windows », « macOS » ;
   - sinon, « Appareil inconnu ».
6. **Durée relative** (`lastActiveLabel`, pur, testé) : minutes, heures, jours, semaines, mois.

## Risques

- **Libellés approximatifs** : un `User-Agent` peut mentir ou se tronquer. Ce n'est qu'un repère pour l'utilisateur.
