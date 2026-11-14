## ADDED Requirements

### Requirement: Séances au serveur
Le serveur SHALL garder les séances d'une table (`session`) : table, titre non vide, date, état (`planned`, `in_progress` ou `closed`) et date de création. Il SHALL aussi garder leurs présences prévues (`session_attendance`) : une ligne par personnage présent, sur une fiche de la même table. Les membres de la table SHALL lire et recevoir les séances et les présences. Seul le MJ de la table SHALL les créer, les modifier et les supprimer, et jamais sur une table archivée ou sans MJ. Supprimer une séance SHALL supprimer ses présences.

#### Scenario: Séance du MJ
- **WHEN** Camille crée « Le relais du Sel » le 30 octobre 2026 pour Brumeval
- **THEN** la séance est enregistrée en état `planned`, et Hugo et Inès la reçoivent

#### Scenario: Un joueur ne crée pas de séance
- **WHEN** Hugo crée une séance pour Brumeval
- **THEN** le serveur la refuse

#### Scenario: Présence prévue
- **WHEN** Camille marque Aldric présent à la séance 12
- **THEN** Hugo voit qu'Aldric est attendu, et le serveur refuse qu'Hugo retire cette présence

#### Scenario: Personnage d'une autre table
- **WHEN** Camille marque présent un personnage rattaché à une autre table
- **THEN** le serveur refuse la présence

#### Scenario: Table archivée
- **WHEN** Brumeval est archivée et Camille modifie une séance
- **THEN** le serveur refuse la modification

#### Scenario: Hors de la table
- **WHEN** un utilisateur qui n'est pas membre de Brumeval synchronise
- **THEN** il ne reçoit ni ses séances ni leurs présences

### Requirement: PX et déverrouillage tenus par le MJ
Sur une fiche rattachée à une table, seul le MJ de la table SHALL changer les PX (`xp`) et le déverrouillage de niveau (`level_unlock`). Une fiche SHALL naître sans `level_unlock`. Une fiche libre SHALL garder ses PX modifiables par son propriétaire. Le reste de la fiche SHALL rester modifiable comme avant.

#### Scenario: Le joueur s'accorde un niveau
- **WHEN** Hugo écrit `level_unlock` sur Aldric, rattaché à Brumeval
- **THEN** le serveur refuse la modification

#### Scenario: Le joueur change ses PX
- **WHEN** Hugo passe Aldric de 7 475 à 14 000 PX
- **THEN** le serveur refuse la modification

#### Scenario: Le MJ accorde un niveau
- **WHEN** Camille accorde le niveau 6 à Aldric
- **THEN** le serveur enregistre `level_unlock`

#### Scenario: Fiche libre
- **WHEN** Hugo change les PX d'un personnage qui n'est rattaché à aucune table
- **THEN** le serveur enregistre la modification

#### Scenario: Fiche créée déverrouillée
- **WHEN** Hugo crée une fiche avec un `level_unlock`
- **THEN** le serveur la refuse

#### Scenario: Montée de niveau du joueur
- **WHEN** Hugo enregistre Aldric monté au niveau 6, sans toucher aux PX
- **THEN** le serveur enregistre la fiche
