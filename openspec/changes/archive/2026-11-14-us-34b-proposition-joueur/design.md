## Context

Le moteur de règles tourne dans l'app : le serveur ne sait pas calculer une fiche. Les fiches sont stockées en tables `character_*`, réécrites par `CharacterStore.save` sans toucher à l'état de jeu ni à l'historique. L'historique (`character_change_log`) n'accepte que des entrées de l'utilisateur connecté (`author_user_id = auth.uid()`).

## Decisions

- **Modification = champs de premier niveau de `CharacterInput`** (`{"feats": [...]}`), appliqués par fusion du JSON de la fiche. Un seul format sert au don, à l'Historique ou aux niveaux, sans code par type pour appliquer. La colonne `kind` (`feat` au MVP, contrainte au serveur) sert au résumé affiché.
- **Application par l'appareil du joueur** : en acceptant, il réécrit sa fiche avec `save`, ce que `can_write_character` lui permet déjà. Le serveur garde seulement le statut. Une proposition acceptée sur un appareil hors ligne part à la reconnexion, comme toute modification.
- **Fusion sur la fiche du moment** : la modification ne remplace que ses champs. Une fiche changée depuis la proposition garde ses autres changements (sorts, objets).
- **Historique** : l'entrée est écrite par le joueur (règle du serveur). Elle porte `proposed_by`, le motif et les dons retirés et ajoutés, lus par la page Historique avec les noms du contenu.
- **Droits** :
  - lecture : `can_read_proposal` (propriétaire ou MJ), plus étroit que `can_read_character`, qui ouvre la fiche aux membres quand la table montre les fiches complètes ;
  - réponse : la garde `guard_character_proposal` n'autorise que le propriétaire, depuis `pending`, vers `accepted` ou `refused`, sans toucher aux autres colonnes que `reply` et `decided_at`.
- **Synchronisation** : un flux `propositions`, avec deux requêtes (fiches du joueur, tables du MJ).
- **Encadré [F4b]** : en tête de fiche, hauteur limitée à la moitié de l'écran (défilement), pour que les onglets restent visibles. L'aperçu compare deux `computeSheet` et ne montre que les valeurs qui changent.

## Risks / Trade-offs

- Si la fiche a changé de dons depuis la proposition, l'acceptation remplace la liste entière par celle du MJ. Le lot c pourra construire la modification au dernier moment ; l'aperçu montre au joueur ce qu'il accepte.
- Deux appareils du même joueur peuvent répondre hors ligne ; la seconde réponse est refusée par le serveur et écartée par `apply_crud`.
