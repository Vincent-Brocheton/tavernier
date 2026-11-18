## ADDED Requirements

### Requirement: Écran de combat
À partir du round 1, l'écran SHALL afficher :
- le round et le nombre de combattants ;
- les combattants dans l'ordre d'initiative, avec leur initiative, leur nom, leur sorte (« PJ · Guerrier 5 » ou « Humanoïde · FP 2 »), leur CA et leurs PV ;
- l'unité active, mise en évidence avec « En cours » ;
- un en-tête par groupe à initiative commune.

« Tour suivant » SHALL rester visible en permanence, et « Annuler » SHALL retirer le dernier événement effectif.

#### Scenario: Tour suivant
- **WHEN** Camille touche « Tour suivant » sur le tour de Thalia
- **THEN** « En cours » passe à l'unité suivante, et après la dernière unité le round augmente

#### Scenario: Annuler
- **WHEN** Camille touche « Annuler » après un « Tour suivant »
- **THEN** le tour revient à l'unité précédente

### Requirement: Rappel de recharge
Au début du tour d'une unité, chaque capacité à recharge utilisée de ses membres SHALL être rappelée avec sa plage. « Lancer 1d6 » SHALL la rendre sur un résultat de la plage et dire le résultat ; « Rechargé » SHALL la rendre sans jet.

#### Scenario: Souffle du dragon
- **WHEN** le souffle (recharge 5–6) du dragon a été utilisé et que son tour commence
- **THEN** l'écran affiche « lancez 1d6 pour Souffle d'acide (recharge 5–6) », et « Rechargé » le rend disponible

### Requirement: Détail et compteurs d'un combattant
Le détail d'un combattant SHALL montrer sa CA, ses PV, le profil d'un monstre et ses compteurs (actions légendaires, résistance légendaire, réaction, recharges), avec utilisé et maximum. Toucher un compteur SHALL en utiliser une unité ou la rendre. Le détail SHALL permettre de retirer le combattant du combat.

#### Scenario: Action légendaire
- **WHEN** Camille touche un pion des actions légendaires du dragon
- **THEN** il en reste 2 sur 3

#### Scenario: Retirer
- **WHEN** Camille retire l'ogre du combat
- **THEN** l'ogre disparaît de l'ordre d'initiative

### Requirement: Ajouter un combattant en cours de combat
Le MJ SHALL ajouter un monstre ou un PNJ en cours de combat. Il SHALL être numéroté après ses semblables, recevoir aussitôt son jet d'initiative et entrer à sa place dans l'ordre.

#### Scenario: Renfort
- **WHEN** Camille ajoute un loup sanguinaire alors que « Loup sanguinaire 1 » à « 3 » combattent
- **THEN** « Loup sanguinaire 4 » entre dans l'ordre avec son initiative

### Requirement: Terminer la rencontre
« Terminer la rencontre » SHALL passer la rencontre « Terminée ».

#### Scenario: Fin
- **WHEN** Camille termine « Le relais du Sel »
- **THEN** la rencontre est « Terminée »
