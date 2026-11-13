## ADDED Requirements

### Requirement: Suppression du compte
Le serveur SHALL supprimer le compte de l'appelant sur demande (`delete_my_account`) : son profil, ses appartenances, ses emplacements et ses personnages avec tout leur détail (EF-CPT-04, ENF-10). Les tables dont il est MJ SHALL rester en place pour leurs joueurs, sans MJ. Les historiques SHALL garder leurs lignes, sans auteur. Un appelant sans session SHALL être refusé.

#### Scenario: Joueur qui supprime son compte
- **WHEN** Inès, joueuse de Brumeval avec Mira, supprime son compte
- **THEN** son profil, son appartenance, son emplacement et Mira n'existent plus, et Brumeval garde son MJ

#### Scenario: MJ qui supprime son compte
- **WHEN** le MJ de Brumeval, table archivée comprise, supprime son compte
- **THEN** Brumeval existe toujours, sans MJ, avec ses joueurs et leurs fiches

#### Scenario: Sans session
- **WHEN** un appelant anonyme demande la suppression
- **THEN** elle est refusée

### Requirement: Table sans MJ en lecture seule
Les fiches d'une table sans MJ SHALL ne plus être modifiables, et un joueur SHALL ne pas pouvoir retirer son PJ de son emplacement (décision du 25 octobre 2026). Elles SHALL rester lisibles par les membres.

#### Scenario: Fiche figée
- **WHEN** le MJ de Brumeval a supprimé son compte et Hugo modifie sa fiche
- **THEN** la modification est refusée, et Hugo lit toujours sa fiche

#### Scenario: PJ gardé dans son emplacement
- **WHEN** Hugo retire son PJ de son emplacement dans Brumeval sans MJ
- **THEN** le retrait est refusé
