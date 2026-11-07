import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/step_layout.dart';
import '../creation/subchoices.dart';
import '../l10n/app_localizations.dart';
import 'combat_tab.dart';
import 'rest_sheet.dart';
import 'sheet_features.dart';

enum _Filter { all, withUses, feats }

/// Onglet Aptitudes [F2].
class FeaturesTab extends StatefulWidget {
  const FeaturesTab({
    super.key,
    required this.id,
    required this.content,
    required this.character,
    required this.sheet,
  });

  final String id;
  final ActiveContent content;
  final CharacterInput character;
  final ComputedSheet sheet;

  @override
  State<FeaturesTab> createState() => _FeaturesTabState();
}

class _FeaturesTabState extends State<FeaturesTab> {
  _Filter _filter = _Filter.all;

  bool _shown(FeatureGroup group, SheetFeature feature) => switch (_filter) {
    _Filter.all => true,
    _Filter.withUses => feature.resource != null,
    _Filter.feats => group.feats,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final content = widget.content;
    final groups = featureGroups(widget.character, widget.sheet, content);
    return ListView(
      padding: EdgeInsets.all(AppSpacing.md),
      children: [
        Wrap(
          spacing: AppSpacing.xs,
          children: [
            for (final (filter, label) in [
              (_Filter.all, l10n.filterAll),
              (_Filter.withUses, l10n.filterWithUses),
              (_Filter.feats, l10n.filterFeats),
            ])
              ChoiceChip(
                label: Text(label),
                selected: _filter == filter,
                onSelected: (_) => setState(() => _filter = filter),
              ),
          ],
        ),
        for (final group in groups)
          if (group.features.any((f) => _shown(group, f))) ...[
            SizedBox(height: AppSpacing.sm),
            Text(switch (group) {
              (feats: true, sourceId: _, level: _, features: _) =>
                l10n.filterFeats,
              (
                level: final int level,
                sourceId: final id,
                feats: _,
                features: _,
              ) =>
                l10n.classLevel(namesOf(content, [id]), level),
              _ => namesOf(content, [group.sourceId]),
            }, style: text.labelLarge),
            for (final feature in group.features)
              if (_shown(group, feature))
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(feature.entity.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(firstSentence(feature.entity.textFr ?? '')),
                      if (feature.resource case final resource?)
                        ResourceTracker(
                          id: widget.id,
                          resource: resource,
                          label: rechargeLabel(l10n, resource.recharge),
                        ),
                    ],
                  ),
                ),
          ],
      ],
    );
  }
}
