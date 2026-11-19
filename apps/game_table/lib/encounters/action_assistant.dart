// Assistant Étude, Influence, Observation (US-24, EF-ACT-01 à 07, [C9]) :
// le test d'un personnage, ses résultats inscrits au journal du MJ.
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import '../npcs/npcs_providers.dart';
import '../sheet/simple_roll.dart';
import 'combat_view.dart';

/// Fiche calculée du personnage [id], avec son Épuisement ; `null` si elle
/// est illisible.
final actorSheetProvider = FutureProvider.autoDispose
    .family<ComputedSheet?, String>((ref, id) async {
      final content = await ref.watch(contentProvider.future);
      final store = ref.watch(characterStoreProvider);
      try {
        final input = await store.load(id);
        if (input == null) return null;
        final play = await store.loadState(id);
        return computeSheet(input, content, exhaustion: play.exhaustion);
      } on Object {
        return null;
      }
    });

/// Ouvre l'assistant sur le combat [combat] de [encounter].
Future<void> showActionAssistant(
  BuildContext context,
  Encounter encounter,
  CombatState combat,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  builder: (sheet) => SafeArea(
    child: SizedBox(
      height: MediaQuery.sizeOf(sheet).height * 0.9,
      child: _Assistant(encounter: encounter, combat: combat),
    ),
  ),
);

/// Bonus de [sheet] pour la compétence [skill] ; 0 sans fiche.
int skillBonus(ComputedSheet? sheet, ContentEntity skill) =>
    sheet?.skills[skill.id.slug.replaceAll('-', '_')] ?? 0;

/// « Humanoïdes et Géants », « A, B et C ».
String _andList(AppLocalizations l10n, List<String> items) => items.length < 2
    ? items.join()
    : l10n.andList(items.sublist(0, items.length - 1).join(', '), items.last);

/// Compétences de la caractéristique [ability], dans l'ordre alphabétique.
List<ContentEntity> skillsOf(ActiveContent content, String ability) => [
  for (final e in sortedEntities(content, 'skill'))
    if (e.data case SkillData(ability: final a) when '$a' == ability) e,
];

class _Assistant extends ConsumerStatefulWidget {
  const _Assistant({required this.encounter, required this.combat});

  final Encounter encounter;
  final CombatState combat;

  @override
  ConsumerState<_Assistant> createState() => _AssistantState();
}

