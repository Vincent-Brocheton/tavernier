import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/services.dart';

/// Pack SRD 5.2.1 (FR) embarqué dans l'application (ENF-05).
const srdPackAsset = 'assets/packs/srd-5.2.1-fr.dndpack';

/// Ouvre la base locale de la plateforme : SQLite natif sur mobile et
/// bureau, SQLite WASM sur le Web (OPFS, repli IndexedDB).
TavernierDatabase openTavernierDatabase({String name = 'tavernier'}) =>
    TavernierDatabase(
      driftDatabase(
        name: name,
        web: DriftWebOptions(
          sqlite3Wasm: Uri.parse('sqlite3.wasm'),
          driftWorker: Uri.parse('drift_worker.js'),
        ),
      ),
    );

/// Lit le pack SRD embarqué.
Future<ContentPack> loadSrdPack() async {
  final data = await rootBundle.load(srdPackAsset);
  return readDndpack(
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
  );
}
