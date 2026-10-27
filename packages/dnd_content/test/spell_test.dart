// Spec content-pack : « Type d'entité sort ».
import 'package:dnd_content/dnd_content.dart';
import 'package:test/test.dart';

Map<String, Object?> _fireball({Map<String, Object?> data = const {}}) => {
  'id': 'srd:spell:fireball',
  'type': 'spell',
  'name': 'Boule de feu',
  'data': {
    'level': 3,
    'school': 'evocation',
    'casting_time': 'action',
    'ritual': false,
    'range': {'kind': 'feet', 'feet': 150},
    'components': {
      'verbal': true,
      'somatic': true,
      'material': 'une boulette de guano de chauve-souris et de soufre',
    },
    'material_consumed': false,
    'duration': 'instantanée',
    'concentration': false,
    ...data,
  },
  'text': {'fr': 'Une zébrure éblouissante jaillit de vous.'},
};

List<String> _issues(Map<String, Object?> json) =>
    parseEntity(json, 'spell/fireball.json').issues.map((i) => i.path).toList();

void main() {
  test('Boule de feu se lit en SpellData', () {
    final result = parseEntity(_fireball(), 'spell/fireball.json');
    expect(result.issues, isEmpty);
    final data = result.entity!.data as SpellData;
    expect(data.level, 3);
    expect(data.school, SpellSchool.evocation);
    expect(data.range, const SpellRange(kind: RangeKind.feet, feet: 150));
    expect(data.components.material, startsWith('une boulette'));
    expect(data.materialCostCp, isNull);
    expect(result.entity!.toJson(), _fireball());
  });

  test('sort mineur à portée personnelle', () {
    final result = parseEntity(
      _fireball(
        data: {
          'level': 0,
          'range': {'kind': 'self'},
        },
      ),
      'spell/x.json',
    );
    expect(result.issues, isEmpty);
    expect((result.entity!.data as SpellData).range.feet, isNull);
  });

  test('niveau hors de 0 à 9 refusé', () {
    expect(_issues(_fireball(data: {'level': 10})), [
      'spell/fireball.json.data.level',
    ]);
    expect(_issues(_fireball(data: {'level': -1})), [
      'spell/fireball.json.data.level',
    ]);
  });

  test('école inconnue refusée', () {
    expect(_issues(_fireball(data: {'school': 'chronurgy'})), [
      'spell/fireball.json.data.school',
    ]);
  });

  test('portée en pieds sans valeur, ou valeur sans pieds, refusée', () {
    expect(
      _issues(
        _fireball(
          data: {
            'range': {'kind': 'feet'},
          },
        ),
      ),
      ['spell/fireball.json.data.range'],
    );
    expect(
      _issues(
        _fireball(
          data: {
            'range': {'kind': 'touch', 'feet': 5},
          },
        ),
      ),
      ['spell/fireball.json.data.range'],
    );
  });

  test('champ inconnu refusé', () {
    expect(_issues(_fireball(data: {'classes': <String>[]})), [
      'spell/fireball.json.data.classes',
    ]);
  });

  test('texte de règles obligatoire', () {
    expect(_issues(_fireball()..remove('text')), ['spell/fireball.json.text']);
  });
}
