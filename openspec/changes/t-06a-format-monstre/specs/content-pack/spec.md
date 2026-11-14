## ADDED Requirements

### Requirement: Type monstre
Un pack SHALL pouvoir contenir des entités `monster` : un profil de jeu complet, avec taille, type de créature, alignement, CA, Initiative, PV et dés de vie, Vitesses, caractéristiques et JS, compétences, vulnérabilités, résistances et immunités, sens, langues, FP, PX et bonus de maîtrise. Il porte aussi ses traits, actions, actions Bonus, Réactions et actions Légendaires, avec leurs usages, et le détail d'une attaque ou d'un jet de sauvegarde. Un champ inconnu SHALL rendre l'entité invalide.

#### Scenario: Profil lu
- **WHEN** le pack SRD contient le Loup
- **THEN** il se lit avec FP 1/4, 50 PX, Intelligence 3 et son action Morsure

#### Scenario: Champ inconnu
- **WHEN** un monstre porte un champ que le format ne connaît pas
- **THEN** il est refusé

### Requirement: Cohérence d'un monstre
La construction d'un pack SHALL refuser un monstre dont le FP, les PX ou le bonus de maîtrise ne concordent pas avec la table du SRD, dont une référence (type de dégâts, état, compétence) ne se résout pas, ou qui a une action Légendaire sans nombre d'utilisations.

#### Scenario: PX incohérents
- **WHEN** un monstre de FP 1/4 annonce 100 PX
- **THEN** la construction échoue en nommant le monstre

### Requirement: Monstres de [D1]
Le pack SRD SHALL contenir le Bandit, le Loup, le Loup sanguinaire, le Chef de bande, l'Ogre et le Vétéran, avec les PX de [D1] : 25, 50, 200, 450, 450 et 700.

#### Scenario: PX de [D1]
- **WHEN** on lit le Vétéran du pack SRD
- **THEN** il vaut 700 PX
