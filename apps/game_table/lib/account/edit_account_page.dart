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
    // En attendant la réponse, on suppose un mot de passe : rien ne se
    // verrouille à tort.
    final hasPassword = ref.watch(hasPasswordProvider).value ?? true;
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
                  // Sans mot de passe (compte Google), l'e-mail est verrouillé
                  // (EF-CPT-10).
                  TextField(
                    controller: _email,
                    readOnly: !hasPassword,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: l10n.emailLabel,
                      suffixIcon: hasPassword
                          ? null
                          : const Icon(Icons.lock_outline),
                      helperText: hasPassword ? null : l10n.emailFromGoogle,
                      helperMaxLines: 3,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  if (hasPassword)
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
                if (hasPassword)
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
                card(l10n.methodsSection, [
                  _SignInMethods(hasPassword: hasPassword),
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

/// Méthodes de connexion [A6] : Google et mot de passe. Il en reste toujours
/// une : « Retirer » est désactivé sur la dernière (EF-CPT-10). Apple est
/// abandonné.
class _SignInMethods extends ConsumerStatefulWidget {
  const _SignInMethods({required this.hasPassword});

  final bool hasPassword;

  @override
  ConsumerState<_SignInMethods> createState() => _SignInMethodsState();
}

class _SignInMethodsState extends ConsumerState<_SignInMethods> {
  var _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await action();
    } on Exception {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.methodFailed)));
      }
    }
    if (mounted) setState(() => _busy = false);
    ref
      ..invalidate(hasPasswordProvider)
      ..invalidate(currentUserProvider);
  }

  Future<void> _addPassword() async {
    final gateway = ref.read(accountGatewayProvider);
    if (gateway == null) return;
    final password = await showDialog<String>(
      context: context,
      builder: (_) => _AddPasswordDialog(email: gateway.user?.email ?? ''),
    );
    if (password == null) return;
    await _run(() async {
      final outcome = await gateway.addPassword(password);
      if (outcome != PasswordChangeOutcome.changed) {
        throw Exception('mot de passe refusé : $outcome');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final gateway = ref.watch(accountGatewayProvider);
    final google = gateway?.googleIdentity;
    final googleEmail = google?.identityData?['email'] as String?;
    final googleOnly = google != null && !widget.hasPassword;
    Widget active() => Padding(
      padding: EdgeInsets.only(left: AppSpacing.xs),
      child: Chip(
        label: Text(l10n.methodActive),
        visualDensity: VisualDensity.compact,
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.g_mobiledata),
          title: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [Text(l10n.googleLabel), if (google != null) active()],
          ),
          subtitle: Text(googleEmail ?? l10n.methodNotLinked),
          trailing: google == null
              ? FilledButton.tonal(
                  onPressed: _busy || gateway == null
                      ? null
                      : () => _run(
                          () => gateway.linkGoogle(
                            redirectTo: kIsWeb ? Uri.base.origin : null,
                          ),
                        ),
                  child: Text(l10n.methodLink),
                )
              : OutlinedButton(
                  onPressed: _busy || googleOnly
                      ? null
                      : () => _run(gateway!.unlinkGoogle),
                  child: Text(l10n.methodRemove),
                ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.key_outlined),
          title: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(l10n.passwordMethodLabel),
              if (widget.hasPassword) active(),
            ],
          ),
          subtitle: widget.hasPassword ? null : Text(l10n.methodNone),
          trailing: widget.hasPassword
              ? null
              : FilledButton.tonal(
                  onPressed: _busy ? null : _addPassword,
                  child: Text(l10n.methodAdd),
                ),
        ),
        if (googleOnly) Text(l10n.googleOnlyNote, style: text.bodySmall),
      ],
    );
  }
}

/// Ajout d'un mot de passe à un compte Google, selon EF-CPT-08.
class _AddPasswordDialog extends StatefulWidget {
  const _AddPasswordDialog({required this.email});

  final String email;

  @override
  State<_AddPasswordDialog> createState() => _AddPasswordDialogState();
}

class _AddPasswordDialogState extends State<_AddPasswordDialog> {
  final _password = TextEditingController();
  var _valid = false;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.addPasswordTitle),
      content: SingleChildScrollView(
        child: NewPasswordField(
          controller: _password,
          label: l10n.newPasswordLabel,
          email: widget.email,
          onValidityChanged: (valid) => setState(() => _valid = valid),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: _valid
              ? () => Navigator.pop(context, _password.text)
              : null,
          child: Text(l10n.accountSave),
        ),
      ],
    );
  }
}
