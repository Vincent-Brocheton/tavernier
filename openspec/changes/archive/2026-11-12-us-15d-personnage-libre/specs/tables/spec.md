## ADDED Requirements

### Requirement: Rattachement d'un personnage libre
Le joueur SHALL pouvoir rattacher, depuis un emplacement vide, un de ses personnages sans table. Le personnage SHALL alors être rattaché à la table, remplir l'emplacement et être envoyé au MJ pour revalidation.

#### Scenario: Rattachement
- **WHEN** Léo rattache Kael à son emplacement
- **THEN** Kael est dans la table, « à valider »

#### Scenario: Déjà rattaché
- **WHEN** un personnage est déjà dans une table
- **THEN** il n'est pas proposé au rattachement

### Requirement: Écarts et dérogations
Le panneau de revue SHALL proposer, pour chaque contrôle en échec, une dérogation ou une correction. Les dérogations SHALL être inscrites dans l'historique de la fiche, sans notification. Avec au moins une correction, la fiche SHALL repartir au joueur avec le message du MJ ; sans correction, elle SHALL être validée.

#### Scenario: Dérogations seules
- **WHEN** le MJ accepte en dérogation un niveau 3 pour une table au niveau 1
- **THEN** la fiche est validée et l'historique porte « Dérogation : niveau 3 accepté »

#### Scenario: Une correction
- **WHEN** un écart est en correction
- **THEN** le bouton est « Demander des corrections (1) », inactif sans message
