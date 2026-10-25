# Cahier des charges — Gestion de personnage compatible 5e

Oct 24, 2026 · @Vincent

## 1. Introduction

**Gestion de personnage compatible 5e** est une application gratuite, multiplateforme et offline-first. Elle permet aux MJ de gérer leurs tables, rencontres et PNJ, et aux joueurs de créer et faire évoluer leurs fiches selon les règles 2024 (SRD 5.2.1, version française officielle).

### 1.1 Objectifs

- **MJ** : préparer et mener une séance complète sans connexion internet, avec un suivi de combat rapide et fiable.
- **Joueurs** : créer et faire évoluer leur fiche, avec validation automatique des règles 2024 (Historique, don d'origine, caractéristiques, bottes d'armes, sorts).
- **Communauté** : créer du contenu homebrew de tout type et le partager entre MJ et entre tables.

### 1.2 Destinataires de ce document

| Partie | Destinataire | Usage |
| --- | --- | --- |
| §1 à §8 | Tous | Vision, périmètre, exigences fonctionnelles et non fonctionnelles |
| §9 | Claude Design | Direction artistique, parcours, inventaire d'écrans, composants |
| §10 à §12 | Claude Code | Architecture, modèle de données, qualité |
| §13 | Trello | Épopées et user stories à reporter en cartes |
| §14 | Tous | Risques et décisions encore ouvertes |

### 1.3 Contraintes légales

- **Contenu de règles embarqué** : SRD 5.2.1 uniquement, dans sa version française officielle (« Document de Référence du Système 5.2.1 »), sous licence CC-BY-4.0. La déclaration d'attribution exigée par la licence est reproduite mot pour mot dans l'écran « À propos », la description des stores et le manifeste du pack SRD : « Cette œuvre inclut du matériel issu du System Reference Document 5.2.1 (« SRD 5.2.1 ») de Wizards of the Coast LLC, disponible à l'adresse https://www.dndbeyond.com/srd. Le SRD 5.2.1 est régi par la Licence Creative Commons Attribution 4.0 International, disponible à l'adresse https://creativecommons.org/licenses/by/4.0/legalcode. » Aucune autre mention de Wizards of the Coast n'est autorisée.
- **Aucun contenu du Player's Handbook 2024 hors SRD** n'est embarqué ni pré-rempli.
- **Marques** : ni « D&D », ni « Dungeons & Dragons », ni logo ou élément visuel de la marque (esperluette-dragon) dans le nom, l'icône ou l'interface. Seules les mentions « compatible 5E » ou « compatible avec la cinquième édition » sont autorisées, comme le prévoit le SRD.
- **Homebrew partagé** : chaque pack déclare une licence ; son auteur atteste que le contenu est original ou libre de droits.
- **Comptes utilisateurs** : données personnelles soumises au RGPD (voir §8).

### 1.4 Glossaire

| Terme | Définition |
| --- | --- |
| MJ | Maître du jeu : crée les tables, les rencontres et les PNJ |
| PJ | Personnage joueur, dont la fiche appartient à un compte joueur |
| PNJ | Personnage non joueur, géré par le MJ (fiche complète ou bloc de stats) |
| Table | Campagne regroupant un MJ, des joueurs, des personnages, des packs actifs et des séances |
| Pack | Ensemble versionné d'entités de règles (SRD ou homebrew), échangeable en fichier `.dndpack` |
| Homebrew | Contenu de règles créé par un utilisateur |
| SRD 5.2.1 | System Reference Document des règles 2024, publié en français sous le titre « Document de Référence du Système », libre sous CC-BY-4.0 |
| Don d'origine | Don accordé par l'Historique à la création (règles 2024) |
| Botte d'arme | Propriété botte d'une arme, utilisable grâce à l'aptitude Bottes d'armes : Coup double, Écorchure, Enchaînement, Ouverture, Poussée, Ralentissement, Renversement, Sape |
| Étude, Influence, Observation | Actions 2024 (Study, Influence, Search en VO) résolues par un test de caractéristique |
| Offline-first | L'appareil est la source de vérité ; le réseau ne sert qu'à synchroniser |

**Vocabulaire de l'interface.** L'application reprend le vocabulaire du SRD 5.2.1 français : « état » pour une condition, « profil de jeu » pour un bloc de stats, « Amical / Indifférent / Hostile » pour les attitudes, « Bottes d'armes » pour l'aptitude de maîtrise. Les distances sont en mètres (1,5 m par case), comme dans le SRD français.

## 2. Utilisateurs et rôles

Un même compte peut être MJ d'une table et joueur d'une autre : le rôle est porté par l'appartenance à une table, pas par le compte. Au MVP, une table a un seul MJ.

### 2.1 Personas

**Camille, MJ régulière.** Elle mène une campagne toutes les deux semaines, prépare ses séances sur son PC (navigateur) et joue avec son téléphone posé à côté de l'écran du MJ. Elle veut un suivi de combat rapide pour 4 à 30 combattants, des rappels de conditions qu'elle oublie souvent, et réutiliser les monstres homebrew d'un ami MJ.

**Hugo, joueur débutant.** Il découvre les règles 2024. Il a besoin d'être guidé pas à pas à la création et à la montée de niveau, avec des choix impossibles bloqués et expliqués. Il consulte sa fiche sur téléphone, parfois sans réseau.

**Inès, joueuse expérimentée et créatrice de homebrew.** Elle conçoit des sous-classes et des sorts, les teste dans sa table, puis les publie pour d'autres MJ.

### 2.2 Rôles et permissions

| Action | MJ de la table | Joueur de la table | Hors table |
| --- | --- | --- | --- |
| Créer, configurer, archiver la table | Oui | Non | — |
| Choisir la méthode de génération des caractéristiques | Oui | Non | — |
| Activer ou désactiver des packs pour la table | Oui | Non | — |
| Inviter un joueur, retirer un joueur | Oui | Non | — |
| Attribuer un emplacement de fiche à un joueur | Oui | Non | — |
| Créer et modifier son PJ | Lecture + modification sur validation | Oui (son PJ uniquement) | Non |
| Voir les fiches des autres PJ | Oui (complètes) | Résumé (nom, portrait, espèce, classe, niveau, état de santé qualitatif) ; fiche complète en lecture seule si le MJ l'active (EF-TAB-09) | Non |
| Créer et gérer PNJ, monstres, rencontres | Oui | Non | — |
| Voir PV et stats des monstres | Oui | Non (V2 : vue joueurs approximative) | — |
| Mettre à jour les PV et conditions de son PJ en combat | Oui | Oui | — |
| Notes de séance | Privées MJ | Notes personnelles privées | — |
| Créer du homebrew | Oui | Oui | Oui |

**Règle d'arbitrage** : le MJ a toujours le dernier mot sur l'état de combat. Une modification de fiche par le MJ (dégâts, condition, correction) est appliquée immédiatement et notifiée au joueur. En dehors du combat, le joueur reste propriétaire de sa fiche ; une modification structurelle par le MJ (niveau, don, Historique) passe par une proposition que le joueur accepte.

## 3. Découpage en lots

Le MVP est large (comptes, synchronisation, homebrew de tout type) ; il est donc découpé en quatre jalons internes, chacun testable de bout en bout avant de passer au suivant.

| Lot | Contenu | Critère de sortie |
| --- | --- | --- |
| **M0 – Fondations** | Monorepo, moteur de règles `dnd_rules`, pack SRD 5.2.1 français (échantillon vertical puis complet), base locale Drift, CI | Création d'un PJ niveau 1 valide en test unitaire, sans UI |
| **M1 – Personnages hors-ligne** | Création guidée 1 à 20, multiclassage, sorts, inventaire simplifié, montée de niveau, repos — en local, sans compte | Un PJ complet créé et monté au niveau 5 en mode avion, sur Web, Android et iOS |
| **M2 – Comptes, tables, synchronisation** | Comptes, tables, invitations, attribution de fiches, synchronisation multi-appareils, sauvegarde | Un MJ et deux joueurs sur trois appareils : modifications hors-ligne fusionnées sans perte après reconnexion |
| **M3 – Gestion de table** | PNJ, préparation de rencontres et difficulté, combat (initiative, PV, conditions, concentration), Étude/Influence/Observation, vue combat du joueur, séances (préparation, clôture, PX ou jalons), notes | Une rencontre de 30 combattants menée sur téléphone, hors-ligne |
| **M4 – Homebrew** | Éditeur de tous les types d'entités, packs, export/import `.dndpack`, activation par table | Une sous-classe homebrew créée par un MJ, importée par un autre, utilisée par un PJ |
| **V1.5** | Mode clair, applications Windows et macOS, partage de packs par proximité (Wi-Fi local + QR), notifications push (invitation, fiche soumise, fiche validée) | — |
| **V2** | Co-MJ (plusieurs MJ par table), bibliothèque communautaire et modération, lanceur de dés avec historique, export PDF des fiches, gestion du poids, vue joueurs sur second écran | — |

**Ordre des plateformes** : Web d'abord (préparation MJ), puis téléphone, puis tablette paysage. Chaque jalon est livré sur Web, Android et iOS, mais la conception et les tests prioritaires suivent cet ordre.

## 4. Comptes et tables

Le compte est obligatoire pour rejoindre ou créer une table ; une fois connecté, l'utilisateur travaille entièrement hors-ligne. Les identifiants d'exigences (EF-xxx) servent de référence dans les cartes Trello.

