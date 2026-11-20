// Spec local-database : « Notes en base » (US-26, EF-NOT-01, 02, 04, 06).
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

      test('écrite, modifiée, partagée, lue par les autres', () async {
        final store = NoteStore(db);
        final prep = await store.create(
          ownerUserId: 'camille',
          tableId: 't',
          scope: 'session',
          refId: 's12',
          title: 'Préparation de la séance 12',
          content: 'Varga attend au relais.',
        );
        final brug = await store.create(
          ownerUserId: 'hugo',
          tableId: 't',
          scope: 'npc',
          refId: 'brug',
          title: 'Dette envers Brug',
          content: 'Chasser les loups du gué.',
        );
        // Privées par défaut : chacun ne voit que les siennes.
        expect(
          [
            for (final n
                in await store.watchVisible('hugo', tableId: 't').first)
              n.id,
          ],
          [brug],
        );

        await store.update(
          brug,
          private: false,
          content: '**Deux** sur trois.',
        );
        final camille = await store.watchVisible('camille', tableId: 't').first;
        expect({for (final n in camille) n.id}, {prep, brug});
        final shared = camille.firstWhere((n) => n.id == brug);
        expect(shared.private, isFalse);
        expect(shared.ownerUserId, 'hugo');
        expect(shared.content, '**Deux** sur trois.');
        expect(shared.scope, 'npc');
        expect(shared.refId, 'brug');
        expect(shared.updatedAt, isNotNull);

        await store.delete(prep);
        expect(
          [for (final n in await store.watchVisible('camille').first) n.id],
          [brug],
        );
      });

      test('conflit gardé, puis fusionné (EF-NOT-06)', () async {
        final store = NoteStore(db);
        final id = await store.create(
          ownerUserId: 'hugo',
          tableId: 't',
          scope: 'session',
          content: 'Demander à Thalia.',
        );
        // Le serveur a gardé l'autre version.
        await db.customStatement(
          "UPDATE note SET conflict = 'Un collier gravé.' WHERE id = ?",
          [id],
        );
        expect(
          (await store.watchVisible('hugo').first).single.conflict,
          'Un collier gravé.',
        );
        await store.resolve(id, 'Un collier gravé. Demander à Thalia.');
        final note = (await store.watchVisible('hugo').first).single;
        expect(note.content, 'Un collier gravé. Demander à Thalia.');
        expect(note.conflict, isNull);
      });
    });
  }
}
