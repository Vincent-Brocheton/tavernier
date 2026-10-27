// Espèces et dons du SRD 5.2.1 (FR), p. 88-94 : noms du SRD et slugs
// anglais (change t-04d-origines). Les lignes de table sont recopiées du
// texte en mise en page ; un test vérifie qu'elles y figurent.

import 'origin_extractor.dart';

const srdSpecies = <SrdSpecies>[
  (
    name: 'Drakéide',
    slug: 'dragonborn',
    traits: {
      'Ascendance draconique': 'draconic-ancestry',
      'Résistance aux dégâts': 'damage-resistance',
      'Souffle': 'breath-weapon',
      'Vision dans le noir': 'darkvision',
      'Vol draconique': 'draconic-flight',
    },
    tables: {
      'Ancêtres draconiques': (
        trait: 'Ascendance draconique',
        rows: [
          ['Dragon', 'Type de dégâts'],
          ['Airain', 'Feu'],
          ['Argent', 'Froid'],
          ['Blanc', 'Froid'],
          ['Bleu', 'Foudre'],
          ['Bronze', 'Foudre'],
          ['Cuivre', 'Acide'],
          ['Noir', 'Acide'],
          ['Or', 'Feu'],
          ['Rouge', 'Feu'],
          ['Vert', 'Poison'],
        ],
      ),
    },
  ),
  (
    name: 'Elfe',
    slug: 'elf',
    traits: {
      'Ascendance féerique': 'fey-ancestry',
      'Lignage elfique': 'elven-lineage',
      'Sens aiguisés': 'keen-senses',
      'Transe': 'trance',
      'Vision dans le noir': 'darkvision',
    },
    tables: {
      'Lignages elfiques': (
        trait: 'Lignage elfique',
        rows: [
          ['Lignage', 'Niveau 1', 'Niveau 3', 'Niveau 5'],
          [
            'Drow',
            'La portée de votre Vision dans le noir passe à 36 m. Vous '
                'connaissez également le sort mineur lumières dansantes.',
            'lueurs féeriques',
            'ténèbres',
          ],
          [
            'Elfe sylvestre',
            'Votre Vitesse passe à 10,50 m. Vous connaissez également le '
                'sort mineur druidisme.',
            'grande foulée',
            'passage sans trace',
          ],
          [
            'Haut-elfe',
            'Vous connaissez le sort mineur prestidigitation. Chaque fois '
                'que vous terminez un Repos long, vous pouvez remplacer ce '
                'sort mineur par un autre sort mineur de la liste de sorts '
                'du Magicien.',
            'détection de la magie',
            'foulée brumeuse',
          ],
        ],
      ),
    },
  ),
  (
    name: 'Gnome',
    slug: 'gnome',
    traits: {
      'Lignage gnome': 'gnomish-lineage',
      'Ruse gnome': 'gnomish-cunning',
      'Vision dans le noir': 'darkvision',
    },
    tables: {},
  ),
  (
    name: 'Goliath',
    slug: 'goliath',
    traits: {
      'Ascendance gigante': 'giant-ancestry',
      'Forme de géant': 'large-form',
      'Forte carrure': 'powerful-build',
    },
    tables: {},
  ),
  (
    name: 'Halfelin',
    slug: 'halfling',
    traits: {
      'Agilité halfeline': 'halfling-nimbleness',
      'Brave': 'brave',
      'Chance': 'luck',
      'Discrétion naturelle': 'naturally-stealthy',
    },
    tables: {},
  ),
  (
    name: 'Humain',
    slug: 'human',
    traits: {
      'Compétent': 'skillful',
      'Ingénieux': 'resourceful',
      'Polyvalent': 'versatile',
    },
    tables: {},
  ),
  (
    name: 'Nain',
    slug: 'dwarf',
    traits: {
      'Connaissance de la pierre': 'stonecunning',
      'Résistance naine': 'dwarven-resilience',
      'Ténacité naine': 'dwarven-toughness',
      'Vision dans le noir': 'darkvision',
    },
    tables: {},
  ),
  (
    name: 'Orc',
    slug: 'orc',
    traits: {
      'Acharnement': 'relentless-endurance',
      'Poussée d’adrénaline': 'adrenaline-rush',
      'Vision dans le noir': 'darkvision',
    },
    tables: {},
  ),
  (
    name: 'Tieffelin',
    slug: 'tiefling',
    traits: {
      'Héritage fiélon': 'fiendish-legacy',
      'Présence d’outre-monde': 'otherworldly-presence',
      'Vision dans le noir': 'darkvision',
    },
    tables: {
      'Héritages fiélons': (
        trait: 'Héritage fiélon',
        rows: [
          ['Héritage', 'Niveau 1', 'Niveau 3', 'Niveau 5'],
          [
            'Abyssal',
            'Vous bénéficiez de la Résistance aux dégâts de poison. Vous '
                'connaissez en outre le sort mineur bouffée de poison.',
            'rayon empoisonné',
            'immobilisation de personne',
          ],
          [
            'Chtonien',
            'Vous bénéficiez de la Résistance aux dégâts nécrotiques. Vous '
                'connaissez en outre le sort mineur contact glacial.',
            'simulacre de vie',
            'rayon affaiblissant',
          ],
          [
            'Infernal',
            'Vous bénéficiez de la Résistance aux dégâts de feu. Vous '
                'connaissez en outre le sort mineur trait de feu.',
            'représailles infernales',
            'ténèbres',
          ],
        ],
      ),
    },
  ),
];

/// Dons : nom du SRD → slug anglais.
const srdFeats = {
  'Doué': 'skilled',
  'Initié à la magie': 'magic-initiate',
  'Sauvagerie martiale': 'savage-attacker',
  'Vigilant': 'alert',
  'Amélioration de caractéristique': 'ability-score-improvement',
  'Empoigneur': 'grappler',
  'Archerie': 'archery',
  'Armes à deux mains': 'great-weapon-fighting',
  'Combat à deux armes': 'two-weapon-fighting',
  'Défense': 'defense',
  'Faveur d’attaque irrésistible': 'boon-of-irresistible-offense',
  'Faveur de déplacement dimensionnel': 'boon-of-dimensional-travel',
  'Faveur de l’esprit nocturne': 'boon-of-the-night-spirit',
  'Faveur de prouesse martiale': 'boon-of-combat-prowess',
  'Faveur de mémoire magique': 'boon-of-spell-recall',
  'Faveur de Vision lucide': 'boon-of-truesight',
  'Faveur du destin': 'boon-of-fate',
};
