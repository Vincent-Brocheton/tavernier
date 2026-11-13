## Context

Le lot b stocke une proposition comme des champs de premier niveau de `CharacterInput` (`{"feats": [...]}`), et le joueur l'applique. Le MJ écrit déjà les propositions (`CharacterStore.propose`, droit `is_table_gm` au serveur). Le moteur ouvre les choix d'un don avec `openChoices`.

## Decisions

- **Qui voit le bouton** : `gmProposalViewProvider`. La fiche doit appartenir à un joueur, dans une table dont l'utilisateur est MJ, et ne pas être archivée. Mêmes conditions que la règle d'insertion du serveur.
- **Modification construite** : la liste des dons de la fiche, avec le don remplacé changé en place. Il garde sa source (`species`, `background`, `class`), ce qui garde les sources des bonus et des choix.
- **Dons remplaçables** : catégories `origin` et `fightingStyle`, qui n'ont pas de prérequis.
- **Dons proposés** : même catégorie, sans le don remplacé, sans un don non répétable déjà pris, sans l'Initié à la magie. Ses choix d'Initié (liste, caractéristique, sorts) passent par d'autres sections de l'assistant de création.
- **Choix du don** : `openChoices(content, [don])`, une rangée de puces par choix. Le compte doit être atteint pour envoyer.
- **Aperçu** : `ProposalPreview`, sorti de l'encadré du joueur, pour que le MJ voie le même tableau.
- **Suivi** : `watchProposals` (toutes les propositions, la plus récente d'abord). La fiche montre au MJ l'attente ou le refus. Une proposition acceptée est dans l'historique.
- **Après l'envoi** : retour à la fiche et message « Proposition envoyée à Hugo. ».

## Risks / Trade-offs

- La modification est figée à l'envoi. Si le joueur change ses dons avant de répondre, l'acceptation remplace sa liste. Le cas est rare : seul le MJ ou une montée de niveau changent les dons.
