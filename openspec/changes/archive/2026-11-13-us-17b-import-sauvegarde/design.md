## Context

L'export du lot a écrit chaque ligne telle qu'en base, sous `tables.<nom>`, dans un ordre où les parents précèdent les enfants (séance, puis rencontre, puis combattant). Toutes les tables exportées ont une clé `id`. Les tables synchronisées sont des vues PowerSync : `INSERT OR IGNORE` n'y a pas de sens, car les écritures passent par des déclencheurs.

## Decisions

- **Ajout seul** : `INSERT … SELECT … WHERE NOT EXISTS (… id = ?)`, comme `CharacterStore` le fait déjà. Une ligne présente n'est jamais touchée : pas de conflit inventé avec la synchronisation, ni de travail récent écrasé par une vieille sauvegarde.
- **Contrôle avant écriture** :
  - noms de tables et de colonnes pris dans la description Drift (`allTables`), jamais dans le fichier, ce qui exclut toute injection SQL par les noms ;
  - valeurs : texte, nombre, booléen ou `null` ;
  - chaque ligne a un `id` texte.

  Toute erreur lève une `FormatException` avant la transaction.
- **Une transaction** pour tout l'import, puis `markTablesUpdated` sur les tables touchées, pour réveiller les écrans.
- **Compte connecté** : les lignes ajoutées partent vers le serveur comme toute écriture locale. Une ligne qui ne revient pas à l'utilisateur (membre d'une table d'un autre MJ, par exemple) est refusée par les droits et écartée par `apply_crud`, puis la synchronisation remet l'état du serveur.
- **Choix du fichier** : `file_selector` (paquet de l'équipe Flutter, Web, Android, iOS et ordinateur). Le Web n'a pas besoin de code à part.
- **Interface** : `DataBackup.import(bytes)` rend un `UserDataImport(added, kept)` ; le widget enchaîne le choix du fichier, la confirmation (`showDialog`), puis un message.

## Risks / Trade-offs

- Une sauvegarde plus ancienne ne corrige pas une ligne abîmée sur l'appareil : seul le remplacement le ferait. Il reste hors périmètre tant que le besoin n'est pas exprimé.
- Une ligne supprimée sur l'appareil après l'export revient à l'import : c'est le sens d'une restauration.
