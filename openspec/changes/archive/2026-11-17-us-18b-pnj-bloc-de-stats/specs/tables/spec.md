## ADDED Requirements

### Requirement: Onglet des PNJ
La page d'une table SHALL avoir, pour son MJ seul, un onglet « PNJ ». Il SHALL ranger les PNJ par dossier (sans dossier en dernier). Chaque PNJ SHALL montrer son nom, son monstre de départ avec son FP et son pack, et son attitude (icône et libellé). Des filtres par attitude SHALL afficher leur nombre de PNJ.

#### Scenario: Liste du MJ
- **WHEN** Camille ouvre l'onglet « PNJ » de Brumeval, où Varga (Hostile) est dans « Guilde du Sel » et le Sergent Varel (Indifférent) sans dossier
- **THEN** elle lit « GUILDE DU SEL », « Varga la Balafrée », « Chef de bande · FP 2 · SRD » et « Hostile », puis le Sergent Varel

#### Scenario: Filtre
- **WHEN** Camille touche « Hostiles · 1 »
- **THEN** seule Varga reste affichée

#### Scenario: Joueur
- **WHEN** Hugo ouvre la page de Brumeval
- **THEN** il n'a pas d'onglet « PNJ »

### Requirement: Nouveau PNJ en bloc de stats
« Nouveau PNJ » SHALL demander un nom (obligatoire), un monstre de départ choisi parmi les packs actifs, un dossier facultatif et une attitude initiale (Indifférent par défaut). « Créer le PNJ » SHALL rester désactivé sans nom ni monstre ; il SHALL créer le PNJ puis ouvrir sa fiche.

#### Scenario: Création
- **WHEN** Camille saisit « Varga la Balafrée », choisit « Chef de bande » en cherchant « chef », saisit le dossier « Guilde du Sel » et choisit Hostile
- **THEN** le PNJ est créé avec ces valeurs, et sa fiche s'ouvre

#### Scenario: Nom manquant
- **WHEN** le nom est vide
- **THEN** « Créer le PNJ » est désactivé

### Requirement: Fiche d'un PNJ en bloc de stats
La fiche d'un PNJ SHALL afficher le profil de son monstre tel qu'imprimé dans le SRD : ligne de type, CA, Initiative, PV, Vitesse en mètres, caractéristiques avec modificateur et JS, compétences, résistances et immunités, équipement, sens, langues, FP avec PX et BM, puis traits et actions par catégorie, avec leur usage et leur texte. Elle SHALL permettre de choisir l'attitude envers le groupe, enregistrée aussitôt, et de dupliquer le PNJ.

#### Scenario: Profil du chef de bande
- **WHEN** Camille ouvre la fiche de Varga
- **THEN** elle lit « Humanoïde de taille M ou P, Neutre », « Variante de « Chef de bande » · SRD 5.2.1 », « +3 (13) », « 52 (8d8 + 16) », « 9 m », « FOR 15 », « JS +4 », « Athlétisme +4, Tromperie +4 », « Perception passive 10 », « 2 (450 PX ; BM +2) », « Réactions » et « Parade »

#### Scenario: Attitude
- **WHEN** Camille choisit Hostile
- **THEN** Varga est Hostile, aussi dans la liste et aux séances suivantes

#### Scenario: Dupliquer
- **WHEN** Camille touche « Dupliquer »
- **THEN** « Varga la Balafrée (copie) » est créée, et sa fiche s'ouvre

#### Scenario: Usages limités
- **WHEN** Camille ouvre un PNJ parti d'un monstre au souffle « (recharge 5–6) »
- **THEN** l'action affiche « (recharge 5–6) » après son nom
