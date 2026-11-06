## ADDED Requirements

### Requirement: Composants des caractéristiques
Le kit SHALL fournir la tuile d'acquisition par points, la bascule de bonus et le bandeau d'état. Un état SHALL se lire sans dépendre de la couleur seule, et chaque cible SHALL mesurer au moins 48 dp.

#### Scenario: Bascule bloquée
- **WHEN** une `BonusToggle` n'est pas disponible
- **THEN** elle ne réagit pas au toucher et s'annonce désactivée

#### Scenario: Bascule invalide
- **WHEN** une `BonusToggle` porte un bonus devenu invalide
- **THEN** son libellé est barré, et elle reste touchable pour le retirer

#### Scenario: Bandeau d'erreur
- **WHEN** un `StatusBanner` d'erreur s'affiche
- **THEN** il porte une icône et est annoncé aux lecteurs d'écran
