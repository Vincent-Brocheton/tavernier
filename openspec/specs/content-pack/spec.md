# content-pack Specification

## Purpose
TBD - created by archiving change t-04a-sorts-srd. Update Purpose after archive.

## Requirements

### Requirement: Entités validées à la lecture
Une entité de pack SHALL avoir un identifiant `{namespace}:{type}:{slug}` dont le type est le sien, un type connu et des données conformes à ce type. Tout champ inconnu, toute opération d'effet hors DSL v1 et tout slug réservé par Windows SHALL rendre l'entité invalide, avec un problème qui nomme le fichier et le champ (format `.dndpack` v1, US-02).

#### Scenario: Champ inconnu
- **WHEN** une entité porte un champ de données absent de son type
- **THEN** elle est refusée avec le chemin du champ

#### Scenario: Opération inconnue
- **WHEN** un effet utilise une opération hors de la liste fermée du DSL v1
- **THEN** l'entité est refusée

### Requirement: Références résolues
Le build du pack SRD SHALL échouer si une référence d'une entité vers une autre ne se résout pas dans le pack, ou vise une entité d'un autre type que celui attendu, en listant chaque problème avec son fichier.

#### Scenario: Référence cassée
- **WHEN** un don cite un sort absent du pack
- **THEN** le build échoue et nomme le fichier du don

### Requirement: Archive déterministe et bornée
Les mêmes sources SHALL produire les mêmes octets d'archive. La lecture d'une archive SHALL refuser une archive de plus de 20 Mo, de plus de 10 000 entités, de profondeur JSON supérieure à 32, ou dont le nombre d'entités ou la somme de contrôle ne correspondent pas au manifeste (ENF-09).

#### Scenario: Deux builds
- **WHEN** le pack SRD est construit deux fois depuis les mêmes sources
- **THEN** les deux archives sont identiques octet pour octet

#### Scenario: Somme de contrôle fausse
- **WHEN** `entities.json` est modifié sans mettre à jour le manifeste
- **THEN** la lecture de l'archive est refusée

### Requirement: Type d'entité sort
Le format SHALL connaître le type `spell`. Un sort porte :
- son niveau, de 0 (sort mineur) à 9 ;
- son école, parmi les huit du SRD ;
- son temps d'incantation et sa durée, tels que dans le SRD ;
- son caractère de rituel et de concentration ;
- sa portée, en pieds ou par genre : personnelle, contact, champ de vision, illimitée ou spéciale ;
- ses composantes V, S et M (texte, coût en pièces de cuivre, composant consommé) ;
- son texte de règles en français.

Un sort ne cite aucune classe : c'est la classe qui porte sa liste de sorts.

#### Scenario: Niveau hors bornes
- **WHEN** un sort déclare le niveau 10
- **THEN** il est refusé

#### Scenario: Portée en pieds
- **WHEN** le SRD donne une portée de 45 m
- **THEN** le sort stocke une portée de 150 pieds

### Requirement: Sorts du SRD 5.2.1
Le pack SRD SHALL contenir les 339 sorts du SRD 5.2.1 français, dont 27 sorts mineurs. Leur texte est copié du PDF officiel, sans traduction, et chacun porte le slug anglais de son nom officiel.

#### Scenario: Boule de feu (SRD p. 121)
- **WHEN** on lit `srd:spell:fireball`
- **THEN** c'est « Boule de feu », sort d'Évocation du niveau 3, incanté en une action, portée 150 pieds, composantes V, S, M (« une boulette de guano de chauve-souris et de soufre »), durée instantanée, ni rituel ni concentration ; son texte cite 8d6 dégâts de feu et l'emplacement de niveau supérieur

#### Scenario: Composant coûteux consommé
- **WHEN** on lit `srd:spell:raise-dead` (Rappel à la vie)
- **THEN** son composant matériel coûte 50 000 pc (500 po) et est consommé

#### Scenario: Comptes
- **WHEN** on compte les sorts du pack
- **THEN** on obtient 339 sorts, 27 de niveau 0, au moins un de chaque niveau de 1 à 9 et au moins un de chaque école

