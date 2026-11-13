# local-database Specification

## Purpose
Base SQLite locale de chaque appareil, source de vérité hors-ligne : elle porte le contenu de règles des packs et les données de jeu, permet la recherche dans le compendium et évolue par migrations versionnées.

## Requirements

### Requirement: Schéma version 1
Une base neuve SHALL contenir, en version de schéma 1, toutes les tables du contenu de règles (cahier §11.1, plus `language`, `tool`, `feature`, `species_trait`) et des données de jeu (cahier §11.2, plus `character_language`, `character_choice`).

#### Scenario: Base neuve
- **WHEN** la base est ouverte pour la première fois
- **THEN** sa version de schéma vaut 1 et chacune des tables attendues existe

### Requirement: Identifiant unique des données synchronisables
Chaque table de données de jeu SHALL avoir une clé primaire `id` textuelle unique, y compris les tables de liaison, pour rester synchronisable en M2.

#### Scenario: Tables de liaison
- **WHEN** la structure des tables `character_*`, `table_member` et `table_pack` est lue
- **THEN** chacune a une clé primaire réduite à la colonne `id`

### Requirement: Intégrité référentielle
La base SHALL refuser une ligne de contenu de règles qui cite un parent absent (clés étrangères actives), et supprimer en cascade les lignes dépendantes d'un pack supprimé. Sur les tables synchronisées, le serveur SHALL refuser les orphelins à l'envoi, et l'application SHALL supprimer elle-même les lignes dépendantes.

#### Scenario: Niveau de classe orphelin
- **WHEN** un niveau de classe est envoyé au serveur pour un personnage inexistant
- **THEN** le serveur le refuse

#### Scenario: Suppression d'un personnage
- **WHEN** un personnage est supprimé
- **THEN** ses valeurs de base, niveaux de classe, dons, bottes, objets, langues, choix et son état de jeu sont supprimés avec lui

### Requirement: Import et export d'un pack
Un pack SHALL s'écrire dans les tables normalisées et se relire à l'identique (manifeste et entités). Réimporter la même version d'un pack SHALL remplacer ses entités sans les dupliquer.

#### Scenario: Pack SRD aller-retour
- **WHEN** le pack SRD de l'échantillon (188 entités) est importé puis exporté
- **THEN** l'export est égal au pack d'origine, entité par entité

#### Scenario: Réimport
- **WHEN** le même pack est importé deux fois
- **THEN** la base contient une seule fois chacune de ses entités

### Requirement: Recherche plein texte
La base SHALL retrouver les entités de contenu par leur nom ou leur texte de règles (FTS5), sans tenir compte des accents ni de la casse, y compris sur un début de mot.

#### Scenario: Recherche avec ou sans accent
- **WHEN** on cherche « défense » puis « defense »
- **THEN** les deux recherches renvoient le don `srd:feat:defense`

#### Scenario: Début de mot
- **WHEN** on cherche « épé »
- **THEN** les résultats contiennent l'épée longue et l'épée courte

#### Scenario: Texte de règles
- **WHEN** on cherche « Classe d'armure »
- **THEN** les résultats contiennent le don Défense, dont le texte cite la Classe d'armure

### Requirement: Enregistrement d'un personnage
Un personnage stocké (`CharacterInput`) SHALL s'écrire dans les tables `character_*` et se relire à l'identique ; l'enregistrer de nouveau SHALL remplacer ses données sans doublon.

#### Scenario: Aldric aller-retour
- **WHEN** Aldric niveau 1 est enregistré puis relu
- **THEN** le personnage relu est égal à l'entrée de la fixture [D1]

#### Scenario: Modification
- **WHEN** Aldric est enregistré une seconde fois avec une botte de moins
- **THEN** la relecture donne deux bottes

### Requirement: Migrations versionnées
Chaque version du schéma SHALL être figée dans un instantané versionné ; un changement de schéma sans nouvelle version et sans migration testée SHALL faire échouer les tests.

