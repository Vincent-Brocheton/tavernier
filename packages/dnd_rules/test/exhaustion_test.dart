// Spec character-sheet : « Épuisement appliqué » (US-37, EF-CON-07). SRD
// 5.2.1, état Épuisement : −2 par niveau à chaque test d20, −1,50 m de
// Vitesse par niveau ; valeurs d'Aldric niveau 5 dans [F3a] et [F3b].
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

void main() {
  final aldric = CharacterInput.fromJson(fixtureInput('aldric_n5'));
  final content = srdContent();

  int contribution(Computed value) =>
      value.sources.where((c) => c.label == exhaustionSource).single.value;

  test('[F3a] : épuisement 2 sur Aldric niveau 5', () {
    final rested = computeSheet(aldric, content);
    final tired = computeSheet(aldric, content, exhaustion: 2);
    expect(rested.skills['athletics'], 7);
    expect(tired.skills['athletics'], 3);
    expect(contribution(tired.skillBreakdown['athletics']!), -4);
    expect(tired.initiative.value, 0);
    expect(tired.speed.value, 20);
    expect(contribution(tired.speed), -10);
    expect(tired.savingThrows['str'], rested.savingThrows['str']! - 4);
    expect(
      tired.attacks.first.attackBonus,
      rested.attacks.first.attackBonus - 4,
    );
  });

  test('[F3b] : épuisement 5, Initiative −6 et 1,50 m de Vitesse', () {
    final sheet = computeSheet(aldric, content, exhaustion: 5);
    expect(sheet.initiative.value, -6);
    expect(sheet.speed.value, 5);
  });

  test('la Perception passive n\'est pas un test d20', () {
    expect(
      computeSheet(aldric, content, exhaustion: 3).passivePerception,
      computeSheet(aldric, content).passivePerception,
    );
  });

  test('sans épuisement : aucune contribution', () {
    final sheet = computeSheet(aldric, content);
    expect(
      sheet.skillBreakdown['athletics']!.sources.map((c) => c.label),
      isNot(contains(exhaustionSource)),
    );
  });

  test('épuisement 6 : mort', () {
    expect(exhaustionDeath, 6);
  });
}
