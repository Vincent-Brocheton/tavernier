// Espèces et dons du SRD (change t-04d-origines). Valeurs relues dans
// docs/srd/FR_SRD_CC_v5.2.1.pdf, page imprimée citée.
import 'dart:io';
import 'dart:isolate';

import 'package:dnd_content/dnd_content.dart';
import 'package:path/path.dart' as p;
import 'package:srd_builder/src/origin_extractor.dart';
import 'package:srd_builder/src/srd_origins.dart';
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

void main() {
  late Map<String, ContentEntity> byId;

  setUpAll(() {
    final loaded = loadSources(Directory(p.join(_root, 'sources')));
    expect(loaded.issues, isEmpty);
    byId = {for (final e in loaded.pack!.entities) '${e.id}': e};
  });

  SpeciesData species(String slug) =>
      byId['srd:species:$slug']!.data as SpeciesData;
  List<Map<String, Object?>> effects(String id) => [
    for (final e in byId[id]!.effects) {'op': e.op, ...e.args, 'when': e.when},
  ];

  test('9 espèces, toutes Humanoïdes, chacune avec ses traits', () {
    final all = byId.values.where((e) => e.type == 'species').toList();
    expect(all, hasLength(9));
    for (final s in all) {
      final data = s.data as SpeciesData;
      expect(data.creatureType, 'humanoid');
      expect(data.traits, isNotEmpty);
      for (final t in data.traits) {
        expect(byId['$t']?.textFr, isNotEmpty, reason: '$t');
      }
    }
  });

  test('Nain (p. 90) : 30 pieds, Vision dans le noir 120, Ténacité', () {
    expect(species('dwarf').speedFeet, 30);
    expect(effects('srd:feature:dwarf-darkvision').single['range'], 120);
    expect(
      effects('srd:feature:dwarf-dwarven-toughness').single['per_level'],
      1,
    );
  });

  test('Goliath (p. 89) : 35 pieds, Ascendance gigante par Repos long', () {
    expect(species('goliath').speedFeet, 35);
    final ancestry = effects('srd:feature:goliath-giant-ancestry').single;
    expect(ancestry['max'], {'ref': 'proficiency_bonus'});
    expect(ancestry['recharge'], [
      {'on': 'long_rest', 'amount': 'all'},
    ]);
    expect(
      byId['srd:feature:goliath-giant-ancestry']!.textFr,
      contains('Tonnerre des cieux (géants des tempêtes).'),
    );
  });

  test('Lignage drow (p. 88) : 120 pieds, sorts aux niveaux 1, 3 et 5', () {
    final lineage = effects('srd:feature:elf-elven-lineage').single;
    final drow = (lineage['options']! as List<Object?>).first! as List;
    expect(drow, [
      {'op': 'grant_sense', 'sense': 'darkvision', 'range': 120},
      {'op': 'grant_spell', 'spell': 'srd:spell:dancing-lights'},
      containsPair('when', {'level': 3}),
      containsPair('when', {'level': 5}),
    ]);
    expect(drow[2], containsPair('spell', 'srd:spell:faerie-fire'));
    expect(drow[3], containsPair('spell', 'srd:spell:darkness'));
  });

  test('tailles au choix (p. 90-91) : Humain et Tieffelin', () {
    expect(species('human').sizes, ['M', 'P']);
    expect(species('tiefling').sizes, ['M', 'P']);
    expect(species('gnome').sizes, ['P']);
  });

  test('17 dons, dont 7 Faveurs épiques de niveau 19 (p. 93-94)', () {
    final feats = [
      for (final e in byId.values)
        if (e.type == 'feat') e.data as FeatData,
    ];
    expect(feats, hasLength(17));
    final boons = feats.where((f) => f.category == FeatCategory.epicBoon);
    expect(boons, hasLength(7));
    expect(boons.map((b) => b.prerequisites?.minLevel).toSet(), {19});
    expect(
      (byId['srd:feat:boon-of-spell-recall']!.data as FeatData)
          .prerequisites
          ?.feature,
      'spellcasting',
    );
  });

  test('Faveur de Vision lucide (p. 94) : Vision lucide 60 pieds', () {
    expect(
      effects('srd:feat:boon-of-truesight').last,
      containsPair('range', 60),
    );
  });

  test('lignes de table recopiées : présentes dans le texte en page', () {
    final layout = File(
      p.join(_root, '..', '..', 'docs', 'srd', 'FR_SRD_CC_v5.2.1.txt'),
    ).readAsStringSync();
    for (final s in srdSpecies) {
      for (final MapEntry(key: title, value: table) in s.tables.entries) {
        expect(
          missingTableCells(layout, title, table.rows),
          isEmpty,
          reason: title,
        );
      }
    }
  });
}
