// Règles de création partagées par le moteur et l'interface : l'interface
// n'en porte aucune (CLAUDE.md, « Aucune valeur de règle en dur dans l'UI »).

/// Budget de l'acquisition par points (SRD p. 22).
const pointBuyBudget = 27;

/// Coût de chaque valeur (SRD p. 22, « Coût des valeurs de caractéristique ») ;
/// ses clés sont les valeurs possibles avant bonus.
const pointBuyCosts = {8: 0, 9: 1, 10: 2, 11: 3, 12: 4, 13: 5, 14: 7, 15: 9};

/// Points dépensés pour [scores] ; une valeur hors table compte pour un
/// dépassement du budget.
int pointBuySpent(Map<String, int> scores) => scores.values.fold(
  0,
  (sum, value) => sum + (pointBuyCosts[value] ?? pointBuyBudget + 1),
);

/// Modificateur d'une valeur de caractéristique, arrondi à l'inférieur.
int abilityModifier(int score) => ((score - 10) / 2).floor();

/// Plafond d'une valeur de caractéristique à la création (SRD p. 87).
const abilityScoreCap = 20;

/// Langue connue de tout personnage (SRD p. 20).
const startingLanguageId = 'srd:language:common';

/// Langues courantes à choisir en plus du Commun (SRD p. 20).
const startingLanguageChoices = 2;
