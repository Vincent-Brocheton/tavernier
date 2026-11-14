# Proposal

## Why

Carte Trello [US-35](https://trello.com/c/ClnskrIq), lot c. Le lot b a posé les séances et leurs présences dans la base. Il manque les écrans pour que le MJ crée et prépare ses séances (**EF-SEA-01**, **EF-SEA-02**, planches [S1], [S2], [S6], composant `SessionCard` §2.27).

## What Changes

- **Onglet « Séances »** sur la page d'une table, pour le MJ et pour les joueurs, juste après « Vue d'ensemble ».
- **Sans séance** ([S6]) :
  - « Aucune séance » et son texte ;
  - pour le MJ, « Préparer la séance 1 » et « Jouer tout de suite, sans préparation » ;
  - « 2 joueurs sur 4 ont une fiche validée. Les autres pourront rejoindre la séance en cours. »
- **Liste** ([S1]) :
  - sections « Prochaine » (séances préparées ou en cours) et « Passées » (closes) ;
  - une `SessionCard` par séance : pavé de date (« OCT. » et « 30 »), « Séance 12 », titre et badge d'état (« Préparée », « En cours », « Close ») ;
  - pour le MJ, « Nouvelle séance » et « Jouer tout de suite ».
- **Créer une séance** :
  - « Préparer la séance n » crée la séance n, préparée, datée du jour, avec tous les personnages de la table prévus, puis ouvre sa préparation ;
  - « Jouer tout de suite » crée une séance du jour, déjà en cours (décision de design 19).
- **Préparation** ([S2], `/tables/:id/seances/:session`, MJ) :
  - en-tête « Les Marches de Brumeval · Séance 12 », titre « Préparer la séance » ;
  - champs Titre et Date (sélecteur de date), enregistrés au fil de la saisie ;
  - « Présences prévues », avec un interrupteur par personnage (« Hugo · Guerrier 5 ») ;
  - « Ouvrir la séance », qui passe la séance en cours.
- **Joueur** : il voit la liste sans les boutons. Sur la prochaine séance, il lit « Personnage attendu : Aldric Varenne » ([S5]) quand son personnage est prévu.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `tables` : onglet des séances, création, préparation, présences.
- `local-database` : création d'une séance avec ses présences, en une fois.

## Impact

- `packages/dnd_data/` : `SessionStore.create(present: …)`, tests.
- `apps/game_table/` :
  - `sessions/` (nouveau) : onglet, carte, préparation, providers ;
  - route ;
  - onglet ajouté à `TablePage` ;
  - ARB ;
  - tests.

**Hors périmètre :**
- **Rencontres de la séance**, « Nouvelle rencontre » et budget : US-19 et suivantes.
- **Notes de séance** : carte des notes.
- **Encadré « Prête à jouer sans réseau »** : il liste les rencontres, les PNJ et les notes, qui n'existent pas encore.
- **Séance en cours** ([S3]), **clôture** ([S4], [S7]) et **panneau d'une séance close** ([S1], à droite) : lot d.
- **Vue détaillée du joueur** ([S5] : PX gagnés, notes) : lot e.
- **Suppression d'une séance** : aucun écran ne la montre.
