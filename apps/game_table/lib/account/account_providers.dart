// Compte et synchronisation (US-39, T-05) : configuration de Supabase,
// session, réseau, et connexion de la base PowerSync quand un utilisateur
// est connecté.
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../creation/creation_providers.dart';
import 'account_gateway.dart';
import 'devices.dart';
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
    // Un navigateur donne son User-Agent ; une app native se nomme, pour la
    // liste des appareils connectés (EF-CPT-05).
    headers: kIsWeb ? null : {'User-Agent': _nativeUserAgent()},
  );
}

String _nativeUserAgent() {
  final view = PlatformDispatcher.instance.views.first;
  final shortest = view.physicalSize.shortestSide / view.devicePixelRatio;
  return nativeUserAgent(
    defaultTargetPlatform.name.toLowerCase(),
    tablet: shortest >= 600,
  );
}

/// Accès au compte, ou `null` sans configuration.
final accountGatewayProvider = Provider<AccountGateway?>(
  (ref) => accountsConfigured ? AccountGateway(Supabase.instance.client) : null,
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

/// Vrai si le compte a un mot de passe (un compte Google n'en a pas).
final hasPasswordProvider = FutureProvider.autoDispose<bool>((ref) async {
  final gateway = ref.watch(accountGatewayProvider);
  ref.watch(currentUserProvider);
  return gateway?.user == null ? true : gateway!.hasPassword();
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

/// Avatar de l'utilisateur connecté (data URI), d'après son profil local ;
/// suit la synchronisation (un changement fait sur un autre appareil).
final avatarProvider = StreamProvider<String?>((ref) {
  final me = ref.watch(currentUserProvider.select((u) => u.value?.id));
  if (me == null) return Stream.value(null);
  final database = ref.watch(databaseProvider);
  return database
      .customSelect(
        'SELECT avatar FROM profile WHERE id = ?',
        variables: [Variable.withString(me)],
        readsFrom: {database.profiles},
      )
      .watchSingleOrNull()
      .map((row) => row?.readNullable<String>('avatar'));
});

/// Connecte la base PowerSync tant qu'un utilisateur est connecté, et la
/// déconnecte sinon. À surveiller depuis la racine de l'app.
final syncProvider = Provider<void>((ref) {
  if (!accountsConfigured) return;
  // L'identifiant seul : un rafraîchissement de jeton ne reconnecte pas.
  final userId = ref.watch(currentUserProvider.select((u) => u.value?.id));
  final database = ref.watch(databaseProvider);
  final powerSync = database.powerSync;
  if (powerSync == null) return;
  if (userId == null) {
    powerSync.then((db) => db.disconnect());
  } else {
    powerSync.then(
      (db) => db.connect(
        connector: SupabaseConnector(Supabase.instance.client, powerSyncUrl),
      ),
    );
  }
});

/// Actions de session de l'appareil (US-12).
class SessionActions {
  SessionActions(this._ref);

  final Ref _ref;

  /// Modifications locales pas encore envoyées au serveur.
  Future<int> pendingUploads() async {
    final powerSync = await _ref.read(databaseProvider).powerSync;
    return powerSync == null
        ? 0
        : (await powerSync.getUploadQueueStats()).count;
  }

  /// Appareils connectés au compte (EF-CPT-05), cet appareil d'abord.
  /// Demande le réseau.
  Future<List<ConnectedDevice>> devices() async {
    final rows = await Supabase.instance.client.rpc<List<dynamic>>(
      'list_my_sessions',
    );
    return [
      for (final row in rows.cast<Map<String, dynamic>>())
        ConnectedDevice(
          id: row['id'] as String,
          info: describeUserAgent(row['user_agent'] as String?),
          lastActive: DateTime.parse(row['last_active_at'] as String),
          current: row['is_current'] as bool,
        ),
    ];
  }

  /// Change le pseudonyme dans la base de l'appareil : hors ligne compris,
  /// il part à la synchronisation (EF-CPT-09).
  Future<void> renameProfile(String userId, String pseudonym) async {
    await _ref.read(databaseProvider).customStatement(
      'UPDATE profile SET pseudonym = ? WHERE id = ?',
      [pseudonym.trim(), userId],
    );
    _ref.invalidate(pseudonymProvider);
  }

  /// Change l'avatar (data URI, `null` pour le retirer) dans la base de
  /// l'appareil : hors ligne compris, il part à la synchronisation
  /// (EF-CPT-09). Les listes de membres observées sont prévenues.
  Future<void> setAvatar(String userId, String? avatar) async {
    final database = _ref.read(databaseProvider);
    await database.customUpdate(
      'UPDATE profile SET avatar = ? WHERE id = ?',
      variables: [Variable<String>(avatar), Variable.withString(userId)],
      updates: {database.profiles},
    );
  }

  /// Déconnecte un autre appareil : il ne peut plus prolonger sa connexion.
  Future<void> revokeDevice(String id) => Supabase.instance.client.rpc<bool>(
    'revoke_my_session',
    params: {'target': id},
  );

  /// Arrête la synchronisation, efface les données synchronisées de
  /// l'appareil (le compte suivant n'en voit rien), puis ferme la session.
  /// Le contenu de règles reste.
  Future<void> signOut() async {
    await (await _ref.read(databaseProvider).powerSync)?.disconnectAndClear();
    await _ref.read(accountGatewayProvider)?.signOut();
  }
}

final sessionActionsProvider = Provider<SessionActions>(SessionActions.new);

/// Un appareil connecté au compte.
final class ConnectedDevice {
  const ConnectedDevice({
    required this.id,
    required this.info,
    required this.lastActive,
    required this.current,
  });

  final String id;
  final DeviceInfo info;
  final DateTime lastActive;

  /// Vrai pour l'appareil qui affiche la liste.
  final bool current;
}

/// Appareils connectés, relus à chaque ouverture du profil.
final connectedDevicesProvider =
    FutureProvider.autoDispose<List<ConnectedDevice>>(
      (ref) => ref.watch(sessionActionsProvider).devices(),
    );
