## ADDED Requirements

### Requirement: Résumés publiés
`CharacterStore` SHALL publier le résumé d'une fiche de table seulement s'il a changé. `TableStore` SHALL rendre les résumés d'une table, à jour à chaque changement. L'état de santé qualitatif SHALL valoir « indemne » au maximum de PV, « blessé » au-dessus de la moitié, « gravement blessé » à la moitié ou moins.

#### Scenario: Seuils
- **WHEN** les PV sont 33/33, 17/33 puis 16/33
- **THEN** l'état est indemne, blessé, puis gravement blessé

#### Scenario: Rien de changé
- **WHEN** le même résumé est publié deux fois
- **THEN** une seule écriture part
