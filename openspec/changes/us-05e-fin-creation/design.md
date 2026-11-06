# Design

## Contexte

`CreationDraft` porte les choix, `subchoiceSections` sait quelles sélections sont encore ouvertes et `CharacterStore` écrit un `CharacterInput`. `computeSheet` calcule la fiche et signale les erreurs d'intégrité. Le schéma Drift v1 n'est pas publié : il se régénère au lieu de migrer.

## Décisions

1. **Conversion à partir des sections.** `toCharacterInput` ne lit que les sections ouvertes : une sélection restée dans `choices` après un changement de classe n'est pas enregistrée (décision du change `us-05c-sous-choix`).
2. **Don et sélections.** Les choix d'un don vont dans `FeatInput.choices`, comme le lit `computeSheet`. L'Initié à la magie garde le format des fixtures [D1] : `spell_list`, `ability`, `cantrips`, `level_1_spell`.
3. **Outils de classe.** Le Barde a ses instruments dans `choices`, sous `class-tools` : `ClassLevelInput` n'a pas de champ pour eux et le moteur ignore une clé inconnue.
4. **Équipement.** Une armure et un bouclier sont portés d'office, comme sur [P8]. Les quantités d'un même objet s'additionnent. L'or va dans `coins`, indexé par pièce pour accueillir plus tard les cinq monnaies (EF-PJ-10).
5. **Sorts.** `SpellsInput` reprend le bloc `spells` des fixtures, avec `spellbook` en plus. La table `character_spell` existe déjà : les sorts mineurs y portent la source `cantrip`, les autres `class`.
6. **Blocage de l'étape 9.** `computeSheet` tourne au récapitulatif : une erreur d'intégrité bloque l'enregistrement et s'affiche. Une botte sur une arme absente de l'équipement est une alerte qui ne bloque pas [P8].
7. **UUID v7 maison.** Quinze lignes dans `dnd_data`, plutôt qu'un paquet de plus.
8. **Bouton « Enregistrer ».** [P8] dit « Envoyer au MJ », mais il n'y a ni table ni compte en M1 : le personnage reste libre, au statut `draft`.

## Risques

- **Base Web :** c'est la première écriture de l'app dans la base en vrai. La persistance après rechargement se vérifie dans le navigateur.
- **Erreur à l'écriture :** un échec est affiché et le brouillon reste ouvert, pour ne rien perdre.
