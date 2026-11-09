// Spec account : « Appareils connectés » (EF-CPT-05).
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/devices.dart';

void main() {
  group('appareil d\'après le User-Agent', () {
    test('navigateurs', () {
      expect(
        describeUserAgent(
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
          '(KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36',
        ),
        const DeviceInfo(
          form: DeviceForm.computer,
          platform: DevicePlatform.windows,
          browser: 'Chrome',
        ),
      );
      expect(
        describeUserAgent(
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 14.5; rv:132.0) '
          'Gecko/20100101 Firefox/132.0',
        ),
        const DeviceInfo(
          form: DeviceForm.computer,
          platform: DevicePlatform.macos,
          browser: 'Firefox',
        ),
      );
      expect(
        describeUserAgent(
          'Mozilla/5.0 (iPhone; CPU iPhone OS 18_1 like Mac OS X) '
          'AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.1 '
          'Mobile/15E148 Safari/604.1',
        ),
        const DeviceInfo(
          form: DeviceForm.phone,
          platform: DevicePlatform.iphone,
          browser: 'Safari',
        ),
      );
      expect(
        describeUserAgent(
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
          '(KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0',
        ).browser,
        'Edge',
      );
      expect(
        describeUserAgent(
          'Mozilla/5.0 (Linux; Android 15; Pixel 8) AppleWebKit/537.36 '
          '(KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36',
        ),
        const DeviceInfo(
          form: DeviceForm.phone,
          platform: DevicePlatform.android,
          browser: 'Chrome',
        ),
      );
    });

    test('applications natives', () {
      expect(
        describeUserAgent('Tavernier (android; phone)'),
        const DeviceInfo(
          form: DeviceForm.phone,
          platform: DevicePlatform.android,
        ),
      );
      expect(
        describeUserAgent('Tavernier (ios; tablet)'),
        const DeviceInfo(
          form: DeviceForm.tablet,
          platform: DevicePlatform.ipad,
        ),
      );
      expect(
        describeUserAgent('Tavernier (windows; computer)'),
        const DeviceInfo(
          form: DeviceForm.computer,
          platform: DevicePlatform.windows,
        ),
      );
    });

    test('inconnu', () {
      expect(describeUserAgent(null), const DeviceInfo());
      expect(describeUserAgent('curl/8.0'), const DeviceInfo());
    });

    test('User-Agent des apps natives, relu par describeUserAgent', () {
      expect(
        describeUserAgent(nativeUserAgent('android', tablet: false)),
        const DeviceInfo(
          form: DeviceForm.phone,
          platform: DevicePlatform.android,
        ),
      );
      expect(
        nativeUserAgent('macos', tablet: false),
        'Tavernier (macos; computer)',
      );
    });
  });

  group('dernière activité', () {
    final now = DateTime.utc(2026, 11, 9, 12);
    Activity ago(Duration d) => activitySince(now.subtract(d), now);

    test('moins de 5 minutes : maintenant', () {
      expect(ago(const Duration(minutes: 4)), const Activity.now());
    });

    test('minutes, heures, jours, semaines, mois', () {
      expect(
        ago(const Duration(minutes: 42)),
        const Activity(ActivityUnit.minutes, 42),
      );
      expect(
        ago(const Duration(hours: 1, minutes: 5)),
        const Activity(ActivityUnit.hours, 1),
      );
      expect(
        ago(const Duration(days: 2, hours: 3)),
        const Activity(ActivityUnit.days, 2),
      );
      expect(
        ago(const Duration(days: 21)),
        const Activity(ActivityUnit.weeks, 3),
      );
      expect(
        ago(const Duration(days: 65)),
        const Activity(ActivityUnit.months, 2),
      );
    });
  });
}
