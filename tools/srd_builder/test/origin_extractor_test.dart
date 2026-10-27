// Extraction des espèces et des dons (change t-04d-origines). Extraits réels
// du PDF en ordre de lecture, abrégés.
import 'package:srd_builder/src/origin_extractor.dart';
import 'package:test/test.dart';

const _species = '''
Description des espèces
Drakéide
Type de créature : Humanoïde Catégorie de taille : M (moyenne, entre 1,50 m et
2,10 m) Vitesse : 9 m
En tant que drakéide, vous disposez des traits spéciaux suivants.
Ascendance draconique. Votre lignée remonte à un géniteur dragon. Choisissez le type de dragon dans la table « Ancêtres draconiques ».

Ancêtres draconiques
Type de Dragon dégâts Airain Feu Argent Froid
Cuivre Acide
Souffle. Lorsque vous entreprenez l’action Attaque à votre tour (choisissez la forme à chaque

fois). Chaque créature prise dans la zone effectue un jet de sauvegarde.
Vol draconique. Lorsque vous atteignez le niveau de personnage 5, vous pouvez canaliser la magie draconique.
Goliath
Type de créature : Humanoïde
Catégorie de taille : M (moyenne, entre 2,10 m et
2,40 m)
Vitesse : 10,50 m
En tant que goliath, vous disposez des traits spéciaux suivants.
Ascendance gigante. Vous êtes un lointain descendant des géants. Choisissez l’un des bénéfices ci-après :
Brûlure ignée (géants du feu). Lorsque vous touchez une cible, vous pouvez infliger 1d10 dégâts de feu.
Forte carrure. Vous avez l’Avantage à tous les tests.

90

Document de Référence du Système 5.2.1

Humain
Type de créature : Humanoïde Catégorie de taille : M (moyenne, entre 1,20 m et
2,10 m) ou P (petite, de 60 cm à 1,20 m), à choisir lors de la sélection de l’espèce Vitesse : 9 m
En tant qu’humain, vous disposez des traits spéciaux suivants.
Compétent. Vous recevez la maîtrise d’une compétence de votre choix.

Dons
Description des dons
''';

const _config = [
  (
    name: 'Drakéide',
    slug: 'dragonborn',
    traits: {
      'Ascendance draconique': 'draconic-ancestry',
      'Souffle': 'breath-weapon',
      'Vol draconique': 'draconic-flight',
    },
    tables: {
      'Ancêtres draconiques': (
        trait: 'Ascendance draconique',
        rows: [
          ['Dragon', 'Type de dégâts'],
          ['Airain', 'Feu'],
        ],
      ),
    },
  ),
  (
    name: 'Goliath',
    slug: 'goliath',
    traits: {
      'Ascendance gigante': 'giant-ancestry',
      'Forte carrure': 'powerful-build',
    },
    tables: <String, ({String trait, List<List<String>> rows})>{},
  ),
  (
    name: 'Humain',
    slug: 'human',
    traits: {'Compétent': 'skillful'},
    tables: <String, ({String trait, List<List<String>> rows})>{},
  ),
];

const _feats = '''
Description des dons
Les dons qui suivent sont organisés par catégorie.
Dons d’origines
Vigilant
Don d’origines
Vous recevez les bénéfices suivants. Maîtrise de l’Initiative. Lorsque vous jouez l’Initia-
tive, ajoutez votre bonus de maîtrise au jet.
Dons généraux
Amélioration de caractéristique
Don général (prérequis : niveau 4 ou supérieur)
Augmentez de 2 la valeur de caractéristique de votre choix.
Répétable. Vous pouvez sélectionner ce don plus d’une fois.
Empoigneur
Don général (prérequis : niveau 4 ou supérieur, Force ou Dextérité 13 ou plus)
Vous recevez les bénéfices suivants. Augmentation de caractéristique. Votre valeur de
Force ou de Dextérité augmente de 1, jusqu’à un maximum de 20.
Dons de Style de combat
Archerie
Don de Style de combat (prérequis : aptitude Style de combat)
Vous recevez un bonus de +2 aux jets d’attaque.
Dons de faveur épique
Faveur de mémoire magique
Don de faveur épique (prérequis : niveau 19 ou supérieur, aptitude Sorts)
Vous recevez les bénéfices suivants.

94

Document de Référence du Système 5.2.1

Équipement
Pièces de monnaie
''';

