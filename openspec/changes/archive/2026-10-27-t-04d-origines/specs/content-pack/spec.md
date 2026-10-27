## ADDED Requirements

### Requirement: Espèces du SRD
Le pack SRD SHALL contenir les 9 espèces du SRD 5.2.1 : Drakéide, Elfe, Gnome, Goliath, Halfelin, Humain, Nain, Orc et Tieffelin. Chacune SHALL avoir :
- son type de créature, ses catégories de taille et sa Vitesse en pieds ;
- un trait par paragraphe du SRD, avec le texte copié du PDF ;
- les effets prévus par l'inventaire des aptitudes.

#### Scenario: Nain (SRD p. 90)
- **WHEN** on lit `srd:species:dwarf`
- **THEN** sa Vitesse vaut 30 pieds, sa Vision dans le noir 120 pieds, et Ténacité naine ajoute 1 point de vie maximum par niveau

#### Scenario: Goliath (SRD p. 89)
- **WHEN** on lit `srd:species:goliath`
- **THEN** sa Vitesse vaut 35 pieds et Ascendance gigante propose six bénéfices, utilisables autant de fois que le bonus de maîtrise par Repos long

#### Scenario: Lignage elfique (SRD p. 88)
- **WHEN** on choisit le lignage drow
- **THEN** la Vision dans le noir passe à 120 pieds, lumières dansantes est connu au niveau 1, lueurs féeriques au niveau 3 et ténèbres au niveau 5

#### Scenario: Taille au choix (SRD p. 90-91)
- **WHEN** on lit l'Humain et le Tieffelin
- **THEN** chacun propose les tailles M et P

### Requirement: Dons du SRD
Le pack SRD SHALL contenir les 17 dons du SRD 5.2.1, chacun avec sa catégorie, ses prérequis, la mention « Répétable » et son texte copié du PDF.

#### Scenario: Faveurs épiques (SRD p. 93-94)
- **WHEN** on lit les dons de catégorie `epic_boon`
- **THEN** il y en a 7, chacun exige le niveau 19, et la Faveur de mémoire magique exige en plus l'aptitude Sorts

#### Scenario: Faveur de Vision lucide
- **WHEN** un personnage a la Faveur de Vision lucide
- **THEN** il reçoit la Vision lucide sur 60 pieds
