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

/// Un adversaire préparé : son groupe, son nom, son nombre, son FP (`null`
/// sans profil), les PX d'un exemplaire et son initiative commune.
typedef Foe = ({
  String groupId,
  String name,
  int quantity,
  String? cr,
  int xp,
  bool sharedInitiative,
});

/// Adversaires de [encounter]. Un PNJ prend le FP et les PX de son monstre
/// de départ ; une fiche complète ou une référence introuvable vaut 0 PX.
List<Foe> foesOf(
  AppLocalizations l10n,
  Encounter encounter,
  ActiveContent content,
  List<Npc> npcs,
) => [
  for (final group in encounter.groups)
    if (_profileOf(l10n, group, content, npcs) case (final name, final monster))
      (
        groupId: group.id,
        name: name,
        quantity: group.quantity,
        cr: monster?.cr,
        xp: monster?.xp ?? 0,
        sharedInitiative: group.sharedInitiative,
      ),
];

/// Nom et profil d'un groupe : le monstre, ou le monstre de départ d'un PNJ.
(String, MonsterData?) _profileOf(
  AppLocalizations l10n,
  EncounterGroup group,
  ActiveContent content,
  List<Npc> npcs,
) => switch (group.kind) {
  'npc' => switch (npcs.where((n) => n.id == group.refId).firstOrNull) {
    final npc? => (npc.name, monsterOf(content, npc.monsterId)),
    null => (l10n.encounterFoeMissing, null),
  },
  _ => switch (content.entity(group.refId)) {
    ContentEntity(:final name, data: final MonsterData monster) => (
      name,
      monster,
    ),
    _ => (l10n.encounterFoeMissing, null),
  },
};

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

/// Seule voie d'écriture du journal du combat (cahier §10).
final combatStoreProvider = Provider<CombatStore>(
  (ref) => CombatStore(ref.watch(databaseProvider)),
);

/// État d'un combat : la projection de son journal.
final combatStateProvider = StreamProvider.family<CombatState, String>(
  (ref, encounterId) => ref.watch(combatStoreProvider).watchState(encounterId),
);

/// Journal d'un combat, dans l'ordre (« Annuler » vise son dernier
/// événement effectif).
final combatEventsProvider = StreamProvider.family<List<CombatEvent>, String>(
  (ref, encounterId) => ref.watch(combatStoreProvider).watchEvents(encounterId),
);
