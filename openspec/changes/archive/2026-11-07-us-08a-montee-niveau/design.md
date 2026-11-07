# Design

## Contexte

`computeSheet` applique les effets actifs, mais ni `ability_bonus` ni le format d'une Amélioration de caractéristique. Les fixtures [D1] stockent celle-ci dans `FeatInput.choices` sous la forme `{"str": 1, "con": 1}`.

## Décisions

1. **Format [D1] conservé.** Si `choices` porte des codes de caractéristique, le moteur retient l'option du `choice` dont les `ability_bonus` correspondent. Cela sert aussi à Empoigneur, sans ajouter de `labels`.
2. **Caractéristiques après les effets.** `_activeEffects` ne dépend pas des valeurs : il passe avant le calcul des caractéristiques, qui reçoivent les `ability_bonus`, plafonnés par `max`.
3. **Ce qui change = deux fiches.** L'assistant calcule la fiche avant et après `applyLevelUp`. PV, bottes gagnées et panneau en découlent, sans règle dupliquée.
4. **Gains dans `dnd_rules`.** `levelGain` rend les aptitudes du nouveau niveau, la sous-classe due, les catégories de don et les choix qui s'ouvrent à ce niveau.
5. **Éligibilité d'un don.** `featBlock` rend une raison : niveau, caractéristique, aptitude requise, déjà obtenu. L'écran l'affiche, selon le motif des options bloquées.
6. **Brouillon en mémoire.** `LevelUpDraft` ne vit que le temps de l'assistant. Rien n'est écrit avant « Enregistrer ».

## Risques

- **Sorts :** un lanceur peut monter sans mettre à jour ses sorts jusqu'au change suivant. L'écran le dit.
