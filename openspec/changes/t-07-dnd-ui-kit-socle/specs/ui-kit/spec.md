## ADDED Requirements

### Requirement: Tokens issus de la source de vérité
Les couleurs, la typographie, les espacements, les rayons, les tailles, les points de rupture, les opacités d'état et les durées de mouvement du kit SHALL être exactement ceux de `docs/design/design_tokens.json`.

#### Scenario: Couleur sombre
- **WHEN** on lit la couleur `primary` du thème sombre
- **THEN** elle vaut `#84D5C4`, comme dans les tokens

#### Scenario: Écart avec les tokens
- **WHEN** une valeur du kit diffère de celle du fichier de tokens
- **THEN** le test de concordance échoue en nommant le jeton

### Requirement: Thème sombre par défaut
Le kit SHALL fournir un thème sombre (MVP) et un thème clair (V1.5) Material 3. Leur schéma de couleurs vient des tokens, l'élévation est tonale (sans teinte de surface) et les cibles tactiles font au moins 48 dp (COMPOSANTS §1, ENF-14).

#### Scenario: Thème de l'application
- **WHEN** l'application démarre
- **THEN** elle utilise le thème sombre, de surface `#1A1612`

#### Scenario: Cible tactile
- **WHEN** un bouton du thème est rendu
- **THEN** sa zone tactile mesure au moins 48 × 48 dp

### Requirement: Couleurs de jeu
Le kit SHALL exposer les cinq couleurs réservées au jeu (dégâts, soins, PV temporaires, concentration, alerte), avec leurs conteneurs, dans chaque thème. La barre de PV SHALL prendre la couleur des soins au-dessus de 50 %, de l'alerte au-dessus de 25 %, et des dégâts sinon (COMPOSANTS §2.2).

#### Scenario: Paliers de la barre de PV
- **WHEN** on demande la couleur de la barre pour 31/52, 13/52 et 3/11 PV
- **THEN** on obtient respectivement soins, alerte et dégâts

### Requirement: Formats d'écran
Le kit SHALL classer une largeur en téléphone (< 600 dp), tablette paysage (600 à 1023 dp) ou desktop (≥ 1024 dp), et donner la marge de page de chaque format : 16, 24 et 32 dp.

#### Scenario: Bornes
- **WHEN** on classe 599, 600, 1023 et 1024 dp
- **THEN** on obtient téléphone, tablette, tablette et desktop

### Requirement: Typographie
Les styles Display et Headline SHALL utiliser Cinzel, et tous les autres Roboto Flex, toutes deux embarquées dans l'application avec leur licence. Les valeurs chiffrées SHALL disposer d'un style à chiffres tabulaires.

#### Scenario: Familles
- **WHEN** on lit `headlineSmall` puis `bodyMedium` du thème
- **THEN** le premier est en Cinzel et le second en Roboto Flex, aux tailles des tokens (24 et 14)

#### Scenario: Chiffres tabulaires
- **WHEN** on applique le style numérique
- **THEN** il active la fonctionnalité de police `tnum`

### Requirement: Icônes de jeu
Le kit SHALL fournir une icône pour chacun des 15 états, des 13 types de dégâts, d'action, d'action Bonus et de réaction, et des 8 écoles de magie, rendue en trait à la taille et à la couleur de l'`IconTheme`. Une icône porteuse de sens SHALL avoir un libellé lu par les lecteurs d'écran ; une icône décorative SHALL en être exclue.

#### Scenario: Jeu complet
- **WHEN** on liste les icônes d'états, de types de dégâts, d'économie d'actions et d'écoles
- **THEN** on en compte respectivement 15, 13, 3 et 8, chacune avec un tracé lisible

#### Scenario: Libellé
- **WHEN** l'icône Empoisonné est rendue avec le libellé « Empoisonné »
- **THEN** l'arbre sémantique contient « Empoisonné »

### Requirement: Navigation adaptative
L'application SHALL présenter ses cinq destinations (Accueil, Tables, Personnages, Compendium, Homebrew) dans une barre de navigation de 80 dp en bas sur téléphone, et dans un rail de navigation de 80 dp à gauche à partir de 600 dp.

#### Scenario: Téléphone
- **WHEN** la fenêtre mesure 390 dp de large
- **THEN** une barre de navigation affiche les cinq destinations et aucun rail n'est présent

#### Scenario: Tablette et desktop
- **WHEN** la fenêtre mesure 960 puis 1440 dp de large
- **THEN** un rail affiche les cinq destinations et aucune barre n'est présente

#### Scenario: Changement de destination
- **WHEN** l'utilisateur touche « Personnages »
- **THEN** la destination Personnages devient sélectionnée

### Requirement: Accessibilité du texte et du mouvement
L'application SHALL borner la taille du texte choisie par l'utilisateur entre 85 et 200 %, et SHALL ramener à zéro les durées d'animation du kit quand le système demande de réduire les animations (ENF-14).

#### Scenario: Taille de texte excessive
- **WHEN** le système demande 300 % de taille de texte
- **THEN** le texte de l'application est rendu à 200 %

#### Scenario: Animations réduites
- **WHEN** le système demande de réduire les animations
- **THEN** la durée de mouvement standard du kit vaut zéro

### Requirement: Planche golden du kit
Le rendu du thème, de la typographie, des icônes et de la navigation sur les trois formats SHALL être comparé à des images de référence (cahier §12.1), sur la plateforme de référence de la CI (Linux).

#### Scenario: Régression visuelle
- **WHEN** une couleur ou une icône change sans mise à jour des références
- **THEN** le test golden échoue en CI
