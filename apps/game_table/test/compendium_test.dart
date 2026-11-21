// Spec homebrew : « Compendium » (US-30 lot c1, EF-CMP-01, [K1], [K2],
// [K5]) ; « Bannir une entité pour une table » (EF-HB-10).
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/account_providers.dart';
import 'package:game_table/compendium/compendium_page.dart';
import 'package:game_table/creation/creation_providers.dart';
import 'package:game_table/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

import 'fake_pack_storage.dart';

final _srd = readDndpack(
  File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync(),
);
const _me = User(
  id: '00000000-0000-0000-0000-00000000000a',
  appMetadata: {},
  userMetadata: {},
  aud: 'authenticated',
  createdAt: '2026-11-11T10:00:00Z',
);

void main() {
  group('recherche', () {
    final entries = compendiumEntries([_srd]);

    test('sans accents ni casse, filtrée, triée', () {
      final names = [
        for (final r in searchCompendium(
          entries,
          'BOUCLIER',
          CompendiumFilter.spells,
        ))
          r.entity.name,
      ];
      expect(names, containsAll(['Bouclier', 'Bouclier de la foi']));
      expect(names, isNot(contains('Fire')));
      expect(
        searchCompendium(
          entries,
          'invisibilite',
          CompendiumFilter.all,
        ).map((r) => r.entity.name),
        contains('Invisibilité'),
      );
      expect(searchCompendium(entries, '  ', CompendiumFilter.all), isEmpty);
    });

    test('vouliez-vous dire : la faute de frappe retrouve son sort', () {
      expect(editDistance('invisibilte', 'invisibilite'), 1);
      expect(editDistance('', 'abc'), 3);
      expect(
        suggestions(entries, 'invisibilté').map((r) => r.entity.name),
        contains('Invisibilité'),
      );
      expect(suggestions(entries, 'ab'), isEmpty);
    });

    test('badge de source et résumé', () {
      expect(sourceBadge(_srd.manifest), 'SRD');
      expect(
        sourceBadge(
          _srd.manifest.copyWith(origin: PackOrigin.imported, version: '2.2.0'),
        ),
        '${_srd.manifest.author} 2.2.0',
      );
    });
  });

  group('écran', () {
    late TavernierDatabase db;
    late String table;

    Future<void> pump(WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      db = TavernierDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await tester.runAsync(() async {
        table = await TableStore(db).create(
          gmUserId: _me.id,
          settings: const TableSettings(name: 'Les Marches de Brumeval'),
          packs: [(packId: _srd.manifest.id, version: _srd.manifest.version)],
        );
        await TableStore(db).banEntity(table, 'srd:spell:invisibility');
        // Un pack de la bibliothèque, inactif pour la table.
        await PackLibrary(db)
            .install(await gardiensFile(_srd.manifest, '0.1.0'));
      });
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            srdPackProvider.overrideWith((ref) => _srd),
            currentUserProvider.overrideWith((ref) => Stream.value(_me)),
          ],
          child: MaterialApp(
            theme: AppTheme.dark,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              ...GlobalMaterialLocalizations.delegates,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(body: CompendiumPage()),
          ),
        ),
      );
      await settle(tester);
    }

    testWidgets('[K2] table : SRD, banni, pack inactif signalé', (
      tester,
    ) async {
      await pump(tester);
      expect(
        find.textContaining('Contexte : Les Marches de Brumeval'),
        findsOneWidget,
      );
      await tester.enterText(find.byType(TextField), 'invisibilité');
      await settle(tester);
      expect(find.text('Invisibilité'), findsOneWidget);
      expect(find.text('BANNI'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'rempart');
      await settle(tester);
      // Le pack des Gardiens n'est pas actif sur la table.
      expect(find.text('Aucun résultat'), findsOneWidget);
      await tester.tap(find.text('Chercher dans tous mes packs'));
      await settle(tester);
      expect(find.text('Gardien du rempart'), findsOneWidget);
      expect(find.text('Inès 0.1.0'), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('[K5] faute de frappe : l’entité bannie reste lisible', (
      tester,
    ) async {
      await pump(tester);
      await tester.enterText(find.byType(TextField), 'invisibilté');
      await settle(tester);
      expect(find.text('Aucun résultat'), findsOneWidget);
      expect(find.text('Vouliez-vous dire'), findsOneWidget);
      expect(find.text('BANNI ICI'), findsOneWidget);
      await tester.tap(find.text('Invisibilité'));
      await settle(tester);
      expect(
        find.text(
          'Le MJ l’a banni pour cette table. Vous pouvez toujours lire sa fiche.',
        ),
        findsWidgets,
      );
      expect(find.text('Source : ${_srd.manifest.name}'), findsOneWidget);
      await unmount(tester);
    });
  });
}

/// Laisse la base finir ses écritures, hors du temps simulé du test.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 3; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pumpAndSettle();
  }
}

/// Démonte l'app : drift ferme ses requêtes observées par un minuteur.
Future<void> unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 1));
}
