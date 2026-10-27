// Outils, matériel d'aventurier et équipement de départ des classes (change
// t-04e-equipement). Valeurs relues dans docs/srd/FR_SRD_CC_v5.2.1.pdf, page
// imprimée citée.
import 'dart:io';
import 'dart:isolate';

import 'package:dnd_content/dnd_content.dart';
import 'package:path/path.dart' as p;
import 'package:srd_builder/src/equipment_extractor.dart';
import 'package:srd_builder/srd_builder.dart';
import 'package:test/test.dart';

final _root = p.normalize(
  p.join(
    p.fromUri(
      Isolate.resolvePackageUriSync(Uri.parse('package:srd_builder/'))!,
    ),
    '..',
  ),
);

/// Classes dans l'ordre du SRD, celui des lignes « Équipement de départ ».
const _classOrder = [
  'barbarian',
  'bard',
  'cleric',
  'druid',
  'sorcerer',
  'fighter',
  'wizard',
  'monk',
  'warlock',
  'paladin',
  'ranger',
  'rogue',
];

void main() {
  late Map<String, ContentEntity> byId;
  late String layout;

  setUpAll(() {
    final loaded = loadSources(Directory(p.join(_root, 'sources')));
    expect(loaded.issues, isEmpty);
    byId = {for (final e in loaded.pack!.entities) '${e.id}': e};
    layout = File(
      p.join(_root, '..', '..', 'docs', 'srd', 'FR_SRD_CC_v5.2.1.txt'),
    ).readAsStringSync();
  });

  ToolData tool(String slug) => byId['srd:tool:$slug']!.data as ToolData;
  List<StartingEquipmentOption> options(String slug) =>
      (byId['srd:class:$slug']!.data as ClassData).startingEquipment;

  test('37 outils, chacun avec son texte (p. 98-100)', () {
    final tools = byId.values.where((e) => e.type == 'tool').toList();
    expect(tools, hasLength(37));
    expect(tools.where((t) => t.textFr?.isNotEmpty != true), isEmpty);
    expect(
      tools.where((t) => (t.data as ToolData).category == ToolCategory.artisan),
      hasLength(17),
    );
  });

  test('Outils de voleur (p. 100) : Dextérité, 0,5 kg, 25 po', () {
    final thieves = tool('thieves-tools');
    expect(thieves.ability, ContentId.tryParse('srd:ability:dexterity'));
    expect((thieves.weightKg, thieves.costCp), (0.5, 2500));
  });

  test('luth (p. 100) : instrument de Charisme, 1 kg, 35 po', () {
    final lute = tool('lute');
    expect(lute.category, ToolCategory.musicalInstrument);
    expect(lute.ability, ContentId.tryParse('srd:ability:charisma'));
    expect((lute.weightKg, lute.costCp), (1.0, 3500));
  });

  test('Acide (p. 100) : 0,5 kg, 25 po, texte de l’attaque', () {
    final acid = byId['srd:item:acid']!;
    final data = acid.data as ItemData;
    expect((data.weightKg, data.costCp), (0.5, 2500));
    expect(acid.textFr, contains('jet de sauvegarde de Dextérité'));
    expect(acid.textFr, contains('2d6 dégâts d’acide'));
  });

  test('chaque ligne de gear.tsv figure dans le tableau en page', () {
    final gear = readGear(File(p.join(_root, 'extract', 'gear.tsv')));
    expect(gear, hasLength(95));
    expect([
      for (final g in gear)
        if (!gearRowInLayout(layout, g.label, g.weight, g.price)) g.slug,
    ], isEmpty);
    for (final g in gear) {
      expect(byId['srd:item:${g.slug}']?.textFr, isNotEmpty, reason: g.slug);
    }
  });

  test('Guerrier (p. 56) : options A, B et C, la C en or seul', () {
    final fighter = options('fighter');
    expect([for (final o in fighter) o.gold], [4, 11, 155]);
    expect(fighter.last.items, isEmpty);
    expect(
      fighter.first.items
          .singleWhere((q) => '${q.item}' == 'srd:weapon:javelin')
          .quantity,
      8,
    );
  });

  test('Barde (p. 35) : instrument de musique à choisir', () {
    final a = options('bard').first;
    expect(a.items.map((q) => ('${q.item}', q.quantity)), [
      ('srd:armor:leather', 1),
      ('srd:weapon:dagger', 2),
      ('srd:item:entertainers-pack', 1),
    ]);
    expect(a.toolChoice, [ToolCategory.musicalInstrument]);
    expect(a.gold, 19);
  });

  test('or et nombre d’options de chaque classe relus dans le SRD', () {
    final lines = layout.split('\n');
    final starts = [
      for (final (i, l) in lines.indexed)
        if (RegExp(r'Équipement\s+Choisissez').hasMatch(l)) i,
    ];
    expect(starts, hasLength(_classOrder.length));
    for (final (k, slug) in _classOrder.indexed) {
      final window = lines.skip(starts[k]).take(14).join('\n');
      final opts = options(slug);
      expect(
        window.contains('Choisissez entre A, B et C'),
        opts.length == 3,
        reason: slug,
      );
      for (final (i, o) in opts.indexed) {
        final letter = String.fromCharCode(0x41 + i);
        // Une option d'objets se termine par « et N po ; » : la colonne
        // voisine peut s'intercaler après « et », jamais avant le « ; ».
        final pattern = o.items.isEmpty
            ? '\\($letter\\)\\s+${o.gold}\\s+po'
            : '(?<![\\d,])${o.gold}\\s+po\\s+;';
        expect(window, matches(RegExp(pattern)), reason: '$slug ($letter)');
      }
    }
  });
}
