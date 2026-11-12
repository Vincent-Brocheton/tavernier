import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../account/account_providers.dart';
import '../creation/creation_providers.dart';
import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import 'table_labels.dart';
import 'tables_providers.dart';

/// Lien d'invitation ; sur le Web seulement, faute d'adresse publique de
/// l'app ailleurs : le code suffit alors.
String? inviteLink(String code) =>
    kIsWeb ? '${Uri.base.removeFragment()}#/rejoindre/$code' : null;

/// Onglet « Membres » [T10] : l'invitation (MJ) et la liste des membres.
class MembersTab extends ConsumerWidget {
  const MembersTab({super.key, required this.table});

  final TableSummary table;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final gm = table.role == TableRole.gm;
    final desktop =
        formFactorOf(MediaQuery.sizeOf(context).width) == FormFactor.desktop;
    final members = _MemberList(table: table);
    final hasReview =
        gm &&
        (ref.watch(tableSlotsProvider(table.id)).value ?? const <PcSlot>[]).any(
          (s) => s.status == 'submitted',
        );
    if (gm && desktop) {
      return Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 320,
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: InviteCard(table: table),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(child: members),
              if (hasReview) ...[
                SizedBox(width: AppSpacing.md),
                SizedBox(width: 360, child: ReviewPanel(table: table)),
              ],
            ],
          ),
        ),
      );
    }
    return ListView(
      padding: EdgeInsets.all(AppSpacing.md),
      children: [
        if (hasReview) ReviewPanel(table: table),
        // Sur téléphone, l'invitation s'ouvre dans une feuille [T11].
        if (gm && !table.archived) ...[
          FilledButton.icon(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              builder: (_) => SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: InviteCard(table: table),
                ),
              ),
            ),
            icon: const Icon(Icons.person_add_alt),
            label: Text(l10n.inviteTitle),
          ),
          SizedBox(height: AppSpacing.md),
        ],
        members,
      ],
    );
  }
}

/// Invitation en cours [T10, T11] : QR du lien, code, copier, partager,
/// expiration, révocation ; sans invitation, de quoi en créer une.
class InviteCard extends ConsumerWidget {
  const InviteCard({super.key, required this.table});

  final TableSummary table;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final store = ref.watch(tableStoreProvider);
    final invite = ref.watch(tableInviteProvider(table.id)).value;

    void copy(String value) {
      Clipboard.setData(ClipboardData(text: value));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.inviteCopied)));
    }

    final children = <Widget>[
      Text(l10n.inviteTitle, style: text.titleMedium),
      SizedBox(height: AppSpacing.xs),
      Text(l10n.inviteHint, style: text.bodySmall),
      SizedBox(height: AppSpacing.md),
    ];
    if (invite == null) {
      children.addAll([
        Text(l10n.inviteNone, style: text.bodyMedium),
        SizedBox(height: AppSpacing.md),
        FilledButton(
          onPressed: table.archived ? null : () => store.createInvite(table.id),
          child: Text(l10n.inviteCreate),
        ),
      ]);
    } else {
      final link = inviteLink(invite.code);
      // Arrondi au jour supérieur : une invitation créée à l'instant vaut 7 jours.
      final days =
          (invite.expiresAt.difference(DateTime.now()).inMinutes / 1440).ceil();
      children.addAll([
        if (link != null)
          Center(
            child: Container(
              // Fond clair et marge blanche : la lecture du QR en dépend.
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: scheme.onSurface,
                borderRadius: BorderRadius.circular(AppRadii.md),
              ),
              child: Semantics(
                label: l10n.inviteTitle,
                image: true,
                child: QrImageView(
                  data: link,
                  size: 160,
                  padding: EdgeInsets.zero,
                  backgroundColor: scheme.onSurface,
                  eyeStyle: QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: scheme.surface,
                  ),
                  dataModuleStyle: QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: scheme.surface,
                  ),
                ),
              ),
            ),
          ),
        SizedBox(height: AppSpacing.sm),
        Text(
          l10n.inviteCodeLabel,
          style: text.labelMedium,
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: SelectableText(
                invite.code,
                style: AppTypography.numeric(text.titleLarge!)
                    .copyWith(letterSpacing: 8),
              ),
            ),
            IconButton(
              tooltip: l10n.inviteCopyCode,
              onPressed: () => copy(invite.code),
              icon: const Icon(Icons.copy),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        if (link != null)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              FilledButton.tonal(
                onPressed: () => copy(link),
                child: Text(l10n.inviteCopyLink),
              ),
              OutlinedButton(
                // Sans partage dans ce navigateur : le lien est copié.
                onPressed: () => SharePlus.instance
                    .share(
                      ShareParams(
                        text: l10n.inviteShareText(
                          table.settings.name,
                          link,
                          invite.code,
                        ),
                      ),
                    )
                    .catchError((Object _) {
                      copy(link);
                      return const ShareResult(
                        '',
                        ShareResultStatus.unavailable,
                      );
                    }),
                child: Text(l10n.inviteShare),
              ),
            ],
          ),
        SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Icon(Icons.schedule, size: 18, color: scheme.onSurfaceVariant),
            SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(l10n.inviteExpires(days), style: text.bodySmall),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: scheme.error),
              onPressed: () => store.revokeInvite(invite.id),
              child: Text(l10n.inviteRevoke),
            ),
          ],
        ),
      ]);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

