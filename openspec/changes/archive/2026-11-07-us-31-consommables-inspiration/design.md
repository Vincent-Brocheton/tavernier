# Design

## Contexte

`character_state` a déjà `heroic_inspiration`. Le pack n'a aucune donnée d'usage d'un objet. La ressource `heroic-inspiration` de l'Humain sert de déclaration, sans suivi.

## Décisions

1. **`consumable_heal`.** `dice`, `bonus`, `action`. Un effet garde les données de jeu hors du schéma, et une opération inconnue rend l'entité invalide. Il n'agit qu'à l'usage, jamais sur la fiche.
2. **`consumableOf`.** Lit l'effet pour l'écran, qui n'a aucune valeur de règle.
3. **Soin saisi ou lancé.** Le jet vient de l'écran ; la somme, plafonnée aux dés, reste validée par `consumableRange`.
4. **Inspiration, un booléen de `PlayState`.** Le SRD en interdit plus d'une. N'importe quel personnage peut en recevoir : ce n'est pas une ressource de classe, et elle quitte le suivi des ressources.
5. **Ingénieux.** La ressource déclarée donne l'Inspiration à la fin d'un Repos long.
6. **PV à la montée de niveau.** Le SRD ne parle que du maximum : rien ne change.

## Risques

- **Carte partiellement livrée :** EF-PJ-17 reste à faire une fois les tables disponibles.
