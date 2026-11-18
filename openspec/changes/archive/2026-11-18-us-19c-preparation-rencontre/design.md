## Context

Plusieurs pièces existent déjà :
- **`EncounterStore`** (lot a) : il ajoute un groupe (en cumulant), change sa quantité ou son initiative commune, le retire, et modifie la rencontre.
- **Lot b** : il calcule les adversaires (`foesOf`), les PJ présents (`presentLevelsProvider`) et la difficulté.
- **Contenu actif** : il porte le type, le FP et les PX de chaque monstre. `sortedEntities` et `foldAccents` trient et cherchent.

## Decisions

- **`Foe`** reçoit l'identifiant du groupe, son FP (celui du monstre ou du monstre de départ du PNJ) et son initiative commune. La page agit directement sur le groupe.
- **Numérotation** : « numérotés {nom} 1 à {n} » à partir de 2, sinon « unique ». C'est la règle du lancement (US-20), annoncée dès la préparation.
- **« − » à 1** : il retire le groupe. Le serveur refuse de toute façon une quantité de 0.
- **Ordre des FP** : la valeur du FP est lue depuis la chaîne (« 1/8 » vaut 0,125). Le filtre est un `RangeSlider` sur la liste des FP présents dans le contenu ; sans filtre, la puce affiche « Tous les FP ». Les monstres sont triés par FP, puis par nom.
- **Disposition** : à partir de la largeur tablette, deux colonnes (ajout à gauche, préparation à droite). Sur téléphone, une seule colonne et « Ajouter un adversaire » ouvre le même composant (`FoePicker`) dans une feuille.
- **Personnages présents** : des puces en lecture, avec le nom et « Guerrier 5 » (classes du résumé).
- **« Prête à jouer »** : un `SwitchListTile`, affiché pour un brouillon ou une rencontre prête.
- **Jauge** : elle n'apparaît qu'avec au moins un PJ présent. Sinon, « Aucun personnage présent » remplace la jauge et le budget.

## Risks / Trade-offs

- **Présents par séance** : décocher un PJ pour une seule rencontre n'est pas possible. C'est un écart à [C1], noté dans la PR. Il faudra un stockage par rencontre (`encounter_presence`) si le besoin se confirme.
- **Grand bestiaire** : la liste du sélecteur est limitée à 50 lignes après filtre ; la recherche affine.
