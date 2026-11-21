// Une feuille qui se ferme après une écriture lente ne doit pas fermer la
// page d'en dessous si on l'a déjà refermée (cause de l'échec intermittent
// du parcours M3 sous Safari).
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/src/pop_if_current.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  for (final (guarded, survives) in [(true, true), (false, false)]) {
    testWidgets(
      guarded
          ? 'feuille refermée avant la fin de l’écriture : la page reste'
          : 'sans garde, le pop tardif ferme la page (le défaut)',
      (tester) async {
        final write = Completer<void>();
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (home) => TextButton(
                onPressed: () => Navigator.of(home).push(
                  MaterialPageRoute<void>(
                    builder: (page) => Scaffold(
                      body: Center(
                        child: TextButton(
                          onPressed: () => showModalBottomSheet<void>(
                            context: page,
                            builder: (sheet) => TextButton(
                              onPressed: () async {
                                await write.future;
                                if (guarded) {
                                  popIfCurrent(sheet);
                                } else if (sheet.mounted) {
                                  Navigator.pop(sheet);
                                }
                              },
                              child: const Text('Enregistrer'),
                            ),
                          ),
                          child: const Text('Combat'),
                        ),
                      ),
                    ),
                  ),
                ),
                child: const Text('Préparation'),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Préparation'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Combat'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Enregistrer'));
        await tester.pump();
        // Le voile est touché pendant l'écriture : la feuille se referme.
        await tester.tapAt(const Offset(10, 10));
        await tester.pump(const Duration(milliseconds: 50));
        // L'écriture finit pendant l'animation de sortie.
        write.complete();
        await tester.pumpAndSettle();
        expect(find.text('Combat'), survives ? findsOneWidget : findsNothing);
      },
    );
  }
}
