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

### Requirement: Onglet des séances
La page d'une table SHALL avoir un onglet « Séances » pour le MJ et pour les joueurs. Sans séance, il SHALL afficher « Aucune séance » et la part des joueurs dont la fiche est validée. Avec des séances, il SHALL afficher « Prochaine » (séances préparées ou en cours) et « Passées » (closes). Chaque séance SHALL avoir son pavé de date, « Séance n », son titre et un badge d'état avec libellé. Seul le MJ SHALL voir les boutons de création. Un joueur dont le personnage est prévu à la prochaine séance SHALL lire « Personnage attendu : » suivi du nom.

#### Scenario: Table sans séance, vue du MJ
- **WHEN** Camille ouvre l'onglet « Séances » d'une table sans séance, où 2 des 4 emplacements ont une fiche validée
- **THEN** elle lit « Aucune séance », « Préparer la séance 1 », « Jouer tout de suite, sans préparation » et « 2 joueurs sur 4 ont une fiche validée. Les autres pourront rejoindre la séance en cours. »

#### Scenario: Liste des séances
- **WHEN** Brumeval a la séance 12 préparée et la séance 11 close
- **THEN** « Prochaine » montre « Séance 12 », « Le relais du Sel » et « Préparée », et « Passées » montre « Séance 11 » et « Close »

#### Scenario: Vue du joueur
- **WHEN** Hugo ouvre l'onglet, et Aldric est prévu à la séance 12
- **THEN** il lit « Personnage attendu : Aldric Varenne », sans aucun bouton de création

### Requirement: Créer une séance
Le MJ SHALL créer une séance de deux façons :
- « Préparer la séance n » crée une séance préparée, datée du jour, titrée « Séance n », avec tous les personnages de la table prévus, puis ouvre sa préparation ;
- « Jouer tout de suite » crée la même séance, mais déjà en cours.

#### Scenario: Préparer
- **WHEN** Camille touche « Préparer la séance 1 »
- **THEN** la séance 1 est créée, préparée et datée du jour, Aldric et Mira y sont prévus, et sa préparation s'ouvre

#### Scenario: Jouer tout de suite
- **WHEN** Camille touche « Jouer tout de suite, sans préparation »
- **THEN** une séance du jour est créée en cours, et la liste la montre avec « En cours »

### Requirement: Préparer une séance
L'écran de préparation SHALL montrer le titre et la date, modifiables et enregistrés au fil de la saisie, puis les présences prévues : un interrupteur par personnage de la table, avec son joueur, sa classe et son niveau. « Ouvrir la séance » SHALL passer une séance préparée en cours.

#### Scenario: Titre et date
- **WHEN** Camille saisit « Le relais du Sel » et choisit le 30 octobre 2026
- **THEN** la séance garde ce titre et cette date

#### Scenario: Présence retirée
- **WHEN** Camille décoche Kael
- **THEN** Kael n'est plus prévu à la séance

#### Scenario: Ouvrir la séance
- **WHEN** Camille touche « Ouvrir la séance »
- **THEN** la séance passe « En cours »

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

### Requirement: Nouveau PNJ en fiche complète
« Nouveau PNJ » SHALL proposer deux formes : « Bloc de stats » et « Fiche complète ». En fiche complète, « Créer le PNJ » SHALL ouvrir l'assistant de création des personnages, avec le nom prérempli et la méthode de caractéristiques libre. L'enregistrement SHALL créer une fiche de PNJ rattachée à la table, puis le PNJ lié, avec son dossier et son attitude.

#### Scenario: Maître Odran
- **WHEN** Camille choisit « Fiche complète », saisit « Maître Odran », le dossier « Relais du Sel » et Amical, puis termine l'assistant en tirant les caractéristiques aux dés
- **THEN** Odran est une fiche de PNJ de Brumeval, et le PNJ « Maître Odran » est rangé dans « Relais du Sel », Amical, lié à cette fiche

### Requirement: Fiche d'un PNJ en fiche complète
La fiche d'un PNJ lié à une fiche complète SHALL montrer « Fiche complète », « Ouvrir la fiche », l'attitude et les informations cachées, sans « Dupliquer ». La liste des PNJ SHALL afficher « Fiche complète · niveau n ».

#### Scenario: Ouvrir la fiche
- **WHEN** Camille touche « Ouvrir la fiche » sur Maître Odran
- **THEN** la fiche de personnage d'Odran s'ouvre

