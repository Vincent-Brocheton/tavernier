// Compte Supabase (US-39) : connexion, mot de passe oublié, nouveau mot de
// passe. Les écrans ne lisent jamais le texte d'erreur du serveur : chaque
// échec se ramène à une issue, qui choisit le message (EF-CPT-07).
import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Issue d'une connexion.
enum SignInOutcome {
  signedIn,

  /// E-mail inconnu ou mot de passe faux : un seul message pour les deux.
  invalidCredentials,

  /// Pas de réponse du serveur.
  network,

  /// Autre refus (trop d'essais…).
  failed,
}

/// Issue d'une inscription.
enum SignUpOutcome {
  signedIn,

  /// Confirmation par e-mail attendue ; aussi la réponse pour une adresse
  /// déjà prise, pour ne pas révéler l'existence d'un compte (EF-CPT-07).
  confirmEmail,

  /// Pas de réponse du serveur.
  network,

  /// Autre refus.
  failed,
}

/// Issue d'un changement de mot de passe.
enum PasswordChangeOutcome { changed, wrongCurrent, network, failed }

/// Échec d'une demande sans réponse du serveur.
final class AccountNetworkException implements Exception {
  const AccountNetworkException();
}

/// Accès au compte par Supabase Auth.
class AccountGateway {
  AccountGateway(this._client);

  final SupabaseClient _client;
  GoTrueClient get _auth => _client.auth;

  /// Utilisateur connecté, ou `null`.
  User? get user => _auth.currentUser;

  /// Changements de session (connexion, déconnexion, lien de
  /// réinitialisation suivi).
  Stream<AuthState> get changes => _auth.onAuthStateChange;

  Future<SignInOutcome> signIn(String email, String password) async {
    try {
      await _auth.signInWithPassword(email: email.trim(), password: password);
      return SignInOutcome.signedIn;
    } on AuthRetryableFetchException {
      return SignInOutcome.network;
    } on AuthApiException catch (e) {
      return const {
            'invalid_credentials',
            'email_not_confirmed',
            'user_not_found',
          }.contains(e.code)
          ? SignInOutcome.invalidCredentials
          : SignInOutcome.failed;
    } on AuthException {
      return SignInOutcome.failed;
    }
  }

  /// Crée un compte par e-mail. Le serveur vérifie les 15 ans d'après
  /// [birthDate] et ne la garde pas ; il crée le profil avec [pseudonym].
  Future<SignUpOutcome> signUp({
    required String email,
    required String password,
    required String pseudonym,
    required DateTime birthDate,
    String? redirectTo,
  }) async {
    try {
      final response = await _auth.signUp(
        email: email.trim(),
        password: password,
        emailRedirectTo: redirectTo,
        data: {
          'pseudonym': pseudonym.trim(),
          'birth_date':
              '${birthDate.year.toString().padLeft(4, '0')}-'
              '${birthDate.month.toString().padLeft(2, '0')}-'
              '${birthDate.day.toString().padLeft(2, '0')}',
        },
      );
      return response.session == null
          ? SignUpOutcome.confirmEmail
          : SignUpOutcome.signedIn;
    } on AuthRetryableFetchException {
      return SignUpOutcome.network;
    } on AuthApiException catch (e) {
      return e.code == 'user_already_exists' || e.code == 'email_exists'
          ? SignUpOutcome.confirmEmail
          : SignUpOutcome.failed;
    } on AuthException {
      return SignUpOutcome.failed;
    }
  }

  /// Renvoie l'e-mail de confirmation d'inscription. Comme pour le mot de
  /// passe oublié, la réponse ne dit jamais si le compte existe ; seule
  /// l'absence de réseau lève [AccountNetworkException].
  Future<void> resendConfirmation(String email, {String? redirectTo}) async {
    try {
      await _auth.resend(
        type: OtpType.signup,
        email: email.trim(),
        emailRedirectTo: redirectTo,
      );
    } on AuthRetryableFetchException {
      throw const AccountNetworkException();
    } on AuthException {
      // Adresse inconnue, déjà confirmée ou trop de demandes : même réponse.
    }
  }

  /// Demande le passage à [email] : un lien de confirmation part vers la
  /// nouvelle adresse, l'ancienne reste active jusque-là (EF-CPT-09). La
  /// réponse ne dit jamais si l'adresse est déjà prise ; seule l'absence de
  /// réseau lève [AccountNetworkException].
  Future<void> changeEmail(String email, {String? redirectTo}) async {
    try {
      await _auth.updateUser(
        UserAttributes(email: email.trim()),
        emailRedirectTo: redirectTo,
      );
    } on AuthRetryableFetchException {
      throw const AccountNetworkException();
    } on AuthException {
      // Adresse prise, invalide ou trop de demandes : même réponse.
    }
  }

