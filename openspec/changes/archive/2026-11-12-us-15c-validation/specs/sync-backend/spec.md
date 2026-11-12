## ADDED Requirements

### Requirement: Revue et transfert au serveur
Le serveur SHALL réserver le message d'envoi au propriétaire de la fiche, le commentaire de revue au MJ, et le changement de propriétaire au MJ de la table, vers un membre, sur une fiche non archivée. Au retrait d'un joueur, ses emplacements SHALL être supprimés.

#### Scenario: Commentaire du joueur
- **WHEN** le joueur écrit le commentaire de revue
- **THEN** le serveur refuse

#### Scenario: Transfert vers un inconnu
- **WHEN** le MJ donne la fiche à un utilisateur hors de la table
- **THEN** le serveur refuse

#### Scenario: Retrait
- **WHEN** le MJ retire un joueur
- **THEN** ses emplacements disparaissent, sa fiche reste archivée
