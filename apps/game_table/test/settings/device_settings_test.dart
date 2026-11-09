// Spec account : « Réglages d'affichage », « Consentement aux rapports de
// crash ».
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/settings/device_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> _container(Map<String, Object> values) async {
  SharedPreferences.setMockInitialValues(values);
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('premier lancement : consentement à demander, texte à 100 %', () async {
    final container = await _container({});
    final settings = container.read(deviceSettingsProvider);
    expect(settings.crashReports, isNull);
    expect(settings.textScale, 1);
  });

  test('réglages gardés et relus au lancement suivant', () async {
    final first = await _container({});
    await first.read(deviceSettingsProvider.notifier).setTextScale(1.5);
    await first.read(deviceSettingsProvider.notifier).setCrashReports(true);

    final prefs = await SharedPreferences.getInstance();
    final next = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(next.dispose);
    final settings = next.read(deviceSettingsProvider);
    expect(settings.textScale, 1.5);
    expect(settings.crashReports, isTrue);
  });

  test('taille du texte bornée de 85 % à 200 %', () async {
    final container = await _container({'text_scale': 3.0});
    expect(container.read(deviceSettingsProvider).textScale, 2);
    await container.read(deviceSettingsProvider.notifier).setTextScale(0.5);
    expect(container.read(deviceSettingsProvider).textScale, 0.85);
  });

  test('sans stockage : refus, rien à demander', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(deviceSettingsProvider).crashReports, isFalse);
  });
}
