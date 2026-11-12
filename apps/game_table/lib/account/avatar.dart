// Avatar du profil (US-40, EF-CPT-03) : image carrée compressée sur
// l'appareil, rangée en data URI dans profile.avatar, donc modifiable hors
// ligne et synchronisée avec le profil (EF-CPT-09).
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

/// Plafond de l'image enregistrée (cahier [A5]), vérifié aussi par le serveur.
const avatarMaxBytes = 200 * 1024;

const _side = 256;

/// Recadre au centre, réduit à 256 px et encode en JPEG sous 200 Ko ; null si
/// le fichier n'est pas une image lisible.
String? compressAvatar(Uint8List source) {
  final image = img.decodeImage(source);
  if (image == null) return null;
  final side = image.width < image.height ? image.width : image.height;
  final square = img.copyResizeCropSquare(
    image,
    size: _side > side ? side : _side,
  );
  for (var quality = 85; quality >= 25; quality -= 15) {
    final jpeg = img.encodeJpg(square, quality: quality);
    if (jpeg.length <= avatarMaxBytes) {
      return 'data:image/jpeg;base64,${base64Encode(jpeg)}';
    }
  }
  return null;
}

/// Ouvre le sélecteur d'images de l'appareil. Rend l'avatar compressé, null si
/// l'utilisateur annule ; lève [FormatException] si l'image est illisible.
Future<String?> pickAvatar() async {
  final file = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    // La plateforme réduit d'abord les grandes photos : le décodage en Dart
    // reste rapide, même sur le Web.
    maxWidth: 1024,
    maxHeight: 1024,
  );
  if (file == null) return null;
  // Hors du fil de l'interface quand la plateforme le permet (pas sur le Web).
  return await compute(compressAvatar, await file.readAsBytes()) ??
      (throw const FormatException('image illisible'));
}

/// Sélecteur d'avatar, remplacé dans les tests.
final avatarPickerProvider = Provider<Future<String?> Function()>(
  (ref) => pickAvatar,
);

/// Avatar d'un utilisateur : son image, sinon l'initiale de son pseudonyme,
/// sinon une icône.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    required this.pseudonym,
    required this.avatar,
    this.radius,
    super.key,
  });

  final String? pseudonym;
  final String? avatar;
  final double? radius;

  // ponytail: cache sans limite, quelques avatars par appareil ; LRU si ça grossit.
  static final _cache = <String, MemoryImage?>{};

  static MemoryImage? _image(String? avatar) {
    if (avatar == null) return null;
    return _cache.putIfAbsent(avatar, () {
      final data = Uri.tryParse(avatar)?.data;
      return data == null || !data.mimeType.startsWith('image/')
          ? null
          : MemoryImage(data.contentAsBytes());
    });
  }

  @override
  Widget build(BuildContext context) {
    final image = _image(avatar);
    final name = pseudonym?.trim() ?? '';
    return CircleAvatar(
      radius: radius,
      backgroundImage: image,
      // Une image reçue abîmée laisse un disque uni plutôt qu'une erreur.
      onBackgroundImageError: image == null ? null : (_, _) {},
      child: image != null
          ? null
          : name.isEmpty
          ? const Icon(Icons.person_outline)
          : Text(name.characters.first.toUpperCase()),
    );
  }
}
