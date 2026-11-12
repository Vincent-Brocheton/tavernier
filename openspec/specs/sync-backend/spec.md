# sync-backend Specification

## Purpose
TBD - created by archiving change t-05a-schema-supabase. Update Purpose after archive.

## Requirements

### Requirement: Schéma des données de jeu
Le backend SHALL porter les tables de jeu du cahier §11.2, avec les mêmes noms et colonnes que la base locale.

#### Scenario: Base vierge
- **WHEN** les migrations sont appliquées à une base vierge
- **THEN** elles réussissent

### Requirement: Droits par table et par rôle
Chaque table SHALL limiter lecture et écriture selon le rôle de l'utilisateur.

#### Scenario: Membre
- **WHEN** un joueur est membre d'une table
- **THEN** il voit la table et ses membres, pas ses invitations

#### Scenario: Inconnu
- **WHEN** un utilisateur n'est pas membre
- **THEN** il ne voit ni la table, ni ses membres, ni ses fiches

#### Scenario: Fiche
- **WHEN** un joueur crée sa fiche
- **THEN** son MJ la lit et la modifie, un autre joueur ne la voit pas

#### Scenario: Fiches visibles
- **WHEN** la table montre les fiches
- **THEN** un autre joueur la lit sans pouvoir la modifier ni la supprimer

#### Scenario: Usurpation
- **WHEN** un utilisateur crée une table ou une fiche au nom d'un autre
- **THEN** l'écriture est refusée

#### Scenario: Historique
- **WHEN** une modification est inscrite à l'historique
- **THEN** elle ne peut plus être corrigée

#### Scenario: Départ
- **WHEN** un joueur quitte une table
- **THEN** il ne la voit plus

### Requirement: Règles de synchronisation
Le service de synchronisation SHALL n'envoyer à un utilisateur que les lignes que les droits de la base lui laissent lire.

#### Scenario: Joueur
- **WHEN** un joueur se connecte
- **THEN** il reçoit son profil, sa fiche et son contenu, ses tables, leurs membres et leurs packs, mais pas les invitations ni la fiche d'un autre joueur

#### Scenario: MJ
- **WHEN** le MJ se connecte
- **THEN** il reçoit en plus les fiches de sa table, leur contenu et les invitations

#### Scenario: Inconnu
- **WHEN** un utilisateur sans table se connecte
- **THEN** il ne reçoit que son profil

#### Scenario: Fiches visibles
- **WHEN** la table montre les fiches complètes
- **THEN** chaque membre reçoit les fiches des autres membres

### Requirement: Envoi des écritures
Les écritures locales SHALL être envoyées au backend avec le jeton de l'utilisateur. Un personnage sans propriétaire SHALL recevoir l'utilisateur connecté, et une écriture refusée définitivement SHALL être écartée sans bloquer les suivantes.

#### Scenario: Personnage créé sans compte
- **WHEN** un personnage créé hors connexion est envoyé
- **THEN** le serveur l'enregistre avec l'utilisateur connecté pour propriétaire

#### Scenario: Écriture refusée
- **WHEN** le serveur refuse une écriture pour des droits insuffisants
- **THEN** les écritures suivantes partent quand même

### Requirement: Fusion sans perte
Des modifications faites hors ligne sur plusieurs appareils SHALL fusionner champ par champ, le dernier écrit gagnant (cahier ENF-03).

#### Scenario: Trois appareils
- **WHEN** trois appareils d'un même compte modifient hors ligne trois points différents d'une fiche, puis se reconnectent
- **THEN** chaque appareil et le serveur ont les trois modifications

### Requirement: Inscription côté serveur
Le serveur SHALL refuser une inscription sans date de naissance ou de moins de 15 ans, SHALL ne pas conserver la date de naissance, et SHALL créer le profil avec le pseudonyme fourni.

#### Scenario: Quinze ans révolus
- **WHEN** un compte est créé avec une date de naissance de plus de 15 ans
- **THEN** son profil existe avec le pseudonyme, et ses métadonnées ne contiennent plus la date de naissance

#### Scenario: Trop jeune
- **WHEN** un compte est créé avec une date de naissance de moins de 15 ans
- **THEN** la création échoue

### Requirement: Sessions du compte
Un utilisateur SHALL lister ses seules sessions, et SHALL révoquer toute autre de ses sessions que celle en cours ; jamais celle d'un autre utilisateur.

