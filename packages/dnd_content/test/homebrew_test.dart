// Spec homebrew : « Vérification d'un pack », « Mes packs » (US-27).
import 'package:dnd_content/dnd_content.dart';
import 'package:test/test.dart';

import 'pack_fixtures.dart';

void main() {
  final srd = [
    ability('str'),
    ability('dex'),
    ability('con'),
    ability('wis'),
    skill('athletics', 'srd:ability:str'),
    skill('perception', 'srd:ability:wis'),
    feat('alert', 'origin'),
    feat('grappler', 'general'),
  ];
  final manifest = newHomebrewManifest(
    id: '0193a000-0000-7000-8000-000000000001',
    name: 'Gardiens des Marches',
    namespace: 'gardiens',
    author: 'Inès',
    srd: srdManifest(),
  );

  Map<String, Object?> background(List<String> abilities, String feat) => {
    'id': 'gardiens:background:sentinelle',
    'type': 'background',
    'name': 'Sentinelle',
    'data': {
      'abilities': abilities,
      'origin_feat': feat,
      'skill_proficiencies': ['srd:skill:athletics', 'srd:skill:perception'],
      'equipment_a': <Object?>[],
      'gold_a': 15,
      'gold_b': 50,
    },
    'text': {'fr': 'Texte.'},
  };

  test('nouveau pack : manifeste valide, version 0.1.0', () {
    expect(PackManifest.parse(manifest).issues, isEmpty);
    expect(manifest['version'], '0.1.0');
    expect(checkDraft(manifest, const [], dependencies: srd), isEmpty);
  });

  test('Historique incomplet : les règles 2024 se lisent déjà', () {
    final messages = [
      for (final i in checkDraft(manifest, [
        {
          'id': 'gardiens:background:sentinelle',
          'type': 'background',
          'name': 'Sentinelle',
          'data': {
            'abilities': ['srd:ability:str'],
          },
        },
      ], dependencies: srd))
        i.message,
    ];
    expect(
      messages,
      contains('un Historique cite exactement 3 caractéristiques'),
    );
    expect(
      messages,
      contains('un Historique accorde exactement 2 compétences'),
    );
  });

  test('Historique complet : aucun problème', () {
    final issues = checkDraft(manifest, [
      background([
        'srd:ability:str',
        'srd:ability:dex',
        'srd:ability:con',
      ], 'srd:feat:alert'),
    ], dependencies: srd);
    expect(issues, isEmpty);
  });

  test('Historique à 2 caractéristiques et don général : signalés', () {
    final messages = [
      for (final i in checkDraft(manifest, [
        background(['srd:ability:str', 'srd:ability:dex'], 'srd:feat:grappler'),
      ], dependencies: srd))
        i.message,
    ];
    expect(messages, contains(contains('exactement 3 caractéristiques')));
    expect(messages, contains(contains('don d\'origines')));
  });

  test('Don sans catégorie : signalé, le reste se lit', () {
    final issues = checkDraft(manifest, [
      {
        'id': 'gardiens:feat:veilleur',
        'type': 'feat',
        'name': 'Veilleur',
        'data': <String, Object?>{},
        'text': {'fr': 'Texte.'},
      },
    ], dependencies: srd);
    expect(issues.single.path, contains('category'));
  });

  test('identifiants : slug sans accents, unique dans le pack', () {
    expect(slugOf('Gardiens des Marches'), 'gardiens-des-marches');
    expect(
      homebrewEntityId('gardiens', 'feat', 'Œil de la Sentinelle', const []),
      'gardiens:feat:oeil-de-la-sentinelle',
    );
    expect(
      homebrewEntityId('gardiens', 'feat', 'Veilleur', [
        'gardiens:feat:veilleur',
      ]),
      'gardiens:feat:veilleur-2',
    );
  });
}
