// Sorts du pack SRD (change t-04a-sorts-srd). Valeurs relues dans
// docs/srd/FR_SRD_CC_v5.2.1.pdf, page imprimée citée.
import 'dart:io';
import 'dart:isolate';

import 'package:dnd_content/dnd_content.dart';
import 'package:path/path.dart' as p;
import 'package:srd_builder/srd_builder.dart';
import 'package:test/test.dart';

final _sources = p.normalize(
  p.join(
    p.fromUri(
      Isolate.resolvePackageUriSync(Uri.parse('package:srd_builder/'))!,
    ),
    '..',
    'sources',
  ),
);

void main() {
  late Map<String, ContentEntity> byId;
  late List<SpellData> spells;

  setUpAll(() {
    final loaded = loadSources(Directory(_sources));
    expect(loaded.issues, isEmpty);
    byId = {for (final e in loaded.pack!.entities) '${e.id}': e};
    spells = [
      for (final e in loaded.pack!.entities)
        if (e.data case final SpellData s) s,
    ];
  });

  SpellData spell(String slug) => byId['srd:spell:$slug']!.data as SpellData;
  String text(String slug) => byId['srd:spell:$slug']!.textFr!;

  test('339 sorts, dont 27 sorts mineurs, tous niveaux et écoles', () {
    expect(spells, hasLength(339));
    expect(spells.where((s) => s.level == 0), hasLength(27));
    expect({for (final s in spells) s.level}, {for (var l = 0; l <= 9; l++) l});
    expect({for (final s in spells) s.school}, SpellSchool.values.toSet());
  });

  test('Boule de feu (p. 121)', () {
    final s = spell('fireball');
    expect(byId['srd:spell:fireball']!.name, 'Boule de feu');
    expect(
      (s.level, s.school, s.castingTime),
      (3, SpellSchool.evocation, 'action'),
    );
    expect(s.range, const SpellRange(kind: RangeKind.feet, feet: 150));
    expect(
      s.components,
      const SpellComponents(
        verbal: true,
        somatic: true,
        material: 'une boulette de guano de chauve-souris et de soufre',
      ),
    );
    expect(
      (s.duration, s.ritual, s.concentration),
      ('instantanée', false, false),
    );
    expect(
      text('fireball'),
      contains('subit 8d6 dégâts de feu en cas d’échec'),
    );
    expect(
      text('fireball'),
      endsWith(
        'Emplacement de niveau supérieur. Les dégâts augmentent de 1d6 par '
        'niveau d’emplacement au-delà du 3e.',
      ),
    );
  });

  test('Bénédiction (p. 120) : concentration, composant de 5 po', () {
    final s = spell('bless');
    expect((s.level, s.school), (1, SpellSchool.enchantment));
    expect(s.range.feet, 30);
    expect((s.materialCostCp, s.materialConsumed), (500, false));
    expect((s.duration, s.concentration), ('jusqu’à 1 minute', true));
    expect(text('bless'), startsWith('Vous bénissez jusqu’à trois créatures'));
  });

  test('Rappel à la vie (p. 171) : diamant de 500 po consommé', () {
    final s = spell('raise-dead');
    expect(
      (s.level, s.school, s.castingTime),
      (5, SpellSchool.necromancy, '1 heure'),
    );
    expect(s.range.kind, RangeKind.touch);
    expect((s.materialCostCp, s.materialConsumed), (50000, true));
    expect(text('raise-dead'), contains('malus de –4 aux Tests d20'));
  });

  test('Souhait (p. 177) : composante verbale seule', () {
    final s = spell('wish');
    expect((s.level, s.school), (9, SpellSchool.conjuration));
    expect(s.components, const SpellComponents(verbal: true, somatic: false));
    expect(s.range.kind, RangeKind.self);
    expect(text('wish'), startsWith('Souhait est le sort le plus puissant'));
  });

  test('Aspersion acide (p. 118) : sort mineur, amélioration', () {
    final s = spell('acid-splash');
    expect((s.level, s.school, s.range.feet), (0, SpellSchool.evocation, 60));
    expect(
      text('acid-splash'),
      contains('Amélioration de sort mineur. Les dégâts augmentent de 1d6'),
    );
  });

  test('Bouclier (p. 120) : réaction et son déclencheur', () {
    final s = spell('shield');
    expect(s.castingTime, startsWith('Réaction, que vous jouez lorsqu’un jet'));
    expect((s.duration, s.range.kind), ('1 round', RangeKind.self));
    expect(text('shield'), contains('bonus de +5 à la CA'));
  });

  test('rituels : Détection de la magie, mais pas Boule de feu', () {
    expect(spell('detect-magic').ritual, isTrue);
    expect(spell('detect-magic').castingTime, 'action');
    expect(spells.where((s) => s.ritual).length, greaterThan(20));
  });
}
