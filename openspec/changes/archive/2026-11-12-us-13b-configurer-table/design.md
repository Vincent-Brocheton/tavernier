# Design

## Décisions

1. **`table_activity`**, une table synchronisée : `id`, `table_id`, `author_user_id`, `at`, `kind`, `detail` (JSON en texte).
   - Lecture : les membres et le MJ.
   - Écriture : le MJ, en ajout seul, sans modification ni suppression. Comme l'historique d'une fiche, une activité ne se corrige pas.
   - Elle entre dans la publication `powersync`, et dans le flux `tables` des règles de synchronisation.
2. **Une entrée par réglage changé** : `kind` vaut `config` et `detail` porte `{field, from, to}`. L'archivage donne `kind` = `archived` ou `restored`. L'écran traduit chaque entrée avec les ARB.
3. **`TableStore.update`** compare l'ancienne et la nouvelle configuration. Dans une seule transaction, il met à jour `game_table` et ajoute les entrées d'activité. `setArchived` fait de même pour l'archivage.
4. **Lecture seule côté serveur** :
   - `can_write_character` rend faux pour une fiche d'une table archivée ;
   - la règle de mise à jour de `game_table` n'accepte, sur une table archivée, que sa restauration par le MJ ;
   - les écritures refusées sont écartées par `apply_crud` et journalisées (T-05).
5. **Formulaire [F6]** : des listes déroulantes, comme sur la planche, pour méthode, niveau, repos, PV et progression. Les modifications sont gardées dans l'écran jusqu'à « Enregistrer », et le panneau de droite les liste. Sur téléphone, le panneau passe sous le formulaire.

## Risques

- **Règles hébergées à redéployer à la main** : tant que ce n'est pas fait, l'activité ne descend pas vers les autres appareils. Elle reste visible là où elle a été écrite, et part quand même au serveur.
