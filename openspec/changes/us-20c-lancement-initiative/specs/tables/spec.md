## ADDED Requirements

### Requirement: Lancer une rencontre
« Lancer la rencontre » SHALL passer la rencontre « En cours » et créer ses combattants :
- les PJ présents, avec le bonus, l'Avantage d'initiative, la CA et les PV de leur fiche ;
- les monstres et PNJ, numérotés, avec l'initiative commune de leur groupe, la CA, les PV (moyens ou tirés selon la rencontre) et leurs compteurs (actions et résistances légendaires, recharges).

Les jets des monstres et des PNJ SHALL être lancés aussitôt, puis l'écran d'initiative SHALL s'ouvrir.

#### Scenario: Le relais du Sel
- **WHEN** Camille lance la rencontre avec Aldric et Mira présents, 2 vétérans à initiative commune et un ogre
- **THEN** la rencontre est « En cours », avec Aldric, Mira, « Vétéran 1 », « Vétéran 2 » et « Ogre », et les vétérans et l'ogre ont déjà leur jet

#### Scenario: PV tirés
- **WHEN** la rencontre est en « Jet au lancement »
- **THEN** les PV de chaque monstre sont tirés d'après ses dés de vie

### Requirement: Écran d'initiative
L'écran d'initiative SHALL montrer, par unité, le combattant, son bonus et son mode, son jet, son total et l'origine du jet. Il SHALL proposer :
- la saisie du dé gardé d'un PJ ;
- la surprise d'une unité (Désavantage, et nouveau jet pour un monstre) ;
- l'ordre du tour avec ses égalités et qui les tranche ;
- le réordonnancement de cet ordre.

« Commencer le round 1 » SHALL attendre que tous les jets soient saisis.

#### Scenario: Saisie d'un PJ
- **WHEN** Camille saisit 15 pour Aldric (+4)
- **THEN** son total est 19, et il prend sa place dans l'ordre du tour

#### Scenario: Égalité
- **WHEN** les vétérans et l'ogre font 15
- **THEN** l'ordre affiche « Égalité · le MJ décide » sur les deux

#### Scenario: Surprise
- **WHEN** Camille marque les vétérans surpris
- **THEN** ils affichent « Désavantage », et leur jet est relancé

#### Scenario: Commencer
- **WHEN** tous les jets sont saisis et Camille touche « Commencer le round 1 »
- **THEN** le round 1 commence sur la première unité de l'ordre
