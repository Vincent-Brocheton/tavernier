import 'dart:async';

import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'account_gateway.dart';
import 'account_providers.dart';

/// Délai avant de pouvoir renvoyer le lien (EF-CPT-08).
const resendDelay = Duration(seconds: 60);

/// Mot de passe oublié [A2] : la réponse ne dit jamais si un compte existe
/// (EF-CPT-07), et le lien se renvoie après 60 secondes.
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _email = TextEditingController();
  String? _sentTo;
  var _busy = false;
  var _networkError = false;
  var _wait = Duration.zero;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final gateway = ref.read(accountGatewayProvider);
    if (gateway == null) return;
    final email = _sentTo ?? _email.text.trim();
    setState(() {
      _busy = true;
      _networkError = false;
    });
    try {
      // Sur le Web, le lien ramène à l'app ; ailleurs, au site du projet.
      await gateway.requestPasswordReset(
        email,
        redirectTo: kIsWeb ? Uri.base.origin : null,
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
    if (!mounted) return;
    setState(() {
      _busy = false;
      _sentTo = email;
      _wait = resendDelay;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _wait -= const Duration(seconds: 1));
      if (_wait <= Duration.zero) timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final sentTo = _sentTo;
    final seconds = _wait.inSeconds;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.forgotTitle)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(AppSpacing.md),
              children: [
                if (_networkError) ...[
                  StatusBanner(message: l10n.signInNetworkError),
                  SizedBox(height: AppSpacing.md),
                ],
                if (sentTo == null) ...[
                  Text(l10n.forgotIntro, style: text.bodyMedium),
                  SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    decoration: InputDecoration(labelText: l10n.emailLabel),
                    onSubmitted: (_) => _busy ? null : _send(),
                  ),
                  SizedBox(height: AppSpacing.md),
                  FilledButton(
                    onPressed: _busy ? null : _send,
                    child: Text(l10n.forgotSend),
                  ),
                ] else ...[
                  Text(l10n.forgotSentTitle, style: text.titleLarge),
                  SizedBox(height: AppSpacing.xs),
                  Text(l10n.forgotSentBody(sentTo), style: text.bodyMedium),
                  SizedBox(height: AppSpacing.md),
                  OutlinedButton(
                    onPressed: seconds > 0 || _busy ? null : _send,
                    child: Text(
                      seconds > 0
                          ? l10n.forgotResendIn(
                              '${seconds ~/ 60}:'
                              '${(seconds % 60).toString().padLeft(2, '0')}',
                            )
                          : l10n.forgotResend,
                    ),
                  ),
                ],
                SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () => context.canPop()
                      ? context.pop()
                      : context.go('/connexion'),
                  child: Text(l10n.backToSignIn),
                ),
                SizedBox(height: AppSpacing.lg),
                Text(l10n.forgotSocialNote, style: text.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
