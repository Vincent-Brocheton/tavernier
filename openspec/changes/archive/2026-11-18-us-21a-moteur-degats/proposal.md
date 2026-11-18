# Proposal

## Why

Carte Trello [US-21](https://trello.com/c/BYwN5Svc), lot a : le moteur des points de vie en combat (**EF-PV-01** à **04**, cahier §6.3, SRD « Dégâts et soins »). Le journal (US-20) porte les combattants et leurs PV ; ce lot y ajoute les dégâts, les soins, les PV temporaires et les jets contre la mort. Le pavé de dégâts suit au lot b.

## What Changes

- **Nouveaux événements** :
  - `damage` : cibles, montant, type, coup critique, et corrections manuelles « Vulnérabilité ×2 » ou « Résistance ½ » ;
  - `heal` (cibles, montant) ;
  - `temp_hp` : cibles, montant, et remplacement facultatif ;
  - `death_save` : réussite, échec, 1 ou 20 naturel.
- **Dégâts** (SRD) :
  - l'Immunité annule les dégâts ;
  - la Résistance les divise par deux, arrondi à l'inférieur, puis la Vulnérabilité les double ;
  - les défenses viennent du profil du combattant, auxquelles s'ajoutent les corrections manuelles ;
  - les PV temporaires sont consommés en premier, et les PV ne descendent pas sous 0.
- **PV temporaires** : ils ne se cumulent pas. Le plus élevé est gardé, sauf remplacement demandé (EF-PV-02).
- **Soins** : jusqu'au maximum de PV. Un PJ à 0 PV soigné se relève, et ses jets contre la mort repartent de zéro.
- **À 0 PV** (EF-PV-03) :
  - **un PJ** est Inconscient et fait ses jets contre la mort. Trois réussites le stabilisent, trois échecs le tuent. Un 20 naturel lui rend 1 PV, un 1 naturel compte deux échecs. Chaque dégât subi à 0 PV compte un échec, deux sur un coup critique (EF-PV-04) ;
  - **un monstre** est « hors de combat » ; le MJ le garde dans l'ordre.
- **Aperçu** : `damagePreview` donne, par cible, les dégâts subis et les PV avant et après, sans rien écrire.
- **Lancement** : les défenses d'un monstre (résistances, vulnérabilités, immunités aux dégâts) passent dans `combatant_added`.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `encounters` : dégâts, soins, PV temporaires, jets contre la mort.

## Impact

- `packages/dnd_rules/lib/src/combat.dart` et ses tests.
- `apps/game_table/lib/encounters/launch.dart` (défenses du profil) et son test.

**Hors périmètre :**
- **Pavé de dégâts et cibles multiples à l'écran** : lot b.
- **Automatismes de 0 PV** d'EF-PV-05 (dégâts massifs, Stabilisé par Soutien) et **Assommer** (EF-PV-06) : US-37.
- **Concentration** : US-23.
- **Report des PV d'un PJ sur sa fiche** à la fin du combat : avec la vue du joueur (US-36).
