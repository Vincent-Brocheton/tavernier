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
import 'encounters_providers.dart';

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

/// Influences passées de la table [tableId], pour la mémoire des échecs
/// (EF-ACT-03) : la cible est le PNJ s'il y en a un, sinon le combattant.
final influenceAttemptsProvider = StreamProvider.autoDispose
    .family<List<InfluenceAttempt>, String>(
      (ref, tableId) => ref
          .watch(combatStoreProvider)
          .watchTableEvents(tableId, CombatEventType.influence)
          .map(
            (rows) => [
              for (final (:at, :event) in rows)
                if (event.payload case {
                  'actor': final String actor,
                  'approach': final String approach,
                  'success': final bool success,
                })
                  (
                    at: at,
                    actor: actor,
                    target:
                        (event.payload['npc'] ?? event.payload['target'] ?? '')
                            as String,
                    approach: approach,
                    success: success,
                    retryHours: (event.payload['retry_hours'] as int?) ?? 24,
                  ),
            ],
          ),
    );

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
      length: 3,
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
          TabBar(
            tabs: [
              Tab(text: l10n.actionStudy),
              Tab(text: l10n.actionInfluence),
              Tab(text: l10n.actionObservation),
            ],
          ),
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
                      _Influence(
                        key: ValueKey('influence:${actor.id}'),
                        encounter: widget.encounter,
                        combat: widget.combat,
                        actor: actor,
                      ),
                      _Observation(
                        key: ValueKey('observation:${actor.id}'),
                        encounter: widget.encounter,
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
    // Sans PNJ, les paliers d'Étude du monstre lui-même.
    final tiers =
        npc?.hiddenInfo ??
        switch (target == null
            ? null
            : monsterOfCombatant(content, npcs, target)) {
          final MonsterData m => [
            for (final r in m.studyReveals) HiddenInfo(dc: r.dc, text: r.text),
          ],
          _ => const <HiddenInfo>[],
        };
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

/// Façon dont la cible reçoit la requête (SRD, « Influence »).
enum Reception { willing, unwilling, hesitant }

/// Influence [C10] : réception, puis test selon la façon d'interagir.
class _Influence extends ConsumerStatefulWidget {
  const _Influence({
    super.key,
    required this.encounter,
    required this.combat,
    required this.actor,
  });

  final Encounter encounter;
  final CombatState combat;
  final Combatant actor;

  @override
  ConsumerState<_Influence> createState() => _InfluenceState();
}

class _InfluenceState extends ConsumerState<_Influence> {
  late String? _target = widget.combat.combatants
      .where((c) => c.kind != CombatantKind.pc)
      .firstOrNull
      ?.id;
  Reception? _reception;
  String? _approach;
  int? _dice;
  String? _attitude;
  final _dc = TextEditingController();
  final _retry = TextEditingController(text: '24');

  @override
  void dispose() {
    _dc.dispose();
    _retry.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final content = ref.watch(contentProvider).value;
    final npcs =
        ref.watch(tableNpcsProvider(widget.encounter.tableId)).value ??
        const <Npc>[];
    final attempts =
        ref.watch(influenceAttemptsProvider(widget.encounter.tableId)).value ??
        const <InfluenceAttempt>[];
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
    final monster = target == null
        ? null
        : monsterOfCombatant(content, npcs, target);
    final npc = npcs.where((n) => n.id == target?.refId).firstOrNull;
    final attitude = npc?.attitude.name ?? target?.attitude ?? 'indifferent';
    final after = _attitude ?? attitude;
    final memoryTarget = npc?.id ?? target?.id ?? '';
    final checks = influenceChecksFor(content, monster?.creatureType);
    final check = checks.where((c) => c.id == _approach).firstOrNull;
    final intelligence = monster?.abilities['int'];
    final dc = int.tryParse(_dc.text) ?? influenceDc(intelligence);
    final mode = influenceMode(attitude);
    int bonusOf(InfluenceCheck c) => switch (content.entity('${c.skill}')) {
      final skill? => skillBonus(sheet, skill),
      null => 0,
    };
    final bonus = check == null ? 0 : bonusOf(check);
    final total = _dice == null ? null : _dice! + bonus;
    final success = switch (_reception) {
      Reception.willing => true,
      Reception.unwilling => false,
      Reception.hesitant => total != null && total >= dc,
      null => false,
    };
    final now = DateTime.now().toUtc();
    final ready =
        target != null &&
        switch (_reception) {
          Reception.hesitant => check != null && total != null,
          null => false,
          _ => true,
        };

    String attitudeName(String code) => switch (code) {
      'friendly' => l10n.attitudeFriendly,
      'hostile' => l10n.attitudeHostile,
      _ => l10n.attitudeIndifferent,
    };

    Future<void> save() async {
      final hesitant = _reception == Reception.hesitant;
      await appendCombat(ref, widget.encounter.id, [
        (
          CombatEventType.influence,
          {
            'actor': widget.actor.id,
            'target': target!.id,
            'npc': ?npc?.id,
            'reception': _reception!.name,
            if (hesitant) ...{
              'approach': check!.id,
              'skill': '${check.skill}',
              'dc': dc,
              'mode': mode.name,
              'total': total,
            },
            'success': success,
            'attitude': after,
            if (hesitant && !success)
              'retry_hours': int.tryParse(_retry.text) ?? 24,
          },
        ),
      ]);
      if (npc != null && after != npc.attitude.name) {
        await ref
            .read(npcStoreProvider)
            .update(npc.id, attitude: Attitude.parse(after));
      }
      if (context.mounted) Navigator.pop(context);
    }

    /// Dernier échec qui bloque encore l'approche [c], s'il y en a un.
    InfluenceAttempt? lastFailure(InfluenceCheck c) {
      final blocked = influenceBlockedUntil(
        attempts,
        actor: widget.actor.id,
        target: memoryTarget,
        approach: c.id,
        now: now,
      );
      if (blocked == null) return null;
      return attempts.lastWhere(
        (a) =>
            !a.success &&
            a.actor == widget.actor.id &&
            a.target == memoryTarget &&
            a.approach == c.id,
      );
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
              DropdownMenuItem(value: c.id, child: Text(c.label)),
          ],
          onChanged: (v) => setState(() {
            _target = v;
            _attitude = null;
            _approach = null;
            _dice = null;
            _dc.clear();
          }),
        ),
        if (target != null)
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              l10n.influenceAttitude(attitudeName(attitude)),
              style: text.bodyMedium,
            ),
          ),
        SizedBox(height: AppSpacing.md),
        Text(l10n.influenceStep1(target?.label ?? ''), style: text.titleSmall),
        SizedBox(height: AppSpacing.xs),
        SegmentedButton<Reception>(
          emptySelectionAllowed: true,
          segments: [
            ButtonSegment(
              value: Reception.willing,
              label: Text(l10n.influenceWilling),
            ),
            ButtonSegment(
              value: Reception.unwilling,
              label: Text(l10n.influenceUnwilling),
            ),
            ButtonSegment(
              value: Reception.hesitant,
              label: Text(l10n.influenceHesitant),
            ),
          ],
          selected: {?_reception},
          onSelectionChanged: (s) => setState(() => _reception = s.firstOrNull),
        ),
        if (_reception case final r?)
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.xs),
            child: Text(switch (r) {
              Reception.willing => l10n.influenceWillingHelp,
              Reception.unwilling => l10n.influenceUnwillingHelp,
              Reception.hesitant => l10n.influenceHesitantHelp,
            }, style: text.bodySmall),
          ),
        if (_reception == Reception.hesitant) ...[
          SizedBox(height: AppSpacing.md),
          Text(l10n.influenceStep2, style: text.titleSmall),
          for (final c in checks)
            ListTile(
              contentPadding: EdgeInsets.zero,
              selected: c.id == _approach,
              leading: Icon(
                c.id == _approach
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
              ),
              title: Text(l10n.influenceApproach(c.id)),
              subtitle: switch (lastFailure(c)) {
                final failed? => Text(
                  l10n.influenceRecentFailure(
                    widget.actor.label,
                    now.difference(failed.at).inHours,
                    failed.retryHours,
                  ),
                  style: TextStyle(color: scheme.error),
                ),
                null => Text(
                  l10n.influenceCheck(
                    namesOf(content, ['${c.ability}']),
                    namesOf(content, ['${c.skill}']),
                  ),
                ),
              },
              trailing: Text(formatSigned(bonusOf(c))),
              onTap: () => setState(() {
                _approach = c.id;
                _dice = null;
              }),
            ),
          SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _dc,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.influenceDcLabel,
              hintText: '${influenceDc(intelligence)}',
              helperText: intelligence == null
                  ? l10n.influenceDcHelpNoInt
                  : l10n.influenceDcHelp(intelligence),
              helperMaxLines: 3,
            ),
            onChanged: (_) => setState(() {}),
          ),
          if (mode != RollMode.normal)
            Padding(
              padding: EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                l10n.influenceMode(
                  mode == RollMode.advantage
                      ? l10n.combatAdvantage
                      : l10n.combatDisadvantage,
                  attitudeName(attitude),
                ),
                style: text.bodyMedium,
              ),
            ),
          if (check != null) ...[
            SizedBox(height: AppSpacing.md),
            Text(l10n.actionResult, style: text.titleSmall),
            SimpleRoll(
              key: ValueKey('${check.id}:${mode.name}'),
              formula: DiceFormula(1, 20, bonus: bonus, mode: mode),
              bonusLabel: namesOf(content, ['${check.skill}']),
              onChanged: (v) => setState(() => _dice = v),
            ),
            if (total != null)
              Text(
                success ? l10n.reminderSucceeded : l10n.reminderFailed,
                style: text.titleMedium,
              ),
            if (total != null && !success)
              TextField(
                controller: _retry,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.influenceRetryLabel,
                ),
              ),
          ],
        ],
        if (_reception != null) ...[
          SizedBox(height: AppSpacing.md),
          Text(l10n.influenceAttitudeAfter, style: text.titleSmall),
          SizedBox(height: AppSpacing.xs),
          SegmentedButton<String>(
            segments: [
              for (final code in ['friendly', 'indifferent', 'hostile'])
                ButtonSegment(value: code, label: Text(attitudeName(code))),
            ],
            selected: {after},
            onSelectionChanged: (s) => setState(() => _attitude = s.first),
          ),
          if (after == attitude)
            Padding(
              padding: EdgeInsets.only(top: AppSpacing.xxs),
              child: Text(
                l10n.influenceUnchanged(attitudeName(attitude)),
                style: text.bodySmall,
              ),
            ),
        ],
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
              onPressed: ready ? save : null,
              child: Text(l10n.influenceSave),
            ),
          ],
        ),
      ],
    );
  }
}

