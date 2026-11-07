# Design

## Contexte

`docs/dsl/DSL_V1.md` décrit `modify_hp_max`, `grant_sense` et `grant_expertise`, mais `computeSheet` ignorait les deux premiers.

## Décisions

1. **Niveau du bonus.** `per_level` se multiplie par le niveau de l'effet actif : le niveau total pour une espèce ou un don, le niveau de classe pour une aptitude.
2. **Résistance draconique.** Le SRD donne +3 à l'obtention, puis +1 par niveau d'Ensorceleur suivant : c'est le niveau de classe. `per_level: 1` suffit, `flat` doublerait les 3 premiers.
3. **`saving_throws` des fixtures.** La fiche rend les six jets. Les valeurs de Mira et Brannoc sont complétées à la main.
4. **Libellés de `sources`.** Les fixtures de Brannoc suivent le format du moteur (une contribution par classe, puis la source). Les valeurs ne changent pas.
5. **`pending_keys`.** Le test saute ces clés une par une, le reste de la fixture devient actif. `domain_spells` et `spellbook_count` y figurent car `spellcasting_test.dart` les couvre via `sheetSpells`.

## Risques

- **Valeurs attendues :** seuls leur format et les jets non maîtrisés changent, recalculés à la main.
