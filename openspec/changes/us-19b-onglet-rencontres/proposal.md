# Proposal

## Why

Carte Trello [US-19](https://trello.com/c/IlyBQSQV), lot b. Le MJ range ses rencontres par séance, les retrouve, les duplique et les déplace (**EF-REN-01**, **EF-REN-03**, **EF-REN-05**, planche [F5]). Le lot a a posé le moteur de difficulté et `EncounterStore`.

## What Changes

- **Onglet « Rencontres »** sur la page d'une table, pour le MJ seul, entre « Séances » et « PNJ ».
  - « Nouvelle rencontre » demande un titre et une séance (ou « Sans séance »), crée la rencontre en brouillon et ouvre sa page.
  - Recherche par titre ou par nom d'adversaire, sans tenir compte des accents ni de la casse.
  - Filtres « Toutes », « À jouer · n » (brouillon ou prête) et « Terminées ».
  - Sections, dans l'ordre : séances à venir (pas closes, par date), « Sans séance · en réserve », puis séances closes (de la plus récente à la plus ancienne). Chaque en-tête affiche « SÉANCE 12 », la date, puis « · close » pour une séance close.
- **Ligne d'une rencontre** :
  - titre ;
  - « Vétéran ×2, Bandit ×4 · 1 500 PX · Modérée » : les adversaires, leurs PX et la difficulté selon les PJ présents ;
  - badge d'état (« Brouillon », « Prête », « En cours », « Terminée ») ;
  - « Dupliquer », « Ranger dans une séance » pour une rencontre sans séance, et « Ouvrir ».
- **PJ présents** : ceux prévus à la séance de la rencontre, ou tous les personnages de la table pour une rencontre en réserve. Le niveau de chacun vient de son résumé.
- **Panneau latéral** (grand écran) :
  - « Dupliquer » et son explication ;
  - « Budget de difficulté » de la prochaine séance : Faible, Modérée et Élevée, avec « 4 personnages de niveau 5, selon les présences prévues. ».
- **Page d'une rencontre** (`/tables/:id/rencontres/:rencontre`) : titre, séance et adversaires, en lecture. Le lot c y ajoute la préparation.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `tables` : onglet des rencontres.

## Impact

- `apps/game_table/lib/encounters/` (nouveau) :
  - providers (adversaires, PX, difficulté) ;
  - onglet ;
  - feuilles « Nouvelle rencontre » et « Ranger dans une séance » ;
  - page de la rencontre.
- `tables/table_page.dart`, `main.dart` et ARB.
- Tests de widgets.

**Hors périmètre :**
- **Préparation** ([C1]) : ajout d'adversaires, jauge, mode de PV et PJ présents. C'est le lot c.
- **Combat** : « N rounds · 10 / 11 adversaires tombés », « Résumé » et « reportée de la séance 12 ». Ils viendront avec le combat (US-20 et suivantes).
- **« Séances précédentes (10) »** : toutes les séances sont affichées.
- **Pluriels des noms de monstres** (« 2 loups sanguinaires ») : le contenu n'a pas de pluriel ; la ligne écrit « Loup sanguinaire ×2 ».
