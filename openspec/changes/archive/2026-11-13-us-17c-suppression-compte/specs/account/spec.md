## ADDED Requirements

### Requirement: Supprimer le compte
Le profil d'un compte connecté SHALL proposer « Supprimer mon compte », qui ouvre la page [T15] (EF-CPT-04). La page SHALL proposer l'export des données et SHALL dire ce qui va se passer. « Supprimer définitivement » SHALL rester inactif tant que « SUPPRIMER » n'est pas tapé. Une fois le compte supprimé, l'appareil SHALL effacer les données synchronisées et fermer la session. Sans réseau, rien ne SHALL être supprimé, et la page SHALL le dire.

#### Scenario: Confirmation tapée
- **WHEN** l'utilisateur tape « SUPPR »
- **THEN** « Supprimer définitivement » reste inactif ; il s'active à « SUPPRIMER »

#### Scenario: Compte supprimé
- **WHEN** l'utilisateur confirme et que le serveur supprime le compte
- **THEN** les données synchronisées de l'appareil sont effacées, la session est fermée et l'app revient à l'accueil

#### Scenario: Sans réseau
- **WHEN** le serveur ne répond pas
- **THEN** le compte et la session restent, et un message le dit

#### Scenario: Sans compte
- **WHEN** personne n'est connecté
- **THEN** le profil ne propose pas de supprimer un compte
