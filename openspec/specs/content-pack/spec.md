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