#### Scenario: Liste
- **WHEN** Camille ouvre l'onglet « PNJ »
- **THEN** Maître Odran affiche « Fiche complète · niveau 1 »

### Requirement: Onglet des rencontres
La page d'une table SHALL avoir, pour son MJ seul, un onglet « Rencontres ». Les rencontres y SHALL être rangées dans cet ordre : séances à venir, « Sans séance » (en réserve), puis séances closes. Chaque rencontre SHALL montrer :
- son titre ;
- ses adversaires avec leur nombre ;
- le total de leurs PX ;
- sa difficulté selon les PJ présents ;
- son état (libellé dans un badge).

Les PJ présents SHALL être ceux prévus à sa séance, ou tous les personnages de la table pour une rencontre en réserve. Des filtres « Toutes », « À jouer » et « Terminées », et une recherche par titre ou adversaire, SHALL restreindre la liste.

#### Scenario: Liste du MJ
- **WHEN** la séance 12 de Brumeval, avec Aldric et Mira de niveau 5 prévus, contient « Le relais du Sel » (2 vétérans, prête), et « Embuscade » (1 bandit) est en réserve
- **THEN** Camille lit « SÉANCE 12 », « Le relais du Sel », « Vétéran ×2 · 1 400 PX · Faible » et « Prête », puis « SANS SÉANCE » et « Embuscade »

#### Scenario: Filtre et recherche
- **WHEN** Camille touche « Terminées », puis « Toutes » et cherche « veteran »
- **THEN** elle ne voit aucune rencontre, puis seulement « Le relais du Sel »

#### Scenario: Joueur
- **WHEN** Hugo ouvre la page de Brumeval
- **THEN** il n'a pas d'onglet « Rencontres »

### Requirement: Créer, dupliquer et ranger une rencontre
« Nouvelle rencontre » SHALL demander un titre (obligatoire) et une séance (ou « Sans séance »), créer la rencontre en brouillon et ouvrir sa page. « Dupliquer » SHALL créer une copie en brouillon. « Ranger dans une séance » SHALL déplacer une rencontre en réserve dans la séance choisie.

#### Scenario: Nouvelle rencontre
- **WHEN** Camille crée « Les chiens de Varga » dans la séance 12
- **THEN** la rencontre est en brouillon dans la séance 12, et sa page s'ouvre

#### Scenario: Dupliquer
- **WHEN** Camille duplique « Le relais du Sel »
- **THEN** « Le relais du Sel (copie) » apparaît, en brouillon, dans la séance 12

#### Scenario: Ranger
- **WHEN** Camille range « Embuscade » dans la séance 12
- **THEN** elle passe sous « SÉANCE 12 »

### Requirement: Budget de la prochaine séance
Sur grand écran, l'onglet SHALL afficher le budget de difficulté de la prochaine séance (Faible, Modérée, Élevée), avec le nombre de personnages présents et leur niveau.

#### Scenario: Budget
- **WHEN** la prochaine séance prévoit Aldric et Mira, de niveau 5
- **THEN** le panneau affiche Faible 1 000 PX, Modérée 1 500 PX, Élevée 2 200 PX et « 2 personnages de niveau 5, selon les présences prévues. »

### Requirement: Préparer une rencontre
La page d'une rencontre SHALL montrer sa jauge de difficulté, les personnages présents, ses adversaires et le mode de PV des monstres. Chaque groupe d'adversaires SHALL afficher son FP, sa numérotation (« numérotés Vétéran 1 à 2 » ou « unique »), son initiative commune, sa quantité modifiable et ses PX. La jauge SHALL se mettre à jour à chaque changement.

#### Scenario: Le relais du Sel ([C1], [D1])
- **WHEN** Camille ouvre « Le relais du Sel », avec 2 vétérans, un ogre et 4 bandits, et Aldric et Mira, de niveau 5, présents
- **THEN** elle lit « 1 950 PX », « Modérée », « Vétéran », « FP 3 · numérotés Vétéran 1 à 2 », « 1 400 PX », « Ogre », « FP 2 · unique », « Bandit » et « numérotés Bandit 1 à 4 »

#### Scenario: Quantité
- **WHEN** Camille touche « + » sur l'ogre, puis « − » deux fois
- **THEN** l'ogre passe à 2 (« numérotés Ogre 1 à 2 »), puis le groupe disparaît, et la jauge suit

#### Scenario: Mode de PV et état
- **WHEN** Camille choisit « Jet au lancement » et active « Prête à jouer »
- **THEN** la rencontre est en jet de PV et prête

