## Context

Les statuts de fiche viennent de US-15 : `draft`, `submitted`, `validated`, `changes_requested`, `archived`. Le propriétaire écrit sa fiche quel que soit son statut, sauf archivée (`can_write_character`, `sheetEditableProvider`). Le commentaire du MJ (`review_comment`) s'affiche déjà dans « Mon personnage ».

## Decisions

- **Données** : `CharacterStore.access` rend aussi `reviewComment`. Le bandeau lit ce même accès, comme `sheetEditableProvider`, sans nouvelle requête à surveiller.
- **Qui voit le bandeau** : le propriétaire seulement. Le MJ a son panneau de revue.
- **Nom du MJ** : `pseudonymOfProvider(gmUserId)`. Sans pseudonyme connu, « le MJ ».
- **Rendu** : `StatusBanner` de type information (icône sablier) pour l'attente ; `StatusBanner` d'alerte « Corrections demandées » pour le commentaire, comme dans « Mon personnage ». Pas de nouveau composant du kit : `PendingPlayableBanner` est ce couple de bandeaux.

## Risks / Trade-offs

- Comme pour les droits, l'accès est lu à l'ouverture de la fiche : un changement de statut reçu pendant qu'elle est ouverte n'apparaît qu'à la réouverture.
