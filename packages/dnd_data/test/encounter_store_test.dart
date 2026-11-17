// Spec local-database : « Rencontres stockées » (US-19, EF-REN-01, 02, 05).
import 'package:dnd_data/dnd_data.dart';
import 'package:test/test.dart';

import 'support.dart';

void main() {
  for (final (name, open) in [
    ('tables', () async => memoryDatabase()),
    ('PowerSync', powerSyncDatabase),
  ]) {
    group(name, () {
      late TavernierDatabase db;
      late EncounterStore store;
      setUp(() async {
        db = await open();
        store = EncounterStore(db);
      });
      tearDown(() => db.close());

      Future<List<Encounter>> list() => store.watchList('t').first;

      test('création : brouillon, PV moyens, en réserve', () async {
        final id = await store.create(tableId: 't', title: 'Embuscade');
        await store.create(tableId: 'autre', title: 'Ailleurs');
        final e = (await list()).single;
        expect(
          (e.id, e.title, e.sessionId, e.status, e.hpMode),
          (id, 'Embuscade', null, EncounterStatus.draft, HpMode.average),
        );
        expect(e.groups, isEmpty);
      });

      test('groupes : ajout qui cumule, ordre d\'ajout, quantité', () async {
        final id = await store.create(
          tableId: 't',
          title: 'Le relais du Sel',
          sessionId: 's12',
        );
        await store.addGroup(
          id,
          kind: 'monster',
          refId: 'srd:monster:dire-wolf',
        );
        await store.addGroup(id, kind: 'monster', refId: 'srd:monster:ogre');
        await store.addGroup(
          id,
          kind: 'monster',
          refId: 'srd:monster:dire-wolf',
        );
        await store.addGroup(id, kind: 'npc', refId: 'varga');
        var groups = (await list()).single.groups;
        expect(
          [for (final g in groups) (g.kind, g.refId, g.quantity)],
          [
            ('monster', 'srd:monster:dire-wolf', 2),
            ('monster', 'srd:monster:ogre', 1),
            ('npc', 'varga', 1),
          ],
        );
        expect(groups.first.sharedInitiative, isTrue);

        await store.updateGroup(
          groups.first.id,
          quantity: 3,
          sharedInitiative: false,
        );
        await store.removeGroup(groups[1].id);
        groups = (await list()).single.groups;
        expect(
          [for (final g in groups) (g.refId, g.quantity, g.sharedInitiative)],
          [('srd:monster:dire-wolf', 3, false), ('varga', 1, true)],
        );
      });

      test('quantité plafonnée à 30', () async {
        final id = await store.create(tableId: 't', title: 'Nuée');
        final group = await store.addGroup(
          id,
          kind: 'monster',
          refId: 'srd:monster:rat',
          quantity: 29,
        );
        await store.addGroup(
          id,
          kind: 'monster',
          refId: 'srd:monster:rat',
          quantity: 5,
        );
        expect((await list()).single.groups.single.quantity, 30);
        await store.updateGroup(group, quantity: 40);
        expect((await list()).single.groups.single.quantity, 30);
      });

      test('modification : séance, état, mode de PV, position', () async {
        final a = await store.create(tableId: 't', title: 'A');
        final b = await store.create(tableId: 't', title: 'B');
        await store.update(
          a,
          title: 'Le relais du Sel',
          sessionId: 's12',
          status: EncounterStatus.ready,
          hpMode: HpMode.roll,
          position: 2,
        );
        await store.update(b, position: 1);
        final [first, second] = await list();
        expect(first.id, b);
        expect(
          (second.title, second.sessionId, second.status, second.hpMode),
          ('Le relais du Sel', 's12', EncounterStatus.ready, HpMode.roll),
        );
        await store.update(a, clearSession: true);
        expect((await list()).firstWhere((e) => e.id == a).sessionId, isNull);
      });

      test('duplication : « (copie) », brouillon, mêmes groupes', () async {
        final id = await store.create(
          tableId: 't',
          title: 'Le relais du Sel',
          sessionId: 's12',
        );
        await store.update(
          id,
          status: EncounterStatus.ready,
          hpMode: HpMode.roll,
        );
        await store.addGroup(
          id,
          kind: 'monster',
          refId: 'srd:monster:veteran',
          quantity: 2,
        );
        await store.addGroup(id, kind: 'npc', refId: 'varga');
        final copy = await store.duplicate(id);
        final c = (await list()).firstWhere((e) => e.id == copy);
        expect(
          (c.title, c.sessionId, c.status, c.hpMode),
          (
            'Le relais du Sel (copie)',
            's12',
            EncounterStatus.draft,
            HpMode.roll,
          ),
        );
        expect(
          [for (final g in c.groups) (g.refId, g.quantity)],
          [('srd:monster:veteran', 2), ('varga', 1)],
        );
      });

      test('suppression : les groupes partent avec la rencontre', () async {
        final id = await store.create(tableId: 't', title: 'A');
        await store.addGroup(id, kind: 'monster', refId: 'srd:monster:wolf');
        await store.delete(id);
        expect(await list(), isEmpty);
        final left = await db
            .customSelect('SELECT count(*) AS n FROM encounter_group')
            .getSingle();
        expect(left.read<int>('n'), 0);
      });
    });
  }
}
