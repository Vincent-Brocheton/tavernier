# Design

## Lot a

### Moteur (`combat.dart`)

- **`instantDeath(Combatant, DamageResult)`** : vrai pour un PJ vivant dans deux cas.
  - Debout : il tombe à 0 PV avec un excédent (dégâts après PV temporaires, moins les PV avant) au moins égal à ses PV max.
  - Déjà à 0 PV : les dégâts après PV temporaires sont au moins égaux à ses PV max.

  `_takeDamage` s'en sert pour marquer `dead`. L'aperçu l'utilise aussi.
- **`knock_out`** (payload de `damage`) :
  - une cible qui tomberait de plus de 0 à 0 PV reste à 1 PV et reçoit une instance `srd:condition:unconscious`, d'identifiant `<id de l'événement>:ko`, marquée `knocked_out` ;
  - un soin d'au moins 1 PV retire les instances `knocked_out` ;
  - il n'y a ni jet contre la mort ni hors de combat : la cible a 1 PV.
- **`stabilized`** (issue de `death_save`) : `stable = true` pour un PJ inconscient.
- **Fin automatique** : dans `projectCombat`, `endConcentration` est appelée dans deux cas :
  - après les dégâts sur une cible concentrée tombée à 0 PV ou morte ;
  - après la pose effective (pas d'immunité) d'un état de `incapacitatingConditions` (`incapacitated`, `unconscious`, `paralyzed`, `petrified`, `stunned`, d'après le SRD : chacun inclut Neutralisé). L'instance d'Assommer en fait partie.

### Écran

- **Pavé** (`_Preview`) :
  - la ligne d'alerte « Mort sur le coup · excédent n ≥ PV max m (dégâts massifs) », ou « Mort : n dégâts à 0 PV ≥ PV max m » ;
  - la ligne « Concentration : <conséquence> » quand la cible tombe à 0 PV, à la place du DD ;
  - le bouton d'application devient « Appliquer : <nom> meurt » pour une cible unique qui meurt.
- **Assommer** : un `SwitchListTile`, affiché seulement pour une cible unique qui tomberait à 0 PV sans mourir. Son sous-titre : « Attaque de corps à corps : <nom> reste à 1 PV avec l'état Inconscient. »
- **Soutien** : un bouton « Soutien réussi » à côté des jets contre la mort, dans le détail du combattant.
- **[C5]** : quand l'état choisi met fin à la concentration d'une cible, une ligne avertit avec la conséquence.

## Choix

- **La confirmation EF-CON-06 se fait dans l'aperçu**, avant validation. Une boîte de dialogue en plus après « Appliquer » ralentirait la saisie de dégâts, que EF-PV-01 limite à deux interactions. Le journal reste annulable.
- **Assommer est proposé pour toute cible unique**. Le pavé ne sait pas si l'attaque est au corps à corps : le libellé le rappelle, et le MJ décide.

## Lot b

- **Moteur** : `computeSheet(character, content, {int exhaustion = 0})`.
  - Une contribution `exhaustionSource` (−2 × niveau) s'ajoute aux compétences, aux sauvegardes, à l'Initiative et aux attaques (armes, mains nues, sort) ; −5 pieds × niveau s'ajoutent à la Vitesse.
  - La Perception passive ajoute 2 × niveau pour annuler la pénalité de Perception : le SRD la calcule depuis le modificateur, pas depuis un test d20.
  - `exhaustionDeath = 6`. En combat, `_addCondition` marque `dead` au niveau 6, et la pose met fin à la concentration.
  - `PlayState.withExhaustion`.
- **Fiche** :
  - `SheetPage` lit l'état de jeu et passe le niveau au calcul ;
  - la fiche est en lecture seule à partir de 6 ;
  - `ExhaustionTracker` (onglet Principal) montre la puce et le réglage − / +, plus la confirmation du niveau 6 ([F3b]). Son « − » reste actif sur une fiche morte, si l'utilisateur a le droit de la modifier : c'est l'annulation.
- **Combat** : la puce de l'état Épuisement reprend le libellé complet (`exhaustionLabel`).

### Choix

- **Mort déduite du niveau**, sans nouveau champ : la colonne `exhaustion` existe déjà, donc pas de changement de schéma.
- **Annulation par le « − » de la fiche**, et non par l'historique comme le dit [F3b] : l'historique de la fiche n'annule rien aujourd'hui.
- **Le MJ voit la mort sur la fiche synchronisée** : il n'y a pas de notification à part.
