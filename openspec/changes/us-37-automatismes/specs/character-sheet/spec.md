## ADDED Requirements

### Requirement: Épuisement appliqué
`computeSheet` SHALL recevoir le niveau d'Épuisement de l'état de jeu. Chaque niveau SHALL retirer 2 aux tests d20 et 5 pieds (1,50 m) à la Vitesse. Les tests d20 touchés sont les compétences, les jets de sauvegarde, l'Initiative et les bonus d'attaque, y compris l'attaque de sort. Chaque valeur touchée SHALL porter une contribution « Épuisement ». La Perception passive, qui n'est pas un test d20, SHALL rester inchangée.

#### Scenario: Aldric épuisé ([F3a])
- **WHEN** Aldric, Guerrier 5, a 2 niveaux d'Épuisement
- **THEN** l'Athlétisme vaut +3 (+4 Force, +3 maîtrise, −4 Épuisement), l'Initiative +0 et la Vitesse 6 m

#### Scenario: Niveau 5 ([F3b])
- **WHEN** Aldric a 5 niveaux d'Épuisement
- **THEN** son Initiative vaut −6 et sa Vitesse 1,50 m

### Requirement: Mort par Épuisement
Sur la fiche, passer au niveau 6 d'Épuisement SHALL demander une confirmation. Au niveau 6, le personnage SHALL être mort : la fiche passe en lecture seule, avec la puce « Mort · Épuisement 6 ». Retirer un niveau SHALL rendre la fiche modifiable. En combat, un combattant au niveau 6 SHALL être mort, et sa concentration SHALL prendre fin.

#### Scenario: Confirmation ([F3b])
- **WHEN** le joueur ajoute un niveau à Aldric, épuisé 5, puis confirme
- **THEN** Aldric est mort et sa fiche est en lecture seule

#### Scenario: Annulée
- **WHEN** le joueur retire un niveau à Aldric mort d'épuisement
- **THEN** Aldric est à l'Épuisement 5 et sa fiche est modifiable

### Requirement: Puce d'Épuisement
La fiche et la carte de combat SHALL montrer « Épuisement n · −2n aux tests d20 · Vitesse −m » pour un niveau n entre 1 et 5.

#### Scenario: Fiche ([F3a])
- **WHEN** Aldric a 2 niveaux d'Épuisement
- **THEN** la fiche montre « Épuisement 2 · −4 aux tests d20 · Vitesse −3 m »