### Requirement: Ajouter des adversaires
La préparation SHALL proposer les monstres des packs actifs et les PNJ de la table, avec une recherche sans accents ni casse et un filtre de FP. Chaque monstre SHALL montrer son type, son FP, ses PX et sa source. Ajouter un adversaire déjà présent SHALL augmenter sa quantité.

#### Scenario: Monstre
- **WHEN** Camille cherche « loup sanguinaire » et touche « + »
- **THEN** le loup sanguinaire rejoint les adversaires, et les PX augmentent de 200

#### Scenario: PNJ
- **WHEN** Camille passe sur « PNJ » et ajoute Varga
- **THEN** Varga rejoint les adversaires avec les PX de son chef de bande

#### Scenario: Filtre de FP
- **WHEN** Camille limite le FP de 1 à 2
- **THEN** l'ogre (FP 2) est proposé, mais ni le bandit (FP 1/8) ni le vétéran (FP 3)

### Requirement: Lancer une rencontre
« Lancer la rencontre » SHALL passer la rencontre « En cours » et créer ses combattants :
- les PJ présents, avec le bonus, l'Avantage d'initiative, la CA et les PV de leur fiche ;
- les monstres et PNJ, numérotés, avec l'initiative commune de leur groupe, la CA, les PV (moyens ou tirés selon la rencontre) et leurs compteurs (actions et résistances légendaires, recharges).

Les jets des monstres et des PNJ SHALL être lancés aussitôt, puis l'écran d'initiative SHALL s'ouvrir.

#### Scenario: Le relais du Sel
- **WHEN** Camille lance la rencontre avec Aldric et Mira présents, 2 vétérans à initiative commune et un ogre
- **THEN** la rencontre est « En cours », avec Aldric, Mira, « Vétéran 1 », « Vétéran 2 » et « Ogre », et les vétérans et l'ogre ont déjà leur jet

#### Scenario: PV tirés
- **WHEN** la rencontre est en « Jet au lancement »
- **THEN** les PV de chaque monstre sont tirés d'après ses dés de vie

### Requirement: Écran d'initiative
L'écran d'initiative SHALL montrer, par unité, le combattant, son bonus et son mode, son jet, son total et l'origine du jet. Il SHALL proposer :
- la saisie du dé gardé d'un PJ ;
- la surprise d'une unité (Désavantage, et nouveau jet pour un monstre) ;
- l'ordre du tour avec ses égalités et qui les tranche ;
- le réordonnancement de cet ordre.

« Commencer le round 1 » SHALL attendre que tous les jets soient saisis.

#### Scenario: Saisie d'un PJ
- **WHEN** Camille saisit 15 pour Aldric (+4)
- **THEN** son total est 19, et il prend sa place dans l'ordre du tour

#### Scenario: Égalité
- **WHEN** les vétérans et l'ogre font 15
- **THEN** l'ordre affiche « Égalité · le MJ décide » sur les deux

#### Scenario: Surprise
- **WHEN** Camille marque les vétérans surpris
- **THEN** ils affichent « Désavantage », et leur jet est relancé

#### Scenario: Commencer
- **WHEN** tous les jets sont saisis et Camille touche « Commencer le round 1 »
- **THEN** le round 1 commence sur la première unité de l'ordre

### Requirement: Écran de combat
À partir du round 1, l'écran SHALL afficher :
- le round et le nombre de combattants ;
- les combattants dans l'ordre d'initiative, avec leur initiative, leur nom, leur sorte (« PJ · Guerrier 5 » ou « Humanoïde · FP 2 »), leur CA et leurs PV ;
- l'unité active, mise en évidence avec « En cours » ;
- un en-tête par groupe à initiative commune.

« Tour suivant » SHALL rester visible en permanence, et « Annuler » SHALL retirer le dernier événement effectif.

#### Scenario: Tour suivant
- **WHEN** Camille touche « Tour suivant » sur le tour de Thalia
- **THEN** « En cours » passe à l'unité suivante, et après la dernière unité le round augmente

#### Scenario: Annuler
- **WHEN** Camille touche « Annuler » après un « Tour suivant »
- **THEN** le tour revient à l'unité précédente

### Requirement: Rappel de recharge
Au début du tour d'une unité, chaque capacité à recharge utilisée de ses membres SHALL être rappelée avec sa plage. « Lancer 1d6 » SHALL la rendre sur un résultat de la plage et dire le résultat ; « Rechargé » SHALL la rendre sans jet.

