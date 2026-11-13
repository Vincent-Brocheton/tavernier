## ADDED Requirements

### Requirement: Propositions du MJ au serveur
Le serveur SHALL garder les propositions structurelles du MJ (`character_proposal`) : fiche, table, auteur, type, modification, motif non vide, statut et réponse. Seuls le propriétaire de la fiche et le MJ de la table SHALL les lire et les recevoir à la synchronisation. Seul le MJ SHALL en créer, en son nom, en attente, pour une fiche non archivée de sa table. Seul le propriétaire SHALL y répondre, une seule fois, en acceptant ou en refusant, sans changer la proposition.

#### Scenario: Proposition
- **WHEN** Camille propose une modification de la fiche d'Hugo, avec un motif
- **THEN** la proposition est enregistrée en attente, et Hugo la reçoit

#### Scenario: Motif vide
- **WHEN** le motif est vide
- **THEN** le serveur refuse la proposition

#### Scenario: Un joueur ne propose pas
- **WHEN** Hugo crée une proposition
- **THEN** le serveur la refuse

#### Scenario: Réponse du joueur
- **WHEN** Hugo refuse avec « Je garde Vigilant. »
- **THEN** Camille lit la réponse, et ni elle ni Hugo ne peuvent plus la changer

#### Scenario: Autres membres
- **WHEN** la table montre les fiches complètes
- **THEN** Inès ne reçoit pas la proposition faite à Hugo
