// Charge les polices embarquées avant chaque fichier de test : les mesures
// et les images de référence utilisent le vrai rendu, pas la police de test.
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  for (final (family, file) in [
    ('packages/dnd_ui_kit/Cinzel', 'fonts/Cinzel.ttf'),
    ('packages/dnd_ui_kit/RobotoFlex', 'fonts/RobotoFlex.ttf'),
  ]) {
    final bytes = File(file).readAsBytesSync();
    await (FontLoader(
      family,
    )..addFont(Future.value(ByteData.sublistView(bytes)))).load();
  }
  await testMain();
}
