import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('milliers séparés par une espace fine insécable', () {
    expect(formatThousands(0), '0');
    expect(formatThousands(475), '475');
    expect(formatThousands(7475), '7 475');
    expect(formatThousands(355000), '355 000');
    expect(formatThousands(1234567), '1 234 567');
    expect(formatThousands(-1500), '−1 500');
  });

  test('signe moins typographique', () {
    expect(formatSigned(-1), '−1');
    expect(formatSigned(3), '+3');
  });
}
