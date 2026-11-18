## ADDED Requirements

### Requirement: Dégâts
Un événement `damage` SHALL infliger un montant d'un type de dégâts à une ou plusieurs cibles. Pour chaque cible :
- l'Immunité annule les dégâts ;
- la Résistance les divise par deux, arrondi à l'inférieur, puis la Vulnérabilité les double ;
- les défenses du profil s'ajoutent aux corrections manuelles (« Résistance ½ », « Vulnérabilité ×2 ») ;
- les PV temporaires sont consommés en premier ;
- les PV ne descendent pas sous 0.

#### Scenario: Mira ([1b])
- **WHEN** Mira, à 22 PV sur 38, subit 12 dégâts tranchants
- **THEN** elle est à 10 PV

#### Scenario: Résistance puis Vulnérabilité (SRD)
- **WHEN** une créature résistante et vulnérable au feu subit 23 dégâts de feu
- **THEN** elle en subit 22 (23 ÷ 2 = 11, puis × 2)

#### Scenario: Immunité
- **WHEN** un dragon noir, immunisé à l'acide, subit 30 dégâts d'acide
- **THEN** ses PV ne changent pas

#### Scenario: PV temporaires d'abord
- **WHEN** Aldric, à 41 PV et 5 PV temporaires, subit 8 dégâts
- **THEN** il a 0 PV temporaire et 38 PV

#### Scenario: Plusieurs cibles
- **WHEN** deux loups subissent 10 dégâts de feu
- **THEN** chacun perd 10 PV

### Requirement: Soins et PV temporaires
Un soin SHALL rendre des PV sans dépasser le maximum. Des PV temporaires SHALL ne pas se cumuler : le plus élevé est gardé, sauf demande de remplacement.

#### Scenario: Soin plafonné
- **WHEN** Mira, à 10 PV sur 38, reçoit 40 PV de soin
- **THEN** elle est à 38 PV

#### Scenario: PV temporaires non cumulés
- **WHEN** Aldric a 5 PV temporaires et en reçoit 3, puis 8
- **THEN** il en a 5, puis 8

### Requirement: Zéro point de vie
À 0 PV, un PJ SHALL être Inconscient et faire ses jets contre la mort :
- trois réussites le stabilisent, trois échecs le tuent ;
- un 20 naturel lui rend 1 PV, un 1 naturel compte deux échecs ;
- chaque dégât subi à 0 PV compte un échec, deux sur un coup critique ;
- un soin le relève et remet ses jets à zéro.

À 0 PV, un monstre SHALL être hors de combat et rester dans l'ordre.

#### Scenario: Mira tombe
- **WHEN** Mira, à 10 PV, subit 15 dégâts
- **THEN** elle est à 0 PV, Inconsciente, sans réussite ni échec

#### Scenario: Coup critique à 0 PV
- **WHEN** Mira, à 0 PV avec un échec, subit un coup critique
- **THEN** elle compte trois échecs et meurt

#### Scenario: Stabilisée
- **WHEN** Mira réussit trois jets contre la mort
- **THEN** elle est stabilisée, toujours Inconsciente

#### Scenario: 20 naturel
- **WHEN** Mira obtient un 20 naturel
- **THEN** elle revient à 1 PV, consciente, et ses jets repartent de zéro

#### Scenario: Monstre hors de combat
- **WHEN** un loup tombe à 0 PV
- **THEN** il est hors de combat et reste dans l'ordre d'initiative

### Requirement: Aperçu des dégâts
Le moteur SHALL donner, pour une cible et des dégâts envisagés, les dégâts subis et les PV avant et après, sans rien écrire au journal.

#### Scenario: Aperçu
- **WHEN** le MJ envisage 12 dégâts tranchants sur Mira, à 22 PV
- **THEN** l'aperçu donne 12 dégâts, de 22 à 10 PV
