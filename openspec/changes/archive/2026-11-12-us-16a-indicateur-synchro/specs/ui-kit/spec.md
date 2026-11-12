## ADDED Requirements

### Requirement: Indicateur de synchronisation
Le kit SHALL fournir `SyncIndicator`, à quatre états (synchronisé, en attente, hors ligne, conflit résolu), chacun avec son icône, sa couleur sémantique et le libellé fourni. En mode compact, seule l'icône SHALL s'afficher, le libellé restant accessible par infobulle et lecteur d'écran.

#### Scenario: En attente
- **WHEN** l'indicateur est en attente avec le libellé « 3 modifications en attente »
- **THEN** il montre le nuage et la flèche, et ce libellé

#### Scenario: Compact
- **WHEN** l'indicateur est compact
- **THEN** seul l'icône est visible, et le lecteur d'écran lit le libellé
