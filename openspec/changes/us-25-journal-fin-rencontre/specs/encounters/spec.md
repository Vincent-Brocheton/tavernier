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
