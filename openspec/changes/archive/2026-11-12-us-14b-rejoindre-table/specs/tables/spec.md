## ADDED Requirements

### Requirement: Rejoindre une table
L'utilisateur SHALL pouvoir rejoindre une table par le lien d'une invitation ou en saisissant son code de 6 caractères. Rejoindre exige le réseau et un compte : sinon, la demande SHALL être gardée sur l'appareil et partir d'elle-même au retour du réseau ou à la connexion (EF-TAB-08). Un refus du serveur SHALL être expliqué selon son motif.

#### Scenario: Lien
- **WHEN** l'utilisateur connecté, en ligne, ouvre le lien d'une invitation valide
- **THEN** il devient joueur de la table et la page de la table s'ouvre

#### Scenario: Hors ligne
- **WHEN** l'utilisateur saisit un code sans réseau
- **THEN** l'app affiche « En attente du réseau… », garde le code, et la demande part au retour du réseau

#### Scenario: Sans compte
- **WHEN** l'utilisateur ouvre le lien sans être connecté
- **THEN** l'app garde le code et propose de se connecter ; la demande part à la connexion

#### Scenario: Code refusé
- **WHEN** le serveur refuse le code (inconnu, expiré, table archivée, trop d'essais)
- **THEN** l'app affiche le motif et oublie le code
