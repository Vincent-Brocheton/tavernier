import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'abilities_step.dart';
import 'background_step.dart';
import 'class_step.dart';
import 'creation_draft.dart';
import 'creation_providers.dart';
import 'languages_step.dart';
import 'species_step.dart';

/// Assistant de création en 9 étapes (cahier §5.1, [P1]–[P9]).
class CreationPage extends ConsumerWidget {
  const CreationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: ref
            .watch(contentProvider)
            .when(
              data: _Wizard.new,
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.contentError),
                    SizedBox(height: AppSpacing.sm),
                    FilledButton(
                      onPressed: () => ref.invalidate(contentProvider),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}

class _Wizard extends ConsumerWidget {
  const _Wizard(this.content);

  final ActiveContent content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(creationProvider);
    final notifier = ref.read(creationProvider.notifier);
    final form = formFactorOf(MediaQuery.sizeOf(context).width);
    final phone = form == FormFactor.phone;
    final margin = AppSpacing.page(form);
    final steps = _steps(l10n, draft, content);
    final last = draft.step == creationStepCount - 1;
    final body = switch (draft.step) {
      0 => ClassStep(content: content),
      1 => BackgroundStep(content: content),
      2 => SpeciesStep(content: content),
      3 => LanguagesStep(content: content),
      4 => AbilitiesStep(content: content),
      _ => Center(child: Text(l10n.comingSoon)),
    };
    final nextName = last ? null : steps[draft.step + 1].label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(
          draft: draft,
          title: steps[draft.step].label,
          intro: _intro(l10n, draft.step),
          margin: margin,
          phone: phone,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(margin, AppSpacing.md, margin, 0),
            child: phone
                ? body
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 232,
                        child: SingleChildScrollView(
                          child: WizardSteps(
                            steps: steps,
                            current: draft.step,
                            reached: draft.reached,
                            onSelected: (step) =>
                                notifier.update((d) => d.goTo(step, content)),
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.lg),
                      Expanded(child: body),
                    ],
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(margin),
          child: WizardFooter(
            previousLabel: l10n.previous,
            nextLabel: phone || nextName == null
                ? l10n.next
                : l10n.nextTo(nextName),
            onPrevious: draft.step == 0
                ? null
                : () => notifier.update((d) => d.previous()),
            onNext: () => notifier.update((d) => d.next(content)),
            // L'assistant s'arrête aux Sous-choix, encore à livrer.
            blockedReason: draft.step >= 5
                ? l10n.comingSoon
                : _reason(l10n, draft, content),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.draft,
    required this.title,
    required this.intro,
    required this.margin,
    required this.phone,
  });

  final CreationDraft draft;
  final String title;
  final String? intro;
  final double margin;
  final bool phone;

  void _close(BuildContext context) =>
      context.canPop() ? context.pop() : context.go('/');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final number = draft.step + 1;
    final short = MediaQuery.sizeOf(context).height < 600;
    return Container(
      color: scheme.surfaceContainerLow,
      padding: EdgeInsets.fromLTRB(
        margin,
        AppSpacing.xs,
        margin,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: l10n.close,
                onPressed: () => _close(context),
              ),
              SizedBox(width: AppSpacing.xs),
              Expanded(child: Text(l10n.newCharacter, style: text.titleMedium)),
            ],
          ),
          if (phone)
            WizardProgress(
              label: l10n.stepOf(number, creationStepCount),
              value: number / creationStepCount,
            )
          else
            Text(
              l10n.stepEyebrow(number, creationStepCount),
              style: text.labelMedium!.copyWith(color: scheme.onSurfaceVariant),
            ),
          SizedBox(height: AppSpacing.xs),
          Text(
            title,
            style: text.headlineMedium!.copyWith(color: scheme.tertiary),
          ),
          // Sur un écran bas (téléphone en paysage), la liste passe avant.
          if (intro case final value? when !short)
            Padding(
              padding: EdgeInsets.only(top: AppSpacing.xxs),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Text(value, style: text.bodyMedium),
              ),
            ),
        ],
      ),
    );
  }
}

String? _intro(AppLocalizations l10n, int step) => switch (step) {
  0 => l10n.introClass,
  1 => l10n.introBackground,
  2 => l10n.introSpecies,
  3 => l10n.introLanguages,
  4 => l10n.introAbilities(pointBuyBudget),
  _ => null,
};

String? _reason(
  AppLocalizations l10n,
  CreationDraft draft,
  ActiveContent content,
) => switch (missingChoice(draft, content)) {
  null => null,
  MissingChoice.classChoice => l10n.missingClass,
  MissingChoice.background => l10n.missingBackground,
  MissingChoice.tool => l10n.missingTool,
  MissingChoice.species => l10n.missingSpecies,
  MissingChoice.size => l10n.missingSize,
  MissingChoice.languages => l10n.missingLanguages(
    startingLanguageChoices - draft.languages.length,
  ),
  MissingChoice.points => l10n.missingPoints(draft.remainingPoints),
  MissingChoice.bonusInvalid => l10n.missingBonusInvalid,
  MissingChoice.bonus => l10n.missingBonus,
};

List<WizardStep> _steps(
  AppLocalizations l10n,
  CreationDraft draft,
  ActiveContent content,
) {
  String chosen(String? id) =>
      (id == null ? null : content.entity(id)?.name) ?? l10n.stepToChoose;
  return [
    WizardStep(label: l10n.stepClass, detail: chosen(draft.classId)),
    WizardStep(label: l10n.stepBackground, detail: chosen(draft.backgroundId)),
    WizardStep(label: l10n.stepSpecies, detail: chosen(draft.speciesId)),
    WizardStep(
      label: l10n.stepLanguages,
      detail: draft.languages.isEmpty
          ? l10n.stepLanguagesHint
          : [
              startingLanguageId,
              ...draft.languages,
            ].map((id) => content.entity(id)?.name ?? id).join(', '),
    ),
    WizardStep(label: l10n.stepAbilities, detail: l10n.stepAbilitiesHint),
    WizardStep(label: l10n.stepSubchoices, detail: l10n.stepSubchoicesHint),
    WizardStep(label: l10n.stepEquipment, detail: l10n.stepEquipmentHint),
    WizardStep(label: l10n.stepDetails, detail: l10n.stepDetailsHint),
    WizardStep(label: l10n.stepSummary, detail: l10n.stepSummaryHint),
  ];
}
