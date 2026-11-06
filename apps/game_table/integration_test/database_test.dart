// Spec local-database : la base s'ouvre et persiste sur chaque plateforme
// (Web : SQLite WASM ; Android, iOS : SQLite natif).
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/database.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('importe le pack SRD, cherche, rouvre et relit', (_) async {
    final name = 'test_${DateTime.now().microsecondsSinceEpoch}';
    final pack = await loadSrdPack();

    var db = openTavernierDatabase(name: name);
    await PackStore(db).importPack(pack);
    final hits = await PackStore(db).search('vigil');
    expect(hits.map((h) => h.id), contains('srd:feat:alert'));
    await db.close();

    db = openTavernierDatabase(name: name);
    addTearDown(db.close);
    final reread = await PackStore(db).exportPack(pack.manifest.id);
    expect(reread!.manifest.toJson(), pack.manifest.toJson());
    expect(
      {for (final e in reread.entities) e.id: e.toJson()},
      {for (final e in pack.entities) e.id: e.toJson()},
    );
  });

  testWidgets('enregistre un personnage, rouvre et le retrouve', (_) async {
    final name = 'test_${DateTime.now().microsecondsSinceEpoch}';
    final id = uuidV7();
    const character = CharacterInput(
      name: 'Aldric',
      kind: 'pc',
      speciesId: 'srd:species:human',
      backgroundId: 'srd:background:soldier',
      baseScores: BaseScores(
        method: ScoreMethod.pointBuy,
        strength: 15,
        dexterity: 15,
        constitution: 15,
        intelligence: 8,
        wisdom: 8,
        charisma: 8,
      ),
      backgroundChoice: BackgroundChoice(
        distribution: '2-1',
        bonuses: {'str': 2, 'con': 1},
      ),
      classLevels: [ClassLevelInput(classId: 'srd:class:wizard', level: 1)],
      spells: SpellsInput(
        cantrips: ['srd:spell:light'],
        prepared: ['srd:spell:sleep'],
        spellbook: ['srd:spell:sleep', 'srd:spell:shield'],
      ),
      coins: {'gp': 18},
      alignment: 'LB',
    );

    var db = openTavernierDatabase(name: name);
    await CharacterStore(db).save(id, character);
    await db.close();

    db = openTavernierDatabase(name: name);
    addTearDown(db.close);
    final characters = await CharacterStore(db).list();
    expect(characters.single.id, id);
    expect(characters.single.character, character);
  });
}
