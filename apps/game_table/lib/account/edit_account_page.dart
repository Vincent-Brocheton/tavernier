import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'account_gateway.dart';
import 'account_providers.dart';
import 'new_password_field.dart';

/// Modifier le compte [A5] : pseudonyme (hors ligne compris), e-mail et mot
/// de passe (avec le réseau), un seul « Enregistrer » (EF-CPT-09).
class EditAccountPage extends ConsumerStatefulWidget {
  const EditAccountPage({super.key});

  @override
  ConsumerState<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends ConsumerState<EditAccountPage> {
  final _pseudonym = TextEditingController();
  final _email = TextEditingController();
  final _current = TextEditingController();
  final _next = TextEditingController();
  var _obscuredCurrent = true;
  var _nextValid = false;
  var _initialized = false;
  var _busy = false;

  /// Message d'erreur affiché en tête, ou `null`.
  String? _error;

  /// Adresse à qui le lien de confirmation est parti.
  String? _emailSentTo;

  @override
  void dispose() {
    for (final c in [_pseudonym, _email, _current, _next]) {
      c.dispose();
    }
    super.dispose();
  }

  String get _savedEmail => ref.read(accountGatewayProvider)?.user?.email ?? '';
  String get _savedPseudonym => ref.read(pseudonymProvider).value ?? '';

  bool get _pseudonymChanged =>
      _pseudonym.text.trim() != _savedPseudonym && _pseudonym.text.isNotEmpty;
  bool get _emailChanged =>
      _email.text.trim().isNotEmpty &&
      _email.text.trim().toLowerCase() != _savedEmail.toLowerCase();
  bool get _passwordChanged => _next.text.isNotEmpty;

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final gateway = ref.read(accountGatewayProvider);
    final user = gateway?.user;
    if (gateway == null || user == null) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    void fail(String message) => setState(() {
      _busy = false;
      _error = message;
    });

    if (_pseudonymChanged) {
      await ref
          .read(sessionActionsProvider)
          .renameProfile(user.id, _pseudonym.text);
    }
    String? sentTo;
    if (_emailChanged) {
      final email = _email.text.trim();
      try {
        await gateway.changeEmail(
          email,
          redirectTo: kIsWeb ? Uri.base.origin : null,
        );
      } on AccountNetworkException {
        return fail(l10n.accountNetworkError);
      }
      sentTo = email;
    }
    if (_passwordChanged) {
      switch (await gateway.changePassword(_current.text, _next.text)) {
        case PasswordChangeOutcome.changed:
          break;
        case PasswordChangeOutcome.wrongCurrent:
          return fail(l10n.wrongCurrentPassword);
        case PasswordChangeOutcome.network:
          return fail(l10n.accountNetworkError);
        case PasswordChangeOutcome.failed:
          return fail(l10n.signInFailed);
      }
    }
    if (!mounted) return;
    if (sentTo != null) {
      // On reste : le message du lien envoyé doit être lu.
      setState(() {
        _busy = false;
        _emailSentTo = sentTo;
        _current.clear();
        _next.clear();
      });
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.accountSaved)));
    context.canPop() ? context.pop() : context.go('/profil');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final pseudonym = ref.watch(pseudonymProvider).value;
    if (!_initialized && pseudonym != null) {
      _initialized = true;
      _pseudonym.text = pseudonym;
      _email.text = _savedEmail;
    }
    final emptyPseudonym = _initialized && _pseudonym.text.trim().isEmpty;
    final passwordReady =
        !_passwordChanged || (_current.text.isNotEmpty && _nextValid);
    final canSave =
        !_busy &&
        !emptyPseudonym &&
        passwordReady &&
        (_pseudonymChanged || _emailChanged || _passwordChanged);

    Widget card(String title, List<Widget> children) => Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: text.titleSmall),
            SizedBox(height: AppSpacing.sm),
            ...children,
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editAccountTitle),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.sm),
            child: FilledButton(
              onPressed: canSave ? _save : null,
              child: Text(l10n.accountSave),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: EdgeInsets.all(AppSpacing.md),
              children: [
                if (_error case final error?) ...[
                  StatusBanner(message: error),
                  SizedBox(height: AppSpacing.md),
                ],
                if (_emailSentTo case final email?) ...[
                  StatusBanner(
                    kind: StatusBannerKind.info,
                    icon: Icons.mark_email_read_outlined,
                    message: l10n.emailChangeSent(email),
                  ),
                  SizedBox(height: AppSpacing.md),
                ],
                card(l10n.profileSection, [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 28,
                      child: Text(
                        _pseudonym.text.isEmpty
                            ? '?'
                            : _pseudonym.text.characters.first.toUpperCase(),
                      ),
                    ),
                    title: Text(l10n.avatarLabel),
                    subtitle: Text(l10n.avatarHint),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _pseudonym,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: l10n.pseudonymLabel,
                      helperText: l10n.pseudonymHint,
                      helperMaxLines: 3,
                      errorText: emptyPseudonym ? l10n.pseudonymRequired : null,
                    ),
                  ),
                ]),
                SizedBox(height: AppSpacing.md),
                card(l10n.emailSection, [
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(labelText: l10n.emailLabel),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Card(
                    margin: EdgeInsets.zero,
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    child: ListTile(
                      leading: const Icon(Icons.mail_outline),
                      title: Text(
                        l10n.emailChangeHint(_savedEmail),
                        style: text.bodyMedium,
                      ),
                    ),
                  ),
                ]),
                SizedBox(height: AppSpacing.md),
                card(l10n.changePasswordSection, [
                  TextField(
                    controller: _current,
                    obscureText: _obscuredCurrent,
                    autofillHints: const [AutofillHints.password],
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: l10n.currentPasswordLabel,
                      suffixIcon: IconButton(
                        tooltip: _obscuredCurrent
                            ? l10n.showPassword
                            : l10n.hidePassword,
                        icon: Icon(
                          _obscuredCurrent
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () => setState(
                          () => _obscuredCurrent = !_obscuredCurrent,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  NewPasswordField(
                    controller: _next,
                    label: l10n.newPasswordLabel,
                    email: _savedEmail,
                    pseudonym: _pseudonym.text,
                    onValidityChanged: (valid) =>
                        setState(() => _nextValid = valid),
                  ),
                ]),
                SizedBox(height: AppSpacing.md),
                Text(l10n.networkFieldsNote, style: text.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
