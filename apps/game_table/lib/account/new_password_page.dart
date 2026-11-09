import 'dart:async';

import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'account_gateway.dart';
import 'account_providers.dart';
import 'password_policy.dart';

/// Nouveau mot de passe [A3], ouvert par le lien de réinitialisation : règles
/// cochées au fil de la saisie, jauge de robustesse, et « Déconnecter mes
/// autres appareils » coché par défaut (EF-CPT-08).
class NewPasswordPage extends ConsumerStatefulWidget {
  const NewPasswordPage({super.key});

  @override
  ConsumerState<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends ConsumerState<NewPasswordPage> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  var _obscured = true;
  var _obscuredConfirm = true;
  var _signOutOthers = true;
  var _busy = false;
  var _networkError = false;

  /// Résultat de Have I Been Pwned pour [_checked] ; `null` en attente ou
  /// sans réponse.
  bool? _breached;
  String? _checked;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  /// Vérifie la fuite après 400 ms sans frappe.
  void _onPasswordChanged(String password) {
    _debounce?.cancel();
    setState(() => _breached = null);
    if (!longEnough(password)) return;
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      bool? breached;
      try {
        breached = await ref
            .read(breachedPasswordsProvider)
            .isBreached(password);
      } on Exception {
        breached = null;
      }
      if (!mounted || _password.text != password) return;
      setState(() {
        _breached = breached;
        _checked = password;
      });
    });
  }

  Future<void> _save() async {
    final gateway = ref.read(accountGatewayProvider);
    if (gateway == null) return;
    setState(() {
      _busy = true;
      _networkError = false;
    });
    try {
      await gateway.updatePassword(
        _password.text,
        signOutOthers: _signOutOthers,
      );
    } on AccountNetworkException {
      if (mounted) {
        setState(() {
          _busy = false;
          _networkError = true;
        });
      }
      return;
    }
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final gateway = ref.watch(accountGatewayProvider);
    final email = gateway?.user?.email ?? '';
    final pseudonym = ref.watch(pseudonymProvider).value;
    final expiry = gateway?.resetLinkExpiry;
    final password = _password.text;

    final lengthOk = longEnough(password);
    final identityOk =
        password.isNotEmpty &&
        differsFromIdentity(password, email: email, pseudonym: pseudonym);
    final breachedState = !lengthOk || _checked != password || _breached == null
        ? PasswordRuleState.pending
        : _breached!
        ? PasswordRuleState.unmet
        : PasswordRuleState.met;
    PasswordRuleState state(bool ok) => password.isEmpty
        ? PasswordRuleState.pending
        : ok
        ? PasswordRuleState.met
        : PasswordRuleState.unmet;
    final mismatch = _confirm.text.isNotEmpty && _confirm.text != password;
    final ready =
        lengthOk &&
        identityOk &&
        breachedState == PasswordRuleState.met &&
        _confirm.text == password &&
        !_busy;
    final level = strength(password);

    return Scaffold(
      appBar: AppBar(
        // Ouvert par le lien reçu : pas d'écran précédent, on referme vers
        // l'accueil [A3].
        leading: CloseButton(onPressed: () => context.go('/')),
        title: Text(l10n.newPasswordTitle),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: EdgeInsets.all(AppSpacing.md),
              children: [
                Text(
                  expiry == null
                      ? l10n.newPasswordAccountOnly(email)
                      : l10n.newPasswordAccount(
                          email,
                          expiry
                              .difference(DateTime.now())
                              .inMinutes
                              .clamp(0, 60),
                        ),
                  style: text.bodyMedium,
                ),
                SizedBox(height: AppSpacing.md),
                if (_networkError) ...[
                  StatusBanner(message: l10n.savePasswordNetworkError),
                  SizedBox(height: AppSpacing.md),
                ],
                TextField(
                  controller: _password,
                  obscureText: _obscured,
                  autofillHints: const [AutofillHints.newPassword],
                  onChanged: _onPasswordChanged,
                  decoration: InputDecoration(
                    labelText: l10n.newPasswordLabel,
                    suffixIcon: IconButton(
                      tooltip: _obscured
                          ? l10n.showPassword
                          : l10n.hidePassword,
                      icon: Icon(
                        _obscured ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => _obscured = !_obscured),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                PasswordRules(
                  strength: level,
                  strengthLabel: l10n.passwordStrength(switch (level) {
                    0 => l10n.passwordStrength0,
                    1 => l10n.passwordStrength1,
                    2 => l10n.passwordStrength2,
                    3 => l10n.passwordStrength3,
                    _ => l10n.passwordStrength4,
                  }),
                  rules: [
                    (label: l10n.ruleLength, state: state(lengthOk)),
                    (label: l10n.ruleIdentity, state: state(identityOk)),
                    (label: l10n.ruleBreached, state: breachedState),
                  ],
                  metLabel: l10n.ruleMet,
                  unmetLabel: l10n.ruleUnmet,
                  pendingLabel: l10n.rulePending,
                ),
                SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _confirm,
                  obscureText: _obscuredConfirm,
                  autofillHints: const [AutofillHints.newPassword],
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: l10n.confirmPasswordLabel,
                    errorText: mismatch ? l10n.passwordMismatch : null,
                    suffixIcon: IconButton(
                      tooltip: _obscuredConfirm
                          ? l10n.showPassword
                          : l10n.hidePassword,
                      icon: Icon(
                        _obscuredConfirm
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => _obscuredConfirm = !_obscuredConfirm),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                CheckboxListTile(
                  value: _signOutOthers,
                  onChanged: (v) => setState(() => _signOutOthers = v!),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.signOutOthers),
                  subtitle: Text(l10n.signOutOthersHint),
                ),
                SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: ready ? _save : null,
                  child: Text(l10n.savePasswordAndSignIn),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
