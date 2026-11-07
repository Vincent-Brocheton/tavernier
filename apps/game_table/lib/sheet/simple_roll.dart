import 'dart:math';

import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';

/// Jet simple [J6] : « Saisir mon jet » ou « Lancer », détail du jet, résultat
/// des dés modifiable avant validation (EF-DES-01 à 03).
class SimpleRoll extends StatefulWidget {
  const SimpleRoll({
    super.key,
    required this.formula,
    required this.onChanged,
    this.bonusLabel,
    this.random,
  });

  final DiceFormula formula;

  /// Résultat des dés s'il est possible, sinon `null`.
  final ValueChanged<int?> onChanged;

  /// Origine du bonus, affichée après lui (« CON »).
  final String? bonusLabel;

  /// Hasard des tests ; par défaut, celui du système.
  final Random? random;

  @override
  State<SimpleRoll> createState() => _SimpleRollState();
}

class _SimpleRollState extends State<SimpleRoll> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  late final Random _random = widget.random ?? Random();
  DiceRoll? _roll;

  DiceFormula get _formula => widget.formula;

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _changed() {
    final value = int.tryParse(_controller.text);
    widget.onChanged(value != null && _formula.validDice(value) ? value : null);
  }

  void _launch() {
    final roll = rollDice(_formula, _random);
    setState(() {
      _roll = roll;
      _controller.text = '${roll.diceTotal}';
    });
    _changed();
  }

  /// « d20 8 + 3 = 11 », « 2d4 (3, 2) + 2 = 7 », dé écarté barré.
  InlineSpan _detail(int dice, TextStyle style) {
    final roll = _roll;
    final rolled = roll != null && roll.diceTotal == dice;
    final bonus = _formula.bonus;
    final label = widget.bonusLabel == null ? '' : ' ${widget.bonusLabel}';
    return TextSpan(
      style: style,
      children: [
        TextSpan(text: '${_formula.dice} '),
        if (rolled && roll.dropped != null) ...[
          TextSpan(text: '$dice ('),
          TextSpan(
            text: '${roll.dropped}',
            style: const TextStyle(decoration: TextDecoration.lineThrough),
          ),
          const TextSpan(text: ')'),
        ] else if (rolled && roll.dice.length > 1)
          TextSpan(text: '(${roll.dice.join(', ')})')
        else
          TextSpan(text: '$dice'),
        if (bonus != 0)
          TextSpan(text: ' ${bonus > 0 ? '+' : '−'} ${bonus.abs()}$label'),
        TextSpan(text: ' = ${dice + bonus}'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final value = int.tryParse(_controller.text);
    final valid = value != null && _formula.validDice(value);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            OutlinedButton(
              onPressed: _focus.requestFocus,
              child: Text(l10n.enterRoll),
            ),
            OutlinedButton(
              onPressed: _launch,
              child: Text(_roll == null ? l10n.castSpell : l10n.reroll),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.xs),
        TextField(
          controller: _controller,
          focusNode: _focus,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.rollResultOf(_formula.dice),
            errorText: value != null && !valid
                ? l10n.rollImpossible(_formula.dice)
                : null,
          ),
          onChanged: (_) {
            setState(() {});
            _changed();
          },
        ),
        if (valid) ...[
          SizedBox(height: AppSpacing.xxs),
          Text.rich(_detail(value, text.bodyMedium!)),
        ],
      ],
    );
  }
}
