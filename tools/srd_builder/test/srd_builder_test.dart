import 'package:srd_builder/srd_builder.dart';
import 'package:test/test.dart';

void main() {
  test("sans commande, affiche l'aide et réussit", () {
    final out = StringBuffer();
    expect(run([], out, StringBuffer()), 0);
    expect(out.toString(), contains('srd_builder build'));
  });

  test('une option inconnue échoue avec le code 64', () {
    final err = StringBuffer();
    expect(run(['--inconnue'], StringBuffer(), err), 64);
    expect(err.toString(), isNotEmpty);
  });
}
