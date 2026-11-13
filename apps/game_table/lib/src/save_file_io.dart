import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

/// Passe le fichier à la feuille de partage du système (« Enregistrer dans
/// Fichiers », e-mail…). Faux si l'utilisateur a fermé la feuille sans rien
/// en faire.
Future<bool> saveFile(String name, Uint8List bytes, String mimeType) async =>
    (await SharePlus.instance.share(
      ShareParams(
        files: [XFile.fromData(bytes, mimeType: mimeType, name: name)],
        fileNameOverrides: [name],
      ),
    )).status !=
    ShareResultStatus.dismissed;
