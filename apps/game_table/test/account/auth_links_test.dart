// Retours de Supabase Auth dans l'adresse (US-39, US-12) : un lien expiré ou
// déjà servi ne doit jamais faire planter la navigation.
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/auth_links.dart';

void main() {
  test('lien en erreur : vers la connexion, avec le motif', () {
    // Le fragment « #error=… » est lu comme un chemin par le routeur.
    expect(
      authCallbackRedirect(
        Uri.parse(
          '/error=access_denied&error_code=otp_expired'
          '&error_description=Email+link+is+invalid+or+has+expired&sb=',
        ),
      ),
      '/connexion?lien=invalide',
    );
  });

  test('jeton dans le fragment (flux implicite) : vers l\'accueil', () {
    expect(
      authCallbackRedirect(Uri.parse('/access_token=abc&type=signup')),
      '/',
    );
  });

  test('adresse ordinaire : rien à faire', () {
    for (final location in ['/', '/connexion', '/characters/42', '/?code=x']) {
      expect(
        authCallbackRedirect(Uri.parse(location)),
        isNull,
        reason: location,
      );
    }
  });
}
