## Context

Plusieurs pièces existent déjà :
- **Moteur** (lot a) : `projectCombat`, `rollInitiative`, `combineRollModes`, `numberedLabels`, `rollHitPoints`.
- **Journal** (lot b) : `CombatStore.launch` et `append`.
- **Préparation** (US-19) : les groupes (`EncounterGroup`), les PJ présents et le mode de PV.
- **Fiche calculée** (`computeSheet`) : elle donne `initiative` (valeur et `advantage`), `armorClass` et `hitPointsMax` ; `CharacterStore.loadState` donne les PV courants.

## Decisions

- **`launchEvents(...)`** (app, `launch.dart`) : une fonction pure qui rend les événements du lancement, à partir de la rencontre, du contenu, des PNJ, des PJ présents (identifiant, nom, joueur, fiche calculée, PV courants) et d'un `Random`.
  - **Un PJ** : `kind: pc`, `ref_id` = sa fiche, `owner` = son joueur.
  - **Un PNJ en fiche complète** : comme un PJ, mais en `kind: npc`.
  - **Un groupe** : un membre par exemplaire, d'identifiant `<groupe>:<n>`. `group_id` vaut l'identifiant du groupe si l'initiative est commune, sinon rien.
  - **Compteurs d'un profil** : `legendary_actions` = `legendaryUses`, `legendary_resistance` = usages par jour du trait « Résistance légendaire », `recharge:<action>` = 1 pour chaque action à recharge.
  - **Jets automatiques** : un par unité de monstre ou de PNJ, en mode normal.
- **Écran d'initiative** (`CombatPage`, au round 0) :
  - la surprise est un état de l'écran, initialisé par le dernier jet de chaque unité ;
  - marquer un monstre surpris relance son jet (`initiative_rolled`, `surprised: true`) ;
  - pour un PJ, la surprise change le mode affiché et s'enregistre avec son jet saisi ;
  - la saisie d'un PJ prend le dé gardé (1 à 20) et écrit `initiative_rolled` avec le bonus de sa fiche ;
  - le glisser-déposer écrit `order_set` avec l'ordre affiché.
- **Origine** : « Jet automatique » (monstre, PNJ) ou « Saisi par le MJ » (PJ). « Saisi par Hugo » viendra avec US-36.
- **Après « Commencer le round 1 »** : l'écran affiche « Round 1 · tour de Thalia ». Le lot d le remplace par l'écran de combat.
- **Disposition** : deux colonnes sur grand écran (tableau, ordre), une seule sur téléphone, avec le tableau en cartes.

## Risks / Trade-offs

- **Fiche illisible** (contenu manquant) : le PJ est ajouté avec un bonus de 0 et sans PV. Le MJ peut le corriger dans le combat (US-21).
- **Relancer un monstre surpris** remplace son premier jet. Le journal garde les deux jets, et la projection retient le dernier.
