## ADDED Requirements

### Requirement: Cibler des combattants
Sur l'écran de combat, toucher une carte SHALL en faire la seule cible, et un appui long SHALL ajouter ou retirer une cible. Le pied SHALL rappeler les cibles et proposer « Dégâts », « Soins » et « PV temp. ». Le détail d'un combattant SHALL s'ouvrir par son icône.

#### Scenario: Plusieurs cibles
- **WHEN** Camille touche « Loup 1 », puis appuie longuement sur « Loup 2 »
- **THEN** le pied affiche « Cibles : Loup 1, Loup 2 »

### Requirement: Pavé de dégâts et soins
Le pavé SHALL montrer les cibles, le montant saisi et son type, l'aperçu des PV de chaque cible, « Coup critique », les touches 0 à 9, « + », « − », « Vulnérabilité ×2 », « Résistance ½ », « PV temp. » et « Soins ». Il SHALL appliquer en une touche des dégâts, un soin ou des PV temporaires à toutes les cibles. Les dégâts SHALL suivre les règles du moteur (défenses, PV temporaires, 0 PV).

#### Scenario: Mira ([1b])
- **WHEN** Camille saisit 12, choisit « Tranchants » et voit l'aperçu de Mira
- **THEN** l'aperçu affiche « 22 → 10 / 38 PV », et « Appliquer 12 dégâts tranchants » porte Mira à 10 PV

#### Scenario: Addition de dés
- **WHEN** Camille saisit 7, « + », 5
- **THEN** le montant vaut 12

#### Scenario: Soins
- **WHEN** Camille passe en « Soins » et applique 8 sur Mira à 10 PV
- **THEN** Mira est à 18 PV

#### Scenario: Deux cibles, Résistance ½
- **WHEN** Camille applique 10 dégâts de feu avec « Résistance ½ » à deux loups
- **THEN** chacun perd 5 PV

### Requirement: État des PV sur les cartes
Chaque carte SHALL montrer une barre de PV colorée selon la part restante, les PV temporaires, et l'état à 0 PV :
- un PJ affiche « Inconscient » avec ses jets contre la mort, ou « Mort » ;
- un monstre est estompé, avec « Hors de combat ».

La feuille d'un PJ Inconscient SHALL permettre de saisir ses jets contre la mort.

#### Scenario: Mira tombe
- **WHEN** Mira tombe à 0 PV
- **THEN** sa carte affiche « Inconscient » et ses jets contre la mort, et sa feuille propose « Réussite » et « Échec »

#### Scenario: Loup hors de combat
- **WHEN** un loup tombe à 0 PV
- **THEN** sa carte affiche « Hors de combat »
