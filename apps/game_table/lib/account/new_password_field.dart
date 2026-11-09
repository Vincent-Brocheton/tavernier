import 'dart:async';

import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'account_providers.dart';
import 'password_policy.dart';

/// Saisie d'un nouveau mot de passe (EF-CPT-08), à l'inscription [T2] comme
/// à la réinitialisation [A3] : l'œil, puis la jauge et les règles cochées au
/// fil de la saisie. [onValidityChanged] reçoit vrai quand toutes les règles
/// sont respectées, dont l'absence des fuites (Have I Been Pwned, vérifiée
/// 400 ms après la dernière frappe).
class NewPasswordField extends ConsumerStatefulWidget {
  const NewPasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.email,
    this.pseudonym,
    required this.onValidityChanged,
  });

  final TextEditingController controller;
  final String label;
  final String email;
  final String? pseudonym;
  final ValueChanged<bool> onValidityChanged;

  @override
  ConsumerState<NewPasswordField> createState() => _NewPasswordFieldState();
}

class _NewPasswordFieldState extends ConsumerState<NewPasswordField> {
  var _obscured = true;

  /// Résultat de Have I Been Pwned pour [_checked] ; `null` en attente ou
  /// sans réponse.
  bool? _breached;
  String? _checked;
  Timer? _debounce;
  bool? _lastValidity;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String password) {
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
      if (!mounted || widget.controller.text != password) return;
      setState(() {
        _breached = breached;
        _checked = password;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final password = widget.controller.text;
    final lengthOk = longEnough(password);
    final identityOk =
        password.isNotEmpty &&
        differsFromIdentity(
          password,
          email: widget.email,
          pseudonym: widget.pseudonym,
        );
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
    final valid =
        lengthOk && identityOk && breachedState == PasswordRuleState.met;
    if (valid != _lastValidity) {
      _lastValidity = valid;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.onValidityChanged(valid),
      );
    }
    final level = strength(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: widget.controller,
          obscureText: _obscured,
          autofillHints: const [AutofillHints.newPassword],
          onChanged: _onChanged,
          decoration: InputDecoration(
            labelText: widget.label,
            suffixIcon: IconButton(
              tooltip: _obscured ? l10n.showPassword : l10n.hidePassword,
              icon: Icon(_obscured ? Icons.visibility : Icons.visibility_off),
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
      ],
    );
  }
}
