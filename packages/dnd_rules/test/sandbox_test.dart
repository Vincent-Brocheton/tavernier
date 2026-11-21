// Spec character-sheet : « Prétiré de test », « Comparaison de deux fiches »
// (US-28, EF-HB-03, [H04]). Valeurs relues dans le SRD 5.2.1 : Guerrier
// p. 56 (d10, PV fixes 6), cotte de mailles 16 et bouclier +2 p. 98.
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

void main() {
  final content = srdContent();

  group('sandboxCharacter', () {
    test('Guerrier prétiré niveau 7 : Humain, Soldat, cotte et bouclier', () {
      final input = sandboxCharacter(
        content,
        classId: 'srd:class:fighter',
        level: 7,
        subclassId: 'srd:subclass:champion',
        shield: true,
      );
      expect(input.speciesId, 'srd:species:human');
      expect(input.backgroundId, 'srd:background:soldier');
      expect(input.classLevels.single.level, 7);
      expect(input.classLevels.single.subclassId, 'srd:subclass:champion');
      expect([
        for (final i in input.items)
          if (i.equipped) i.itemId,
      ], containsAll(['srd:armor:chain-mail', 'srd:armor:shield']));
      final sheet = computeSheet(input, content);
      // Cotte de mailles 16 + bouclier 2, sans Style de combat choisi.
      expect(sheet.armorClass.value, 18);
      // FOR 15 + 2 (Soldat), CON 13 : 10 + 1, puis 6 fois 6 + 1.
      expect(sheet.abilities['str']!.value, 17);
      expect(sheet.hitPointsMax.value, 53);
    });

    test('la sous-classe ne vient qu’à son niveau ; Historique remplacé', () {
      final input = sandboxCharacter(
        content,
        classId: 'srd:class:fighter',
        level: 2,
        subclassId: 'srd:subclass:champion',
        backgroundId: 'srd:background:sage',
      );
      expect(input.classLevels.single.subclassId, isNull);
      expect(input.feats.single.featId, 'srd:feat:magic-initiate');
      expect(input.feats.single.sourceType, 'background');
      expect(input.items.any((i) => i.itemId == 'srd:armor:shield'), isFalse);
    });
  });

  group('compareSheets', () {
    final feat = parseEntity({
      'id': 'hb:feat:veilleur',
      'type': 'feat',
      'name': 'Veilleur',
      'data': {'category': 'general'},
      'text': {'fr': 'Vous montez la garde.'},
      'effects': [
        {'op': 'modify_ac', 'value': 1},
      ],
    }, 'test').entity!;
    final withFeat = srdContent([feat]);
    final base = sandboxCharacter(
      withFeat,
      classId: 'srd:class:fighter',
      level: 5,
    );
    final before = computeSheet(base, withFeat);
    final after = computeSheet(
      base.copyWith(
        feats: [
          ...base.feats,
          const FeatInput(
            featId: 'hb:feat:veilleur',
            sourceType: 'test',
            sourceRef: 'test',
          ),
        ],
      ),
      withFeat,
    );

    test('CA +1 par le don ; les lignes inchangées des JS n’y sont pas', () {
      final comparison = compareSheets(before, after);
      final ac = comparison.rows.firstWhere(
        (r) => r.kind == SheetRowKind.armorClass,
      );
      expect(ac.before, '${before.armorClass.value}');
      expect(ac.after, '${before.armorClass.value + 1}');
      expect(ac.sources, ['hb:feat:veilleur']);
      expect(
        comparison.rows.where((r) => r.kind == SheetRowKind.savingThrow),
        isEmpty,
      );
      expect(
        {for (final r in comparison.rows) r.kind},
        containsAll([
          SheetRowKind.armorClass,
          SheetRowKind.hitPoints,
          SheetRowKind.initiative,
          SheetRowKind.speed,
          SheetRowKind.passivePerception,
          SheetRowKind.attack,
        ]),
      );
      expect(comparison.addedErrors, isEmpty);
    });

    test('sans fiche « sans » : valeurs avec seules', () {
      final comparison = compareSheets(null, after);
      expect(comparison.rows.every((r) => r.before == null), isTrue);
      final attack = comparison.rows.firstWhere(
        (r) => r.kind == SheetRowKind.attack,
      );
      expect(attack.after, matches(RegExp(r'^\+\d+ · \d+d\d+')));
    });

    test('ce qui change : JS, compétence, ressource ; règle ajoutée', () {
      // Le Champion de niveau 3 n'ajoute rien aux JS ; un Guerrier de
      // niveau 5 qui passe au niveau 9 gagne Indomptable et du BM.
      final low = computeSheet(
        sandboxCharacter(content, classId: 'srd:class:fighter', level: 5),
        content,
      );
      final high = computeSheet(
        sandboxCharacter(content, classId: 'srd:class:fighter', level: 9),
        content,
      );
      final rows = compareSheets(low, high).rows;
      final save = rows.firstWhere(
        (r) => r.kind == SheetRowKind.savingThrow && r.ref == 'str',
      );
      expect(int.parse(save.after) - int.parse(save.before!), 1);
      expect(rows.any((r) => r.kind == SheetRowKind.skill), isTrue);
      expect(rows.any((r) => r.kind == SheetRowKind.resource), isTrue);

      final broken = computeSheet(
        base.copyWith(
          feats: [
            ...base.feats,
            const FeatInput(
              featId: 'srd:feat:alert',
              sourceType: 'species',
              sourceRef: 'srd:species:human',
            ),
            const FeatInput(
              featId: 'srd:feat:grappler',
              sourceType: 'species',
              sourceRef: 'srd:species:human',
            ),
          ],
        ),
        withFeat,
      );
      expect(
        compareSheets(before, broken).addedErrors.map((e) => e.rule),
        contains(IntegrityRule.featGrant),
      );
    });
  });
}
