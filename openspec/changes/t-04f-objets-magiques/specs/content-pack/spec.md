## ADDED Requirements

### Requirement: Type d'entité objet magique
Le format de pack SHALL accepter le type `magic-item`, avec sa catégorie, sa rareté, sa ligne de type, son harmonisation et son texte. Un objet magique sans texte, ou dont la rareté ou la catégorie est inconnue, SHALL être refusé.

#### Scenario: Harmonisation réservée
- **WHEN** on lit un objet dont l'harmonisation exige une classe
- **THEN** `attunement` est vrai et `attunement_by` donne la créature exigée

#### Scenario: Objet sans texte
- **WHEN** une entité `magic-item` n'a pas de texte
- **THEN** elle est refusée à la validation

### Requirement: Objets magiques du SRD
Le pack SRD SHALL contenir les 258 objets magiques du SRD 5.2.1, avec le texte copié du PDF. Les tables d'un objet SHALL rester lisibles ligne par ligne, à leur place dans le texte.

#### Scenario: Cape de protection (SRD p. 235)
- **WHEN** on lit `srd:magic-item:cloak-of-protection`
- **THEN** c'est un objet merveilleux peu courant qui exige l'harmonisation

#### Scenario: Bâton de guérison
- **WHEN** on lit `srd:magic-item:staff-of-healing`
- **THEN** l'harmonisation exige « un Barde, Clerc ou Druide »

#### Scenario: Rareté variable
- **WHEN** on lit `srd:magic-item:weapon-plus-1-2-or-3`
- **THEN** sa rareté vaut `varies` et sa ligne de type cite les trois raretés

#### Scenario: Artefact
- **WHEN** on lit `srd:magic-item:orb-of-dragonkind`
- **THEN** sa rareté vaut `artifact`

#### Scenario: Potions de guérison
- **WHEN** on lit `srd:magic-item:potions-of-healing`
- **THEN** son texte associe chaque potion à ses points de vie sur une même ligne
