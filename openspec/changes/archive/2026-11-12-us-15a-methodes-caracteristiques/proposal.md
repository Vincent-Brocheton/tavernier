# Proposal

## Why

Carte Trello [US-15](https://trello.com/c/UMRG1bPS), premier lot. La création d'un personnage dans une table doit suivre la méthode de caractéristiques de la table (§4.3, EF-TAB-01). Un personnage libre, lui, choisit sa méthode. Le SRD (p. 21-22) en décrit trois : valeurs standard, génération aléatoire, acquisition par points. Le moteur les valide déjà, mais l'assistant ne propose aujourd'hui que l'acquisition par points.

US-15 est découpée en cinq lots :
- a : les trois méthodes ;
- b : emplacements, création contrainte, envoi au MJ ;
- c : validation ou corrections ;
- d : rattachement d'un personnage libre [T14] ;
- e : résumé du groupe [T13].

## What Changes

- **Choix de la méthode** en tête de l'étape Caractéristiques : « Acquisition par points », « Valeurs standard », « Génération aléatoire », avec leur rappel (« 15, 14, 13, 12, 10, 8 à répartir », « 4d6, on retire le plus faible, six fois »). Le lot b l'imposera dans une table.
- **Valeurs standard** : les six valeurs sont réparties d'emblée. Pour chaque caractéristique, une liste en propose une ; choisir une valeur déjà prise échange les deux.
- **Génération aléatoire** :
  - « Lancer » tire six fois 4d6 sans le plus faible ;
  - « Saisir mes jets » accepte six valeurs de 3 à 18, tirées avec de vrais dés (décision « Saisir mon jet » et « Lancer », cahier §14.2) ;
  - les jets se répartissent ensuite comme les valeurs standard ;
  - l'étape reste bloquée tant qu'aucun jet n'est fait.
- **Suggestion** (bouton existant) : la table « Valeurs standard par classe » du SRD pour les points et les valeurs standard ; pour les jets, le même ordre de priorité.
- **Enregistrement** : la méthode et les jets sont gardés sur la fiche (`base_scores.method`, `score_rolls`), que le moteur vérifie déjà.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-creation` : méthodes de caractéristiques.

## Impact

- `apps/game_table/lib/creation/` : brouillon (méthode, jets), étape Caractéristiques, conversion vers `CharacterInput` ; ARB ; tests.

**Hors périmètre :**
- **Méthode imposée par la table** : lot b.
- **Planche** : aucune planche ne montre les valeurs standard ni les jets. La mise en page suit celle de l'acquisition par points [3a, 3b].
