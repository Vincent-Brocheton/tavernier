## ADDED Requirements

### Requirement: Publier une version
La page « Publier une version » ([H06]) SHALL proposer :
- la description, la licence et l'auteur, avec la signature de l'appareil ;
- le type de version (correctif, mineure, majeure), avec la version qui en résulte ;
- les changements depuis la version publiée ;
- l'attestation ;
- les contrôles : taille, nombre d'entités, règles validées et dépendances.

La première publication garde la version du brouillon. « Publier la version » SHALL rester grisé tant que la vérification signale un problème ou que l'attestation n'est pas cochée. Publier SHALL signer le pack, l'importer dans le contenu de l'appareil (origine `local`) et porter la version dans le brouillon.

#### Scenario: Première publication
- **WHEN** Inès coche l'attestation et publie « Gardiens des Marches » 0.1.0, qui passe la vérification
- **THEN** le pack 0.1.0 est dans le contenu de l'appareil, signé par la clé de l'appareil

#### Scenario: Version mineure
- **WHEN** elle ajoute un Don, choisit « Mineure » et publie
- **THEN** la page annonce « 0.1.0 → 0.2.0 » et liste le Don en « Ajouté », et le contenu de l'appareil porte la 0.2.0

#### Scenario: Attestation manquante
- **WHEN** l'attestation n'est pas cochée
- **THEN** « Publier la version » est grisé

### Requirement: Export signé
« Exporter le .dndpack signé » SHALL partager le fichier de la version publiée par la feuille de partage du système, sans réseau (EF-HB-05). Le fichier SHALL se relire, et sa signature SHALL être valide.

#### Scenario: Export hors ligne
- **WHEN** Inès exporte la 0.2.0 sans réseau
- **THEN** la feuille de partage reçoit `gardiens-des-marches-0.2.0.dndpack`, dont la signature est valide
