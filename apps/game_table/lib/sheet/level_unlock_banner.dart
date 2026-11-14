// Déverrouillage de la montée de niveau (US-35, EF-SEA-05, COMPOSANTS
// §2.30 `LevelGrantBanner`, [S9]).
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../l10n/app_localizations.dart';
import '../settings/device_settings.dart';
import 'conflicts.dart' show pseudonymOfProvider;
import 'proposal_banner.dart';
import 'sheet_access.dart';

/// Progression d'une fiche de table : mode, PX et déverrouillage ; `null`
/// hors table (ou table pas encore reçue), où la montée reste libre.
typedef SheetProgression = ({
  ProgressionMode mode,
  int xp,
  LevelUnlock? unlock,
});

final sheetProgressionProvider = FutureProvider.autoDispose
    .family<SheetProgression?, ({String id, int level})>((ref, key) async {
      final access = await ref.watch(characterStoreProvider).access(key.id);
      final mode = access?.progressionMode;
      if (access?.tableId == null || mode == null) return null;
      final progression = ProgressionMode.parse(mode);
      return (
        mode: progression,
        xp: access!.xp,
        unlock: levelUnlockOf(
          level: key.level,
          xp: access.xp,
          mode: progression,
          granted: access.levelUnlock,
        ),
      );
    });

/// Montées reportées par « Plus tard » (`id:niveau`), gardées sur
/// l'appareil jusqu'à la montée.
final deferredLevelUpsProvider =
    NotifierProvider<DeferredLevelUps, Set<String>>(DeferredLevelUps.new);

class DeferredLevelUps extends Notifier<Set<String>> {
  static const _key = 'deferred_level_ups';

  @override
  Set<String> build() => {
    ...?ref.watch(sharedPreferencesProvider)?.getStringList(_key),
  };

  void toggle(String id, int level) {
    final key = '$id:$level';
    state = state.contains(key) ? ({...state}..remove(key)) : {...state, key};
    ref.read(sharedPreferencesProvider)?.setStringList(_key, [...state]);
  }
}

/// Origine du déverrouillage, telle que l'affiche la fiche.
String unlockTitle(AppLocalizations l10n, LevelUnlock unlock, String? by) =>
    switch (unlock.origin) {
      UnlockOrigin.xp => l10n.levelUnlockXp(formatThousands(unlock.xp ?? 0)),
      UnlockOrigin.milestone => l10n.levelUnlockMilestone(
        unlock.level,
        by ?? l10n.levelUnlockGm,
      ),
      UnlockOrigin.override => l10n.levelUnlockOverride(
        unlock.level,
        by ?? l10n.levelUnlockGm,
      ),
    };

/// Bandeau en tête de l'onglet Principal : origine, motif, « Plus tard » et
/// « Monter au niveau n ». Rien sans déverrouillage, ou s'il est reporté.
class LevelGrantBanner extends ConsumerWidget {
  const LevelGrantBanner({
    super.key,
    required this.id,
    required this.level,
    required this.levelUpPath,
  });

