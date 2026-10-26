// Tracés des icônes de jeu, grille 24 × 24, trait arrondi. Sources :
// docs/maquettes/html/Main.dc.html ([0] Fondations : états, économie
// d'actions, icônes transverses), G01-Ecoles-Magie.dc.html ([G1] écoles) et
// Combat-Phone-Degats.dc.html (5 types de dégâts). Les clés sont les slugs
// des entités du pack SRD (`srd:condition:<clé>`, `srd:damage-type:<clé>`).

/// Une icône de trait : tracé SVG 24 × 24.
final class GameIconData {
  const GameIconData(
    this.name,
    this.path, {
    this.strokeWidth = 2,
    this.filled = false,
  });

  final String name;
  final String path;
  final double strokeWidth;

  /// Forme pleine (action, action Bonus) au lieu d'un trait.
  final bool filled;
}

/// Jeu d'icônes de jeu (COMPOSANTS §2.3).
abstract final class GameIcons {
  /// Les 15 états du SRD.
  static const conditions = <String, GameIconData>{
    'blinded': GameIconData(
      'blinded',
      'M3 3l18 18 M10.6 5.1A10 10 0 0 1 12 5c6.4 0 10 7 10 7a17 17 0 0 1-3 '
          '3.8 M6.6 6.6C3.9 8.4 2 12 2 12s3.6 7 10 7a9.7 9.7 0 0 0 5.4-1.6',
    ),
    'charmed': GameIconData(
      'charmed',
      'M12 20s-7-4.4-7-10a4 4 0 0 1 7-2.6A4 4 0 0 1 19 10c0 5.6-7 10-7 10z '
          'M19 2v4 M17 4h4',
    ),
    'deafened': GameIconData(
      'deafened',
      'M6 8.5a6 6 0 0 1 12 0c0 3.5-3 4.5-3 7.5a3 3 0 0 1-5.5 1.6 M3 3l18 18',
    ),
    'exhaustion': GameIconData('exhaustion', 'M3 8h15v8H3z M21 11v2 M6 11v2'),
    'frightened': GameIconData(
      'frightened',
      'M12 3a9 9 0 1 0 0 18 9 9 0 0 0 0-18z M9 9.5h.01 M15 9.5h.01 '
          'M8 16c1-1 2-1 2.7 0s1.9 1 2.6 0 2-1 2.7 0',
    ),
    'grappled': GameIconData(
      'grappled',
      'M7 11V6a1.5 1.5 0 0 1 3 0v4 M10 9V5a1.5 1.5 0 0 1 3 0v5 '
          'M13 9V6a1.5 1.5 0 0 1 3 0v6 M16 11a1.5 1.5 0 0 1 3 0v3a7 7 0 0 1-7 '
          '7h-1a6 6 0 0 1-5-3l-2.5-4a1.5 1.5 0 0 1 2.6-1.5L7 14',
    ),
    'incapacitated': GameIconData(
      'incapacitated',
      'M12 3a9 9 0 1 0 0 18 9 9 0 0 0 0-18z M5.6 5.6l12.8 12.8',
    ),
    'invisible': GameIconData(
      'invisible',
      'M5 21V10a7 7 0 0 1 14 0v11l-2.3-2-2.3 2-2.4-2-2.3 2-2.4-2z '
          'M9.5 10h.01 M14.5 10h.01',
    ),
    'paralyzed': GameIconData(
      'paralyzed',
      'M12 3.5a2 2 0 1 0 0 4 2 2 0 0 0 0-4z M12 9v6 M8 21l4-6 4 6 M6 11h12',
    ),
    'petrified': GameIconData(
      'petrified',
      'M12 3l8 4.5v9L12 21l-8-4.5v-9z M12 12l8-4.5 M12 12v9 M12 12L4 7.5',
    ),
    'poisoned': GameIconData(
      'poisoned',
      'M12 3s6 6.5 6 11a6 6 0 0 1-12 0c0-4.5 6-11 6-11z M10 12.5l4 4 '
          'M14 12.5l-4 4',
    ),
    'prone': GameIconData(
      'prone',
      'M3 19h18 M5 15h9l4-2 M8 15l2-3h4 M18.5 9.5a2 2 0 1 0 0 .01',
    ),
    'restrained': GameIconData(
      'restrained',
      'M9 15l6-6 M10 6l1-1a4 4 0 0 1 5.7 5.7l-1 1 M14 18l-1 1a4 4 0 0 1-5.7-'
          '5.7l1-1',
    ),
    'stunned': GameIconData(
      'stunned',
      'M5 3l1 2 2 1-2 1-1 2-1-2-2-1 2-1z M18 3l.7 1.5L20 5l-1.3.5L18 7l-.7-'
          '1.5L16 5l1.3-.5z M4 14a8 3 0 1 0 16 0 8 3 0 1 0-16 0',
    ),
    'unconscious': GameIconData('unconscious', 'M4 6h6l-6 7h6 M13 13h5l-5 6h5'),
  };

