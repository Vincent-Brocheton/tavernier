import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';

/// Abréviation d'une caractéristique (FOR, DEX…).
String abbreviation(AppLocalizations l10n, String code) => switch (code) {
  'str' => l10n.abbrStr,
  'dex' => l10n.abbrDex,
  'con' => l10n.abbrCon,
  'int' => l10n.abbrInt,
  'wis' => l10n.abbrWis,
  _ => l10n.abbrCha,
};

/// Décompositions d'une fiche [2b] : traduit les contributions du moteur.
final class SheetBreakdowns {
  const SheetBreakdowns(this.l10n, this.content, this.sheet);

  final AppLocalizations l10n;
  final ActiveContent content;
  final ComputedSheet sheet;

  String _name(String code) => namesOf(content, [abilityIdByCode[code]!]);

  BreakdownLine _line(
    Contribution c, {
    bool first = false,
    String Function(int)? format,
  }) {
    final String label;
    final String? badge;
    switch (c.label) {
      case 'base':
        (label, badge) = (l10n.breakdownBase, l10n.sourceCreation);
      case 'proficiency':
        (label, badge) = (l10n.breakdownProficiency, null);
      case 'expertise':
        (label, badge) = (l10n.expertise, null);
      case final code when abilityCodes.contains(code):
        (label, badge) = (l10n.breakdownModifier(_name(code)), null);
      case final id:
        (label, badge) = (namesOf(content, [id]), l10n.sourceSrd);
    }
    return BreakdownLine(
      amount: (format ?? (first ? (int v) => '$v' : formatSigned))(c.value),
      label: label,
      badge: badge,
    );
  }

  List<BreakdownLine> _lines(
    Computed value, {
    bool firstPlain = false,
    String Function(int)? format,
  }) => [
    for (final (i, c) in value.sources.indexed)
      _line(c, first: firstPlain && i == 0, format: format),
  ];

  ValueBreakdown _view(
    String category,
    String title,
    String value,
    List<BreakdownLine> lines, {
    String? modifier,
    String? rule,
    List<BreakdownUse> uses = const [],
  }) => ValueBreakdown(
    category: category,
    title: title,
    value: value,
    modifier: modifier,
    lines: lines,
    rule: rule,
    usesLabel: l10n.usedBy,
    uses: uses,
    closeLabel: l10n.close,
  );

  Widget ability(String code) {
    final score = sheet.abilities[code]!;
    final modifier = formatSigned(score.modifier);
    return _view(
      l10n.categoryAbility,
      _name(code),
      '${score.value}',
      _lines(score, firstPlain: true),
      modifier: modifier,
      rule: l10n.modifierRule(modifier, score.value),
      uses: [
        BreakdownUse(
          l10n.savingThrowOf(abbreviation(l10n, code)),
          formatSigned(sheet.savingThrows[code]!),
        ),
        for (final skill in sortedEntities(content, 'skill'))
          if ('${(skill.data as SkillData).ability}' == abilityIdByCode[code])
            BreakdownUse(
              skill.name,
              formatSigned(sheet.skills[skillKey(skill)]!),
            ),
      ],
    );
  }

  Widget skill(ContentEntity skill) => _view(
    l10n.categorySkill,
    skill.name,
    formatSigned(sheet.skills[skillKey(skill)]!),
    _lines(sheet.skillBreakdown[skillKey(skill)]!),
  );

  Widget attack(String name, Attack attack) => _view(
    l10n.categoryAttack,
    name,
    formatSigned(attack.attackBonus),
    _lines(Computed(attack.sources)),
  );

  Widget armorClass() => _view(
    l10n.categoryStat,
    l10n.statArmorClass,
    '${sheet.armorClass.value}',
    _lines(sheet.armorClass, firstPlain: true),
  );

  Widget initiative() => _view(
    l10n.categoryStat,
    l10n.statInitiative,
    formatSigned(sheet.initiative.value),
    _lines(sheet.initiative),
  );

  Widget speed() => _view(
    l10n.categoryStat,
    l10n.statSpeed,
    formatFeet(sheet.speedFeet),
    _lines(sheet.speed, format: formatFeet),
  );

  Widget hitPoints() => _view(
    l10n.categoryStat,
    l10n.statHitPoints,
    '${sheet.hitPointsMax.value}',
    _lines(sheet.hitPointsMax, firstPlain: true),
  );

  Widget proficiency() => _view(
    l10n.categoryStat,
    l10n.statProficiency,
    formatSigned(sheet.proficiencyBonus),
    [
      BreakdownLine(
        amount: formatSigned(sheet.proficiencyBonus),
        label: l10n.proficiencyByLevel(sheet.level),
        badge: l10n.sourceSrd,
      ),
    ],
  );

  Widget passivePerception() => _view(
    l10n.categoryStat,
    l10n.statPassivePerception,
    '${sheet.passivePerception}',
    _lines(
      Computed([
        const Contribution('base', 10),
        ...sheet.skillBreakdown['perception']!.sources,
      ]),
      firstPlain: true,
    ),
  );
}
