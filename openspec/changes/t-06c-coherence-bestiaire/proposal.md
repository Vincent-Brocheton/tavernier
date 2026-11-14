# Proposal

## Why

Carte Trello [T-06](https://trello.com/c/SB1Cryrw), lot c sur trois, le dernier. Le critère d'acceptation restant est : « Profils de jeu relus contre le PDF (FP et PX cohérents) ». La carte exige une relecture humaine, car le PDF est en deux colonnes. Les lots a et b vérifient déjà FP, PX et bonus de maîtrise, ainsi que chaque modificateur lu. Ce lot ajoute :
- des contrôles qui ne laissent passer aucun profil faux ;
- une seconde lecture automatique, indépendante de la première ;
- une fiche qui dit au relecteur où regarder en priorité.

## What Changes

- **Contrôles à la construction**, pour tout pack, car ce sont des égalités du profil imprimé :
  - un JS vaut le modificateur, ou le modificateur plus le bonus de maîtrise ;
  - la Perception passive vaut 10 plus le bonus de Perception (compétence, ou à défaut modificateur de Sagesse) ;
  - les PV valent la moyenne des dés de vie ;
  - les dégâts moyens d'une attaque valent la moyenne de leurs dés.

  Aucun des 330 profils du SRD n'y déroge.
- **Seconde lecture** : un test relit le texte en mise en page (`docs/srd/FR_SRD_CC_v5.2.1.txt`), une source distincte du texte en ordre de lecture utilisé par l'extracteur. Il compare toutes les valeurs du bestiaire à celles des sources : FP et PX, PV et dés de vie, chaque ligne de caractéristique et JS, CA et Initiative. Les seuls écarts permis sont les coquilles corrigées et les lignes que la mise en page ne rend pas lisibles, listées une à une.
- **Écarts à relire** : trois règles, que le SRD lui-même ne suit pas toujours, ne bloquent pas la construction. Elles alimentent la fiche de relecture.
  - Initiative : modificateur de Dextérité, plus 0, 1 ou 2 fois le bonus de maîtrise ;
  - compétences : modificateur plus 1 ou 2 fois le bonus de maîtrise ;
  - bonus d'attaque : modificateur d'une caractéristique plus le bonus de maîtrise.
- **Fiche de relecture** `docs/srd/RELECTURE_BESTIAIRE.md`, écrite par `extract-monsters`. Elle contient :
  - les contrôles automatiques passés ;
  - les points à vérifier en priorité, avec leur page : coquilles corrigées, écarts à relire, lectures incertaines de l'extracteur ;
  - la liste des 330 profils par page, pour la relecture humaine.

  Le suivi de la relecture reste sur la carte Trello. La fiche est réécrite à chaque extraction.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `content-pack` : cohérence d'un monstre (nouveaux contrôles), bestiaire relu contre le texte en mise en page.

## Impact

- `packages/dnd_content/lib/src/pack/content_pack.dart` et ses tests.
- `tools/srd_builder/` : écarts à relire, pages et fiche dans `monster_extractor.dart` ; test de seconde lecture.
- `docs/srd/RELECTURE_BESTIAIRE.md` (nouveau, généré), `CLAUDE.md`.

**Hors périmètre :**
- **La relecture humaine elle-même** : c'est au porteur de projet de la faire, à l'aide de la fiche. Les corrections qu'elle demandera passeront par l'extracteur, avec `monsterTypos` pour les coquilles.
- **Bonus d'attaque d'un sort relié à la caractéristique d'incantation** : le texte d'« Incantation » n'est pas lu.
