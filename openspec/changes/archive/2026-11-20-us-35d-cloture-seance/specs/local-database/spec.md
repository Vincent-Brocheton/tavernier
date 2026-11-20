## ADDED Requirements

### Requirement: PX ajoutés à une fiche
`CharacterStore.addXp` SHALL ajouter des PX à une fiche et l'inscrire dans son historique, au nom du MJ, avec le montant, les PX avant et après, et la séance (EF-SEA-03).

#### Scenario: Clôture de la séance 12
- **WHEN** Camille ajoute 825 PX à Aldric, qui en a 7 475
- **THEN** Aldric a 8 300 PX, et son historique porte `{kind: xp, amount: 825, from: 7475, to: 8300, session}`
