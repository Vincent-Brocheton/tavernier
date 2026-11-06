# Design

## Context

- `CreationDraft` porte la position et les choix des étapes 1 à 3 ; `missingChoice` ne contrôle que l'étape affichée.
- `compute_sheet.dart` connaît le coût des valeurs (privé) et valide 27 points, la répartition et l'éligibilité.
- Le cahier interdit toute valeur de règle en dur dans l'interface.

Motivation : proposal.md.

## Goals / Non-Goals

**Goals:**
- Les règles vivent dans `dnd_rules`, et le moteur et l'interface partagent les mêmes.
- Un choix devenu invalide reste visible et bloque.

**Non-Goals:**
- Pas d'aperçu calculé par `computeSheet` : le brouillon n'est pas encore un `CharacterInput`.

## Decisions

1. **`creation_rules.dart`** : `pointBuyBudget`, `pointBuyCosts`, `pointBuySpent`, `abilityModifier`, `startingLanguageId`, `startingLanguageChoices`. `compute_sheet.dart` les réutilise.
2. **Brouillon :** `languages`, `scores` (8 partout au départ), `distribution` (`2-1` par défaut), `bonuses`.
   - `raiseScore` et `lowerScore` respectent le budget et les bornes.
   - `setBonus` : en `2-1`, poser un +2 retire l'ancien +2, et toucher le bonus déjà posé le retire ; une caractéristique ne porte qu'un bonus. En `1-1-1`, chaque +1 se bascule.
   - Changer de répartition vide les bonus.
   - Changer d'Historique garde les bonus : le joueur voit ce qui est devenu invalide.
3. **Blocage :** `missingAt(draft, step, content)` contrôle n'importe quelle étape. `next` regarde l'étape affichée, `goTo` toutes celles qu'il franchit vers l'avant.
4. **Langues :** `category: standard` sauf le Commun, triées. « Tirer au sort » complète les places libres, sans toucher aux langues déjà choisies.
5. **Bonus, ligne par ligne :** l'étape dérive pour chaque caractéristique ses bascules (`BonusToggleState`) et sa règle, depuis le brouillon.
6. **Étapes :** « Suivant » s'arrête à l'étape Sous-choix, jusqu'au change suivant.

## Risks / Trade-offs

- **Tableau étroit sur téléphone** → cibles de 48 dp, nom de caractéristique sur toute la largeur restante, testé à 375 dp.