/// Observation [F3] : test de Sagesse, découverte consignée par le MJ
/// (EF-ACT-04) ; pas d'informations préparées.
class _Observation extends ConsumerStatefulWidget {
  const _Observation({super.key, required this.encounter, required this.actor});

  final Encounter encounter;
  final Combatant actor;

  @override
  ConsumerState<_Observation> createState() => _ObservationState();
}

class _ObservationState extends ConsumerState<_Observation> {
  final _sought = TextEditingController();
  final _dc = TextEditingController();
  final _found = TextEditingController();
  String? _skill;
  int? _dice;
  String? _npc;

  @override
  void dispose() {
    _sought.dispose();
    _dc.dispose();
    _found.dispose();
    super.dispose();
  }

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
    final skills = skillsOf(content, 'srd:ability:wisdom');
    final skill =
        skills.where((s) => '${s.id}' == _skill).firstOrNull ??
        skills.where((s) => s.id.slug == 'perception').firstOrNull ??
        skills.firstOrNull;
    final bonus = skill == null ? 0 : skillBonus(sheet, skill);
    final total = _dice == null ? null : _dice! + bonus;
    final dc = int.tryParse(_dc.text);
    final ready =
        skill != null && total != null && _found.text.trim().isNotEmpty;

    Future<void> save() async {
      await appendCombat(ref, widget.encounter.id, [
        (
          CombatEventType.observation,
          {
            'actor': widget.actor.id,
            if (_sought.text.trim().isNotEmpty) 'sought': _sought.text.trim(),
            'skill': '${skill!.id}',
            'total': total,
            'dc': ?dc,
            if (dc != null) 'success': total! >= dc,
            'discovery': _found.text.trim(),
            'npc': ?_npc,
          },
        ),
      ]);
      if (context.mounted) Navigator.pop(context);
    }

