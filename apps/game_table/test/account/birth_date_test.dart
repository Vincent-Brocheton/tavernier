// Spec account : « Inscription » (EF-CPT-01, 15 ans au moins).
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/birth_date.dart';

void main() {
  group('saisie JJ/MM/AAAA', () {
    test('date valide', () {
      expect(parseBirthDate('12/03/2013'), DateTime(2013, 3, 12));
      expect(parseBirthDate(' 01/01/2000 '), DateTime(2000));
    });

    test('date impossible ou mal formée : refusée', () {
      for (final text in [
        '31/02/2010',
        '2010-02-01',
        '1/2/2010',
        '',
        '12/13/2010',
      ]) {
        expect(parseBirthDate(text), isNull, reason: text);
      }
    });
  });

  group('15 ans au moins', () {
    final today = DateTime(2026, 11, 9);

    test('15 ans aujourd\'hui : accepté', () {
      expect(oldEnough(DateTime(2011, 11, 9), today), isTrue);
    });

    test('15 ans demain : refusé', () {
      expect(oldEnough(DateTime(2011, 11, 10), today), isFalse);
    });

    test('[T2] : 12/03/2013, refusé', () {
      expect(oldEnough(DateTime(2013, 3, 12), today), isFalse);
    });
  });
}
