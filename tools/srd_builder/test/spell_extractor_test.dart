// Extraction des sorts (change t-04a-sorts-srd, décisions 3 à 6). Extraits
// réels de `pdftotext` sur docs/srd/FR_SRD_CC_v5.2.1.pdf.
import 'package:srd_builder/src/spell_extractor.dart';
import 'package:test/test.dart';

const _excerpt = '''
Description des sorts
Boule de feu
Évocation du 3e niveau (Ensorceleur, Magicien)
Temps d’incantation : action Portée : 45 m Composantes : V, S, M (une boulette de guano de chauve-souris et de soufre) Durée : instantanée
Une zébrure éblouissante jaillit de vous jusqu’au point que vous choisissez à portée, produisant une déflagration au grondement sourd.
L’explosion embrase les objets inflammables de la zone qui ne sont portés par personne.
Emplacement de niveau supérieur. Les dégâts augmentent de 1d6 par niveau d’emplacement au-delà du 3e.

Rappel à la vie
Nécromancie du 5e niveau (Barde, Clerc, Paladin)
Temps d’incantation : 1 heure Portée : contact Composantes : V, S, M (un diamant d’une valeur mini-
male de 500 po, que le sort détruit) Durée : instantanée
Avec un toucher, vous ramenez à la vie une créature
153 Document de Référence du Système 5.2.1
\f
morte, à condition qu’elle soit décédée depuis 10 jours au plus.
Arrêt du temps
Transmutation du 9e niveau (Ensorceleur, Magicien)
Temps d’incantation : action Portée : personnelle

118 Document de Référence du Système 5.2.1
Composantes : V Durée : instantanée
Vous arrêtez brièvement l’écoulement du temps pour tout le monde sauf vous.
Lumières dansantes
Illusion mineure (Barde, Ensorceleur, Magicien)
Temps d’incantation : action ou rituel Portée : 36 m Composantes : V, S, M (un peu de phosphore) Durée : Concentration, jusqu’à 1 minute
Vous créez jusqu’à quatre lumières de la taille d’une torche, vous-
même compris. Une valeur minimale est requise, de même. Des bâtonnets gra-
vés spécialement.
''';

void main() {
  final clean = cleanText(_excerpt);
  final spells = splitSpells(clean.lines);

  test('pieds de page et sauts de page retirés', () {
    expect(
      clean.lines.where((l) => l.contains('Document de Référence')),
      isEmpty,
    );
  });

  test('mot coupé recollé, trait d’union réel gardé', () {
    expect(spells[1].components['material'], contains('valeur minimale de'));
    expect(spells[3].text, contains('vous-même compris'));
    expect(spells[3].text, contains('bâtonnets gravés spécialement'));
  });

  test('paragraphe coupé par une page recollé', () {
    expect(
      spells[1].text,
      'Avec un toucher, vous ramenez à la vie une créature morte, à condition '
      'qu’elle soit décédée depuis 10 jours au plus.',
    );
    expect(clean.joins, isNotEmpty);
  });

  test('quatre sorts découpés, en-têtes lus', () {
    expect(
      [for (final s in spells) s.name],
      [
        'Boule de feu',
        'Rappel à la vie',
        'Arrêt du temps',
        'Lumières dansantes',
      ],
    );
    final fireball = spells[0];
    expect(
      (fireball.level, fireball.school, fireball.castingTime, fireball.ritual),
      (3, 'evocation', 'action', false),
    );
    expect(fireball.classes, ['Ensorceleur', 'Magicien']);
    expect(fireball.range, {'kind': 'feet', 'feet': 150});
    expect(fireball.duration, 'instantanée');
    expect(fireball.concentration, isFalse);
    expect(fireball.text.split('\n'), hasLength(3));
    expect(fireball.text, startsWith('Une zébrure éblouissante'));
    expect(fireball.text, endsWith('au-delà du 3e.'));
  });

  test('métadonnées coupées par une page', () {
    final stop = spells[2];
    expect(stop.level, 9);
    expect(stop.range, {'kind': 'self'});
    expect(stop.components, {'verbal': true, 'somatic': false});
    expect(stop.text, startsWith('Vous arrêtez brièvement'));
  });

  test('sort mineur, rituel et concentration', () {
    final lights = spells[3];
    expect(lights.level, 0);
    expect(lights.ritual, isTrue);
    expect(lights.castingTime, 'action');
    expect(lights.concentration, isTrue);
    expect(lights.duration, 'jusqu’à 1 minute');
  });

  test('composant coûteux consommé', () {
    final raise = spells[1];
    expect(raise.materialCostCp, 50000);
    expect(raise.materialConsumed, isTrue);
    expect(spells[0].materialCostCp, isNull);
    expect(spells[0].materialConsumed, isFalse);
  });

  test('portées converties en pieds', () {
    expect(parseRange('9 m'), {'kind': 'feet', 'feet': 30});
    expect(parseRange('1,50 m'), {'kind': 'feet', 'feet': 5});
    expect(parseRange('1,5 km'), {'kind': 'feet', 'feet': 5000});
    expect(parseRange('contact'), {'kind': 'touch'});
    expect(parseRange('champ de vision'), {'kind': 'sight'});
    expect(() => parseRange('très loin'), throwsFormatException);
  });
}
