// Spec local-database : « PNJ stockés » (US-18, EF-PNJ-01 à 03, EF-ACT-06).
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
      late NpcStore store;
      setUp(() async {
        db = await open();
        store = NpcStore(db);
      });
      tearDown(() => db.close());

      Future<List<Npc>> list() => store.watchList('t').first;

      test(
        'liste par dossier, sans dossier en dernier, puis par nom',
        () async {
          await store.create(tableId: 't', name: 'Sergent Varel');
          await store.create(
            tableId: 't',
            name: 'Varga la Balafrée',
            folder: 'Guilde du Sel',
            monsterId: 'srd:monster:bandit-captain',
          );
          await store.create(
            tableId: 't',
            name: 'Maître Odran',
            folder: 'Relais du Sel',
          );
          await store.create(tableId: 'autre', name: 'Ailleurs');
          expect(
            [for (final n in await list()) n.name],
            ['Varga la Balafrée', 'Maître Odran', 'Sergent Varel'],
          );
        },
      );

      test('Indifférent par défaut, sans informations cachées', () async {
        final id = await store.create(tableId: 't', name: 'Bourgmestre Hesse');
        final npc = (await list()).single;
        expect(npc.id, id);
        expect(npc.attitude, Attitude.indifferent);
        expect(npc.hiddenInfo, isEmpty);
        expect(npc.folder, isNull);
      });

      test(
        'modification : attitude, dossier effacé, paliers dans l\'ordre',
        () async {
          final id = await store.create(
            tableId: 't',
            name: 'Varga',
            folder: 'Guilde du Sel',
          );
          await store.update(
            id,
            name: 'Varga la Balafrée',
            attitude: Attitude.hostile,
            statBlock: const {'ac': 15},
            hiddenInfo: const [
              HiddenInfo(dc: 10, text: 'Ancienne sergente de la garde.'),
              HiddenInfo(dc: 15, text: 'Porte le sceau de la Guilde du Sel.'),
            ],
          );
          var npc = (await list()).single;
          expect(npc.name, 'Varga la Balafrée');
          expect(npc.attitude, Attitude.hostile);
          expect(npc.statBlock, {'ac': 15});
          expect([for (final h in npc.hiddenInfo) h.dc], [10, 15]);
          expect(npc.hiddenInfo.first.revealed, isFalse);
          expect(npc.folder, 'Guilde du Sel');

          await store.update(id, clearFolder: true);
          npc = (await list()).single;
          expect(npc.folder, isNull);
          expect(npc.name, 'Varga la Balafrée');
        },
      );

      test('duplication : « (copie) », même dossier et même contenu', () async {
        final id = await store.create(
          tableId: 't',
          name: 'Varga la Balafrée',
          folder: 'Guilde du Sel',
          monsterId: 'srd:monster:bandit-captain',
          attitude: Attitude.hostile,
          hiddenInfo: const [HiddenInfo(dc: 20, text: 'Sœur du bourgmestre.')],
        );
        final copy = await store.duplicate(id);
        final npcs = await list();
        expect(
          [for (final n in npcs) n.name],
          ['Varga la Balafrée', 'Varga la Balafrée (copie)'],
        );
        final c = npcs.firstWhere((n) => n.id == copy);
        expect(
          (c.folder, c.monsterId, c.attitude, c.hiddenInfo.single.text),
          (
            'Guilde du Sel',
            'srd:monster:bandit-captain',
            Attitude.hostile,
            'Sœur du bourgmestre.',
          ),
        );
      });

      test('suppression', () async {
        final id = await store.create(tableId: 't', name: 'Brug');
        await store.delete(id);
        expect(await list(), isEmpty);
      });
    });
  }
}
