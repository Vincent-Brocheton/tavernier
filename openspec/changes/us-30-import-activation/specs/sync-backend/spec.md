## ADDED Requirements

### Requirement: Stockage des packs
Le bucket privé `packs` SHALL recevoir les fichiers `.dndpack` des packs activés, chacun nommé `{sha256}.dndpack`, 20 Mo au plus. Les droits SHALL :
- permettre le dépôt à un MJ d'au moins une table ;
- réserver la lecture aux membres et au MJ d'une table dont un `table_pack` cite ce fichier ;
- n'autoriser ni modification ni suppression.

`table_pack.file_sha256` SHALL être une empreinte hexadécimale de 64 caractères, ou vide.

#### Scenario: Lecture réservée
- **WHEN** un utilisateur qui n'est membre d'aucune table citant le fichier essaie de le lire
- **THEN** il ne le voit pas

#### Scenario: Nom imposé
- **WHEN** un MJ dépose un fichier dont le nom n'est pas `{sha256}.dndpack`
- **THEN** le dépôt est refusé
