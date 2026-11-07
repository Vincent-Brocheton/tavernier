# Design

## Contexte

`CharacterInput.spells` porte `cantrips`, `prepared` et `spellbook`. Les colonnes `cantrips`, `prepared_spells`, `slot_n` et `pact_slot_level` de la table de classe disent les comptes et le niveau de sort atteint.

## Décisions

1. **Différence de deux lignes de table.** `spellGain` compare le niveau courant et le suivant : c'est ce que la table de classe dit, sans règle à coder par classe.
2. **Grimoire.** 2 sorts par niveau de Magicien après le premier (SRD, Grimoire), de niveau atteint. Les sorts préparés du Magicien se prennent dans le grimoire, nouveaux sorts compris.
3. **Sort déjà connu.** Les sorts de `CharacterInput`, ceux des Initiés et ceux accordés au niveau atteint. La règle du porteur de projet s'applique : un sort ne se prend pas deux fois. L'exception, un sort déjà pris puis acquis par une capacité de sous-classe, n'exige aucun blocage : le sort reste simplement connu.
4. **Initié à la magie dans le brouillon.** Liste, caractéristique, 2 sorts mineurs et 1 sort, au format des fixtures [D1].
5. **Étape Sorts conditionnelle.** Elle n'apparaît que si le niveau apporte des sorts.

## Risques

- **Sélections en une seule liste :** `SpellsInput` ne sépare pas les classes. Le multiclassage devra le dire à l'écran, sans changer le stockage dans un premier temps.
