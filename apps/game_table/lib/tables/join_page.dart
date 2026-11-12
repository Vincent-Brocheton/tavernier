import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../account/account_providers.dart';
import '../l10n/app_localizations.dart';
import 'pending_join.dart';

/// Rejoindre une table [T12] : par le lien d'une invitation ([code] fourni)
/// ou en saisissant le code. Sans réseau ou sans compte, la demande est
/// gardée et part d'elle-même (EF-TAB-08).
class JoinPage extends ConsumerStatefulWidget {
  const JoinPage({super.key, this.code});

  final String? code;

  @override
  ConsumerState<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends ConsumerState<JoinPage> {
  late final _controller = TextEditingController(
    text: widget.code?.toUpperCase() ?? ref.read(pendingJoinProvider).code,
  );

  @override
  void initState() {
    super.initState();
    if (widget.code case final code?) {
      Future.microtask(
        () => ref.read(pendingJoinProvider.notifier).submit(code),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _error(AppLocalizations l10n, String? error) => switch (error) {
    'expired_code' => l10n.joinErrorExpired,
    'archived_table' => l10n.joinErrorArchived,
    'too_many_attempts' => l10n.joinErrorTooMany,
    _ => l10n.joinErrorInvalid,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final join = ref.watch(pendingJoinProvider);
    ref.listen(pendingJoinProvider, (_, next) {
      if (next.status == JoinStatus.joined) {
        ref.read(pendingJoinProvider.notifier).acknowledge();
        context.go('/tables/${next.tableId}');
      }
    });
    final online = ref.watch(onlineProvider).value ?? true;
    final waiting = join.status == JoinStatus.waiting && !online;
    final joining = join.status == JoinStatus.joining;
    final complete = _controller.text.length == 6;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
        title: Text(l10n.joinTitle),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: EdgeInsets.all(AppSpacing.md),
              children: [
                if (!online) ...[
                  StatusBanner(
                    kind: StatusBannerKind.info,
                    icon: Icons.cloud_off,
                    title: l10n.joinOfflineTitle,
                    message: l10n.joinOfflineBody,
                  ),
                  SizedBox(height: AppSpacing.md),
                ],
                if (join.status == JoinStatus.needsAccount) ...[
                  StatusBanner(
                    kind: StatusBannerKind.info,
                    icon: Icons.person_outline,
                    message: l10n.joinNeedsAccount,
                  ),
                  SizedBox(height: AppSpacing.sm),
                  FilledButton(
                    onPressed: () => context.push('/connexion'),
                    child: Text(l10n.signInAction),
                  ),
                  SizedBox(height: AppSpacing.md),
                ],
                if (join.status == JoinStatus.failed) ...[
                  StatusBanner(message: _error(l10n, join.error)),
                  SizedBox(height: AppSpacing.md),
                ],
                Text(l10n.joinCodeHint, style: text.bodyMedium),
                SizedBox(height: AppSpacing.md),
                _CodeBoxes(
                  controller: _controller,
                  label: l10n.joinCodeLabel,
                  onChanged: (_) {
                    ref.read(pendingJoinProvider.notifier).acknowledge();
                    setState(() {});
                  },
                ),
                SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: complete && !waiting && !joining
                      ? () => ref
                            .read(pendingJoinProvider.notifier)
                            .submit(_controller.text)
                      : null,
                  icon: waiting
                      ? const Icon(Icons.schedule)
                      : joining
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.login),
                  label: Text(waiting ? l10n.joinWaiting : l10n.joinTable),
                ),
                if (waiting) ...[
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.joinWaitingHint,
                    style: text.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Six cases de 56 dp ; un champ transparent par-dessus porte la saisie, le
/// clavier, le collage et l'accessibilité.
class _CodeBoxes extends StatelessWidget {
  const _CodeBoxes({
    required this.controller,
    required this.label,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = AppTypography.numeric(
      Theme.of(context).textTheme.titleLarge!,
    );
    final code = controller.text;
    return SizedBox(
      height: 56,
      child: Stack(
        children: [
          Row(
            children: [
              for (var i = 0; i < 6; i++) ...[
                if (i > 0) SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: i == code.length
                            ? scheme.primary
                            : scheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(AppRadii.sm),
                    ),
                    child: Text(i < code.length ? code[i] : '', style: style),
                  ),
                ),
              ],
            ],
          ),
          Positioned.fill(
            child: TextField(
              controller: controller,
              autofocus: true,
              maxLength: 6,
              showCursor: false,
              enableInteractiveSelection: false,
              autocorrect: false,
              enableSuggestions: false,
              textCapitalization: TextCapitalization.characters,
              style: const TextStyle(color: Colors.transparent),
              decoration: InputDecoration(
                border: InputBorder.none,
                counterText: '',
                hintText: label,
                hintStyle: const TextStyle(color: Colors.transparent),
                semanticCounterText: '',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
                TextInputFormatter.withFunction(
                  (_, value) => value.copyWith(text: value.text.toUpperCase()),
                ),
              ],
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
