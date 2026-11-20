# Proposal

## Why

Carte Trello US-36 : la vue combat du joueur. Exigences : **EF-VJ-01** à **EF-VJ-06** ; cahier §6.2 et §6.3 ; planches [J1], [J2] et [J3].

Le journal de combat est réservé au MJ, par la RLS `is_table_gm` et le flux PowerSync `tables_mj`. Le téléphone du joueur ne peut donc ni suivre le combat ni y répondre. Lui envoyer le journal pour le filtrer sur place exposerait ce qu'il ne doit pas voir : le journal lui-même, l'Étude, les PV et la CA des adversaires, les adversaires cachés (EF-VJ-03, EF-ACT-07).

Décision du porteur de projet du 20 novembre 2026 : deux tables serveur, sur le motif des résumés de fiche (US-15).
- **`combat_view`** : la vue filtrée d'une rencontre en cours, calculée et publiée par l'appareil du MJ, lue par les membres de la table.
- **`combat_request`** : ce que le joueur envoie pour son PJ (jet saisi, dégâts, soins, ressource). L'appareil du MJ l'applique au journal, et la version du MJ prime (EF-VJ-06).

Les adversaires sont visibles par défaut, et le MJ masque ceux qui sont cachés (décision du même jour).

La carte est livrée en trois lots.

## What Changes

### Lot a : données et projection

- **Serveur** :
  - `combat_view` : `id` (celui de la rencontre), `table_id`, `payload` en JSON, `updated_at`. Les membres et le MJ la lisent ; le MJ seul l'écrit, et pas sur une table archivée.
  - `combat_request` : `id`, `encounter_id`, `table_id`, `character_id`, `author_user_id`, `type`, `payload`, `created_at`. Le propriétaire du PJ l'insère pour son PJ de la table ; le MJ et l'auteur la lisent ; le MJ peut la supprimer.
  - Les règles PowerSync et les tests de droits (pgTAP, flux).
- **Base locale** : les deux tables synchronisées, au schéma v3, avec leur migration.
- **Dépôts** :
  - `CombatViewStore` : publier, et suivre la vue d'une rencontre en cours ;
  - `CombatRequestStore` : envoyer une demande, et suivre celles d'une rencontre.
- **Moteur** :
  - l'événement `combatant_hidden` : un adversaire masqué ou rendu visible ;
  - `playerCombatView(state)` : la projection filtrée, sérialisable en JSON.

### Lot b : côté MJ

- L'appareil du MJ publie la vue à chaque changement du combat.
- Il applique les demandes des joueurs au journal, avec la référence de la demande.
- La carte d'un adversaire porte « Masquer aux joueurs ».

### Lot c : écran du joueur ([J1], [J2], [J3])

- **Bascule** : le joueur passe sur « En combat » quand une rencontre où figure son PJ est en cours, et un geste le ramène à sa fiche (EF-VJ-01).
- **Bandeau** : le round, le tour actif et « vous jouez dans n tours ». À son tour, « C'est votre tour », avec l'économie d'actions à cocher (EF-VJ-02).
- **Ordre simplifié** : les PJ avec leur santé, les adversaires sous leur seul nom (EF-VJ-03).
- **Son PJ** : PV avec Dégâts, Soins et PV temp. ; états, concentration et réaction ; attaques, sorts et ressources (EF-VJ-04).
- **Jets demandés** : concentration et jet contre la mort (EF-VJ-05).
- **Hors-ligne** : le dernier état connu et « Hors-ligne : dites vos changements au MJ » (EF-VJ-06).

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `sync-backend` : `combat_view`, `combat_request`.
- `local-database` : schéma v3.
- `encounters` : masquage d'un adversaire, vue du joueur, demandes.

## Impact

- **Serveur** : une migration, deux tests pgTAP, `sync-config.yaml` et `sync_test.sh`.
- **`dnd_data`** : tables, migration v3, dépôts.
- **`dnd_rules`** : `player_view.dart`.
- **App** : lots b et c.

## Hors périmètre

- **Notifications** quand le combat commence : l'écran bascule à l'ouverture de l'app ou pendant son usage.
- **Sauvegarde à refaire demandée au joueur** : la fin de tour du MJ ([C6]) reste le lieu de ces jets. Seuls la concentration et les jets contre la mort sont demandés au téléphone.
