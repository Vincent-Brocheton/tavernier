import 'dart:async';

import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'account_gateway.dart';
import 'account_providers.dart';
import 'forgot_password_page.dart' show resendDelay;

/// « Renvoyer l'e-mail de confirmation » : utilisable une fois par minute,
/// avec un décompte (comme [A2]), et sans jamais dire si le compte existe.
/// [justSent] démarre le décompte : l'e-mail vient de partir.
class ResendConfirmationButton extends ConsumerStatefulWidget {
  const ResendConfirmationButton({
    super.key,
    required this.email,
    this.justSent = false,
  });

  final String email;
  final bool justSent;

  @override
  ConsumerState<ResendConfirmationButton> createState() =>
      _ResendConfirmationButtonState();
}

class _ResendConfirmationButtonState
    extends ConsumerState<ResendConfirmationButton> {
  var _wait = Duration.zero;
  Timer? _timer;
  String? _sentTo;
  var _networkError = false;

  @override
  void initState() {
    super.initState();
    if (widget.justSent) _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _wait = resendDelay;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _wait -= const Duration(seconds: 1));
      if (_wait <= Duration.zero) timer.cancel();
    });
  }

  Future<void> _resend() async {
    final gateway = ref.read(accountGatewayProvider);
    if (gateway == null) return;
    final email = widget.email.trim();
    try {
      await gateway.resendConfirmation(
        email,
        redirectTo: kIsWeb ? Uri.base.origin : null,
      );
    } on AccountNetworkException {
      if (mounted) setState(() => _networkError = true);
      return;
    }
    if (!mounted) return;
    setState(() {
      _networkError = false;
      _sentTo = email;
      _startCountdown();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final seconds = _wait.inSeconds;
    final ready = seconds <= 0 && widget.email.contains('@');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton(
          onPressed: ready ? _resend : null,
          child: Text(
            seconds > 0
                ? l10n.resendConfirmationIn(
                    '${seconds ~/ 60}:'
                    '${(seconds % 60).toString().padLeft(2, '0')}',
                  )
                : l10n.resendConfirmation,
          ),
        ),
        if (_networkError || _sentTo != null) ...[
          SizedBox(height: AppSpacing.xs),
          Text(
            _networkError
                ? l10n.signInNetworkError
                : l10n.confirmationResent(_sentTo!),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}