/// Liste des membres ; le MJ peut retirer un joueur (EF-TAB-06).
class _MemberList extends ConsumerWidget {
  const _MemberList({required this.table});

  final TableSummary table;

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    TableMemberInfo member,
    String name,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.removeMemberTitle(name)),
        content: Text(l10n.removeMemberBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.removeAction),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(tableStoreProvider).removeMember(table.id, member.userId);
    }
  }

  /// Transfère l'emplacement et sa fiche à un autre membre (cahier §4.3).
  Future<void> _transfer(
    BuildContext context,
    WidgetRef ref,
    PcSlot slot,
    List<TableMemberInfo> members,
  ) async {
    final l10n = AppLocalizations.of(context);
    final target = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.transferTitle(slot.characterName ?? '')),
        children: [
          for (final member in members)
            if (member.userId != slot.playerUserId)
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, member.userId),
                child: Text(member.pseudonym ?? l10n.memberUnknown),
              ),
        ],
      ),
    );
    if (target != null) {
      await ref
          .read(tableStoreProvider)
          .transferSlot(slot.id, slot.characterId!, target);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final me = ref.watch(currentUserProvider.select((u) => u.value?.id));
    final members = ref.watch(tableMembersProvider(table.id)).value ?? [];
    final slots = ref.watch(tableSlotsProvider(table.id)).value ?? [];
    final store = ref.read(tableStoreProvider);
    final gm = table.role == TableRole.gm;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.membersCount(members.length), style: text.titleMedium),
            for (final member in members)
              Builder(
                builder: (context) {
                  final name = member.pseudonym ?? l10n.memberUnknown;
                  final role = l10n.role(member.role);
                  final editable = gm && !table.archived;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          child: Text(name.characters.first.toUpperCase()),
                        ),
                        title: Text(name),
                        subtitle: Text(
                          member.userId == me ? l10n.memberYou(role) : role,
                        ),
                        trailing: editable
                            ? PopupMenuButton<void>(
                                itemBuilder: (_) => [
                                  PopupMenuItem(
                                    onTap: () => store.createSlot(
                                      table.id,
                                      member.userId,
                                    ),
                                    child: Text(l10n.assignSlot),
                                  ),
                                  if (member.role == TableRole.player)
                                    PopupMenuItem(
                                      onTap: () =>
                                          _remove(context, ref, member, name),
                                      child: Text(l10n.removeMember),
                                    ),
                                ],
                              )
                            : null,
                      ),
                      // Ses emplacements, sous le membre (cahier §4.3).
                      for (final slot in slots)
                        if (slot.playerUserId == member.userId)
                          ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.only(left: 56),
                            leading: const Icon(Icons.person_outline),
                            title: Text(l10n.slotLine(slot)),
                            trailing: !editable
                                ? null
                                : slot.characterId == null
                                ? IconButton(
                                    tooltip: l10n.removeSlot,
                                    onPressed: () => store.deleteSlot(slot.id),
                                    icon: const Icon(Icons.close),
                                  )
                                : slot.status == 'archived'
                                ? null
                                : IconButton(
                                    tooltip: l10n.transferSlot,
                                    onPressed: () =>
                                        _transfer(context, ref, slot, members),
                                    icon: const Icon(Icons.swap_horiz),
                                  ),
                          ),
                    ],
                  );
                },
              ),
            if (gm) ...[
              SizedBox(height: AppSpacing.sm),
              Text(l10n.removeNote, style: text.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}

/// Fiche relue localement, pour les contrôles du panneau de revue.
final _reviewedCharacterProvider = FutureProvider.autoDispose
    .family<CharacterInput?, String>(
      (ref, id) => ref.watch(characterStoreProvider).load(id),
    );

/// Panneau « Fiche à valider » [T10] : une carte par fiche envoyée.
class ReviewPanel extends ConsumerWidget {
  const ReviewPanel({super.key, required this.table});

  final TableSummary table;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slots = [
      for (final slot
          in ref.watch(tableSlotsProvider(table.id)).value ?? const <PcSlot>[])
        if (slot.status == 'submitted' && slot.characterId != null) slot,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final slot in slots)
          _ReviewCard(key: ValueKey(slot.id), table: table, slot: slot),
      ],
    );
  }
}

