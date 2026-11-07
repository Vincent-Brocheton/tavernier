## ADDED Requirements

### Requirement: Tuiles de valeur et décomposition
Le kit SHALL fournir `AbilityTile`, `StatTile` et `ValueBreakdown`. Une tuile SHALL rester touchable sur 48 dp au moins et s'annoncer au lecteur d'écran avec son libellé et sa valeur.

#### Scenario: Maîtrise
- **WHEN** une `AbilityTile` a un jet de sauvegarde maîtrisé
- **THEN** la maîtrise se lit à une icône, pas à la seule couleur

#### Scenario: Grand écran
- **WHEN** `showAdaptiveSheet` s'ouvre sur un écran large
- **THEN** le contenu est dans une boîte de dialogue