#### Scenario: Instantané à jour
- **WHEN** les tests de migration s'exécutent
- **THEN** le schéma produit par le code est identique à l'instantané de la version 1

### Requirement: Base sur chaque plateforme
L'application SHALL ouvrir une base persistante sur Web (SQLite WASM), Android et iOS : écrire, fermer, rouvrir et relire les mêmes données, et y exécuter une recherche FTS5 (cahier ENF-06). Sur le Web, cela vaut pour les navigateurs d'ENF-06 : Chrome, Firefox, Safari et Edge.

#### Scenario: Web
- **WHEN** le test d'intégration s'exécute dans Chrome
- **THEN** la base est créée, un pack importé et retrouvé par recherche après réouverture

#### Scenario: Autres navigateurs
- **WHEN** le même test s'exécute dans Firefox, Safari et Edge
- **THEN** il réussit dans chacun

#### Scenario: Android
- **WHEN** le même test s'exécute sur un émulateur Android
- **THEN** il réussit

#### Scenario: iOS
- **WHEN** le même test s'exécute sur le simulateur iOS du job de CI macOS
- **THEN** il réussit

### Requirement: Stockage Web
Sur le Web, la base SHALL utiliser OPFS quand le navigateur le permet, et SHALL basculer seule sur IndexedDB sinon, sans perte de fonction (cahier §10.1, §14.1), que la page soit isolée ou non.

#### Scenario: Page isolée sur Chrome
- **WHEN** la base est ouverte dans Chrome avec les en-têtes COOP/COEP
- **THEN** le test d'intégration réussit

#### Scenario: Page non isolée
- **WHEN** la base est ouverte sans ces en-têtes
- **THEN** le test d'intégration réussit aussi

### Requirement: Stockage persistant
Sur le Web, l'application SHALL pouvoir demander au navigateur un stockage persistant et connaître sa réponse (accordé ou refusé), pour avertir l'utilisateur en cas de refus (cahier ENF-07). Hors Web, la demande SHALL répondre « accordé » sans rien faire.

#### Scenario: Demande sur le Web
- **WHEN** l'application demande un stockage persistant dans un navigateur qui répond sans demander à l'utilisateur (Chrome, Edge, Safari)
- **THEN** elle reçoit un booléen, sans erreur, que la demande soit accordée ou non

#### Scenario: Navigateur qui interroge l'utilisateur
- **WHEN** le navigateur affiche une invite (Firefox) et que l'utilisateur n'y répond pas
- **THEN** la demande reste en attente sans bloquer la base ni le reste de l'application

#### Scenario: Demande sur mobile
- **WHEN** l'application demande un stockage persistant sur Android ou iOS
- **THEN** la réponse est « accordé »

### Requirement: Volume de contenu
La base SHALL accepter un pack de 10 000 entités (plafond ENF-09), le restituer en entier et y chercher, sur le Web comme sur mobile. Les durées d'import, de réouverture et de recherche SHALL être mesurées et consignées par navigateur et par stockage.

#### Scenario: Pack de 10 000 entités
- **WHEN** un pack de 10 000 entités est importé, la base fermée puis rouverte
- **THEN** la base compte 10 000 entités pour ce pack, une recherche par nom retrouve une entité précise, et les durées mesurées sont écrites dans la sortie du test

### Requirement: Sorts dans la base
La base SHALL stocker les sorts d'un pack dans la table `spell` (cahier §11.1) et les restituer à l'identique à l'export. La recherche plein texte SHALL trouver un sort par son nom ou son texte.

#### Scenario: Aller-retour
- **WHEN** le pack SRD complet est importé puis exporté
- **THEN** chaque sort exporté est égal au sort d'origine

#### Scenario: Recherche
- **WHEN** on cherche « boule de feu »
- **THEN** le premier résultat est `srd:spell:fireball`, de type `spell`

