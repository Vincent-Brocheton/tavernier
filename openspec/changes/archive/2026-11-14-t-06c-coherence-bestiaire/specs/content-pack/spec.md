## MODIFIED Requirements

### Requirement: Cohérence d'un monstre
La construction d'un pack SHALL refuser un monstre dans les cas suivants :
- son FP, ses PX ou son bonus de maîtrise ne concordent pas avec la table du SRD ;
- une de ses références (type de dégâts, état, compétence) ne se résout pas ;
- il a une action Légendaire sans nombre d'utilisations ;
- un de ses JS ne vaut ni le modificateur ni le modificateur plus le bonus de maîtrise ;
- sa Perception passive ne vaut pas 10 plus son bonus de Perception (la compétence, ou à défaut le modificateur de Sagesse) ;
- ses PV ne valent pas la moyenne de ses dés de vie ;
- les dégâts moyens d'une attaque ne valent pas la moyenne de leurs dés.

#### Scenario: PX incohérents
- **WHEN** un monstre de FP 1/4 annonce 100 PX
- **THEN** la construction échoue en nommant le monstre

#### Scenario: JS incohérent
- **WHEN** un monstre de Dextérité 15 (+2) et de bonus de maîtrise +2 annonce un JS de Dextérité de +3
- **THEN** la construction échoue en nommant le JS

#### Scenario: PV incohérents
- **WHEN** un monstre annonce 12 PV pour 2d8 + 2
- **THEN** la construction échoue : la moyenne est 11

#### Scenario: Perception passive incohérente
- **WHEN** un monstre a Perception +5 et une Perception passive de 13
- **THEN** la construction échoue : 15 attendu

## ADDED Requirements

### Requirement: Bestiaire relu contre le PDF
Les valeurs du bestiaire SHALL concorder avec une seconde lecture du texte du PDF en mise en page : FP et PX, PV et dés de vie, caractéristiques et JS, CA et Initiative. Les seuls écarts permis sont les coquilles corrigées et les lignes illisibles de la mise en page, listées une à une.

#### Scenario: Seconde lecture
- **WHEN** on compare les sources au texte en mise en page
- **THEN** les seuls écarts sont les coquilles corrigées (Archimage, Jeune dragon blanc) et les lignes illisibles listées

### Requirement: Fiche de relecture du bestiaire
`extract-monsters` SHALL écrire `docs/srd/RELECTURE_BESTIAIRE.md`. La fiche donne d'abord les points à vérifier en priorité, chacun avec sa page : coquilles corrigées, Initiative, compétences et bonus d'attaque hors des règles de calcul du SRD, lectures incertaines. Elle donne ensuite les profils par page.

#### Scenario: Écart à relire
- **WHEN** l'Initiative de l'Archimage (+7) ne vaut pas son modificateur de Dextérité (+2) plus 0, 1 ou 2 fois son bonus de maîtrise (+4)
- **THEN** la fiche de relecture le signale avec sa page, et la construction réussit
