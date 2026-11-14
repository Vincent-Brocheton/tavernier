# Design

## Moteur

`level_unlock.dart` (dans `dnd_rules`) :

```dart
const xpThresholds = [0, 300, 900, 2700, 6500, 14000, 23000, 34000, 48000,
  64000, 85000, 100000, 120000, 140000, 165000, 195000, 225000, 265000,
  305000, 355000]; // niveau 1 → 20, SRD « Évolution du personnage »

enum UnlockOrigin { xp, milestone, override }

final class LevelUnlock { int level; UnlockOrigin origin; int? xp;
  String? by; String? reason; String? sessionId; }

LevelUnlock? levelUnlockOf({required int level, required int xp,
  required ProgressionMode mode, Map<String, Object?>? granted});
```

Règles de `levelUnlockOf` :
- Au niveau 20, rien.
- Un niveau accordé (`granted`) plus haut que le niveau actuel l'emporte, en jalons comme en PX. Un niveau de jalon ne compte qu'en jalons ; une dérogation compte dans les deux modes.
- En PX, le seuil du niveau suivant atteint déverrouille ce niveau. Il ne déverrouille qu'un niveau à la fois.
- Un niveau accordé déjà atteint ne compte plus. Il n'est donc pas effacé après la montée.

`ProgressionMode` vient de la colonne `game_table.progression_mode` (`xp` ou `milestone`).

## Base locale

- `access(id)` rend en plus `progression_mode`, `xp` et `level_unlock` (JSON décodé).
- `grantLevel(id, {level, origin, byUserId, reason, sessionId})` écrit `level_unlock` et une entrée d'historique `{kind: 'level_grant', level, origin, reason, session}`.
- `recordLevelUp(id, {from, to, unlock})` écrit une entrée `{kind: 'level_up', from, to, origin, by, reason}`. L'assistant l'appelle après l'enregistrement.

## Application

- `levelUnlockProvider(id)` lit `access` et la fiche, puis appelle `levelUnlockOf`. Il rend `null` pour une fiche hors table, qui garde le bouton libre d'aujourd'hui.
- `LevelGrantBanner` s'affiche en tête de l'onglet Principal (`primaryContainer`) :
  - titre : « Seuil de 14 000 PX atteint », « Niveau 6 accordé par Camille » ou « Niveau 6 débloqué par Camille (dérogation) » ;
  - sous-titre : le motif, s'il y en a un ;
  - boutons : « Plus tard » (texte) et « Monter au niveau 6 » (plein).
- « Plus tard » ajoute `id:niveau` à une liste gardée dans `SharedPreferences`, comme les conflits déjà vus. La puce « Niveau 6 », placée dans le bloc d'identité, rouvre le bandeau.
- Sans déverrouillage, en PX : la ligne « 7 475 / 14 000 PX » apparaît sous l'identité, avec `Semantics` comme une jauge.
- Dérogation : le bouton « Débloquer le niveau n » apparaît pour le MJ qui regarde la fiche d'un joueur de sa table (`gmProposalViewProvider` non nul). Il ouvre une boîte avec un motif facultatif, puis appelle `grantLevel(origin: override)`.
- L'historique affiche « Niveau 6 accordé par … : motif », « Niveau 6 débloqué (dérogation) » et « Montée au niveau 6 ».
