## Context

Le lot b a livré `SessionStore` : création, modification, liste numérotée et présences. La page d'une table a déjà ses onglets (« Vue d'ensemble », « Membres », « Configuration »). Les emplacements (`watchSlots`) donnent le statut de chaque fiche. Les résumés (`watchGroup`) donnent le nom, l'espèce, les classes et le propriétaire de chaque personnage de la table.

## Decisions

- **Onglet** : `SessionsTab(table)`, inséré en deuxième position, ce qui donne quatre onglets au MJ et trois au joueur.
- **Personnages prévus par défaut** : les résumés de la table (`tableGroupProvider`). Ce sont tous les personnages rattachés, comme dans [S2], où tout le monde est coché sauf le cas noté.
- **Part des fiches validées** : sur les emplacements, ceux dont la fiche est `validated`, parmi tous. Sans emplacement, la ligne n'est pas affichée.
- **Titre par défaut** : « Séance n », car le serveur exige un titre non vide. n vaut le nombre de séances plus un.
- **Enregistrement au fil de la saisie** : un `onChanged` sur le titre, qui n'enregistre pas un titre vide, et le sélecteur de date. La planche montre « Enregistrée », sans bouton Enregistrer.
- **Dates** : placeholders `DateTime` des ARB (`MMM` pour le pavé, `MMMMEEEEd` pour « vendredi 30 octobre »).
- **Badge d'état** : un libellé dans un conteneur coloré (`healContainer` pour « Préparée », `surfaceContainerHighest` pour « Close »). Le texte porte l'information, pas la couleur seule.
- **Préparation** : `SessionPage`, sur la route `/tables/:id/seances/:session`, ouverte par le toucher d'une séance. Le joueur ne l'ouvre pas.

## Risks / Trade-offs

- **Séance close** : son toucher ouvre aussi la préparation, faute de panneau de clôture (lot d). Le MJ peut y corriger le titre et la date.
- **Nouveau personnage** : un personnage rattaché après la création de la séance n'est pas prévu. Le MJ le coche à la préparation.
