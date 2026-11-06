import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'creation_providers.dart';
import 'details_step.dart';
import 'draft_input.dart';
import 'equipment_step.dart';
import 'step_layout.dart';

/// Étape 9, Récapitulatif [P8] : la fiche calculée, les alertes et les
/// erreurs. L'envoi au MJ arrive avec les tables, en M2.
class SummaryStep extends ConsumerWidget {
  const SummaryStep({super.key, required this.content});

  final ActiveContent content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final draft = ref.watch(creationProvider);
    final input = toCharacterInput(draft, content);
    final sheet = computeSheet(input, content);
    final cls = content.entity(draft.classId!)!.data as ClassData;
    final species = content.entity(draft.speciesId!)!.data as SpeciesData;
    final absent = masteriesWithoutWeapon(input);
    final tools = [
      ?(content.entity(draft.backgroundId!)!.data as BackgroundData)
          .toolProficiency,
      ?draft.toolChoice,
      ...draft.classTools,
    ];
    final feats = [
      for (final feat in input.feats) feat.featId,
      ...levelOneFeatures(cls),
      ...species.traits,
    ];
    final initiate = [
      for (final feat in input.feats)
        ...?feat.choices?['cantrips'] as List<String>?,
      for (final feat in input.feats)
        if (feat.choices?['level_1_spell'] case final String spell) spell,
    ];
    final spells = [
      ...input.spells.cantrips,
      ...input.spells.prepared,
      ...initiate,
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(input.name, style: text.headlineSmall),
          Text(
            [
              namesOf(content, [draft.speciesId!]),
              l10n.classLevel(namesOf(content, [draft.classId!]), 1),
              namesOf(content, [draft.backgroundId!]),
              if (draft.alignment case final code?) alignmentName(l10n, code),
            ].join(' · '),
            style: text.bodyMedium,
          ),
          SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final code in abilityCodes)
                _Stat(
                  namesOf(content, [abilityIdByCode[code]!]),
                  formatSigned(sheet.abilities[code]!.modifier),
                  note: l10n.savingThrow(
                    formatSigned(sheet.savingThrows[code]!),
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _Stat(l10n.statHitPoints, '${sheet.hitPointsMax.value}'),
              _Stat(l10n.statArmorClass, '${sheet.armorClass.value}'),
              _Stat(l10n.statInitiative, formatSigned(sheet.initiative.value)),
              _Stat(l10n.statSpeed, formatFeet(sheet.speedFeet)),
              _Stat(l10n.statProficiency, formatSigned(sheet.proficiencyBonus)),
              _Stat(l10n.statPassivePerception, '${sheet.passivePerception}'),
            ],
          ),
          DetailHeading(l10n.summaryProficiencies),
          DetailRow(
            l10n.labelSkills,
            [
              for (final skill in sortedEntities(content, 'skill'))
                if (sheet.skillProficiencies.contains(skill.id.slug))
                  '${skill.name} '
                      '${formatSigned(sheet.skills[skill.id.slug] ?? 0)}',
            ].join(', '),
          ),
          if (tools.isNotEmpty)
            DetailRow(l10n.summaryTools, namesOf(content, tools)),
          DetailRow(l10n.summaryLanguages, namesOf(content, input.languages)),
          if (sheet.attacks.isNotEmpty) ...[
            DetailHeading(l10n.summaryAttacks),
            for (final attack in sheet.attacks)
              DetailRow(
                attack.weaponId == 'unarmed'
                    ? l10n.unarmedStrike
                    : namesOf(content, [attack.weaponId]),
                [
                  formatSigned(attack.attackBonus),
                  '${attack.damage} '
                      '${namesOf(content, ['srd:damage-type:${attack.damageType}'])}',
                  if (attack.mastery case final mastery?)
                    namesOf(content, [mastery]),
                ].join(' · '),
              ),
          ],
          DetailHeading(l10n.summaryFeatures),
          Text(namesOf(content, feats), style: text.bodyMedium),
          if (spells.isNotEmpty) ...[
            DetailHeading(l10n.summarySpells),
            Text(namesOf(content, spells), style: text.bodyMedium),
          ],
          DetailHeading(l10n.stepEquipment),
          Text(
            [
              for (final item in input.items)
                itemLabel(content, item.itemId, item.quantity),
              l10n.goldPieces(input.coins['gp'] ?? 0),
            ].join(', '),
            style: text.bodyMedium,
          ),
          DetailHeading(l10n.summaryChecks),
          for (final error in sheet.integrityErrors) ...[
            StatusBanner(title: l10n.ruleError, message: error.message),
            SizedBox(height: AppSpacing.xs),
          ],
          if (absent.isNotEmpty) ...[
            StatusBanner(
              title: l10n.masteryWithoutWeaponTitle,
              message: l10n.masteryWithoutWeapon(namesOf(content, absent)),
            ),
            SizedBox(height: AppSpacing.xs),
          ],
          _Check(l10n.checkPoints(sheet.pointBuyCost ?? 0, pointBuyBudget)),
          _Check(
            l10n.checkBonus(
              [
                for (final MapEntry(key: code, value: bonus)
                    in draft.bonuses.entries)
                  '${formatSigned(bonus)} '
                      '${namesOf(content, [abilityIdByCode[code]!])}',
              ].join(', '),
            ),
          ),
          _Check(
            l10n.checkPacks(
              content.packs.map((p) => p.manifest.name).join(', '),
            ),
          ),
          SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value, {this.note});

  final String label;
  final String value;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      width: 112,
      padding: EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Column(
        children: [
          Text(label, style: text.labelMedium, textAlign: TextAlign.center),
          Text(value, style: text.titleLarge),
          if (note case final note?) Text(note, style: text.bodySmall),
        ],
      ),
    );
  }
}

class _Check extends StatelessWidget {
  const _Check(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: AppSpacing.xxs),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    ),
  );
}
