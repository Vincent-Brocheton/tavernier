import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../account/account_providers.dart';
import '../creation/creation_providers.dart';
import '../l10n/app_localizations.dart';
import 'configuration_tab.dart';
import 'members_tab.dart';
import 'table_labels.dart';
import 'table_summary_card.dart';
import 'tables_providers.dart';

/// Page d'une table (US-13) : le rôle, le nom et la description, puis les
/// onglets « Vue d'ensemble » (réglages et activité), « Membres » et, pour le
/// MJ,
/// « Configuration » [F6].
class TablePage extends ConsumerWidget {
  const TablePage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final table = ref.watch(tableProvider(id)).value;
    final gm = table?.role == TableRole.gm;
    return DefaultTabController(
      // Une clé par rôle : le nombre d'onglets en dépend.
      key: ValueKey(gm),
      length: gm ? 3 : 2,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => context.canPop() ? context.pop() : context.go('/'),
          ),
        ),
        body: SafeArea(
          // Table rejointe à l'instant : elle arrive par la synchronisation.
          child: table == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (gm ? l10n.youAreGm : l10n.youArePlayer)
                                .toUpperCase(),
                            style: text.labelMedium!.copyWith(
                              color: scheme.primary,
                            ),
                          ),
                          Text(
                            table.settings.name,
                            style: text.headlineMedium!.copyWith(
                              color: scheme.tertiary,
                            ),
                          ),
                          if (table.settings.description
                              case final description?)
                            Padding(
                              padding: EdgeInsets.only(top: AppSpacing.xs),
                              child: Text(description, style: text.bodyMedium),
                            ),
                        ],
                      ),
                    ),
                    TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      tabs: [
                        Tab(text: l10n.tabOverview),
                        Tab(text: l10n.tabMembers),
                        if (gm) Tab(text: l10n.tabConfiguration),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _Overview(table: table),
                          MembersTab(table: table),
                          if (gm) ConfigurationTab(table: table),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Vue d'ensemble : les réglages en vigueur et l'activité récente.
class _Overview extends ConsumerWidget {
  const _Overview({required this.table});

  final TableSummary table;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final material = MaterialLocalizations.of(context);
    final activity = ref.watch(tableActivityProvider(table.id)).value;
    final me = ref.watch(currentUserProvider.select((u) => u.value?.id));
    final mine = [
      for (final slot
          in ref.watch(tableSlotsProvider(table.id)).value ?? const <PcSlot>[])
        if (slot.playerUserId == me) slot,
    ];
    String describe(TableActivity entry) => switch (entry.kind) {
      'archived' => l10n.activityArchived,
      'restored' => l10n.activityRestored,
      _ => l10n.changeLine(
        l10n.settingLabel('${entry.detail['field']}'),
        l10n.settingValue('${entry.detail['field']}', entry.detail['from']),
        l10n.settingValue('${entry.detail['field']}', entry.detail['to']),
      ),
    };
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.md),
          children: [
            if (table.archived) ...[
              StatusBanner(
                kind: StatusBannerKind.alert,
                icon: Icons.inventory_2_outlined,
                message: l10n.archivedBanner,
              ),
              SizedBox(height: AppSpacing.md),
            ],
            if (mine.isNotEmpty) ...[
              Text(l10n.myCharacterTitle, style: text.titleMedium),
              SizedBox(height: AppSpacing.sm),
              for (final slot in mine) _MySlot(table: table, slot: slot),
              SizedBox(height: AppSpacing.md),
            ],
            TableSummaryCard(settings: table.settings, showName: false),
            SizedBox(height: AppSpacing.md),
            Text(l10n.activityTitle, style: text.titleMedium),
            SizedBox(height: AppSpacing.sm),
            if (activity != null && activity.isEmpty)
              Text(l10n.activityEmpty, style: text.bodyMedium),
            for (final entry in activity ?? const <TableActivity>[])
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.history),
                title: Text(describe(entry)),
                subtitle: Text(
                  '${material.formatMediumDate(entry.at.toLocal())} · '
                  '${material.formatTimeOfDay(TimeOfDay.fromDateTime(entry.at.toLocal()))}',
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Un emplacement du joueur (US-15, cahier §4.3) : « Créer ma fiche », ou
/// la fiche, son statut et son envoi au MJ.
class _MySlot extends ConsumerWidget {
  const _MySlot({required this.table, required this.slot});

  final TableSummary table;
  final PcSlot slot;

  /// Envoi au MJ, avec un message facultatif ([T10] : « Message de Hugo »).
  Future<void> _submit(BuildContext context, WidgetRef ref, String id) async {
    final message = await showDialog<String>(
      context: context,
      builder: (_) => const _SubmitDialog(),
    );
    if (message != null) {
      await ref
          .read(characterStoreProvider)
          .submit(id, message.isEmpty ? null : message);
    }
  }

  /// Rattache un personnage libre à l'emplacement, et l'envoie au MJ pour
  /// revalidation (cahier §4.3).
  Future<void> _attach(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final me = ref.read(currentUserProvider).value?.id;
    if (me == null) return;
    final characters = ref.read(characterStoreProvider);
    final free = await characters.freeCharacters(me);
    if (!context.mounted) return;
    final chosen = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.attachTitle),
        children: [
          if (free.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(l10n.attachNone),
            ),
          for (final character in free)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, character.id),
              child: Text(character.name),
            ),
        ],
      ),
    );
    if (chosen == null || !context.mounted) return;
    final message = await showDialog<String>(
      context: context,
      builder: (_) => const _SubmitDialog(),
    );
    if (message == null) return;
    await characters.attach(chosen, table.id, message.isEmpty ? null : message);
    await ref.read(tableStoreProvider).fillSlot(slot.id, chosen);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final characters = ref.read(characterStoreProvider);
    final id = slot.characterId;
    final level = slot.level ?? 1;
    final start = table.settings.startingLevel;
    final children = <Widget>[
      if (id == null) ...[
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.person_add_alt),
          title: Text(l10n.slotEmpty),
        ),
        if (!table.archived)
          Wrap(
            alignment: WrapAlignment.end,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              OutlinedButton(
                onPressed: () => _attach(context, ref),
                child: Text(l10n.attachFree),
              ),
              FilledButton(
                onPressed: () => context.push(
                  '/characters/new?table=${table.id}&slot=${slot.id}',
                ),
                child: Text(l10n.createMySheet),
              ),
            ],
          ),
      ] else ...[
        if (slot.status == 'changes_requested' && slot.reviewComment != null)
          StatusBanner(
            kind: StatusBannerKind.alert,
            title: l10n.correctionsTitle,
            message: slot.reviewComment!,
          ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            child: Text(
              (slot.characterName ?? '?').characters.first.toUpperCase(),
            ),
          ),
          title: Text(slot.characterName ?? ''),
          subtitle: Text(
            l10n.sheetLevelStatus(level, l10n.characterStatus(slot.status)),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/characters/$id'),
        ),
        if (!table.archived)
          switch (slot.status) {
            'draft' || 'changes_requested' when level < start => Text(
              l10n.reachStartingLevel(start),
              style: text.bodySmall,
            ),
            'draft' || 'changes_requested' => Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () => _submit(context, ref, id),
                child: Text(l10n.submitToGm),
              ),
            ),
            'submitted' => Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () => characters.withdraw(id),
                child: Text(l10n.withdrawSheet),
              ),
            ),
            _ => const SizedBox.shrink(),
          },
      ],
    ];
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

/// Message facultatif pour le MJ ; rend le message (vide compris) à l'envoi,
/// `null` à l'annulation.
class _SubmitDialog extends StatefulWidget {
  const _SubmitDialog();

  @override
  State<_SubmitDialog> createState() => _SubmitDialogState();
}

class _SubmitDialogState extends State<_SubmitDialog> {
  final _message = TextEditingController();

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.submitToGm),
      content: TextField(
        controller: _message,
        maxLines: 3,
        decoration: InputDecoration(labelText: l10n.submitMessageLabel),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _message.text.trim()),
          child: Text(l10n.submitAction),
        ),
      ],
    );
  }
}
