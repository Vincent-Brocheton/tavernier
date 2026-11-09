// Doubles de test du compte, partagés par les tests d'écrans.
import 'package:game_table/account/account_gateway.dart';
import 'package:game_table/account/account_providers.dart';
import 'package:game_table/account/devices.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthState, User, UserIdentity;

final class FakeGateway implements AccountGateway {
  FakeGateway({this.signedIn = true});

  /// Faux : page ouverte sans le lien de réinitialisation.
  final bool signedIn;
  SignInOutcome outcome = SignInOutcome.signedIn;
  SignUpOutcome signUpOutcome = SignUpOutcome.signedIn;
  final signIns = <(String, String)>[];
  final signUps = <(String, String, String, DateTime)>[];
  final resets = <String>[];
  final updates = <(String, bool)>[];

  @override
  User? get user => !signedIn
      ? null
      : const User(
          id: 'u1',
          appMetadata: {},
          userMetadata: {},
          aud: 'authenticated',
          createdAt: '2026-11-09T10:00:00Z',
          email: 'hugo@exemple.fr',
        );

  @override
  Stream<AuthState> get changes => const Stream.empty();

  @override
  DateTime? get resetLinkExpiry =>
      DateTime.now().add(const Duration(minutes: 48, seconds: 30));

  @override
  Future<SignInOutcome> signIn(String email, String password) async {
    signIns.add((email, password));
    return outcome;
  }

  @override
  Future<SignUpOutcome> signUp({
    required String email,
    required String password,
    required String pseudonym,
    required DateTime birthDate,
    String? redirectTo,
  }) async {
    signUps.add((email, password, pseudonym, birthDate));
    return signUpOutcome;
  }

  var signedOut = false;
  final resent = <String>[];

  /// Compte Google : identité liée, âge à vérifier, mot de passe absent.
  bool google = false;
  bool ageCheckedValue = true;
  bool hasPasswordValue = true;
  bool ageAccepted = true;
  final calls = <String>[];

  @override
  Future<void> signInWithGoogle({String? redirectTo}) async =>
      calls.add('google');

  @override
  bool get ageChecked => ageCheckedValue;

  @override
  Future<bool> confirmAge(DateTime birthDate) async {
    calls.add('age ${birthDate.year}');
    return ageAccepted;
  }

  @override
  Future<bool> hasPassword() async => hasPasswordValue;

  @override
  UserIdentity? get googleIdentity => !google
      ? null
      : const UserIdentity(
          id: 'g1',
          userId: 'u1',
          identityData: {'email': 'ines.l@gmail.com'},
          identityId: 'g1',
          provider: 'google',
          createdAt: '2026-11-09T10:00:00Z',
          lastSignInAt: '2026-11-09T10:00:00Z',
        );

  @override
  Future<void> linkGoogle({String? redirectTo}) async => calls.add('link');

  @override
  Future<void> unlinkGoogle() async => calls.add('unlink');

  @override
  Future<PasswordChangeOutcome> addPassword(String password) async {
    calls.add('add $password');
    return PasswordChangeOutcome.changed;
  }

  final emailChanges = <String>[];
  PasswordChangeOutcome passwordOutcome = PasswordChangeOutcome.changed;
  final passwordChanges = <(String, String)>[];

  @override
  Future<void> changeEmail(String email, {String? redirectTo}) async =>
      emailChanges.add(email);

  @override
  Future<PasswordChangeOutcome> changePassword(
    String current,
    String next,
  ) async {
    passwordChanges.add((current, next));
    return passwordOutcome;
  }

  @override
  Future<void> resendConfirmation(String email, {String? redirectTo}) async =>
      resent.add(email);

  @override
  Future<void> signOut() async => signedOut = true;

  @override
  Future<void> requestPasswordReset(String email, {String? redirectTo}) async =>
      resets.add(email);

  @override
  Future<void> updatePassword(
    String password, {
    required bool signOutOthers,
  }) async => updates.add((password, signOutOthers));
}

final class FakeSession implements SessionActions {
  FakeSession(this.pending, {this.online = true});

  final int pending;
  final bool online;
  var signedOut = false;
  final revoked = <String>[];
  final _devices = [
    ConnectedDevice(
      id: 's1',
      info: describeUserAgent(
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/131.0 Safari/537.36',
      ),
      lastActive: DateTime.now(),
      current: true,
    ),
    ConnectedDevice(
      id: 's2',
      info: describeUserAgent('Tavernier (android; phone)'),
      lastActive: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
      current: false,
    ),
  ];

  @override
  Future<List<ConnectedDevice>> devices() async {
    if (!online) throw Exception('hors ligne');
    return [
      for (final d in _devices)
        if (!revoked.contains(d.id)) d,
    ];
  }

  /// Faux : la déconnexion à distance échoue faute de réseau.
  var revokeFails = false;

  @override
  Future<void> revokeDevice(String id) async {
    if (revokeFails) throw Exception('hors ligne');
    revoked.add(id);
  }

  final renames = <String>[];

  @override
  Future<void> renameProfile(String userId, String pseudonym) async =>
      renames.add(pseudonym);

  @override
  Future<int> pendingUploads() async => pending;

  @override
  Future<void> signOut() async => signedOut = true;
}
