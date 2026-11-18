## ADDED Requirements

### Requirement: Jauge de difficulté
Le kit SHALL fournir `DifficultyGauge`, qui affiche :
- la difficulté (libellé et icône) ;
- une barre remplie selon les PX, avec les repères Faible, Modérée et Élevée et leurs valeurs ;
- le total de PX et une légende.

La barre et l'icône SHALL être `outline` sous Faible, puis couleur des soins, de l'alerte ou des dégâts. La jauge SHALL être une région annoncée aux lecteurs d'écran, avec la difficulté, les PX et la légende.

#### Scenario: Le relais du Sel
- **WHEN** la jauge reçoit Modérée, 3 000 PX et les repères 2 000, 3 000 et 4 400
- **THEN** elle affiche « Modérée », les trois repères, « 3 000 PX » et « 4 PJ de niveau 5 », en couleur d'alerte avec l'icône d'avertissement

#### Scenario: Au-delà d'Élevée
- **WHEN** les PX dépassent largement le seuil Élevé
- **THEN** la barre est pleine
