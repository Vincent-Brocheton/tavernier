# Proposal

## Why

Carte Trello [US-05](https://trello.com/c/NRrTNP2B), fin du lot 2. L'étape 6 livrée par `us-05c-sous-choix` laisse un lanceur de sorts passer sans choisir ses sorts. Le cahier (§5.1, étape 6) demande les sorts de départ et les sous-choix du don d'origines, dont la liste de sorts de l'Initié à la magie.

La maquette [P5] ne montre pas de sorts : les sections reprennent ses puces et son panneau « À compléter ».

## What Changes

- **Sorts de classe à l'étape 6 :** sorts mineurs et sorts préparés, comptés par les colonnes de la table de classe.
- **Sort mineur supplémentaire :** l'option Thaumaturge de l'Ordre divin et l'option Magicien de l'Ordre primitif augmentent le nombre de sorts mineurs (`grant_spell_list_access`).
- **Grimoire du Magicien :** 6 sorts du 1er niveau, puis 4 sorts préparés choisis dans le grimoire (SRD, « Grimoire »).
- **Initié à la magie :** caractéristique d'incantation, 2 sorts mineurs et 1 sort du 1er niveau.
  - Un Historique impose sa liste (Acolyte : Clerc, Sage : Magicien).
  - Pris par Polyvalent, le joueur choisit entre Clerc, Druide et Magicien. La liste déjà prise par l'Historique est grisée : le don se reprend avec une autre liste.
- **Caractéristique d'incantation des lignages :** Lignage elfique, Lignage gnome et Héritage fiélon demandent de choisir Intelligence, Sagesse ou Charisme. `choice` reçoit `title`, qui distingue ce choix de celui du lignage.
- **`dnd_rules` :** règles de ces comptes et listes, pour qu'aucune valeur de règle ne soit en dur dans l'app.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-creation` : sorts de départ et Initié à la magie à l'étape Sous-choix.
- `content-pack` : caractéristique d'incantation des lignages, titre d'un choix.

## Impact

- `packages/dnd_content` : schéma de `choice`.
- `packages/dnd_rules` : `creation_choices.dart`.
- `tools/srd_builder/sources/feature/` : 3 traits, pack régénéré.
- `apps/game_table/lib/creation/` : brouillon, sections, écran, ARB.
- `docs/dsl/DSL_V1.md`.

**Hors périmètre :**
- **`CharacterInput` et base :** le champ `spells` et son enregistrement arrivent avec la conversion du brouillon, au lot 3. Les sélections vivent dans le brouillon, sous `choices`.
- **Validation et calcul des sorts par `computeSheet` :** US-09.
- **Sort connu deux fois :** le SRD ne l'interdit pas, l'écran ne le bloque donc pas.
