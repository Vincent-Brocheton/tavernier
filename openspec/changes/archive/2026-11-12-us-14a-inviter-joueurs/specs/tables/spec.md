## ADDED Requirements

### Requirement: Membres d'une table
L'app SHALL montrer à chaque membre la liste des membres de la table, avec leur pseudonyme et leur rôle, le MJ en premier. Le MJ SHALL pouvoir retirer un joueur après confirmation ; sa fiche est archivée, pas supprimée (EF-TAB-06).

#### Scenario: Liste
- **WHEN** un membre ouvre l'onglet « Membres »
- **THEN** il voit chaque membre, son pseudonyme et son rôle

#### Scenario: Retrait
- **WHEN** le MJ retire un joueur et confirme
- **THEN** le joueur n'est plus membre de la table

#### Scenario: Joueur
- **WHEN** un joueur ouvre l'onglet « Membres »
- **THEN** il ne voit ni l'invitation ni l'action de retrait

### Requirement: Invitation
Le MJ SHALL pouvoir créer une invitation valable 7 jours, avec un code de 6 caractères sans caractère ambigu, un lien et un QR code de ce lien. Il SHALL pouvoir copier le lien, le partager et révoquer l'invitation (EF-TAB-05). Créer une invitation SHALL révoquer celle en cours.

#### Scenario: Création
- **WHEN** le MJ crée une invitation
- **THEN** l'app montre le code, le QR du lien et « Expire dans 7 jours »

#### Scenario: Révocation
- **WHEN** le MJ révoque l'invitation
- **THEN** elle n'est plus proposée, et l'app offre d'en créer une autre

#### Scenario: Expiration
- **WHEN** l'invitation a plus de 7 jours
- **THEN** elle n'est plus proposée
