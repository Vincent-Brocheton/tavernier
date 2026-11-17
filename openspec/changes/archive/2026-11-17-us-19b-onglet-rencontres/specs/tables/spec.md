## ADDED Requirements

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
