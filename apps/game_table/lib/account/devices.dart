// Appareils connectés (US-12, EF-CPT-05) : de quoi nommer une session
// d'après son User-Agent, et dire depuis quand elle est inactive. Les
// libellés eux-mêmes viennent des ARB.

/// Forme de l'appareil, pour son icône et son nom.
enum DeviceForm { phone, tablet, computer, unknown }

enum DevicePlatform { windows, macos, linux, android, iphone, ipad }

/// Ce qu'on sait d'un appareil.
final class DeviceInfo {
  const DeviceInfo({
    this.form = DeviceForm.unknown,
    this.platform,
    this.browser,
  });

  final DeviceForm form;
  final DevicePlatform? platform;

  /// Navigateur, pour la version Web ; `null` pour une app native.
  final String? browser;

  @override
  bool operator ==(Object other) =>
      other is DeviceInfo &&
      other.form == form &&
      other.platform == platform &&
      other.browser == browser;

  @override
  int get hashCode => Object.hash(form, platform, browser);

  @override
  String toString() => 'DeviceInfo($form, $platform, $browser)';
}

/// User-Agent envoyé par les apps natives, qui n'en ont pas de lisible :
/// `Tavernier (android; phone)`.
String nativeUserAgent(String operatingSystem, {required bool tablet}) {
  final form = switch (operatingSystem) {
    'android' || 'ios' => tablet ? 'tablet' : 'phone',
    _ => 'computer',
  };
  return 'Tavernier ($operatingSystem; $form)';
}

/// Appareil d'après le User-Agent d'une session.
DeviceInfo describeUserAgent(String? userAgent) {
  final ua = userAgent ?? '';
  final native = RegExp(r'^Tavernier \((\w+); (\w+)\)').firstMatch(ua);
  if (native != null) {
    final form = DeviceForm.values.asNameMap()[native[2]] ?? DeviceForm.unknown;
    return DeviceInfo(
      form: form,
      platform: switch (native[1]) {
        'android' => DevicePlatform.android,
        'ios' =>
          form == DeviceForm.tablet
              ? DevicePlatform.ipad
              : DevicePlatform.iphone,
        'windows' => DevicePlatform.windows,
        'macos' => DevicePlatform.macos,
        'linux' => DevicePlatform.linux,
        _ => null,
      },
    );
  }
  if (!ua.startsWith('Mozilla/')) return const DeviceInfo();

  final (platform, form) = ua.contains('iPhone')
      ? (DevicePlatform.iphone, DeviceForm.phone)
      : ua.contains('iPad')
      ? (DevicePlatform.ipad, DeviceForm.tablet)
      : ua.contains('Android')
      ? (
          DevicePlatform.android,
          ua.contains('Mobile') ? DeviceForm.phone : DeviceForm.tablet,
        )
      : ua.contains('Windows')
      ? (DevicePlatform.windows, DeviceForm.computer)
      : ua.contains('Macintosh')
      ? (DevicePlatform.macos, DeviceForm.computer)
      : ua.contains('Linux')
      ? (DevicePlatform.linux, DeviceForm.computer)
      : (null, DeviceForm.unknown);
  // L'ordre compte : Edge et Chrome se disent aussi « Safari ».
  final browser = ua.contains('Edg/')
      ? 'Edge'
      : ua.contains('Firefox/')
      ? 'Firefox'
      : ua.contains('Chrome/') || ua.contains('CriOS/')
      ? 'Chrome'
      : ua.contains('Safari/')
      ? 'Safari'
      : null;
  return DeviceInfo(form: form, platform: platform, browser: browser);
}

/// Unité de la durée d'inactivité.
enum ActivityUnit { now, minutes, hours, days, weeks, months }

/// Inactivité d'un appareil : « actif maintenant » ou « il y a [count]
/// [unit] ».
final class Activity {
  const Activity(this.unit, this.count);

  const Activity.now() : unit = ActivityUnit.now, count = 0;

  final ActivityUnit unit;
  final int count;

  @override
  bool operator ==(Object other) =>
      other is Activity && other.unit == unit && other.count == count;

  @override
  int get hashCode => Object.hash(unit, count);

  @override
  String toString() => 'Activity($unit, $count)';
}

/// Inactivité entre [lastActive] et [now] ; moins de 5 minutes compte comme
/// « maintenant ».
Activity activitySince(DateTime lastActive, DateTime now) {
  final gap = now.difference(lastActive);
  if (gap.inMinutes < 5) return const Activity.now();
  if (gap.inHours < 1) return Activity(ActivityUnit.minutes, gap.inMinutes);
  if (gap.inDays < 1) return Activity(ActivityUnit.hours, gap.inHours);
  if (gap.inDays < 7) return Activity(ActivityUnit.days, gap.inDays);
  if (gap.inDays < 30) return Activity(ActivityUnit.weeks, gap.inDays ~/ 7);
  return Activity(ActivityUnit.months, gap.inDays ~/ 30);
}
