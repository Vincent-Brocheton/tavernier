# Design

## Context

- `apps/game_table` n'a qu'une coquille à cinq destinations, sans état partagé ni routes.
- `CharacterInput` exige une espèce, un Historique, des scores : il ne peut pas représenter un brouillon incomplet.
- `ActiveContent` donne accès aux entités, et la validation complète reste `computeSheet`.
- Le pack embarqué se lit sans réseau (`loadSrdPack`).

Motivation : proposal.md.

## Goals / Non-Goals

**Goals:**
- Un brouillon immuable, testable sans widget, dont dépendent toutes les étapes.
- Aucune valeur de règle en dur dans l'interface : noms, dés et listes viennent du pack.

**Non-Goals:**
- Pas d'écriture en base, pas de reprise d'un brouillon après fermeture.

## Decisions

1. **`CreationDraft`** (`lib/creation/creation_draft.dart`) : `classId`, `backgroundId`, `toolChoice`, `speciesId`, `size`, tous facultatifs, et `reached`, l'étape la plus loin atteinte. Le lot 3 le convertira en `CharacterInput`.
2. **Blocage :** `missingChoice(draft, content)` renvoie le choix manquant de l'étape affichée (`MissingChoice`), ou `null`. L'interface le traduit par l'ARB. Dans ce lot, « Suivant » reste bloqué à partir de l'étape 4, avec « Bientôt disponible » pour raison.
3. **Cohérence du brouillon :**
   - choisir un autre Historique efface l'outil choisi ;
   - choisir une espèce à une seule taille fixe cette taille ; à deux tailles, la taille reste à choisir.
   Retoucher le choix déjà fait ne change rien : la carte reste touchable quand elle est ouverte, et le joueur ne doit pas perdre la taille ou l'outil déjà choisis.
4. **État :** `creationProvider` (`Notifier<CreationDraft>`), `contentProvider` (`FutureProvider<ActiveContent>`, le pack embarqué). `go_router` porte `/` et `/characters/new`. L'étape courante est dans l'état, pas dans l'URL : la barre d'adresse ne doit pas permettre de sauter une étape bloquée.
5. **Disposition :**
   - téléphone (< 600) : une colonne, le détail s'ouvre dans la carte sélectionnée, qui vient à l'écran ;
   - à partir de la tablette : étapes (232 dp), grille, détail à droite (300 dp).
6. **Filtres de classe :** Martiales si `weapon_proficiencies` contient une valeur `martial*` ; Lanceurs de sorts si `spellcasting_ability` existe ; Homebrew si l'espace de noms n'est pas `srd`, et le filtre n'apparaît que s'il existe de tels contenus.
7. **`primary_abilities_any`** (faux par défaut) : vrai pour le Guerrier. Le moteur prend `any` s'il est vrai, `every` sinon. L'interface joint les noms par « ou » ou « et ».
8. **Tri :** les listes suivent l'ordre alphabétique français, sans tenir compte des accents (Rôdeur avant Roublard).
9. **Distances :** `formatFeet` (kit) convertit à 0,3 m le pied et écrit « 9 m » ou « 10,50 m », comme les maquettes.

## Risks / Trade-offs

- **Dépendances de `go_router` et Riverpod avec le découpage de Material** → vérifié à l'ajout. En cas d'incompatibilité, repli sur le `Navigator`.
- **Lecture du pack au démarrage de l'assistant** → le `FutureProvider` garde le résultat, avec un indicateur pendant le chargement.
