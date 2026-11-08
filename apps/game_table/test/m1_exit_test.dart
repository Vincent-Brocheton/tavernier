// Critère de sortie de M1 (cahier §3), sur une base en mémoire : le même
// parcours tourne en intégration sur chaque plateforme.
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/creation/creation_providers.dart';
import 'package:game_table/main.dart';
import 'package:material_ui/material_ui.dart';

import '../integration_test/support/m1_flow.dart';

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

void main() {
  for (final width in [390.0, 800.0, 1440.0, 1600.0]) {
    testWidgets('$width dp : création puis niveau 5', (tester) async {
      tester.view.physicalSize = Size(width, switch (width) {
        800 => 600,
        1600 => 881,
        _ => 1300,
      });
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final database = TavernierDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final store = CharacterStore(database);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            contentProvider.overrideWith((ref) => _content),
            characterStoreProvider.overrideWith((ref) => store),
          ],
          child: const GameTableApp(),
        ),
      );
      await createAndReachLevel5(tester);

      final saved = (await store.list()).single.character;
      expect(saved.name, m1Name);
      expect(saved.classLevels.single.level, 5);
      expect(saved.classLevels.single.subclassId, 'srd:subclass:champion');
      expect(computeSheet(saved, _content).integrityErrors, isEmpty);
    });
  }
}
