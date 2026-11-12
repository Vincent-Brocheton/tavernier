# tables Specification

## Purpose
TBD - created by archiving change us-13a-creer-table. Update Purpose after archive.

## Requirements

### Requirement: Création d'une table
Un MJ connecté SHALL créer une table avec un nom, une description, un niveau de départ de 1 à 20, une méthode de caractéristiques, une règle de repos long, un mode de PV à la montée de niveau et une progression en PX ou en jalons (EF-TAB-01 à 03, EF-TAB-10). Le pack SRD SHALL y être actif (EF-TAB-04).

#### Scenario: Création
- **WHEN** le MJ remplit le nom et crée la table
- **THEN** la table existe avec ses réglages, il en est le MJ et membre, et le pack SRD y est actif

#### Scenario: Nom obligatoire
- **WHEN** le nom est vide
- **THEN** « Créer la table » est désactivé

#### Scenario: Hors ligne
- **WHEN** le MJ crée une table sans réseau
- **THEN** elle apparaît dans sa liste et part au serveur à la reconnexion

### Requirement: Liste des tables
L'onglet Tables SHALL lister, à un utilisateur connecté, les tables dont il est MJ ou membre, et proposer « Nouvelle table ».

#### Scenario: Après création
- **WHEN** le MJ revient à l'onglet Tables
- **THEN** sa nouvelle table y figure avec le rôle « MJ »

### Requirement: Configuration d'une table
Le MJ SHALL modifier la méthode de caractéristiques, le niveau de départ, le repos long, les PV à la montée de niveau, la progression et la visibilité des fiches complètes. Avant l'enregistrement, l'écran SHALL lister les modifications ; un changement de méthode SHALL rappeler qu'il ne touche pas les fiches existantes (EF-TAB-11).

#### Scenario: Changement de méthode
- **WHEN** le MJ choisit une autre méthode de caractéristiques
- **THEN** le bandeau « Ce changement ne touche pas les fiches existantes » s'affiche, et le panneau liste « Méthode : ancienne → nouvelle »

#### Scenario: Enregistrement
- **WHEN** le MJ enregistre
- **THEN** la table prend la nouvelle configuration, et chaque changement est daté dans l'activité

#### Scenario: Annulation
- **WHEN** le MJ annule
- **THEN** le formulaire revient à la configuration enregistrée

### Requirement: Activité de la table
Chaque changement de configuration et chaque archivage SHALL être daté, avec son auteur, dans l'activité de la table, visible des membres.

#### Scenario: Vue d'ensemble
- **WHEN** un membre ouvre la vue d'ensemble
- **THEN** il voit les derniers changements, datés

### Requirement: Archivage
Le MJ SHALL archiver la table, qui passe en lecture seule pour tous, et SHALL pouvoir la restaurer (EF-TAB-07).

#### Scenario: Archivée
- **WHEN** la table est archivée
- **THEN** la configuration est verrouillée, et seul « Restaurer » reste disponible

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

### Requirement: Rejoindre une table
L'utilisateur SHALL pouvoir rejoindre une table par le lien d'une invitation ou en saisissant son code de 6 caractères. Rejoindre exige le réseau et un compte : sinon, la demande SHALL être gardée sur l'appareil et partir d'elle-même au retour du réseau ou à la connexion (EF-TAB-08). Un refus du serveur SHALL être expliqué selon son motif.

#### Scenario: Lien
- **WHEN** l'utilisateur connecté, en ligne, ouvre le lien d'une invitation valide
- **THEN** il devient joueur de la table et la page de la table s'ouvre

#### Scenario: Hors ligne
- **WHEN** l'utilisateur saisit un code sans réseau
- **THEN** l'app affiche « En attente du réseau… », garde le code, et la demande part au retour du réseau

#### Scenario: Sans compte
- **WHEN** l'utilisateur ouvre le lien sans être connecté
- **THEN** l'app garde le code et propose de se connecter ; la demande part à la connexion