  /// Change le mot de passe après avoir vérifié [current] par une connexion.
  Future<PasswordChangeOutcome> changePassword(
    String current,
    String next,
  ) async {
    final email = user?.email;
    if (email == null) return PasswordChangeOutcome.failed;
    switch (await signIn(email, current)) {
      case SignInOutcome.signedIn:
        break;
      case SignInOutcome.invalidCredentials:
        return PasswordChangeOutcome.wrongCurrent;
      case SignInOutcome.network:
        return PasswordChangeOutcome.network;
      case SignInOutcome.failed:
        return PasswordChangeOutcome.failed;
    }
    try {
      await _auth.updateUser(UserAttributes(password: next));
      return PasswordChangeOutcome.changed;
    } on AuthRetryableFetchException {
      return PasswordChangeOutcome.network;
    } on AuthException {
      return PasswordChangeOutcome.failed;
    }
  }

  /// Connexion ou inscription par Google (redirection, sur le Web).
  Future<void> signInWithGoogle({String? redirectTo}) async {
    try {
      await _auth.signInWithOAuth(OAuthProvider.google, redirectTo: redirectTo);
    } on AuthRetryableFetchException {
      throw const AccountNetworkException();
    }
  }

  /// Vrai si l'âge de l'utilisateur a été vérifié : à l'inscription par
  /// e-mail, ou par [confirmAge] pour un compte Google (EF-CPT-01).
  bool get ageChecked => user?.userMetadata?['age_checked_at'] != null;

  /// Déclare la date de naissance d'un compte créé sans elle. Vrai à 15 ans
  /// révolus ; sinon le serveur supprime le compte, et la session locale est
  /// fermée.
  Future<bool> confirmAge(DateTime birthDate) async {
    final ok = await _client.rpc<bool>(
      'confirm_age',
      params: {
        'birth_date':
            '${birthDate.year.toString().padLeft(4, '0')}-'
            '${birthDate.month.toString().padLeft(2, '0')}-'
            '${birthDate.day.toString().padLeft(2, '0')}',
      },
    );
    if (ok) {
      // Les métadonnées de la session portent maintenant la vérification.
      await _auth.refreshSession();
    } else {
      await signOut();
    }
    return ok;
  }

  /// Vrai si le compte a un mot de passe (un compte Google n'en a pas).
  Future<bool> hasPassword() => _client.rpc<bool>('has_password');

  /// Identité Google liée au compte, ou `null`.
  UserIdentity? get googleIdentity =>
      user?.identities?.where((i) => i.provider == 'google').firstOrNull;

  /// Lie Google au compte (redirection, sur le Web).
  Future<void> linkGoogle({String? redirectTo}) =>
      _auth.linkIdentity(OAuthProvider.google, redirectTo: redirectTo);

  /// Retire Google ; à n'appeler que s'il reste une autre méthode.
  Future<void> unlinkGoogle() async {
    final identity = googleIdentity;
    if (identity == null) return;
    await _auth.unlinkIdentity(identity);
    await _auth.refreshSession();
  }

  /// Ajoute un mot de passe à un compte qui n'en a pas (compte Google).
  Future<PasswordChangeOutcome> addPassword(String password) async {
    try {
      await _auth.updateUser(UserAttributes(password: password));
      return PasswordChangeOutcome.changed;
    } on AuthRetryableFetchException {
      return PasswordChangeOutcome.network;
    } on AuthException {
      return PasswordChangeOutcome.failed;
    }
  }

  /// Ferme la session sur cet appareil seulement. Sans réseau, la session
  /// locale est quand même oubliée.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on AuthException {
      // Le serveur n'a pas répondu : la session locale est déjà effacée.
    }
  }

  /// Demande un lien de réinitialisation. Le résultat ne dit jamais si le
  /// compte existe ; seule l'absence de réseau lève
  /// [AccountNetworkException].
  Future<void> requestPasswordReset(String email, {String? redirectTo}) async {
    try {
      await _auth.resetPasswordForEmail(email.trim(), redirectTo: redirectTo);
    } on AuthRetryableFetchException {
      throw const AccountNetworkException();
    } on AuthException {
      // Adresse inconnue, mal formée ou trop de demandes : même réponse.
    }
  }

  /// Fin de validité du lien de réinitialisation suivi (1 heure après son
  /// envoi), ou `null` si on ne la connaît pas.
  DateTime? get resetLinkExpiry {
    final sent = DateTime.tryParse(user?.recoverySentAt ?? '');
    return sent?.add(const Duration(hours: 1));
  }

  /// Enregistre le nouveau mot de passe, puis déconnecte les autres
  /// appareils si [signOutOthers].
  Future<void> updatePassword(
    String password, {
    required bool signOutOthers,
  }) async {
    try {
      await _auth.updateUser(UserAttributes(password: password));
      if (signOutOthers) await _auth.signOut(scope: SignOutScope.others);
    } on AuthRetryableFetchException {
      throw const AccountNetworkException();
    }
  }
}
