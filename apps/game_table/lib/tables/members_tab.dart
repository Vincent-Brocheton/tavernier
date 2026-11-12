import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../account/account_providers.dart';
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
            ],
          ),
        ),
      );
    }
    return ListView(
      padding: EdgeInsets.all(AppSpacing.md),
      children: [
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
                style: AppTypography.numeric(text.headlineMedium!)
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final me = ref.watch(currentUserProvider.select((u) => u.value?.id));
    final members = ref.watch(tableMembersProvider(table.id)).value ?? [];
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
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      child: Text(name.characters.first.toUpperCase()),
                    ),
                    title: Text(name),
                    subtitle: Text(
                      member.userId == me ? l10n.memberYou(role) : role,
                    ),
                    trailing:
                        gm && member.role == TableRole.player && !table.archived
                        ? PopupMenuButton<void>(
                            itemBuilder: (_) => [
                              PopupMenuItem(
                                onTap: () =>
                                    _remove(context, ref, member, name),
                                child: Text(l10n.removeMember),
                              ),
                            ],
                          )
                        : null,
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
