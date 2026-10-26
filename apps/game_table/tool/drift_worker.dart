// Source du worker Web de drift, compilé dans web/drift_worker.js :
// fvm dart compile js -O4 tool/drift_worker.dart -o web/drift_worker.js
import 'package:drift/wasm.dart';

void main() => WasmDatabase.workerMainForOpen();
