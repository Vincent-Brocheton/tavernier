## ADDED Requirements

### Requirement: Variantes du bandeau d'état
`StatusBanner` SHALL proposer les variantes erreur (`errorContainer`) et alerte (`alertContainer`), avec un titre facultatif et une icône. La couleur ne SHALL jamais porter seule l'information.

#### Scenario: Erreur sans titre
- **WHEN** le bandeau d'erreur n'a qu'un message
- **THEN** il affiche l'icône d'erreur et le message, et s'annonce au lecteur d'écran

### Requirement: Règles du mot de passe
`PasswordRules` SHALL afficher une jauge de robustesse en 4 segments, exposée comme une mesure avec son libellé, et la liste des règles, chacune avec son état (respectée, non respectée, en attente) lu par le lecteur d'écran (COMPOSANTS 2.58).

#### Scenario: Règle respectée
- **WHEN** une règle est respectée
- **THEN** elle affiche une coche et le lecteur d'écran lit « Respecté »