    return ListView(
      padding: EdgeInsets.all(AppSpacing.md),
      children: [
        TextField(
          controller: _sought,
          decoration: InputDecoration(labelText: l10n.observationSought),
        ),
        SizedBox(height: AppSpacing.md),
        Text(l10n.observationCheck, style: text.titleSmall),
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
        Padding(
          padding: EdgeInsets.only(top: AppSpacing.xs),
          child: Text(l10n.observationHelp, style: text.bodySmall),
        ),
        SizedBox(height: AppSpacing.md),
        Text(l10n.actionResult, style: text.titleSmall),
        SimpleRoll(
          key: ValueKey(skill?.id),
          formula: DiceFormula(1, 20, bonus: bonus),
          bonusLabel: skill?.name,
          onChanged: (v) => setState(() => _dice = v),
        ),
        SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _dc,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: l10n.observationDc),
          onChanged: (_) => setState(() {}),
        ),
        if (total != null && dc != null)
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              total >= dc ? l10n.reminderSucceeded : l10n.reminderFailed,
              style: text.titleMedium,
            ),
          ),
        SizedBox(height: AppSpacing.md),
        TextField(
          controller: _found,
          minLines: 2,
          maxLines: 6,
          decoration: InputDecoration(labelText: l10n.observationFound),
          onChanged: (_) => setState(() {}),
        ),
        Padding(
          padding: EdgeInsets.only(top: AppSpacing.xs),
          child: Text(l10n.observationNoPrepared, style: text.bodySmall),
        ),
        SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<String?>(
          initialValue: _npc,
          isExpanded: true,
          decoration: InputDecoration(labelText: l10n.observationLinkNpc),
          items: [
            DropdownMenuItem(child: Text(l10n.concentrationNone)),
            for (final n in npcs)
              DropdownMenuItem(value: n.id, child: Text(n.name)),
          ],
          onChanged: (v) => setState(() => _npc = v),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(l10n.observationGmOnly, style: text.bodySmall),
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
              onPressed: ready ? save : null,
              child: Text(l10n.actionLog),
            ),
          ],
        ),
      ],
    );
  }
}
