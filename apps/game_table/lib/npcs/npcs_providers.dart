// PNJ d'une table (US-18) : dépôt et liste, au-dessus de la base.
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../l10n/app_localizations.dart';

/// Seule voie d'écriture des PNJ (cahier §10).
final npcStoreProvider = Provider<NpcStore>(
  (ref) => NpcStore(ref.watch(databaseProvider)),
);

/// PNJ d'une table, par dossier puis par nom.
final tableNpcsProvider = StreamProvider.family<List<Npc>, String>(
  (ref, tableId) => ref.watch(npcStoreProvider).watchList(tableId),
);

/// Monstre de départ d'un PNJ dans le contenu actif, s'il y est.
MonsterData? monsterOf(ActiveContent content, String? id) => switch (id) {
  final id? => content.entity(id)?.data as MonsterData?,
  null => null,
};

/// Libellé du pack d'une entité : « SRD 5.2.1 » ou le nom du pack.
String packLabelOf(AppLocalizations l10n, ActiveContent content, String id) {
  final namespace = id.split(':').first;
  if (namespace == 'srd') return l10n.sourceSrd;
  return content.packs
          .where((p) => p.manifest.namespace == namespace)
          .firstOrNull
          ?.manifest
          .name ??
      namespace;
}

/// Source courte d'une entité : « SRD » ou le nom de son pack ([F4]).
String sourceLabelOf(AppLocalizations l10n, ActiveContent content, String id) =>
    id.startsWith('srd:')
    ? l10n.sourceSrdShort
    : packLabelOf(l10n, content, id);

/// Libellé et icône d'une attitude : la couleur ne la porte jamais seule.
(String, IconData) attitudeLabel(AppLocalizations l10n, Attitude attitude) =>
    switch (attitude) {
      Attitude.friendly => (l10n.attitudeFriendly, Icons.sentiment_satisfied),
      Attitude.indifferent => (
        l10n.attitudeIndifferent,
        Icons.sentiment_neutral,
      ),
      Attitude.hostile => (l10n.attitudeHostile, Icons.sentiment_dissatisfied),
    };
