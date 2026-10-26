// Spike T-01 (spec local-database : « Stockage Web », « Volume de contenu »).
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/database.dart';
import 'package:game_table/persistent_storage.dart';
import 'package:integration_test/integration_test.dart';

import 'support/browser_name.dart';

/// `opfs` pour exiger OPFS (job Chrome isolé) ; vide sinon.
const _expectedStorage = String.fromEnvironment('T01_EXPECTED_STORAGE');

/// Plafond d'entités d'un pack (ENF-09).
const _volume = 10000;

/// Pack synthétique de [_volume] dons, aux textes repris du pack SRD : aucun
/// contenu hors SRD. Le don 4242 porte un nom repérable.
ContentPack _syntheticPack(ContentPack srd) {
  final texts = [for (final e in srd.entities) ?e.textFr];
  return ContentPack(
    manifest: const PackManifest(
      id: '00000000-0000-0000-0000-000000000701',
      namespace: 't01',
      name: 'Volume T-01',
      version: '1.0.0',
      origin: PackOrigin.local,
      author: 'Tavernier',
      licence: 'CC-BY-4.0',
      locale: 'fr',
    ),
    entities: [
      for (var i = 0; i < _volume; i++)
        parseEntity({
          'id': 't01:feat:don-$i',
          'type': 'feat',
          'name': i == 4242 ? 'Aiguille 4242' : 'Don synthétique $i',
          'data': {'category': 'general'},
          'text': {'fr': texts[i % texts.length]},
        }, 'don-$i').entity!,
    ],
  );
}

/// Entrée d'Aldric niveau 1, copie de la fixture [D1]
/// `packages/dnd_rules/test/fixtures/d1/aldric_n1.json` (illisible depuis un
/// navigateur).
final _aldric = CharacterInput.fromJson({
  'name': 'Aldric Varenne',
  'player': 'Hugo',
  'kind': 'pc',
  'species_id': 'srd:species:human',
  'species_choices': {'size': 'M'},
  'choices': {
    'skillful': ['srd:skill:insight'],
  },
  'background_id': 'srd:background:soldier',
  'base_scores': {
    'method': 'point_buy',
    'str': 15,
    'dex': 13,
    'con': 14,
    'int': 8,
    'wis': 12,
    'cha': 10,
  },
  'background_choice': {
    'distribution': '2-1',
    'bonuses': {'str': 2, 'con': 1},
    'tool_choice': 'srd:tool:dice-set',
  },
  'class_levels': [
    {
      'class_id': 'srd:class:fighter',
      'level': 1,
      'skill_choices': ['srd:skill:perception', 'srd:skill:survival'],
    },
  ],
  'feats': [
    {
      'feat_id': 'srd:feat:savage-attacker',
      'source_type': 'background',
      'source_ref': 'srd:background:soldier',
    },
    {
      'feat_id': 'srd:feat:alert',
      'source_type': 'species',
      'source_ref': 'srd:species:human',
    },
    {
      'feat_id': 'srd:feat:defense',
      'source_type': 'class',
      'source_ref': 'srd:class:fighter',
    },
  ],
  'languages': [
    'srd:language:common',
    'srd:language:dwarvish',
    'srd:language:orc',
  ],
  'weapon_masteries': [
    {'weapon_id': 'srd:weapon:longsword', 'slot_index': 0},
    {'weapon_id': 'srd:weapon:javelin', 'slot_index': 1},
    {'weapon_id': 'srd:weapon:battleaxe', 'slot_index': 2},
  ],
  'items': [
    {'item_id': 'srd:armor:chain-mail', 'quantity': 1, 'equipped': true},
    {'item_id': 'srd:armor:shield', 'quantity': 1, 'equipped': true},
    {'item_id': 'srd:weapon:longsword', 'quantity': 1, 'equipped': true},
    {'item_id': 'srd:weapon:javelin', 'quantity': 4, 'equipped': false},
    {'item_id': 'srd:weapon:battleaxe', 'quantity': 1, 'equipped': false},
    {'item_id': 'srd:item:healers-kit', 'quantity': 1, 'equipped': false},
  ],
  'xp': 0,
});

String _platform() => kIsWeb ? browserName() : defaultTargetPlatform.name;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Mesures écrites par `flutter drive` dans
  /// `build/integration_response_data.json` (CI) et affichées en console.
  final report = <String, Object?>{};
  void record(Map<String, Object?> values) {
    report.addAll(values);
    binding.reportData = {'t01': report};
    debugPrint(
      'T01 ${values.entries.map((e) => '${e.key}=${e.value}').join(' ')}',
    );
  }

  String dbName() => 't01_${DateTime.now().microsecondsSinceEpoch}';

  testWidgets('le stockage Web choisi est connu', (_) async {
    WasmDatabaseResult? result;
    final db = openTavernierDatabase(
      name: dbName(),
      onWebResult: (r) => result = r,
    );
    addTearDown(db.close);
    await db.customSelect('SELECT 1').get();

    if (!kIsWeb) {
      expect(result, isNull);
      return;
    }
    expect(result, isNotNull);
    record({
      'stockage': result!.chosenImplementation.name,
      'manquants': result!.missingFeatures.map((f) => f.name).join(','),
    });
    if (_expectedStorage == 'opfs') {
      expect(result!.chosenImplementation.name, startsWith('opfs'));
    }
  });

  testWidgets('le stockage persistant se demande sans erreur', (_) async {
    final granted = await requestPersistentStorage();
    record({'persistant': granted});
    if (!kIsWeb) expect(granted, isTrue);
  });

  testWidgets('10 000 entités : import, réouverture, recherche', (_) async {
    final pack = _syntheticPack(await loadSrdPack());
    final name = dbName();
    var storage = 'natif';
    final watch = Stopwatch()..start();
    int lap() {
      final ms = watch.elapsedMilliseconds;
      watch.reset();
      return ms;
    }

    var db = openTavernierDatabase(
      name: name,
      onWebResult: (r) => storage = r.chosenImplementation.name,
    );
    await db.customSelect('SELECT 1').get();
    lap();
    await PackStore(db).importPack(pack);
    await CharacterStore(db).save('aldric', _aldric);
    final importMs = lap();
    await db.close();

    db = openTavernierDatabase(name: name);
    addTearDown(db.close);
    final count = await db
        .customSelect(
          'SELECT count(*) AS n FROM feat WHERE pack_id = ?',
          variables: [Variable<String>(pack.manifest.id)],
        )
        .getSingle();
    final reopenMs = lap();
    final hits = await PackStore(db).search('aiguille');
    final searchMs = lap();
    final aldric = await CharacterStore(db).load('aldric');
    final characterMs = lap();

    record({
      'plateforme': _platform(),
      'stockage': storage,
      'import_ms': importMs,
      'reouverture_ms': reopenMs,
      'recherche_ms': searchMs,
      'personnage_ms': characterMs,
    });
    expect(count.read<int>('n'), _volume);
    expect(hits.first.id, 't01:feat:don-4242');
    expect(aldric, _aldric);
  });
}
