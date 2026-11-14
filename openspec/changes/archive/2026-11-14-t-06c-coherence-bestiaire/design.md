# Design

## Contrôles bloquants (`dnd_content`, `_monsterIssues`)

Ces égalités sont vérifiées sur le profil imprimé, sans rien recalculer :
- **modificateur** : `(valeur − 10) ~/ 2`, arrondi vers le bas ;
- **JS** : la valeur imprimée vaut le modificateur, ou le modificateur plus le BM ;
- **Perception passive** : 10 plus `skills['…:perception']`, ou à défaut le modificateur de Sagesse ;
- **moyenne d'un dé** : `NdF ± k` donne `N × (F + 1) / 2 ± k`, arrondi à l'inférieur. Une expression illisible est refusée. Le contrôle s'applique aux `hit_dice` (contre `hp`) et à chaque `dice` d'un dégât (contre `average`).

Les compétences vérifiées ici sont celles du pack et de ses dépendances (`known`). Le pack SRD s'y conforme déjà : la mesure sur les 330 profils ne donne aucun écart.

## Écarts à relire (`srd_builder`)

`reviewNotes(MonsterData)` renvoie des phrases, sans rien bloquer :
- **Initiative** : hors de mod Dex + {0, 1, 2} × BM ;
- **compétence** : hors de mod + {1, 2} × BM, avec la caractéristique de la compétence (table de l'extracteur) ;
- **attaque** : bonus hors de { mod de chacune des six caractéristiques + BM }.

Mesure sur le SRD :
- Initiative : une, l'Archimage ;
- compétences : deux, la Grenouille géante et le Tertre errant ;
- attaques : environ vingt, surtout des attaques de sort et quelques cas particuliers comme la Thallophyte violette.

## Pages

Dans le texte en ordre de lecture, chaque page se termine par « N Document de Référence du Système 5.2.1 » ou « Document de Référence du Système 5.2.1 N ». La page d'un profil est celle du premier pied de page qui suit sa ligne de type, cherchée dans le texte brut, avant `cleanText`. Le profil s'ouvre sur cette page.

## Fiche de relecture

Elle est écrite par `extract-monsters` (`--review`, par défaut `docs/srd/RELECTURE_BESTIAIRE.md`), en Markdown, dans cet ordre :
1. les contrôles automatiques et leur résultat (nombre de profils) ;
2. **à vérifier en priorité**, un point par ligne `p. N — Nom : motif`. On y trouve les coquilles corrigées (avec la page du profil qui les contient), les écarts à relire et les lectures incertaines du rapport ;
3. **profils par page** : un tableau page / profils.

`build/extract-monsters.txt` disparaît : la fiche le remplace.

## Seconde lecture (test `srd_monsters_test.dart`)

Le test lit le texte en mise en page à partir du second « Monstres de A à Z », le premier étant le sommaire. Il en tire des multiensembles et les compare aux sources :
- `FP x (y PX` → (FP, PX) ;
- `Pv n (dés)` → (PV, dés) ;
- `For 19 +4 +4` → (caractéristique, valeur, JS) ;
- `CA n   Initiative ±i` → (CA, Initiative).

Le test vérifie ensuite :
- `mise en page − sources` vaut exactement l'ensemble des valeurs fautives corrigées ;
- `sources − mise en page` vaut exactement les valeurs corrigées, plus les lignes illisibles de la mise en page, listées dans le test.
