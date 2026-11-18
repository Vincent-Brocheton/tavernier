# Design

## Événements

| Type | Données |
| --- | --- |
| `concentration_started` | `combatant`, `spell` (nom affiché) |
| `concentration_check` | `combatant`, `success` |
| `concentration_ended` | `combatant` |

Un état lié porte `concentration: <id du lanceur>` dans `condition_added`. Le lien vise le lanceur, pas un sort précis : commencer une autre concentration retire déjà les effets de la précédente, donc il n'y a pas d'ambiguïté.

## Projection

- **Concentration** : `Combatant.concentration` (nom du sort) et `Combatant.concentrationChecks` (DD en attente, avec les dégâts subis, dans l'ordre).
- **Test** : `damage` ajoute un test quand `taken > 0` et que la cible est concentrée. `concentrationDc(taken)` est une fonction pure, exportée pour l'aperçu du pavé.
- **Fin** : `_endConcentration(caster)` vide la concentration et les tests, puis retire de tous les combattants les instances dont `concentration == caster.id`. Elle sert à `concentration_ended`, à un échec et à une nouvelle `concentration_started`.
- **Effets liés** : `CombatState.linkedTo(casterId)` liste les états liés, pour le texte de confirmation (« Béni est retiré d'Aldric et Thalia »).

## Écran

- **`ConcentrationAlerts`** (`concentration.dart`) :
  - une carte `concentrationContainer` par test en attente, placée sous le bandeau de début de tour ;
  - Réussite écrit le test tout de suite ;
  - Échec ouvre un dialogue de confirmation qui nomme le sort et les effets liés.
- **Puce** : `Chip` de couleur `concentrationContainer`, avec l'icône `GameIcons.concentration`, sous les états de la carte.
- **Détail** :
  - « Se concentrer » ouvre un dialogue avec un `Autocomplete` sur les noms des sorts à concentration du contenu actif. La saisie reste libre, pour un sort de monstre ou d'homebrew.
  - « Mettre fin » passe par la même confirmation que l'échec.
- **[C5]** : une liste déroulante sous les durées. « Aucun » est la valeur par défaut.
- **Pavé** : une ligne de plus dans `_Preview` quand la cible est concentrée et que les dégâts dépassent 0.

## Choix

- **Sort désigné par son nom** : pas d'identifiant de sort. Un monstre lance des sorts décrits dans son profil, souvent hors des entités `spell`.
- **Tests en file** : le SRD demande un JS par source de dégâts. Deux attaques avant la résolution donnent deux alertes.
- **Pas de fin automatique à 0 PV** : c'est EF-CON-06 (US-37). Le test reste en attente jusqu'à ce que le MJ le résolve ou mette fin à la concentration.