  final String id;
  final int level;
  final String levelUpPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlock = ref
        .watch(sheetProgressionProvider((id: id, level: level)))
        .value
        ?.unlock;
    final deferred = ref.watch(deferredLevelUpsProvider);
    if (unlock == null ||
        !SheetAccess.editableOf(context) ||
        deferred.contains('$id:${unlock.level}')) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final by = switch (unlock.by) {
      final user? => ref.watch(pseudonymOfProvider(user)).value,
      null => null,
    };
    return Card(
      color: scheme.primaryContainer,
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: scheme.onPrimaryContainer),
                SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    unlockTitle(l10n, unlock, by),
                    style: text.titleSmall?.copyWith(
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            if (unlock.reason case final reason?)
              Text(
                l10n.levelUnlockReason(reason),
                style: text.bodySmall?.copyWith(
                  color: scheme.onPrimaryContainer,
                ),
              ),
            SizedBox(height: AppSpacing.xs),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: AppSpacing.xs,
              children: [
                TextButton(
                  onPressed: () => ref
                      .read(deferredLevelUpsProvider.notifier)
                      .toggle(id, unlock.level),
                  child: Text(l10n.levelUnlockLater),
                ),
                FilledButton(
                  onPressed: () => context.push(levelUpPath),
                  child: Text(l10n.levelUpTo(unlock.level)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Ligne du bloc d'identité : puce d'une montée reportée, ou progression
/// en PX sans déverrouillage ; rien en jalons (EF-SEA-05).
class LevelProgressLine extends ConsumerWidget {
  const LevelProgressLine({super.key, required this.id, required this.level});

  final String id;
  final int level;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progression = ref
        .watch(sheetProgressionProvider((id: id, level: level)))
        .value;
    if (progression == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final unlock = progression.unlock;
    if (unlock != null) {
      if (!ref
          .watch(deferredLevelUpsProvider)
          .contains('$id:${unlock.level}')) {
        return const SizedBox.shrink();
      }
      return ActionChip(
        avatar: const Icon(Icons.trending_up),
        label: Text(l10n.levelUnlockChip(unlock.level)),
        onPressed: () => ref
            .read(deferredLevelUpsProvider.notifier)
            .toggle(id, unlock.level),
      );
    }
    final next = nextXpThreshold(level);
    if (progression.mode != ProgressionMode.xp || next == null) {
      return const SizedBox.shrink();
    }
    final xp = formatThousands(progression.xp);
    final target = formatThousands(next);
    return Semantics(
      label: l10n.xpProgressLabel(level + 1, xp, target),
      excludeSemantics: true,
      child: Text(l10n.xpProgress(xp, target), style: text.bodySmall),
    );
  }
}

/// Bouton libre d'une fiche hors table, comme avant US-35.
class FreeLevelUpButton extends ConsumerWidget {
  const FreeLevelUpButton({
    super.key,
    required this.id,
    required this.level,
    required this.levelUpPath,
  });

  final String id;
  final int level;
  final String levelUpPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progression = ref.watch(
      sheetProgressionProvider((id: id, level: level)),
    );
    if (progression case AsyncData(value: null)
        when SheetAccess.editableOf(context) && level < maxCharacterLevel) {
      return FilledButton(
        onPressed: () => context.push(levelUpPath),
        child: Text(AppLocalizations.of(context).levelUpTo(level + 1)),
      );
    }
    return const SizedBox.shrink();
  }
}

/// Dérogation du MJ (EF-SEA-05) : sur la fiche d'un joueur de sa table, il
/// débloque le niveau suivant, avec un motif facultatif.
class LevelOverrideButton extends ConsumerWidget {
  const LevelOverrideButton({
    super.key,
    required this.id,
    required this.name,
    required this.level,
  });

  final String id;
  final String name;
  final int level;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(gmProposalViewProvider(id)).value;
    final progression = ref
        .watch(sheetProgressionProvider((id: id, level: level)))
        .value;
    if (view == null ||
        progression == null ||
        progression.unlock != null ||
        level >= maxCharacterLevel) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    return OutlinedButton.icon(
      onPressed: () => _confirm(context, ref, l10n, view.me),
      icon: const Icon(Icons.lock_open),
      label: Text(l10n.levelOverrideAction(level + 1)),
    );
  }

  Future<void> _confirm(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String me,
  ) async {
    // Motif saisi, `null` si le MJ annule.
    final motif = await showDialog<String>(
      context: context,
      builder: (_) => _OverrideDialog(level: level + 1, name: name),
    );
    if (motif == null) return;
    await ref
        .read(characterStoreProvider)
        .grantLevel(
          id,
          level: level + 1,
          origin: UnlockOrigin.override.name,
          byUserId: me,
          reason: motif.isEmpty ? null : motif,
        );
    ref.invalidate(sheetProgressionProvider((id: id, level: level)));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.levelOverrideDone(level + 1))),
      );
    }
  }
}

class _OverrideDialog extends StatefulWidget {
  const _OverrideDialog({required this.level, required this.name});

  final int level;
  final String name;

  @override
  State<_OverrideDialog> createState() => _OverrideDialogState();
}

class _OverrideDialogState extends State<_OverrideDialog> {
  final _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.levelOverrideAction(widget.level)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.levelOverrideBody(widget.level, widget.name)),
          SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _reason,
            decoration: InputDecoration(labelText: l10n.levelOverrideReason),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _reason.text.trim()),
          child: Text(l10n.levelOverrideConfirm),
        ),
      ],
    );
  }
}
