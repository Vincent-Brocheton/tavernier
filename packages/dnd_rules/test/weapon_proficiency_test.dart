// Maîtrises d'armes des classes (cahier §11.1, T-04) : catégories entières
// ou une partie des armes de guerre (Moine p. 64, Roublard p. 84).
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/src/compute_sheet.dart';
import 'package:test/test.dart';

WeaponData _weapon(WeaponCategory category, List<String> properties) =>
    WeaponData(
      category: category,
      kind: WeaponKind.melee,
      damage: '1d6',
      damageType: ContentId.tryParse('srd:damage-type:piercing')!,
      properties: properties,
      mastery: ContentId.tryParse('srd:mastery:vex')!,
      costCp: 1000,
    );

void main() {
  final rapier = _weapon(WeaponCategory.martial, ['finesse']);
  final shortsword = _weapon(WeaponCategory.martial, ['finesse', 'light']);
  final longsword = _weapon(WeaponCategory.martial, ['versatile']);
  final dagger = _weapon(WeaponCategory.simple, ['finesse', 'light']);

  test('catégories entières', () {
    expect(coversWeapon({'simple', 'martial'}, longsword), isTrue);
    expect(coversWeapon({'simple'}, longsword), isFalse);
    expect(coversWeapon({'simple'}, dagger), isTrue);
  });

  test('Moine : armes de guerre dotées de la propriété Légère', () {
    const monk = {'simple', 'martial_light'};
    expect(coversWeapon(monk, shortsword), isTrue);
    expect(coversWeapon(monk, rapier), isFalse);
    expect(coversWeapon(monk, longsword), isFalse);
  });

  test('Roublard : armes de guerre Finesse ou Légère', () {
    const rogue = {'simple', 'martial_finesse_or_light'};
    expect(coversWeapon(rogue, rapier), isTrue);
    expect(coversWeapon(rogue, shortsword), isTrue);
    expect(coversWeapon(rogue, longsword), isFalse);
  });
}
