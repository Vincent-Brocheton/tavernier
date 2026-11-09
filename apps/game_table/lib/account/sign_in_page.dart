import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'account_gateway.dart';
import 'account_providers.dart';

/// Connexion par e-mail et mot de passe : une colonne sur téléphone [A1],
/// deux sur desktop [A4]. Une seule erreur d'identifiants (EF-CPT-07) ; sans
/// réseau, le bouton est désactivé et expliqué, et rien n'est gardé en
/// attendant (EF-CPT-11).
class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  var _obscured = true;
  var _busy = false;
  SignInOutcome? _failure;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final gateway = ref.read(accountGatewayProvider);
    if (gateway == null) return;
    setState(() {
      _busy = true;
      _failure = null;
    });
    final outcome = await gateway.signIn(_email.text, _password.text);
    if (!mounted) return;
    if (outcome == SignInOutcome.signedIn) {
      context.canPop() ? context.pop() : context.go('/');
      return;
    }
    setState(() {
      _busy = false;
      _failure = outcome;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final online = ref.watch(onlineProvider).value ?? true;
    final desktop =
        formFactorOf(MediaQuery.sizeOf(context).width) == FormFactor.desktop;

    final form = AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (desktop) ...[
            Text(l10n.signInTitle, style: text.headlineMedium),
            SizedBox(height: AppSpacing.xs),
            Text(l10n.signInPurpose, style: text.bodyMedium),
            SizedBox(height: AppSpacing.lg),
          ],
          if (!online) ...[
            StatusBanner(
              kind: StatusBannerKind.alert,
              icon: Icons.cloud_off,
              title: l10n.offlineTitle,
              message: l10n.offlineFirstSignIn,
            ),
            SizedBox(height: AppSpacing.md),
          ],
          if (_failure case final failure?) ...[
            StatusBanner(
              message: switch (failure) {
                SignInOutcome.network => l10n.signInNetworkError,
                SignInOutcome.failed => l10n.signInFailed,
                _ => l10n.signInInvalid,
              },
            ),
            SizedBox(height: AppSpacing.md),
          ],
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: l10n.emailLabel),
          ),
          SizedBox(height: AppSpacing.md),
          TextField(
            controller: _password,
            obscureText: _obscured,
            autofillHints: const [AutofillHints.password],
            onSubmitted: (_) => online && !_busy ? _signIn() : null,
            decoration: InputDecoration(
              labelText: l10n.passwordLabel,
              suffixIcon: IconButton(
                tooltip: _obscured ? l10n.showPassword : l10n.hidePassword,
                icon: Icon(_obscured ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscured = !_obscured),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.push('/connexion/mot-de-passe-oublie'),
              child: Text(l10n.forgotPasswordLink),
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          FilledButton(
            onPressed: online && !_busy ? _signIn : null,
            child: Text(l10n.signInAction),
          ),
          SizedBox(height: AppSpacing.xl),
          Text(
            desktop ? l10n.signInDesktopFooter : l10n.signInFooter,
            textAlign: TextAlign.center,
            style: text.bodySmall,
          ),
        ],
      ),
    );

    if (desktop) {
      return Scaffold(
        body: Row(
          children: [
            Expanded(
              child: ColoredBox(
                color: scheme.primaryContainer,
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.page(FormFactor.desktop)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.signInTagline,
                        style: text.displaySmall!.copyWith(
                          color: scheme.tertiary,
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        l10n.signInPitch,
                        style: text.titleMedium!.copyWith(
                          color: scheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppSpacing.page(FormFactor.desktop)),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: form,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.page(FormFactor.phone)),
          children: [
            Text(
              l10n.signInWelcome,
              style: text.headlineLarge!.copyWith(color: scheme.tertiary),
            ),
            SizedBox(height: AppSpacing.xs),
            Text(l10n.signInPurpose, style: text.bodyMedium),
            SizedBox(height: AppSpacing.lg),
            form,
          ],
        ),
      ),
    );
  }
}
