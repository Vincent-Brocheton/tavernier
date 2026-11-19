// Spec local-database : « Journal du combat stocké » (US-20).
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

Map<String, Object?> _combatant(String id, String label, int bonus) => {
  'id': id,
  'kind': 'monster',
  'label': label,
  'bonus': bonus,
};

void main() {
  for (final (name, open) in [
    ('tables', () async => memoryDatabase()),
    ('PowerSync', powerSyncDatabase),
  ]) {
    group(name, () {
      late TavernierDatabase db;
      late CombatStore store;
      late String encounter;
      setUp(() async {
        db = await open();
        store = CombatStore(db);
        encounter = await EncounterStore(db)
            .create(tableId: 't', title: 'Le relais du Sel');
      });
      tearDown(() => db.close());

      Future<EncounterStatus> status() async =>
          (await EncounterStore(db).watchList('t').first).single.status;

      test('journal daté de la rencontre (US-25, EF-LOG-01)', () async {
        await store.launch(encounter, authorUserId: 'camille', [
          (CombatEventType.combatantAdded, _combatant('ogre', 'Ogre', -1)),
          (CombatEventType.combatStarted, const {}),
        ]);
        final log = await store.watchLog(encounter).first;
        expect(
          [for (final e in log) e.event.type],
          [CombatEventType.combatantAdded, CombatEventType.combatStarted],
        );
        expect(
          DateTime.now().toUtc().difference(log.last.at).inMinutes,
          lessThan(1),
        );
      });

      test('Influences de toute la table, datées (US-24)', () async {
        final other = await EncounterStore(db)
            .create(tableId: 't', title: 'Les chiens de Varga');
        await store.append(other, authorUserId: 'camille', [
          (CombatEventType.influence, {'actor': 'aldric', 'success': false}),
          (CombatEventType.study, {'actor': 'thalia'}),
        ]);
        await store.append(encounter, authorUserId: 'camille', [
          (CombatEventType.influence, {'actor': 'mira', 'success': true}),
        ]);
        final events = await store
            .watchTableEvents('t', CombatEventType.influence)
            .first;
        expect(
          [for (final e in events) e.event.payload['actor']],
          ['aldric', 'mira'],
        );
        expect(
          DateTime.now().toUtc().difference(events.first.at).inMinutes,
          lessThan(1),
        );
      });

      test('lancement : en cours, combattants projetés', () async {
        await store.launch(encounter, authorUserId: 'camille', [
          (CombatEventType.combatantAdded, _combatant('aldric', 'Aldric', 4)),
          (CombatEventType.combatantAdded, _combatant('ogre', 'Ogre', -1)),
        ]);
        expect(await status(), EncounterStatus.running);
        final state = await store.watchState(encounter).first;
        expect([for (final c in state.combatants) c.label], ['Aldric', 'Ogre']);
      });

      test('journal dans l\'ordre, projection au deuxième tour', () async {
        await store.launch(encounter, authorUserId: 'camille', [
          (CombatEventType.combatantAdded, _combatant('a', 'A', 2)),
          (CombatEventType.combatantAdded, _combatant('b', 'B', 1)),
          (
            CombatEventType.initiativeRolled,
            {
              'unit': 'a',
              'dice': [10],
              'bonus': 2,
            },
          ),
          (
            CombatEventType.initiativeRolled,
            {
              'unit': 'b',
              'dice': [5],
              'bonus': 1,
            },
          ),
        ]);
        await store.append(encounter, authorUserId: 'camille', [
          (CombatEventType.combatStarted, const {}),
          (CombatEventType.turnAdvanced, const {}),
        ]);
        final events = await store.watchEvents(encounter).first;
        expect(
          [for (final e in events.skip(4)) e.type],
          [CombatEventType.combatStarted, CombatEventType.turnAdvanced],
        );
        final state = await store.watchState(encounter).first;
        expect((state.round, state.active), (1, 'b'));
      });

      test('fin : terminée', () async {
        await store.launch(encounter, authorUserId: 'camille', const []);
        await store.finish(encounter);
        expect(await status(), EncounterStatus.finished);
      });

      test('auteur et table recopiés', () async {
        await store.append(encounter, authorUserId: 'camille', [
          (CombatEventType.combatStarted, const {}),
        ]);
        final row = await db
            .customSelect(
              'SELECT table_id, author_user_id FROM encounter_event',
            )
            .getSingle();
        expect(
          (row.read<String>('table_id'), row.read<String>('author_user_id')),
          ('t', 'camille'),
        );
      });

      test('rencontre absente : erreur, rien d’écrit', () async {
        await expectLater(
          store.append('inconnue', authorUserId: 'camille', [
            (CombatEventType.combatStarted, const {}),
          ]),
          throwsStateError,
        );
      });
    });
  }
}
