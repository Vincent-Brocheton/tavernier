# Design

## Contexte

Le SRD donne une table « Valeurs standard par classe ». Ces valeurs coûtent toujours 27 points, donc elles sont valides en acquisition par points.

## Décisions

1. **Table du SRD dans `dnd_rules`.** Par identifiant de classe. Une classe de pack hors table reçoit le tableau standard, caractéristiques principales d'abord, puis Constitution.
2. **Écart avec [J11].** La planche donne au Guerrier Constitution 14 et Dextérité 13, comme Aldric. Le SRD donne Dextérité 14 et Constitution 13 : le SRD gagne. La fiche d'Aldric ne change pas, seule la suggestion suit le SRD.
3. **Bonus d'Historique.** +2 puis +1 sur les plus hautes valeurs éligibles, en répartition 2-1.
4. **`SuggestButton`.** Applique au toucher puis affiche la raison. L'état reste dans le brouillon, modifiable comme un choix manuel.
5. **Amélioration.** +2 sur la première caractéristique principale qui le permet, sinon +1 sur les deux meilleures qui le permettent.

## Risques

- **Compétences déjà maîtrisées :** les options bloquées sont exclues par l'écran.
