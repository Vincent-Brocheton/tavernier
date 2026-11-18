# Design

## Fichier `condition_sheets.dart`

- **`conditionIcon(String? id)`** : icône Material de chaque état, et `Icons.auto_awesome` pour « Autre effet ». Ce sont des remplaçants des icônes dessinées de §2.3 ; le libellé est toujours affiché à côté.
- **`showAddCondition(context, encounter, targets)`** : feuille modale `_AddCondition`, un `ConsumerStatefulWidget` qui garde :
  - l'état choisi : un identifiant, ou `null` pour « Autre effet » ;
  - la sorte de durée, le nombre de rounds, le combattant X, le DD et la caractéristique ;
  - les niveaux d'Épuisement ;
  - pour « Autre effet » : le libellé, et les dégâts récurrents (dés, type, début ou fin).
- **Valeurs par défaut** :
  - le premier état est choisi d'emblée, avec une durée de 1 round ;
  - X est le premier membre de l'unité active, sinon la première cible ;
  - la sauvegarde est un JS de Force, DD 10.
- **Envoi** : un `condition_added` par cible, chacun avec son instance (`uuidV7()`), écrits ensemble par `appendCombat`.
- **`ConditionChip(combatant, instance, combat)`** : puce compacte (26 dp) dans la carte. Elle montre l'icône, le nom (celui de l'état, « Épuisement N », ou le libellé) et la durée courte en `bodySmall` atténué. La toucher ouvre la fiche.
- **`showConditionSheet(context, encounter, combatantId, instanceId)`**, fiche [K4] :
  - le nom, puis « État · <pack> » ;
  - `textFr` de l'entité ;
  - « Dans ce combat », avec la durée longue ;
  - les boutons « Retirer l'état » (`condition_removed`) et, pour l'Épuisement, « Retirer un niveau » (`levels: 1`) ;
  - « Fermer ».
- **Durées**, en court pour la puce et en long pour la fiche :
  - rounds restants : `instance.round + N − round` courant, au moins 1 ;
  - début ou fin du tour de X : « début tour X » ou « fin tour X ». Si X n'est plus là, son identifiant est remplacé par « ? » ;
  - sauvegarde : « JS FOR DD 13 », au moyen de `abbreviation()` de `sheet_breakdowns.dart` ;
  - indéfinie : rien sur la puce, « durée indéfinie » sur la fiche.

## Écrans touchés

- **`combat_view.dart`** :
  - le pied gagne `IconButton.filledTonal` « État » (`Icons.label_outline`) ;
  - `_CombatantCard` reçoit le `CombatState`, pour résoudre le nom de X, et affiche un `Wrap` de `ConditionChip` sous la barre de PV.
- **`combatant_sheet.dart`** : une section « États et effets » liste les puces, avec un bouton « Ajouter un état » qui vise ce combattant.
