// Spec local-database : la base s'ouvre et persiste sur chaque plateforme
// (Web : SQLite WASM ; Android, iOS : SQLite natif).
import 'package:dnd_data/dnd_data.dart';
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
    expect(hits.first.id, 'srd:feat:alert');
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
}
