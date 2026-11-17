## Context

`NpcStore.update` écrit déjà le nom, le dossier (`clearFolder`) et la liste des paliers (`HiddenInfo(dc, text, revealed)`). La fiche [C2] du lot b montre le profil et l'attitude.

## Decisions

- **Une seule feuille par palier** (`showModalBottomSheet`), qui rend le palier modifié, un ordre de suppression, ou rien si le MJ annule :
  - un champ « DD » numérique, valide de 1 à 30 ;
  - un champ « Information » de plusieurs lignes ;
  - « Supprimer », pour un palier existant seulement ;
  - « Enregistrer », désactivé tant que la saisie n'est pas valide.
- **Écriture de la liste entière** : à chaque enregistrement, la liste triée par DD est réécrite avec `update(hiddenInfo:)`. Un PNJ en a quelques paliers, et la colonne est un seul JSON.
- **État conservé** : la modification d'un palier reprend `revealed` de l'original.
- **« Modifier »** : une feuille Nom et Dossier. Un dossier vidé appelle `update(clearFolder: true)`.
- **Table archivée** : ni ajout, ni modification, ni « Modifier », comme pour l'attitude.

## Risks / Trade-offs

- **Deux appareils du MJ hors ligne** : s'ils modifient chacun un palier, le dernier écrit l'emporte sur toute la liste, car la colonne est un seul JSON. C'est la règle des fiches (dernier écrit gagnant), et le cas reste rare.
