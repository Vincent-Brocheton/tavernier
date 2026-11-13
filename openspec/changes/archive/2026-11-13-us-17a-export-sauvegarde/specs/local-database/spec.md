## ADDED Requirements

### Requirement: Export des données de l'utilisateur
La base SHALL produire un export JSON de toutes les données de l'utilisateur qu'elle contient : profil, tables et leurs membres, emplacements, personnages avec tout leur détail et leur historique, PNJ, séances, rencontres et notes (ENF-10, ENF-12). L'export SHALL porter un format et une version, et la liste des packs de contenu installés sans leur contenu. Le contenu de règles SHALL en être exclu.

#### Scenario: Personnage exporté
- **WHEN** l'utilisateur a enregistré Aldric et exporte ses données
- **THEN** l'export contient la ligne d'Aldric dans `character`, ses niveaux de classe et ses objets, avec les valeurs enregistrées

#### Scenario: Contenu de règles exclu
- **WHEN** le pack SRD est installé
- **THEN** l'export cite le pack SRD et sa version, mais ne contient aucun sort, aucune classe ni aucun monstre
