# Design

## Contexte

PowerSync range chaque écriture locale dans `ps_crud` : `PUT` pour une insertion avec toute la ligne, `PATCH` pour une modification avec les seules colonnes changées, `DELETE` pour une suppression. Le connecteur vide cette file vers le backend, transaction par transaction, et PowerSync renvoie ensuite l'état du serveur à chaque appareil.

## Décisions

1. **Envoi par lot, fonction `apply_crud`** (`package:supabase`, en Dart pur, utilisable par l'app comme par les tests). Une transaction locale part en un seul appel, appliqué en une seule transaction Postgres. Un premier essai, ligne par ligne par PostgREST, laissait les autres appareils recevoir une fiche sans son contenu. Dans le lot, `PUT` devient un upsert, `PATCH` une mise à jour des seules colonnes envoyées, et `DELETE` une suppression. La fonction est `security invoker` : les règles RLS de l'utilisateur s'appliquent. Elle n'écrit que les tables de la publication `powersync`.
   - **Règles de lecture :** un upsert vérifie aussi la lecture de la ligne nouvelle, que les fonctions `security definer` ne voient pas encore. Les règles de lecture testent donc aussi la ligne directement : le propriétaire, et le MJ de la table.
2. **Booléens :** en local, ce sont des entiers 0/1, et PostgREST attend `true`/`false`. Le connecteur convertit les colonnes booléennes, lues dans les tables Drift (une seule source).
3. **Propriétaire :** un `PUT` de `character` sans `owner_user_id` reçoit l'utilisateur connecté. Le serveur renvoie la ligne complétée, et la copie locale s'aligne.
4. **Erreurs définitives écartées une par une :** chaque opération du lot a son point de sauvegarde. Un refus de classe 22 (donnée invalide), de classe 23 (contrainte) ou `42501` (droits) n'écarte que cette opération, rendue au connecteur, qui la journalise. Sinon, une seule écriture refusée bloquerait toutes les suivantes. Une erreur réseau remonte, et PowerSync réessaie.
5. **Enregistrement par différence :** chaque ligne de contenu garde son identifiant déterministe (`<fiche>:<table>:<clé>`). `save` lit les lignes existantes, supprime celles qui disparaissent, insère les nouvelles et met à jour les autres. `ignoreEmptyUpdates` évite d'envoyer une mise à jour sans changement.
6. **Test de fusion en Dart natif** (`dnd_data/test/sync/`), contre Supabase et PowerSync du job CI. Il se saute lui-même sans les variables d'environnement du backend : `melos run test` reste hors ligne.
7. **Coût :** estimation à partir des grilles publiques de Supabase et de PowerSync, avec un volume par utilisateur calculé sur une fiche réelle.

## Risques

- **Égalité d'horodatage :** le « dernier écrit » est le dernier envoyé, pas le dernier saisi. Un appareil resté longtemps hors ligne gagne sur un champ modifié entre-temps ailleurs. C'est acceptable pour les fiches ; le combat (M3) passe par un journal d'événements.
