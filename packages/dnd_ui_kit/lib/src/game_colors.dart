import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

import 'tokens.dart';

/// Les cinq couleurs réservées au jeu (COMPOSANTS §1). Elles accompagnent
/// toujours une icône et un libellé : la couleur seule ne porte jamais
/// d'information.
@immutable
final class GameColors extends ThemeExtension<GameColors> {
  const GameColors({
    required this.damage,
    required this.onDamage,
    required this.damageContainer,
    required this.onDamageContainer,
    required this.heal,
    required this.onHeal,
    required this.healContainer,
    required this.onHealContainer,
    required this.tempHp,
    required this.onTempHp,
    required this.tempHpContainer,
    required this.onTempHpContainer,
    required this.concentration,
    required this.onConcentration,
    required this.concentrationContainer,
    required this.onConcentrationContainer,
    required this.alert,
    required this.onAlert,
    required this.alertContainer,
    required this.onAlertContainer,
  });

  factory GameColors._fromTokens(Map<String, Color> t) => GameColors(
    damage: t['damage']!,
    onDamage: t['onDamage']!,
    damageContainer: t['damageContainer']!,
    onDamageContainer: t['onDamageContainer']!,
    heal: t['heal']!,
    onHeal: t['onHeal']!,
    healContainer: t['healContainer']!,
    onHealContainer: t['onHealContainer']!,
    tempHp: t['tempHp']!,
    onTempHp: t['onTempHp']!,
    tempHpContainer: t['tempHpContainer']!,
    onTempHpContainer: t['onTempHpContainer']!,
    concentration: t['concentration']!,
    onConcentration: t['onConcentration']!,
    concentrationContainer: t['concentrationContainer']!,
    onConcentrationContainer: t['onConcentrationContainer']!,
    alert: t['alert']!,
    onAlert: t['onAlert']!,
    alertContainer: t['alertContainer']!,
    onAlertContainer: t['onAlertContainer']!,
  );

  static final dark = GameColors._fromTokens(AppTokens.darkGameColors);
  static final light = GameColors._fromTokens(AppTokens.lightGameColors);

  /// Couleurs de jeu du thème courant.
  static GameColors of(BuildContext context) =>
      Theme.of(context).extension<GameColors>()!;

  final Color damage;
  final Color onDamage;
  final Color damageContainer;
  final Color onDamageContainer;
  final Color heal;
  final Color onHeal;
  final Color healContainer;
  final Color onHealContainer;
  final Color tempHp;
  final Color onTempHp;
  final Color tempHpContainer;
  final Color onTempHpContainer;
  final Color concentration;
  final Color onConcentration;
  final Color concentrationContainer;
  final Color onConcentrationContainer;
  final Color alert;
  final Color onAlert;
  final Color alertContainer;
  final Color onAlertContainer;

  List<Color> get _all => [
    damage, onDamage, damageContainer, onDamageContainer, //
    heal, onHeal, healContainer, onHealContainer,
    tempHp, onTempHp, tempHpContainer, onTempHpContainer,
    concentration, onConcentration, concentrationContainer,
    onConcentrationContainer,
    alert, onAlert, alertContainer, onAlertContainer,
  ];

  static GameColors _fromList(List<Color> c) => GameColors(
    damage: c[0],
    onDamage: c[1],
    damageContainer: c[2],
    onDamageContainer: c[3],
    heal: c[4],
    onHeal: c[5],
    healContainer: c[6],
    onHealContainer: c[7],
    tempHp: c[8],
    onTempHp: c[9],
    tempHpContainer: c[10],
    onTempHpContainer: c[11],
    concentration: c[12],
    onConcentration: c[13],
    concentrationContainer: c[14],
    onConcentrationContainer: c[15],
    alert: c[16],
    onAlert: c[17],
    alertContainer: c[18],
    onAlertContainer: c[19],
  );

  /// Remplissage de la barre de PV (COMPOSANTS §2.2) : soins au-dessus de
  /// 50 %, alerte au-dessus de 25 %, dégâts sinon.
  Color hpBar(int current, int max) {
    final ratio = max <= 0 ? 0 : current / max;
    return ratio > 0.5
        ? heal
        : ratio > 0.25
        ? alert
        : damage;
  }

  @override
  GameColors copyWith() => this;

  @override
  GameColors lerp(GameColors? other, double t) {
    if (other == null) return this;
    final a = _all;
    final b = other._all;
    return _fromList([
      for (var i = 0; i < a.length; i++) Color.lerp(a[i], b[i], t)!,
    ]);
  }

  @override
  bool operator ==(Object other) =>
      other is GameColors && listEquals(_all, other._all);

  @override
  int get hashCode => Object.hashAll(_all);
}