### Requirement: Équipement de départ des classes en base
La base locale SHALL stocker les options d'équipement de départ de chaque classe importée, et SHALL les restituer à l'export du pack à l'identique.

#### Scenario: Aller-retour d'un pack
- **WHEN** on importe le pack SRD puis qu'on relit le Guerrier
- **THEN** ses trois options d'équipement de départ sont identiques à celles du pack

### Requirement: Objets magiques en base
La base locale SHALL stocker chaque objet magique importé et SHALL le restituer à l'export du pack à l'identique.

#### Scenario: Aller-retour
- **WHEN** on importe un pack qui contient un objet magique puis qu'on l'exporte
- **THEN** l'objet exporté est identique à l'objet importé

### Requirement: Caractéristique principale au choix en base
La base locale SHALL conserver `primary_abilities_any` à l'import et le restituer à l'export.

#### Scenario: Aller-retour
- **WHEN** on importe puis exporte le pack SRD
- **THEN** le Guerrier garde `primary_abilities_any` à vrai

### Requirement: Sorts, monnaie et détails du personnage
`CharacterStore` SHALL écrire et relire les sorts, la monnaie, l'alignement, l'apparence, la personnalité et l'histoire d'un personnage.

#### Scenario: Aller-retour
- **WHEN** on enregistre puis relit un personnage avec ces champs
- **THEN** l'entrée relue est identique, à l'ordre des sorts près

### Requirement: Liste des personnages
`CharacterStore` SHALL lister les personnages enregistrés, du plus ancien au plus récent, dans l'ordre de leurs identifiants UUID v7.

#### Scenario: Deux personnages
- **WHEN** deux personnages sont enregistrés
- **THEN** la liste les rend avec leur identifiant, le plus ancien d'abord

### Requirement: Identifiants des données utilisateur
Un identifiant de personnage SHALL être un UUID v7.

#### Scenario: Format
- **WHEN** on génère un identifiant
- **THEN** sa version vaut 7, sa variante RFC 9562, et il est unique

#### Scenario: Ordre chronologique
- **WHEN** on génère un identifiant à deux instants distincts
- **THEN** le plus récent se trie après le premier

### Requirement: État de jeu d'un personnage
Le dépôt SHALL écrire et relire les dépenses et la concentration d'un personnage, sans toucher à son entrée stockée.

#### Scenario: Relecture
- **WHEN** un état est enregistré puis relu
- **THEN** ses dépenses et sa concentration sont identiques

#### Scenario: Sans état
- **WHEN** un personnage n'a pas d'état enregistré
- **THEN** son état est vide

#### Scenario: Personnage réenregistré
- **WHEN** le personnage est enregistré après une montée de niveau
- **THEN** son état de jeu ne change pas

### Requirement: PV et Épuisement dans l'état de jeu
Le dépôt SHALL écrire et relire les PV actuels et l'Épuisement d'un personnage.

#### Scenario: Relecture
- **WHEN** un état avec des PV et de l'Épuisement est enregistré puis relu
- **THEN** ces valeurs sont identiques

#### Scenario: Personnage indemne
- **WHEN** aucun PV n'a été enregistré
- **THEN** les PV actuels sont vides, soit le maximum

### Requirement: Inspiration dans l'état de jeu
Le dépôt SHALL écrire et relire l'Inspiration héroïque d'un personnage.

#### Scenario: Relecture
- **WHEN** un état avec l'Inspiration est enregistré puis relu
- **THEN** il l'a toujours

### Requirement: Base locale PowerSync
La base locale SHALL être ouverte par PowerSync sur chaque plateforme. Les tables de données de jeu synchronisées (cahier §11.2) SHALL être celles de PowerSync, et leur schéma SHALL être dérivé des tables Drift.

#### Scenario: Tables synchronisées
- **WHEN** la base est ouverte pour la première fois
- **THEN** `character` et ses tables de contenu sont des vues PowerSync, et les tables du contenu de règles des tables ordinaires

