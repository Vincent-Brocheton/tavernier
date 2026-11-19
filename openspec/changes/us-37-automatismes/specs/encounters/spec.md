## ADDED Requirements

### Requirement: Dégâts massifs
Un PJ SHALL mourir sur le coup quand des dégâts le font tomber à 0 PV avec un excédent au moins égal à ses PV max. À 0 PV, des dégâts subis au moins égaux à ses PV max SHALL le tuer. Le moteur SHALL exposer ce verdict pour l'aperçu, sans rien écrire au journal.

#### Scenario: Brannoc ([F2a])
- **WHEN** Brannoc, à 3 PV sur 27, subit 30 dégâts contondants
- **THEN** il est mort (excédent 27, égal à ses PV max)

#### Scenario: Excédent insuffisant
- **WHEN** Brannoc, à 3 PV sur 27, subit 29 dégâts
- **THEN** il est à 0 PV, Inconscient et vivant

#### Scenario: Dégâts à 0 PV
- **WHEN** Brannoc, à 0 PV sans échec, subit 27 dégâts
- **THEN** il est mort

### Requirement: Assommer
Un événement `damage` portant `knock_out` SHALL, pour une cible qui tomberait à 0 PV, la laisser à 1 PV avec l'état Inconscient. Un soin qui rend au moins 1 PV SHALL retirer cet état.

#### Scenario: Varga assommée ([F2b])
- **WHEN** Varga, à 7 PV, subit 9 dégâts tranchants avec `knock_out`
- **THEN** elle est à 1 PV avec l'état Inconscient, et pas hors de combat

#### Scenario: Pas de chute
- **WHEN** Varga, à 20 PV, subit 9 dégâts avec `knock_out`
- **THEN** elle est à 11 PV, sans état

#### Scenario: Réveil par un soin
- **WHEN** Varga assommée reçoit 2 PV de soin
- **THEN** elle est à 3 PV, sans l'état Inconscient

### Requirement: Soutien
L'issue `stabilized` d'un `death_save` SHALL stabiliser un PJ à 0 PV (Soutien réussi, Sagesse (Médecine) DD 10).

#### Scenario: Brannoc stabilisé ([F2c])
- **WHEN** Brannoc, à 0 PV avec un échec, est stabilisé par Mira
- **THEN** il est Stabilisé, toujours Inconscient ; le moindre dégât relance ses jets

### Requirement: Fin automatique de la concentration
La concentration d'un combattant SHALL prendre fin, avec ses effets liés et ses tests en attente, quand il tombe à 0 PV ou meurt, ou reçoit l'état Neutralisé, Inconscient, Paralysé, Pétrifié ou Étourdi. Le pavé de dégâts et la pose d'état SHALL l'annoncer avant validation.

#### Scenario: Mira tombe
- **WHEN** Mira, concentrée sur Bénédiction, tombe à 0 PV
- **THEN** sa concentration prend fin et Béni est retiré d'Aldric et Thalia

#### Scenario: Étourdie
- **WHEN** Mira, concentrée, reçoit l'état Étourdi
- **THEN** sa concentration prend fin

#### Scenario: Immunisée
- **WHEN** un combattant immunisé à l'état Étourdi le reçoit
- **THEN** sa concentration continue

#### Scenario: Assommée
- **WHEN** Mira, concentrée, est assommée
- **THEN** elle est à 1 PV, Inconsciente, et sa concentration prend fin

### Requirement: Réaction des PJ
La carte d'un PJ vivant SHALL montrer « Réaction disponible » ou « Réaction utilisée ». Un appui SHALL dépenser ou rendre la réaction, et elle SHALL revenir au début du tour du PJ, comme pour les monstres.

#### Scenario: Réaction rendue
- **WHEN** Aldric a utilisé sa réaction, puis son tour commence
- **THEN** sa carte montre « Réaction disponible »

### Requirement: Échange d'initiative (Vigilant)
Un événement `initiative_swapped` (`combatant`, `with`) SHALL échanger les initiatives de deux combattants. Il ne vaut que si toutes ces conditions sont réunies :
- le combat n'a pas commencé ;
- le premier a le don Vigilant ;
- les deux ont joué l'Initiative ;
- aucun des deux n'est Neutralisé.

Un ordre déjà choisi SHALL suivre l'échange. Le lancement SHALL proposer « <nom> : échanger… » pour chaque PJ qui a le don ([C3]).

#### Scenario: Aldric et Mira ([C3])
- **WHEN** Aldric (19, Vigilant) échange avec Mira (8)
- **THEN** Aldric a 8, Mira 19, et Mira joue avant lui

#### Scenario: Neutralisé
- **WHEN** Mira est Étourdie
- **THEN** l'échange est ignoré

#### Scenario: Combat commencé
- **WHEN** le round 1 a commencé
- **THEN** l'échange est ignoré

