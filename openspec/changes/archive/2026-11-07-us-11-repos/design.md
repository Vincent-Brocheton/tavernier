# Design

## Contexte

`PlayState` porte les dépenses et la concentration. `character_state` a déjà `hp_current` et `exhaustion`. Les effets `grant_resource` et `free_casts` déclarent leur `recharge`, que le moteur n'exposait pas.

## Décisions

1. **`ComputedSheet.recharges`.** Par ressource, ce qui revient à chaque type de repos, y compris les lancers gratuits. `initiative` reste ignoré ici.
2. **`rest.dart`.** Fonctions pures : `spendHitDie`, `finishRest`, `hitPoints`. Le jet vient de l'écran, pour garder le moteur sans hasard.
3. **PV `null` = au maximum.** Une montée de niveau qui relève le maximum garde un personnage indemne à son maximum.
4. **Dés de vie.** Clés `hit-die:d10` dans les dépenses : `hit_dice_used` ne sait pas compter par type.
5. **Minimum 1 PV soigné par dé**, et un personnage à 0 PV ne se repose pas (SRD, Repos court et Repos long).
6. **Emplacements.** Pacte au repos court et au repos long, les autres au repos long seulement.
7. **`LongRestRule`.** `fullHitPoints` par défaut. `hitDice` rend les dés sans rendre les PV (EF-TAB-03).
8. **Validation en fin de repos.** Annuler ne change rien : l'écran travaille sur une copie jusqu'à « Terminer ».
9. **Jet.** « Lancer » tire le dé côté écran. Le lanceur partagé viendra avec US-33.

## Risques

- **Sans table :** la règle de repos long n'est pas encore réglable.
