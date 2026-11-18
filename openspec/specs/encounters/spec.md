# encounters Specification

## Purpose
TBD - created by archiving change us-19a-rencontres-donnees. Update Purpose after archive.

## Requirements

### Requirement: Budget de PX d'une rencontre
Le moteur SHALL donner, pour chaque niveau de 1 à 20, les seuils Faible, Modérée et Élevée de la table « Budget de PX par personnage » du SRD. Le budget d'une rencontre SHALL être la somme des seuils de chaque personnage présent, selon son niveau.

#### Scenario: Quatre PJ de niveau 5 ([D1])
- **WHEN** Aldric, Mira, Thalia et Brannoc, tous de niveau 5, sont présents
- **THEN** le budget est Faible 2 000, Modérée 3 000, Élevée 4 400

#### Scenario: Niveaux mêlés
- **WHEN** trois PJ de niveau 5 et Kael, de niveau 3, sont présents
- **THEN** le budget est Faible 1 650, Modérée 2 475, Élevée 3 700

#### Scenario: Niveau 20
- **WHEN** un seul PJ de niveau 20 est présent
- **THEN** le budget est Faible 6 400, Modérée 13 200, Élevée 22 000

### Requirement: Difficulté d'une rencontre
La difficulté SHALL être le plus haut seuil que les PX des adversaires atteignent : Élevée, Modérée ou Faible ; sous le seuil Faible, la rencontre SHALL être « sous le budget faible ».

#### Scenario: Le relais du Sel ([D1])
- **WHEN** 3 000 PX d'adversaires affrontent quatre PJ de niveau 5
- **THEN** la rencontre est Modérée

#### Scenario: Embuscade sur la route ([D1])
- **WHEN** 300 PX d'adversaires affrontent quatre PJ de niveau 5
- **THEN** la rencontre est sous le budget faible

#### Scenario: Seuils au niveau 1 ([D1])
- **WHEN** quatre PJ de niveau 1 affrontent 300 PX, puis 200 PX d'adversaires
- **THEN** la première rencontre est Modérée, la seconde Faible

#### Scenario: Au-delà d'Élevée
- **WHEN** 5 000 PX d'adversaires affrontent quatre PJ de niveau 5
- **THEN** la rencontre est Élevée

### Requirement: Journal du combat
Le moteur SHALL décrire un combat par un journal d'événements à liste fermée (`combatant_added`, `combatant_removed`, `initiative_rolled`, `order_set`, `combat_started`, `turn_advanced`, `counter_used`, `counter_restored`, `undo`). L'état du combat SHALL être la projection du journal, dans l'ordre des événements. Un type inconnu SHALL être refusé. `undo` SHALL retirer de la projection l'événement qu'il désigne.

#### Scenario: Projection
- **WHEN** le journal ajoute Aldric et Varga, puis leurs jets d'initiative
- **THEN** l'état contient les deux combattants avec leur total

#### Scenario: Annulation
- **WHEN** le MJ annule le dernier « tour suivant »
- **THEN** le combattant actif redevient le précédent

#### Scenario: Type inconnu
- **WHEN** un événement de type « boule_de_feu » est lu
- **THEN** il est refusé

### Requirement: Jet d'initiative
Le jet d'initiative SHALL être un d20 plus le bonus d'initiative. La surprise SHALL donner le Désavantage ; Avantage et Désavantage SHALL s'annuler. Un groupe à initiative commune SHALL n'avoir qu'un jet pour tous ses membres.

#### Scenario: Aldric ([C3])
- **WHEN** Aldric (+4, Avantage) tire 15 et 11
- **THEN** son initiative est 19, dé écarté 11

#### Scenario: Brannoc surpris ([C3])
- **WHEN** Brannoc (+2), surpris, tire 6 et 14
- **THEN** son initiative est 8, dé écarté 14

#### Scenario: Avantage et surprise
- **WHEN** un combattant a l'Avantage et est surpris
- **THEN** il lance un seul d20

### Requirement: Ordre d'initiative et égalités
L'ordre par défaut SHALL suivre le total décroissant, puis le bonus décroissant. Les unités à égalité de total SHALL être signalées avec qui décide :
- le MJ, entre monstres ou entre un monstre et un PJ ;
- les joueurs concernés, entre PJ.

L'ordre fixé par le MJ (`order_set`) SHALL remplacer l'ordre par défaut ; un combattant ajouté ensuite SHALL entrer à sa place d'initiative.

#### Scenario: Le relais du Sel ([C3])
- **WHEN** Thalia 22, Aldric 19, Varga 17, Vétérans 1–2 15, Loups sanguinaires 1–3 15, Bandits 1–4 12, l'ogre 9, Brannoc 8 et Mira 8 sont tirés
- **THEN** l'ordre suit ces totaux ; l'égalité à 15 est au MJ, celle à 8 aux joueurs de Brannoc et de Mira

#### Scenario: Réordonner
- **WHEN** le MJ place les loups avant les vétérans
- **THEN** l'ordre garde ce choix

### Requirement: Rounds et tours
`combat_started` SHALL ouvrir le round 1 sur la première unité. `turn_advanced` SHALL passer à l'unité suivante, puis au round suivant après la dernière. Au début du tour d'une unité, sa réaction et ses actions légendaires SHALL lui être rendues. Un combattant SHALL pouvoir être ajouté ou retiré en cours de combat ; le retrait du combattant actif SHALL passer le tour à l'unité suivante.

#### Scenario: Tour suivant
- **WHEN** le combat commence et le MJ passe neuf tours sur neuf unités
- **THEN** le round 2 commence sur Thalia

#### Scenario: Réaction rendue
- **WHEN** Varga utilise sa réaction au round 1
- **THEN** elle est utilisée jusqu'au début du tour de Varga au round 2

#### Scenario: Retrait du combattant actif
- **WHEN** l'ogre est retiré pendant son tour
- **THEN** le tour passe à Brannoc

### Requirement: Compteurs d'un combattant
Le moteur SHALL suivre, par combattant :
- la réaction ;
- les actions légendaires, rendues au début de son tour ;
- les résistances légendaires, jamais rendues pendant la rencontre ;
- les capacités à recharge, rendues par un d6 réussi.

#### Scenario: Actions légendaires
- **WHEN** un dragon a 3 actions légendaires et en utilise 2
- **THEN** il lui en reste 1, puis 3 au début de son tour

#### Scenario: Recharge
- **WHEN** le souffle (recharge 5–6) est utilisé, puis le d6 donne 5 au début de son tour
- **THEN** le souffle est de nouveau disponible ; un 4 ne l'aurait pas rendu

### Requirement: Préparation des combattants
Le moteur SHALL numéroter les membres d'un groupe (« Vétéran 1 », « Vétéran 2 » ; un seul exemplaire garde son nom). Il SHALL aussi tirer les PV d'après les dés de vie (« 8d8 + 16 ») pour le mode « Jet au lancement ».

#### Scenario: Numérotation
- **WHEN** 3 loups sanguinaires sont préparés
- **THEN** ils s'appellent « Loup sanguinaire 1 » à « Loup sanguinaire 3 »

#### Scenario: PV tirés
- **WHEN** les PV du chef de bande (« 8d8 + 16 ») sont tirés
- **THEN** ils valent de 24 à 80