#### Scenario: Écriture hors ligne
- **WHEN** un personnage est enregistré sans connexion
- **THEN** il se relit à l'identique et l'écriture attend dans la file d'envoi

### Requirement: Enregistrement par différence
`CharacterStore.save` SHALL n'écrire que les lignes de la fiche qui changent : insérer les nouvelles, supprimer celles qui disparaissent, modifier les autres.

#### Scenario: Rien ne change
- **WHEN** une fiche est réenregistrée à l'identique
- **THEN** aucune écriture n'attend dans la file d'envoi

#### Scenario: Un objet change
- **WHEN** seule la quantité d'un objet change
- **THEN** la file d'envoi ne contient que cette quantité

### Requirement: Dépôt des tables de jeu
`TableStore` SHALL créer une table, l'inscription de son MJ et ses packs dans une seule transaction, et SHALL lister les tables d'un utilisateur, MJ ou membre.

#### Scenario: Une transaction
- **WHEN** une table est créée
- **THEN** `game_table`, `table_member` et `table_pack` sont écrits ensemble, ou rien ne l'est

#### Scenario: Liste
- **WHEN** un utilisateur est MJ d'une table et membre d'une autre
- **THEN** la liste rend les deux, avec son rôle dans chacune

### Requirement: Invitations et membres
`TableStore` SHALL créer une invitation (code, expiration à 7 jours) en révoquant celle en cours, rendre l'invitation en cours d'une table, la révoquer, rendre les membres avec leur pseudonyme et retirer un membre.

#### Scenario: Une seule invitation en cours
- **WHEN** le MJ crée deux invitations de suite
- **THEN** seule la seconde est en cours

#### Scenario: Retrait
- **WHEN** le MJ retire un membre
- **THEN** il n'apparaît plus dans les membres

### Requirement: Tables réactives
Les listes de tables, une table, ses membres et son invitation SHALL se mettre à jour quand la base change, synchronisation comprise.

#### Scenario: Écriture locale
- **WHEN** une table est créée pendant qu'on observe la liste
- **THEN** la liste la montre sans nouvelle demande

### Requirement: Emplacements et fiches de table
`TableStore` SHALL créer, remplir et supprimer les emplacements de PJ, et les rendre avec le nom, le statut et le niveau de leur fiche, à jour à chaque changement. `CharacterStore` SHALL rattacher une fiche neuve à une table sans jamais effacer ce rattachement, changer son statut, et ne lister que les fiches de l'utilisateur et celles pas encore envoyées.

#### Scenario: Emplacement rempli
- **WHEN** une fiche de niveau 3 remplit un emplacement
- **THEN** l'emplacement rend son nom, son statut et le niveau 3

#### Scenario: Fiches d'un autre
- **WHEN** le MJ a reçu la fiche d'un joueur
- **THEN** elle n'apparaît pas dans sa liste de personnages

### Requirement: Identifiants ordonnés
Les identifiants UUID v7 créés par un même processus SHALL croître strictement, même dans la même milliseconde.

#### Scenario: Mille identifiants
- **WHEN** mille identifiants sont créés d'affilée
- **THEN** ils sont triés et tous différents

### Requirement: Revue et transfert des fiches de table
`CharacterStore` SHALL envoyer une fiche avec un message, la valider ou demander des corrections avec un commentaire, et la reprendre. `TableStore` SHALL transférer un emplacement et sa fiche à un autre joueur, et rendre le message et le commentaire avec chaque emplacement.

#### Scenario: Corrections
- **WHEN** le MJ demande des corrections avec un commentaire
- **THEN** l'emplacement rend le statut `changes_requested` et le commentaire

#### Scenario: Transfert
- **WHEN** le MJ transfère un emplacement
- **THEN** l'emplacement et la fiche ont le nouveau joueur

