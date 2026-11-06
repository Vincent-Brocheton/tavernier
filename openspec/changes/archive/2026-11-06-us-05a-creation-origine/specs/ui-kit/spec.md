## ADDED Requirements

### Requirement: Composants de l'assistant
Le kit SHALL fournir la liste des étapes, la barre de progression du téléphone, le pied d'assistant, la carte de sélection et le badge de source. Une sélection SHALL se lire sans dépendre de la couleur seule, et chaque cible SHALL mesurer au moins 48 dp.

#### Scenario: Étape courante
- **WHEN** `WizardSteps` affiche l'étape 2 sur 9
- **THEN** l'étape 1 porte une coche et l'étape 2 est annoncée comme courante

#### Scenario: Suivant bloqué
- **WHEN** `WizardFooter` reçoit une raison de blocage
- **THEN** « Suivant » est désactivé et la raison s'affiche au-dessus

#### Scenario: Carte sélectionnée
- **WHEN** une `SelectionCard` est sélectionnée
- **THEN** elle affiche une coche et s'annonce sélectionnée aux lecteurs d'écran

### Requirement: Distances en mètres
Le kit SHALL afficher une distance stockée en pieds en mètres, à 1,5 m pour 5 pieds.

#### Scenario: Valeurs
- **WHEN** on formate 30 puis 35 pieds
- **THEN** on obtient « 9 m » puis « 10,50 m »
