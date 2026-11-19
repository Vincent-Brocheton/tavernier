// Pavé dégâts et soins (US-21, EF-PV-01 à 04, [1b], COMPOSANTS §2.4) :
// cibles, montant et type, aperçu par cible, coup critique, corrections
// ½ et ×2, soins, PV temporaires ; une touche pour appliquer.
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import 'combat_view.dart';
import 'concentration.dart';
import 'encounters_providers.dart';
import 'hp_bar.dart';

/// Ce que le pavé applique.
enum KeypadMode { damage, heal, tempHp }

/// Type de dégâts par défaut, tant que le MJ n'en choisit pas.
const _defaultType = 'srd:damage-type:slashing';

/// Ouvre le pavé sur [targets] de [encounter], en [mode].
Future<void> showDamageKeypad(
  BuildContext context,
  Encounter encounter,
  Set<String> targets,
  KeypadMode mode,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => SafeArea(
    child: SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.92,
      child: DamageKeypad(encounter: encounter, targets: targets, mode: mode),
    ),
  ),
);

class DamageKeypad extends ConsumerStatefulWidget {
  const DamageKeypad({
    super.key,
    required this.encounter,
    required this.targets,
    required this.mode,
  });

  final Encounter encounter;
  final Set<String> targets;
  final KeypadMode mode;

  @override
  ConsumerState<DamageKeypad> createState() => _DamageKeypadState();
}

class _DamageKeypadState extends ConsumerState<DamageKeypad> {
  late final Set<String> _targets = {...widget.targets};
  late KeypadMode _mode = widget.mode;

  /// Termes saisis, et leur signe : « 7 + 5 − 2 ».
  final _terms = <int>[0];
  final _signs = <int>[1];
  var _type = _defaultType;
  var _critical = false;
  var _half = false;
  var _double = false;
  var _replace = false;
  var _knockOut = false;

  int get _amount {
    var total = 0;
    for (var i = 0; i < _terms.length; i++) {
      total += _signs[i] * _terms[i];
    }
    return total.clamp(0, 9999);
  }

  void _digit(int d) => setState(() {
    final next = _terms.last * 10 + d;
    if (next <= 9999) _terms[_terms.length - 1] = next;
  });

  void _operator({required bool minus}) => setState(() {
    if (_terms.last == 0) {
      _signs[_signs.length - 1] = minus ? -1 : 1;
    } else {
      _terms.add(0);
      _signs.add(minus ? -1 : 1);
    }
  });

  void _erase() => setState(() {
    if (_terms.last != 0) {
      _terms[_terms.length - 1] = _terms.last ~/ 10;
    } else if (_terms.length > 1) {
      _terms.removeLast();
      _signs.removeLast();
    }
  });

