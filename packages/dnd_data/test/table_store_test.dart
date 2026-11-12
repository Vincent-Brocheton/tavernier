// Spec local-database : « Dépôt des tables de jeu » (US-13).
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:test/test.dart';

import 'support.dart';

const _gm = '00000000-0000-0000-0000-00000000000a';
const _player = '00000000-0000-0000-0000-00000000000b';
const _srd = (packId: '377190b6-2dfa-4b38-83be-1c4c6d0cf55d', version: '1.0.0');

const _brumeval = TableSettings(
  name: 'Les Marches de Brumeval',
  description: 'Campagne de frontière.',
  startingLevel: 3,
  statMethod: ScoreMethod.standardArray,
  longRest: LongRestRule.hitDice,
  hpOnLevel: HpOnLevel.roll,
  progression: Progression.milestones,
);

void main() {
  for (final (name, open) in [
    ('tables', () async => memoryDatabase()),
    ('PowerSync', powerSyncDatabase),
  ]) {
    group(name, () {
      late TavernierDatabase db;
      late TableStore store;
      setUp(() async {
        db = await open();
        store = TableStore(db);
      });
      tearDown(() => db.close());

      Future<int> count(String table) async =>
          (await db
                  .customSelect('SELECT count(*) AS n FROM $table')
                  .getSingle())
              .read<int>('n');

      test('création : table, MJ membre, pack SRD figé', () async {
        final id = await store.create(
          gmUserId: _gm,
          settings: _brumeval,
          packs: [_srd],
        );
        final table = await store.load(id, _gm);
        expect(table!.settings, _brumeval);
        expect(table.role, TableRole.gm);
        expect(table.archived, isFalse);
        expect(await count('table_member'), 1);
        final pack = await db
            .customSelect(
              'SELECT pack_id, pinned_version FROM table_pack '
              'WHERE table_id = ?',
              variables: [Variable.withString(id)],
            )
            .getSingle();
        expect(pack.data, {
          'pack_id': _srd.packId,
          'pinned_version': _srd.version,
        });
      });

      test('liste : MJ ou membre, la plus récente d\'abord', () async {
        final first = await store.create(
          gmUserId: _gm,
          settings: _brumeval,
          packs: [_srd],
        );
        final second = await store.create(
          gmUserId: _player,
          settings: _brumeval.copyWith(name: 'Autre table'),
          packs: [_srd],
        );
        await db.customStatement(
          'INSERT INTO table_member (id, table_id, user_id, role, joined_at) '
          "VALUES ('m9', ?, ?, 'player', '2026-11-11T10:00:00Z')",
          [second, _gm],
        );
        final list = await store.list(_gm);
        expect(list.map((t) => t.id), [second, first]);
        expect(list.map((t) => t.role), [TableRole.player, TableRole.gm]);
        expect(await store.list('inconnu'), isEmpty);
      });

      test('valeur inconnue : valeur par défaut, la liste tient', () async {
        await db.customStatement(
          'INSERT INTO game_table (id, gm_user_id, name, stat_method, '
          'long_rest_rule, hp_on_level_rule, progression_mode) '
          "VALUES ('t1', ?, 'Ancienne', 'point_buy', 'full', 'average', 'xp')",
          [_gm],
        );
        final [table] = await store.list(_gm);
        expect(table.settings.statMethod, ScoreMethod.pointBuy);
        expect(table.settings.longRest, LongRestRule.fullHitPoints);
      });

      test('table absente : null', () async {
        expect(await store.load('absente', _gm), isNull);
      });

      test('configuration : enregistrée, chaque changement daté', () async {
        final id = await store.create(
          gmUserId: _gm,
          settings: _brumeval,
          packs: [_srd],
        );
        await store.update(
          id,
          authorUserId: _gm,
          settings: _brumeval.copyWith(
            statMethod: ScoreMethod.pointBuy,
            startingLevel: 4,
          ),
          fullSheetsVisible: true,
        );
        final table = await store.load(id, _gm);
        expect(table!.settings.statMethod, ScoreMethod.pointBuy);
        expect(table.settings.startingLevel, 4);
        expect(table.fullSheetsVisible, isTrue);
        final activity = await store.activity(id);
        expect(
          {for (final a in activity) a.detail['field']: a.detail},
          {
            'statMethod': {
              'field': 'statMethod',
              'from': 'standardArray',
              'to': 'pointBuy',
            },
            'startingLevel': {'field': 'startingLevel', 'from': 3, 'to': 4},
            'fullSheetsVisible': {
              'field': 'fullSheetsVisible',
              'from': false,
              'to': true,
            },
          },
        );
        expect(activity.map((a) => a.kind).toSet(), {'config'});
        expect(activity.map((a) => a.authorUserId).toSet(), {_gm});
      });

      test('rien de changé : aucune activité', () async {
        final id = await store.create(
          gmUserId: _gm,
          settings: _brumeval,
          packs: [_srd],
        );
        await store.update(
          id,
          authorUserId: _gm,
          settings: _brumeval,
          fullSheetsVisible: false,
        );
        expect(await store.activity(id), isEmpty);
      });

      test('archivage puis restauration, datés', () async {
        final id = await store.create(
          gmUserId: _gm,
          settings: _brumeval,
          packs: [_srd],
        );
        await store.setArchived(id, archived: true, authorUserId: _gm);
        expect((await store.load(id, _gm))!.archived, isTrue);
        await store.setArchived(id, archived: false, authorUserId: _gm);
        expect((await store.load(id, _gm))!.archived, isFalse);
        // La plus récente d'abord.
        expect((await store.activity(id)).map((a) => a.kind), [
          'restored',
          'archived',
        ]);
      });

      test('invitation : une seule en cours, code sans ambiguïté', () async {
        final id = await store.create(
          gmUserId: _gm,
          settings: _brumeval,
          packs: [_srd],
        );
        final first = await store.createInvite(id);
        final second = await store.createInvite(id);
        expect(second.code, matches(RegExp(r'^[A-HJKMNP-Z2-9]{6}$')));
        expect(
          second.expiresAt.difference(DateTime.now()).inHours,
          inInclusiveRange(167, 168),
        );
        expect((await store.watchInvite(id).first)?.id, second.id);
        expect(second.id, isNot(first.id));

        await store.revokeInvite(second.id);
        expect(await store.watchInvite(id).first, isNull);
      });

      test('invitation expirée : plus en cours', () async {
        final id = await store.create(
          gmUserId: _gm,
          settings: _brumeval,
          packs: [_srd],
        );
        await db.customStatement(
          'INSERT INTO table_invite (id, table_id, code, expires_at, revoked) '
          "VALUES ('i1', ?, 'K7Q4ZP', '2026-01-01T00:00:00.000Z', 0)",
          [id],
        );
        expect(await store.watchInvite(id).first, isNull);
      });

      test('membres : MJ d\'abord, pseudonymes, retrait', () async {
        final id = await store.create(
          gmUserId: _gm,
          settings: _brumeval,
          packs: [_srd],
        );
        await db.customStatement(
          'INSERT INTO table_member (id, table_id, user_id, role, joined_at) '
          "VALUES ('m9', ?, ?, 'player', '2026-11-11T10:00:00Z')",
          [id, _player],
        );
        await db.customStatement(
          'INSERT INTO profile (id, pseudonym, locale, settings) '
          "VALUES (?, 'Camille', 'fr', '{}'), (?, 'Hugo', 'fr', '{}')",
          [_gm, _player],
        );
        final members = await store.watchMembers(id).first;
        expect(members.map((m) => (m.pseudonym, m.role)), [
          ('Camille', TableRole.gm),
          ('Hugo', TableRole.player),
        ]);

        await store.removeMember(id, _player);
        expect((await store.watchMembers(id).first).map((m) => m.userId), [
          _gm,
        ]);
      });

      test('emplacements : attribués, remplis, niveau et statut', () async {
        final id = await store.create(
          gmUserId: _gm,
          settings: _brumeval,
          packs: [_srd],
        );
        final first = await store.createSlot(id, _player);
        final second = await store.createSlot(id, _player);
        expect((await store.watchSlots(id).first).map((s) => s.id), [
          first,
          second,
        ]);

        await db.customStatement(
          'INSERT INTO character (id, table_id, kind, name, species_id, '
          "background_id, status) VALUES ('c1', ?, 'pc', 'Aldric', "
          "'srd:species:human', 'srd:background:soldier', 'draft')",
          [id],
        );
        await db.customStatement(
          'INSERT INTO character_class_level (id, character_id, class_id, '
          "level, position) VALUES ('l1', 'c1', 'srd:class:fighter', 2, 0), "
          "('l2', 'c1', 'srd:class:rogue', 1, 1)",
        );
        await store.fillSlot(first, 'c1');
        final [filled, empty] = await store.watchSlots(id).first;
        expect(filled.characterId, 'c1');
        expect(filled.characterName, 'Aldric');
        expect(filled.status, 'draft');
        expect(filled.level, 3);
        expect(filled.playerUserId, _player);
        expect(empty.characterId, isNull);

        await store.deleteSlot(second);
        expect((await store.watchSlots(id).first).length, 1);
      });

      test('liste réactive : une table créée apparaît', () async {
        final lists = store.watchList(_gm);
        final seen = expectLater(
          lists.map((list) => list.length),
          emitsThrough(1),
        );
        await store.create(gmUserId: _gm, settings: _brumeval, packs: [_srd]);
        await seen;
      });
    });
  }
}
