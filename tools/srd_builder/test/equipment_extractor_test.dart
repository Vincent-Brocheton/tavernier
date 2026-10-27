// Extraction des outils et du matériel d'aventurier (change
// t-04e-equipement). Extraits réels du PDF, abrégés.
import 'package:srd_builder/src/equipment_extractor.dart';
import 'package:test/test.dart';

const _tools = '''
Outils d’artisan

Les outils d’artisan sont tous axés sur la fabrication d’objets.

Matériel de brasseur (20 po)

Caractéristique : Intelligence

Poids : 4,5 kg

Utilisation : détecter qu’une boisson est empoisonnée

(DD 15), identifier un alcool (DD 10)

Artisanat : antidote

Ustensiles de cuisinier (1 po)
Caractéristique : Sagesse\t\t
Poids : 4 kg
Artisanat : rations
Autres outils
Boîte de jeux (variable)
Caractéristique : Sagesse\t\t
Poids : —
Variantes : cartes à jouer (5 pa), dés (1 pa), échecs dra-
coniques (1 po)
Instrument de musique (variable)
Caractéristique : Charisme
Poids : variable
Variantes : chalemie (2 po, 0,5 kg), flûte
de pan (12 po, 1 kg), luth (35 po, 1 kg)
Outils de voleur (25 po)
Caractéristique : Dextérité
Poids : 0,5 kg
Utilisation : crocheter une serrure (DD 15)
Matériel d’aventurier
Acide (25 po)
''';

const _toolSlugs = {
  'Matériel de brasseur': 'brewers-supplies',
  'Ustensiles de cuisinier': 'cooks-utensils',
  'Outils de voleur': 'thieves-tools',
  'cartes à jouer': 'playing-card-set',
  'dés': 'dice-set',
  'échecs draconiques': 'dragonchess-set',
  'chalemie': 'shawm',
  'flûte de pan': 'pan-flute',
  'luth': 'lute',
};

const _gear = '''
Matériel d’aventurier
Le tableau « Matériel d’aventurier » de cette section inclut du matériel.
Acide (25 po)
Lorsque vous effectuez l’action Attaque, vous pouvez remplacer l’une de vos attaques.
Bélier portable (4 po)
Vous pouvez utiliser un bélier portable pour enfoncer les portes.
100 Document de Référence du Système 5.2.1
Matériel d’aventurier
Objet Acide Antidote Beaux habits
Poids 0,5 kg
Prix 25 po 50 po 15 po
Focaliseur arcanique (variable)
Un focaliseur arcanique prend l’une des formes de la table. Un
Ensorceleur peut s’en servir.
Focaliseurs arcaniques
Focaliseur Baguette Bâton
Poids 0,5 kg
Lanterne à capote (5 po)
Une lanterne à capote brûle de l’huile. Abaisser la
103 Document de Référence du Système 5.2.1
capote par une action Bonus réduit l’éclairage.
Montures et véhicules
Si une monture peut vous aider.
''';

void main() {
  group('outils', () {
    final tools = extractTools(_tools, _toolSlugs);
    Map<String, Object?> data(String slug) =>
        tools.singleWhere((t) => t.slug == slug).data;

    test('un outil par titre « Nom (prix) », variantes dépliées', () {
      expect(
        [for (final t in tools) t.slug],
        [
          'brewers-supplies',
          'cooks-utensils',
          'playing-card-set',
          'dice-set',
          'dragonchess-set',
          'shawm',
          'pan-flute',
          'lute',
          'thieves-tools',
        ],
      );
    });

    test('catégorie, caractéristique, poids et prix', () {
      expect(data('brewers-supplies'), {
        'category': 'artisan',
        'ability': 'srd:ability:intelligence',
        'weight_kg': 4.5,
        'cost_cp': 2000,
      });
      expect(data('thieves-tools'), {
        'category': 'other',
        'ability': 'srd:ability:dexterity',
        'weight_kg': 0.5,
        'cost_cp': 2500,
      });
    });

    test('variante : prix et poids lus dans « Variantes »', () {
      expect(data('dice-set'), {
        'category': 'gaming_set',
        'ability': 'srd:ability:wisdom',
        'cost_cp': 10,
      });
      expect(data('pan-flute'), {
        'category': 'musical_instrument',
        'ability': 'srd:ability:charisma',
        'weight_kg': 1.0,
        'cost_cp': 1200,
      });
      expect(
        tools.singleWhere((t) => t.slug == 'lute').name,
        'Instrument de musique : luth',
      );
    });

    test('texte : lignes de l’outil recollées', () {
      expect(
        tools.first.text,
        'Caractéristique : Intelligence\n'
        'Poids : 4,5 kg\n'
        'Utilisation : détecter qu’une boisson est empoisonnée (DD 15), '
        'identifier un alcool (DD 10)\n'
        'Artisanat : antidote',
      );
      // L'intertitre « Autres outils » ne s'ajoute pas au texte.
      expect(tools[1].text, endsWith('Artisanat : rations'));
    });

    test('outil de la configuration introuvable : erreur', () {
      expect(
        () => extractTools(_tools, {..._toolSlugs, 'Outils de potier': 'x'}),
        throwsFormatException,
      );
    });
  });

  group('matériel', () {
    final texts = extractGearTexts(_gear, [
      'Acide',
      'Bélier portable',
      'Focaliseur arcanique',
      'Lanterne à capote',
    ]);

    test('texte de chaque description, tables retirées', () {
      expect(
        texts['Acide'],
        'Lorsque vous effectuez l’action Attaque, vous pouvez remplacer '
        'l’une de vos attaques.',
      );
      expect(
        texts['Bélier portable'],
        'Vous pouvez utiliser un bélier portable pour enfoncer les portes.',
      );
      expect(
        texts['Focaliseur arcanique'],
        'Un focaliseur arcanique prend l’une des formes de la table. Un '
        'Ensorceleur peut s’en servir.',
      );
      expect(texts['Lanterne à capote'], endsWith('réduit l’éclairage.'));
    });

    test('description absente : erreur', () {
      expect(
        () => extractGearTexts(_gear, ['Acide', 'Cadenas']),
        throwsFormatException,
      );
    });

    test('poids et prix en unités du pack', () {
      expect(parseWeight('0,5 kg'), 0.5);
      expect(parseWeight('250 g'), 0.25);
      expect(parseWeight('—'), isNull);
      expect(parseWeight('Variable'), isNull);
      expect(parsePrice('1 000 po'), 100000);
      expect(parsePrice('5 pa'), 50);
      expect(parsePrice('2 pc'), 2);
      expect(parsePrice('Variable'), isNull);
    });

    test('ligne de gear.tsv retrouvée dans le tableau en page', () {
      const layout = '''
      Acide                            0,5 kg      25 po    Munitions
      Paquetage d’exploration           27,5 kg     12 po
      Parchemin de sort (1 niveau)
                                     er
                                                   —       50 po
''';
      expect(gearRowInLayout(layout, 'Acide', '0,5 kg', '25 po'), isTrue);
      expect(gearRowInLayout(layout, 'Acide', '1 kg', '25 po'), isFalse);
      expect(
        gearRowInLayout(layout, 'Paquetage d’exploration', '27,5 kg', '12 po'),
        isTrue,
      );
      expect(
        gearRowInLayout(layout, 'Parchemin de sort (1 niveau)', '—', '50 po'),
        isTrue,
      );
    });
  });
}
