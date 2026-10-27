// Mise en page des classes dans le SRD 5.2.1 français : titres, colonnes de
// la table de progression, sections internes. Sert à `extract-classes`.

const _slots = [
  'slot_1',
  'slot_2',
  'slot_3',
  'slot_4',
  'slot_5',
  'slot_6',
  'slot_7',
  'slot_8',
  'slot_9',
];

/// Description d'une classe du SRD pour l'extraction.
typedef SrdClass = ({
  /// Nom français, tel que dans « Traits de base du … ».
  String name,
  String slug,

  /// Titre de la table de progression.
  String table,

  /// Colonnes de la table, après « Aptitudes de classe ».
  List<String> columns,
  String subclassSlug,

  /// Sections internes rattachées à une aptitude.
  Map<String, String> appendSections,

  /// Encadrés intercalés par la lecture : nombre de lignes, aptitude cible.
  Map<String, ({int lines, String to})> sidebars,
});

const srdClasses = <SrdClass>[
  (
    name: 'Barbare',
    slug: 'barbarian',
    table: 'Aptitudes du Barbare',
    columns: ['rages', 'rage_damage', 'weapon_mastery'],
    subclassSlug: 'path-of-the-berserker',
    appendSections: {},
    sidebars: {},
  ),
  (
    name: 'Barde',
    slug: 'bard',
    table: 'Aptitudes du Barde',
    columns: ['bardic_die', 'cantrips', 'prepared_spells', ..._slots],
    subclassSlug: 'college-of-lore',
    appendSections: {},
    sidebars: {},
  ),
  (
    name: 'Clerc',
    slug: 'cleric',
    table: 'Aptitudes du Clerc',
    columns: ['channel_divinity', 'cantrips', 'prepared_spells', ..._slots],
    subclassSlug: 'life-domain',
    appendSections: {},
    sidebars: {},
  ),
  (
    name: 'Druide',
    slug: 'druid',
    table: 'Aptitudes du Druide',
    columns: ['wild_shape', 'cantrips', 'prepared_spells', ..._slots],
    subclassSlug: 'circle-of-the-land',
    appendSections: {},
    sidebars: {},
  ),
  (
    name: 'Ensorceleur',
    slug: 'sorcerer',
    table: 'Aptitudes de l’Ensorceleur',
    columns: ['sorcery_points', 'cantrips', 'prepared_spells', ..._slots],
    subclassSlug: 'draconic-sorcery',
    appendSections: {'Options de Métamagie': 'Métamagie'},
    sidebars: {},
  ),
  (
    name: 'Magicien',
    slug: 'wizard',
    table: 'Aptitudes du Magicien',
    columns: ['cantrips', 'prepared_spells', ..._slots],
    subclassSlug: 'evoker',
    appendSections: {},
    sidebars: {'Étoffer et remplacer son grimoire': (lines: 5, to: 'Sorts')},
  ),
];
