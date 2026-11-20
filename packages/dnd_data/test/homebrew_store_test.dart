// Spec local-database : « Brouillons homebrew » (US-27).
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

      test('aller-retour d\'un brouillon incomplet', () async {
        final store = HomebrewStore(db);
        const manifest = {
          'name': 'Gardiens des Marches',
          'namespace': 'gardiens',
          'version': '0.1.0',
        };
        final id = await store.create(manifest);
        expect((await store.watchAll().first).single.entities, isEmpty);

        // Un Historique à 2 caractéristiques : invalide, mais enregistré.
        final entities = [
          {
            'id': 'gardiens:feat:veilleur',
            'type': 'feat',
            'name': 'Veilleur',
            'data': {'category': 'origin'},
          },
          {
            'id': 'gardiens:background:sentinelle',
            'type': 'background',
            'name': 'Sentinelle',
            'data': {
              'abilities': ['srd:ability:str', 'srd:ability:con'],
            },
          },
        ];
        await store.save(id, manifest: manifest, entities: entities);
        final draft = (await store.watch(id).first)!;
        expect(draft.manifest, manifest);
        expect(draft.entities, entities);
        expect(draft.updatedAt, isNotNull);

        await store.delete(id);
        expect(await store.watch(id).first, isNull);
      });
    });
  }
}
