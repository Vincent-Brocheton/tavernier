## ADDED Requirements

### Requirement: Entrées du journal
Le moteur SHALL rendre, pour chaque événement du journal et dans son ordre, une entrée qui porte :
- l'événement et le round où il a eu lieu ;
- le fait qu'il soit annulé ;
- pour les dégâts et les soins, les PV avant et après de chaque cible, et sa chute éventuelle.

Les noms des combattants SHALL rester connus après leur retrait du combat.

#### Scenario: Dégâts sur Mira (Combat-Desktop)
- **WHEN** Mira, à 22 PV, subit 12 dégâts tranchants au round 3
- **THEN** l'entrée porte le round 3 et Mira de 22 à 10 PV

#### Scenario: Chute
- **WHEN** Brannoc, à 5 PV, subit 8 dégâts perforants
- **THEN** l'entrée porte Brannoc de 5 à 0 PV, Inconscient

#### Scenario: Événement annulé
- **WHEN** des dégâts sont annulés
- **THEN** leur entrée est marquée annulée, et l'annulation a sa propre entrée

### Requirement: Journal du MJ
Le combat SHALL ouvrir le journal de la rencontre. Le journal SHALL :
- lister les entrées de la plus récente à la plus ancienne, chacune avec une phrase et « R<round> · <heure> » ;
- offrir les filtres Tout, PV, États et Étude ;
- afficher le nombre d'actions annulables ;
- barrer les entrées annulées.

Il SHALL rester réservé au MJ (EF-ACT-07, RLS du journal).

#### Scenario: Filtre PV
- **WHEN** le MJ choisit le filtre PV
- **THEN** seuls les dégâts, les soins, les PV temporaires et les jets contre la mort restent

#### Scenario: Annulations disponibles
- **WHEN** le journal porte 24 actions, dont une annulée
- **THEN** il annonce 23 actions annulables (EF-LOG-02 : 20 au minimum)

### Requirement: Résumé de fin de rencontre
Le moteur SHALL résumer une rencontre à partir de son journal (EF-LOG-03) :
- le nombre de rounds ;
- les adversaires tombés (hors de combat, morts ou assommés), avec le round de leur chute, sur le nombre d'adversaires présents ;
- les PJ tombés à 0 PV, avec leur round et leur état final ;
- les moments notés : Étude, Influence, Observation, concentration perdue ;
- les PX au total, qui sont ceux des adversaires encore dans le combat à la fin. Un adversaire retiré du combat, comme en fuite, ne compte pas ([D1]).

#### Scenario: Le relais du Sel ([D1], [C11])
- **WHEN** le Chef de bande, 2 vétérans, l'ogre, 3 loups sanguinaires et 4 bandits sont restés dans le combat
- **THEN** la rencontre vaut 3 000 PX, soit 750 par PJ pour 4 PJ

#### Scenario: Embuscade sur la route ([D1])
- **WHEN** Varga, Chef de bande ajoutée en renfort, est retirée du combat en fuite
- **THEN** ses 450 PX ne comptent pas

#### Scenario: Chutes
- **WHEN** l'ogre tombe à 0 PV au round 4, Varga est assommée au round 5 et Brannoc tombe au round 2 puis est stabilisé
- **THEN** le résumé les porte avec ces rounds, Varga assommée et Brannoc stabilisé

### Requirement: Clôture de la rencontre
« Terminer la rencontre » SHALL montrer le résumé ([C11]) avec les PX de chaque PJ, modifiables. Par défaut, chaque PJ reçoit le total divisé par le nombre de PJ, arrondi à l'inférieur. « Clore » SHALL écrire un événement `encounter_finished` (rounds, PX par PJ), puis passer la rencontre « Terminée ». Une rencontre terminée SHALL montrer son résumé, avec les PX retenus.

#### Scenario: Clore
- **WHEN** le MJ clôt une rencontre de 3 000 PX à 4 PJ
- **THEN** le journal porte `encounter_finished` avec 750 PX pour chacun, et la rencontre est « Terminée »

#### Scenario: PX modifiés
- **WHEN** le MJ donne 700 PX à Brannoc avant de clore
- **THEN** l'événement porte 700 PX pour Brannoc