  Future<void> _apply({required bool knockOut}) async {
    final targets = _targets.toList();
    final amount = _amount;
    await appendCombat(ref, widget.encounter.id, [
      switch (_mode) {
        KeypadMode.damage => (
          CombatEventType.damage,
          {
            'targets': targets,
            'amount': amount,
            'type': _type,
            'critical': _critical,
            'half': _half,
            'double': _double,
            if (knockOut) 'knock_out': true,
          },
        ),
        KeypadMode.heal => (
          CombatEventType.heal,
          {'targets': targets, 'amount': amount},
        ),
        KeypadMode.tempHp => (
          CombatEventType.tempHp,
          {'targets': targets, 'amount': amount, 'replace': _replace},
        ),
      },
    ]);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final colors = GameColors.of(context);
    final combat = ref.watch(combatStateProvider(widget.encounter.id)).value;
    final content = ref.watch(contentProvider).value;
    if (combat == null || content == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final targets = [for (final id in _targets) ?combat.combatant(id)];
    final types = sortedEntities(content, 'damage-type');
    final typeName = namesOf(content, [_type]);
    final amount = _amount;
    final color = switch (_mode) {
      KeypadMode.damage => colors.damage,
      KeypadMode.heal => colors.heal,
      KeypadMode.tempHp => colors.tempHp,
    };
    final single = targets.length == 1 && _mode == KeypadMode.damage
        ? targets.single
        : null;
    final hit = single == null || single.hp == null
        ? null
        : resolveDamage(single, amount, _type, half: _half, double: _double);
    final dies = hit != null && instantDeath(single!, hit);
    // Cible unique qui tomberait à 0 PV sans mourir : Assommer (EF-PV-06).
    final falls = hit != null && !dies && hit.hpBefore > 0 && hit.hpAfter == 0
        ? single
        : null;
    final knockOut = _knockOut && falls != null;
    final apply = switch (_mode) {
      KeypadMode.damage when dies => l10n.keypadApplyDies(single.label),
      KeypadMode.damage when knockOut => l10n.keypadApplyKnockOut(falls.label),
      KeypadMode.damage => l10n.keypadApplyDamage(
        amount,
        typeName.toLowerCase(),
      ),
      KeypadMode.heal => l10n.keypadApplyHeal(amount),
      KeypadMode.tempHp => l10n.keypadApplyTemp(amount),
    };

    Widget key(String label, VoidCallback onTap, {bool selected = false}) =>
        SizedBox(
          height: 52,
          child: selected
              ? FilledButton.tonal(onPressed: onTap, child: _fit(label))
              : OutlinedButton(onPressed: onTap, child: _fit(label)),
        );

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(switch (_mode) {
                KeypadMode.damage => l10n.combatDamage,
                KeypadMode.heal => l10n.combatHeal,
                KeypadMode.tempHp => l10n.combatTempHp,
              }, style: text.headlineSmall),
            ),
            CloseButton(onPressed: () => Navigator.pop(context)),
          ],
        ),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(l10n.keypadTargets, style: text.labelMedium),
            for (final c in targets)
              InputChip(
                label: Text(c.label),
                onDeleted: _targets.length > 1
                    ? () => setState(() => _targets.remove(c.id))
                    : null,
              ),
            ActionChip(
              avatar: const Icon(Icons.add, size: 18),
              label: Text(l10n.keypadAddTarget),
              onPressed: () async {
                final id = await showModalBottomSheet<String>(
                  context: context,
                  builder: (sheet) => SafeArea(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (final c in combat.combatants)
                          if (!_targets.contains(c.id))
                            ListTile(
                              title: Text(c.label),
                              onTap: () => Navigator.pop(sheet, c.id),
                            ),
                      ],
                    ),
                  ),
                );
                if (id != null) setState(() => _targets.add(id));
              },
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('$amount', style: text.displayLarge!.copyWith(color: color)),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                [
                  if (_mode == KeypadMode.damage) typeName.toLowerCase(),
                  if (_terms.length > 1)
                    [
                      for (var i = 0; i < _terms.length; i++)
                        '${_signs[i] < 0 ? '−' : '+'} ${_terms[i]}',
                    ].join(' '),
                ].join('  '),
                style: text.titleMedium,
              ),
            ),
            IconButton(
              tooltip: l10n.keypadErase,
              icon: const Icon(Icons.backspace_outlined),
              onPressed: _erase,
            ),
          ],
        ),
        if (_mode == KeypadMode.damage)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final t in types)
                  Padding(
                    padding: EdgeInsets.only(right: AppSpacing.xs),
                    child: ChoiceChip(
                      label: Text(t.name),
                      selected: '${t.id}' == _type,
                      onSelected: (_) => setState(() => _type = '${t.id}'),
                    ),
                  ),
              ],
            ),
          ),
        SizedBox(height: AppSpacing.sm),
        for (final c in targets)
          _Preview(
            combatant: c,
            mode: _mode,
            amount: amount,
            type: _type,
            half: _half,
            double: _double,
            replace: _replace,
            concentrationEnd: c.concentration == null
                ? null
                : concentrationConsequence(l10n, content, combat, c),
          ),
        if (falls case final c?)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.keypadKnockOut),
            subtitle: Text(l10n.keypadKnockOutHelp(c.label)),
            value: _knockOut,
            onChanged: (v) => setState(() => _knockOut = v),
          ),
        if (_mode == KeypadMode.damage)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.keypadCritical),
            subtitle: Text(l10n.keypadCriticalHelp),
            value: _critical,
            onChanged: (v) => setState(() => _critical = v),
          ),
        if (_mode == KeypadMode.tempHp)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.keypadReplaceTemp),
            subtitle: Text(l10n.keypadReplaceTempHelp),
            value: _replace,
            onChanged: (v) => setState(() => _replace = v),
          ),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.xs,
          crossAxisSpacing: AppSpacing.xs,
          childAspectRatio: 1.6,
          children: [
            for (final d in [7, 8, 9]) key('$d', () => _digit(d)),
            key(
              l10n.keypadDouble,
              () => setState(() => _double = !_double),
              selected: _double,
            ),
            for (final d in [4, 5, 6]) key('$d', () => _digit(d)),
            key(
              l10n.keypadHalf,
              () => setState(() => _half = !_half),
              selected: _half,
            ),
            for (final d in [1, 2, 3]) key('$d', () => _digit(d)),
            key(
              l10n.combatTempHp,
              () => setState(
                () => _mode = _mode == KeypadMode.tempHp
                    ? KeypadMode.damage
                    : KeypadMode.tempHp,
              ),
              selected: _mode == KeypadMode.tempHp,
            ),
            key('0', () => _digit(0)),
            key('+', () => _operator(minus: false)),
            key('−', () => _operator(minus: true)),
            key(
              l10n.combatHeal,
              () => setState(
                () => _mode = _mode == KeypadMode.heal
                    ? KeypadMode.damage
                    : KeypadMode.heal,
              ),
              selected: _mode == KeypadMode.heal,
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 56,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: color,
              foregroundColor: scheme.surface,
            ),
            onPressed: amount > 0 && targets.isNotEmpty
                ? () => _apply(knockOut: knockOut)
                : null,
            icon: const Icon(Icons.check),
            label: Text(apply),
          ),
        ),
        SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

