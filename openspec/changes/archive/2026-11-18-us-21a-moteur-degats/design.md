## Context

`Combatant` (US-20) porte `hp`, `hpMax` et `ac` en lecture seule, venus de `combatant_added`. La liste des événements est fermée (`CombatEventType`), et la projection rejoue le journal. Le SRD fixe l'ordre des ajustements : réductions, puis Résistance (moitié, arrondie à l'inférieur), puis Vulnérabilité (double). L'Immunité annule.

## Decisions

- **Événements** :
  - `damage {targets, amount, type, critical, half, double}` : `half` et `double` sont les corrections manuelles du pavé, pour toutes les cibles ;
  - `heal {targets, amount}` ;
  - `temp_hp {targets, amount, replace}` ;
  - `death_save {combatant, outcome}`, où `outcome` vaut `success`, `failure`, `nat1` ou `nat20`.
- **Défenses** : `combatant_added` reçoit `resistances`, `vulnerabilities` et `immunities`, des listes d'identifiants de types de dégâts (`srd:damage-type:acid`). Pour un monstre, elles viennent de son profil ; un PJ n'en a pas dans sa fiche calculée, et le MJ les corrige à la main.
- **`resolveDamage(combatant, amount, type, {half, double})`** : une fonction pure qui rend `DamageResult(taken, hpBefore, hpAfter, tempBefore, tempAfter)`. La projection et l'aperçu l'utilisent toutes les deux.
- **État mutable du combattant** : `hp`, `tempHp`, `deathSuccesses`, `deathFailures`, `stable` et `dead`. Plusieurs valeurs en sont dérivées :
  - `unconscious` : un PJ à 0 PV, vivant ;
  - `outOfCombat` : un autre combattant à 0 PV ;
  - un combattant sans PV connus ignore les dégâts.
- **Jets contre la mort** :
  - un jet n'est accepté que pour un PJ à 0 PV, ni stable ni mort ;
  - `nat1` ajoute deux échecs ;
  - `nat20` rend 1 PV et remet les compteurs à zéro ;
  - trois échecs le tuent, trois réussites le stabilisent ;
  - un dégât sur un PJ stable relance les jets (il n'est plus stable) et compte un échec, deux sur un coup critique.
- **Soin** : un mort ne se soigne pas. Un PJ à 0 PV soigné se relève, avec compteurs à zéro et `stable` faux.

## Risks / Trade-offs

- **Dégâts massifs** (mort sur le coup si l'excédent atteint les PV max) : EF-PV-05, donc US-37. D'ici là, le MJ enregistre trois échecs.
- **PV d'un PJ** : ils vivent dans le journal du combat, sans retour sur sa fiche (US-36).
