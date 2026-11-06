# Design

## Contexte

`computeSheet` donne des `Computed` pour les caractéristiques, la CA, l'Initiative et les PV, mais de simples entiers pour les compétences et les sauvegardes. Le kit n'a aucune tuile de valeur.

## Décisions

1. **Contributions à côté des entiers.** `skills` et `savingThrows` restent des `Map<String, int>` : la sortie JSON et les fixtures [D1] ne bougent pas. `skillBreakdown` et `saveBreakdown` portent le détail, et les entiers en sont déduits.
2. **Libellés de contribution.** En plus de `base` et des codes de caractéristique, `proficiency` et `expertise`. L'app les traduit.
3. **Une décomposition, deux présentations.** `showAdaptiveSheet` ouvre une feuille modale au téléphone et une boîte de dialogue ailleurs. Le contenu est le même widget.
4. **« Utilisée par » limité aux caractéristiques.** Les autres valeurs n'alimentent rien de visible.
5. **Valeurs dérivées dans l'app.** Perception passive et Maîtrise n'ont pas de `Computed` : l'écran compose leurs lignes depuis `skillBreakdown` et le niveau.

## Risques

- **Expertise :** les fiches déjà enregistrées changent de valeur, ce qui est le comportement attendu puisque rien n'est figé.