### 4.1 Comptes

| ID | Exigence |
| --- | --- |
| EF-CPT-01 | Inscription et connexion par e-mail + mot de passe, Google et Apple (Sign in with Apple est exigé par l'App Store dès qu'un fournisseur tiers est proposé). Âge minimum : 15 ans, date de naissance déclarée à l'inscription ; inscription refusée en dessous. |
| EF-CPT-02 | La première connexion exige le réseau ; la session reste ensuite valide hors-ligne, sans limite de durée tant que l'utilisateur ne se déconnecte pas. |
| EF-CPT-03 | Profil : pseudonyme affiché, avatar optionnel, langue, taille du texte, thème. |
| EF-CPT-04 | Suppression du compte depuis l'application (exigence Apple et Google), avec export préalable proposé. Les PJ du compte sont retirés des tables ; les packs publiés restent attribués à « auteur supprimé ». Les tables dont il est MJ restent en place pour leurs joueurs, sans MJ : la table continue d'exister, mais ses fiches ne peuvent plus être modifiées (décision du 25 octobre 2026, voir §14.3). |
| EF-CPT-05 | Gestion des appareils connectés : liste et déconnexion à distance. |
| EF-CPT-06 | Consentement explicite et révocable aux rapports de crash, demandé au premier lancement. |
| EF-CPT-07 | Erreur de connexion : message unique « E-mail ou mot de passe incorrect », sans dire lequel, pour ne pas révéler l'existence d'un compte. Même principe pour « Mot de passe oublié » : « Si un compte existe pour cette adresse… ». |
| EF-CPT-08 | Réinitialisation du mot de passe : lien valable 1 heure, renvoi possible après 60 secondes. Nouveau mot de passe de 10 caractères au moins, différent de l'e-mail et du pseudonyme, absent des listes de mots de passe divulgués, avec jauge de robustesse et règles cochées au fil de la saisie. Option « Déconnecter mes autres appareils » cochée par défaut. |
| EF-CPT-09 | Changement d'e-mail : confirmation par lien envoyé à la nouvelle adresse ; l'ancienne reste active jusque-là et reçoit un avertissement. L'e-mail et le mot de passe demandent le réseau ; le pseudonyme et l'avatar se modifient hors-ligne. |
| EF-CPT-10 | Méthodes de connexion : un compte peut lier mot de passe, Google et Apple, et en garde toujours au moins une (« Retirer » désactivé sur la dernière). Un compte Google ou Apple sans mot de passe doit en ajouter un avant de changer son e-mail. |
| EF-CPT-11 | Première connexion sans réseau : le bouton est désactivé avec l'explication ; aucun identifiant n'est stocké ni mis en file en attendant le réseau. |

### 4.2 Tables

| ID | Exigence |
| --- | --- |
| EF-TAB-01 | Un MJ crée une table : nom, description, image de couverture optionnelle, niveau de départ des PJ. |
| EF-TAB-02 | Le MJ choisit **une** méthode de génération des caractéristiques pour la table : tableau standard, achat de points ou 4d6 en retirant le plus faible. Elle s'impose à toutes les créations de PJ de la table. |
| EF-TAB-03 | Le MJ choisit la règle du repos long (récupération totale des PV, ou récupération par dépense de dés de vie) et le mode de PV à la montée de niveau (moyenne fixe ou jet). |
| EF-TAB-04 | Le MJ active les packs de la table et fige leur version (voir §7). |
| EF-TAB-05 | Le MJ invite des joueurs par lien, code à 6 caractères ou QR code. L'invitation expire après 7 jours et peut être révoquée. |
| EF-TAB-06 | Le MJ retire un joueur ; la fiche de ce joueur est archivée, pas supprimée. |
| EF-TAB-07 | Le MJ archive une table : lecture seule, restaurable. |
| EF-TAB-08 | Rejoindre une table exige le réseau ; hors-ligne, la demande est mise en file et part à la reconnexion. Tout le reste fonctionne hors-ligne. |
| EF-TAB-09 | Visibilité entre joueurs. Par défaut, chaque joueur voit un résumé des autres PJ : nom, portrait, espèce, classe, niveau et état de santé qualitatif (**indemne** : PV au maximum ; **blessé** : plus de la moitié des PV max ; **gravement blessé** : moitié ou moins). Les PV chiffrés ne sont pas affichés. Un réglage de table permet au MJ d'ouvrir les fiches complètes des autres PJ en lecture seule. |
| EF-TAB-10 | Le MJ choisit à la création de la table la progression des personnages : points d'expérience ou jalons, modifiable dans la configuration. En jalons, aucun PX n'apparaît sur les fiches ni dans la vue joueur ; la jauge de difficulté des rencontres reste calculée en PX. |
| EF-TAB-11 | Changement de configuration en cours de campagne : une nouvelle méthode de caractéristiques ne s'applique qu'aux prochaines créations ; passer en jalons fige les PX acquis. Les joueurs voient la nouvelle règle à leur synchronisation, et chaque changement est daté dans l'activité de la table. |

### 4.3 Attribution des fiches

1. Le MJ crée un **emplacement de PJ** dans la table et l'attribue à un joueur ayant rejoint la table.
2. Le joueur reçoit une notification et lance la création guidée (§5), contrainte par la configuration de la table (méthode de caractéristiques, niveau de départ, packs actifs).
3. Le MJ peut valider la fiche finale ou demander des corrections avec un commentaire.
4. Un joueur peut tenir plusieurs PJ dans une même table si le MJ lui attribue plusieurs emplacements.
5. Un PJ peut être transféré d'un joueur à un autre par le MJ (joueur qui quitte le groupe).

**Personnage libre.** Un joueur peut aussi créer un personnage hors de toute table (méthode de caractéristiques et niveau de départ à son choix), puis le rattacher à une table qu'il a rejointe. Au rattachement, le personnage est revalidé contre la configuration de la table : méthode de caractéristiques, niveau de départ, packs actifs, entités bannies. Les écarts sont listés au MJ, qui accepte avec dérogation ou demande une correction. Une dérogation n'envoie pas de notification au joueur : elle est inscrite dans l'historique de la fiche, qu'il peut consulter. Un personnage ne peut être rattaché qu'à une table à la fois.

### 4.4 Séances et progression

| ID | Exigence |
| --- | --- |
| EF-SEA-01 | Le MJ crée des séances (date, titre) et y range rencontres et notes. « Jouer tout de suite » crée une séance datée du jour. |
| EF-SEA-02 | Préparation : présences prévues, préremplies dans chaque rencontre (difficulté et partage des PX). Un écran indique si tout le nécessaire est sur l'appareil pour jouer hors-ligne, et quelle version d'une fiche sera utilisée si une synchronisation manque. |
| EF-SEA-03 | Clôture (table en PX) : les PX de chaque rencontre jouée sont partagés entre les personnages présents à cette rencontre ; un absent ne gagne rien. Les PX sont ajoutés aux fiches et inscrits dans leur historique. Une rencontre non jouée est reportée à la séance suivante, gardée sans séance ou supprimée. |
| EF-SEA-04 | Table en jalons : le MJ accorde un niveau à tout moment de la séance ou à la clôture, avec un motif visible des joueurs. Les absents sont décochés par défaut ; à la clôture, les personnages déjà servis apparaissent cochés et grisés. Hors-ligne, l'attribution part à la reconnexion. |
| EF-SEA-05 | Le bouton « Monter au niveau n » n'apparaît que si la montée est déverrouillée : seuil de PX atteint (table en PX), niveau accordé par le MJ (table en jalons) ou dérogation du MJ (les deux modes). Il affiche toujours son origine : « Seuil de 14 000 PX atteint », « Niveau 6 accordé par Camille ». « Plus tard » réduit l'encadré en puce près du nom. Sans déverrouillage, l'en-tête montre la progression en PX, ou rien en jalons. |
| EF-SEA-06 | Une fois déverrouillée, la montée de niveau ne demande pas de validation du MJ ; elle est tracée dans l'historique de la fiche. |
| EF-SEA-07 | Après la clôture, le joueur voit ses PX (ou le jalon) et les notes de séance partagées, pas le résumé des rencontres. |

## 5. Création et suivi des personnages

Toute valeur de la fiche est **calculée** par le moteur de règles à partir des choix du joueur ; aucune valeur dérivée n'est saisie à la main, sauf dérogation explicite du MJ (champ « ajustement manuel » tracé).

### 5.1 Création guidée (ordre des règles 2024)

1. **Classe** : choix parmi les classes des packs actifs ; affichage des caractéristiques principales, dés de vie, maîtrises.
2. **Origine – Historique** : affiche les 3 caractéristiques éligibles, le don d'origine, les 2 compétences, l'outil et le choix d'équipement (pack ou 50 po).
3. **Origine – Espèce** : taille, vitesse, traits ; aucun bonus de caractéristique.
4. **Origine – Langues** : Commun + 2 langues standard.
5. **Caractéristiques** : selon la méthode imposée par la table, puis répartition des bonus d'Historique (+2/+1 ou +1/+1/+1, uniquement sur les 3 caractéristiques éligibles, plafond 20).
6. **Sous-choix** : compétences de classe, bottes d'armes, sorts de départ, sous-choix du don d'origine (ex. liste de sorts de Magic Initiate).
7. **Équipement de départ** : packs de classe et d'Historique, ou or.
8. **Détails** : nom, alignement, apparence, personnalité, histoire, portrait optionnel.
9. **Récapitulatif** : fiche calculée, alertes éventuelles, envoi au MJ pour validation. Les alertes ne bloquent pas l'envoi ; seules les erreurs de règle bloquent « Suivant ».

