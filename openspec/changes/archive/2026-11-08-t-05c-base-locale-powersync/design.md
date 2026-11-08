# Design

## Contexte

PowerSync tient chaque table synchronisée sous forme de vue sur ses propres tables (`ps_data__<table>`). Des déclencheurs y enregistrent chaque écriture dans `ps_crud`, la file d'envoi. Le reste de la base reste du SQLite ordinaire, géré par Drift.

## Décisions

1. **Un seul schéma, celui de Drift.** Le schéma PowerSync est calculé à partir des tables Drift synchronisées : un booléen ou un entier devient `integer`, un réel `real`, le reste `text`, et `id` est implicite. Ajouter une colonne côté Drift suffit.
2. **Liste des tables synchronisées dans `dnd_data`**, alignée sur la publication `powersync` du backend. Un test vérifie que la migration Supabase les crée toutes.
3. **Migration Drift :** à la création, toutes les entités sauf les tables synchronisées. Le schéma reste en version 1, puisqu'il n'est pas publié.
4. **Dates en texte** (`store_date_time_values_as_text`) : PowerSync transporte les `timestamptz` en texte ISO 8601.
5. **Pas d'UPSERT sur une vue** (SQLite le refuse). `UPDATE`, puis `INSERT` si aucune ligne n'a changé, dans la même transaction.
6. **Ouverture dans `dnd_data`** (`openPowerSyncDatabase(path)`) : les tests de `dnd_data` passent par les mêmes vues que l'app.
7. **Web :** PowerSync choisit seul OPFS ou IndexedDB, depuis sa version 2.2, et sans en-têtes COOP/COEP. Les tests du Web vérifient l'ouverture, la persistance et la recherche ; ils ne vérifient plus quel stockage est retenu.

## Risques

- **Binaire natif de PowerSync** téléchargé à la compilation (comme celui de sqlite3) : même fragilité réseau en CI.
- **Débit des enregistrements :** une fiche réécrit tout son contenu à chaque enregistrement (suppression puis insertion), ce qui crée autant d'entrées dans `ps_crud`. C'est acceptable en M2, mais une écriture plus fine serait utile si l'envoi devient lent.
