## ADDED Requirements

### Requirement: Pack signé
Un manifeste SHALL pouvoir porter `description`, `author_public_key` (clé publique Ed25519, base64) et `signature` (signature Ed25519, base64). Le message signé SHALL être le JSON du manifeste sans `signature`, avec `checksum` et `entity_count`, encodé comme dans l'archive. `verifyPackSignature` SHALL accepter un manifeste signé par la clé qu'il cite, et refuser :
- un manifeste modifié après la signature ;
- un manifeste sans signature ;
- une signature faite par une autre clé.

#### Scenario: Pack signé relu
- **WHEN** un pack est signé, écrit en `.dndpack` puis relu
- **THEN** sa signature est valide pour la clé publique de son auteur

#### Scenario: Pack modifié
- **WHEN** la version d'un manifeste signé est changée
- **THEN** sa signature n'est plus valide

### Requirement: Versions d'un pack
`nextVersion` SHALL donner la version suivante (EF-HB-11) :
- un correctif augmente le dernier nombre (2.1.0 → 2.1.1) ;
- une mineure augmente le deuxième et remet le dernier à zéro (2.1.0 → 2.2.0) ;
- une majeure augmente le premier et remet les autres à zéro (2.1.0 → 3.0.0).

`packChanges` SHALL lister les entités ajoutées, modifiées et retirées entre deux versions.

#### Scenario: Mineure
- **WHEN** l'auteur choisit une version mineure depuis 2.1.0
- **THEN** la version publiée est 2.2.0