void main() {
  group('espèces', () {
    final species = extractSpecies(_species, _config);

    test('en-tête : type, tailles et Vitesse en pieds', () {
      expect(
        [for (final s in species) s.slug],
        ['dragonborn', 'goliath', 'human'],
      );
      expect(species[0].data, {
        'creature_type': 'humanoid',
        'sizes': ['M'],
        'speed_feet': 30,
      });
      expect(species[1].data['speed_feet'], 35);
      expect(species[2].data['sizes'], ['M', 'P']);
    });

    test('un trait par paragraphe « Nom. », table retirée puis recopiée', () {
      final traits = species[0].traits;
      expect(
        [for (final t in traits) t.slug],
        ['draconic-ancestry', 'breath-weapon', 'draconic-flight'],
      );
      expect(
        traits[0].text,
        'Votre lignée remonte à un géniteur dragon. Choisissez le type de '
        'dragon dans la table « Ancêtres draconiques ».\n'
        'Ancêtres draconiques\n'
        'Dragon | Type de dégâts\n'
        'Airain | Feu',
      );
      // Paragraphe coupé par un saut de colonne.
      expect(
        traits[1].text,
        'Lorsque vous entreprenez l’action Attaque à votre tour (choisissez '
        'la forme à chaque fois). Chaque créature prise dans la zone '
        'effectue un jet de sauvegarde.',
      );
    });

    test('niveau du trait : 1, ou le niveau de personnage qu’il cite', () {
      expect([for (final t in species[0].traits) t.level], [1, 1, 5]);
    });

    test('une sous-option « Nom (…). » reste dans son trait', () {
      final traits = species[1].traits;
      expect(
        [for (final t in traits) t.slug],
        ['giant-ancestry', 'powerful-build'],
      );
      expect(traits[0].text, contains('\nBrûlure ignée (géants du feu).'));
    });

    test('pied de page retiré avant l’espèce suivante', () {
      expect(
        species[1].traits[1].text,
        'Vous avez l’Avantage à tous les tests.',
      );
    });

    test('trait de la configuration introuvable : erreur', () {
      expect(
        () => extractSpecies(_species, [
          (
            name: 'Humain',
            slug: 'human',
            traits: {'Compétent': 'skillful', 'Ingénieux': 'resourceful'},
            tables: <String, ({String trait, List<List<String>> rows})>{},
          ),
        ]),
        throwsFormatException,
      );
    });
  });

  group('dons', () {
    final feats = extractFeats(_feats);

    test('titre, catégorie et texte, intertitres ignorés', () {
      expect(
        [for (final f in feats) f.name],
        [
          'Vigilant',
          'Amélioration de caractéristique',
          'Empoigneur',
          'Archerie',
          'Faveur de mémoire magique',
        ],
      );
      expect(feats[0].data, {'category': 'origin'});
      expect(
        feats[0].text,
        'Vous recevez les bénéfices suivants. Maîtrise de l’Initiative. '
        'Lorsque vous jouez l’Initiative, ajoutez votre bonus de maîtrise '
        'au jet.',
      );
    });

    test('prérequis et « Répétable »', () {
      expect(feats[1].data, {
        'category': 'general',
        'prerequisites': {'min_level': 4},
        'repeatable': true,
      });
      expect(feats[2].data, {
        'category': 'general',
        'prerequisites': {
          'min_level': 4,
          'ability_min_any': {'str': 13, 'dex': 13},
        },
      });
      expect(feats[3].data, {
        'category': 'fighting_style',
        'prerequisites': {'feature': 'fighting_style'},
      });
      expect(feats[4].data, {
        'category': 'epic_boon',
        'prerequisites': {'min_level': 19, 'feature': 'spellcasting'},
      });
      expect(feats[4].text, 'Vous recevez les bénéfices suivants.');
      // Ligne coupée avant une majuscule : recollée dans le paragraphe.
      expect(
        feats[2].text,
        'Vous recevez les bénéfices suivants. Augmentation de '
        'caractéristique. Votre valeur de Force ou de Dextérité augmente '
        'de 1, jusqu’à un maximum de 20.',
      );
    });
  });

  test('cellule de table absente du texte en mise en page', () {
    const layout = '''
     Ancêtres draconiques
             Type de                       Type de
      Dragon dégâts                 Dragon dégâts
     Airain    Feu                  Cuivre    Acide
''';
    expect(
      missingTableCells(layout, 'Ancêtres draconiques', [
        ['Dragon', 'Type de dégâts'],
        ['Airain', 'Feu'],
        ['Cuivre', 'Acide'],
      ]),
      isEmpty,
    );
    expect(
      missingTableCells(layout, 'Ancêtres draconiques', [
        ['Airain', 'Froid'],
      ]),
      ['Froid'],
    );
    // Acide est la valeur de Cuivre, sur la même ligne du texte en page.
    expect(
      missingTableCells(layout, 'Ancêtres draconiques', [
        ['Airain', 'Acide'],
        ['Cuivre', 'Feu'],
      ]),
      ['Acide', 'Feu'],
    );
  });
}
