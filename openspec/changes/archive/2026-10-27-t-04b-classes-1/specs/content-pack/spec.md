## ADDED Requirements

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
