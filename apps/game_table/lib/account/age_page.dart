import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'account_providers.dart';
import 'birth_date.dart';

/// Date de naissance d'un compte créé sans elle (Google, EF-CPT-01) : le
/// serveur la vérifie sans la garder. Sous 15 ans, le compte est supprimé et
/// l'écran l'explique.
class AgePage extends ConsumerStatefulWidget {
  const AgePage({super.key});

  @override
  ConsumerState<AgePage> createState() => _AgePageState();
}

class _AgePageState extends ConsumerState<AgePage> {
  final _birthDate = TextEditingController();
  var _busy = false;
  var _refused = false;
  var _failed = false;

  @override
  void dispose() {
    _birthDate.dispose();
    super.dispose();
  }

  Future<void> _confirm(DateTime birthDate) async {
    final gateway = ref.read(accountGatewayProvider);
    if (gateway == null) return;
    setState(() {
      _busy = true;
      _failed = false;
    });
    bool accepted;
    try {
      accepted = await gateway.confirmAge(birthDate);
    } on Exception {
      if (mounted) {
        setState(() {
          _busy = false;
          _failed = true;
        });
      }
      return;
    }
    if (!mounted) return;
    if (accepted) {
      context.go('/');
    } else {
      setState(() {
        _busy = false;
        _refused = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final birthText = _birthDate.text.trim();
    final birthDate = parseBirthDate(birthText);
    final invalid =
        birthText.length >= 10 &&
        (birthDate == null || birthDate.isAfter(DateTime.now()));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.ageTitle),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(AppSpacing.md),
              children: [
                if (_refused) ...[
                  StatusBanner(message: l10n.ageRefused),
                  SizedBox(height: AppSpacing.md),
                  FilledButton(
                    onPressed: () => context.go('/'),
                    child: Text(l10n.backToSignIn),
                  ),
                ] else ...[
                  if (_failed) ...[
                    StatusBanner(message: l10n.signInNetworkError),
                    SizedBox(height: AppSpacing.md),
                  ],
                  Text(l10n.ageIntro, style: text.bodyMedium),
                  SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _birthDate,
                    keyboardType: TextInputType.datetime,
                    autofillHints: const [AutofillHints.birthday],
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: l10n.birthDateLabel,
                      hintText: l10n.birthDateHint,
                      errorText: invalid ? l10n.birthDateInvalid : null,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  FilledButton(
                    onPressed: !_busy && birthDate != null && !invalid
                        ? () => _confirm(birthDate)
                        : null,
                    child: Text(l10n.ageContinue),
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
