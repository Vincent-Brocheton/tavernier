// Pack SRD réel construit depuis tools/srd_builder/sources (US-02).
// Valeurs attendues relues dans docs/srd/FR_SRD_CC_v5.2.1.pdf.
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:dnd_content/dnd_content.dart';
import 'package:path/path.dart' as p;
import 'package:srd_builder/srd_builder.dart';
import 'package:test/test.dart';

final _repo = p.normalize(
  p.join(
    p.fromUri(
      Isolate.resolvePackageUriSync(Uri.parse('package:srd_builder/'))!,
    ),
    '..',
    '..',
    '..',
  ),
);

void main() {
  late ContentPack pack;
  late Map<String, ContentEntity> byId;
  late StringBuffer err;

  setUpAll(() {
    final out = Directory.systemTemp.createTempSync('srd_sample_');
    addTearDown(() => out.deleteSync(recursive: true));
    final target = p.join(out.path, 'srd.dndpack');
    err = StringBuffer();
    final code = run(
      [
        'build',
        '--sources',
        p.join(_repo, 'tools', 'srd_builder', 'sources'),
        '--out',
        target,
      ],
      StringBuffer(),
      err,
    );
    expect(code, 0, reason: '$err');
    pack = readDndpack(File(target).readAsBytesSync());
    byId = {for (final e in pack.entities) '${e.id}': e};
  });

  Iterable<ContentEntity> ofType(String type) =>
      pack.entities.where((e) => e.type == type);

  test(
    'le manifeste porte l\'attribution CC-BY, la licence et l\'id du pack',
    () {
      expect(pack.manifest.attribution, srdAttributionFr);
      expect(pack.manifest.licence, 'CC-BY-4.0');
      expect(pack.manifest.id, '377190b6-2dfa-4b38-83be-1c4c6d0cf55d');
      expect(pack.manifest.origin, PackOrigin.srd);
    },
  );

  test('l\'échantillon vertical est complet', () {
    expect(byId, contains('srd:class:fighter'));
    expect(byId, contains('srd:subclass:champion'));
    expect(byId, contains('srd:species:human'));
    expect(ofType('background').map((e) => e.id.slug).toSet(), {
      'acolyte',
      'criminal',
      'sage',
      'soldier',
    });
    expect(ofType('ability'), hasLength(6));
    expect(ofType('skill'), hasLength(18));
    expect(ofType('condition'), hasLength(15));
    expect(ofType('damage-type'), hasLength(13));
    expect(ofType('mastery'), hasLength(8));
    expect(ofType('weapon').length, greaterThanOrEqualTo(30));
    expect(ofType('armor'), hasLength(13));
  });

  test(
    'chaque identifiant de contenu de la fixture d\'Aldric niveau 1 existe',
    () {
      final fixture = File(
        p.join(
          _repo,
          'packages',
          'dnd_rules',
          'test',
          'fixtures',
          'd1',
          'aldric_n1.json',
        ),
      ).readAsStringSync();
      final ids = <String>{};
      void visit(Object? value) {
        switch (value) {
          case String():
            final type = ContentId.tryParse(value)?.type;
            if (type != null && type != 'resource') ids.add(value);
          case Map<String, Object?>():
            value.values.forEach(visit);
          case List<Object?>():
            value.forEach(visit);
        }
      }

      visit((jsonDecode(fixture) as Map<String, Object?>)['input']);
      visit(
        ((jsonDecode(fixture) as Map<String, Object?>)['expected']!
            as Map<String, Object?>)['attacks'],
      );
      expect(ids, isNotEmpty);
      expect(ids.where((id) => !byId.containsKey(id)), isEmpty);
    },
  );

  test('table du Guerrier : Second souffle et Bottes d\'arme (p. 56)', () {
    final fighter = byId['srd:class:fighter']!.data as ClassData;
    expect(fighter.hitDie, 10);
    expect(fighter.levels, hasLength(20));
    Map<String, int> at(int level) =>
        fighter.levels.firstWhere((l) => l.level == level).columns;
    expect(at(1), {'second_wind': 2, 'weapon_mastery': 3});
    expect(at(4), {'second_wind': 3, 'weapon_mastery': 4});
    expect(at(10), {'second_wind': 4, 'weapon_mastery': 5});
    expect(at(16), {'second_wind': 4, 'weapon_mastery': 6});
    expect(fighter.levels.map((l) => l.proficiencyBonus), [
      2,
      2,
      2,
      2,
      3,
      3,
      3,
      3,
      4,
      4,
      4,
      4,
      5,
      5,
      5,
      5,
      6,
      6,
      6,
      6,
    ]);
  });

  test('le Soldat : For, Dex, Con et Sauvagerie martiale (p. 87)', () {
    final soldier = byId['srd:background:soldier']!.data as BackgroundData;
    expect(soldier.abilities.map((a) => a.slug), [
      'strength',
      'dexterity',
      'constitution',
    ]);
    expect(soldier.originFeat.slug, 'savage-attacker');
    expect(soldier.skillProficiencies.map((s) => s.slug).toSet(), {
      'athletics',
      'intimidation',
    });
  });

  test('Vigilant ajoute le bonus de maîtrise à l\'Initiative (p. 92)', () {
    expect(byId['srd:feat:alert']!.effects.single.toJson(), {
      'op': 'modify_initiative',
      'add': {'ref': 'proficiency_bonus'},
    });
  });

  test('Défense : +1 CA en armure (p. 93)', () {
    expect(byId['srd:feat:defense']!.effects.single.toJson(), {
      'op': 'modify_ac',
      'when': {'armor': 'any'},
      'value': 1,
    });
  });

  test('épée longue, javeline, cotte de mailles et bouclier (p. 97-98)', () {
    final longsword = byId['srd:weapon:longsword']!.data as WeaponData;
    expect(
      (longsword.damage, longsword.damageType.slug, longsword.mastery.slug),
      ('1d8', 'slashing', 'sap'),
    );
    final javelin = byId['srd:weapon:javelin']!.data as WeaponData;
    expect((javelin.damage, javelin.mastery.slug), ('1d6', 'slow'));
    expect(javelin.rangeFeet, [30, 120]);
    final chain = byId['srd:armor:chain-mail']!.data as ArmorData;
    expect(
      (chain.baseAc, chain.strRequirement, chain.stealthDisadvantage),
      (16, 13, true),
    );
    expect((byId['srd:armor:shield']!.data as ArmorData).baseAc, 2);
  });

  test(
    'chaque texte de règles est non vide et sans césure de fin de ligne',
    () {
      for (final entity in pack.entities.where((e) => e.textFr != null)) {
        expect(entity.textFr!.trim(), isNotEmpty, reason: '${entity.id}');
        expect(entity.textFr, isNot(contains('-\n')), reason: '${entity.id}');
      }
    },
  );
}
