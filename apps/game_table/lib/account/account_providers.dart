// Compte et synchronisation (US-39, T-05) : configuration de Supabase,
// session, réseau, et connexion de la base PowerSync quand un utilisateur
// est connecté.
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../creation/creation_providers.dart';
import 'account_gateway.dart';
import 'password_policy.dart';

/// Projet Supabase, sa clé publique et le service PowerSync, passés au
/// build par `--dart-define` (rien de secret). Sans eux, l'app reste
/// entièrement locale.
const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabasePublishableKey = String.fromEnvironment(
  'SUPABASE_PUBLISHABLE_KEY',
);
const powerSyncUrl = String.fromEnvironment('POWERSYNC_URL');

/// Vrai si l'app a de quoi se connecter à un compte.
const accountsConfigured =
    supabaseUrl != '' && supabasePublishableKey != '' && powerSyncUrl != '';

/// Initialise Supabase, qui garde la session sur l'appareil : elle reste
/// valide hors ligne (EF-CPT-02).
Future<void> initAccounts() async {
  if (!accountsConfigured) return;
  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabasePublishableKey,
  );
}

/// Accès au compte, ou `null` sans configuration.
final accountGatewayProvider = Provider<AccountGateway?>(
  (ref) =>
      accountsConfigured ? AccountGateway(Supabase.instance.client.auth) : null,
);

/// Utilisateur connecté, mis à jour à chaque changement de session.
final currentUserProvider = StreamProvider<User?>((ref) async* {
  final gateway = ref.watch(accountGatewayProvider);
  if (gateway == null) {
    yield null;
    return;
  }
  yield gateway.user;
  await for (final change in gateway.changes) {
    yield change.session?.user;
  }
});

/// Vrai si l'appareil a une interface réseau.
final onlineProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  bool online(List<ConnectivityResult> r) =>
      r.any((c) => c != ConnectivityResult.none);
  yield online(await connectivity.checkConnectivity());
  yield* connectivity.onConnectivityChanged.map(online);
});

/// Vérification des mots de passe divulgués (Have I Been Pwned).
final breachedPasswordsProvider = Provider<BreachedPasswords>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return BreachedPasswords(client);
});

/// Pseudo de l'utilisateur connecté, d'après son profil local.
final pseudonymProvider = FutureProvider<String?>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return null;
  final row = await ref
      .watch(databaseProvider)
      .customSelect(
        'SELECT pseudonym FROM profile WHERE id = ?',
        variables: [Variable.withString(user.id)],
      )
      .getSingleOrNull();
  return row?.read<String>('pseudonym');
});

/// Connecte la base PowerSync tant qu'un utilisateur est connecté, et la
/// déconnecte sinon. À surveiller depuis la racine de l'app.
final syncProvider = Provider<void>((ref) {
  if (!accountsConfigured) return;
  final user = ref.watch(currentUserProvider).value;
  final database = ref.watch(databaseProvider);
  final powerSync = database.powerSync;
  if (powerSync == null) return;
  if (user == null) {
    powerSync.then((db) => db.disconnect());
  } else {
    powerSync.then(
      (db) => db.connect(
        connector: SupabaseConnector(Supabase.instance.client, powerSyncUrl),
      ),
    );
  }
});
