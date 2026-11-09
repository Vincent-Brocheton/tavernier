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

/// Échec d'une demande sans réponse du serveur.
final class AccountNetworkException implements Exception {
  const AccountNetworkException();
}

/// Accès au compte par Supabase Auth.
class AccountGateway {
  AccountGateway(this._auth);

  final GoTrueClient _auth;

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
