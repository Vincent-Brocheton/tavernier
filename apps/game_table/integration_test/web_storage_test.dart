// Spike T-01 (spec local-database : « Stockage Web », « Volume de contenu »).
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/database.dart';
import 'package:game_table/persistent_storage.dart';
import 'package:integration_test/integration_test.dart';

/// `opfs` pour exiger OPFS (job Chrome isolé) ; vide sinon.
const _expectedStorage = String.fromEnvironment('T01_EXPECTED_STORAGE');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  String dbName() => 't01_${DateTime.now().microsecondsSinceEpoch}';

  testWidgets('le stockage Web choisi est connu', (_) async {
    WasmDatabaseResult? result;
    final db = openTavernierDatabase(
      name: dbName(),
      onWebResult: (r) => result = r,
    );
    addTearDown(db.close);
    await db.customSelect('SELECT 1').get();

    if (!kIsWeb) {
      expect(result, isNull);
      return;
    }
    expect(result, isNotNull);
    debugPrint(
      'T01 stockage=${result!.chosenImplementation.name} '
      'manquants=${result!.missingFeatures.map((f) => f.name).join(',')}',
    );
    if (_expectedStorage == 'opfs') {
      expect(result!.chosenImplementation.name, startsWith('opfs'));
    }
  });

  testWidgets('le stockage persistant se demande sans erreur', (_) async {
    final granted = await requestPersistentStorage();
    debugPrint('T01 persistant=$granted');
    if (!kIsWeb) expect(granted, isTrue);
  });
}
