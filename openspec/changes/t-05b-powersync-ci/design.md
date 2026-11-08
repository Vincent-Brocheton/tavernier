# Design

## Contexte

PowerSync lit le journal de réplication de Postgres (publication `powersync`), range les lignes dans des buckets, et sert à chaque client ceux que ses règles lui ouvrent. Les règles s'écrivent en Sync Streams (édition 3), qui acceptent jointures et sous-requêtes imbriquées.

## Décisions

1. **Sync Streams plutôt que `bucket_definitions`.** Les droits RLS passent par la table de la fiche puis par son MJ ou ses membres ; seuls les Sync Streams expriment ces chaînes sans dénormaliser le schéma.
2. **Mêmes chemins que les fonctions RLS.** Une fiche est lue par son propriétaire, par le MJ de sa table, ou par les membres quand `full_sheets_visible` est vrai. Un CTE `fiches` rassemble ces chemins ; le contenu d'une fiche (12 tables) suit `character_id IN fiches`.
3. **Flux abonnés d'office** (`auto_subscribe`) : profil, tables, fiches. Rien ne dépend encore d'un paramètre d'abonnement.
4. **Stockage des buckets dans Postgres**, base `powersync_storage` du même serveur en CI. Pas de MongoDB à faire tourner.
5. **Authentification Supabase** (`supabase: true`) par le JWKS de l'API locale, avec en secours le secret JWT local pour les jetons HS256.
6. **Test par le flux HTTP** `/sync/stream` (NDJSON), lu jusqu'au premier `checkpoint_complete`, avec `curl` et `jq`. Le test compare les couples `type/id` reçus à la liste attendue, écrite à la main.

## Risques

- **Service non exécuté hors CI :** premières exécutions possiblement rouges, corrigées dans la PR.
- **Image `latest` :** une version qui casse la configuration rendrait le job rouge ; on épinglera une version si cela arrive.
