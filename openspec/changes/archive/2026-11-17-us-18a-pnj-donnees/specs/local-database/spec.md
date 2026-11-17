## ADDED Requirements

### Requirement: PNJ stockés
La base locale SHALL garder les PNJ dans la table synchronisée `npc_statblock`. `NpcStore` SHALL :
- créer un PNJ et rendre son identifiant ;
- modifier son nom, son dossier, son bloc de stats, son attitude et ses informations cachées ;
- le dupliquer sous le nom « <nom> (copie) », dans le même dossier ;
- le supprimer ;
- suivre les PNJ d'une table, triés par dossier (sans dossier en dernier) puis par nom.

#### Scenario: Liste par dossier
- **WHEN** Brumeval a Varga (« Guilde du Sel »), Odran (« Relais du Sel ») et le Sergent Varel (sans dossier)
- **THEN** la liste rend Varga, Odran, puis le Sergent Varel

#### Scenario: Attitude par défaut
- **WHEN** le MJ crée un PNJ sans attitude
- **THEN** il est Indifférent

#### Scenario: Duplication
- **WHEN** le MJ duplique Varga
- **THEN** « Varga la Balafrée (copie) » existe dans « Guilde du Sel », avec le même bloc de stats, la même attitude et les mêmes informations cachées

#### Scenario: Informations cachées
- **WHEN** le MJ enregistre deux paliers, DD 10 et DD 15
- **THEN** le PNJ les rend dans cet ordre
