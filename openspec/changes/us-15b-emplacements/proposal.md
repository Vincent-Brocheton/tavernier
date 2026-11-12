# Proposal

## Why

Carte Trello [US-15](https://trello.com/c/UMRG1bPS), lot b. Cahier §4.3, points 1 à 4 :
1. le MJ crée un emplacement de PJ et l'attribue à un joueur de la table ;
2. le joueur lance la création guidée, contrainte par la configuration de la table (méthode de caractéristiques, niveau de départ, packs actifs) ;
3. la fiche finale est soumise au MJ ;
4. un joueur peut tenir plusieurs PJ si le MJ lui attribue plusieurs emplacements.

Les méthodes de caractéristiques existent depuis us-15a.

## What Changes

- **Emplacements de PJ** (`pc_slot`) : le MJ attribue un emplacement à un joueur depuis l'onglet Membres. Il peut en attribuer plusieurs, et retirer un emplacement encore vide. Chaque membre affiche ses emplacements : « emplacement libre », « Aldric Varenne (en création) », « (à valider) », « (validée) », « (corrections demandées) ».
- **« Mon personnage »** dans la vue d'ensemble de la table, pour le joueur. Selon l'état de l'emplacement :
  - vide : « Créer ma fiche » ;
  - rempli : nom, statut et lien vers la fiche ;
  - fiche en création : « Envoyer au MJ », une fois le niveau de départ atteint.
- **Création contrainte** : ouverte depuis un emplacement, la création impose la méthode de la table, sans choix. En génération aléatoire, « Lancer » ne sert qu'une fois. Le personnage est rattaché à la table et à l'emplacement. Si la table démarre au-dessus du niveau 1, le joueur monte sa fiche au niveau de départ avec l'assistant existant avant de l'envoyer.
- **Statuts de fiche** : `draft` (en création), `submitted` (à valider), `validated` (validée), `changes_requested` (corrections demandées), `archived` (us-14a).
  - Le serveur n'accepte que les passages permis :
    - le propriétaire envoie (`draft` ou `changes_requested` → `submitted`) ou reprend (`submitted` → `draft`) ;
    - le MJ valide ou demande des corrections sur une fiche envoyée.
  - L'interface du MJ vient au lot c.
- **Personnages** : l'onglet ne liste que les fiches de l'utilisateur, plus celles que la synchronisation apporte au MJ.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `tables` : emplacements, « Mon personnage », envoi au MJ.
- `sync-backend` : `pc_slot`, statuts de fiche, fiche rattachée à une table dont on est membre.
- `character-creation` : création contrainte par la table.
- `local-database` : emplacements, fiche rattachée, statut, liste par propriétaire.

## Impact

- `backend/supabase/migrations/`, `backend/supabase/tests/`, `backend/powersync/sync-config.yaml` et son test.
- `packages/dnd_data` : table `pc_slot` (instantané Drift v1 régénéré), `TableStore`, `CharacterStore`.
- `apps/game_table` : Membres, vue d'ensemble, création, onglet Personnages ; ARB ; tests.

**À faire par le porteur de projet** : redéployer les règles de synchronisation PowerSync (nouveau flux `pc_slot`).

**Hors périmètre :**
- **Validation ou corrections par le MJ** : lot c.
- **Transfert d'un PJ** d'un joueur à un autre (§4.3, point 5) : lot c, avec les actions du MJ sur une fiche.
- **Notification** au joueur : les notifications push sont en V1.5. Le joueur voit son emplacement dans la table.
- **Packs actifs** : seul le SRD existe d'ici M4.
