import 'package:dnd_content/dnd_content.dart';
import 'package:test/test.dart';

import 'pack_fixtures.dart';

List<String> _messages(ContentPack pack) =>
    validatePack(pack).map((i) => '$i').toList();

ContentPack _with(List<ContentEntity> entities) =>
    ContentPack(manifest: srdManifest(), entities: entities);

void main() {
  test('l\'attribution est celle du cahier §1.3, mot pour mot', () {
    expect(
      srdAttributionFr,
      'Cette œuvre inclut du matériel issu du System Reference Document 5.2.1 '
      '(« SRD 5.2.1 ») de Wizards of the Coast LLC, disponible à l\'adresse '
      'https://www.dndbeyond.com/srd. Le SRD 5.2.1 est régi par la Licence '
      'Creative Commons Attribution 4.0 International, disponible à l\'adresse '
      'https://creativecommons.org/licenses/by/4.0/legalcode.',
    );
  });

  test('un pack cohérent est valide', () {
    expect(validatePack(validPack()), isEmpty);
  });

  test('une référence absente est signalée avec son identifiant', () {
    final pack = _with([skill('athletics', 'srd:ability:luck')]);
    expect(_messages(pack).single, contains('srd:ability:luck'));
  });

  test('une référence d\'un champ typé vers le mauvais type est signalée', () {
    final pack = _with([
      skill('athletics', 'srd:skill:stealth'),
      skill('stealth', 'srd:skill:athletics'),
    ]);
    expect(_messages(pack), contains(contains('type « ability » attendu')));
  });

  test('une référence portée par un effet doit exister', () {
    final pack = _with([
      entity({
        'id': 'srd:feat:alert',
        'type': 'feat',
        'name': 'Vigilant',
        'data': {'category': 'origin'},
        'effects': [
          {
            'op': 'grant_proficiency',
            'kind': 'skill',
            'ref': 'srd:skill:insight',
          },
        ],
        'text': {'fr': 'Texte.'},
      }),
    ]);
    expect(_messages(pack).single, contains('srd:skill:insight'));
  });

  test('un identifiant en double est signalé', () {
    final pack = _with([ability('str'), ability('str')]);
    expect(_messages(pack).single, contains('en double'));
  });

  test('un Historique doit citer exactement trois caractéristiques', () {
    final pack = _with([
      ...validPack().entities.where((e) => e.type != 'background'),
      background([
        'srd:ability:str',
        'srd:ability:dex',
      ], 'srd:feat:savage-attacker'),
    ]);
    expect(_messages(pack).single, contains('exactement 3'));
  });

  test('le don d\'un Historique doit être un don d\'origines (§11.3)', () {
    final pack = _with([
      ...validPack().entities.where(
        (e) => e.type != 'background' && e.type != 'feat',
      ),
      feat('grappler', 'general'),
      background([
        'srd:ability:str',
        'srd:ability:dex',
        'srd:ability:con',
      ], 'srd:feat:grappler'),
    ]);
    expect(_messages(pack).single, contains('don d\'origines'));
  });

  test('une dépendance peut fournir la cible d\'une référence', () {
    final pack = _with([skill('athletics', 'srd:ability:str')]);
    expect(validatePack(pack, dependencies: [ability('str')]), isEmpty);
  });

  test('l\'attribution du SRD ne peut pas être modifiée', () {
    final pack = ContentPack(
      manifest: srdManifest(attribution: '${srdAttributionFr}x'),
      entities: validPack().entities,
    );
    expect(_messages(pack).single, contains('attribution'));
  });

  test('la licence est obligatoire', () {
    final manifest = srdManifest();
    final pack = ContentPack(
      manifest: PackManifest(
        id: manifest.id,
        namespace: 'ines',
        name: 'Sorts d\'Inès',
        version: '2.2.0',
        origin: PackOrigin.local,
        author: 'Inès',
        licence: ' ',
        locale: 'fr',
      ),
      entities: const [],
    );
    expect(_messages(pack).single, contains('licence'));
  });
}