class _AssistantState extends ConsumerState<_Assistant> {
  late String? _actor = () {
    final pcs = [
      for (final c in widget.combat.combatants)
        if (c.kind == CombatantKind.pc) c,
    ];
    return (pcs.where((c) => c.unit == widget.combat.active).firstOrNull ??
            pcs.firstOrNull)
        ?.id;
  }();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final pcs = [
      for (final c in widget.combat.combatants)
        if (c.kind == CombatantKind.pc) c,
    ];
    final actor = widget.combat.combatant(_actor ?? '');
    return DefaultTabController(
      length: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _actor,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l10n.actionActor),
                    items: [
                      for (final c in pcs)
                        DropdownMenuItem(value: c.id, child: Text(c.label)),
                    ],
                    onChanged: (v) => setState(() => _actor = v),
                  ),
                ),
                CloseButton(onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          TabBar(tabs: [Tab(text: l10n.actionStudy)]),
          Expanded(
            child: actor == null
                ? Center(child: Text(l10n.actionNoPc, style: text.bodyMedium))
                : TabBarView(
                    children: [
                      _Study(
                        key: ValueKey(actor.id),
                        encounter: widget.encounter,
                        combat: widget.combat,
                        actor: actor,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

/// Étude [C9] : test d'Intelligence sur une cible, paliers révélés.
class _Study extends ConsumerStatefulWidget {
  const _Study({
    super.key,
    required this.encounter,
    required this.combat,
    required this.actor,
  });

  final Encounter encounter;
  final CombatState combat;
  final Combatant actor;

  @override
  ConsumerState<_Study> createState() => _StudyState();
}

class _StudyState extends ConsumerState<_Study> {
  late String? _target = widget.combat.combatants
      .where((c) => c.kind != CombatantKind.pc)
      .firstOrNull
      ?.id;
  String? _skill;
  int? _dice;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final content = ref.watch(contentProvider).value;
    final npcs =
        ref.watch(tableNpcsProvider(widget.encounter.tableId)).value ??
        const <Npc>[];
    final sheet = switch (widget.actor.refId) {
      final id? => ref.watch(actorSheetProvider(id)).value,
      null => null,
    };
    if (content == null) return const SizedBox.shrink();
    final targets = [
      for (final c in widget.combat.combatants)
        if (c.kind != CombatantKind.pc) c,
    ];
    final target = widget.combat.combatant(_target ?? '');
    final type = target == null
        ? null
        : monsterOfCombatant(content, npcs, target)?.creatureType;
    final npc = npcs.where((n) => n.id == target?.refId).firstOrNull;
    final skills = skillsOf(content, 'srd:ability:intelligence');
    final suggested = suggestedStudySkill(content, type);
    final skill =
        skills.where((s) => '${s.id}' == _skill).firstOrNull ??
        skills.where((s) => s.id == suggested).firstOrNull ??
        skills.firstOrNull;
    final bonus = skill == null ? 0 : skillBonus(sheet, skill);
    final total = _dice == null ? null : _dice! + bonus;
    final tiers = npc?.hiddenInfo ?? const <HiddenInfo>[];
    final reached = total == null
        ? const <int>[]
        : [
            for (final i in reachedTiers([for (final t in tiers) t.dc], total))
              if (!tiers[i].revealed) i,
          ];

    Future<void> validate() async {
      await appendCombat(ref, widget.encounter.id, [
        (
          CombatEventType.study,
          {
            'actor': widget.actor.id,
            'target': ?target?.id,
            'skill': '${skill!.id}',
            'total': total,
            'revealed': [for (final i in reached) tiers[i].dc],
          },
        ),
      ]);
      if (npc != null && reached.isNotEmpty) {
        await ref
            .read(npcStoreProvider)
            .update(
              npc.id,
              hiddenInfo: [
                for (final (i, t) in tiers.indexed)
                  reached.contains(i)
                      ? HiddenInfo(dc: t.dc, text: t.text, revealed: true)
                      : t,
              ],
            );
      }
      if (context.mounted) Navigator.pop(context);
    }

    return ListView(
      padding: EdgeInsets.all(AppSpacing.md),
      children: [
        DropdownButtonFormField<String>(
          initialValue: _target,
          isExpanded: true,
          decoration: InputDecoration(labelText: l10n.actionTarget),
          items: [
            for (final c in targets)
              DropdownMenuItem(
                value: c.id,
                child: Text(switch (monsterOfCombatant(
                  content,
                  npcs,
                  c,
                )?.creatureType) {
                  final t? => l10n.actionTargetType(
                    c.label,
                    l10n.creatureType(t.name),
                  ),
                  null => c.label,
                }),
              ),
          ],
          onChanged: (v) => setState(() => _target = v),
        ),
        SizedBox(height: AppSpacing.md),
        Text(l10n.studyCheck, style: text.titleSmall),
        SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final s in skills)
              ChoiceChip(
                label: Text('${s.name} ${formatSigned(skillBonus(sheet, s))}'),
                selected: s == skill,
                onSelected: (_) => setState(() {
                  _skill = '${s.id}';
                  _dice = null;
                }),
              ),
          ],
        ),
        if (suggested != null && type != null)
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              l10n.studySuggested(
                namesOf(content, ['$suggested']),
                _andList(l10n, [
                  for (final MapEntry(:key, :value) in studySkills(
                    content,
                  ).entries)
                    if (value == suggested) l10n.creatureTypes(key.name),
                ]),
              ),
              style: text.bodySmall,
            ),
          ),
        SizedBox(height: AppSpacing.md),
        Text(l10n.actionResult, style: text.titleSmall),
        SimpleRoll(
          key: ValueKey(skill?.id),
          formula: DiceFormula(1, 20, bonus: bonus),
          bonusLabel: skill?.name,
          onChanged: (v) => setState(() => _dice = v),
        ),
        SizedBox(height: AppSpacing.md),
        Text(l10n.studyPrepared, style: text.titleSmall),
        if (tiers.isEmpty)
          Text(l10n.studyNoInfo, style: text.bodySmall)
        else
          for (final (i, t) in tiers.indexed)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Text(l10n.studyDc(t.dc), style: text.titleSmall),
              title: Text(t.text),
              subtitle: Text(
                t.revealed
                    ? l10n.studyAlreadyRevealed
                    : total == null
                    ? ''
                    : reached.contains(i)
                    ? l10n.studyReached
                    : l10n.studyNotReached,
              ),
            ),
        SizedBox(height: AppSpacing.xs),
        Text(l10n.studyGmOnly, style: text.bodySmall),
        SizedBox(height: AppSpacing.md),
        Wrap(
          alignment: WrapAlignment.end,
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: total == null || skill == null ? null : validate,
              child: Text(
                reached.isEmpty
                    ? l10n.actionLog
                    : l10n.studyReveal(reached.length),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
