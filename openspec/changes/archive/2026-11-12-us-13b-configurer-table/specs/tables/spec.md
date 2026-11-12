## ADDED Requirements

### Requirement: Configuration d'une table
Le MJ SHALL modifier la méthode de caractéristiques, le niveau de départ, le repos long, les PV à la montée de niveau, la progression et la visibilité des fiches complètes. Avant l'enregistrement, l'écran SHALL lister les modifications ; un changement de méthode SHALL rappeler qu'il ne touche pas les fiches existantes (EF-TAB-11).

#### Scenario: Changement de méthode
- **WHEN** le MJ choisit une autre méthode de caractéristiques
- **THEN** le bandeau « Ce changement ne touche pas les fiches existantes » s'affiche, et le panneau liste « Méthode : ancienne → nouvelle »

#### Scenario: Enregistrement
- **WHEN** le MJ enregistre
- **THEN** la table prend la nouvelle configuration, et chaque changement est daté dans l'activité

#### Scenario: Annulation
- **WHEN** le MJ annule
- **THEN** le formulaire revient à la configuration enregistrée

### Requirement: Activité de la table
Chaque changement de configuration et chaque archivage SHALL être daté, avec son auteur, dans l'activité de la table, visible des membres.

#### Scenario: Vue d'ensemble
- **WHEN** un membre ouvre la vue d'ensemble
- **THEN** il voit les derniers changements, datés

### Requirement: Archivage
Le MJ SHALL archiver la table, qui passe en lecture seule pour tous, et SHALL pouvoir la restaurer (EF-TAB-07).

#### Scenario: Archivée
- **WHEN** la table est archivée
- **THEN** la configuration est verrouillée, et seul « Restaurer » reste disponible