Le joueur peut revenir à toute étape ; les choix devenus invalides sont signalés et doivent être refaits.

### 5.2 Exigences

| ID | Exigence |
| --- | --- |
| EF-PJ-01 | Niveaux 1 à 20, multiclassage avec contrôle des prérequis (13 dans la caractéristique principale de chaque classe concernée). |
| EF-PJ-02 | Valeurs calculées : modificateurs, bonus de maîtrise, sauvegardes, compétences, Perception passive, initiative, CA, vitesse, PV max, DD et bonus d'attaque des sorts, attaques et dégâts d'armes. |
| EF-PJ-03 | Chaque valeur calculée affiche sa décomposition au toucher (ex. « FOR 16 = 14 base + 2 Historique Soldat »). |
| EF-PJ-04 | Bottes d'armes : nombre d'emplacements selon la classe et le niveau ; choix modifiable après un repos long ; effet de la botte affiché sur l'attaque. |
| EF-PJ-05 | Dons classés par catégorie (origine, général, style de combat, faveur épique) ; seuls les dons éligibles sont proposés (catégorie, niveau, prérequis). |
| EF-PJ-06 | Montée de niveau guidée : PV (moyenne fixe ou jet, selon réglage de table), aptitudes de classe, sous-classe au niveau 3, amélioration de caractéristique ou don aux niveaux prévus, faveur épique au niveau 19, nouveaux sorts. |
| EF-PJ-07 | Sorts : connus et préparés selon la classe, grimoire du Magicien, rituels, sorts mineurs avec progression, emplacements par niveau, magie de pacte de l'Occultiste, table d'emplacements du multiclassage. |
| EF-PJ-08 | Fiche de sort : niveau, école, temps d'incantation (action, action bonus, réaction avec déclencheur, rituel), portée, composantes V/S/M avec coût et consommation, durée, concentration, description. |
| EF-PJ-09 | Concentration : un seul sort actif ; lancer un second sort à concentration demande confirmation et met fin au premier. |
| EF-PJ-10 | Inventaire simplifié : objets et quantités, monnaie (pc, pa, pe, po, pp), objets équipés, harmonisation (3 objets maximum). La CA et les attaques suivent l'équipement porté. Pas de poids au MVP. |
| EF-PJ-11 | Suivi de jeu : PV actuels et temporaires, dés de vie, jets de sauvegarde contre la mort, Inspiration héroïque, ressources de classe (utilisations par repos), conditions et niveau d'épuisement. |
| EF-PJ-12 | Repos court : dépense de dés de vie, récupération des ressources « repos court ». Repos long : selon la règle de la table (EF-TAB-03), récupération des emplacements et ressources, réduction de l'épuisement d'un niveau. |
| EF-PJ-13 | Historique des modifications de la fiche (qui, quand, quoi), consultable par le joueur et le MJ. Lecture seule : une correction est une nouvelle modification, elle-même tracée. Une valeur écrasée à la synchronisation reste visible, barrée, avec un renvoi vers l'entrée « Conflit résolu ». |
| EF-PJ-14 | Le contenu homebrew d'une fiche est figé à la version du pack au moment de son utilisation ; une mise à jour du pack déclenche une alerte « contenu modifié » avec choix de migrer ou de conserver. Ce choix appartient à chaque joueur : le MJ ne peut pas imposer la migration. |
| EF-PJ-15 | Suggestions : un bouton « Suggérer » à chaque étape de création et de montée de niveau (répartition des points pour la classe, compétences et don cohérents avec l'Historique, bottes pour les armes de départ). La suggestion est un choix prérempli, modifiable, avec sa raison en une ligne. |
| EF-PJ-16 | Proposition structurelle du MJ : depuis la fiche d'un PJ, le MJ propose une modification (niveau, don, Historique…) avec un motif obligatoire. Le joueur la reçoit en tête de fiche avec un aperçu avant et après, et l'accepte ou la refuse avec un message. L'acceptation applique la modification et l'inscrit dans l'historique. |
| EF-PJ-17 | Effets reçus : la fiche liste les effets et états posés par d'autres (nom, source, durée restante, effet en une ligne, ex. « Béni · de Mira · +1d4 aux attaques et aux JS · 8 rounds »). Les valeurs touchées l'indiquent dans leur décomposition. L'effet disparaît à son expiration ou à la fin de la concentration du lanceur. |
| EF-PJ-18 | Consommables et Inspiration : bouton « Utiliser » sur les consommables (ex. potion de guérison : rappel action Bonus, soin 2d4 + 2 saisi ou lancé, PV appliqués, quantité décomptée, entrée d'historique). Inspiration héroïque : « Utiliser » pour relancer un dé ; « Donner à… » un PJ qui n'en a pas, quand le personnage en reçoit une alors qu'il en a déjà une. |
| EF-PJ-19 | Repos de groupe : le MJ déclenche un repos court ou long pour les PJ présents ; chaque joueur reçoit l'écran de repos (dépense des dés de vie, récapitulatif) et le MJ voit qui a terminé. Le repos individuel reste possible hors séance. |
| EF-PJ-20 | Une fiche en attente de validation reste jouable en séance (bandeau « En attente de validation · utilisable en jeu »). Les corrections demandées par le MJ ne font pas perdre l'état de jeu (PV, emplacements, ressources). |
| EF-PJ-21 | Termes de règles cliquables : dans les aptitudes, sorts et effets, un terme de règle (Désavantage, Agrippé, action Bonus, Concentration…) ouvre sa fiche du compendium en feuille modale, sans quitter la fiche. |

### 5.3 PNJ

| ID | Exigence |
| --- | --- |
| EF-PNJ-01 | Le MJ crée un PNJ soit comme **fiche complète** (même assistant que les PJ, sans contrainte de méthode de caractéristiques), soit comme **bloc de stats** (format monstre). |
| EF-PNJ-02 | Un PNJ peut être dupliqué, rangé dans des dossiers, et réutilisé dans plusieurs rencontres de la table. |
| EF-PNJ-03 | Le MJ peut associer des informations cachées à un PNJ ou un monstre, révélables par l'action Étude (§6.4). |

## 6. Gestion de table et combat

Le combat est l'écran le plus critique : toute action courante (dégâts, soin, condition, passer le tour) doit tenir en **deux interactions au plus**, sur téléphone à une main.

### 6.1 Préparation des rencontres

| ID | Exigence |
| --- | --- |
| EF-REN-01 | Le MJ crée des rencontres à l'avance et les range par séance. |
| EF-REN-02 | Ajout de combattants depuis le bestiaire (SRD + packs actifs), les PNJ et les PJ de la table ; quantité par monstre avec numérotation automatique (« Gobelin 1…4 »). |
| EF-REN-03 | Calcul de difficulté selon le budget d'XP 2024 (faible, modérée, élevée) en fonction du niveau des PJ présents ; jauge mise à jour à chaque ajout. |
| EF-REN-04 | PV des monstres : valeur moyenne par défaut, ou jet des dés de vie au lancement (réglage de la rencontre). |
| EF-REN-05 | Une rencontre peut être dupliquée et modifiée. |

### 6.2 Initiative et tours

| ID | Exigence |
| --- | --- |
| EF-INI-01 | Jet d'initiative automatique pour les monstres et PNJ ; tableau de saisie rapide pour les PJ (le joueur peut saisir son propre résultat depuis son appareil). |
| EF-INI-02 | Option d'initiative commune pour un groupe de monstres identiques. |
| EF-INI-03 | Surprise : désavantage au jet d'initiative des combattants surpris. |
| EF-INI-04 | Égalités selon le SRD 5.2.1 : le MJ ordonne les monstres ex aequo, les joueurs ordonnent leurs PJ ex aequo, et le MJ tranche entre un monstre et un PJ. L'application propose un ordre par défaut, signale chaque égalité avec qui doit décider, et permet le réordonnancement manuel par glisser-déposer. |
| EF-INI-05 | Compteur de rounds, combattant actif mis en évidence, bouton « tour suivant » toujours accessible. |
| EF-INI-06 | Ajout ou retrait d'un combattant en cours de combat. |
| EF-INI-07 | Compteurs par monstre : actions légendaires, résistances légendaires, capacités à recharge, réactions utilisées dans le round. |
| EF-INI-08 | Réaction des PJ : chaque carte de PJ affiche « Réaction disponible / utilisée », réinitialisée au début de son tour, comme pour les monstres. |
| EF-INI-09 | Don Vigilant : juste après le jet d'initiative, un PJ qui a ce don peut échanger son initiative avec un allié consentant (bouton « Échanger avec… »), sauf si l'un des deux est Neutralisé. |

### 6.3 Points de vie, conditions, concentration

| ID | Exigence |
| --- | --- |
| EF-PV-01 | Dégâts et soins sur un ou plusieurs combattants à la fois, avec type de dégâts ; résistances, vulnérabilités et immunités appliquées automatiquement. |
| EF-PV-02 | PV temporaires consommés en premier ; un nouveau gain de PV temporaires ne se cumule pas (on garde le plus élevé, au choix). |
| EF-PV-03 | À 0 PV : PJ inconscient avec suivi des jets de sauvegarde contre la mort ; monstre marqué hors de combat (MJ peut le conserver pour un « coup de grâce » narratif). |
| EF-CON-01 | Les 15 états du SRD 5.2.1 (À terre, Agrippé, Assourdi, Aveuglé, Charmé, Effrayé, Empoisonné, Entravé, Épuisement, Étourdi, Inconscient, Invisible, Neutralisé, Paralysé, Pétrifié), chacun avec icône, libellé et résumé de règle au toucher. L'épuisement gère ses 6 niveaux. |
| EF-CON-02 | Durée d'une condition : nombre de rounds, jusqu'au début ou à la fin du tour d'un combattant donné, jusqu'à réussite d'une sauvegarde (DD et caractéristique), ou indéfinie. |
| EF-CON-03 | Rappels automatiques au début et à la fin de chaque tour : conditions qui expirent, sauvegardes à répéter, dégâts récurrents. |
| EF-CON-04 | Concentration : à chaque dégât subi par un combattant concentré, alerte avec le DD calculé (10 ou la moitié des dégâts si plus élevé, plafonné à 30) et boutons réussite / échec. |
| EF-CON-05 | Fin de concentration : le sort et ses effets liés (conditions posées par ce sort) sont retirés sur confirmation. |
| EF-PV-04 | Pavé de dégâts : les corrections manuelles sont libellées « Vulnérabilité ×2 » et « Résistance ½ ». Une bascule « Coup critique » ne change pas le montant saisi mais déclenche les règles liées (deux échecs de jet contre la mort sur un PJ à 0 PV). |
| EF-PV-05 | Automatismes à 0 PV (SRD 5.2.1), annulables : tomber à 0 PV donne l'état Inconscient et lance les jets contre la mort ; dégâts massifs (excédent ≥ PV max) = mort sur le coup, annoncée dans l'aperçu avant validation ; dégâts à 0 PV = un échec (deux sur coup critique), mort si les dégâts atteignent les PV max ; soins à 0 PV = Inconscient retiré et compteurs remis à zéro ; Stabilisé (trois réussites ou Soutien avec Médecine DD 10) = plus de jets, reste Inconscient, le moindre dégât relance les jets. |
| EF-PV-06 | Assommer : quand une attaque de corps à corps ferait tomber une créature à 0 PV, le pavé propose « Assommer » : 1 PV et état Inconscient. |
| EF-CON-06 | La concentration prend fin automatiquement si le lanceur devient Inconscient ou Neutralisé, ou meurt ; les effets liés sont retirés avec confirmation. |
| EF-CON-07 | Épuisement appliqué : chaque niveau retire 2 à tous les tests d20 et 1,50 m à la Vitesse ; la pénalité apparaît dans la décomposition des valeurs touchées et en puce sur la carte et la fiche (« Épuisement 2 · −4 aux tests d20 · Vitesse −3 m »). Le niveau 6 demande une confirmation, puis marque le personnage comme mort. |

### 6.4 Assistant Étude, Influence, Observation

| ID | Exigence |
| --- | --- |
| EF-ACT-01 | **Étude** : test d'Intelligence (Arcanes, Histoire, Investigation, Nature ou Religion). L'assistant suggère la compétence adaptée selon le type de créature de la cible ; le MJ fixe le DD ; selon le résultat, les informations cachées préparées sur la cible (paliers de DD) sont révélées et ajoutées au journal. |
| EF-ACT-02 | **Influence, étape 1** : le MJ indique comment la cible reçoit la requête. *Disposée* : elle accepte sans test. *Réticente* : elle refuse sans test. *Hésitante* : un test est nécessaire. |
| EF-ACT-03 | **Influence, étape 2** (cible hésitante) : l'assistant propose le test selon la façon d'interagir, d'après la table « Tests d'Influence » : Charisme (Intimidation) pour intimider, (Persuasion) pour convaincre, (Représentation) pour amuser, (Tromperie) pour tromper, ou Sagesse (Dressage) pour amadouer une Bête ou une Monstruosité. DD par défaut : 15 ou la valeur d'Intelligence de la cible si elle est plus élevée. L'attitude module le test : Avantage contre une cible Amicale, Désavantage contre une cible Hostile. Le MJ enregistre le résultat et le changement d'attitude ; l'échec est mémorisé par personnage et par approche : une nouvelle tentative identique est signalée pendant 24 heures (règle du SRD), délai modifiable par le MJ. |
| EF-ACT-04 | **Observation** : test de Sagesse (Intuition, Médecine, Perception ou Survie) ; pas d'informations préparées : le MJ consigne ce qui est découvert, et peut le lier à un PNJ ou en faire une note. |
| EF-ACT-05 | Les correspondances type de créature → compétence suggérée et interaction → test d'Influence sont des données de règles, modifiables par pack. |
| EF-ACT-06 | L'attitude d'un PNJ (Amical, Indifférent, Hostile ; Indifférent par défaut pour un monstre) persiste hors combat et entre séances. |
| EF-ACT-07 | Le journal de rencontre et les informations révélées par l'Étude sont réservés au MJ : les joueurs ne les voient pas dans l'application, le MJ les annonce à la table. |

### 6.5 Journal et annulation

| ID | Exigence |
| --- | --- |
| EF-LOG-01 | Toute action de combat produit un événement horodaté dans le journal de la rencontre. |
| EF-LOG-02 | Annulation (undo) des 20 dernières actions au minimum. |
| EF-LOG-03 | Fin de rencontre : résumé (durée en rounds, XP gagnés, combattants tombés), conservé dans la séance. |

### 6.6 Notes

| ID | Exigence |
| --- | --- |
| EF-NOT-01 | Notes en texte simple (gras, listes, liens internes vers PNJ et rencontres) rattachées à une table, une séance, un PNJ ou une rencontre. |
| EF-NOT-02 | Notes privées du MJ, invisibles des joueurs ; chaque joueur peut tenir ses propres notes privées. |
| EF-NOT-03 | Recherche plein texte hors-ligne dans les notes. |
| EF-NOT-04 | Partage : le MJ comme les joueurs peuvent partager une note avec la table ; elle reste modifiable par son seul auteur et s'ouvre en lecture seule pour les autres. Une note est privée par défaut. |
| EF-NOT-05 | Les notes du joueur s'affichent dans l'onglet Notes de sa fiche, groupées par rattachement ; les notes partagées par d'autres y apparaissent en lecture seule. |
| EF-NOT-06 | Une note modifiée sur deux appareils hors-ligne garde les deux versions dans la note ; l'auteur fusionne. |

### 6.7 Jets de dés

| ID | Exigence |
| --- | --- |
| EF-DES-01 | Partout où un jet précis est attendu, deux chemins côte à côte : « Saisir mon jet » (dés physiques) et « Lancer » (l'application lance). |
| EF-DES-02 | Le jet de l'application connaît sa formule : nombre de dés, bonus, Avantage ou Désavantage (deux d20 affichés, le dé écarté barré) et effets reçus (ex. +1d4 Béni). |
| EF-DES-03 | Le résultat s'affiche avec son détail (« d20 15 + 7 = 22 ») et reste modifiable avant validation. |
| EF-DES-04 | Jets concernés au MVP : initiative, jets contre la mort, dés de vie, jets de sauvegarde demandés au joueur, soins d'un consommable, PV à la montée de niveau en mode jet, jets automatiques des monstres. |
| EF-DES-05 | Hors MVP (V2) : lanceur libre, historique des jets, jets partagés à la table. |

### 6.8 Vue combat du joueur

| ID | Exigence |
| --- | --- |
| EF-VJ-01 | Quand le MJ lance une rencontre où figure son PJ, le téléphone du joueur bascule sur un écran « En combat » ; un geste ramène à la fiche complète. |
| EF-VJ-02 | Bandeau de tour toujours visible : round, combattant actif, nombre de tours avant le sien (« vous jouez dans 2 tours »). À son tour, bandeau « C'est votre tour » et rappel de l'économie d'actions (action, action Bonus, réaction, déplacement), que le joueur coche au fil du tour. |
| EF-VJ-03 | Ordre d'initiative simplifié : les PJ avec leur état de santé qualitatif ; les adversaires rendus visibles par le MJ, sous leur seul nom, sans PV ni CA ; les adversaires cachés n'apparaissent pas. Ni journal ni informations d'Étude. |
| EF-VJ-04 | Son personnage sans défiler : PV, PV temporaires, boutons Dégâts / Soins / PV temp., états et effets reçus avec leur durée, concentration en cours, réaction utilisée ou non, attaques (toucher, dégâts, effet de botte), sorts préparés avec emplacements restants, ressources. Lancer un sort décompte l'emplacement ; un sort à concentration propose de mettre fin au précédent. |
| EF-VJ-05 | Demandes de jets : quand son PJ doit faire un jet (concentration, sauvegarde à refaire, jet contre la mort), la demande apparaît sur son téléphone avec le type de jet, le DD et son bonus ; saisie du d20 ou lancer (§6.7). Le résultat remonte chez le MJ, qui peut le saisir lui-même. Les états qui expirent sur son PJ lui sont signalés en même temps qu'au MJ. |
| EF-VJ-06 | Toute modification du joueur apparaît chez le MJ et dans le journal ; en cas de conflit, la version du MJ prime. Hors-ligne, l'écran montre le dernier état connu avec « Hors-ligne : dites vos changements au MJ », et les modifications locales partent à la reconnexion. |

## 7. Homebrew et packs

Tout contenu de règles, SRD compris, vit dans un **pack** versionné ; le homebrew passe par les mêmes validations que le SRD, si bien qu'aucune entité homebrew ne peut casser le moteur de règles.

### 7.1 Types d'entités éditables

| Type | Champs mécaniques clés | Contraintes 2024 appliquées par l'éditeur |
| --- | --- | --- |
| Don | Catégorie, prérequis, effets, répétable | Catégorie obligatoire (origine, général, style de combat, faveur épique) |
| Historique | 3 caractéristiques, don d'origine, 2 compétences, 1 outil, équipement | Exactement 3 caractéristiques, 1 don de catégorie origine |
| Espèce | Taille, vitesse, traits, sous-lignées | Aucun bonus de caractéristique |
| Classe | Dé de vie, caractéristique principale, maîtrises, progression 1 à 20, nombre de bottes, incantation | Progression complète sur 20 niveaux, sous-classe au niveau 3 |
| Sous-classe | Classe parente, aptitudes par niveau | Niveaux d'aptitudes alignés sur ceux de la classe parente |
| Sort | Niveau, école, incantation, portée, composantes, durée, concentration, listes de classes, effets à niveau supérieur | — |
| Objet | Type, rareté, harmonisation, propriétés, botte (armes), CA (armures) | Une arme a toujours une botte |
| Monstre | Bloc de stats complet, type, FP/XP, actions, légendaires, informations d'Étude par palier | Valeur d'Intelligence obligatoire (DD d'Influence) ; CA calculée depuis l'armure et le bouclier avec sa formule affichée, ou naturelle avec un libellé |

### 7.2 Exigences

| ID | Exigence |
| --- | --- |
| EF-HB-01 | Éditeur par formulaires guidés ; les effets mécaniques se composent à partir d'une liste fermée d'opérations (DSL déclaratif, voir §10). Aucun code ni formule libre. |
| EF-HB-02 | Une entité homebrew peut **dériver** d'une entité SRD (variante) sans la modifier. |
| EF-HB-03 | Prévisualisation : l'auteur teste son entité sur un personnage de test avant de la publier dans un pack. |
| EF-HB-04 | Un pack a un nom, une description, une version (semver), une licence, un auteur et des dépendances. |
| EF-HB-05 | Export d'un pack en fichier `.dndpack` signé, via la feuille de partage du système. |
| EF-HB-06 | Import d'un `.dndpack` : contrôle de taille, de signature et de schéma, résolution des dépendances, aperçu avant confirmation (contenu, auteur, conflits). |
| EF-HB-07 | Mise à jour d'un pack importé uniquement si la signature correspond au même auteur ; sinon il est importé comme pack distinct. |
| EF-HB-08 | Duplication (fork) d'un pack importé pour le modifier, sous le nom de l'utilisateur. |
| EF-HB-09 | Activation d'un pack dans une table avec version figée ; les membres de la table reçoivent automatiquement les packs actifs par la synchronisation. |
| EF-HB-10 | Le SRD 5.2.1 est un pack verrouillé, toujours disponible, désactivable seulement entité par entité au niveau d'une table (ex. bannir un sort). |
| EF-HB-11 | Versions de pack : un correctif ne change que du texte, une version mineure ajoute du contenu compatible, une version majeure peut invalider des fiches. Une progression de classe incomplète bloque la publication, pas le test. |
| EF-CMP-01 | Compendium : recherche hors-ligne limitée par défaut aux packs actifs de la table, avec possibilité d'élargir à tous ses packs. Les entités bannies restent consultables, marquées « BANNI ». |

## 8. Exigences non fonctionnelles

L'exigence structurante est qu'une séance entière se joue sans réseau ; la synchronisation est un bonus qui ne bloque jamais une action.

| ID | Domaine | Exigence |
| --- | --- | --- |
| ENF-01 | Hors-ligne | Toutes les fonctions sont disponibles sans réseau, sauf : inscription, première connexion, rejoindre une table, accepter une invitation. |
| ENF-02 | Synchronisation | Les modifications locales sont mises en file et envoyées à la reconnexion, sans action de l'utilisateur. Un indicateur discret montre l'état (synchronisé, en attente, hors-ligne, conflit). |
| ENF-03 | Conflits | Fiches : dernier écrit gagnant champ par champ, sauf état de combat où le MJ prime. Combat : journal d'événements fusionné par horodatage. Tout conflit écrasant une donnée du joueur est notifié. |
| ENF-04 | Performance | Démarrage à froid < 2 s sur un téléphone Android milieu de gamme de 2022 ; action de combat reflétée à l'écran < 100 ms ; rencontre de 30 combattants fluide (60 i/s au défilement). |
| ENF-05 | Taille | Application mobile < 40 Mo installée, pack SRD inclus ; aucune image de règles embarquée. |
| ENF-06 | Plateformes | iOS 15+, Android 8+ (API 26), Web sur les deux dernières versions de Chrome, Firefox, Safari et Edge ; Windows 10+ et macOS 12+ en V1.5. |
| ENF-07 | Persistance Web | Demande de stockage persistant au navigateur ; alerte si refusé ; sauvegarde cloud via la synchronisation. |
| ENF-08 | Sécurité | Authentification par jetons à durée limitée avec rafraîchissement ; règles d'accès côté serveur par table et par rôle ; un joueur ne peut jamais lire les données privées du MJ, même en modifiant le client. |
| ENF-09 | Sécurité des packs | Un pack importé n'exécute jamais de code ; plafonds de taille (20 Mo), d'entités (10 000) et de profondeur JSON. |
| ENF-10 | RGPD | Données hébergées dans l'UE ; politique de confidentialité ; export complet des données de l'utilisateur (JSON) ; suppression de compte effective sous 30 jours. |
| ENF-11 | Télémétrie | Rapports de crash uniquement, avec consentement explicite et révocable, sans données de jeu ni contenu personnel. Aucune analytique d'usage. |
| ENF-12 | Sauvegarde | Export et import manuels de l'ensemble des données locales ; rappel de sauvegarde si aucune synchronisation ni export depuis 30 jours. |
| ENF-13 | i18n | Français au lancement ; aucune chaîne en dur ; fichiers ARB ; contenus de règles traduisibles par pack de langue. Distances stockées en pieds (unité de la VO) et affichées selon la langue, avec la conversion du SRD français (1,5 m pour 5 pieds). |
| ENF-14 | Accessibilité | Conditions toujours distinguées par icône + libellé ; contraste WCAG 2.2 AA ; taille de texte réglable de 85 % à 200 % ; cibles tactiles ≥ 48 px ; lecteurs d'écran (VoiceOver, TalkBack) sur les écrans de combat et de fiche. |
| ENF-15 | Ergonomie mobile | Actions de combat principales atteignables d'une main, dans le tiers inférieur de l'écran. |

## 9. Brief pour Claude Design

L'interface est un **outil de travail sobre et dense**, en mode sombre par défaut, avec une ambiance fantasy limitée aux titres et à de légères textures ; l'efficacité en combat prime sur la décoration.

### 9.1 Direction artistique

- **Ton** : hybride. Écrans de travail (combat, fiche) sobres, lisibles, denses. Écrans d'accueil, de table et de création de personnage plus évocateurs.
- **Typographie** : une police à empattements à caractère fantasy pour les titres uniquement ; une sans-empattement très lisible pour tout le reste, avec chiffres tabulaires pour PV, CA et initiative.
- **Couleurs** : fond sombre chaud (pas de noir pur), une couleur d'accent principale, et des couleurs sémantiques réservées (dégâts, soins, PV temporaires, concentration, alerte). La couleur ne porte jamais seule une information.
- **Textures** : grain ou papier très discret sur les en-têtes et cartes de table, jamais sur les zones de données.
- **Iconographie** : un jeu d'icônes cohérent pour les 15 conditions, les types de dégâts, les écoles de magie, les actions (action, action bonus, réaction).
- **Interdits** : aucun logo, nom ou motif rappelant la marque D&D ; aucun visuel du Player's Handbook.
- **Thème clair** : à prévoir dans les tokens dès le départ, livré en V1.5.

### 9.2 Points de rupture

| Format | Largeur | Priorité | Disposition attendue |
| --- | --- | --- | --- |
| Web desktop | ≥ 1024 px | 1 | Multi-panneaux : liste d'initiative + détail du combattant + journal côte à côte |
| Téléphone | < 600 px | 2 | Une colonne, actions de combat en barre inférieure, feuilles modales (bottom sheets) |
| Tablette paysage | 600 à 1023 px | 3 | Deux panneaux : liste + détail |

### 9.3 Parcours à concevoir

1. Premier lancement : consentement crash, inscription ou connexion, choix MJ ou joueur (non bloquant).
2. MJ : créer une table, la configurer (méthode de caractéristiques, repos long, packs), inviter des joueurs, attribuer des emplacements.
3. Joueur : rejoindre une table par lien, code ou QR, puis création guidée du PJ en 9 étapes, puis envoi au MJ.
4. Joueur : monter de niveau.
5. MJ : préparer une rencontre avec jauge de difficulté.
6. MJ : mener un combat (initiative, tour par tour, dégâts multiples, condition, alerte de concentration, Étude ou Influence, fin de rencontre).
7. Repos court et repos long.
8. Créer une entité homebrew, la tester, l'ajouter à un pack, exporter le pack.
9. Importer un pack reçu (aperçu, conflits, confirmation) et l'activer sur une table.

### 9.4 Inventaire des écrans

| Module | Écrans |
| --- | --- |
| Compte | Connexion / inscription, profil et réglages, appareils, consentements, export et suppression des données |
| Accueil | Mes tables (MJ et joueur), mes personnages, mes packs, état de synchronisation |
| Table | Vue d'ensemble, configuration, membres et invitations, séances, PNJ, rencontres, notes, packs actifs |
| Personnage | Assistant de création (9 étapes), fiche (onglets : principal, compétences, combat, sorts, inventaire, aptitudes, notes), montée de niveau, repos, historique des modifications |
| Combat | Préparation de rencontre, suivi de combat, détail d'un combattant, fenêtres dégâts/soins, conditions, concentration, assistant Étude/Influence/Observation, journal, résumé de fin |
| Compendium | Recherche transverse (sorts, dons, objets, monstres, conditions), fiche d'entité avec source du pack |
| Homebrew | Mes packs, éditeur par type d'entité (8 types), constructeur d'effets, prévisualisation, export, import avec aperçu |

### 9.5 États à couvrir sur chaque écran

Vide (premier usage, avec action suggérée), chargement, hors-ligne, synchronisation en attente, conflit résolu, erreur de validation de règle (message expliquant la règle), et pour le combat : combattant actif, à 0 PV, concentré, sous plusieurs conditions.

### 9.6 Composants clés

Carte de combattant compacte (nom, PV en barre + chiffres, CA, conditions en pastilles icône + libellé, indicateur de concentration) ; pavé numérique de dégâts/soins avec type ; puce de condition avec durée ; décomposition d'une valeur calculée ; sélecteur de répartition des bonus d'Historique ; jauge de difficulté ; badge de source (SRD ou nom du pack) ; indicateur de synchronisation.

## 10. Architecture technique (pour Claude Code)

Chaque appareil possède une base SQLite complète qui est la source de vérité locale ; un service de synchronisation la réplique vers un Postgres hébergé dans l'UE, filtré par table et par rôle.

&#91;embedded content: architecture · 3 couches sur l'appareil, 3 services cloud\]

Le partage de packs entre MJ passe par fichier, d'appareil à appareil, sans dépendre du cloud ; la réplication reprend dès que le réseau revient.

### 10.1 Stack

| Couche | Choix | Remarque |
| --- | --- | --- |
| Framework | Flutter (stable), Dart 3 | Une base de code pour Web, iOS, Android, puis Windows et macOS |
| État | Riverpod | Fournisseurs réactifs branchés sur les flux de la base |
| Modèles | freezed + json\_serializable | Entités immuables, sérialisation des packs |
| Base locale | SQLite via Drift ; Web en SQLite WASM (OPFS, repli IndexedDB) | Migrations versionnées, FTS5 pour la recherche |
| Synchronisation | **Retenu : PowerSync** (SDK Flutter, intégration Drift) adossé à Supabase | Décision prise ; intégration dès le début du jalon M2, en commençant par la cible Web |
| Backend | Supabase : Postgres, Auth (e-mail, Google, Apple), Storage (portraits, packs), région UE | Règles d'accès par ligne (RLS) par table et par rôle |
| Crash | Sentry, hébergement UE, activé seulement après consentement | Aucune donnée de jeu dans les rapports |
| Partage de packs | `share_plus`, `file_picker`, `archive`, `cryptography` (Ed25519) | Fonctionne sans réseau |
| i18n | `flutter_localizations` + fichiers ARB | Français au lancement |
| Navigation | go\_router | URL profondes pour les invitations Web |

### 10.2 Organisation du dépôt (monorepo Melos)

```
packages/
  dnd_rules/      moteur pur Dart : computeSheet(), validations, interpréteur du DSL d'effets
  dnd_content/    modèles et validateurs des entités et du format .dndpack
  dnd_data/       Drift : tables, DAO, migrations, import/export, adaptateur de synchronisation
  dnd_ui_kit/     tokens de design, thèmes, composants partagés
apps/
  game_table/     application Flutter (écrans, navigation, Riverpod)
tools/
  srd_builder/    CLI Dart qui produit le pack SRD 5.2.1 (FR) à partir des sources JSON
backend/
  supabase/       schéma Postgres, règles RLS, migrations, règles de synchronisation
```

### 10.3 Principes

- **Le moteur de règles est une fonction pure** : `computeSheet(personnage, contenu actif) → fiche calculée`. Il ne touche ni à la base, ni au réseau, ni à Flutter.
- **Les grants** : on stocke les sources (choix, dons, niveaux) et non les valeurs finales ; chaque valeur calculée garde la trace de ses contributions (EF-PJ-03).
- **DSL d'effets déclaratif** : liste fermée d'opérations (`ability_bonus`, `grant_proficiency`, `grant_feat`, `grant_spell`, `grant_resource`, `modify_speed`, `modify_ac`, `grant_mastery_slots`, `choice`…). Une opération inconnue rend l'entité invalide.
- **Identifiants stables** : `{namespace}:{type}:{slug}` pour le contenu, UUID v7 pour les données utilisateur (générés hors-ligne, triables).
- **Combat en journal d'événements** : l'état des combattants est une projection du journal, ce qui donne l'annulation et une fusion simple à la synchronisation.

## 11. Modèle de données

Le modèle sépare le **contenu de règles** (rangé par pack, en lecture pour le moteur) des **données de jeu** (comptes, tables, personnages, combats), et chaque table de données indique à qui elle est synchronisée.

### 11.1 Contenu de règles (par pack)

| Table | Champs clés |
| --- | --- |
| `content_pack` | id (UUID), namespace, nom, version (semver), origin (`srd` / `local` / `imported`), author\_id, licence, checksum, signature |
| `pack_dependency` | pack\_id, depends\_on\_pack\_id, version\_range |
| `ability`, `skill` | id ; skill.ability\_id |
| `background` | id, pack\_id, extends\_id, origin\_feat\_id, equipment\_gold\_alt |
| `background_ability` | background\_id, ability\_id (exactement 3 lignes) |
| `background_proficiency` | background\_id, type (`skill` / `tool`), ref\_id |
| `background_equipment_option` | background\_id, option (A / B), items (JSON) |
| `feat` | id, pack\_id, extends\_id, category (`origin` / `general` / `fighting_style` / `epic_boon`), prerequisites (JSON), repeatable |
| `species` | id, pack\_id, extends\_id, taille, vitesse, traits |
| `class`, `class_level` | class.hit\_die, primary\_ability, proficiencies ; class\_level : level, prof\_bonus, features, weapon\_mastery\_count, spell\_slots |
| `subclass`, `subclass_feature` | parent\_class\_id, level, feature |
| `spell`, `spell_class` | niveau, école, casting\_time, portée, composantes, coût matériel, consommé, durée, concentration, ritual |
| `item`, `weapon`, `armor` | rareté, harmonisation ; weapon.mastery\_property\_id ; armor.base\_ac, dex\_cap |
| `mastery_property`, `condition`, `damage_type` | listes de référence |
| `monster`, `monster_action` | bloc de stats, type de créature, FP, XP, intelligence ; actions, légendaires, recharge |
| `study_reveal` | monster\_id, dc, texte révélé (informations d'Étude par palier) |
| `effect` | owner\_type, owner\_id, payload (opération du DSL) |
| `entity_text` | entity\_id, locale, description (Markdown) |

Tout identifiant de contenu suit `{namespace}:{type}:{slug}`, par exemple `srd:background:soldier`.

### 11.2 Données de jeu

| Table | Champs clés | Synchronisée vers |
| --- | --- | --- |
| `profile` | user\_id, pseudonyme, avatar, langue, réglages | Ses appareils |
| `game_table` | id, gm\_user\_id, nom, stat\_method, long\_rest\_rule, hp\_on\_level\_rule, starting\_level, progression\_mode (xp / milestone), full\_sheets\_visible, archived | Membres de la table |
| `table_member` | table\_id, user\_id, role (`gm` / `player`), joined\_at | Membres de la table |
| `table_invite` | table\_id, code, expires\_at, revoked | MJ |
| `table_pack` | table\_id, pack\_id, pinned\_version | Membres de la table |
| `table_banned_entity` | table\_id, entity\_id | Membres de la table |
| `character` | id, table\_id, owner\_user\_id, kind (`pc` / `npc_full`), species\_id, background\_id, statut (brouillon, soumis, validé), xp, level\_unlock (origine et niveau déverrouillé) | Propriétaire + MJ ; résumé et état de santé qualitatif aux joueurs de la table ; fiche complète en lecture seule si `full_sheets_visible` |
| `character_base_scores` | character\_id, ability\_id, base, method | Propriétaire + MJ |
| `character_background_choice` | character\_id, distribution (`2-1` / `1-1-1`), bonus par caractéristique, feat\_choices (JSON) | Propriétaire + MJ |
| `character_class_level` | character\_id, class\_id, level, subclass\_id, hp\_roll | Propriétaire + MJ |
| `character_feat` | character\_id, feat\_id, source\_type, source\_ref, choices (JSON) | Propriétaire + MJ |
| `character_weapon_mastery` | character\_id, weapon\_id, slot\_index | Propriétaire + MJ |
| `character_spell` | character\_id, spell\_id, source, prepared, in\_spellbook | Propriétaire + MJ |
| `character_item` | character\_id, item\_id, quantité, équipé, harmonisé | Propriétaire + MJ |
| `character_state` | hp\_current, hp\_temp, hit\_dice\_used, death\_saves, exhaustion, heroic\_inspiration, ressources (JSON), concentration\_spell\_id | Propriétaire + MJ |
| `character_content_ref` | character\_id, entity\_id, pack\_id, pack\_version, snapshot (JSON) | Propriétaire + MJ |
| `character_change_log` | character\_id, author\_user\_id, horodatage, diff (JSON) | Propriétaire + MJ |
| `npc_statblock` | id, table\_id, monster\_id ou bloc complet, attitude, informations cachées | MJ |
| `session` | id, table\_id, date, titre | Membres de la table |
| `encounter` | id, session\_id, statut, difficulté calculée, hp\_mode | MJ |
| `combatant` | id, encounter\_id, kind, ref\_id, label, initiative, group\_id, hp, ac, attitude, visible | MJ ; ligne de son PJ au joueur |
| `encounter_event` | id (UUID v7), encounter\_id, round, actor\_id, type, payload (JSON), author\_user\_id | MJ ; événements de son PJ au joueur |
| `note` | id, owner\_user\_id, table\_id, scope (table, séance, PNJ, rencontre), ref\_id, contenu, privée | Auteur ; ou MJ selon le cas |
| `author_identity` | user\_id, public\_key | Public |

### 11.3 Règles d'intégrité appliquées par `dnd_rules`

- Bonus d'Historique uniquement sur les 3 caractéristiques de `background_ability`, distribution `2-1` ou `1-1-1`, aucune caractéristique au-delà de 20 par ce biais.
- Le don d'origine d'un Historique est forcément de catégorie `origin`.
- Nombre de bottes choisies ≤ `weapon_mastery_count` cumulé des classes du personnage ; arme maîtrisée par une de ses classes.
- Prérequis de multiclassage vérifiés à chaque ajout de niveau dans une nouvelle classe.
- Un seul `concentration_spell_id` non nul par personnage ou combattant.

## 12. Qualité, tests et CI/CD

Le moteur de règles est le cœur du produit : il vise une couverture de 95 % de lignes et ne fusionne jamais avec un test rouge.

### 12.1 Stratégie de tests

| Niveau | Cible | Couverture ou critère |
| --- | --- | --- |
| Unitaires | `dnd_rules` : calculs de fiche, validations 2024, DSL d'effets, multiclassage, emplacements de sorts | ≥ 95 % des lignes ; un test par règle d'intégrité (§11.3) |
| Unitaires | `dnd_content` : validateurs d'entités, format `.dndpack`, signature | ≥ 90 % |
| Intégration | Import / export de packs : aller-retour sur base vierge, pack corrompu, signature d'un autre auteur, dépendance manquante, plafonds de taille | Tous les cas de EF-HB-05 à EF-HB-08 |
| Intégration | Synchronisation : modifications concurrentes hors-ligne MJ et joueur, fusion du journal de combat | Scénario du critère de sortie M2 |
| Widgets | Écrans de combat : dégâts multiples, condition avec expiration, alerte de concentration, undo | Parcours 6 du §9.3 |
| Golden | Fiche et carte de combattant en sombre, 3 points de rupture, texte à 200 % | Captures de référence versionnées |
| Données | Pack SRD complet chargé, aucune référence cassée, chaque classe montée de 1 à 20 sans erreur | Exécuté à chaque build du pack |
| Données de référence | Jeu de personnages et de rencontres de référence (Aldric, Mira, Thalia, Brannoc, Kael ; rencontres de la séance 12), identique dans les maquettes et dans les tests | Chaque personnage recalculé par computeSheet() donne exactement les valeurs de sa planche |

Cas de test de référence à fournir dès M0 : personnages exemples (un par classe, niveaux 1, 5, 11, 20) avec leur fiche attendue, écrite à la main et relue.

### 12.2 CI/CD (GitHub Actions)

1. Sur chaque pull request : `dart format --set-exit-if-changed`, `flutter analyze` (lints stricts), tests unitaires et de widgets, couverture publiée.
2. Sur `main` : build Web déployé en préproduction, builds Android et iOS internes.
3. Sur tag de version : build du pack SRD, publication Web, envoi vers TestFlight et Google Play (test interne).
4. Migrations Supabase appliquées depuis `backend/supabase` par la CI uniquement.

### 12.3 Conventions

- Commits conventionnels (`feat:`, `fix:`…) ; chaque commit référence une carte Trello ou un ID d'exigence.
- Branches `feature/<id-carte>-<slug>` ; fusion par pull request.
- Aucune chaîne d'interface en dur ; aucune valeur de règle en dur dans l'UI (elle vient de `dnd_rules`).
- Un fichier `CLAUDE.md` à la racine résume ce cahier des charges, l'architecture et les commandes, pour les sessions Claude Code.

## 13. Backlog : épopées et user stories

Chaque ligne devient une carte Trello ; une liste par jalon, une étiquette par épopée. Les critères d'acceptation renvoient aux exigences (EF / ENF) pour le détail.

| Jalon | ID | User story | Critères d'acceptation |
| --- | --- | --- | --- |
| M0 | US-01 | En tant que dev, je dispose d'un monorepo Melos avec CI, lints et tests qui tournent. | PR bloquée si format, analyse ou tests échouent (§12.2). |
| M0 | US-02 | En tant que dev, je génère le pack SRD 5.2.1 français depuis des sources JSON validées. | Build en échec sur toute référence cassée ; pack échantillon (Guerrier, 4 Historiques, armes, conditions) chargé. |
| M0 | US-03 | En tant que dev, je calcule une fiche de niveau 1 avec `computeSheet()`. | Tests verts pour les règles §11.3 ; décomposition disponible pour chaque valeur. |
| M0 | US-04 | En tant que dev, j'ai le schéma Drift v1 et ses migrations. | Base créée sur Web, Android, iOS ; FTS5 opérationnel. |
| M1 | US-05 | En tant que joueur, je crée un personnage en 9 étapes guidées. | Choix invalides bloqués et expliqués ; fonctionne en mode avion (EF-PJ-01 à 05). |
| M1 | US-06 | En tant que joueur, je répartis les bonus de mon Historique. | Seules les 3 caractéristiques éligibles ; `2-1` ou `1-1-1` ; plafond 20. |
| M1 | US-07 | En tant que joueur, je consulte ma fiche et la décomposition de chaque valeur. | Toucher une valeur affiche ses sources (EF-PJ-03). |
| M1 | US-08 | En tant que joueur, je monte de niveau, y compris en multiclassage. | Prérequis contrôlés ; sous-classe au niveau 3 ; dons éligibles seulement (EF-PJ-06). |
| M1 | US-09 | En tant que joueur, je gère mes sorts, emplacements et ma concentration. | Connus, préparés, grimoire, pacte, multiclassage conformes (EF-PJ-07 à 09). |
| M1 | US-10 | En tant que joueur, je gère mon inventaire et ma monnaie. | CA et attaques recalculées selon l'équipement ; 3 harmonisations maximum. |
| M1 | US-11 | En tant que joueur, je fais un repos court ou long. | Ressources récupérées selon leur type ; règle de repos long de la table respectée. |
| M2 | US-12 | En tant qu'utilisateur, je crée un compte et je reste connecté hors-ligne. | E-mail, Google, Apple ; session valide en mode avion (EF-CPT-01, 02). |
| M2 | US-13 | En tant que MJ, je crée et configure une table. | Méthode de caractéristiques, règles de repos et de PV, niveau de départ (EF-TAB-01 à 03). |
| M2 | US-14 | En tant que MJ, j'invite des joueurs par lien, code ou QR. | Expiration 7 jours, révocation (EF-TAB-05). |
| M2 | US-15 | En tant que MJ, j'attribue un emplacement de PJ à un joueur, qui crée sa fiche. | Création contrainte par la table ; envoi au MJ ; validation ou demande de correction ; rattachement d'un personnage libre avec revalidation ; résumé des autres PJ visible (§4.3, EF-TAB-09). |
| M2 | US-16 | En tant qu'utilisateur, mes données se synchronisent entre mes appareils. | Scénario 3 appareils hors-ligne puis reconnexion sans perte (ENF-02, 03). |
| M2 | US-17 | En tant qu'utilisateur, j'exporte ou je supprime toutes mes données. | Export JSON complet ; suppression depuis l'app (EF-CPT-04, ENF-10). |
| M3 | US-18 | En tant que MJ, je crée des PNJ en fiche complète ou en bloc de stats. | EF-PNJ-01 à 03. |
| M3 | US-19 | En tant que MJ, je prépare une rencontre et vois sa difficulté. | Jauge 2024 mise à jour à chaque ajout ; numérotation automatique (EF-REN-01 à 05). |
| M3 | US-20 | En tant que MJ, je lance l'initiative et je mène les tours. | Jets auto des monstres, saisie des PJ, groupes, surprise, réordonnancement (EF-INI-01 à 07). |
| M3 | US-21 | En tant que MJ, j'applique dégâts et soins à plusieurs combattants. | Résistances appliquées ; PV temporaires ; deux interactions maximum (EF-PV-01 à 03). |
| M3 | US-22 | En tant que MJ, je pose des conditions et je suis rappelé à leur échéance. | Rappels de début et fin de tour ; sauvegardes répétées (EF-CON-01 à 03). |
| M3 | US-23 | En tant que MJ, je suis alerté des tests de concentration. | DD calculé ; fin de concentration retire les effets liés (EF-CON-04, 05). |
| M3 | US-24 | En tant que MJ, j'utilise l'assistant Étude, Influence, Observation. | Compétences suggérées, DD, révélations par palier, attitude enregistrée, étape disposé / réticent / hésitant (EF-ACT-01 à 06). |
| M3 | US-25 | En tant que MJ, j'annule une action et je consulte le journal. | 20 annulations minimum ; résumé de fin de rencontre (EF-LOG-01 à 03). |
| M3 | US-26 | En tant qu'utilisateur, je prends des notes privées. | Rattachement, confidentialité, recherche hors-ligne (EF-NOT-01 à 03). |
| M4 | US-27 | En tant que créateur, j'édite les 8 types d'entités homebrew. | Contraintes 2024 du §7.1 appliquées ; effets composés uniquement par le DSL. |
| M4 | US-28 | En tant que créateur, je teste mon entité sur un personnage de test. | Aperçu de la fiche calculée avant ajout au pack (EF-HB-03). |
| M4 | US-29 | En tant que créateur, j'exporte un pack signé. | Fichier `.dndpack` partagé via la feuille système, sans réseau (EF-HB-05). |
| M4 | US-30 | En tant que MJ, j'importe un pack et l'active sur ma table. | Contrôles et aperçu ; mise à jour seulement si même auteur ; diffusion aux membres (EF-HB-06 à 09). |
| M1 | US-31 | En tant que joueur, je vois les effets que d'autres m'appliquent et j'utilise mes consommables et mon Inspiration. | EF-PJ-17, EF-PJ-18. |
| M1 | US-32 | En tant que joueur débutant, je reçois des suggestions à chaque étape de création et de montée de niveau, et les termes de règles sont cliquables. | EF-PJ-15, EF-PJ-21. |
| M1 | US-33 | En tant que joueur ou MJ, je lance un jet simple ou je saisis mon dé. | EF-DES-01 à 05. |
| M2 | US-34 | En tant que MJ, je propose une modification structurelle à un joueur, qui l'accepte ou la refuse ; sa fiche reste jouable en attente de validation. | EF-PJ-16, EF-PJ-20. |
| M3 | US-35 | En tant que MJ, je prépare et clos mes séances, en PX ou en jalons, et les joueurs montent de niveau quand c'est déverrouillé. | EF-TAB-10, 11, EF-SEA-01 à 07. |
| M3 | US-36 | En tant que joueur, je suis le combat depuis mon téléphone et je réponds aux jets demandés. | EF-VJ-01 à 06. |
| M3 | US-37 | En tant que MJ, les règles de 0 PV, d'Assommer, de concentration et d'épuisement s'appliquent automatiquement, et je suis les réactions des PJ. | EF-PV-04 à 06, EF-CON-06, 07, EF-INI-08, 09. |
| M3 | US-38 | En tant que MJ, je déclenche un repos court ou long pour le groupe. | EF-PJ-19. |

## 14. Risques et points ouverts

Chaque risque a une solution concrète rattachée à un jalon ; la synchronisation et le homebrew de classes restent les deux chantiers à surveiller pour un développeur solo. Toutes les décisions de cadrage sont prises.

### 14.1 Risques et solutions

| Risque | Impact | Solution proposée | Jalon |
| --- | --- | --- | --- |
| DSL trop pauvre pour les classes et sous-classes homebrew | Fort | 1. Inventorier toutes les aptitudes du SRD 5.2.1 et les classer en trois niveaux : **calculable** (bonus, maîtrise, CA), **compteur** (utilisations par repos), **descriptif** (texte seul). 2. Le DSL couvre les deux premiers ; le troisième est toujours accepté et affiché sur la fiche. 3. Une aptitude homebrew non modélisable reste utilisable en mode descriptif. 4. Le DSL est versionné (`dsl_version` dans le manifeste) pour l'étendre sans casser les anciens packs. | M0 (inventaire), M4 |
| Synchronisation hors-ligne multi-utilisateurs | Fort | 1. PowerSync retenu ; intégration dès le début de M2, cible Web en premier. 2. Dès M1, toutes les écritures passent par une couche de dépôts unique, si bien que le moteur de synchronisation reste remplaçable. 3. Tests d'intégration dès la première semaine de M2 : fusion sans perte sur 3 appareils, persistance Web, coût estimé à 1 000 utilisateurs. 4. Plan B conservé en cas de blocage : synchronisation maison sur Supabase (journal de modifications par table, horloge hybride). 5. Le combat en événements immuables ne produit pas de conflit. | M1, M2 |
| SQLite WASM sur Web (performances, persistance) | Moyen | 1. Spike en M0 : 10 000 entités, démarrage, persistance après fermeture, test sur Safari. 2. Hébergement Web compatible avec les en-têtes COOP/COEP exigés par OPFS. 3. Repli IndexedDB automatique. 4. La synchronisation sert de sauvegarde en cas d'éviction. | M0 |
| Saisie du SRD 5.2.1 français (380 pages) | Moyen | 1. Source unique : le PDF officiel français, donc aucune traduction maison du contenu de règles. 2. Extraction semi-automatique (texte du PDF → un fichier JSON par entité) puis relecture ; la mise en page à deux colonnes impose une vérification humaine des profils de jeu et des tableaux. 3. Saisie au rythme des jalons : Guerrier, 4 Historiques et leurs dons d'origine en M0, toutes les classes, sorts et objets en M1, monstres en M3. 4. Glossaire figé sur le vocabulaire officiel français. 5. Pack anglais ultérieur à partir du SRD 5.2.1 anglais, avec les mêmes identifiants d'entités. | M0 à M3 |
| Coûts serveur d'une application gratuite avec comptes | Moyen | 1. Paliers gratuits Supabase et PowerSync au lancement. 2. Quotas par compte : portrait compressé en WebP de 200 Ko maximum, pack de 20 Mo maximum. 3. Suivi mensuel des coûts avec seuil d'alerte. 4. Si nécessaire, dons volontaires (Ko-fi, Patreon), sans fonctionnalité payante. | M2 |
| Contenu protégé publié en homebrew | Moyen | 1. Au MVP, partage uniquement par fichier entre utilisateurs, sans publication publique. 2. Attestation de l'auteur à chaque export. 3. Pour la bibliothèque V2 : conditions d'utilisation, bouton de signalement, retrait sous 72 h, conformité au règlement européen sur les services numériques (DSA). | M4, V2 |
| Usage de la marque D&D | Fort | 1. Nom retenu sans marque. 2. Checklist avant toute publication : nom, icône, captures et description ne citent que « compatible 5E » ou « compatible avec la cinquième édition ». 3. Déclaration d'attribution CC-BY officielle dans la description des stores, sans autre mention de Wizards of the Coast. 4. Recherche d'antériorité du nom (INPI, EUIPO) avant publication. | Avant M1 public |
| Inscription de mineurs | Moyen | 1. Âge minimum 15 ans (consentement numérique en France), date de naissance déclarative. 2. Aucune donnée sensible collectée. 3. Classification d'âge des stores adaptée (contenu fantastique, violence légère). | M2 |

### 14.2 Décisions prises

| Sujet | Décision | Impact dans le document |
| --- | --- | --- |
| Nom | Gestion de personnage compatible 5e | Titre, §1 |
| Co-MJ | Un seul MJ par table au MVP ; co-MJ envisagé plus tard | §2, lot V2 |
| Notifications push | En V1.5 | Lot V1.5 |
| Âge minimum | 15 ans | EF-CPT-01 |
| Personnage libre | Créé hors table, puis rattaché à une table avec revalidation | §4.3 |
| Visibilité des fiches entre joueurs | Résumé avec état de santé qualitatif par défaut ; fiches complètes en lecture seule sur réglage du MJ | EF-TAB-09, §2.2, §11.2 |
| Contenu de règles | SRD 5.2.1 en version française officielle ; pas de traduction maison | §1.3, §1.4, §6.4, risque « saisie du SRD » |
| Synchronisation | PowerSync retenu | §10.1, risque « synchronisation » |
| Jets de dés | Jet simple au MVP (saisie ou lancer par l'application) ; lanceur libre avec historique en V2 | §6.7, lot V2 |
| Égalités d'initiative | Règle du SRD 5.2.1 (MJ pour les monstres, joueurs pour les PJ, MJ entre les deux) | EF-INI-04 |
| Décisions de design et revue des maquettes | Les 24 décisions prises pendant le design et les points de la revue MJ et joueur (design/REVUE\_MJ.md) sont intégrés | §3, §4.1 à §4.4, §5, §6.2 à §6.8, §7, §11, §12, §13 |
| Sécurité du compte | Messages d'erreur qui ne révèlent pas l'existence d'un compte, réinitialisation encadrée, méthodes de connexion multiples, changement d'e-mail confirmé (décisions de design 36 à 40) | EF-CPT-07 à 11 |

### 14.3 Prochains arbitrages

Les prochaines décisions viendront des spikes techniques : performances et persistance de SQLite WASM sur Web (M0), puis premiers tests d'intégration PowerSync (M2).

- [x] **Table d'un MJ qui supprime son compte.** Décidé le 25 octobre 2026 : la table continue d'exister, mais elle n'a plus de MJ. Ses fiches ne peuvent donc plus être modifiées : elles restent consultables par leurs joueurs, en lecture seule. Pas de transfert de MJ au MVP. Un joueur ne peut pas non plus retirer son PJ d'une table sans MJ pour en refaire un personnage libre modifiable.
