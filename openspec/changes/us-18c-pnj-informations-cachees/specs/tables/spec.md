## ADDED Requirements

### Requirement: Informations cachées d'un PNJ
La fiche d'un PNJ SHALL lister ses informations cachées, triées par DD croissant. Chaque palier SHALL afficher son DD, son texte et son état (« Révélée » ou « Cachée », avec une icône). Le MJ SHALL ajouter un palier (DD entier de 1 à 30, texte obligatoire), le modifier ou le supprimer. Un palier modifié SHALL garder son état de révélation.

#### Scenario: Ajouter des paliers
- **WHEN** Camille ajoute « Est la sœur cadette du bourgmestre Hesse. » au DD 20, puis « Ancienne sergente de la garde de Brumeval. » au DD 10
- **THEN** la fiche de Varga montre DD 10 puis DD 20, tous deux « Cachée »

#### Scenario: Valeurs refusées
- **WHEN** le texte est vide ou le DD vaut 0
- **THEN** le palier ne peut pas être enregistré

#### Scenario: Modifier et supprimer
- **WHEN** Camille passe le palier DD 10 à DD 12, puis supprime le palier DD 20
- **THEN** il reste un seul palier, au DD 12

#### Scenario: Palier révélé
- **WHEN** un palier révélé est modifié
- **THEN** il reste « Révélée »

### Requirement: Renommer et ranger un PNJ
« Modifier » SHALL permettre de changer le nom (obligatoire) et le dossier d'un PNJ. Un dossier vide SHALL sortir le PNJ de son dossier.

#### Scenario: Renommer et ranger
- **WHEN** Camille renomme le Sergent Varel « Sergent Varel de la garde » et le range dans « Brumeval »
- **THEN** la fiche et la liste montrent le nouveau nom, sous « BRUMEVAL »

#### Scenario: Sortir d'un dossier
- **WHEN** Camille vide le dossier de Varga
- **THEN** Varga passe sous « SANS DOSSIER »
