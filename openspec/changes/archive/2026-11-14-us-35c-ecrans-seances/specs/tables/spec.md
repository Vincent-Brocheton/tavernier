## ADDED Requirements

### Requirement: Onglet des séances
La page d'une table SHALL avoir un onglet « Séances » pour le MJ et pour les joueurs. Sans séance, il SHALL afficher « Aucune séance » et la part des joueurs dont la fiche est validée. Avec des séances, il SHALL afficher « Prochaine » (séances préparées ou en cours) et « Passées » (closes). Chaque séance SHALL avoir son pavé de date, « Séance n », son titre et un badge d'état avec libellé. Seul le MJ SHALL voir les boutons de création. Un joueur dont le personnage est prévu à la prochaine séance SHALL lire « Personnage attendu : » suivi du nom.

#### Scenario: Table sans séance, vue du MJ
- **WHEN** Camille ouvre l'onglet « Séances » d'une table sans séance, où 2 des 4 emplacements ont une fiche validée
- **THEN** elle lit « Aucune séance », « Préparer la séance 1 », « Jouer tout de suite, sans préparation » et « 2 joueurs sur 4 ont une fiche validée. Les autres pourront rejoindre la séance en cours. »

#### Scenario: Liste des séances
- **WHEN** Brumeval a la séance 12 préparée et la séance 11 close
- **THEN** « Prochaine » montre « Séance 12 », « Le relais du Sel » et « Préparée », et « Passées » montre « Séance 11 » et « Close »

#### Scenario: Vue du joueur
- **WHEN** Hugo ouvre l'onglet, et Aldric est prévu à la séance 12
- **THEN** il lit « Personnage attendu : Aldric Varenne », sans aucun bouton de création

### Requirement: Créer une séance
Le MJ SHALL créer une séance de deux façons :
- « Préparer la séance n » crée une séance préparée, datée du jour, titrée « Séance n », avec tous les personnages de la table prévus, puis ouvre sa préparation ;
- « Jouer tout de suite » crée la même séance, mais déjà en cours.

#### Scenario: Préparer
- **WHEN** Camille touche « Préparer la séance 1 »
- **THEN** la séance 1 est créée, préparée et datée du jour, Aldric et Mira y sont prévus, et sa préparation s'ouvre

#### Scenario: Jouer tout de suite
- **WHEN** Camille touche « Jouer tout de suite, sans préparation »
- **THEN** une séance du jour est créée en cours, et la liste la montre avec « En cours »

### Requirement: Préparer une séance
L'écran de préparation SHALL montrer le titre et la date, modifiables et enregistrés au fil de la saisie, puis les présences prévues : un interrupteur par personnage de la table, avec son joueur, sa classe et son niveau. « Ouvrir la séance » SHALL passer une séance préparée en cours.

#### Scenario: Titre et date
- **WHEN** Camille saisit « Le relais du Sel » et choisit le 30 octobre 2026
- **THEN** la séance garde ce titre et cette date

#### Scenario: Présence retirée
- **WHEN** Camille décoche Kael
- **THEN** Kael n'est plus prévu à la séance

#### Scenario: Ouvrir la séance
- **WHEN** Camille touche « Ouvrir la séance »
- **THEN** la séance passe « En cours »