#### Scenario: Liste
- **WHEN** un utilisateur liste ses sessions
- **THEN** il ne voit que les siennes, et celle en cours est signalée

#### Scenario: Révocation
- **WHEN** il révoque une autre de ses sessions
- **THEN** elle est supprimée

#### Scenario: Session d'un autre
- **WHEN** il tente de révoquer la session d'un autre utilisateur
- **THEN** rien n'est supprimé

### Requirement: Âge des comptes sans date à l'inscription
Le serveur SHALL enregistrer la vérification d'âge d'un compte créé sans date de naissance (Google) quand il déclare 15 ans révolus, sans garder la date, et SHALL supprimer le compte sinon.

#### Scenario: Quinze ans
- **WHEN** l'utilisateur déclare une date de 15 ans révolus
- **THEN** ses métadonnées portent `age_checked_at`, sans la date

#### Scenario: Trop jeune
- **WHEN** il déclare une date de moins de 15 ans
- **THEN** son compte est supprimé

### Requirement: Mot de passe défini
Le serveur SHALL dire à l'utilisateur si son compte a un mot de passe, sans rien en révéler d'autre.

#### Scenario: Compte Google
- **WHEN** un compte créé par Google demande s'il a un mot de passe
- **THEN** la réponse est non, puis oui une fois qu'il en a défini un

### Requirement: Activité d'une table au serveur
Le serveur SHALL laisser les membres d'une table lire son activité, le MJ y ajouter des entrées, et personne les modifier ou les supprimer. L'activité SHALL être synchronisée vers les membres.

#### Scenario: Joueur
- **WHEN** un joueur ajoute une entrée d'activité
- **THEN** le serveur la refuse

#### Scenario: Synchronisation
- **WHEN** le MJ ajoute une entrée
- **THEN** chaque membre la reçoit

### Requirement: Table archivée en lecture seule
Le serveur SHALL refuser toute écriture sur les fiches d'une table archivée, et toute modification de la table autre que sa restauration par le MJ.

#### Scenario: Fiche d'une table archivée
- **WHEN** le propriétaire modifie sa fiche dans une table archivée
- **THEN** le serveur la refuse

#### Scenario: Restauration
- **WHEN** le MJ restaure la table
- **THEN** elle redevient modifiable

### Requirement: Rejoindre une table
Le serveur SHALL ajouter comme joueur l'utilisateur qui présente le code d'une invitation valide (ni révoquée, ni expirée, table non archivée) et rendre l'identifiant de la table. Il SHALL refuser un code inconnu, expiré ou révoqué avec un motif distinct, et freiner un compte après 10 échecs en une heure.

#### Scenario: Code valide
- **WHEN** un utilisateur présente un code valide
- **THEN** il devient joueur de la table

#### Scenario: Déjà membre
- **WHEN** un membre présente à nouveau le code
- **THEN** rien ne change et la table est rendue

#### Scenario: Code expiré ou révoqué
- **WHEN** l'invitation est expirée ou révoquée
- **THEN** le serveur refuse avec le motif `expired_code`

#### Scenario: Recherche au hasard
- **WHEN** un compte a échoué 10 fois dans l'heure
- **THEN** le serveur refuse avec le motif `too_many_attempts`, même pour un code valide

### Requirement: Retrait d'un joueur
Quand un joueur quitte une table ou en est retiré, le serveur SHALL passer ses fiches de cette table au statut `archived`, sans les supprimer, et refuser ensuite toute écriture sur elles.

#### Scenario: Retrait
- **WHEN** le MJ retire un joueur
- **THEN** la fiche du joueur dans la table est archivée et reste lisible par son propriétaire

#### Scenario: Fiche archivée
- **WHEN** le propriétaire modifie une fiche archivée
- **THEN** le serveur refuse

### Requirement: Emplacements au serveur
Le serveur SHALL laisser les membres lire les emplacements de leur table, le MJ les créer et les supprimer, et le joueur d'un emplacement n'y placer qu'une fiche à lui de la même table. Les emplacements SHALL être synchronisés vers les membres.

#### Scenario: Joueur
- **WHEN** un joueur crée un emplacement
- **THEN** le serveur refuse

#### Scenario: Fiche d'un autre
- **WHEN** un joueur place dans son emplacement la fiche d'un autre
- **THEN** le serveur refuse

