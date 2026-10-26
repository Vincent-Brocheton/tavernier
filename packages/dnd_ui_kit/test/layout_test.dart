// Spec ui-kit : « Formats d'écran » et « Couleurs de jeu ».
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formats aux bornes des points de rupture', () {
    expect(formFactorOf(599), FormFactor.phone);
    expect(formFactorOf(600), FormFactor.tabletLandscape);
    expect(formFactorOf(1023), FormFactor.tabletLandscape);
    expect(formFactorOf(1024), FormFactor.desktop);
  });

  test('marge de page par format (COMPOSANTS §1)', () {
    expect(AppSpacing.page(FormFactor.phone), 16);
    expect(AppSpacing.page(FormFactor.tabletLandscape), 24);
    expect(AppSpacing.page(FormFactor.desktop), 32);
  });

  test('paliers de la barre de PV (COMPOSANTS §2.2)', () {
    final c = GameColors.dark;
    expect(c.hpBar(31, 52), c.heal);
    expect(c.hpBar(26, 52), c.alert, reason: '50 % pile : alerte');
    expect(c.hpBar(14, 52), c.alert);
    expect(c.hpBar(13, 52), c.damage, reason: '25 % pile : dégâts');
    expect(c.hpBar(3, 11), c.alert, reason: '27 %, Loup 2 sur [0]');
    expect(c.hpBar(2, 11), c.damage);
    expect(c.hpBar(0, 27), c.damage);
  });

  test('GameColors interpole entre deux thèmes', () {
    final mid = GameColors.dark.lerp(GameColors.light, 0.5);
    expect(mid.damage, isNot(GameColors.dark.damage));
    expect(GameColors.dark.lerp(null, 0.5), GameColors.dark);
    expect(GameColors.dark.copyWith(), GameColors.dark);
  });
}
