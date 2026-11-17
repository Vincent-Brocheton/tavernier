## Context

Plusieurs pièces existent déjà :
- **`EncounterStore.watchList`** (lot a) : les rencontres et leurs groupes.
- **`SessionStore`** (US-35) : les séances et les présences.
- **`tableGroupProvider`** : les résumés des personnages, avec leurs classes et leurs niveaux.
- **`contentProvider`** et **`tableNpcsProvider`** : les PX d'un monstre ; un PNJ en bloc de stats prend les PX de son monstre de départ.
- **Moteur** : `encounterBudget` et `encounterDifficulty` (lot a).

## Decisions

- **Adversaires d'une rencontre** (`encounterFoes`) : pour chaque groupe, un nom, une quantité et les PX unitaires.
  - Pour un monstre, ce sont son nom et ses PX dans le contenu.
  - Pour un PNJ, ce sont son nom et les PX de son monstre de départ, ou 0 pour une fiche complète. Le budget 2024 ne compte que les PX des profils.
  - Une référence introuvable s'affiche « Adversaire introuvable », à 0 PX.
- **PJ présents** :
  - avec une séance : les personnages prévus à cette séance (`sessionAttendanceProvider`) ;
  - en réserve : tous les résumés de la table.

  Le niveau d'un personnage est la somme de ses niveaux de classe, d'après son résumé. Sans aucun PJ présent, il n'y a pas de difficulté.
- **Ligne** : `Vétéran ×2, Bandit ×4 · 1 500 PX · Modérée` (ou « sous le budget faible »). Les libellés de difficulté viennent de l'ARB. La quantité s'écrit `×n` à partir de 2.
- **Ordre des sections** : séances non closes par date croissante, puis la réserve, puis séances closes par date décroissante. Une séance sans rencontre n'a pas de section. Dans une section, l'ordre est celui de `watchList` (position, création).
- **Filtres** : « À jouer » regroupe `draft` et `ready` ; « Terminées » vaut `finished`. Les rencontres `running` n'apparaissent que sous « Toutes ».
- **Recherche** : `foldAccents` sur le titre et les noms des adversaires.
- **« Nouvelle rencontre »** : une feuille avec le titre (obligatoire) et un `DropdownButtonFormField` des séances non closes, plus « Sans séance ». À la création, la page de la rencontre s'ouvre.
- **« Ranger dans une séance »** : une feuille qui liste les séances non closes ; le choix écrit `session_id`.
- **Panneau latéral** : affiché à partir de la largeur tablette (`FormFactor`). La prochaine séance est la première séance non close par date.
- **Page d'une rencontre** (`EncounterPage`) : le titre, la séance et la liste des adversaires (nom, quantité, PX). Le lot c la remplace par [C1].

## Risks / Trade-offs

- **Présences par séance** : la difficulté de chaque rencontre lit la présence de sa séance. Les rencontres d'une même séance partagent la même source, observée une seule fois par séance grâce aux providers `family`.
- **PNJ en fiche complète** : il compte 0 PX, faute de profil. Le budget 2024 ne s'applique qu'aux monstres et aux blocs de stats.
