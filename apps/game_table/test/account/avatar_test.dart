// Spec account : « Avatar du profil » (US-40, EF-CPT-03).
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/avatar.dart';
import 'package:image/image.dart' as img;
import 'package:material_ui/material_ui.dart';

Uint8List _noise(int width, int height) {
  final image = img.Image(width: width, height: height);
  var seed = 7;
  for (final pixel in image) {
    seed = (seed * 1103515245 + 12345) & 0x7fffffff;
    pixel
      ..r = seed & 0xff
      ..g = (seed >> 8) & 0xff
      ..b = (seed >> 16) & 0xff;
  }
  return img.encodePng(image);
}

void main() {
  test('photo rectangulaire bruitée : carrée, 256 px, JPEG sous 200 Ko', () {
    final source = _noise(1600, 900);
    expect(source.length, greaterThan(avatarMaxBytes));
    final avatar = compressAvatar(source)!;
    expect(avatar, startsWith('data:image/jpeg;base64,'));
    final bytes = base64Decode(avatar.split(',').last);
    expect(bytes.length, lessThanOrEqualTo(avatarMaxBytes));
    final decoded = img.decodeJpg(bytes)!;
    expect((decoded.width, decoded.height), (256, 256));
  });

  test('fichier illisible : null', () {
    expect(compressAvatar(Uint8List.fromList(utf8.encode('bonjour'))), isNull);
  });

  testWidgets('avatar : image, sinon initiale, sinon icône', (tester) async {
    final avatar = compressAvatar(_noise(64, 64));
    Future<void> show(String? pseudonym, String? image) => tester.pumpWidget(
      MaterialApp(
        home: ProfileAvatar(pseudonym: pseudonym, avatar: image),
      ),
    );
    await show('hugo', avatar);
    expect(find.text('H'), findsNothing);
    expect(
      tester.widget<CircleAvatar>(find.byType(CircleAvatar)).backgroundImage,
      isA<MemoryImage>(),
    );
    await show('hugo', null);
    expect(find.text('H'), findsOneWidget);
    await show('hugo', 'pas une image');
    expect(find.text('H'), findsOneWidget);
    await show(null, null);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
  });
}