#### Scenario: Code refusé
- **WHEN** le serveur refuse le code (inconnu, expiré, table archivée, trop d'essais)
- **THEN** l'app affiche le motif et oublie le code

### Requirement: Emplacements de PJ
Le MJ SHALL pouvoir attribuer un ou plusieurs emplacements de PJ à un membre de la table, et retirer un emplacement vide. L'onglet Membres SHALL montrer chaque emplacement avec le nom et le statut de sa fiche.

#### Scenario: Attribution
- **WHEN** le MJ attribue un emplacement à Hugo
- **THEN** l'emplacement apparaît sous Hugo, « emplacement libre »

#### Scenario: Fiche en cours
- **WHEN** Hugo a créé Aldric dans son emplacement
- **THEN** la ligne affiche « Aldric Varenne (en création) »

### Requirement: Mon personnage
Le joueur SHALL voir ses emplacements dans la vue d'ensemble de la table : « Créer ma fiche » pour un emplacement vide, sinon le nom et le statut de la fiche. Il SHALL pouvoir envoyer au MJ une fiche en création ou à corriger, une fois au niveau de départ de la table, et reprendre une fiche envoyée.

#### Scenario: Envoi
- **WHEN** la fiche est au niveau de départ et le joueur appuie sur « Envoyer au MJ »
- **THEN** la fiche passe « à valider »

#### Scenario: Niveau de départ non atteint
- **WHEN** la table démarre au niveau 3 et la fiche est au niveau 1
- **THEN** « Envoyer au MJ » est inactif, avec le rappel du niveau à atteindre

### Requirement: Validation d'une fiche par le MJ
Le MJ SHALL voir chaque fiche envoyée dans un panneau « Fiche à valider », avec ses contrôles (méthode, niveau de départ, intégrité) et le message du joueur. Il SHALL pouvoir la valider, ou demander des corrections avec un commentaire obligatoire. Le joueur SHALL voir ce commentaire sur sa fiche à corriger.

#### Scenario: Validation
- **WHEN** le MJ valide une fiche envoyée
- **THEN** elle passe « validée » et quitte le panneau

#### Scenario: Corrections sans commentaire
- **WHEN** le commentaire est vide
- **THEN** « Demander des corrections » est inactif

#### Scenario: Commentaire lu par le joueur
- **WHEN** le MJ demande des corrections avec un commentaire
- **THEN** le joueur lit ce commentaire dans « Mon personnage »

### Requirement: Transfert d'un PJ
Le MJ SHALL pouvoir transférer un emplacement rempli, et sa fiche, à un autre membre de la table.

#### Scenario: Transfert
- **WHEN** le MJ transfère l'emplacement d'Aldric de Hugo à Inès
- **THEN** l'emplacement apparaît sous Inès, et la fiche est à elle

### Requirement: Rattachement d'un personnage libre
Le joueur SHALL pouvoir rattacher, depuis un emplacement vide, un de ses personnages sans table. Le personnage SHALL alors être rattaché à la table, remplir l'emplacement et être envoyé au MJ pour revalidation.

#### Scenario: Rattachement
- **WHEN** Léo rattache Kael à son emplacement
- **THEN** Kael est dans la table, « à valider »

#### Scenario: Déjà rattaché
- **WHEN** un personnage est déjà dans une table
- **THEN** il n'est pas proposé au rattachement

### Requirement: Écarts et dérogations
Le panneau de revue SHALL proposer, pour chaque contrôle en échec, une dérogation ou une correction. Les dérogations SHALL être inscrites dans l'historique de la fiche, sans notification. Avec au moins une correction, la fiche SHALL repartir au joueur avec le message du MJ ; sans correction, elle SHALL être validée.

#### Scenario: Dérogations seules
- **WHEN** le MJ accepte en dérogation un niveau 3 pour une table au niveau 1
- **THEN** la fiche est validée et l'historique porte « Dérogation : niveau 3 accepté »

#### Scenario: Une correction
- **WHEN** un écart est en correction
- **THEN** le bouton est « Demander des corrections (1) », inactif sans message

### Requirement: Résumé du groupe
La vue d'ensemble d'une table SHALL montrer les autres PJ : nom, espèce, classes et niveaux, état de santé qualitatif avec icône et libellé, sans PV chiffrés (EF-TAB-09). Quand le MJ a ouvert les fiches complètes, toucher un PJ SHALL ouvrir sa fiche en lecture seule.

#### Scenario: Blessé
- **WHEN** Thalia a 20 PV sur 33
- **THEN** le groupe affiche Thalia « Blessé », sans chiffres

#### Scenario: Fiches fermées
- **WHEN** le MJ n'a pas ouvert les fiches complètes
- **THEN** toucher un PJ du groupe n'ouvre rien