### Requirement: Liste de sorts d'une classe
Une classe SHALL pouvoir déclarer sa liste de sorts et sa caractéristique d'incantation. Chaque sort de la liste SHALL être une référence résolue vers une entité de type `spell`.

#### Scenario: Référence vers un autre type
- **WHEN** la liste de sorts d'une classe cite une aptitude au lieu d'un sort
- **THEN** le build échoue et nomme le fichier de la classe

#### Scenario: Classe sans sorts
- **WHEN** une classe ne déclare pas de liste de sorts (Barbare, Guerrier)
- **THEN** elle est valide et sa liste est vide

### Requirement: Classes du SRD, lot 2
Le pack SRD SHALL contenir le Barbare, le Barde, le Clerc, le Druide, l'Ensorceleur et le Magicien. Chacun SHALL avoir :
- ses traits de base ;
- sa table de progression sur 20 niveaux ;
- sa sous-classe du SRD ;
- une aptitude par entrée « Niveau N : … » de la classe et de la sous-classe, avec le texte copié du PDF.

Les aptitudes calculables ou à utilisations SHALL porter les effets prévus par l'inventaire des aptitudes (`docs/dsl/INVENTAIRE_APTITUDES.md`).

#### Scenario: Barbare (SRD p. 30)
- **WHEN** on lit `srd:class:barbarian`
- **THEN** son dé de vie est d12, ses jets de sauvegarde Force et Constitution, et sa colonne Rages vaut 2 au niveau 1 et 6 au niveau 20

#### Scenario: Défense sans armure du Barbare (SRD p. 30)
- **WHEN** on lit l'aptitude Défense sans armure du Barbare
- **THEN** elle porte la formule de CA 10 + Dextérité + Constitution, bouclier permis, sans armure

#### Scenario: Lanceur de sorts complet
- **WHEN** on lit la table du Magicien au niveau 20
- **THEN** ses emplacements sont 4, 3, 3, 3, 3, 2, 2, 1, 1 du niveau 1 au niveau 9, et sa caractéristique d'incantation est l'Intelligence

#### Scenario: Listes de sorts
- **WHEN** on compare la liste de sorts de chaque classe aux classes citées dans l'en-tête de chaque sort du SRD
- **THEN** elles sont identiques

### Requirement: Classes du SRD, lot 3
Le pack SRD SHALL contenir le Moine, l'Occultiste, le Paladin, le Rôdeur et le Roublard. Chacun SHALL avoir :
- ses traits de base ;
- sa table de progression sur 20 niveaux ;
- sa sous-classe du SRD ;
- une aptitude par entrée « Niveau N : … », avec le texte copié du PDF ;
- les effets prévus par l'inventaire des aptitudes.

#### Scenario: Moine (SRD p. 64)
- **WHEN** on lit `srd:class:monk`
- **THEN** son dé d'Arts martiaux vaut 6 au niveau 1 et 12 au niveau 20, et son Déplacement sans armure vaut 10 pieds au niveau 2 et 30 pieds au niveau 18

#### Scenario: Magie de pacte (SRD p. 68)
- **WHEN** on lit la table de l'Occultiste aux niveaux 1, 13 et 17
- **THEN** il a 1 emplacement de niveau 1, puis 3 emplacements de niveau 5, puis 4 emplacements de niveau 5

#### Scenario: Attaque sournoise (SRD p. 84)
- **WHEN** on lit la table du Roublard aux niveaux 1 et 19
- **THEN** l'Attaque sournoise compte 1 dé puis 10 dés

#### Scenario: Imposition des mains (SRD p. 75)
- **WHEN** on lit l'aptitude Imposition des mains
- **THEN** sa réserve vaut 5 fois le niveau de Paladin et se recharge au Repos long

#### Scenario: Demi-lanceurs
- **WHEN** on lit les tables du Paladin et du Rôdeur au niveau 20
- **THEN** leurs emplacements sont 4, 3, 3, 3, 2 du niveau 1 au niveau 5