#### Scenario: Souffle du dragon
- **WHEN** le souffle (recharge 5–6) du dragon a été utilisé et que son tour commence
- **THEN** l'écran affiche « lancez 1d6 pour Souffle d'acide (recharge 5–6) », et « Rechargé » le rend disponible

### Requirement: Détail et compteurs d'un combattant
Le détail d'un combattant SHALL montrer sa CA, ses PV, le profil d'un monstre et ses compteurs (actions légendaires, résistance légendaire, réaction, recharges), avec utilisé et maximum. Toucher un compteur SHALL en utiliser une unité ou la rendre. Le détail SHALL permettre de retirer le combattant du combat.

#### Scenario: Action légendaire
- **WHEN** Camille touche un pion des actions légendaires du dragon
- **THEN** il en reste 2 sur 3

#### Scenario: Retirer
- **WHEN** Camille retire l'ogre du combat
- **THEN** l'ogre disparaît de l'ordre d'initiative

### Requirement: Ajouter un combattant en cours de combat
Le MJ SHALL ajouter un monstre ou un PNJ en cours de combat. Il SHALL être numéroté après ses semblables, recevoir aussitôt son jet d'initiative et entrer à sa place dans l'ordre.

#### Scenario: Renfort
- **WHEN** Camille ajoute un loup sanguinaire alors que « Loup sanguinaire 1 » à « 3 » combattent
- **THEN** « Loup sanguinaire 4 » entre dans l'ordre avec son initiative

### Requirement: Terminer la rencontre
« Terminer la rencontre » SHALL passer la rencontre « Terminée ».

#### Scenario: Fin
- **WHEN** Camille termine « Le relais du Sel »
- **THEN** la rencontre est « Terminée »

### Requirement: Cibler des combattants
Sur l'écran de combat, toucher une carte SHALL en faire la seule cible, et un appui long SHALL ajouter ou retirer une cible. Le pied SHALL rappeler les cibles et proposer « Dégâts », « Soins » et « PV temp. ». Le détail d'un combattant SHALL s'ouvrir par son icône.

#### Scenario: Plusieurs cibles
- **WHEN** Camille touche « Loup 1 », puis appuie longuement sur « Loup 2 »
- **THEN** le pied affiche « Cibles : Loup 1, Loup 2 »

### Requirement: Pavé de dégâts et soins
Le pavé SHALL montrer les cibles, le montant saisi et son type, l'aperçu des PV de chaque cible, « Coup critique », les touches 0 à 9, « + », « − », « Vulnérabilité ×2 », « Résistance ½ », « PV temp. » et « Soins ». Il SHALL appliquer en une touche des dégâts, un soin ou des PV temporaires à toutes les cibles. Les dégâts SHALL suivre les règles du moteur (défenses, PV temporaires, 0 PV).

#### Scenario: Mira ([1b])
- **WHEN** Camille saisit 12, choisit « Tranchants » et voit l'aperçu de Mira
- **THEN** l'aperçu affiche « 22 → 10 / 38 PV », et « Appliquer 12 dégâts tranchants » porte Mira à 10 PV

#### Scenario: Addition de dés
- **WHEN** Camille saisit 7, « + », 5
- **THEN** le montant vaut 12

#### Scenario: Soins
- **WHEN** Camille passe en « Soins » et applique 8 sur Mira à 10 PV
- **THEN** Mira est à 18 PV

#### Scenario: Deux cibles, Résistance ½
- **WHEN** Camille applique 10 dégâts de feu avec « Résistance ½ » à deux loups
- **THEN** chacun perd 5 PV

### Requirement: État des PV sur les cartes
Chaque carte SHALL montrer une barre de PV colorée selon la part restante, les PV temporaires, et l'état à 0 PV :
- un PJ affiche « Inconscient » avec ses jets contre la mort, ou « Mort » ;
- un monstre est estompé, avec « Hors de combat ».

La feuille d'un PJ Inconscient SHALL permettre de saisir ses jets contre la mort.

#### Scenario: Mira tombe
- **WHEN** Mira tombe à 0 PV
- **THEN** sa carte affiche « Inconscient » et ses jets contre la mort, et sa feuille propose « Réussite » et « Échec »

#### Scenario: Loup hors de combat
- **WHEN** un loup tombe à 0 PV
- **THEN** sa carte affiche « Hors de combat »