  /// Les 13 types de dégâts du SRD. Les maquettes ne dessinent que
  /// tranchant, perforant, contondant, feu et froid ; les 8 autres sont
  /// dessinés dans le même style. À valider par le design.
  static const damageTypes = <String, GameIconData>{
    // À valider par le design.
    'acid': GameIconData(
      'acid',
      'M12 3s6 6.5 6 11a6 6 0 0 1-12 0c0-4.5 6-11 6-11z '
          'M9.5 14a1 1 0 1 0 2 0 1 1 0 0 0-2 0 M13 17a1 1 0 1 0 2 0 1 1 0 0 0-2 0',
    ),
    'bludgeoning': GameIconData(
      'bludgeoning',
      'M15 4l5 5-3 3-5-5z M12 7l-8 8a1.4 1.4 0 0 0 2 2l8-8',
    ),
    'cold': GameIconData('cold', 'M12 2v20 M3.3 7l17.4 10 M3.3 17L20.7 7'),
    'fire': GameIconData(
      'fire',
      'M12 22a7 7 0 0 0 7-7c0-4-3-6-4-10-2 2-3 4-3 6-1-1-2-2-2-4-2 2-5 5-5 '
          '8a7 7 0 0 0 7 7z',
    ),
    // À valider par le design.
    'force': GameIconData(
      'force',
      'M12 3v5 M9.5 5.5L12 3l2.5 2.5 M12 21v-5 M9.5 18.5L12 21l2.5-2.5 '
          'M3 12h5 M5.5 9.5L3 12l2.5 2.5 M21 12h-5 M18.5 9.5L21 12l-2.5 2.5',
    ),
    // À valider par le design.
    'lightning': GameIconData('lightning', 'M14 2L6 13h5l-2 9 9-12h-5l2-8z'),
    // À valider par le design.
    'necrotic': GameIconData(
      'necrotic',
      'M12 3a7 7 0 0 0-7 7v3l2 2v4h10v-4l2-2v-3a7 7 0 0 0-7-7z '
          'M9.5 11.5h.01 M14.5 11.5h.01 M12 3l-1 3 2 2',
    ),
    'piercing': GameIconData('piercing', 'M4 20L20 4 M14 4h6v6'),
    // À valider par le design.
    'poison': GameIconData(
      'poison',
      'M12 3s6 6.5 6 11a6 6 0 0 1-12 0c0-4.5 6-11 6-11z M10 13h.01 '
          'M14 13h.01 M10 17h4',
    ),
    // À valider par le design.
    'psychic': GameIconData(
      'psychic',
      'M12 12a1 1 0 1 1 1-1 3 3 0 1 1-3-3 5 5 0 1 1-5 5 7 7 0 1 1 7 7',
    ),
    // À valider par le design.
    'radiant': GameIconData(
      'radiant',
      'M12 8a4 4 0 1 0 0 8 4 4 0 0 0 0-8z M12 2v2 M12 20v2 M4.9 4.9l1.4 1.4 '
          'M17.7 17.7l1.4 1.4 M2 12h2 M20 12h2 M4.9 19.1l1.4-1.4 '
          'M17.7 6.3l1.4-1.4',
    ),
    'slashing': GameIconData('slashing', 'M5 19L19 5 M9 20L20 9 M4 15L15 4'),
    // À valider par le design.
    'thunder': GameIconData(
      'thunder',
      'M3 12h2 M7 8v8 M11 5v14 M15 8v8 M19 10v4',
    ),
  };

  /// Action, action Bonus, réaction.
  static const actionEconomy = <String, GameIconData>{
    'action': GameIconData(
      'action',
      'M12 5a7 7 0 1 0 0 14 7 7 0 0 0 0-14z',
      filled: true,
    ),
    'bonus': GameIconData('bonus', 'M12 4l8.5 15h-17z', filled: true),
    'reaction': GameIconData(
      'reaction',
      'M20 11a8 8 0 1 0-2.3 5.7 M20 4v7h-7',
      strokeWidth: 2.2,
    ),
  };

