## ADDED Requirements

### Requirement: Import des données de l'utilisateur
La base SHALL importer un export `tavernier-export` en ajoutant les lignes absentes, table par table, et SHALL garder telle quelle toute ligne déjà présente avec le même identifiant (ENF-12). L'import SHALL rendre le nombre de lignes ajoutées et de lignes déjà présentes.

#### Scenario: Restauration sur une base vide
- **WHEN** l'export contenant Aldric est importé dans une base vide
- **THEN** Aldric, ses niveaux de classe et ses objets s'y retrouvent avec les mêmes valeurs

#### Scenario: Ligne déjà présente gardée
- **WHEN** Aldric a été renommé sur l'appareil après l'export, puis l'export est importé
- **THEN** Aldric garde son nouveau nom, et sa ligne compte parmi les lignes déjà présentes

### Requirement: Contrôle du fichier importé
La base SHALL contrôler le fichier en entier avant toute écriture et refuser, sans rien écrire, un fichier d'un autre format, d'une version plus récente ou aux lignes mal formées. Les tables et les colonnes inconnues SHALL être ignorées.

#### Scenario: Fichier refusé
- **WHEN** le fichier n'est pas un `tavernier-export`, vient d'une version plus récente ou contient une ligne sans identifiant
- **THEN** l'import est refusé et la base n'a pas changé

#### Scenario: Colonne inconnue
- **WHEN** une ligne porte une colonne que la base ne connaît pas
- **THEN** la colonne est ignorée et la ligne est importée
