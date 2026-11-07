// Spec character-sheet : « Inventaire », « Harmonisation », « Monnaie ».
import 'dart:convert';
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/creation/creation_providers.dart';
import 'package:game_table/l10n/app_localizations.dart';
import 'package:game_table/sheet/inventory_tab.dart';
import 'package:game_table/sheet/sheet_page.dart';
import 'package:material_ui/material_ui.dart';

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

final _aldric = () {
  const dir = '../../packages/dnd_rules/test/fixtures/d1';
  Map<String, Object?> read(String name) =>
      jsonDecode(File('$dir/$name.json').readAsStringSync())
          as Map<String, Object?>;
  final input = {...read('aldric_n1')['input']! as Map<String, Object?>};
  final changes = read('aldric_n5')['input_changes']! as Map<String, Object?>;
  changes.forEach((key, value) {
    if (key.endsWith('_added')) {
      final base = key.substring(0, key.length - '_added'.length);
      input[base] = [
        ...(input[base] as List<Object?>? ?? const []),
        ...value! as List<Object?>,
      ];
    } else {
      input[key] = value;
    }
  });
  return CharacterInput.fromJson(input);
}();

late CharacterStore _store;

/// La fiche relue après chaque enregistrement, comme `SheetPage`.
class _Live extends ConsumerWidget {
  const _Live();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider('a')).asData?.value;
    if (character == null) return const SizedBox();
    return InventoryTab(
      id: 'a',
      content: _content,
      character: character,
      sheet: computeSheet(character, _content),
    );
  }
}

Future<void> _settle(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 50)),
  );
  await tester.pumpAndSettle();
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 50)),
  );
  await tester.pumpAndSettle();
}

Future<void> _open(
  WidgetTester tester,
  CharacterInput character, {
  double width = 1440,
}) async {
  tester.view.physicalSize = Size(width, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final database = TavernierDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  _store = CharacterStore(database);
  await tester.runAsync(() => _store.save('a', character));
  await tester.pumpWidget(
    ProviderScope(
      overrides: [characterStoreProvider.overrideWith((ref) => _store)],
      child: MaterialApp(
        theme: AppTheme.dark,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: _Live()),
      ),
    ),
  );
  await _settle(tester);
}

Future<CharacterInput> _saved(WidgetTester tester) async =>
    (await tester.runAsync(() => _store.load('a')))!;

void main() {
  testWidgets('Aldric [P15] : monnaie, équipé, sac', (tester) async {
    await _open(tester, _aldric);
    expect(find.text('46'), findsOneWidget);
    expect(find.text('po'), findsOneWidget);
    expect(find.text('Harmonisation 0 / 3'), findsOneWidget);
    expect(find.text('ÉQUIPÉ'), findsOneWidget);
    expect(find.text('SAC'), findsOneWidget);
    expect(find.text('Cotte de mailles'), findsOneWidget);
    expect(find.text('× 4'), findsOneWidget);
  });

  testWidgets('format téléphone', (tester) async {
    await _open(tester, _aldric, width: 390);
    expect(tester.takeException(), isNull);
  });

  testWidgets('monnaie modifiée', (tester) async {
    await _open(tester, _aldric);
    await tester.tap(find.text('46'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '40');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enregistrer'));
    await _settle(tester);
    final saved = await _saved(tester);
    expect(saved.coins['gp'], 40);
    expect(saved.coins['sp'], 12);
  });

  testWidgets('monnaie invalide : enregistrement bloqué', (tester) async {
    await _open(tester, _aldric);
    await tester.tap(find.text('46'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'beaucoup');
    await tester.pumpAndSettle();
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Enregistrer'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('ranger une armure', (tester) async {
    await _open(tester, _aldric);
    await tester.tap(find.text('Cotte de mailles'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ranger au sac'));
    await _settle(tester);
    final saved = await _saved(tester);
    expect(
      saved.items
          .singleWhere((i) => i.itemId == 'srd:armor:chain-mail')
          .equipped,
      isFalse,
    );
  });

  testWidgets('s\'harmoniser', (tester) async {
    await _open(tester, _aldric);
    await tester.tap(find.text('Cape de protection'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('S’harmoniser'));
    await _settle(tester);
    expect(find.text('Harmonisation 1 / 3'), findsOneWidget);
  });

  testWidgets('harmonisation pleine : bouton désactivé', (tester) async {
    const cloak = 'srd:magic-item:cloak-of-protection';
    await _open(
      tester,
      _aldric.copyWith(
        items: const [
          ItemInput(itemId: cloak, quantity: 1, attuned: true),
          ItemInput(itemId: cloak, quantity: 1, attuned: true),
          ItemInput(itemId: cloak, quantity: 1, attuned: true),
          ItemInput(itemId: cloak, quantity: 1),
        ],
      ),
    );
    await tester.tap(find.text('Cape de protection').last);
    await tester.pumpAndSettle();
    final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
    expect(button.onPressed, isNull);
    expect(find.textContaining('emplacements d’harmonisation'), findsOneWidget);
  });

  testWidgets('quantité : retirer le dernier retire l\'objet', (tester) async {
    await _open(tester, _aldric);
    await tester.tap(find.text('Hache d’armes'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('En retirer un'));
    await _settle(tester);
    expect(find.text('Hache d’armes'), findsNothing);
  });

  testWidgets('ajouter un objet', (tester) async {
    await _open(tester, _aldric);
    await tester.tap(find.text('Ajouter un objet'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'dague');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dague').first);
    await _settle(tester);
    expect(find.text('Dague'), findsOneWidget);
    final saved = await _saved(tester);
    expect(saved.items.last.itemId, 'srd:weapon:dagger');
  });

  testWidgets('recherche sans résultat', (tester) async {
    await _open(tester, _aldric);
    await tester.tap(find.text('Ajouter un objet'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();
    expect(find.text('Aucun objet trouvé.'), findsOneWidget);
  });

  testWidgets('sac vide', (tester) async {
    await _open(tester, _aldric.copyWith(items: const []));
    expect(find.text('Votre sac est vide.'), findsOneWidget);
  });
}
