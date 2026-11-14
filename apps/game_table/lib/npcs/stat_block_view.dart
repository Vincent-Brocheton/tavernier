// Profil de jeu d'un monstre ou d'un PNJ en bloc de stats (US-18, [C2]),
// tel qu'imprimé dans le SRD : rien n'est recalculé.
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import '../sheet/sheet_breakdowns.dart';

/// Ligne de type : « Humanoïde de taille M ou P, Neutre », « Dragon
/// (Chromatique) de taille TG, Chaotique Mauvais ».
String typeLineOf(AppLocalizations l10n, MonsterData m) {
  String size(MonsterSize s) => l10n.monsterSize(s.name);
  final sizes = m.sizes.map(size).reduce(l10n.statSizeOr);
  final tags = m.typeTags.isEmpty ? '' : ' (${m.typeTags.join(', ')})';
  final type = switch (m.swarmSize) {
    final swarm? => l10n.statSwarmLine(
      sizes,
      l10n.creatureTypes(m.creatureType.name),
      size(swarm),
    ),
    null => l10n.statTypeLine(
      '${l10n.creatureType(m.creatureType.name)}$tags',
      sizes,
    ),
  };
  return '$type, ${m.alignment}';
}

/// Usage limité d'une action : « (recharge 5–6) », « (2/jour) ».
String? usesOf(AppLocalizations l10n, MonsterUses? uses) => switch (uses) {
  null => null,
  MonsterUses(:final recharge?) => l10n.statRecharge(
    recharge.replaceAll('-', '–'),
  ),
  MonsterUses(:final perDay?, :final perDayLair?) => l10n.statPerDayLair(
    perDay,
    perDayLair,
  ),
  MonsterUses(:final perDay?) => l10n.statPerDay(perDay),
  MonsterUses(rest: 'long') => l10n.statRestLong,
  MonsterUses() => l10n.statRestShortOrLong,
};

/// Profil de [monster], sous le titre [name].
class StatBlockView extends StatelessWidget {
  const StatBlockView({
    super.key,
    required this.monster,
    required this.content,
    this.name,
    this.source,
  });

  final MonsterData monster;
  final ActiveContent content;
  final String? name;

  /// Ligne sous le type, par exemple le monstre de départ d'un PNJ.
  final String? source;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final m = monster;
    String names(Iterable<Object> ids) => namesOf(content, ids);

    final speed = [
      if (m.speed.walk case final walk?) formatFeet(walk),
      if (m.speed.burrow case final v?) l10n.statBurrow(formatFeet(v)),
      if (m.speed.climb case final v?) l10n.statClimb(formatFeet(v)),
      // Ordre du SRD : escalade, nage, puis vol.
      if (m.speed.swim case final v?) l10n.statSwim(formatFeet(v)),
      if (m.speed.fly case final v?)
        [l10n.statFly(formatFeet(v)), if (m.hover) l10n.statHover].join(' '),
    ].join(', ');
    final senses = [
      [
        if (m.senses.blindsight case final v?)
          [
            l10n.statBlindsight(formatFeet(v)),
            if (m.senses.blindBeyond ?? false) l10n.statBlindBeyond,
          ].join(' '),
        if (m.senses.darkvision case final v?)
          l10n.statDarkvision(formatFeet(v)),
        if (m.senses.tremorsense case final v?)
          l10n.statTremorsense(formatFeet(v)),
        if (m.senses.truesight case final v?) l10n.statTruesight(formatFeet(v)),
        ?m.sensesNote,
      ].join(', '),
      l10n.statPassive(m.passivePerception),
    ].where((s) => s.isNotEmpty).join(' ; ');
    final immunities = [
      if (m.immunities.isNotEmpty) names(m.immunities),
      if (m.conditionImmunities.isNotEmpty) names(m.conditionImmunities),
    ].join(' ; ');
    final cr = switch (m.xpLair) {
      final lair? => l10n.statCrLairValue(
        m.cr,
        formatThousands(m.xp),
        formatThousands(lair),
        formatSigned(m.proficiencyBonus),
      ),
      null => l10n.statCrValue(
        m.cr,
        formatThousands(m.xp),
        formatSigned(m.proficiencyBonus),
      ),
    };

