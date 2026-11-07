import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/step_layout.dart';
import '../creation/subchoices.dart';
import '../l10n/app_localizations.dart';
import 'sheet_breakdowns.dart';
import 'sheet_features.dart';

/// Moment où une ressource se recharge.
String? rechargeLabel(AppLocalizations l10n, String? on) => switch (on) {
  'short_rest' => l10n.rechargeShortRest,
  'long_rest' => l10n.rechargeLongRest,
  _ => null,
};

/// Onglet Combat [F1].
class CombatTab extends StatelessWidget {
  const CombatTab({
    super.key,
    required this.content,
    required this.character,
    required this.sheet,
  });

  final ActiveContent content;
  final CharacterInput character;
  final ComputedSheet sheet;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final resources = [
      for (final group in featureGroups(character, sheet, content))
        for (final feature in group.features)
          if (feature.resource != null) feature,
    ];
    return ListView(
      padding: EdgeInsets.all(AppSpacing.md),
      children: [
        Text(l10n.summaryAttacks, style: text.titleMedium),
        SizedBox(height: AppSpacing.xs),
        for (final attack in sheet.attacks)
          _AttackCard(
            content: content,
            character: character,
            sheet: sheet,
            attack: attack,
          ),
        if (resources.isNotEmpty) ...[
          SizedBox(height: AppSpacing.sm),
          Text(l10n.resourcesTitle, style: text.titleMedium),
          SizedBox(height: AppSpacing.xs),
          for (final feature in resources)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(feature.entity.name),
              subtitle: Text(firstSentence(feature.entity.textFr ?? '')),
              trailing: ResourcePips(
                total: feature.resource!.max,
                available: feature.resource!.max,
                semanticLabel: l10n.usesOf(
                  feature.resource!.max,
                  feature.resource!.max,
                ),
              ),
            ),
        ],
        if (sheet.weaponMasterySlots > 0) ...[
          SizedBox(height: AppSpacing.sm),
          Text(
            l10n.masteriesCount(
              character.weaponMasteries.length,
              sheet.weaponMasterySlots,
            ),
            style: text.titleMedium,
          ),
          SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final mastery in character.weaponMasteries)
                Chip(label: Text(_masteryLabel(content, mastery.weaponId))),
            ],
          ),
        ],
      ],
    );
  }
}

String _masteryLabel(ActiveContent content, String weaponId) {
  final data = content.entity(weaponId)?.data;
  final weapon = namesOf(content, [weaponId]);
  return data is WeaponData
      ? '$weapon · ${namesOf(content, [data.mastery])}'
      : weapon;
}

class _AttackCard extends StatelessWidget {
  const _AttackCard({
    required this.content,
    required this.character,
    required this.sheet,
    required this.attack,
  });

  final ActiveContent content;
  final CharacterInput character;
  final ComputedSheet sheet;
  final Attack attack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final unarmed = attack.weaponId == 'unarmed';
    final name = unarmed
        ? l10n.unarmedStrike
        : namesOf(content, [attack.weaponId]);
    final quantity = character.items
        .where((i) => i.itemId == attack.weaponId)
        .firstOrNull
        ?.quantity;
    final range = attack.rangeFeet;
    final mastery = attack.mastery;
    final detail = [
      namesOf(content, ['srd:damage-type:${attack.damageType}']),
      if (range != null) range.map(formatFeet).join(' / '),
      if (quantity != null && quantity > 1) l10n.inReserve(quantity),
    ].join(' · ');
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.xs),
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: text.titleMedium),
                    Text(detail, style: text.bodySmall),
                  ],
                ),
              ),
              SizedBox(
                width: 72,
                child: StatTile(
                  value: formatSigned(attack.attackBonus),
                  label: l10n.toHit,
                  onTap: () => showAdaptiveSheet(
                    context,
                    SheetBreakdowns(l10n, content, sheet).attack(name, attack),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              SizedBox(
                width: 88,
                child: Column(
                  children: [
                    Text(
                      attack.damage.replaceAll('+', ' + '),
                      style: AppTypography.numeric(text.titleMedium!),
                    ),
                    Text(l10n.damageLabel, style: text.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          if (mastery != null) ...[
            SizedBox(height: AppSpacing.xs),
            Text(
              l10n.masteryOn(namesOf(content, [mastery])),
              style: text.labelMedium,
            ),
            Text(
              firstSentence(content.entity(mastery)?.textFr ?? ''),
              style: text.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