/// Libellé de touche réduit pour tenir sur un écran étroit.
Widget _fit(String label) =>
    FittedBox(fit: BoxFit.scaleDown, child: Text(label, maxLines: 1));

/// Aperçu d'une cible : PV avant → après, portion perdue sur la barre.
class _Preview extends StatelessWidget {
  const _Preview({
    required this.combatant,
    required this.mode,
    required this.amount,
    required this.type,
    required this.half,
    required this.double,
    required this.replace,
    required this.concentrationEnd,
  });

  final Combatant combatant;
  final KeypadMode mode;
  final int amount;
  final String type;
  final bool half;
  final bool double;
  final bool replace;

  /// Ce que la fin de sa concentration retire ; `null` sans concentration.
  final String? concentrationEnd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final c = combatant;
    final hp = c.hp;
    final max = c.hpMax;
    if (hp == null || max == null) return const SizedBox.shrink();
    final damage = mode == KeypadMode.damage
        ? resolveDamage(c, amount, type, half: half, double: double)
        : null;
    final after = switch (mode) {
      KeypadMode.damage => damage!.hpAfter,
      KeypadMode.heal => c.dead ? hp : (hp + amount).clamp(0, max),
      KeypadMode.tempHp => hp,
    };
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.xs),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(c.label, style: text.titleSmall)),
                Text(
                  mode == KeypadMode.tempHp
                      ? l10n.keypadTempPreview(
                          c.tempHp,
                          replace || amount > c.tempHp ? amount : c.tempHp,
                        )
                      : l10n.keypadPreview(hp, after, max),
                  style: text.titleSmall,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xxs),
            HpBar(hp: after, max: max, before: hp),
            if (damage != null && instantDeath(c, damage))
              Text(
                damage.hpBefore == 0
                    ? l10n.keypadDeathAtZero(damageExcess(damage), max)
                    : l10n.keypadInstantDeath(damageExcess(damage), max),
                style: text.bodyMedium!.copyWith(color: scheme.error),
              ),
            if (damage != null && damage.taken > 0)
              if (concentrationEnd case final end?)
                Text(
                  after == 0
                      ? l10n.keypadConcentrationEnds(end)
                      : l10n.keypadConcentration(concentrationDc(damage.taken)),
                  style: text.bodySmall,
                ),
          ],
        ),
      ),
    );
  }
}