    Widget line(String label, String value) => Padding(
      padding: EdgeInsets.only(top: AppSpacing.xxs),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
        style: text.bodyMedium,
      ),
    );
    Widget value(String label, String value) => Expanded(
      child: Card(
        margin: EdgeInsets.all(AppSpacing.xxs),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Column(
            children: [
              Text(label, style: text.labelMedium),
              Text(value, style: text.titleMedium, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );

    final sections = [
      (MonsterActionKind.trait, l10n.statTraits),
      (MonsterActionKind.action, l10n.statActions),
      (MonsterActionKind.bonus, l10n.statBonusActions),
      (MonsterActionKind.reaction, l10n.statReactions),
      (MonsterActionKind.legendary, l10n.statLegendaryActions),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (name != null)
          Text(
            name!,
            style: text.headlineSmall!.copyWith(color: scheme.tertiary),
          ),
        Text(typeLineOf(l10n, m), style: text.bodyMedium),
        if (source != null) Text(source!, style: text.bodySmall),
        SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            value(l10n.statAc, '${m.ac}'),
            value(
              l10n.statInitiative,
              l10n.statInitiativeValue(
                formatSigned(m.initiative),
                10 + m.initiative,
              ),
            ),
            value(l10n.statHp, l10n.statHpValue(m.hp, m.hitDice)),
            value(l10n.statSpeed, speed),
          ],
        ),
        if (m.acNote case final note?) Text(note, style: text.bodySmall),
        if (m.speedNote case final note?) Text(note, style: text.bodySmall),
        SizedBox(height: AppSpacing.sm),
        Wrap(
          children: [
            for (final code in const ['str', 'dex', 'con', 'int', 'wis', 'cha'])
              SizedBox(
                width: 104,
                child: Card(
                  margin: EdgeInsets.all(AppSpacing.xxs),
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xs),
                    child: Column(
                      children: [
                        Text(
                          '${abbreviation(l10n, code)} ${m.abilities[code]}',
                          style: text.labelLarge,
                        ),
                        Text(
                          formatSigned(abilityModifier(m.abilities[code]!)),
                          style: text.titleMedium,
                        ),
                        Text(
                          l10n.statSave(formatSigned(m.savingThrows[code]!)),
                          style: text.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (m.skills.isNotEmpty)
          line(
            l10n.statSkills,
            [
              for (final MapEntry(:key, :value) in m.skills.entries)
                '${names([key])} ${formatSigned(value)}',
            ].join(', '),
          ),
        if (m.vulnerabilities.isNotEmpty)
          line(l10n.statVulnerabilities, names(m.vulnerabilities)),
        if (m.resistances.isNotEmpty)
          line(l10n.statResistances, names(m.resistances)),
        if (immunities.isNotEmpty) line(l10n.statImmunities, immunities),
        if (m.gear.isNotEmpty) line(l10n.statGear, m.gear.join(', ')),
        line(l10n.statSenses, senses),
        line(l10n.statLanguages, m.languages),
        line(l10n.statCr, cr),
        for (final (kind, title) in sections)
          if (m.actions.where((a) => a.kind == kind).toList() case final actions
              when actions.isNotEmpty) ...[
            DetailHeading(title),
            if (kind == MonsterActionKind.legendary && m.legendaryUses != null)
              Text(switch (m.legendaryUsesLair) {
                final lair? => l10n.statLegendaryUsesLair(
                  m.legendaryUses!,
                  lair,
                ),
                null => l10n.statLegendaryUses(m.legendaryUses!),
              }, style: text.bodyMedium),
            for (final action in actions)
              Padding(
                padding: EdgeInsets.only(top: AppSpacing.xs),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: [
                          action.name,
                          ?usesOf(l10n, action.uses),
                        ].join(' '),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      TextSpan(text: '. ${action.text}'),
                    ],
                  ),
                  style: text.bodyMedium,
                ),
              ),
          ],
      ],
    );
  }
}