### Requirement: Personnages libres et historique
`CharacterStore` SHALL lister les personnages libres d'un utilisateur, en rattacher un à une table en l'envoyant au MJ, inscrire des dérogations dans l'historique et rendre l'historique, le plus récent d'abord.

#### Scenario: Rattachement
- **WHEN** un personnage libre est rattaché
- **THEN** il n'est plus libre, et son statut est `submitted`

#### Scenario: Historique
- **WHEN** deux dérogations sont inscrites
- **THEN** l'historique les rend, la dernière d'abord

### Requirement: Résumés publiés
`CharacterStore` SHALL publier le résumé d'une fiche de table seulement s'il a changé. `TableStore` SHALL rendre les résumés d'une table, à jour à chaque changement. L'état de santé qualitatif SHALL valoir « indemne » au maximum de PV, « blessé » au-dessus de la moitié, « gravement blessé » à la moitié ou moins.

#### Scenario: Seuils
- **WHEN** les PV sont 33/33, 17/33 puis 16/33
- **THEN** l'état est indemne, blessé, puis gravement blessé

#### Scenario: Rien de changé
- **WHEN** le même résumé est publié deux fois
- **THEN** une seule écriture part

### Requirement: Valeurs remplacées envoyées
Les modifications de la fiche et de son état de jeu SHALL partir avec les valeurs qu'elles remplacent sur l'appareil, pour que le serveur reconnaisse un conflit.

#### Scenario: PV modifiés
- **WHEN** l'appareil passe les PV de 29 à 39
- **THEN** l'envoi porte 39 et la valeur remplacée 29

### Requirement: Export des données de l'utilisateur
La base SHALL produire un export JSON de toutes les données de l'utilisateur qu'elle contient : profil, tables et leurs membres, emplacements, personnages avec tout leur détail et leur historique, PNJ, séances, rencontres et notes (ENF-10, ENF-12). L'export SHALL porter un format et une version, et la liste des packs de contenu installés sans leur contenu. Le contenu de règles SHALL en être exclu.

#### Scenario: Personnage exporté
- **WHEN** l'utilisateur a enregistré Aldric et exporte ses données
- **THEN** l'export contient la ligne d'Aldric dans `character`, ses niveaux de classe et ses objets, avec les valeurs enregistrées

#### Scenario: Contenu de règles exclu
- **WHEN** le pack SRD est installé
- **THEN** l'export cite le pack SRD et sa version, mais ne contient aucun sort, aucune classe ni aucun monstre

### Requirement: Import des données de l'utilisateur
La base SHALL importer un export `tavernier-export` en ajoutant les lignes absentes, table par table, et SHALL garder telle quelle toute ligne déjà présente avec le même identifiant (ENF-12). L'import SHALL rendre le nombre de lignes ajoutées et de lignes déjà présentes.

#### Scenario: Restauration sur une base vide
- **WHEN** l'export contenant Aldric est importé dans une base vide
- **THEN** Aldric, ses niveaux de classe et ses objets s'y retrouvent avec les mêmes valeurs

#### Scenario: Ligne déjà présente gardée
- **WHEN** Aldric a été renommé sur l'appareil après l'export, puis l'export est importé
- **THEN** Aldric garde son nouveau nom, et sa ligne compte parmi les lignes déjà présentes

### Requirement: Contrôle du fichier importé
La base SHALL contrôler le fichier en entier avant toute écriture et refuser, sans rien écrire, un fichier d'un autre format, d'une version plus récente ou aux lignes mal formées. Les tables et les colonnes inconnues SHALL être ignorées.

#### Scenario: Fichier refusé
- **WHEN** le fichier n'est pas un `tavernier-export`, vient d'une version plus récente ou contient une ligne sans identifiant
- **THEN** l'import est refusé et la base n'a pas changé

#### Scenario: Colonne inconnue
- **WHEN** une ligne porte une colonne que la base ne connaît pas
- **THEN** la colonne est ignorée et la ligne est importée
