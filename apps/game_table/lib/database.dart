import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Pack SRD 5.2.1 (FR) embarqué dans l'application (ENF-05).
const srdPackAsset = 'assets/packs/srd-5.2.1-fr.dndpack';

/// Ouvre la base locale de la plateforme par PowerSync (T-05) : SQLite
/// natif sur mobile et bureau, SQLite WASM sur le Web, où PowerSync choisit
/// OPFS si le navigateur le permet, IndexedDB sinon.
TavernierDatabase openTavernierDatabase({String name = 'tavernier'}) =>
    openPowerSyncTavernierDatabase(
      kIsWeb
          ? Future.value('$name.db')
          : getApplicationSupportDirectory().then(
              (dir) => p.join(dir.path, '$name.db'),
            ),
    );

/// Lit le pack SRD embarqué.
Future<ContentPack> loadSrdPack() async {
  final data = await rootBundle.load(srdPackAsset);
  return readDndpack(
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
  );
}
