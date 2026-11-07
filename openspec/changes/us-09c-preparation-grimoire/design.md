# Design

## Contexte

Le SRD distingue trois façons de changer ses sorts préparés. Clerc, Druide et Magicien changent leur liste après un Repos long. Paladin et Rôdeur y remplacent un sort. Barde, Ensorceleur et Occultiste remplacent un sort à chaque niveau. Chaque classe à sorts mineurs en remplace un, à chaque niveau ou, pour le Magicien, après un Repos long.

## Décisions

1. **`ClassData.prepared_change`.** `long_rest_all`, `long_rest_one`, `level_up_one`. Le texte du SRD n'est pas interprétable par le moteur, la donnée de classe porte la règle.
2. **`changeLimit`.** Rien pour `long_rest_all`, sinon 1 remplacement. L'écran bloque au-delà.
3. **Moment.** Sans repos, rien ne le vérifie encore : l'écran rappelle la règle. US-10 pourra s'y brancher.
4. **Sorts proposés.** Grimoire pour le Magicien, sinon liste de classe jusqu'au plus haut niveau atteint dans cette classe. Un sort connu autrement reste bloqué : règle du porteur de projet sur les sorts pris deux fois.
5. **`withClassSpells`.** Remplace les sorts d'une classe, sans toucher à ceux d'une autre.
6. **Recopie.** `copySpell` ajoute au grimoire et retire l'or. Seuls les po sont comptés : pas de conversion de monnaie.
7. **`ComputedSheet.freeCasts`.** Lu dans les effets actifs : `when.level`, les choix et les valeurs `by_level` sont déjà résolus. Initié à la magie, sans effet dans le pack, compte 1 lancer.
8. **Savoir rituel.** Le SRD exige un sort préparé, sauf pour le Magicien et son grimoire. `inSpellbook` suffit : seul un Magicien a un grimoire.

## Risques

- **Colonne ajoutée au schéma v1 :** non publié, base locale de test à effacer.
