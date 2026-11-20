// Spec local-database : « Repos de groupe en base » (US-38, EF-PJ-19).
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

      test('repos déclenché, reçu, terminé, clos', () async {
        final store = GroupRestStore(db);
        final id = await store.start(
          tableId: 't',
          sessionId: 's12',
          kind: 'short',
          characters: ['aldric', 'mira'],
        );
        final open = (await store.watchOpen('t').first).single;
        expect(open.id, id);
        expect(open.kind, 'short');
        expect(open.characters, ['aldric', 'mira']);
        expect(open.sessionId, 's12');
        expect((await store.watchForCharacter('aldric').first)?.id, id);
        expect(await store.watchForCharacter('thalia').first, isNull);

        await store.markDone(
          restId: id,
          tableId: 't',
          characterId: 'aldric',
          authorUserId: 'hugo',
          summary: {'hit_dice': 2},
        );
        expect(await store.watchForCharacter('aldric').first, isNull);
        expect((await store.watchForCharacter('mira').first)?.id, id);
        expect(await store.watchDone(id).first, {
          'aldric': {'hit_dice': 2},
        });

        await store.close(id);
        expect(await store.watchOpen('t').first, isEmpty);
        expect(await store.watchForCharacter('mira').first, isNull);
      });
    });
  }
}
