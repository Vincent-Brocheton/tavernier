// Rencontres d'une table (US-19) : dépôt, adversaires, PJ présents et
// difficulté selon le budget de PX 2024.
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../creation/creation_providers.dart';
import '../l10n/app_localizations.dart';
import '../npcs/npcs_providers.dart';
import '../sessions/sessions_providers.dart';
import '../tables/tables_providers.dart';

/// Seule voie d'écriture des rencontres (cahier §10).
final encounterStoreProvider = Provider<EncounterStore>(
  (ref) => EncounterStore(ref.watch(databaseProvider)),
);

/// Rencontres d'une table, avec leurs groupes.
final tableEncountersProvider = StreamProvider.family<List<Encounter>, String>(
  (ref, tableId) => ref.watch(encounterStoreProvider).watchList(tableId),
);

/// Un adversaire préparé : nom, nombre, PX d'un exemplaire.
typedef Foe = ({String name, int quantity, int xp});

/// Adversaires de [encounter]. Un PNJ prend les PX de son monstre de
/// départ ; une fiche complète ou une référence introuvable vaut 0 PX.
List<Foe> foesOf(
  AppLocalizations l10n,
  Encounter encounter,
  ActiveContent content,
  List<Npc> npcs,
) => [
  for (final group in encounter.groups)
    switch (group.kind) {
      'npc' => switch (npcs.where((n) => n.id == group.refId).firstOrNull) {
        final npc? => (
          name: npc.name,
          quantity: group.quantity,
          xp: monsterOf(content, npc.monsterId)?.xp ?? 0,
        ),
        null => (
          name: l10n.encounterFoeMissing,
          quantity: group.quantity,
          xp: 0,
        ),
      },
      _ => switch (content.entity(group.refId)) {
        ContentEntity(:final name, data: final MonsterData monster) => (
          name: name,
          quantity: group.quantity,
          xp: monster.xp,
        ),
        _ => (name: l10n.encounterFoeMissing, quantity: group.quantity, xp: 0),
      },
    },
];

/// Total des PX des adversaires.
int xpOfFoes(List<Foe> foes) =>
    foes.fold(0, (sum, f) => sum + f.xp * f.quantity);

/// « Vétéran ×2, Bandit ×4 ».
String foesLabel(AppLocalizations l10n, List<Foe> foes) => foes.isEmpty
    ? l10n.encounterNoFoes
    : foes
          .map(
            (f) =>
                f.quantity > 1 ? l10n.encounterFoe(f.name, f.quantity) : f.name,
          )
          .join(', ');

/// Niveaux des PJ présents : ceux prévus à la séance [sessionId], ou tous
/// les personnages de la table en réserve ; `null` tant qu'ils se chargent.
final presentLevelsProvider = Provider.autoDispose
    .family<List<int>?, ({String tableId, String? sessionId})>((ref, key) {
      final group = ref.watch(tableGroupProvider(key.tableId)).value;
      if (group == null) return null;
      final present = switch (key.sessionId) {
        final session? => ref.watch(sessionAttendanceProvider(session)).value,
        null => {for (final pc in group) pc.id},
      };
      if (present == null) return null;
      // Un personnage encore sans classe ne compte pas.
      return [
        for (final pc in group)
          if (present.contains(pc.id))
            if (pc.classes.fold<int>(0, (sum, c) => sum + c.level)
                case final level when level > 0)
              level.clamp(1, 20),
      ];
    });

/// Libellé d'une difficulté.
String difficultyLabel(AppLocalizations l10n, EncounterDifficulty d) =>
    switch (d) {
      EncounterDifficulty.belowLow => l10n.difficultyBelowLow,
      EncounterDifficulty.low => l10n.difficultyLow,
      EncounterDifficulty.moderate => l10n.difficultyModerate,
      EncounterDifficulty.high => l10n.difficultyHigh,
    };

/// Ligne d'une rencontre : « Vétéran ×2 · 1 400 PX · Modérée ». Sans PJ
/// présent, pas de difficulté.
String encounterSummary(
  AppLocalizations l10n,
  List<Foe> foes,
  List<int>? levels,
) {
  final xp = xpOfFoes(foes);
  return [
    foesLabel(l10n, foes),
    l10n.encounterXp(formatThousands(xp)),
    if (levels != null && levels.isNotEmpty)
      difficultyLabel(l10n, encounterDifficulty(xp, encounterBudget(levels))),
  ].join(' · ');
}
