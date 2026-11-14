// Séances d'une table (US-35) : dépôt et listes, au-dessus de la base.
import 'package:dnd_data/dnd_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../creation/creation_providers.dart';

/// Seule voie d'écriture des séances (cahier §10).
final sessionStoreProvider = Provider<SessionStore>(
  (ref) => SessionStore(ref.watch(databaseProvider)),
);

/// Séances d'une table, la plus récente d'abord, numérotées.
final tableSessionsProvider = StreamProvider.family<List<GameSession>, String>(
  (ref, tableId) => ref.watch(sessionStoreProvider).watchList(tableId),
);

/// Personnages prévus à une séance.
final sessionAttendanceProvider = StreamProvider.family<Set<String>, String>(
  (ref, sessionId) =>
      ref.watch(sessionStoreProvider).watchAttendance(sessionId),
);
