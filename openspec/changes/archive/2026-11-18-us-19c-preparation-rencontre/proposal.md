# Proposal

## Why

Carte Trello [US-19](https://trello.com/c/IlyBQSQV), lot c, le dernier. Le MJ prépare une rencontre : il ajoute des adversaires du bestiaire et ses PNJ, en quantité numérotée, et voit sa difficulté se mettre à jour à chaque ajout (**EF-REN-02**, **EF-REN-03**, **EF-REN-04**, planche [C1], composant `DifficultyGauge` §2.12).

## What Changes

- **`DifficultyGauge`** (ui-kit) :
  - barre avec les repères Faible, Modérée et Élevée, et leur valeur ;
  - libellé et icône de la difficulté à gauche, total de PX et légende à droite ;
  - couleur selon le niveau atteint (`outline`, soins, alerte, dégâts) ;
  - région annoncée aux lecteurs d'écran à chaque changement.
- **Page d'une rencontre** ([C1]), qui remplace la lecture seule du lot b :
  - **En-tête** : « Les Marches de Brumeval · Séance 12 », le titre et « Dupliquer » ;
  - **Jauge** : « 3 000 PX » et « 4 PJ de niveau 5 » (ou « Aucun personnage présent ») ;
  - **« Prête à jouer »** : un interrupteur qui fait passer la rencontre de brouillon à prête, et retour ;
  - **« Personnages présents »** : « Aldric · Guerrier 5 », etc., d'après la séance (ou toute la table en réserve) ;
  - **« Adversaires »** : par groupe, le nom, « FP 3 · numérotés Vétéran 1 à 2 » ou « FP 2 · unique », « Initiative commune », un compteur − / + (− à 1 retire le groupe) et les PX du groupe. « PV des monstres » propose « Moyenne » ou « Jet au lancement » ;
  - **Ajout d'adversaires** : « Bestiaire, PNJ » (recherche), « Monstres » ou « PNJ », filtre de FP, puis « Bandit · Humanoïde · FP 1/8 · 25 PX » avec sa source et « + ». C'est une colonne à gauche sur grand écran, et une feuille « Ajouter un adversaire » sur téléphone ;
  - **Note** : « Budget de PX 2024 : seuil par personnage selon son niveau, additionné pour les personnages présents. ».

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `ui-kit` : jauge de difficulté.
- `tables` : préparation d'une rencontre.

## Impact

- `packages/dnd_ui_kit/lib/src/difficulty_gauge.dart` (nouveau), son export et son test.
- `apps/game_table/lib/encounters/` : `encounter_page.dart` (réécrite), `foe_picker.dart` (nouveau) et `encounters_providers.dart` (identifiant et FP des adversaires).
- ARB et tests de widgets.

**Hors périmètre :**
- **« Lancer la rencontre »** : US-20.
- **Présents propres à une rencontre** (cases à décocher) : ils demandent un stockage par rencontre. Les présents restent ceux de la séance, réglés à la préparation de la séance. Le lancement (US-20) pourra les ajuster.
- **PJ dans la recherche** : les PJ entrent par les présents.
- **Renommer la rencontre** : aucune planche ne le montre.