### Requirement: Ajouter un état
L'écran de combat SHALL proposer « État » pour les cibles choisies. La feuille « Ajouter un état » ([C5]) SHALL offrir :
- les 15 états du SRD, avec icône et libellé, et « Autre effet » à libellé libre ;
- le résumé de la règle de l'état choisi ;
- une durée : nombre de rounds, jusqu'au début ou à la fin du tour d'un combattant, jusqu'à réussite d'une sauvegarde (DD et caractéristique), ou indéfinie.

#### Scenario: Entravé jusqu'à une sauvegarde ([C5])
- **WHEN** le MJ cible le Loup sanguinaire 2, choisit Entravé, « Jusqu'à réussite d'une sauvegarde », DD 13, Force, puis « Ajouter Entravé »
- **THEN** la carte du loup montre « Entravé · JS FOR DD 13 »

#### Scenario: Deux cibles
- **WHEN** le MJ cible Aldric et l'ogre, choisit Effrayé pour 2 rounds et l'ajoute
- **THEN** les deux cartes montrent « Effrayé · 2 rd »

### Requirement: Cas particuliers de l'ajout d'un état
La feuille « Ajouter un état » SHALL remplacer la durée de l'Épuisement par un nombre de niveaux, offrir des dégâts récurrents facultatifs à « Autre effet », et griser un état auquel toutes les cibles sont immunisées.

#### Scenario: Épuisement
- **WHEN** le MJ ajoute 2 niveaux d'Épuisement à Aldric
- **THEN** sa carte montre « Épuisement 2 »

#### Scenario: Autre effet avec dégâts récurrents
- **WHEN** le MJ ajoute « En feu » à l'ogre, avec 1d4 dégâts de feu au début de son tour
- **THEN** la carte de l'ogre montre « En feu »

#### Scenario: Immunité
- **WHEN** le MJ cible un squelette
- **THEN** la tuile Empoisonné est grisée

### Requirement: Fiche d'état
Toucher une puce d'état SHALL ouvrir sa fiche ([K4]), qui montre :
- le texte de la règle du SRD ;
- le porteur et la durée en clair ;
- « Retirer l'état » et, pour l'Épuisement, « Retirer un niveau ».

#### Scenario: Retirer Entravé ([K4])
- **WHEN** le MJ touche la puce Entravé du loup
- **THEN** la fiche montre la règle « Vitesse 0 » et la ligne « Loup sanguinaire 2 · jusqu'à réussite d'un JS de Force DD 13, refait à la fin de chacun de ses tours »
- **AND WHEN** il touche « Retirer l'état »
- **THEN** la puce disparaît de la carte

### Requirement: Rappels de fin de tour
« Tour suivant » SHALL ouvrir le dialogue de fin de tour ([C6]) quand l'unité active a des rappels de fin de tour. Le dialogue montre :
- les sauvegardes à refaire, avec « Lancer », « Échec » et « Réussite » ;
- les états qui expirent ;
- les dégâts récurrents.

« Plus tard » ferme sans passer le tour, et « Tour suivant : <unité> » le passe. Sans rappel, le tour passe directement.

#### Scenario: Sauvegarde réussie ([C6])
- **WHEN** l'ogre, Entravé jusqu'à réussite d'un JS de Force DD 13, finit son tour, et le MJ touche « Réussite »
- **THEN** l'état Entravé est retiré, et le dialogue affiche la réussite
- **AND WHEN** il touche « Tour suivant : Dragon noir adulte »
- **THEN** c'est le tour du dragon

#### Scenario: Plus tard
- **WHEN** le dialogue de fin de tour est ouvert et le MJ touche « Plus tard »
- **THEN** le tour ne passe pas

#### Scenario: Pas de rappel
- **WHEN** le tour du dragon finit, sans rappel
- **THEN** le tour passe à Aldric sans dialogue

### Requirement: Bandeau de début de tour
Au début d'un tour, l'écran de combat SHALL afficher le bandeau « Début du tour · <unité> » ([1a]) s'il y a quelque chose à rappeler. Il liste :
- les états qui viennent d'expirer ;
- ceux qui expirent à la fin de ce tour ;
- les dégâts récurrents, avec « Lancer et appliquer ».

« OK » le masque. Sur les cartes, un état qui expire à la fin du tour en cours affiche « expire ».

#### Scenario: Empoisonné expire à la fin de ce tour ([1a])
- **WHEN** le tour d'Aldric commence, Empoisonné jusqu'à la fin de son tour
- **THEN** le bandeau dit « Empoisonné expire à la fin de ce tour », et la puce affiche « Empoisonné · expire »

