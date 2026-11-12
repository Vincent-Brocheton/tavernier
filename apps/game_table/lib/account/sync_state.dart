// État de la synchronisation, pour l'indicateur (US-16, ENF-02).
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:powersync/powersync.dart' show SyncStatus;

import '../creation/creation_providers.dart';
import '../l10n/app_localizations.dart';
import 'account_providers.dart';

/// Connexion au service de synchronisation ; `null` sans PowerSync (base
/// locale seule).
final powerSyncConnectionProvider =
    StreamProvider<({bool connected, bool connecting})?>((ref) async* {
      final powerSync = ref.watch(databaseProvider).powerSync;
      if (powerSync == null) {
        yield null;
        return;
      }
      final db = await powerSync;
      ({bool connected, bool connecting}) of(SyncStatus s) =>
          (connected: s.connected, connecting: s.connecting);
      yield of(db.currentStatus);
      yield* db.statusStream.map(of);
    });

/// Écritures locales pas encore envoyées (file `ps_crud` de PowerSync).
final pendingUploadsCountProvider = StreamProvider<int>((ref) async* {
  final powerSync = ref.watch(databaseProvider).powerSync;
  if (powerSync == null) {
    yield 0;
    return;
  }
  final db = await powerSync;
  yield* db
      .watch(
        'SELECT count(*) AS n FROM ps_crud',
        triggerOnTables: const {'ps_crud'},
      )
      .map((rows) => rows.first['n'] as int);
});

/// État affiché par l'indicateur ; `null` sans compte connecté.
final syncIndicatorProvider =
    Provider<({SyncIndicatorState state, int pending})?>((ref) {
      if (ref.watch(currentUserProvider).value == null) return null;
      final connection = ref.watch(powerSyncConnectionProvider).value;
      final online = ref.watch(onlineProvider).value ?? true;
      final pending = ref.watch(pendingUploadsCountProvider).value ?? 0;
      final connected =
          connection != null && (connection.connected || connection.connecting);
      final state = !online || !connected
          ? SyncIndicatorState.offline
          : pending > 0
          ? SyncIndicatorState.pending
          : SyncIndicatorState.synced;
      return (state: state, pending: pending);
    });

/// Libellé de l'indicateur : « Hors-ligne · 3 modifications en attente »…
String syncLabel(
  AppLocalizations l10n,
  ({SyncIndicatorState state, int pending}) sync,
) => switch (sync.state) {
  SyncIndicatorState.synced => l10n.syncSynced,
  SyncIndicatorState.pending => l10n.syncPending(sync.pending),
  SyncIndicatorState.offline when sync.pending > 0 => l10n.syncOfflinePending(
    l10n.syncPending(sync.pending),
  ),
  SyncIndicatorState.offline => l10n.syncOffline,
  SyncIndicatorState.conflict => l10n.syncConflict,
};
