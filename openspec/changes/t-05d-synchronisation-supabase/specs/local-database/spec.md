## ADDED Requirements

### Requirement: Enregistrement par différence
`CharacterStore.save` SHALL n'écrire que les lignes de la fiche qui changent : insérer les nouvelles, supprimer celles qui disparaissent, modifier les autres.

#### Scenario: Rien ne change
- **WHEN** une fiche est réenregistrée à l'identique
- **THEN** aucune écriture n'attend dans la file d'envoi

#### Scenario: Un objet change
- **WHEN** seule la quantité d'un objet change
- **THEN** la file d'envoi ne contient que cette quantité
