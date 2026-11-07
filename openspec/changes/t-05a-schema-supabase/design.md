# Design

## Contexte

`dnd_data` porte déjà les tables de jeu en local (Drift). PowerSync réplique des tables Postgres vers ces tables SQLite : les deux schémas doivent correspondre.

## Décisions

1. **Identifiants en texte.** Générés par l'appareil (UUID v7), pour créer hors ligne. Les utilisateurs sont des `uuid` de Supabase Auth.
2. **JSON en texte.** Comme en local, sans conversion à la synchronisation.
3. **Fonctions `security definer`.** `is_table_member`, `is_table_gm`, `can_read_character`, `can_write_character` lisent les tables sans repasser par leurs règles, ce qui évite la récursion.
4. **Une politique par table pour le contenu d'une fiche.** Mêmes droits que la fiche, générés dans une boucle.
5. **Suppression d'une fiche par son propriétaire seul.** Le MJ ne retire pas le PJ d'un joueur (cahier §14.2).
6. **MJ supprimé.** `gm_user_id` passe à vide, la table continue (§14.2).
7. **Tests en CI seulement.** Docker manque sur la machine de développement ; le job lance la CLI Supabase sur le runner.

## Risques

- **SQL non exécuté avant la CI :** premier passage possiblement rouge, corrigé dans la même PR.
- **Job non obligatoire :** il n'est pas dans la protection de `main` tant qu'il n'a pas fait ses preuves.
