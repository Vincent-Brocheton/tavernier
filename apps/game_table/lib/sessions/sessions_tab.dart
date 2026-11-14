// Onglet « Séances » d'une table (US-35, EF-SEA-01, [S1], [S5], [S6]).
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../account/account_providers.dart';
import '../l10n/app_localizations.dart';
import '../tables/tables_providers.dart';
import 'sessions_providers.dart';

/// Séances de [table] : vide ([S6]) ou en deux sections ([S1]). Le MJ les
/// crée ; le joueur voit si son personnage est attendu ([S5]).
class SessionsTab extends ConsumerWidget {
  const SessionsTab({super.key, required this.table});

  final TableSummary table;

  bool get _gm => table.role == TableRole.gm && !table.archived;

  /// Crée la séance suivante, datée du jour, avec tous les personnages de la
  /// table prévus ; [now] : déjà en cours (« Jouer tout de suite »).
  Future<void> _create(
    BuildContext context,
    WidgetRef ref, {
    required bool now,
  }) async {
    final l10n = AppLocalizations.of(context);
    final sessions = ref.read(tableSessionsProvider(table.id)).value ?? [];
    final group = ref.read(tableGroupProvider(table.id)).value ?? [];
    final id = await ref
        .read(sessionStoreProvider)
        .create(
          tableId: table.id,
          title: l10n.sessionNumber(sessions.length + 1),
          date: DateTime.now(),
          status: now ? SessionStatus.inProgress : SessionStatus.planned,
          present: [for (final pc in group) pc.id],
        );
    if (!now && context.mounted) {
      await context.push('/tables/${table.id}/seances/$id');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final sessions = ref.watch(tableSessionsProvider(table.id)).value;
    // Chargés avant le toucher : la création prévoit tout le groupe.
    ref.watch(tableGroupProvider(table.id));
    if (sessions == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (sessions.isEmpty) return _Empty(table: table, onCreate: _create);
    final next = [
      for (final s in sessions)
        if (s.status != SessionStatus.closed) s,
    ];
    final past = [
      for (final s in sessions)
        if (s.status == SessionStatus.closed) s,
    ];
    Widget section(String title, List<GameSession> list) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(title.toUpperCase(), style: text.labelLarge),
        ),
        for (final s in list)
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: SessionCard(table: table, session: s),
          ),
      ],
    );
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.md),
          children: [
            if (_gm)
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () => _create(context, ref, now: false),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.sessionNew),
                  ),
                  OutlinedButton(
                    onPressed: () => _create(context, ref, now: true),
                    child: Text(l10n.sessionPlayNow),
                  ),
                ],
              ),
            if (next.isNotEmpty) section(l10n.sessionsNext, next),
            if (past.isNotEmpty) section(l10n.sessionsPast, past),
          ],
        ),
      ),
    );
  }
}

/// Table sans séance ([S6]).
class _Empty extends ConsumerWidget {
  const _Empty({required this.table, required this.onCreate});

  final TableSummary table;
  final Future<void> Function(BuildContext, WidgetRef, {required bool now})
  onCreate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final gm = table.role == TableRole.gm && !table.archived;
    final slots = ref.watch(tableSlotsProvider(table.id)).value ?? const [];
    final validated = slots.where((s) => s.status == 'validated').length;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(AppSpacing.lg),
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: scheme.surfaceContainerHigh,
                child: Icon(
                  Icons.event_note_outlined,
                  size: 40,
                  color: scheme.tertiary,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              l10n.sessionsEmptyTitle,
              textAlign: TextAlign.center,
              style: text.titleLarge!.copyWith(color: scheme.tertiary),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              l10n.sessionsEmptyBody,
              textAlign: TextAlign.center,
              style: text.bodyMedium,
            ),
            if (gm) ...[
              SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: () => onCreate(context, ref, now: false),
                child: Text(l10n.sessionPrepare(1)),
              ),
              SizedBox(height: AppSpacing.sm),
              OutlinedButton(
                onPressed: () => onCreate(context, ref, now: true),
                child: Text(l10n.sessionPlayNow),
              ),
            ],
            if (slots.isNotEmpty) ...[
              SizedBox(height: AppSpacing.md),
              Text(
                l10n.sessionsValidated(validated, slots.length),
                textAlign: TextAlign.center,
                style: text.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Carte de séance (`SessionCard`, COMPOSANTS §2.27) : pavé de date,
/// « Séance n », titre et badge d'état. Le MJ y ouvre la préparation.
class SessionCard extends ConsumerWidget {
  const SessionCard({super.key, required this.table, required this.session});

  final TableSummary table;
  final GameSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final colors = GameColors.of(context);
    final gm = table.role == TableRole.gm;
    final (label, background, foreground) = switch (session.status) {
      SessionStatus.planned => (
        l10n.sessionPlanned,
        colors.healContainer,
        colors.onHealContainer,
      ),
      SessionStatus.inProgress => (
        l10n.sessionInProgress,
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
      SessionStatus.closed => (
        l10n.sessionClosed,
        scheme.surfaceContainerHighest,
        scheme.onSurface,
      ),
    };
    // Vue du joueur : ses personnages prévus à une séance à venir.
    String? expected;
    if (!gm && session.status != SessionStatus.closed) {
      final me = ref.watch(currentUserProvider.select((u) => u.value?.id));
      final present =
          ref.watch(sessionAttendanceProvider(session.id)).value ?? const {};
      final mine = [
        for (final pc
            in ref.watch(tableGroupProvider(table.id)).value ??
                const <CharacterSummary>[])
          if (pc.ownerUserId == me && present.contains(pc.id)) pc.name,
      ];
      if (mine.isNotEmpty) expected = l10n.sessionExpected(mine.join(', '));
    }
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: gm
            ? () => context.push('/tables/${table.id}/seances/${session.id}')
            : null,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 56,
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                ),
                child: Column(
                  children: [
                    Text(
                      l10n.sessionMonth(session.date).toUpperCase(),
                      style: text.labelSmall,
                    ),
                    Text(l10n.sessionDay(session.date), style: text.titleLarge),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.sessionNumber(session.number),
                      style: text.bodySmall,
                    ),
                    Text(session.title, style: text.titleMedium),
                    if (expected != null) Text(expected, style: text.bodySmall),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(AppRadii.xs),
                ),
                child: Text(
                  label,
                  style: text.labelMedium!.copyWith(color: foreground),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
