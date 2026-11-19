## ADDED Requirements

### Requirement: Tables de règles d'une entité rule
Une entité `rule` SHALL pouvoir porter des `data` avec deux tables facultatives :
- `study_skills` : pour chaque type de créature, la compétence suggérée par l'Étude ;
- `influence_checks` : des façons d'interagir, chacune avec `id`, `ability`, `skill` et `creature_types`. Une liste `creature_types` vide signifie toute cible.

Leurs compétences et caractéristiques SHALL être des références contrôlées. Une entité `rule` sans `data` SHALL rester valide. Ces tables SHALL se lire dans le contenu actif, pour qu'un pack les remplace (EF-ACT-05).

#### Scenario: Domaines de savoir du SRD
- **WHEN** le pack SRD est lu
- **THEN** `srd:rule:study` suggère Histoire pour un Humanoïde, Arcanes pour une Aberration, Nature pour un Dragon et Religion pour un Mort-vivant

#### Scenario: Tests d'Influence du SRD
- **WHEN** le pack SRD est lu
- **THEN** `srd:rule:influence` porte Intimider (Charisme, Intimidation), Convaincre (Persuasion), Amuser (Représentation), Tromper (Tromperie) et Amadouer (Sagesse, Dressage), ce dernier pour une Bête ou une Monstruosité

#### Scenario: Référence inconnue
- **WHEN** une table cite `srd:skill:inexistante`
- **THEN** le pack est refusé
