import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'account_gateway.dart';
import 'account_providers.dart';
import 'new_password_field.dart';

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
  var _obscuredConfirm = true;
  var _signOutOthers = true;
  var _passwordValid = false;
  var _busy = false;
  var _networkError = false;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
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
    final expiry = gateway?.resetLinkExpiry;
    final mismatch =
        _confirm.text.isNotEmpty && _confirm.text != _password.text;
    // Sans session de récupération (page ouverte sans le lien), rien à
    // enregistrer.
    final ready =
        gateway?.user != null &&
        _passwordValid &&
        _confirm.text == _password.text &&
        !_busy;

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
                NewPasswordField(
                  controller: _password,
                  label: l10n.newPasswordLabel,
                  email: email,
                  pseudonym: ref.watch(pseudonymProvider).value,
                  onValidityChanged: (valid) =>
                      setState(() => _passwordValid = valid),
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
