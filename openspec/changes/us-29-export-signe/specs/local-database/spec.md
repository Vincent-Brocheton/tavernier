## ADDED Requirements

### Requirement: Clé de l'auteur
`AuthorKeyStore` SHALL créer une seule paire Ed25519 par appareil, à la première demande, puis rendre toujours la même. Elle est gardée dans la table locale `author_key`, non synchronisée, même sous PowerSync.

#### Scenario: Même clé
- **WHEN** la clé est demandée deux fois
- **THEN** la même clé publique est rendue, et `author_key` n'a qu'une ligne

### Requirement: Pack signé gardé
Le schéma v9 SHALL garder la description, la signature et la clé publique de l'auteur d'un pack (`content_pack`). L'export d'un pack importé SHALL les rendre à l'identique ; une base v8 SHALL monter en v9.

#### Scenario: Aller-retour d'un pack signé
- **WHEN** un pack signé est importé puis exporté
- **THEN** son manifeste exporté a la même description, la même clé publique et la même signature, et la signature reste valide
