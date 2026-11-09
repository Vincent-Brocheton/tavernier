// Retours de Supabase Auth dans l'adresse (US-39, US-12). Supabase revient à
// l'app avec ses paramètres après « # », que le routeur lit comme un chemin :
// « #error=access_denied&error_code=otp_expired… » ou
// « #access_token=… ». On les ramène à un écran connu, au lieu d'une page
// introuvable. Le flux PKCE (« ?code=… ») passe par la racine, sans rien à
// faire ici.

/// Nouvelle adresse pour un retour d'authentification, ou `null` pour une
/// adresse ordinaire.
String? authCallbackRedirect(Uri location) {
  final path = location.path;
  if (path.contains('error_code=') || path.startsWith('/error=')) {
    return '/connexion?lien=invalide';
  }
  if (path.contains('access_token=')) return '/';
  return null;
}
