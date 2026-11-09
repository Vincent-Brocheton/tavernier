import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase/supabase.dart';

import 'powersync.dart';

/// Écriture refusée définitivement par le serveur (droits, donnée invalide,
/// contrainte), et donc écartée de la file.
typedef DiscardedWrite = ({
  String op,
  String table,
  String id,
  String code,
  String message,
});

/// Relie la base PowerSync à Supabase (T-05) : jeton de la session pour le
/// service PowerSync à [powerSyncUrl], et envoi de la file d'écritures
/// locales sous les droits (RLS) de l'utilisateur.
final class SupabaseConnector extends PowerSyncBackendConnector {
  SupabaseConnector(this._client, this.powerSyncUrl, {this.onDiscarded});

  final SupabaseClient _client;
  final String powerSyncUrl;

  /// Appelé pour chaque écriture écartée.
  final void Function(DiscardedWrite write)? onDiscarded;

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

  /// Une transaction locale part en un seul appel à `apply_crud`, appliqué
  /// en une seule transaction Postgres : les autres appareils ne reçoivent
  /// jamais une fiche à moitié écrite. Une erreur réseau remonte, et
  /// PowerSync réessaie ; un refus définitif n'écarte que son opération.
  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    final transaction = await database.getNextCrudTransaction();
    if (transaction == null) return;
    final ops = [
      for (final entry in transaction.crud)
        {
          'op': switch (entry.op) {
            UpdateType.put => 'PUT',
            UpdateType.patch => 'PATCH',
            UpdateType.delete => 'DELETE',
          },
          'table': entry.table,
          'id': entry.id,
          'data': _forPostgres(entry),
        },
    ];
    final discarded = await _client.rpc<List<dynamic>>(
      'apply_crud',
      params: {'ops': ops},
    );
    for (final d in discarded.cast<Map<String, dynamic>>()) {
      final write = (
        op: d['op'] as String,
        table: d['table'] as String,
        id: d['id'] as String,
        code: d['code'] as String,
        message: d['message'] as String,
      );
      _log.warning(
        'Écriture écartée : ${write.op} ${write.table}/${write.id} '
        '(${write.code} ${write.message})',
      );
      onDiscarded?.call(write);
    }
    await transaction.complete();
  }

  /// Colonnes pour Postgres : booléens en `true`/`false` (0/1 en local), et
  /// le propriétaire d'un personnage créé sans compte, que le serveur
  /// exige.
  Map<String, Object?> _forPostgres(CrudEntry entry) {
    final booleans = syncedBooleanColumns[entry.table] ?? const {};
    final data = {
      for (final MapEntry(:key, :value) in (entry.opData ?? const {}).entries)
        key: booleans.contains(key) && value is int ? value != 0 : value,
    };
    if (entry.op == UpdateType.put &&
        entry.table == 'character' &&
        data['owner_user_id'] == null) {
      data['owner_user_id'] = _client.auth.currentUser?.id;
    }
    return data;
  }
}
