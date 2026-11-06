## 1. Règle de la caractéristique principale

- [x] 1.1 Tests puis `primary_abilities_any` : `ClassData`, table `player_class`, aller-retour, instantané du schéma
- [x] 1.2 Tests puis `meetsPrimary` ; Guerrier dans les sources, pack régénéré, `FORMAT_DNDPACK.md`

## 2. Kit

- [x] 2.1 Tests puis `WizardSteps`, `WizardProgress`, `WizardFooter`, `SelectionCard`, `SourceBadge`, `formatFeet`

## 3. Application

- [x] 3.1 Dépendances `flutter_riverpod` et `go_router` ; routes et bouton « Nouveau personnage »
- [x] 3.2 Tests puis `CreationDraft`, `missingChoice`, `creationProvider`, `contentProvider`
- [x] 3.3 Tests puis cadre de l'assistant (disposition selon le format)
- [x] 3.4 Tests puis étape Classe [P1]
- [x] 3.5 Tests puis étape Historique [P2]
- [x] 3.6 Tests puis étape Espèce [P3]

## 4. Vérifications

- [x] 4.1 Parcours vérifié dans le navigateur, téléphone et desktop
- [x] 4.2 `fvm exec melos run format`, `analyze`, `test` et `coverage` verts

## Workflow follow-up

- Revue `code-review` de la pull request, CI verte, fusion.
- Commentaire sur la carte Trello US-05 (lot 1/3).
- `openspec archive us-05a-creation-origine` après la fusion.
