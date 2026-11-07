# Design

## Contexte

`CharacterInput.spells` ne dit pas à quelle classe appartient un sort. Les colonnes `slot_n`, `pact_slots` et `pact_slot_level` de la table de classe portent les emplacements d'une classe seule.

## Décisions

1. **`SpellsInput.classes`.** Association sort → classe, remplie à la montée de niveau. Sans entrée, le sort appartient à la première classe de lanceur : la création n'a qu'une classe.
2. **`MulticlassTraits.caster_divisor`.** 1 pour Barde, Clerc, Druide, Ensorceleur et Magicien, 2 pour Paladin et Rôdeur, 0 pour les autres. C'est une donnée de classe : un homebrew peut la porter.
3. **Niveau de lanceur.** La moitié des niveaux de Paladin et de Rôdeur se calcule sur leur somme, arrondie au supérieur, comme l'écrit le SRD (« La moitié de vos niveaux (arrondir au supérieur) de Paladin et de Rôdeur »).
4. **Table du multiclassage.** Elle ne sert qu'à partir de deux classes à emplacements. L'Occultiste n'y compte pas : ses emplacements restent à part.
5. **`sheetSpells`.** Une fonction unique sert l'onglet et `knownSpells`. Un sort accordé est lu au niveau de sa classe, et non au niveau total.
6. **Libellé « Toujours préparé ».** [P14] écrit « Domaine » pour un Clerc : un libellé commun couvre aussi les serments, les patrons, les lignages et les dons.

## Risques

- **Colonne ajoutée au schéma v1 :** non publié, régénéré.
- **Bonus de sorts mineurs :** `cantrips_known` lit la table de classe, sans Thaumaturge.
