import 'package:dnd_content/dnd_content.dart';
import 'package:test/test.dart';

void main() {
  test('découpe un identifiant en namespace, type et slug', () {
    final id = ContentId.tryParse('srd:background:soldier')!;
    expect(id.namespace, 'srd');
    expect(id.type, 'background');
    expect(id.slug, 'soldier');
    expect(id.toString(), 'srd:background:soldier');
  });

  test('accepte un type composé', () {
    expect(ContentId.tryParse('srd:damage-type:fire')!.type, 'damage-type');
  });

  test('refuse les identifiants mal formés', () {
    for (final bad in [
      'srd:background',
      'SRD:background:soldier',
      'srd:background:Soldat',
      'srd:background:soldier-',
      'srd::soldier',
      'srd:background:soldier:extra',
    ]) {
      expect(ContentId.isValid(bad), isFalse, reason: bad);
      expect(ContentId.tryParse(bad), isNull, reason: bad);
    }
  });

  test('deux identifiants identiques sont égaux', () {
    expect(
      ContentId.tryParse('srd:feat:alert'),
      ContentId.tryParse('srd:feat:alert'),
    );
    expect(
      ContentId.tryParse('srd:feat:alert').hashCode,
      ContentId.tryParse('srd:feat:alert').hashCode,
    );
  });

  test('un problème de validation affiche son chemin', () {
    expect(
      const ContentIssue('effects[0].op', 'opération inconnue').toString(),
      'effects[0].op : opération inconnue',
    );
  });
}
