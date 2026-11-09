// Réglages de l'appareil (US-12, EF-CPT-03, EF-CPT-06) : taille du texte et
// consentement aux rapports de plantage. Gardés sur l'appareil, jamais
// synchronisés.
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stockage de l'appareil, ouvert dans `main` avant le premier affichage ;
/// `null` sans stockage (tests) : les réglages restent en mémoire.
final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) => null);

final class DeviceSettings {
  const DeviceSettings({this.textScale = 1, this.crashReports});

  /// Facteur appliqué à la taille du texte du système, de 0,85 à 2.
  final double textScale;

  /// Consentement aux rapports de plantage ; `null` tant qu'il n'a pas été
  /// demandé.
  final bool? crashReports;
}

final deviceSettingsProvider =
    NotifierProvider<DeviceSettingsNotifier, DeviceSettings>(
      DeviceSettingsNotifier.new,
    );

class DeviceSettingsNotifier extends Notifier<DeviceSettings> {
  static const _textScaleKey = 'text_scale';
  static const _crashReportsKey = 'crash_reports';

  SharedPreferences? get _prefs => ref.read(sharedPreferencesProvider);

  @override
  DeviceSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    // Sans stockage, pas de consentement à recueillir : refus, la valeur sûre.
    if (prefs == null) return const DeviceSettings(crashReports: false);
    return DeviceSettings(
      textScale: (prefs.getDouble(_textScaleKey) ?? 1).clamp(
        AppTokens.textScaleMin,
        AppTokens.textScaleMax,
      ),
      crashReports: prefs.getBool(_crashReportsKey),
    );
  }

  Future<void> setTextScale(double scale) async {
    final value = scale.clamp(AppTokens.textScaleMin, AppTokens.textScaleMax);
    state = DeviceSettings(textScale: value, crashReports: state.crashReports);
    await _prefs?.setDouble(_textScaleKey, value);
  }

  Future<void> setCrashReports(bool consent) async {
    state = DeviceSettings(textScale: state.textScale, crashReports: consent);
    await _prefs?.setBool(_crashReportsKey, consent);
  }
}
