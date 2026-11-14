// Spec local-database : « Séances stockées » (US-35, EF-SEA-01, EF-SEA-02).
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
      late SessionStore store;
      setUp(() async {
        db = await open();
        store = SessionStore(db);
      });
      tearDown(() => db.close());

      Future<List<GameSession>> list() => store.watchList('t').first;

      test(
        'séances de la plus récente à la plus ancienne, numérotées',
        () async {
          final first = await store.create(
            tableId: 't',
            title: 'La passe de Varlande',
            date: DateTime(2026, 10, 9),
          );
          await store.create(
            tableId: 't',
            title: 'Le gué des Loups',
            date: DateTime(2026, 10, 23),
            status: SessionStatus.closed,
          );
          await store.create(
            tableId: 't',
            title: 'Le moulin de Brug',
            date: DateTime(2026, 10, 16),
          );
          await store.create(
            tableId: 'autre',
            title: 'Ailleurs',
            date: DateTime(2026, 10, 1),
          );

          expect(
            [for (final s in await list()) (s.number, s.title, s.status)],
            [
              (3, 'Le gué des Loups', SessionStatus.closed),
              (2, 'Le moulin de Brug', SessionStatus.planned),
              (1, 'La passe de Varlande', SessionStatus.planned),
            ],
          );
          expect((await list()).last.date, DateTime(2026, 10, 9));

          await store.update(first, date: DateTime(2026, 10, 30));
          expect(
            [for (final s in await list()) (s.number, s.title)],
            [
              (3, 'La passe de Varlande'),
              (2, 'Le gué des Loups'),
              (1, 'Le moulin de Brug'),
            ],
          );
        },
      );

      test('même jour : ordre de création', () async {
        await store.create(
          tableId: 't',
          title: 'A',
          date: DateTime(2026, 5, 29),
        );
        await store.create(
          tableId: 't',
          title: 'B',
          date: DateTime(2026, 5, 29),
        );
        expect(
          [for (final s in await list()) (s.number, s.title)],
          [(2, 'B'), (1, 'A')],
        );
      });

      test('création avec ses présences', () async {
        final id = await store.create(
          tableId: 't',
          title: 'Séance 1',
          date: DateTime(2026, 5, 29),
          present: ['aldric', 'mira'],
        );
        expect(await store.watchAttendance(id).first, {'aldric', 'mira'});
      });

      test('titre et état modifiés', () async {
        final id = await store.create(
          tableId: 't',
          title: 'Séance',
          date: DateTime(2026, 10, 30),
        );
        await store.update(
          id,
          title: 'Le relais du Sel',
          status: SessionStatus.inProgress,
        );
        final s = (await list()).single;
        expect(
          (s.title, s.status, s.tableId),
          ('Le relais du Sel', SessionStatus.inProgress, 't'),
        );
      });

      test('présences cochées, décochées, supprimées avec la séance', () async {
        final id = await store.create(
          tableId: 't',
          title: 'Le relais du Sel',
          date: DateTime(2026, 10, 30),
        );
        await store.setPresent(id, 'aldric', present: true);
        await store.setPresent(id, 'mira', present: true);
        await store.setPresent(id, 'mira', present: true);
        expect(await store.watchAttendance(id).first, {'aldric', 'mira'});

        await store.setPresent(id, 'mira', present: false);
        expect(await store.watchAttendance(id).first, {'aldric'});

        await store.delete(id);
        expect(await list(), isEmpty);
        final left = await db
            .customSelect('SELECT count(*) AS n FROM session_attendance')
            .getSingle();
        expect(left.read<int>('n'), 0);
      });
    });
  }
}
