// Objets magiques du SRD (change t-04f-objets-magiques). Valeurs relues dans
// docs/srd/FR_SRD_CC_v5.2.1.pdf.
import 'dart:io';
import 'dart:isolate';

import 'package:dnd_content/dnd_content.dart';
import 'package:path/path.dart' as p;
import 'package:srd_builder/src/magic_item_extractor.dart';
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

/// Les mots de [cell] se suivent dans [words], les colonnes voisines pouvant
/// s'intercaler. Un exposant (« 7e ») est coupé du nombre dans le texte en
/// page (« 7 niveau) / e »).
bool _cellIn(List<String> words, String cell) {
  bool found(String text) {
    var i = 0;
    for (final word in text.split(' ')) {
      while (i < words.length && words[i] != word) {
        i++;
      }
      if (i++ >= words.length) return false;
    }
    return true;
  }

  return found(cell) ||
      found(cell.replaceAllMapped(RegExp(r'(\d)e\b'), (m) => m[1]!));
}

void main() {
  late Map<String, ContentEntity> byId;
  late List<ContentEntity> items;

  setUpAll(() {
    final loaded = loadSources(Directory(p.join(_root, 'sources')));
    expect(loaded.issues, isEmpty);
    byId = {for (final e in loaded.pack!.entities) '${e.id}': e};
    items = byId.values.where((e) => e.type == 'magic-item').toList();
  });

  MagicItemData item(String slug) =>
      byId['srd:magic-item:$slug']!.data as MagicItemData;

  test('258 objets, chacun avec son texte, sans pied de page', () {
    expect(items, hasLength(258));
    for (final e in items) {
      expect(e.textFr, isNotEmpty, reason: '${e.id}');
      expect(e.textFr, isNot(contains('Document de Référence')));
    }
  });

  test('Cape de protection : objet merveilleux peu courant, harmonisé', () {
    final cloak = item('cloak-of-protection');
    expect(cloak.category, MagicItemCategory.wondrous);
    expect(cloak.rarity, Rarity.uncommon);
    expect(cloak.attunement, isTrue);
    expect(cloak.attunementBy, isNull);
  });

  test('Bâton de guérison : harmonisation réservée', () {
    expect(item('staff-of-healing').attunementBy, 'un Barde, Clerc ou Druide');
  });

  test('rareté variable, ligne de type complète', () {
    final weapon = item('weapon-plus-1-2-or-3');
    expect(weapon.rarity, Rarity.varies);
    expect(weapon.typeLine, contains('très rare (+3)'));
    expect(item('horn-of-valhalla').rarity, Rarity.varies);
  });

  test('Orbe draconique : artefact', () {
    expect(item('orb-of-dragonkind').rarity, Rarity.artifact);
  });

  test('une potion courante, et chaque catégorie présente', () {
    expect(item('potion-of-climbing').rarity, Rarity.common);
    expect({
      for (final e in items) (e.data as MagicItemData).category,
    }, MagicItemCategory.values.toSet());
  });

  test('Potions de guérison : chaque potion avec ses points de vie', () {
    final text = byId['srd:magic-item:potions-of-healing']!.textFr;
    expect(text, contains('Potion de guérison | 2d4 + 2 | Courante'));
    expect(
      text,
      contains('Potion de guérison (suprême) | 10d4 + 20 | Très rare'),
    );
  });

  test('Parchemin de sort : niveau 9, légendaire, DD 19, +11', () {
    expect(
      byId['srd:magic-item:spell-scroll']!.textFr,
      contains('9 | Légendaire | 19 | +11'),
    );
  });

  test('tables recopiées : cellules et lignes retrouvées dans le SRD', () {
    final layout = File(
      p.join(_root, '..', '..', 'docs', 'srd', 'FR_SRD_CC_v5.2.1.txt'),
    ).readAsStringSync();
    final chapter = layout.substring(
      layout.indexOf(
        RegExp(r'^\s*Objets magiques de A à Z\s', multiLine: true),
      ),
      layout.indexOf('Aperçu du profil de jeu', 200000),
    );
    final tables = readMagicItemTables(
      File(p.join(_root, 'extract', 'magic_item_tables.json')),
    );
    final missing = <String>[];
    for (final t in tables) {
      final at = chapter.indexOf(
        RegExp(
          '(^|\\s{2}|\\f)${RegExp.escape(t.item)}(\\s{2}|\$)',
          multiLine: true,
        ),
      );
      expect(at, isNonNegative, reason: t.item);
      // En page, la colonne de droite peut précéder le titre de l'objet.
      final line = '\n'.allMatches(chapter.substring(0, at)).length;
      final zone = chapter
          .split('\n')
          .skip(line < 70 ? 0 : line - 70)
          .take(220)
          .join('\n');
      final words = zone.split(RegExp(r'\s+'));
      // Les textes longs (Sac de haricots, Submersible) passent à la ligne
      // avec des coupures de mots : ils sont repris du texte extrait.
      for (final row in t.rows) {
        for (final cell in row) {
          if (cell.length <= 60 && !_cellIn(words, cell)) {
            missing.add('${t.item} : $cell');
          }
        }
      }
      // Lignes de valeurs : les deux dernières cellules se touchent en page,
      // sauf en-tête. Une valeur recopiée sur la mauvaise ligne échoue.
      for (final row in t.rows.skip(1)) {
        final [..., before, last] = row;
        if (before.length > 60 || last.length > 60) continue;
        final alternatives = before
            .split(' ')
            .map(RegExp.escape)
            .map((w) => w.replaceFirst(RegExp(r'(\d)e\b'), r'\1e?'))
            .join('|');
        final next = RegExp.escape(last.split(' ').first);
        if (!RegExp(
          '(^|\\s)($alternatives)\\s+(?:[a-z]{1,2}\\s+)?$next(\\s|\$)',
          multiLine: true,
        ).hasMatch(zone)) {
          missing.add('${t.item} : ${row.join(' | ')}');
        }
      }
    }
    expect(missing, isEmpty);
  });
}
