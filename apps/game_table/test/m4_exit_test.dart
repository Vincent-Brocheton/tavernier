// Critère de sortie de M4 (cahier §3) : une sous-classe homebrew créée par
// un MJ, importée par un autre, utilisée par un PJ. Trois appareils, chacun
// avec sa base : Inès crée et publie, Camille importe et active sur sa
// table, Hugo reçoit le pack et prend la sous-classe à la montée de niveau.
// La synchronisation des lignes de la table entre les appareils est
// simulée ; le fichier passe par le stockage des packs.
import 'dart:io';
import 'dart:typed_data';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/account_providers.dart';
import 'package:game_table/account/data_backup.dart' show saveFileProvider;
import 'package:game_table/creation/creation_providers.dart';
import 'package:game_table/homebrew/homebrew_page.dart';
import 'package:game_table/homebrew/import_page.dart';
import 'package:game_table/homebrew/pack_storage.dart';
import 'package:game_table/l10n/app_localizations.dart';
import 'package:game_table/sheet/level_up_page.dart';
import 'package:game_table/tables/table_packs.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

import 'fake_pack_storage.dart';

final _srd = readDndpack(
  File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync(),
);
const _subclass = 'gardiens-des-marches:subclass:gardien-du-rempart';
const _rempart =
    'gardiens-des-marches:feature:gardien-du-rempart-rempart-vivant';

/// Un appareil : sa base, l'écran [home] et ses remplacements. La montée de
/// niveau revient à la fiche par le routeur : [home] est alors sous
/// `/niveau`, et `/` affiche « fiche ».
Future<TavernierDatabase> _device(
  WidgetTester tester,
  Widget home, {
  TavernierDatabase? db,
  List<Object> overrides = const [],
}) async {
  final database = db ?? TavernierDatabase(NativeDatabase.memory());
  final router = GoRouter(
    initialLocation: '/niveau',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(body: Text('fiche')),
        routes: [
          GoRoute(
            path: 'niveau',
            builder: (_, _) => Scaffold(body: home),
          ),
        ],
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        srdPackProvider.overrideWith((ref) => _srd),
        ...overrides.cast(),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        theme: AppTheme.dark,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await _settle(tester);
  return database;
}

/// Laisse la base et la cryptographie finir, hors du temps simulé.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 4; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pumpAndSettle();
  }
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
  await tester.tap(finder.first);
  await _settle(tester);
}

/// Démonte l'appareil : drift ferme ses requêtes observées par un minuteur.
Future<void> _leave(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 1));
}

/// Le Guerrier de niveau 2 de Hugo, complet (Humain, Soldat), en cotte de
/// mailles et bouclier.
CharacterInput _hugo() => const CharacterInput(
  name: 'Brannoc',
  kind: 'pc',
  speciesId: 'srd:species:human',
  backgroundId: 'srd:background:soldier',
  baseScores: BaseScores(
    method: ScoreMethod.pointBuy,
    strength: 15,
    dexterity: 13,
    constitution: 14,
    intelligence: 8,
    wisdom: 12,
    charisma: 10,
  ),
  backgroundChoice: BackgroundChoice(
    distribution: '2-1',
    bonuses: {'str': 2, 'con': 1},
  ),
  classLevels: [
    ClassLevelInput(
      classId: 'srd:class:fighter',
      level: 2,
      skillChoices: ['srd:skill:perception', 'srd:skill:survival'],
    ),
  ],
  feats: [
    FeatInput(
      featId: 'srd:feat:savage-attacker',
      sourceType: 'background',
      sourceRef: 'srd:background:soldier',
    ),
    FeatInput(
      featId: 'srd:feat:alert',
      sourceType: 'species',
      sourceRef: 'srd:species:human',
    ),
    FeatInput(
      featId: 'srd:feat:defense',
      sourceType: 'class',
      sourceRef: 'srd:class:fighter',
    ),
  ],
  choices: {
    'skillful': ['srd:skill:insight'],
  },
  weaponMasteries: [
    WeaponMasteryInput(weaponId: 'srd:weapon:longsword', slotIndex: 0),
    WeaponMasteryInput(weaponId: 'srd:weapon:javelin', slotIndex: 1),
    WeaponMasteryInput(weaponId: 'srd:weapon:battleaxe', slotIndex: 2),
  ],
  items: [
    ItemInput(itemId: 'srd:armor:chain-mail', quantity: 1, equipped: true),
    ItemInput(itemId: 'srd:armor:shield', quantity: 1, equipped: true),
    ItemInput(itemId: 'srd:weapon:longsword', quantity: 1, equipped: true),
  ],
);

