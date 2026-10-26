// Spec ui-kit : « Tokens issus de la source de vérité ». Chaque valeur du kit
// est comparée à docs/design/design_tokens.json.
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

final Map<String, Object?> _json = jsonDecode(
  File('../../docs/design/design_tokens.json').readAsStringSync(),
) as Map<String, Object?>;

Map<String, Object?> _at(String path) {
  Object? node = _json;
  for (final key in path.split('.')) {
    node = (node! as Map<String, Object?>)[key];
  }
  return node! as Map<String, Object?>;
}

Color _hex(Object? token) {
  final value = (token! as Map<String, Object?>)[r'$value']! as String;
  return Color(int.parse('FF${value.substring(1)}', radix: 16));
}

/// Jetons de [path], sans les clés de métadonnées (`$type`, `$description`).
Map<String, Object?> _tokens(String path) => {
  for (final MapEntry(:key, :value) in _at(path).entries)
    if (!key.startsWith(r'$')) key: value,
};

void _expectColors(String path, Map<String, Color> actual) {
  final expected = _tokens(path);
  expect(actual.keys.toSet(), expected.keys.toSet(), reason: path);
  for (final MapEntry(:key, :value) in expected.entries) {
    expect(actual[key], _hex(value), reason: '$path.$key');
  }
}

void _expectNumbers(String path, Map<String, num> actual) {
  final expected = _tokens(path);
  expect(actual.keys.toSet(), expected.keys.toSet(), reason: path);
  for (final MapEntry(:key, :value) in expected.entries) {
    final number = value is Map ? value[r'$value'] : value;
    expect(actual[key], number, reason: '$path.$key');
  }
}

void main() {
  test('couleurs Material sombres et claires', () {
    _expectColors('color.dark', AppTokens.darkColors);
    _expectColors('color.light', AppTokens.lightColors);
  });

  test('couleurs de jeu sombres et claires', () {
    _expectColors('semantic.dark', AppTokens.darkGameColors);
    _expectColors('semantic.light', AppTokens.lightGameColors);
  });

  test('échelle typographique', () {
    final families = _tokens('typography.fontFamily');
    expect(AppTokens.displayFamily, _value(families['display']));
    expect(AppTokens.textFamily, _value(families['text']));
    final scale = _tokens('typography.scale');
    expect(AppTokens.typeScale.keys.toSet(), scale.keys.toSet());
    for (final MapEntry(:key, :value) in scale.entries) {
      final t = value! as Map<String, Object?>;
      final actual = AppTokens.typeScale[key]!;
      expect(
        (
          actual.display,
          actual.size,
          actual.lineHeight,
          actual.weight,
          actual.letterSpacing,
        ),
        (
          t['family'] == 'display',
          t['size'],
          t['lineHeight'],
          t['weight'],
          t['letterSpacing'] ?? 0,
        ),
        reason: 'typography.scale.$key',
      );
    }
    final textScale = _at('typography.textScale');
    expect(AppTokens.textScaleMin, textScale['min']);
    expect(AppTokens.textScaleMax, textScale['max']);
  });

  test('espacements, rayons, tailles', () {
    _expectNumbers('spacing', AppTokens.spacing);
    _expectNumbers('radius', AppTokens.radius);
    _expectNumbers('size', AppTokens.size);
  });

  test('points de rupture, états, mouvement, grain', () {
    final b = _at('breakpoints');
    expect(AppTokens.phoneMaxWidth, (b['phone']! as Map)['max']);
    expect(AppTokens.desktopMinWidth, (b['desktop']! as Map)['min']);
    expect(AppTokens.tabletMinWidth, (b['tabletLandscape']! as Map)['min']);
    _expectNumbers('state', AppTokens.state);
    final motion = _at('motion');
    expect(
      AppTokens.motionStandardMs,
      (motion['standard']! as Map)['duration'],
    );
    expect(
      AppTokens.motionEmphasizedMs,
      (motion['emphasized']! as Map)['duration'],
    );
    for (final kind in ['standard', 'emphasized']) {
      final easing = (motion[kind]! as Map)['easing']! as String;
      final numbers = RegExp(r'[\d.]+')
          .allMatches(easing)
          .map((m) => double.parse(m[0]!))
          .toList();
      final (a, b, c, d) = AppTokens.motionCurve;
      expect([a, b, c, d], numbers, reason: 'motion.$kind.easing');
    }
    final grain = _at('texture.grain');
    expect(AppTokens.grainOpacity, grain['opacity']);
    expect(
      AppTokens.grainOpacityOnColoredCover,
      grain['opacityOnColoredCover'],
    );
  });
}

Object? _value(Object? token) => (token! as Map<String, Object?>)[r'$value'];