  /// Les 8 écoles de magie ([G1]).
  static const schools = <String, GameIconData>{
    'abjuration': GameIconData(
      'abjuration',
      'M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6z M9 12l2 2 4-4',
    ),
    'conjuration': GameIconData(
      'conjuration',
      'M12 3a9 9 0 1 0 0 18 9 9 0 0 0 0-18z M12 7l1.5 3.5L17 12l-3.5 1.5L12 '
          '17l-1.5-3.5L7 12l3.5-1.5z',
    ),
    'divination': GameIconData(
      'divination',
      'M2 12s3.6-7 10-7 10 7 10 7-3.6 7-10 7S2 12 2 12z M12 9a3 3 0 1 0 0 6 '
          '3 3 0 0 0 0-6z',
    ),
    'enchantment': GameIconData(
      'enchantment',
      'M12 21s-7-4.5-9.5-9A5 5 0 0 1 12 6a5 5 0 0 1 9.5 6c-2.5 4.5-9.5 9-9.5 '
          '9z M9 11h.01 M15 11h.01',
    ),
    'evocation': GameIconData('evocation', 'M13 2L4 14h7l-1 8 9-12h-7z'),
    'illusion': GameIconData(
      'illusion',
      'M4 12c2-4 5-6 8-6s6 2 8 6c-2 4-5 6-8 6s-6-2-8-6z M8 12h8 M12 8v8',
    ),
    'necromancy': GameIconData(
      'necromancy',
      'M12 3a7 7 0 0 0-7 7v4l2 2v3h10v-3l2-2v-4a7 7 0 0 0-7-7z M9 11h.01 '
          'M15 11h.01 M10 16h4',
    ),
    'transmutation': GameIconData(
      'transmutation',
      'M4 7h12l-3-3 M20 17H8l3 3 M7 12h10',
    ),
  };

  // Icônes transverses de [0] Fondations.
  static const shield = GameIconData(
    'shield',
    'M12 3l8 3v6c0 4.5-3.4 8.3-8 9-4.6-.7-8-4.5-8-9V6z',
  );
  static const tempHp = GameIconData(
    'tempHp',
    'M12 2l8.5 5v10L12 22l-8.5-5V7z M12 8v8 M8 12h8',
  );
  static const heal = GameIconData(
    'heal',
    'M12 3a9 9 0 1 0 0 18 9 9 0 0 0 0-18z M12 8v8 M8 12h8',
  );
  static const damage = GameIconData(
    'damage',
    'M12 2l2.4 6.2L21 7l-4.2 5L21 17l-6.6-1.2L12 22l-2.4-6.2L3 17l4.2-5L3 '
        '7l6.6 1.2z',
  );
  static const concentration = GameIconData(
    'concentration',
    'M12 3a9 9 0 1 0 0 18 9 9 0 0 0 0-18z M12 8a4 4 0 1 0 0 8 4 4 0 0 0 0-8z '
        'M12 11.5v1',
  );
  static const warning = GameIconData(
    'warning',
    'M12 9v4 M12 17h.01 M10.3 3.9L2 18a2 2 0 0 0 1.7 3h16.6a2 2 0 0 0 1.7-'
        '3L13.7 3.9a2 2 0 0 0-3.4 0z',
  );
  static const outOfCombat = GameIconData(
    'outOfCombat',
    'M12 3a9 9 0 1 0 0 18 9 9 0 0 0 0-18z M9 9l6 6 M15 9l-6 6',
  );
  static const syncDone = GameIconData(
    'syncDone',
    'M7 18a5 5 0 0 1-.5-9.98A6 6 0 0 1 18 9a4.5 4.5 0 0 1 0 9z '
        'M9.5 13.5l2 2 3.5-3.5',
  );
  static const syncPending = GameIconData(
    'syncPending',
    'M7 18a5 5 0 0 1-.5-9.98A6 6 0 0 1 18 9a4.5 4.5 0 0 1 0 9z M12 16v-5 '
        'M9.5 13.5L12 11l2.5 2.5',
  );
  static const syncOffline = GameIconData(
    'syncOffline',
    'M3 3l18 18 M8 18a5 5 0 0 1-1.6-9.7 M10.5 6.3A6 6 0 0 1 18 9a4.5 4.5 0 0 '
        '1 2.4 8.3',
  );

  /// Toutes les icônes, pour les tests et la planche golden.
  static List<GameIconData> get all => [
    ...conditions.values,
    ...damageTypes.values,
    ...actionEconomy.values,
    ...schools.values,
    shield,
    tempHp,
    heal,
    damage,
    concentration,
    warning,
    outOfCombat,
    syncDone,
    syncPending,
    syncOffline,
  ];
}
