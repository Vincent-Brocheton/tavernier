import 'package:web/web.dart';

/// Navigateur courant, d'après son agent utilisateur.
String browserName() {
  final agent = window.navigator.userAgent;
  for (final (marker, name) in [
    ('Edg/', 'edge'),
    ('Firefox/', 'firefox'),
    ('Chrome/', 'chrome'),
    ('Safari/', 'safari'),
  ]) {
    if (agent.contains(marker)) return name;
  }
  return agent;
}
