// Spec character-sheet : « Déverrouillage de la montée de niveau »
// (EF-SEA-05). Seuils relus dans la table « Évolution du personnage » du
// SRD 5.2.1 ; PX d'Aldric dans [D1] et la planche [S4].
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

void main() {
  test('seuils du SRD : 300 au niveau 2, 14 000 au 6, 355 000 au 20', () {
    expect(xpThresholds, hasLength(20));
    expect(xpThresholds.first, 0);
    expect(xpThresholds[1], 300);
    expect(xpThresholds[4], 6500);
    expect(xpThresholds[5], 14000);
    expect(xpThresholds[11], 100000);
    expect(xpThresholds.last, 355000);
  });

  test('Aldric, niveau 5, 7 475 PX : rien, prochain seuil 14 000', () {
    expect(levelUnlockOf(level: 5, xp: 7475, mode: ProgressionMode.xp), isNull);
    expect(nextXpThreshold(5), 14000);
    expect(nextXpThreshold(20), isNull);
  });

  test('seuil atteint : niveau suivant, un seul à la fois', () {
    final unlock = levelUnlockOf(
      level: 5,
      xp: 30000,
      mode: ProgressionMode.xp,
    )!;
    expect(unlock.level, 6);
    expect(unlock.origin, UnlockOrigin.xp);
    expect(unlock.xp, 14000);
  });

  test('table en jalons : les PX ne déverrouillent rien', () {
    expect(
      levelUnlockOf(level: 5, xp: 14000, mode: ProgressionMode.milestone),
      isNull,
    );
  });

  test('niveau accordé en jalons, avec motif et séance', () {
    final unlock = levelUnlockOf(
      level: 5,
      xp: 0,
      mode: ProgressionMode.milestone,
      granted: {
        'level': 6,
        'origin': 'milestone',
        'by': 'u-camille',
        'reason': 'Varga capturée, le relais du Sel libéré',
        'session': 's-12',
      },
    )!;
    expect(unlock.level, 6);
    expect(unlock.origin, UnlockOrigin.milestone);
    expect(unlock.by, 'u-camille');
    expect(unlock.reason, 'Varga capturée, le relais du Sel libéré');
    expect(unlock.sessionId, 's-12');
  });

  test('niveau accordé déjà atteint : ne compte plus', () {
    expect(
      levelUnlockOf(
        level: 6,
        xp: 0,
        mode: ProgressionMode.milestone,
        granted: {'level': 6, 'origin': 'milestone', 'by': 'u'},
      ),
      isNull,
    );
  });

  test('dérogation : compte dans les deux modes, avant le seuil', () {
    for (final mode in ProgressionMode.values) {
      final unlock = levelUnlockOf(
        level: 3,
        xp: 0,
        mode: mode,
        granted: {'level': 4, 'origin': 'override', 'by': 'u-camille'},
      )!;
      expect((unlock.level, unlock.origin), (4, UnlockOrigin.override));
    }
  });

  test('jalon gardé d’une table repassée en PX : ignoré', () {
    expect(
      levelUnlockOf(
        level: 5,
        xp: 0,
        mode: ProgressionMode.xp,
        granted: {'level': 6, 'origin': 'milestone', 'by': 'u'},
      ),
      isNull,
    );
  });

  test('origine inconnue : ignorée', () {
    expect(
      levelUnlockOf(
        level: 3,
        xp: 0,
        mode: ProgressionMode.milestone,
        granted: {'level': 4, 'origin': 'gift', 'by': 'u'},
      ),
      isNull,
    );
  });

  test('niveau 20 : rien', () {
    expect(
      levelUnlockOf(
        level: 20,
        xp: 999999,
        mode: ProgressionMode.xp,
        granted: {'level': 21, 'origin': 'override', 'by': 'u'},
      ),
      isNull,
    );
  });

  test('mode de progression lu depuis la table', () {
    expect(ProgressionMode.parse('xp'), ProgressionMode.xp);
    expect(ProgressionMode.parse('milestone'), ProgressionMode.milestone);
  });
}
