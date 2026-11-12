# Design

## Décisions

1. **Valeurs stockées** : les noms des énumérations, sans traduction.
   - `stat_method` : `standardArray`, `pointBuy` ou `random` (`ScoreMethod` de `dnd_rules`) ;
   - `long_rest_rule` : `fullHitPoints` ou `hitDice` (`LongRestRule`) ;
   - `hp_on_level_rule` : `average` ou `roll` ;
   - `progression_mode` : `xp` ou `milestones`.
   Les libellés viennent des ARB.
2. **`TableStore`** (`dnd_data`) : `create` écrit `game_table`, `table_member` (le MJ, rôle `gm`) et `table_pack` (`srd-5.2.1-fr`) dans une transaction, avec des identifiants UUID v7. `list(userId)` rend les tables dont l'utilisateur est MJ ou membre, les plus récentes d'abord. `load(id)` rend une table.
3. **Valeurs par défaut** de [T8] : niveau 1, Acquisition par points, récupération totale, moyenne fixe, PX.
4. **Disposition** :
   - desktop [T8] : le formulaire en cartes à gauche, l'aperçu de la carte à droite ;
   - téléphone : une colonne, sans aperçu, avec « Créer la table » en barre d'application.
5. **Connexion exigée** : sans compte, l'onglet Tables propose de se connecter (US-39). Une table appartient à un MJ connecté.

## Risques

- **Nouvelle colonne sur une table synchronisée** : le schéma PowerSync est dérivé de Drift (T-05), et PowerSync recrée ses vues seul. Aucune migration locale n'est à écrire.
