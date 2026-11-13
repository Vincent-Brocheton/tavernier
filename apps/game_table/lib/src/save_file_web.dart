import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart';

/// Télécharge le fichier par un lien temporaire.
Future<bool> saveFile(String name, Uint8List bytes, String mimeType) async {
  final url = URL.createObjectURL(
    Blob([bytes.toJS].toJS, BlobPropertyBag(type: mimeType)),
  );
  (document.createElement('a') as HTMLAnchorElement)
    ..href = url
    ..download = name
    ..click();
  // Révoqué plus tard : certains navigateurs lisent le lien après le clic.
  Timer(const Duration(minutes: 1), () => URL.revokeObjectURL(url));
  return true;
}
