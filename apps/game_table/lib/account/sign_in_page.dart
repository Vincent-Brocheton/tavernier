import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'account_gateway.dart';
import 'account_providers.dart';
import 'birth_date.dart';
import 'new_password_field.dart';
import 'resend_confirmation_button.dart';

/// Connexion [A1] et inscription [T2], en onglets : une colonne sur
/// téléphone, deux sur desktop [A4]. Une seule erreur d'identifiants
/// (EF-CPT-07) ; 15 ans au moins pour s'inscrire (EF-CPT-01) ; sans réseau,
/// les boutons sont désactivés et expliqués, et rien n'est gardé en
/// attendant (EF-CPT-11).
class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key, this.invalidLink = false});

  /// Ouvert par un lien de confirmation ou de réinitialisation expiré.
  final bool invalidLink;

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _pseudonym = TextEditingController();
  final _newPassword = TextEditingController();
  final _birthDate = TextEditingController();
  var _signingUp = false;
  var _obscured = true;
  var _newPasswordValid = false;
  var _busy = false;
  SignInOutcome? _signInFailure;
  SignUpOutcome? _signUpResult;

  /// Adresse à qui la confirmation a été envoyée.
  String? _confirmSentTo;

  @override
  void dispose() {
    for (final c in [_email, _password, _pseudonym, _newPassword, _birthDate]) {
      c.dispose();
    }
    super.dispose();
  }

  void _done() => context.canPop() ? context.pop() : context.go('/');

  Future<void> _signIn() async {
    final gateway = ref.read(accountGatewayProvider);
    if (gateway == null) return;
    setState(() {
      _busy = true;
      _signInFailure = null;
    });
    final outcome = await gateway.signIn(_email.text, _password.text);
    if (!mounted) return;
    if (outcome == SignInOutcome.signedIn) return _done();
    setState(() {
      _busy = false;
      _signInFailure = outcome;
    });
  }

  /// Google, par redirection : la session revient à l'app, et un compte neuf
  /// passe par la date de naissance (EF-CPT-01).
  Future<void> _google() async {
    try {
      await ref
          .read(accountGatewayProvider)
          ?.signInWithGoogle(redirectTo: kIsWeb ? Uri.base.origin : null);
    } on AccountNetworkException {
      if (mounted) setState(() => _signInFailure = SignInOutcome.network);
    }
  }

  Future<void> _signUp(DateTime birthDate) async {
    final gateway = ref.read(accountGatewayProvider);
    if (gateway == null) return;
    setState(() {
      _busy = true;
      _signUpResult = null;
    });
    final email = _email.text.trim();
    final outcome = await gateway.signUp(
      email: email,
      password: _newPassword.text,
      pseudonym: _pseudonym.text,
      birthDate: birthDate,
      redirectTo: kIsWeb ? Uri.base.origin : null,
    );
    if (!mounted) return;
    if (outcome == SignUpOutcome.signedIn) return _done();
    setState(() {
      _busy = false;
      _signUpResult = outcome;
      if (outcome == SignUpOutcome.confirmEmail) _confirmSentTo = email;
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

    final birthText = _birthDate.text.trim();
    final birthDate = parseBirthDate(birthText);
    final birthError = birthText.length < 10
        ? null
        : birthDate == null || birthDate.isAfter(DateTime.now())
        ? l10n.birthDateInvalid
        : !oldEnough(birthDate, DateTime.now())
        ? l10n.tooYoung
        : null;
    final canSignUp =
        online &&
        !_busy &&
        _pseudonym.text.trim().isNotEmpty &&
        _email.text.contains('@') &&
        _newPasswordValid &&
        birthDate != null &&
        birthError == null;

    final emailField = TextField(
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      textInputAction: TextInputAction.next,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(labelText: l10n.emailLabel),
    );

    final signInFields = [
      if (_signInFailure case final failure?) ...[
        StatusBanner(
          message: switch (failure) {
            SignInOutcome.network => l10n.signInNetworkError,
            SignInOutcome.failed => l10n.signInFailed,
            _ => l10n.signInInvalid,
          },
        ),
        SizedBox(height: AppSpacing.md),
      ],
      emailField,
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
    ];

    final signUpFields = [
      if (_confirmSentTo case final email?) ...[
        StatusBanner(
          kind: StatusBannerKind.info,
          icon: Icons.mark_email_read_outlined,
          title: l10n.signUpConfirmTitle,
          message: l10n.signUpConfirmBody(email),
        ),
        SizedBox(height: AppSpacing.sm),
        // L'e-mail vient de partir : le renvoi attend une minute.
        ResendConfirmationButton(email: email, justSent: true),
        SizedBox(height: AppSpacing.md),
      ],
      if (_signUpResult case SignUpOutcome.network || SignUpOutcome.failed) ...[
        StatusBanner(
          message: _signUpResult == SignUpOutcome.network
              ? l10n.signInNetworkError
              : l10n.signUpFailed,
        ),
        SizedBox(height: AppSpacing.md),
      ],
      TextField(
        controller: _pseudonym,
        autofillHints: const [AutofillHints.nickname],
        textInputAction: TextInputAction.next,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(labelText: l10n.pseudonymLabel),
      ),
      SizedBox(height: AppSpacing.md),
      emailField,
      SizedBox(height: AppSpacing.md),
      NewPasswordField(
        controller: _newPassword,
        label: l10n.passwordLabel,
        email: _email.text.trim(),
        pseudonym: _pseudonym.text.trim(),
        onValidityChanged: (valid) => setState(() => _newPasswordValid = valid),
      ),
      SizedBox(height: AppSpacing.md),
      TextField(
        controller: _birthDate,
        keyboardType: TextInputType.datetime,
        autofillHints: const [AutofillHints.birthday],
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: l10n.birthDateLabel,
          hintText: l10n.birthDateHint,
          errorText: birthError,
          suffixIcon: birthError == null
              ? null
              : const Icon(Icons.error_outline),
        ),
      ),
      SizedBox(height: AppSpacing.lg),
      FilledButton(
        onPressed: canSignUp ? () => _signUp(birthDate) : null,
        child: Text(l10n.signUpAction),
      ),
    ];

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
          SegmentedButton<bool>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(value: false, label: Text(l10n.signInTab)),
              ButtonSegment(value: true, label: Text(l10n.signUpTab)),
            ],
            selected: {_signingUp},
            onSelectionChanged: (s) => setState(() => _signingUp = s.single),
          ),
          SizedBox(height: AppSpacing.md),
          if (widget.invalidLink) ...[
            StatusBanner(
              kind: StatusBannerKind.alert,
              icon: Icons.link_off,
              message: l10n.authLinkInvalid,
            ),
            SizedBox(height: AppSpacing.sm),
            // Lien de confirmation expiré : un autre, à l'adresse saisie.
            ResendConfirmationButton(email: _email.text),
            SizedBox(height: AppSpacing.md),
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
          ...(_signingUp ? signUpFields : signInFields),
          // Google, à la connexion comme à l'inscription (Apple : abandonné).
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Text(l10n.orSeparator, style: text.bodySmall),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: online && !_busy ? _google : null,
            icon: const Icon(Icons.g_mobiledata),
            label: Text(l10n.continueWithGoogle),
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