class _ReviewCard extends ConsumerStatefulWidget {
  const _ReviewCard({super.key, required this.table, required this.slot});

  final TableSummary table;
  final PcSlot slot;

  @override
  ConsumerState<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends ConsumerState<_ReviewCard> {
  final _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _review({required bool validated}) => ref
      .read(characterStoreProvider)
      .review(
        widget.slot.characterId!,
        validated: validated,
        comment: _comment.text.trim().isEmpty ? null : _comment.text.trim(),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final slot = widget.slot;
    final settings = widget.table.settings;
    final input = ref
        .watch(_reviewedCharacterProvider(slot.characterId!))
        .value;
    final content = ref.watch(contentProvider).value;
    final player =
        (ref.watch(tableMembersProvider(widget.table.id)).value ?? const [])
            .where((m) => m.userId == slot.playerUserId)
            .firstOrNull
            ?.pseudonym ??
        l10n.memberUnknown;
    final name = slot.characterName ?? '';

    Widget check(bool ok, String label) => Padding(
      padding: EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.error,
            size: 20,
            color: ok ? scheme.primary : scheme.error,
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: text.bodyMedium)),
        ],
      ),
    );

    final checks = <Widget>[];
    if (input != null && content != null) {
      final method = input.baseScores.method;
      checks.add(
        check(
          method == settings.statMethod,
          method == settings.statMethod
              ? l10n.checkMethod(l10n.statMethod(method))
              : l10n.checkMethodWrong(
                  l10n.statMethod(method),
                  l10n.statMethod(settings.statMethod),
                ),
        ),
      );
      final level = input.classLevels.fold(0, (sum, c) => sum + c.level);
      checks.add(
        check(
          level == settings.startingLevel,
          level == settings.startingLevel
              ? l10n.checkLevel(level)
              : l10n.checkLevelWrong(level, settings.startingLevel),
        ),
      );
      final errors = computeSheet(input, content).integrityErrors;
      if (errors.isEmpty) {
        checks.add(check(true, l10n.checkRules));
      } else {
        for (final error in errors) {
          checks.add(check(false, error.message));
        }
      }
    }
    final classes = input == null || content == null
        ? ''
        : [
            for (final c in input.classLevels)
              l10n.classLevel(namesOf(content, [c.classId]), c.level),
          ].join(' / ');
    final background = input == null || content == null
        ? ''
        : namesOf(content, [input.backgroundId]);

    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: scheme.tertiary),
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.reviewTitle, style: text.labelLarge),
            SizedBox(height: AppSpacing.sm),
            Text(name, style: text.titleLarge),
            Text(
              l10n.reviewBy(classes, background, player),
              style: text.bodySmall,
            ),
            ...checks,
            if (slot.submitMessage case final message?) ...[
              SizedBox(height: AppSpacing.sm),
              Text(l10n.playerMessage(player, message), style: text.bodyMedium),
            ],
            SizedBox(height: AppSpacing.md),
            TextField(
              controller: _comment,
              maxLines: 3,
              decoration: InputDecoration(labelText: l10n.reviewCommentLabel),
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: AppSpacing.sm),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                OutlinedButton(
                  onPressed: _comment.text.trim().isEmpty
                      ? null
                      : () => _review(validated: false),
                  child: Text(l10n.requestChanges),
                ),
                FilledButton(
                  onPressed: () => _review(validated: true),
                  child: Text(l10n.validateSheet),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () =>
                    context.push('/characters/${slot.characterId}'),
                child: Text(l10n.openFullSheet),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
