import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import '../settings/device_settings.dart';
import 'account_providers.dart';
import 'devices.dart';

/// Section du profil, sur desktop [A7].
enum _Section { display, privacy, devices }

/// Profil et réglages : une colonne sur téléphone [T5] ; sur desktop [A7],
/// les sections à gauche et la section choisie à droite. Affichage
/// (EF-CPT-03), rapports de plantage (EF-CPT-06), déconnexion.
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  var _section = _Section.display;

  Future<void> _signOut() async {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(sessionActionsProvider);
    final pending = await actions.pendingUploads();
    if (!mounted) return;
    if (pending > 0) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.signOutPendingTitle),
          content: Text(l10n.signOutPendingBody(pending)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.signOutAnyway),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }
    await actions.signOut();
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final user = ref.watch(currentUserProvider).value;
    final pseudonym = ref.watch(pseudonymProvider).value;
    final desktop =
        formFactorOf(MediaQuery.sizeOf(context).width) == FormFactor.desktop;

    final header = _ProfileHeader(
      signedIn: user != null,
      name: user == null
          ? l10n.profileSignedOut
          : pseudonym ?? user.email ?? '',
      email: user?.email,
    );
    final signOut = user == null
        ? null
        : TextButton(onPressed: _signOut, child: Text(l10n.signOut));
    final signIn = user != null || ref.watch(accountGatewayProvider) == null
        ? null
        : FilledButton(
            onPressed: () => context.push('/connexion'),
            child: Text(l10n.signInAction),
          );

    if (!desktop) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.profileTitle)),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(AppSpacing.md),
            children: [
              header,
              ?signIn,
              SizedBox(height: AppSpacing.md),
              const _DisplaySection(),
              SizedBox(height: AppSpacing.md),
              const _PrivacySection(),
              if (user != null) ...[
                SizedBox(height: AppSpacing.md),
                const _DevicesSection(),
              ],
              SizedBox(height: AppSpacing.lg),
              ?signOut,
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.page(FormFactor.desktop)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const BackButton(),
                  // Texte courant, comme [A7] (pas la police d'affichage).
                  Text(
                    l10n.profileTitle,
                    style: text.headlineMedium!.copyWith(
                      fontFamily: text.bodyLarge!.fontFamily,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 240,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final (section, label) in [
                            (_Section.display, l10n.displaySection),
                            (_Section.privacy, l10n.privacySection),
                            if (user != null)
                              (_Section.devices, l10n.devicesSection),
                          ])
                            ListTile(
                              title: Text(label),
                              selected: _section == section,
                              selectedTileColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadii.full,
                                ),
                              ),
                              onTap: () => setState(() => _section = section),
                            ),
                          SizedBox(height: AppSpacing.lg),
                          if (signOut != null)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: signOut,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 640),
                        child: ListView(
                          children: [
                            header,
                            ?signIn,
                            SizedBox(height: AppSpacing.md),
                            switch (_section) {
                              _Section.display => const _DisplaySection(),
                              _Section.privacy => const _PrivacySection(),
                              _Section.devices => const _DevicesSection(),
                            },
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Initiale, pseudonyme et e-mail.
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.signedIn,
    required this.name,
    this.email,
  });

  final bool signedIn;
  final String name;
  final String? email;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 28,
        child: !signedIn || name.isEmpty
            ? const Icon(Icons.person_outline)
            : Text(name.characters.first.toUpperCase()),
      ),
      title: Text(name, style: text.titleMedium),
      subtitle: email == null ? null : Text(email!),
      trailing: signedIn
          ? TextButton(
              onPressed: () => context.push('/profil/compte'),
              child: Text(AppLocalizations.of(context).editAccountAction),
            )
          : null,
    );
  }
}

