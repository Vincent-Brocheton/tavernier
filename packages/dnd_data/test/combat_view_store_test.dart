// Spec local-database : « Vue du combat et demandes en base » (US-36).
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
      setUp(() async => db = await open());
      tearDown(() => db.close());

      test('vue publiée, relue, inchangée non réécrite, retirée', () async {
        final store = CombatViewStore(db);
        expect(
          await store.publish(
            encounterId: 'relais',
            tableId: 't',
            payload: {'round': 3},
          ),
          isTrue,
        );
        expect(
          await store.publish(
            encounterId: 'relais',
            tableId: 't',
            payload: {'round': 3},
          ),
          isFalse,
        );
        await store.publish(
          encounterId: 'relais',
          tableId: 't',
          payload: {'round': 4},
        );
        final view = await store.watch('relais').first;
        expect(view!.payload, {'round': 4});
        expect(
          (await store.watchTable('t').first).single.encounterId,
          'relais',
        );
        await store.remove('relais');
        expect(await store.watch('relais').first, isNull);
      });

      test('demandes envoyées dans l\'ordre, puis retirées', () async {
        final store = CombatRequestStore(db);
        final first = await store.send(
          encounterId: 'relais',
          tableId: 't',
          characterId: 'aldric',
          authorUserId: 'hugo',
          type: 'damage',
          payload: {'amount': 8},
        );
        await store.send(
          encounterId: 'relais',
          tableId: 't',
          characterId: 'aldric',
          authorUserId: 'hugo',
          type: 'heal',
        );
        final requests = await store.watch('relais').first;
        expect([for (final r in requests) r.type], ['damage', 'heal']);
        expect(requests.first.payload, {'amount': 8});
        await store.remove(first);
        expect(
          [for (final r in await store.watch('relais').first) r.type],
          ['heal'],
        );
      });
    });
  }
}
