import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../creation/details_step.dart';
import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import 'combat_tab.dart';
import 'conflicts.dart';
import 'features_tab.dart';
import 'history_page.dart';
import 'inventory_tab.dart';
import 'proposal_banner.dart';
import 'rest_sheet.dart';
import 'sheet_access.dart';
import 'sheet_breakdowns.dart';
import 'spells_tab.dart';

/// Personnage enregistré, relu à l'ouverture de la fiche.
final characterProvider = FutureProvider.autoDispose
    .family<CharacterInput?, String>(
      (ref, id) => ref.watch(characterStoreProvider).load(id),
    );

/// État de jeu, relu à l'ouverture de la fiche.
final playStateProvider = FutureProvider.autoDispose.family<PlayState, String>(
  (ref, id) => ref.watch(characterStoreProvider).loadState(id),
);

const _tabCount = 7;

/// Fiche d'un personnage [2a], [2c].
class SheetPage extends ConsumerWidget {
  const SheetPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.watch(contentProvider).asData?.value;
    final character = ref.watch(characterProvider(id));
    return Scaffold(
      body: SafeArea(
        child: switch ((content, character)) {
          (final content?, AsyncData(value: final character?)) => SheetAccess(
            // Lecture seule tant que les droits ne sont pas connus.
            editable: ref.watch(sheetEditableProvider(id)).value ?? false,
            child: _Sheet(id: id, content: content, character: character),
          ),
          (_, AsyncData(value: null)) ||
          (_, AsyncError()) => const CharacterNotFound(),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

/// Adresse de la montée de niveau du personnage [id].
String levelUpPath(String id) => '/characters/$id/level-up';

void _leave(BuildContext context) =>
    context.canPop() ? context.pop() : context.go('/');

/// Page d'un personnage absent de la base.
class CharacterNotFound extends StatelessWidget {
  const CharacterNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.characterNotFound),
          SizedBox(height: AppSpacing.sm),
          FilledButton(
            onPressed: () => _leave(context),
            child: Text(l10n.back),
          ),
        ],
      ),
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({
    required this.id,
    required this.content,
    required this.character,
  });

  final String id;
  final ActiveContent content;
  final CharacterInput character;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final sheet = computeSheet(character, content);
    final classes = [
      for (final level in character.classLevels)
        l10n.classLevel(namesOf(content, [level.classId]), level.level),
    ].join(' / ');
    final soon = Center(child: Text(l10n.comingSoon));
    return DefaultTabController(
      length: _tabCount,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ConflictBanner(id: id),
          _PendingBanner(id: id),
          ProposalBanner(id: id, content: content, character: character),
          Padding(
            padding: EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                IconButton(
                  tooltip: l10n.back,
                  onPressed: () => _leave(context),
                  icon: const Icon(Icons.arrow_back),
                ),
                SizedBox(width: AppSpacing.xs),
                CircleAvatar(
                  child: Text(character.name.characters.first.toUpperCase()),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(character.name, style: text.titleLarge),
                      Text(
                        [
                          namesOf(content, [character.speciesId]),
                          classes,
                          namesOf(content, [character.backgroundId]),
                          if (character.alignment case final code?)
                            alignmentName(l10n, code),
                        ].join(' · '),
                        style: text.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                if (SheetAccess.editableOf(context) &&
                    sheet.level < maxCharacterLevel)
                  FilledButton(
                    onPressed: () => context.push(levelUpPath(id)),
                    child: Text(l10n.levelUpTo(sheet.level + 1)),
                  ),
                for (final (kind, label) in [
                  if (SheetAccess.editableOf(context))
                    (RestKind.short, l10n.shortRest),
                  if (SheetAccess.editableOf(context))
                    (RestKind.long, l10n.longRest),
                ])
                  OutlinedButton(
                    onPressed: () => showAdaptiveSheet(
                      context,
                      RestSheet(
                        id: id,
                        kind: kind,
                        content: content,
                        character: character,
                        sheet: sheet,
                      ),
                    ),
                    child: Text(label),
                  ),
                TextButton.icon(
                  onPressed: () => context.push(historyPath(id)),
                  icon: const Icon(Icons.history),
                  label: Text(l10n.historyTitle),
                ),
              ],
            ),
          ),
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: l10n.tabMain),
              Tab(text: l10n.tabSkills),
              Tab(text: l10n.tabCombat),
              Tab(text: l10n.tabSpells),
              Tab(text: l10n.tabInventory),
              Tab(text: l10n.tabFeatures),
              Tab(text: l10n.tabNotes),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _MainTab(id: id, content: content, sheet: sheet),
                _SkillsTab(content: content, sheet: sheet),
                CombatTab(
                  id: id,
                  content: content,
                  character: character,
                  sheet: sheet,
                ),
                SpellsTab(
                  id: id,
                  content: content,
                  character: character,
                  sheet: sheet,
                ),
                InventoryTab(
                  id: id,
                  content: content,
                  character: character,
                  sheet: sheet,
                ),
                FeaturesTab(
                  id: id,
                  content: content,
                  character: character,
                  sheet: sheet,
                ),
                soon,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MainTab extends StatelessWidget {
  const _MainTab({
    required this.id,
    required this.content,
    required this.sheet,
  });

  final String id;
  final ActiveContent content;
  final ComputedSheet sheet;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final breakdowns = SheetBreakdowns(l10n, content, sheet);
    void open(Widget view) => showAdaptiveSheet(context, view);
    Widget stat(String value, String label, Widget Function() view) => SizedBox(
      width: 104,
      child: StatTile(value: value, label: label, onTap: () => open(view())),
    );

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HitPointsTracker(id: id, sheet: sheet),
          InspirationTracker(id: id),
          SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              stat(
                '${sheet.armorClass.value}',
                l10n.statArmorClass,
                breakdowns.armorClass,
              ),
              stat(
                formatSigned(sheet.initiative.value),
                l10n.statInitiative,
                breakdowns.initiative,
              ),
              stat(
                formatFeet(sheet.speedFeet),
                l10n.statSpeed,
                breakdowns.speed,
              ),
              stat(
                formatSigned(sheet.proficiencyBonus),
                l10n.statProficiency,
                breakdowns.proficiency,
              ),
              stat(
                '${sheet.passivePerception}',
                l10n.statPassivePerception,
                breakdowns.passivePerception,
              ),
              stat(
                '${sheet.hitPointsMax.value}',
                l10n.statHitPoints,
                breakdowns.hitPoints,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Text(l10n.abilitiesTitle, style: text.titleMedium),
          Text(l10n.tapForBreakdown, style: text.bodySmall),
          SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final code in abilityCodes)
                SizedBox(
                  width: 104,
                  child: AbilityTile(
                    label: abbreviation(l10n, code),
                    modifier: formatSigned(sheet.abilities[code]!.modifier),
                    score: sheet.abilities[code]!.value,
                    save: formatSigned(sheet.savingThrows[code]!),
                    saveProficient: sheet.savingThrowProficiencies.contains(
                      code,
                    ),
                    semanticLabel: l10n.abilitySemantics(
                      namesOf(content, [abilityIdByCode[code]!]),
                      sheet.abilities[code]!.value,
                      formatSigned(sheet.abilities[code]!.modifier),
                      formatSigned(sheet.savingThrows[code]!),
                    ),
                    onTap: () => open(breakdowns.ability(code)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkillsTab extends StatelessWidget {
  const _SkillsTab({required this.content, required this.sheet});

  final ActiveContent content;
  final ComputedSheet sheet;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final breakdowns = SheetBreakdowns(l10n, content, sheet);
    final skills = sortedEntities(content, 'skill');
    return ListView(
      padding: EdgeInsets.all(AppSpacing.md),
      children: [
        for (final code in abilityCodes) ...[
          if (skills.any(
            (s) =>
                (s.data as SkillData).ability.toString() ==
                abilityIdByCode[code],
          ))
            Padding(
              padding: EdgeInsets.only(
                top: AppSpacing.sm,
                bottom: AppSpacing.xxs,
              ),
              child: Text(
                namesOf(content, [abilityIdByCode[code]!]),
                style: text.labelLarge,
              ),
            ),
          for (final skill in skills)
            if ('${(skill.data as SkillData).ability}' == abilityIdByCode[code])
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  sheet.skillProficiencies.contains(skillKey(skill))
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  size: 16,
                ),
                title: Text(skill.name),
                subtitle:
                    sheet.skillBreakdown[skillKey(skill)]!.sources.any(
                      (c) => c.label == 'expertise',
                    )
                    ? Text(l10n.expertise)
                    : null,
                trailing: Text(
                  formatSigned(sheet.skills[skillKey(skill)]!),
                  style: AppTypography.numeric(text.titleMedium!),
                ),
                onTap: () =>
                    showAdaptiveSheet(context, breakdowns.skill(skill)),
              ),
        ],
      ],
    );
  }
}

/// Fiche en attente de validation, jouable [J12] (EF-PJ-20, COMPOSANTS
/// §2.51), avec les corrections demandées par le MJ.
class _PendingBanner extends ConsumerWidget {
  const _PendingBanner({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(sheetPendingProvider(id)).value;
    if (pending == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final gm = switch (pending.gmUserId) {
      final gm? => ref.watch(pseudonymOfProvider(gm)).value,
      null => null,
    };
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.sm,
        children: [
          StatusBanner(
            kind: StatusBannerKind.info,
            icon: Icons.hourglass_empty,
            title: l10n.pendingValidationTitle(gm ?? l10n.pendingValidationGm),
            message: l10n.pendingValidationBody,
          ),
          if (pending.comment case final comment?)
            StatusBanner(
              kind: StatusBannerKind.alert,
              title: l10n.correctionsTitle,
              message: comment,
            ),
        ],
      ),
    );
  }
}

/// Conflit résolu [P16] : une valeur du joueur a été remplacée à la
/// synchronisation ; « Voir l'historique » ou « OK » (EF-PJ-13, ENF-03).
class _ConflictBanner extends ConsumerWidget {
  const _ConflictBanner({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mine = [
      for (final c in ref.watch(unseenConflictsProvider))
        if (c.characterId == id) c,
    ];
    if (mine.isEmpty) return const SizedBox.shrink();
    final latest = mine.first.detail;
    final keptBy = '${latest['kept_by'] ?? ''}';
    final author =
        ref.watch(pseudonymOfProvider(keptBy)).value ?? l10n.conflictSomeone;
    final gmPriority = latest['table'] == 'character_state';
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StatusBanner(
            kind: StatusBannerKind.alert,
            icon: Icons.warning_amber_outlined,
            title: l10n.conflictBannerTitle,
            message: [
              l10n.conflictBannerBody(
                author,
                l10n.conflictField(latest['field']),
                l10n.conflictValue(latest['kept']),
                l10n.conflictValue(latest['replaced']),
              ),
              if (gmPriority && author != l10n.conflictSomeone)
                l10n.conflictGmPriority,
            ].join(' '),
          ),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: AppSpacing.sm,
            children: [
              TextButton(
                onPressed: () => context.push(historyPath(id)),
                child: Text(l10n.conflictSeeHistory),
              ),
              TextButton(
                onPressed: () => ref
                    .read(seenConflictsProvider.notifier)
                    .markSeen(mine.map((c) => c.id)),
                child: Text(l10n.conflictOk),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
