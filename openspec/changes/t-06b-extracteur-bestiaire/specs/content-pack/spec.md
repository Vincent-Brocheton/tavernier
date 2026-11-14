## ADDED Requirements

### Requirement: Nuées et précisions d'un monstre
Un monstre SHALL pouvoir porter `swarm_size`, la taille des créatures d'une nuée. Il SHALL aussi pouvoir porter `speed_note` et `senses_note` : la partie imprimée des lignes Vitesse et Sens que les nombres ne portent pas. Ces trois champs sont optionnels.

#### Scenario: Nuée de chauves-souris
- **WHEN** on lit `srd:monster:swarm-of-bats`
- **THEN** sa taille est G, `swarm_size` vaut `tiny` et son type est Bête

#### Scenario: Vitesse de forme
- **WHEN** on lit le Loup-garou du pack SRD
- **THEN** sa Vitesse au sol vaut 30 pieds et `speed_note` vaut « 12 m (forme de loup uniquement) »

### Requirement: Bestiaire du SRD
Le pack SRD SHALL contenir chaque profil de jeu des sections « Monstres de A à Z » et « Animaux » du SRD 5.2.1. Ces profils sont extraits du texte du PDF par `extract-monsters`, avec des slugs anglais tirés de `extract/monster_slugs.tsv`. L'extraction SHALL échouer sans rien écrire s'il manque un slug ou si une source n'a plus de monstre. Les monstres de [D1] SHALL rester identiques à leur saisie du lot a.

#### Scenario: Dragon rouge adulte
- **WHEN** on lit `srd:monster:adult-red-dragon`
- **THEN** il est de FP 17, vaut 18 000 PX (20 000 dans son antre) et a 3 utilisations d'action Légendaire (4 dans son antre)
- **AND** son Souffle de feu a la recharge « 5-6 » et un JS de Dextérité DD 21

#### Scenario: Monstres de [D1]
- **WHEN** on relance l'extraction
- **THEN** le Bandit, le Loup, le Loup sanguinaire, le Chef de bande, l'Ogre et le Vétéran sont identiques à leur saisie du lot a

#### Scenario: Slug manquant
- **WHEN** un profil du texte n'a pas de slug
- **THEN** la commande échoue en le nommant et n'écrit aucun fichier