/// Carte de section.
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            SizedBox(height: AppSpacing.sm),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Langue, taille du texte, thème (EF-CPT-03).
class _DisplaySection extends ConsumerWidget {
  const _DisplaySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scale = ref.watch(deviceSettingsProvider).textScale;
    String percent(double s) => l10n.textSizeValue((s * 100).round());
    return _SectionCard(
      title: l10n.displaySection,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.languageLabel),
          trailing: Text(l10n.languageFrench),
        ),
        Row(
          children: [
            Expanded(child: Text(l10n.textSizeLabel, style: text.bodyLarge)),
            Text(percent(scale), style: text.titleSmall),
          ],
        ),
        Slider(
          value: scale,
          min: AppTokens.textScaleMin,
          max: AppTokens.textScaleMax,
          label: percent(scale),
          semanticFormatterCallback: percent,
          // Par pas de 5 %.
          onChanged: (value) => ref
              .read(deviceSettingsProvider.notifier)
              .setTextScale((value * 20).round() / 20),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(percent(AppTokens.textScaleMin), style: text.bodySmall),
            Text(percent(AppTokens.textScaleMax), style: text.bodySmall),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Text(l10n.themeLabel, style: text.bodyLarge),
        SizedBox(height: AppSpacing.xs),
        SegmentedButton<ThemeMode>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(value: ThemeMode.dark, label: Text(l10n.themeDark)),
            ButtonSegment(
              value: ThemeMode.light,
              label: Text(l10n.themeLight),
              enabled: false,
            ),
            ButtonSegment(
              value: ThemeMode.system,
              label: Text(l10n.themeSystem),
              enabled: false,
            ),
          ],
          selected: const {ThemeMode.dark},
          onSelectionChanged: (_) {},
        ),
        SizedBox(height: AppSpacing.xs),
        Text(l10n.themeLightSoon, style: text.bodySmall),
      ],
    );
  }
}

/// Rapports de plantage, révocables (EF-CPT-06).
class _PrivacySection extends ConsumerWidget {
  const _PrivacySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return _SectionCard(
      title: l10n.privacySection,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.crashReportsLabel),
          subtitle: Text(l10n.crashReportsHint),
          value: ref.watch(deviceSettingsProvider).crashReports ?? false,
          onChanged: (value) =>
              ref.read(deviceSettingsProvider.notifier).setCrashReports(value),
        ),
      ],
    );
  }
}

/// Appareils connectés au compte, et déconnexion à distance (EF-CPT-05).
class _DevicesSection extends ConsumerWidget {
  const _DevicesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final devices = ref.watch(connectedDevicesProvider);
    return _SectionCard(
      title: l10n.devicesSection,
      children: switch (devices) {
        AsyncData(:final value) => [
          for (final device in value) _DeviceTile(device: device),
        ],
        AsyncError() => [Text(l10n.devicesOffline)],
        _ => [const LinearProgressIndicator()],
      },
    );
  }
}

class _DeviceTile extends ConsumerWidget {
  const _DeviceTile({required this.device});

  final ConnectedDevice device;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final info = device.info;
    final platform = switch (info.platform) {
      DevicePlatform.windows => l10n.platformWindows,
      DevicePlatform.macos => l10n.platformMacos,
      DevicePlatform.linux => l10n.platformLinux,
      DevicePlatform.android => l10n.platformAndroid,
      DevicePlatform.iphone => l10n.platformIphone,
      DevicePlatform.ipad => l10n.platformIpad,
      null => null,
    };
    final name = switch ((info.browser, platform)) {
      (final browser?, final platform?) => l10n.deviceBrowserOn(
        browser,
        platform,
      ),
      (final browser?, null) => browser,
      (null, _) when info.platform == DevicePlatform.android =>
        info.form == DeviceForm.tablet
            ? l10n.deviceAndroidTablet
            : l10n.deviceAndroidPhone,
      (null, final platform?) => platform,
      (null, null) => l10n.deviceUnknown,
    };
    final activity = activitySince(device.lastActive, DateTime.now());
    final since = switch (activity.unit) {
      ActivityUnit.now => l10n.activeNow,
      ActivityUnit.minutes => l10n.activeMinutes(activity.count),
      ActivityUnit.hours => l10n.activeHours(activity.count),
      ActivityUnit.days => l10n.activeDays(activity.count),
      ActivityUnit.weeks => l10n.activeWeeks(activity.count),
      ActivityUnit.months => l10n.activeMonths(activity.count),
    };
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(switch (info.form) {
        DeviceForm.phone => Icons.smartphone,
        DeviceForm.tablet => Icons.tablet,
        DeviceForm.computer => Icons.computer,
        DeviceForm.unknown => Icons.devices_other,
      }),
      title: Text(name),
      subtitle: Text(device.current ? l10n.thisDeviceNow : since),
      trailing: device.current
          ? null
          : TextButton(
              onPressed: () async {
                try {
                  await ref
                      .read(sessionActionsProvider)
                      .revokeDevice(device.id);
                } on Exception {
                  // Sans réseau : rien n'a changé, on le dit.
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.devicesOffline)),
                    );
                  }
                  return;
                }
                ref.invalidate(connectedDevicesProvider);
              },
              child: Text(l10n.revokeDevice),
            ),
    );
  }
}
