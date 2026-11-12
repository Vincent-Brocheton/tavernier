# Proposal

## Why

Carte Trello [US-16](https://trello.com/c/eLEJkqIf), premier lot. Exigences ENF-02 :
- les modifications locales partent seules à la reconnexion ;
- un indicateur discret montre l'état : synchronisé, en attente, hors ligne, conflit.

Et ENF-03 : fusion champ par champ, sans perte.

Le moteur de synchronisation existe depuis T-05 : PowerSync, `apply_crud`, et un test de fusion à trois appareils d'un même compte. Il manque :
- l'indicateur ;
- le scénario du critère de sortie de M2 : un MJ et deux joueurs, sur trois appareils et trois comptes, qui modifient hors ligne puis se reconnectent.

US-16 est découpée en deux lots :
- **a** : indicateur et scénario à trois comptes ;
- **b** : conflits (« Conflit résolu », valeur écrasée barrée dans l'historique, le MJ prime en combat).

## What Changes

- **`SyncIndicator`** (dnd_ui_kit, COMPOSANTS §2.14) : une pilule de 32 dp, ou l'icône seule sur téléphone, avec un libellé lu par les lecteurs d'écran. États :
  - « Synchronisé » : nuage coché, couleur soins ;
  - « N modifications en attente » : nuage et flèche, couleur PV temporaires ;
  - « Hors-ligne » : nuage barré, neutre, avec « · N modifications en attente » s'il y en a ;
  - « Conflit résolu » : triangle, couleur alerte.

  Jamais bloquant.
- **État de l'app** : déduit de la connectivité, du statut de PowerSync (connecté ou en connexion) et du nombre d'écritures en attente (file `ps_crud`), à jour en continu. Affiché seulement avec un compte connecté. L'état « conflit » arrive au lot b.
- **Emplacement** : en haut à droite de l'écran principal, à côté du compte.
- **Scénario à trois comptes** (test d'intégration en CI, contre Supabase et PowerSync) :
  1. un MJ crée une table et une invitation ;
  2. deux joueurs la rejoignent et y créent leur fiche ;
  3. les trois appareils se déconnectent : le MJ change un réglage de la table, chaque joueur modifie sa fiche ;
  4. ils se reconnectent : chacun reçoit tout ce qu'il a le droit de lire, et rien n'est perdu ni écarté.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `ui-kit` : indicateur de synchronisation.
- `account` : état de synchronisation affiché.
- `sync-backend` : fusion entre trois comptes d'une table.

## Impact

- `packages/dnd_ui_kit` : `SyncIndicator` et son test.
- `packages/dnd_data/test/sync/merge_test.dart` : scénario à trois comptes.
- `apps/game_table` : fournisseurs d'état, écran principal ; ARB ; tests.

**Hors périmètre :**
- **État « conflit » et sa détection** : lot b.
- **Bandeau « Hors-ligne depuis 14 min… »** de [T7] : il détaille les modifications en attente par type, ce que la file de PowerSync ne fournit pas simplement. L'indicateur suffit à ENF-02.
