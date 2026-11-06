# Design

## Contexte

`subchoiceSections` compose l'étape 6 et le brouillon garde les sélections des effets dans `choices`. Le moteur ne connaît pas encore les sorts (US-09). Les colonnes `cantrips` et `prepared_spells` de la table de classe portent les comptes, `spell_list` porte la liste.

## Décisions

1. **Stockage dans `choices`.** Les sorts passent par le même `togglePick` que les effets, sous des clés réservées : `spells-cantrips`, `spells-prepared`, `spells-book`, et `magic-initiate-<place>-<champ>`, où la place vaut `background` ou `species`. Aucun champ nouveau dans le brouillon.
2. **Effacement.** Une option absente de la section ne pourrait plus se retirer, donc une sélection ne doit jamais survivre à ses options :
   - changer de classe efface `spells-` ;
   - changer d'Historique efface la place `background` ;
   - changer d'espèce ou de don efface la place `species` ;
   - changer de liste efface les sorts de cette place ;
   - retirer un sort du grimoire le retire des sorts préparés.
3. **Sections en cascade.** Les sorts préparés du Magicien n'apparaissent qu'une fois le grimoire complet, et les sorts de l'Initié qu'une fois la liste connue. L'étape reste bloquée entre-temps, puisque la section amont est incomplète.
4. **Règles dans `dnd_rules`.** `cantripsAtFirstLevel`, `preparedAtFirstLevel`, `spellbookSize` et les constantes de l'Initié. `ChoiceOption.bonusCantrips` lit `grant_spell_list_access` limité aux sorts mineurs.
5. **L'Initié reste codé dans `dnd_rules`.** Ses choix dépendent les uns des autres : le DSL ne sait pas les exprimer. Un don homebrew équivalent ne profitera pas de ces sections.
6. **`choice.title`.** Deux choix du même trait auraient le même titre. Le pack nomme le second : « Caractéristique d'incantation ».
7. **Sort déjà connu.** `knownElsewhere` réunit `grantedSpells` et les sélections des autres sections. Le grimoire et les sorts préparés du Magicien sont les mêmes sorts et ne se bloquent pas entre eux. Un sort qui devient connu après coup, par un lignage par exemple, reste sélectionné et passe « À refaire ».

## Risques

- **Longueur de l'étape :** un Magicien voit une cinquantaine de puces. Acceptable au niveau 1, sans filtre pour l'instant.
- **Fiches sans le choix de caractéristique :** les fixtures [D1] gardent `lineage_ability` dans `species_choices` ; le moteur ignore un `choice` absent de `choices`.
