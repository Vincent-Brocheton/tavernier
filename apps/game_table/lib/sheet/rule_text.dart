import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';

/// Termes d'un contenu, repérés par leur nom.
final class _Terms {
  _Terms(ActiveContent content) {
    for (final entity in content.entities) {
      if (entity.type != 'rule' && entity.type != 'condition') continue;
      _byName[entity.name] = entity;
      // « action Bonus » : un nom composé se trouve aussi en milieu de phrase.
      if (entity.name.contains(' ')) {
        final lower =
            '${entity.name[0].toLowerCase()}'
            '${entity.name.substring(1)}';
        _byName[lower] = entity;
      }
    }
    final names = _byName.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    pattern = RegExp(
      '(?<![\\p{L}])(${names.map(RegExp.escape).join('|')})(?![\\p{L}])',
      unicode: true,
    );
  }

  final _byName = <String, ContentEntity>{};
  late final RegExp pattern;

  ContentEntity entityOf(String name) => _byName[name]!;
}

final _terms = Expando<_Terms>();

_Terms _termsOf(ActiveContent content) => _terms[content] ??= _Terms(content);

/// Texte dont les termes de règles ouvrent leur définition [J13].
class RuleText extends StatelessWidget {
  const RuleText(this.text, {super.key, required this.content, this.style});

  final String text;
  final ActiveContent content;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final terms = _termsOf(content);
    final base = style ?? DefaultTextStyle.of(context).style;
    final spans = <InlineSpan>[];
    var start = 0;
    for (final match in terms.pattern.allMatches(text)) {
      spans
        ..add(TextSpan(text: text.substring(start, match.start)))
        ..add(
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: _Term(
              label: match.group(0)!,
              entity: terms.entityOf(match.group(0)!),
              style: base,
            ),
          ),
        );
      start = match.end;
    }
    spans.add(TextSpan(text: text.substring(start)));
    return Text.rich(TextSpan(style: base, children: spans));
  }
}

class _Term extends StatelessWidget {
  const _Term({required this.label, required this.entity, required this.style});

  final String label;
  final ContentEntity entity;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      link: true,
      label: l10n.ruleTermLabel(entity.name),
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => showAdaptiveSheet(context, _TermSheet(entity: entity)),
        child: Text(
          label,
          style: style.copyWith(
            decoration: TextDecoration.underline,
            decorationStyle: TextDecorationStyle.dotted,
          ),
        ),
      ),
    );
  }
}

/// Définition d'un terme, sans quitter la fiche.
class _TermSheet extends StatelessWidget {
  const _TermSheet({required this.entity});

  final ContentEntity entity;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(entity.name, style: text.headlineSmall),
          SizedBox(height: AppSpacing.xs),
          Text(entity.textFr ?? '', style: text.bodyMedium),
          SizedBox(height: AppSpacing.xs),
          Text(l10n.ruleTermSource, style: text.bodySmall),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.close),
            ),
          ),
        ],
      ),
    );
  }
}
