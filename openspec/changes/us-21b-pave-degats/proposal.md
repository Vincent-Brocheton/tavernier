# Proposal

## Why

Carte Trello [US-21](https://trello.com/c/BYwN5Svc), lot b, le dernier. Le MJ applique dégâts et soins à un ou plusieurs combattants, **en deux interactions au plus** (**EF-PV-01** à **04**, planches [1a] et [1b], composants `DamageKeypad` §2.4, `HpBar` §2.2, `DeathSaves` §2.7). Le moteur est prêt (lot a).

## What Changes

- **Cibles sur l'écran de combat** ([1a]) :
  - toucher une carte la cible, et un appui long en ajoute ou en retire d'autres ;
  - l'icône « Détail » ouvre la feuille du combattant, que toucher la carte ouvrait jusque-là ;
  - le pied affiche « Cible : Chef de bande · appui long pour en cibler plusieurs », puis « Dégâts », « Soins », « PV temp. » et « Tour suivant ».
- **Pavé** ([1b], feuille modale) :
  - **Cibles** : en puces retirables, et « Cible » pour en ajouter ;
  - **Montant** : en grand, avec son type (« 12 tranchants »), et des puces de type de dégâts (un seul choix) ;
  - **Aperçu par cible** : « 22 → 10 / 38 PV », avec la portion perdue sur la barre ;
  - **« Coup critique »** : « Ne change pas le montant saisi ; sur un PJ à 0 PV, compte deux échecs. » ;
  - **Pavé de touches** : 0 à 9, « + » et « − » pour additionner des dés, effacement, « Vulnérabilité ×2 », « Résistance ½ », « PV temp. » et « Soins » ;
  - **Bouton principal** : « Appliquer 12 dégâts tranchants », « Soigner de 12 PV » ou « Donner 12 PV temporaires ».

  Deux interactions suffisent : ouvrir le pavé, puis appliquer, sans compter la saisie du montant.
- **Cartes** :
  - barre de PV colorée (plus de la moitié : soins ; plus du quart : alerte ; sinon : dégâts) ;
  - pastille de PV temporaires « +5 » ;
  - PJ à 0 PV : « Inconscient », avec ses jets contre la mort (cercles et carrés) ;
  - mort : « Mort » ;
  - monstre à 0 PV : estompé, avec « Hors de combat ».
- **Feuille d'un PJ à 0 PV** : jets contre la mort à saisir (« Réussite », « Échec », « 1 naturel », « 20 naturel »), puis « Stabilisé » ou « Mort ».

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `tables` : cibles, pavé de dégâts et soins, état des PV sur les cartes, jets contre la mort.

## Impact

- `apps/game_table/lib/encounters/` :
  - `damage_keypad.dart` (nouveau) ;
  - `combat_view.dart` : cibles, pied, cartes ;
  - `combatant_sheet.dart` : jets contre la mort.
- ARB et tests de widgets.

**Hors périmètre :**
- **« État »** (poser une condition) : US-22.
- **Alerte de concentration dans l'aperçu** : US-23.
- **Aperçu de mort sur le coup et « Assommer »** : US-37.
- **Icônes propres des types de dégâts** : COMPOSANTS §2.3 annonce un jeu d'icônes à produire. Les puces portent ici le libellé seul.
