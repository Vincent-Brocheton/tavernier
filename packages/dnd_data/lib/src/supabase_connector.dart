import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase/supabase.dart';

import 'powersync.dart';

/// Relie la base PowerSync à Supabase (T-05) : jeton de la session pour le
/// service PowerSync à [powerSyncUrl], et envoi de la file d'écritures
/// locales par l'API de Supabase, sous les droits (RLS) de l'utilisateur.
final class SupabaseConnector extends PowerSyncBackendConnector {
  SupabaseConnector(this._client, this.powerSyncUrl, {this.onDiscarded});

  final SupabaseClient _client;
  final String powerSyncUrl;

  /// Appelé pour chaque écriture refusée définitivement, et donc écartée.
  final void Function(CrudEntry entry, PostgrestException error)? onDiscarded;

  static final _log = Logger('tavernier.sync');

  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    var session = _client.auth.currentSession;
    if (session == null) return null;
    if (session.isExpired) {
      session = (await _client.auth.refreshSession()).session ?? session;
    }
    return PowerSyncCredentials(
      endpoint: powerSyncUrl,
      token: session.accessToken,
      userId: session.user.id,
    );
  }

  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    final transaction = await database.getNextCrudTransaction();
    if (transaction == null) return;
    for (final entry in transaction.crud) {
      final table = _client.from(entry.table);
      final data = _forPostgres(entry.table, entry.opData ?? const {});
      try {
        switch (entry.op) {
          case UpdateType.put:
            // Un personnage créé sans compte reçoit l'utilisateur connecté :
            // le serveur refuse un personnage sans propriétaire.
            if (entry.table == 'character' && data['owner_user_id'] == null) {
              data['owner_user_id'] = _client.auth.currentUser?.id;
            }
            await table.upsert({...data, 'id': entry.id});
          case UpdateType.patch:
            await table.update(data).eq('id', entry.id);
          case UpdateType.delete:
            await table.delete().eq('id', entry.id);
        }
      } on PostgrestException catch (e) {
        // Refus définitif : réessayer bloquerait toutes les écritures
        // suivantes. L'erreur réseau, elle, remonte et PowerSync réessaie.
        if (!_isDefinitive(e)) rethrow;
        _log.warning(
          'Écriture écartée : ${entry.op.name} ${entry.table}/${entry.id} '
          '(${e.code} ${e.message})',
        );
        onDiscarded?.call(entry, e);
      }
    }
    await transaction.complete();
  }
}

/// Données invalides (22…), contrainte violée (23…), droits refusés (42501).
bool _isDefinitive(PostgrestException e) {
  final code = e.code ?? '';
  return code.startsWith('22') || code.startsWith('23') || code == '42501';
}

/// Booléens en `true`/`false` (0/1 en local).
Map<String, Object?> _forPostgres(String table, Map<String, Object?> data) => {
  for (final MapEntry(:key, :value) in data.entries)
    key: syncedBooleanColumns[table]!.contains(key) && value is int
        ? value != 0
        : value,
};