#### Scenario: Dégâts récurrents
- **WHEN** le tour de l'ogre, « En feu » (1d4 de feu au début de son tour), commence, et le MJ touche « Lancer et appliquer »
- **THEN** l'ogre perd entre 1 et 4 PV

### Requirement: Repos de groupe
Sur la page d'une séance en cours, le MJ SHALL pouvoir déclencher un repos court ou long pour les PJ présents ([J9]). Tant que le repos est ouvert, chaque PJ visé SHALL montrer « Terminé » avec son récapitulatif (dés de vie dépensés, PV avant et après), ou « En attente » avec « Faire pour… », qui ouvre l'écran de repos sur sa fiche ; « Clore le repos » SHALL le clore.

La fiche d'un PJ attendu SHALL porter, pour son propriétaire ou le MJ, le bandeau « Camille lance un repos court pour le groupe » ; « Faire le repos » SHALL ouvrir l'écran de repos habituel avec l'origine en tête, et « Terminer » SHALL signaler la fin avec son récapitulatif ([J10]). Le repos individuel reste possible hors séance.

#### Scenario: [J9]
- **WHEN** Camille déclenche un repos court à la séance en cours où Aldric et Mira sont présents, puis Hugo termine pour Aldric après 2 dés de vie
- **THEN** Aldric est « Terminé » avec « 2 dés de vie dépensés · PV 34 → 49 », Mira « En attente » avec « Faire pour Mira Solen », et « Clore le repos » rend le choix du repos

#### Scenario: Séance prévue
- **WHEN** la séance n'est pas encore ouverte
- **THEN** la page ne propose pas de repos de groupe

#### Scenario: [J10]
- **WHEN** un repos court attend Aldric, à 4 PV sur 12, et Hugo dépense un d10 de 6
- **THEN** l'écran porte « Aldric Varenne · demandé par … », la fin signalée porte 1 dé, 4 → 12 PV, et le bandeau disparaît

### Requirement: Liste des notes
L'onglet Notes de la table (MJ, [N3]) et celui de la fiche (joueur, [N4], EF-NOT-05) SHALL montrer les notes de l'utilisateur et celles partagées avec la table. Elles sont groupées par rattachement, avec des filtres comptés. Chaque carte porte un extrait, son rattachement, « Partagée avec la table », ou « Partagée par … · lecture seule » pour celle d'un autre, et « Deux versions à fusionner » en cas de conflit.

#### Scenario: [N3]
- **WHEN** Camille ouvre les notes de Brumeval
- **THEN** elle voit ses deux notes et celle partagée par Hugo, pas la note privée de Hugo, et le filtre PNJ ne garde que « Dette envers Brug »

#### Scenario: Vue du joueur
- **WHEN** Hugo ouvre les notes
- **THEN** il voit ses notes et « Calendrier et factions », partagée par Camille, pas sa note privée de séance

### Requirement: Recherche hors-ligne
La recherche SHALL porter sur le titre et le texte des notes de l'appareil, sans tenir compte des accents ni de la casse (EF-NOT-03, [N6]).

#### Scenario: Accents et casse
- **WHEN** Camille cherche « GUILDÉ »
- **THEN** « Calendrier et factions » est le seul résultat

### Requirement: Éditeur de note
L'éditeur ([N5]) SHALL proposer le rattachement (table, séance, PNJ, rencontre), le titre, le texte avec gras, liste et lien vers un PNJ ou une rencontre, et le partage avec la table. Une note neuve SHALL être privée et rattachée à la séance en cours s'il y en a une. La note d'un autre SHALL s'ouvrir en lecture seule, et ses liens SHALL mener au PNJ ou à la rencontre pour le MJ. Une note en conflit SHALL montrer l'autre version, avec « Ajouter à mon texte » et « Écarter l'autre version » (EF-NOT-06).

#### Scenario: Nouvelle note
- **WHEN** Camille écrit « Ce que le loup portait », insère un lien vers Varga, partage et enregistre
- **THEN** la note est partagée, rattachée à la séance en cours, et son texte porte `[Varga la Balafrée](npc:<id>)`

#### Scenario: Lecture seule
- **WHEN** Camille ouvre la note de Hugo
- **THEN** elle la lit sans champ ni « Enregistrer »

#### Scenario: Fusion
- **WHEN** Camille ajoute l'autre version à son texte
- **THEN** la note porte les deux textes, sans conflit