User _user(String id) => User(
  id: id,
  appMetadata: const {},
  userMetadata: const {},
  aud: 'authenticated',
  createdAt: '2026-11-21T10:00:00Z',
);

void main() {
  testWidgets('M4 : sous-classe créée par Inès, activée par Camille, prise '
      'par le Guerrier de Hugo', (tester) async {
    tester.view.physicalSize = const Size(390, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final storage = FakePackStorage();

    // 1. Inès crée la sous-classe, la publie et exporte le fichier signé.
    Uint8List? file;
    final ines = await _device(
      tester,
      const HomebrewPage(),
      overrides: [
        contentProvider.overrideWith((ref) => ActiveContent([_srd])),
        pseudonymProvider.overrideWith((ref) async => 'Inès'),
        saveFileProvider.overrideWithValue((name, bytes, _) async {
          file = bytes;
          return true;
        }),
      ],
    );
    addTearDown(ines.close);
    await _tap(tester, find.text('Nouveau pack'));
    await tester.enterText(find.byType(TextField), 'Gardiens des Marches');
    await _tap(tester, find.text('Créer'));
    await _tap(tester, find.widgetWithText(ActionChip, 'Sous-classe'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Nom *'),
      'Gardien du rempart',
    );
    await _tap(tester, find.text('Classe parente *'));
    await _tap(tester, find.text('Guerrier').last);
    for (final (level, name) in [
      (3, 'Rempart vivant'),
      (7, 'Pas de la sentinelle'),
      (10, 'Garde inflexible'),
      (15, 'Muraille vivante'),
      (18, 'Dernier rempart'),
    ]) {
      await _tap(tester, find.text('Ajouter une aptitude au niveau $level'));
      await tester.enterText(find.widgetWithText(TextField, 'Nom *'), name);
      await tester.enterText(
        find.widgetWithText(TextField, 'Texte (ce que le joueur lira)'),
        '$name : texte de l’aptitude.',
      );
      if (level == 3) {
        await _tap(tester, find.text('Ajouter un effet'));
        await _tap(tester, find.text('Modifier la Classe d’armure'));
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Valeur'),
          '1',
        );
        await tester.pumpAndSettle();
        await _tap(tester, find.text('Condition'));
        await _tap(tester, find.text('tant que vous portez un bouclier').last);
        await _tap(tester, find.text('Enregistrer l’effet'));
      }
      await _tap(tester, find.text('Enregistrer l’aptitude'));
    }
    await _tap(tester, find.text('Enregistrer'));
    expect(find.text('Prêt à publier'), findsOneWidget);
    await _tap(tester, find.text('Publier une version'));
    await _tap(tester, find.byType(CheckboxListTile));
    await _tap(tester, find.text('Publier la version 0.1.0'));
    await _tap(tester, find.text('Exporter le .dndpack signé (0.1.0)'));
    expect(file, isNotNull);
    await _leave(tester);

    // 2. Camille, MJ d'une autre table, importe le pack et l'active.
    final camille = TavernierDatabase(NativeDatabase.memory());
    addTearDown(camille.close);
    final table = (await tester.runAsync(
      () => TableStore(camille).create(
        gmUserId: 'camille',
        settings: const TableSettings(name: 'Les Marches de Brumeval'),
        packs: [(packId: _srd.manifest.id, version: _srd.manifest.version)],
      ),
    ))!;
    await _device(
      tester,
      Builder(
        builder: (context) => ListView(
          children: [
            Consumer(
              builder: (context, ref, _) => TextButton(
                onPressed: () => importPackFile(context, ref),
                child: const Text('Importer un pack'),
              ),
            ),
            TablePacksCard(tableId: table, editable: true),
          ],
        ),
      ),
      db: camille,
      overrides: [
        contentProvider.overrideWith((ref) => ActiveContent([_srd])),
        packStorageProvider.overrideWithValue(storage),
        openPackFileProvider.overrideWithValue(
          () async => (name: 'gardiens-0.1.0.dndpack', bytes: file!),
        ),
      ],
    );
    await _tap(tester, find.text('Importer un pack'));
    expect(find.text('Gardien du rempart'), findsOneWidget);
    expect(find.text('Signature : Inès'), findsOneWidget);
    await _tap(tester, find.widgetWithText(FilledButton, 'Importer'));
    await _tap(tester, find.text('Activer un pack'));
    await _tap(tester, find.text('Gardiens des Marches').last);
    final activated = (await tester.runAsync(
      () => TableStore(camille).watchActivePacks().first,
    ))!.where((p) => p.packId != _srd.manifest.id).single;
    expect(activated.version, '0.1.0');
    expect(storage.files.keys, [activated.fileSha256]);
    await _leave(tester);

    // 3. L'appareil de Hugo reçoit la table par la synchronisation (lignes
    // recopiées), puis le pack par le stockage, et monte son Guerrier.
    final hugo = TavernierDatabase(NativeDatabase.memory());
    addTearDown(hugo.close);
    await tester.runAsync(() async {
      final created = await TableStore(hugo).create(
        gmUserId: 'camille',
        settings: const TableSettings(name: 'Les Marches de Brumeval'),
        packs: [(packId: _srd.manifest.id, version: _srd.manifest.version)],
      );
      await TableStore(hugo).setPack(
        created,
        packId: activated.packId,
        version: activated.version,
        fileSha256: activated.fileSha256,
      );
      await CharacterStore(hugo).save('brannoc', _hugo(), tableId: created);
    });
    await _device(
      tester,
      Consumer(
        builder: (context, ref, _) {
          ref.listen(packDownloaderProvider, (_, _) {});
          return const LevelUpPage(id: 'brannoc');
        },
      ),
      db: hugo,
      overrides: [
        packStorageProvider.overrideWithValue(storage),
        currentUserProvider.overrideWith((ref) => Stream.value(_user('hugo'))),
      ],
    );
    for (var i = 0; i < 20; i++) {
      if (find.text('Gardien du rempart').evaluate().isNotEmpty) break;
      await _settle(tester);
    }
    expect(
      await tester.runAsync(
        () => PackLibrary(hugo).version(activated.packId, '0.1.0'),
      ),
      isNotNull,
    );

    // Niveau 3 : la sous-classe homebrew est proposée, puis prise.
    for (var step = 0; step < 3; step++) {
      if (find.text('Choisissez une sous-classe.').evaluate().isNotEmpty) {
        break;
      }
      await tester.tap(find.byType(FilledButton).last);
      await _settle(tester);
    }
    expect(find.text('Choisissez une sous-classe.'), findsOneWidget);
    await _tap(tester, find.textContaining('Gardien du rempart'));
    expect(find.text('Rempart vivant'), findsWidgets);
    // Jusqu'à « Enregistrer ».
    for (var step = 0; step < 4; step++) {
      if (find.text('fiche').evaluate().isNotEmpty) break;
      await tester.tap(find.byType(FilledButton).last);
      await _settle(tester);
    }
    final saved = (await tester.runAsync(
      () => CharacterStore(hugo).load('brannoc'),
    ))!;
    expect(saved.classLevels.single.level, 3);
    expect(saved.classLevels.single.subclassId, _subclass);

    // Sa fiche compte Rempart vivant : +1 CA, bouclier porté.
    final content = ProviderScope.containerOf(
      tester.element(find.text('fiche')),
    ).read(contentProvider).value!;
    final sheet = computeSheet(saved, content);
    expect(sheet.armorClass.sources.map((c) => c.label), contains(_rempart));
    await _leave(tester);
  });
}