### Requirement: Statut d'une fiche de table
Le serveur SHALL n'accepter que ces passages : le propriétaire envoie (`draft` ou `changes_requested` → `submitted`) ou reprend (`submitted` → `draft`) ; le MJ de la table valide ou demande des corrections sur une fiche envoyée. Une fiche SHALL n'être rattachée qu'à une table dont son propriétaire est membre.

#### Scenario: Envoi
- **WHEN** le propriétaire envoie sa fiche
- **THEN** elle passe `submitted`

#### Scenario: Validation par soi-même
- **WHEN** le propriétaire passe sa fiche à `validated`
- **THEN** le serveur refuse

#### Scenario: Table étrangère
- **WHEN** un utilisateur rattache sa fiche à une table dont il n'est pas membre
- **THEN** le serveur refuse

### Requirement: Revue et transfert au serveur
Le serveur SHALL réserver le message d'envoi au propriétaire de la fiche, le commentaire de revue au MJ, et le changement de propriétaire au MJ de la table, vers un membre, sur une fiche non archivée. Au retrait d'un joueur, ses emplacements SHALL être supprimés.

#### Scenario: Commentaire du joueur
- **WHEN** le joueur écrit le commentaire de revue
- **THEN** le serveur refuse

#### Scenario: Transfert vers un inconnu
- **WHEN** le MJ donne la fiche à un utilisateur hors de la table
- **THEN** le serveur refuse

#### Scenario: Retrait
- **WHEN** le MJ retire un joueur
- **THEN** ses emplacements disparaissent, sa fiche reste archivée

### Requirement: Une table à la fois
Le serveur SHALL refuser de changer la table d'une fiche déjà rattachée. Le MJ SHALL pouvoir inscrire une dérogation dans l'historique d'une fiche de sa table, et le propriétaire la lire.

#### Scenario: Seconde table
- **WHEN** le propriétaire rattache à une autre table une fiche déjà rattachée
- **THEN** le serveur refuse

#### Scenario: Dérogation
- **WHEN** le MJ inscrit une dérogation
- **THEN** le propriétaire la lit dans l'historique

### Requirement: Résumés des fiches au serveur
Le serveur SHALL laisser les membres d'une table lire les résumés de ses fiches, et seuls le propriétaire et le MJ les écrire, pour la table de la fiche. Les résumés SHALL être synchronisés vers les membres.

#### Scenario: Autre joueur
- **WHEN** un joueur écrit le résumé de la fiche d'un autre
- **THEN** le serveur refuse

#### Scenario: Lecture
- **WHEN** un membre lit les résumés
- **THEN** il voit ceux de sa table, sans PV chiffrés

### Requirement: Fusion entre les comptes d'une table
Des modifications faites hors ligne par le MJ et deux joueurs d'une même table, sur trois appareils, SHALL toutes arriver au serveur à la reconnexion, et chaque appareil SHALL recevoir celles qu'il a le droit de lire (critère de sortie de M2).

#### Scenario: MJ et deux joueurs
- **WHEN** le MJ change un réglage de la table et chaque joueur modifie sa fiche, hors ligne, puis tous se reconnectent
- **THEN** le serveur a les trois modifications, chaque joueur a le réglage, le MJ a les deux fiches, et aucune écriture n'est écartée

### Requirement: Conflits détectés et tracés
Le serveur SHALL reconnaître un conflit quand une modification de fiche ou d'état de jeu remplace, pour un champ, une valeur différente de celle que l'appareil avait. Le dernier écrit SHALL gagner, sauf sur l'état de jeu quand la valeur en place vient du MJ de la table et l'écriture d'un autre : la valeur du MJ SHALL rester. Chaque conflit SHALL inscrire dans l'historique de la fiche le champ, la valeur gardée et la valeur remplacée, avec leurs auteurs.

#### Scenario: Le MJ prime en combat
- **WHEN** le MJ a réglé les PV d'Aldric à 34 pendant que le joueur, hors ligne, les passait de 29 à 39
- **THEN** les PV restent à 34 et l'historique trace la valeur 39 remplacée

#### Scenario: Dernier écrit gagnant
- **WHEN** deux appareils renomment la même fiche hors ligne
- **THEN** le dernier envoyé gagne, et l'historique trace le nom remplacé

#### Scenario: Pas de conflit
- **WHEN** une modification remplace la valeur que le serveur a
- **THEN** aucune entrée de conflit n'est inscrite
