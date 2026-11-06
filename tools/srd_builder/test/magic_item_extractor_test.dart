// Extraction des objets magiques (change t-04f-objets-magiques). Extraits
// réels du PDF en ordre de lecture, abrégés.
import 'package:srd_builder/src/magic_item_extractor.dart';
import 'package:test/test.dart';

const _text = '''
Objets magiques de A à Z
Les objets magiques sont présentés par ordre alphabétique.
Amulette de santé
Objet merveilleux, rare (Harmonisation requise)
Votre Constitution est de 19 tant que vous portez cette amulette.
Anneau d’influence animale
Anneau, rare
Tant que vous portez l’anneau, vous pouvez lancer l’un des sorts suivants :
• amitié avec les animaux • terreur
• communication avec les animaux
Une fois utilisé, il s’éteint.
Arme +1, +2 ou +3
Arme (courante ou de guerre), peu courante (+1), rare (+2) ou très rare (+3)
Vous recevez un bonus aux jets d’attaque.
Armure de cuir clouté enchantée
Armure (armure de cuir clouté) rare
Cette armure est enchantée.
Bâton de guérison
Bâton, rare (Harmonisation requise avec un Barde, Clerc ou Druide)
Ce bâton a 10 charges. Votre valeur de
Force ne change pas.

266 Document de Référence du Système 5.2.1

Cor du Valhalla
Objet merveilleux, rare (argent ou airain), très rare (bronze) ou légendaire (fer)
Vous pouvez souffler dans ce cor.
Orbe draconique
Objet merveilleux, Artefact (Harmonisation requise)
Chaque orbe est un globe de cristal.
Potions de guérison
Potion, rareté variable
Vous récupérez des points de vie.
Potion Pv récupérés
Rareté Courante Peu courante
8d4 + 8 Rare
Le liquide étincelle.
Tarot mystérieux
Objet merveilleux, légendaire Généralement rangé dans un étui, ce jeu de cartes
est magique.
Yeux de lynx
Objet merveilleux, peu courant
Ces lentilles s’appliquent sur les yeux.
1d6 Effet
1 Rien
\fMonstres
Aperçu du profil de jeu
''';

const _tables = <MagicItemTable>[
  (
    item: 'Potions de guérison',
    start: 'Potion Pv récupérés',
    resume: 'Le liquide étincelle.',
    rows: [
      ['Potion', 'Pv récupérés', 'Rareté'],
      ['Potion de guérison', '2d4 + 2', 'Courante'],
    ],
  ),
  (
    item: 'Yeux de lynx',
    start: '1d6 Effet',
    resume: '',
    rows: [
      ['1d6', 'Effet'],
    ],
  ),
];

void main() {
  final items = extractMagicItems(_text, tables: _tables);
  ExtractedMagicItem item(String name) =>
      items.singleWhere((i) => i.name == name);

  test('une entrée par ligne de type, jusqu’à « Monstres »', () {
    expect(items, hasLength(10));
    expect(items.first.name, 'Amulette de santé');
    expect(items.last.name, 'Yeux de lynx');
  });

  test('catégorie, rareté et harmonisation', () {
    expect(item('Amulette de santé').data, {
      'category': 'wondrous',
      'rarity': 'rare',
      'type_line': 'Objet merveilleux, rare (Harmonisation requise)',
      'attunement': true,
    });
    expect(item('Anneau d’influence animale').data, {
      'category': 'ring',
      'rarity': 'rare',
      'type_line': 'Anneau, rare',
      'attunement': false,
    });
    expect(item('Orbe draconique').data['rarity'], 'artifact');
    expect(item('Yeux de lynx').data['rarity'], 'uncommon');
  });

  test('harmonisation réservée', () {
    final data = item('Bâton de guérison').data;
    expect(data['attunement'], isTrue);
    expect(data['attunement_by'], 'un Barde, Clerc ou Druide');
    expect(data['category'], 'staff');
  });

  test('plusieurs raretés ou rareté variable : varies', () {
    expect(item('Arme +1, +2 ou +3').data['rarity'], 'varies');
    expect(item('Cor du Valhalla').data['rarity'], 'varies');
    expect(item('Potions de guérison').data['rarity'], 'varies');
    expect(
      item('Arme +1, +2 ou +3').data['type_line'],
      'Arme (courante ou de guerre), peu courante (+1), rare (+2) ou très '
      'rare (+3)',
    );
  });

  test('ligne de type sans virgule', () {
    expect(item('Armure de cuir clouté enchantée').data, {
      'category': 'armor',
      'rarity': 'rare',
      'type_line': 'Armure (armure de cuir clouté) rare',
      'attunement': false,
    });
  });

  test('ligne de type collée au texte', () {
    final tarot = item('Tarot mystérieux');
    expect(tarot.data['type_line'], 'Objet merveilleux, légendaire');
    expect(
      tarot.text,
      'Généralement rangé dans un étui, ce jeu de cartes est magique.',
    );
  });

  test('texte : phrase recollée, pied de page retiré', () {
    expect(
      item('Bâton de guérison').text,
      'Ce bâton a 10 charges. Votre valeur de Force ne change pas.',
    );
  });

  test('une liste à puces garde ses lignes', () {
    expect(
      item('Anneau d’influence animale').text,
      'Tant que vous portez l’anneau, vous pouvez lancer l’un des sorts '
      'suivants :\n'
      '• amitié avec les animaux • terreur\n'
      '• communication avec les animaux\n'
      'Une fois utilisé, il s’éteint.',
    );
  });

  test('une table remplace ses lignes, à sa place dans le texte', () {
    expect(
      item('Potions de guérison').text,
      'Vous récupérez des points de vie.\n'
      'Potion | Pv récupérés | Rareté\n'
      'Potion de guérison | 2d4 + 2 | Courante\n'
      'Le liquide étincelle.',
    );
    expect(
      item('Yeux de lynx').text,
      'Ces lentilles s’appliquent sur les yeux.\n1d6 | Effet',
    );
  });

  test('table introuvable : erreur', () {
    MagicItemTable table(String item, String start, String resume) =>
        (item: item, start: start, resume: resume, rows: const []);
    for (final t in [
      table('Inconnu', 'x', ''),
      table('Yeux de lynx', 'Absent', ''),
      table('Yeux de lynx', '1d6 Effet', 'Absent'),
    ]) {
      expect(
        () => extractMagicItems(_text, tables: [t]),
        throwsFormatException,
      );
    }
  });

  test('lignes restées suspectes : courtes et sans ponctuation', () {
    final suspects = <String>[];
    extractMagicItems(_text, suspects: suspects);
    expect(suspects, contains('Potions de guérison : Potion Pv récupérés'));
    expect(suspects, isNot(contains(startsWith('Amulette'))));
  });

  test('slugs : entrée sans slug et slug sans entrée signalés', () {
    expect(
      missingSlugs(items.take(2).toList(), {
        'Amulette de santé': 'periapt-of-health',
        'Absent': 'absent',
      }),
      [
        'objet sans slug : Anneau d’influence animale',
        'slug sans objet : Absent',
      ],
    );
  });
}
