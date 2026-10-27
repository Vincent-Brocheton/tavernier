## ADDED Requirements

### Requirement: Outils du SRD
Le pack SRD SHALL contenir les 37 outils du SRD 5.2.1. Chacun SHALL avoir :
- sa catégorie (outil d'artisan, boîte de jeux, instrument de musique ou autre) ;
- sa caractéristique ;
- son prix, et son poids quand le SRD en donne un ;
- le texte de sa description copié du PDF.

#### Scenario: Outils de voleur (SRD p. 100)
- **WHEN** on lit `srd:tool:thieves-tools`
- **THEN** sa caractéristique est la Dextérité, son poids 0,5 kg et son prix 25 po

#### Scenario: Variante d'instrument (SRD p. 100)
- **WHEN** on lit le luth
- **THEN** c'est un instrument de musique, de Charisme, de 1 kg et 35 po

### Requirement: Matériel d'aventurier du SRD
Le pack SRD SHALL contenir chaque objet du tableau « Matériel d'aventurier » et chaque variante des tables de munitions, de focaliseurs et de symboles sacrés. Chacun SHALL avoir le poids et le prix du tableau et le texte de sa description copié du PDF.

#### Scenario: Acide (SRD p. 100)
- **WHEN** on lit `srd:item:acid`
- **THEN** il pèse 0,5 kg, coûte 25 po, et son texte décrit le jet de sauvegarde de Dextérité et les 2d6 dégâts d'acide

### Requirement: Équipement de départ des classes
Une classe SHALL pouvoir déclarer ses options d'équipement de départ. Chaque option donne ses objets et leurs quantités, les catégories d'outil à choisir et ses pièces d'or. Chaque objet cité SHALL être une arme, une armure, un outil ou un objet. Les 12 classes du SRD SHALL déclarer les options de leur table de traits de base.

#### Scenario: Guerrier (SRD p. 56)
- **WHEN** on lit les options du Guerrier
- **THEN** il y en a trois, avec 4 po, 11 po et 155 po, et l'option C ne contient que de l'or

#### Scenario: Barde (SRD p. 35)
- **WHEN** on lit l'option A du Barde
- **THEN** elle contient une armure de cuir, 2 dagues, un paquetage d'artiste et 19 po, et un instrument de musique à choisir

#### Scenario: Objet inconnu
- **WHEN** une option cite un identifiant qui n'est pas une arme, une armure, un outil ou un objet
- **THEN** la validation du pack signale une référence de type invalide
