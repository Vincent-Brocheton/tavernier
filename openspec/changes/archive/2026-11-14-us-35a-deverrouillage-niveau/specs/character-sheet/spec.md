## ADDED Requirements

### Requirement: Déverrouillage de la montée de niveau
Pour une fiche rattachée à une table, la montée au niveau n + 1 SHALL être déverrouillée dans trois cas seulement :
- les PX atteignent le seuil du niveau n + 1 (table en PX) ;
- le MJ a accordé ce niveau (table en jalons) ;
- le MJ a débloqué ce niveau par dérogation (les deux modes).

Les seuils SHALL être ceux de la table « Évolution du personnage » du SRD. Une fiche hors table, ou de niveau 20, n'a pas de déverrouillage : la première monte librement, la seconde ne monte plus.

#### Scenario: Seuil atteint
- **WHEN** une fiche de niveau 5 d'une table en PX a 14 000 PX
- **THEN** la montée au niveau 6 est déverrouillée, d'origine « Seuil de 14 000 PX atteint »

#### Scenario: Seuil non atteint
- **WHEN** Aldric, niveau 5, a 7 475 PX
- **THEN** rien n'est déverrouillé, et la progression est 7 475 / 14 000 PX

#### Scenario: Niveau accordé en jalons
- **WHEN** le MJ accorde le niveau 6 à Aldric (niveau 5) avec le motif « Varga capturée, le relais du Sel libéré »
- **THEN** la montée au niveau 6 est déverrouillée, d'origine « Niveau 6 accordé par Camille », avec le motif

#### Scenario: PX en jalons
- **WHEN** une fiche d'une table en jalons a assez de PX pour le niveau suivant
- **THEN** rien n'est déverrouillé

### Requirement: Bandeau de montée de niveau
La fiche d'une table SHALL afficher le bouton « Monter au niveau n » seulement si la montée est déverrouillée, dans un bandeau qui dit son origine. « Plus tard » SHALL réduire ce bandeau en puce près du nom jusqu'à la montée. Sans déverrouillage, l'en-tête SHALL montrer la progression en PX dans une table en PX, et rien dans une table en jalons.

#### Scenario: Bouton caché sans déverrouillage
- **WHEN** Aldric (7 475 PX, table en PX) ouvre sa fiche
- **THEN** il voit « 7 475 / 14 000 PX » et aucun bouton « Monter au niveau 6 »

#### Scenario: Plus tard
- **WHEN** le joueur touche « Plus tard » sur le bandeau
- **THEN** le bandeau devient une puce « Niveau 6 » près du nom, qui le rouvre

### Requirement: Dérogation du MJ
Sur la fiche d'un joueur de sa table, le MJ SHALL pouvoir débloquer le niveau suivant, avec un motif facultatif. L'origine affichée est alors « Niveau n débloqué par … (dérogation) ».

#### Scenario: Dérogation
- **WHEN** Camille débloque le niveau 4 de Kael (niveau 3)
- **THEN** Kael voit « Niveau 4 débloqué par Camille (dérogation) » et le bouton « Monter au niveau 4 »
