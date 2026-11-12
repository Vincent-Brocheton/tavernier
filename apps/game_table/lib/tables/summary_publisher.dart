// Résumés des fiches de table (US-15, EF-TAB-09) : l'appareil du
// propriétaire les publie, parce que les PV max se calculent avec le moteur.
// Les autres joueurs n'en voient que l'état de santé qualitatif.
import 'dart:async';

import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../account/account_providers.dart';
import '../creation/creation_providers.dart';

/// Recalcule et publie le résumé de la fiche [id] de la table [tableId].
Future<void> publishSummaryOf(
  CharacterStore store,
  ActiveContent content, {
  required String id,
  required String tableId,
  required String ownerUserId,
}) async {
  final input = await store.load(id);
  if (input == null) return;
  final state = await store.loadState(id);
  final max = computeSheet(input, content).hitPointsMax.value;
  await store.publishSummary(
    CharacterSummary(
      id: id,
      tableId: tableId,
      ownerUserId: ownerUserId,
      name: input.name,
      speciesId: input.speciesId,
      classes: [
        for (final c in input.classLevels) (classId: c.classId, level: c.level),
      ],
      // Sans PV courants enregistrés, la fiche est indemne.
      health: healthOf(state.hpCurrent ?? max, max),
    ),
  );
}

/// Publie les résumés des fiches de table de l'utilisateur à chaque
/// changement de leur entrée, de leurs niveaux ou de leur état. À écouter
/// depuis la racine de l'app.
final summaryPublisherProvider = Provider<void>((ref) {
  final me = ref.watch(currentUserProvider.select((u) => u.value?.id));
  final content = ref.watch(contentProvider).value;
  if (me == null || content == null) return;
  final database = ref.watch(databaseProvider);
  final store = ref.watch(characterStoreProvider);
  final subscription = database
      .customSelect(
        'SELECT id, table_id FROM character WHERE table_id IS NOT NULL '
        "AND status <> 'archived' "
        'AND (owner_user_id IS NULL OR owner_user_id = ?)',
        variables: [Variable.withString(me)],
        readsFrom: {
          database.characters,
          database.characterStates,
          database.characterClassLevels,
        },
      )
      .watch()
      .listen((rows) async {
        for (final row in rows) {
          try {
            await publishSummaryOf(
              store,
              content,
              id: row.read<String>('id'),
              tableId: row.read<String>('table_id'),
              ownerUserId: me,
            );
          } on Object {
            // Une fiche illisible (contenu manquant) ne bloque pas les autres.
          }
        }
      });
  ref.onDispose(() => unawaited(subscription.cancel()));
});
