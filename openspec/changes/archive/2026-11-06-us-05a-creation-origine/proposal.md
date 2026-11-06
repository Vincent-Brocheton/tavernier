# Proposal

## Why

Carte Trello [US-05 · Création de personnage guidée en 9 étapes](https://trello.com/c/NRrTNP2B), **lot 1/3**. Le pack SRD est complet (T-04). L'application n'a pas encore d'écran de jeu : ce lot pose le cadre de l'assistant et ses trois premières étapes (cahier §5.1, maquettes [P1], [P2], [P3]).

US-05 est livrée en trois lots, chacun avec son change et sa pull request ; la carte passe dans « Fait » avec le dernier :

1. **Cadre et origine** (ce change) : assistant, étapes Classe, Historique, Espèce.
2. **Caractéristiques et sous-choix** : Langues, Caractéristiques (avec US-06), Sous-choix.
3. **Fin de parcours** : Équipement, Détails, Récapitulatif, enregistrement.

## What Changes

- **Assistant de création :** accessible depuis Personnages, avec ses 9 étapes.
  - Sur desktop et tablette, la liste des étapes à gauche ; sur téléphone, « Étape n sur 9 » et une barre de progression.
  - « Suivant » est désactivé tant qu'un choix manque, avec sa raison au-dessus (critère « choix invalides bloqués et expliqués »).
  - Le joueur revient à toute étape déjà atteinte.
  - L'étape 4 affiche « Bientôt disponible » et « Suivant » s'y arrête jusqu'au lot suivant ; les étapes 5 à 9 sont listées, pas encore accessibles.
- **Étape 1, Classe [P1] :** recherche, filtres (Toutes, Martiales, Lanceurs de sorts, Homebrew), cartes et panneau de détail.
- **Étape 2, Historique [P2] :** cartes, détail (caractéristiques, don d'origines, compétences, outil), choix de l'outil quand l'Historique en propose un.
- **Étape 3, Espèce [P3] :** liste, traits, choix de la taille quand l'espèce en propose deux.
- **Contenu lu hors ligne :** l'assistant lit le pack SRD embarqué, sans réseau.
- **Stack :** `flutter_riverpod` et `go_router`, prévus par le cahier §10, entrent dans l'application.
- **Kit :** `WizardSteps`, `WizardFooter`, `SelectionCard`, `SourceBadge` et l'affichage des distances en mètres.
- **Correction de règle (EF-PJ-01) :** la caractéristique principale du Guerrier est « Force **ou** Dextérité », celles du Moine, du Paladin et du Rôdeur sont « A **et** B ».
  - Nouveau champ `primary_abilities_any` de `class` (ajout compatible au format v1).
  - Le moteur l'applique au prérequis de multiclassage : il acceptait à tort 13 dans une seule des deux caractéristiques.

## Capabilities

### New Capabilities

- `character-creation` : assistant de création d'un personnage.

### Modified Capabilities

- `content-pack` : `primary_abilities_any`.
- `character-sheet` : prérequis de multiclassage.
- `local-database` : colonne `primary_abilities_any`.
- `ui-kit` : composants de l'assistant.

## Impact

- `apps/game_table` : `lib/creation/`, routes, providers, ARB, dépendances.
- `packages/dnd_ui_kit` : composants et tests.
- `packages/dnd_content`, `packages/dnd_data`, `packages/dnd_rules` : champ `primary_abilities_any`.
- `tools/srd_builder/sources/class/fighter.json`, pack régénéré.
- `docs/packs/FORMAT_DNDPACK.md`.

**Écarts relevés, le SRD gagne (CLAUDE.md) :** les maquettes [P1]–[P3] utilisent des libellés qui ne sont pas ceux du SRD (« Ascendance de géant », « Chanceux », « Endurance implacable »). L'application affiche les noms du pack (« Ascendance gigante », « Chance », « Acharnement »).

**Hors périmètre :**
- **Contraintes de table** (méthode, niveau de départ, packs actifs) : les tables arrivent en M2. Ce lot crée un personnage de niveau 1 avec le pack SRD. L'en-tête n'affiche donc pas de table.
- **Enregistrement :** le brouillon reste en mémoire jusqu'au lot 3, où `CharacterStore` passera derrière le dépôt prévu par CLAUDE.md. Ce lot n'écrit rien en base.
- **Suggestions** (US-32) et **texture de l'en-tête** : la texture attend `TexturedHeader`.
- **Description de classe :** le texte d'accroche de [P1] n'existe pas dans le pack, et « Voir la progression » arrive avec le compendium.
