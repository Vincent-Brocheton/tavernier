// Spec homebrew : « Contenu figé par fiche », « Alerte "contenu modifié" »
// (US-30 lot c2, EF-PJ-14, [H10]).
import 'dart:convert';
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/account_providers.dart';
import 'package:game_table/creation/creation_providers.dart';
import 'package:game_table/l10n/app_localizations.dart';
import 'package:game_table/sheet/content_change.dart';
import 'package:material_ui/material_ui.dart';

import 'fake_pack_storage.dart';

final _srd = readDndpack(
  File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync(),
);
const _gardiens = '0193a000-0000-7000-8000-000000000030';

/// Table figée en 0.1.0, bibliothèque en 0.1.0 et 0.2.0 (+2 CA), et la
/// fiche de Hugo, Gardien du rempart, qui a enregistré ses références.
Future<String> _seed(TavernierDatabase db) async {
  final table = await TableStore(db).create(
    gmUserId: '00000000-0000-0000-0000-00000000000a',
    settings: const TableSettings(name: 'Brumeval'),
    packs: [(packId: _srd.manifest.id, version: _srd.manifest.version)],
  );
  await PackLibrary(db).install(await gardiensFile(_srd.manifest, '0.1.0'));
  await PackLibrary(db)
      .install(await gardiensFile(_srd.manifest, '0.2.0', ac: 2));
  await TableStore(db).setPack(table, packId: _gardiens, version: '0.1.0');
  final v1 = ActiveContent([
    _srd,
    (await PackLibrary(db).version(_gardiens, '0.1.0'))!,
  ]);
  final hugo = sandboxCharacter(
    v1,
    classId: 'srd:class:fighter',
    level: 3,
    subclassId: 'gardiens:subclass:rempart',
    shield: true,
  );
  final store = CharacterStore(db);
  await store.save('hugo', hugo, tableId: table);
  for (final r in contentRefsToRecord(hugo, v1, const []).create) {
    await store.saveContentRef('hugo', r);
  }
  return table;
}

void main() {
  test('la table passe en 0.2.0 : la fiche garde +1 CA, puis migre', () async {
    final db = TavernierDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        srdPackProvider.overrideWith((ref) => _srd),
      ],
    );
    addTearDown(container.dispose);
    final table = await _seed(db);
    final hugo = (await CharacterStore(db).load('hugo'))!;

    Future<int> ac() async {
      container
        ..invalidate(characterContentProvider('hugo'))
        ..invalidate(contentChangesProvider('hugo'));
      return computeSheet(
        hugo,
        await container.read(characterContentProvider('hugo').future),
      ).armorClass.value;
    }

    // Cotte de mailles 16 + bouclier 2 + Rempart vivant.
    expect(await ac(), 19);
    await TableStore(db).setPack(table, packId: _gardiens, version: '0.2.0');
    for (var i = 0; i < 50; i++) {
      final content = await container.read(contentProvider.future);
      if (content.packs.any((p) => p.manifest.version == '0.2.0')) break;
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
    expect(await ac(), 19);
    final change = (await container.read(contentChangesProvider('hugo').future))
        .single;
    expect(change.before.name, 'Gardien du rempart');
    expect((change.fromVersion, change.toVersion), ('0.1.0', '0.2.0'));

    final content = await container.read(tableContentProvider(table).future);
    await CharacterStore(db).resolveContentChange(
      'hugo',
      change,
      migrate: true,
      snapshot: entitySnapshot(content, change.entityId),
    );
    expect(await ac(), 20);
    expect(
      await container.read(contentChangesProvider('hugo').future),
      isEmpty,
    );
  });

  testWidgets('[H10] l’alerte, la comparaison, « Garder la version »', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final db = TavernierDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await tester.runAsync(() async {
      final table = await _seed(db);
      await TableStore(db).setPack(table, packId: _gardiens, version: '0.2.0');
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          srdPackProvider.overrideWith((ref) => _srd),
          currentUserProvider.overrideWith((ref) => Stream.value(null)),
        ],
        child: MaterialApp(
          theme: AppTheme.dark,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: ContentChangeBanners(id: 'hugo')),
        ),
      ),
    );
    Future<void> settle() async {
      for (var i = 0; i < 4; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 30)),
        );
        await tester.pumpAndSettle();
      }
    }

    await settle();
    expect(
      find.text(
        'Contenu modifié : Gardien du rempart a changé dans la version de la '
        'table.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Voir et choisir'));
    await settle();
    expect(find.text('Gardien du rempart a changé'), findsOneWidget);
    expect(find.text('Votre version · 0.1.0'), findsOneWidget);
    expect(find.text('Nouvelle · 0.2.0'), findsOneWidget);
    expect(find.text('+1 CA avec un bouclier.'), findsOneWidget);
    expect(find.text('+2 CA avec un bouclier.'), findsOneWidget);
    await tester.tap(find.text('Garder la version 0.1.0'));
    await settle();
    expect(find.text('Voir et choisir'), findsNothing);
    final log = await tester.runAsync(
      () => db
          .customSelect(
            "SELECT diff FROM character_change_log WHERE character_id = 'hugo'",
          )
          .get(),
    );
    expect(
      (jsonDecode(log!.single.read<String>('diff')) as Map)['choice'],
      'keep',
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
