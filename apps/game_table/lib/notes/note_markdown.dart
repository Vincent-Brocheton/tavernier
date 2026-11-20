// Markdown réduit des notes (US-26, EF-NOT-01) : `**gras**`, lignes `- `
// pour les listes, liens `[Varga](npc:<id>)` et `[Le relais](encounter:<id>)`.
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:material_ui/material_ui.dart';

final _inline = RegExp(
  r'\*\*(.+?)\*\*|\[([^\]]+)\]\((npc|encounter):([^)]+)\)',
);

/// Texte brut d'une note, pour un extrait ou une recherche.
String notePlainText(String markdown) => markdown
    .split('\n')
    .map((l) => l.startsWith('- ') ? l.substring(2) : l)
    .join(' ')
    .replaceAllMapped(_inline, (m) => m.group(1) ?? m.group(2)!)
    .trim();

/// Lien interne d'une note : `npc` ou `encounter`, et l'identifiant visé.
typedef NoteLink = ({String kind, String id});

/// Texte d'une note en Markdown réduit ; [onLink] rend les liens actifs.
class NoteText extends StatelessWidget {
  const NoteText(this.markdown, {super.key, this.onLink});

  final String markdown;
  final ValueChanged<NoteLink>? onLink;

  List<InlineSpan> _spans(BuildContext context, String line) {
    final link = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      decoration: TextDecoration.underline,
    );
    final spans = <InlineSpan>[];
    var at = 0;
    for (final m in _inline.allMatches(line)) {
      if (m.start > at) spans.add(TextSpan(text: line.substring(at, m.start)));
      if (m.group(1) case final bold?) {
        spans.add(
          TextSpan(
            text: bold,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      } else {
        final target = (kind: m.group(3)!, id: m.group(4)!);
        spans.add(
          TextSpan(
            text: m.group(2),
            style: link,
            recognizer: onLink == null
                ? null
                : (TapGestureRecognizer()..onTap = () => onLink!(target)),
          ),
        );
      }
      at = m.end;
    }
    if (at < line.length) spans.add(TextSpan(text: line.substring(at)));
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final line in markdown.split('\n'))
          if (line.startsWith('- '))
            Padding(
              padding: EdgeInsets.only(left: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  ', style: style),
                  Expanded(
                    child: Text.rich(
                      TextSpan(children: _spans(context, line.substring(2))),
                      style: style,
                    ),
                  ),
                ],
              ),
            )
          else
            Text.rich(TextSpan(children: _spans(context, line)), style: style),
      ],
    );
  }
}
