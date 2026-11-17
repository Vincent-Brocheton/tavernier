## ADDED Requirements

### Requirement: PNJ au serveur
Le serveur SHALL garder les PNJ d'une table (`npc_statblock`) : nom non vide, dossier, monstre de départ, bloc de stats, fiche liée, attitude (`friendly`, `indifferent` ou `hostile`, `indifferent` par défaut), informations cachées et date de création. Seul le MJ de la table SHALL les lire, les recevoir et les écrire ; l'écriture SHALL être refusée sur une table archivée ou sans MJ. Une fiche liée SHALL appartenir à la même table.

#### Scenario: PNJ du MJ
- **WHEN** Camille crée « Varga la Balafrée » à partir du chef de bande, dans le dossier « Guilde du Sel »
- **THEN** le PNJ est enregistré, Indifférent, et Camille le reçoit

#### Scenario: Les joueurs ne voient pas les PNJ
- **WHEN** Hugo, joueur de Brumeval, lit ou synchronise
- **THEN** il ne reçoit aucun PNJ, et le serveur refuse qu'il en crée un

#### Scenario: Attitude inconnue
- **WHEN** Camille enregistre l'attitude « méfiant »
- **THEN** le serveur la refuse

#### Scenario: Fiche d'une autre table
- **WHEN** Camille lie à un PNJ une fiche d'une autre table
- **THEN** le serveur refuse le PNJ

### Requirement: Fiches de PNJ cachées aux membres
Quand une table montre les fiches complètes, un membre SHALL lire et recevoir les fiches de PJ (`kind = 'pc'`) de la table, mais jamais celles de PNJ. Le propriétaire et le MJ SHALL toujours lire toutes les fiches de la table.

#### Scenario: Fiches visibles
- **WHEN** Brumeval montre les fiches complètes, et Camille y a la fiche complète d'Odran
- **THEN** Inès lit la fiche d'Aldric, mais pas celle d'Odran

#### Scenario: Le MJ lit sa fiche de PNJ
- **WHEN** Camille lit la fiche d'Odran
- **THEN** elle la lit
