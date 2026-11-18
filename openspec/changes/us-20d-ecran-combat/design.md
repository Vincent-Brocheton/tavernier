## Context

Plusieurs pièces existent déjà :
- **`CombatState`** (lot a) : l'ordre des unités, le round, l'unité active, et les combattants avec leurs compteurs (`max`, `remaining`).
- **`CombatStore`** (lot b) : il ajoute des événements et termine une rencontre.
- **Lot c** : il a posé `launchEvents` (combattants d'un profil, compteurs) et l'écran au round 0.
- **`FoePicker`** (US-19) : il ajoute un groupe à une rencontre préparée.

## Decisions

- **`lastUndoable(events)`** (moteur) : le même calcul d'annulations que la projection, puis le dernier événement non annulé qui n'est pas une annulation.
- **Écran** :
  - `CombatPage` choisit l'initiative (round 0) ou le combat (round ≥ 1) ;
  - le combat est une liste de `_CombatantCard`, groupée par unité (en-tête pour un groupe de plusieurs membres) ;
  - le pied « Tour suivant » est un `bottomNavigationBar` ;
  - « Annuler » est dans l'en-tête, désactivé sans événement annulable.
- **Sous-titre d'un combattant** :
  - un PJ (ou un PNJ en fiche complète) : « PJ · Guerrier 5 », d'après son résumé ;
  - un monstre ou un PNJ en bloc : « Humanoïde · FP 2 », d'après le profil de son monstre (`ref_id`, ou le monstre de départ du PNJ).
- **Compteurs** : un pion par unité de maximum. Toucher un pion plein écrit `counter_used`, toucher un pion vide écrit `counter_restored`. Ce dernier rend tout le compteur, sauf pour les compteurs de plus d'une unité : la projection ne sait que tout rendre, donc l'usage partiel s'annule avec « Annuler ».
- **Recharge** :
  - la plage vient de l'action du profil (`uses.recharge`, « 5-6 ») ;
  - « Lancer 1d6 » tire avec `Random`, rend la capacité si `rechargeSucceeds`, et affiche le résultat dans une `SnackBar` ;
  - le rappel ne s'affiche que pour l'unité active, s'il lui reste une recharge à 0.
- **Ajout en combat** :
  - `FoePicker` reçoit un rappel `onAdd(kind, refId)`, et l'ajout à la préparation reste son comportement par défaut ;
  - le nouveau combattant est construit par `profileCombatant(...)`, extrait de `launchEvents` : son identifiant est un `uuidV7`, et son nom suit ses semblables (« Loup sanguinaire 4 ») ;
  - son jet d'initiative suit dans le même ajout.
- **Fin** : `CombatStore.finish`, puis retour à la préparation.

## Risks / Trade-offs

- **Rendre une seule action légendaire** sur trois n'existe pas dans le moteur, qui rend tout le compteur. Le cas est rare, puisque les actions légendaires reviennent d'elles-mêmes à chaque tour ; « Annuler » couvre l'erreur de saisie.
- **PV affichés mais figés** jusqu'à US-21 : l'écran montre l'état projeté, qui ne change pas encore.
