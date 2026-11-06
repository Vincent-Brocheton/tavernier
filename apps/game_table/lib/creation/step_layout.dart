import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';

/// Disposition d'une étape : sur grand écran, la liste à gauche et le détail
/// du choix dans un panneau à droite ; sur téléphone, le détail s'ouvre dans
/// la carte sélectionnée et [detail] n'est pas affiché.
class StepLayout extends StatelessWidget {
  const StepLayout({super.key, required this.list, this.detail});

  final Widget list;
  final Widget? detail;

  @override
  Widget build(BuildContext context) {
    final phone =
        formFactorOf(MediaQuery.sizeOf(context).width) == FormFactor.phone;
    final panel = detail;
    if (phone || panel == null) return SingleChildScrollView(child: list);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: SingleChildScrollView(child: list)),
        SizedBox(width: AppSpacing.lg),
        SizedBox(
          width: 300,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadii.lg),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: panel,
            ),
          ),
        ),
      ],
    );
  }
}

/// Grille de cartes : autant de colonnes que la largeur en permet.
class CardGrid extends StatelessWidget {
  const CardGrid({super.key, required this.children, this.minWidth = 230});

  final List<Widget> children;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = AppSpacing.sm;
        final columns = ((constraints.maxWidth + gap) / (minWidth + gap))
            .floor()
            .clamp(1, 3);
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final child in children) SizedBox(width: width, child: child),
          ],
        );
      },
    );
  }
}

/// Ligne « libellé / valeur » d'un panneau de détail.
class DetailRow extends StatelessWidget {
  const DetailRow(this.label, this.value, {super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 4, child: Text(label, style: text.bodySmall)),
          SizedBox(width: AppSpacing.xs),
          Expanded(flex: 5, child: Text(value, style: text.bodyMedium)),
        ],
      ),
    );
  }
}

/// Titre de section d'un panneau de détail.
class DetailHeading extends StatelessWidget {
  const DetailHeading(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xxs),
    child: Text(label, style: Theme.of(context).textTheme.labelLarge),
  );
}

/// Badge de la source d'une entité : SRD ou nom du pack homebrew.
Widget sourceBadgeOf(AppLocalizations l10n, ActiveContent content, String id) {
  final namespace = id.split(':').first;
  if (namespace == 'srd') return SourceBadge(l10n.sourceSrd);
  final pack = content.packs.firstWhere(
    (p) => p.manifest.namespace == namespace,
  );
  return SourceBadge(pack.manifest.name, homebrew: true);
}

/// Entités de type [type], dans l'ordre alphabétique français : Rôdeur avant
/// Roublard, les accents ne comptent pas.
List<ContentEntity> sortedEntities(ActiveContent content, String type) {
  const accents = {
    'à': 'a',
    'â': 'a',
    'ä': 'a',
    'ç': 'c',
    'é': 'e',
    'è': 'e',
    'ê': 'e',
    'ë': 'e',
    'î': 'i',
    'ï': 'i',
    'ô': 'o',
    'ö': 'o',
    'ù': 'u',
    'û': 'u',
    'ü': 'u',
  };
  String key(ContentEntity e) =>
      e.name.toLowerCase().split('').map((c) => accents[c] ?? c).join();
  return content.entities.where((e) => e.type == type).toList()
    ..sort((a, b) => key(a).compareTo(key(b)));
}

/// Noms des entités [ids] du contenu, joints par [separator].
String namesOf(
  ActiveContent content,
  Iterable<Object> ids, {
  String separator = ', ',
}) => ids.map((id) => content.entity('$id')?.name ?? '$id').join(separator);
