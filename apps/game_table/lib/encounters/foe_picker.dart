// Ajout d'adversaires à une rencontre (US-19, EF-REN-02, [C1]) : monstres
// des packs actifs et PNJ de la table, recherche et filtre de FP.
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import '../npcs/npcs_providers.dart';
import 'encounters_providers.dart';

/// Valeur d'un FP pour le trier : « 1/8 » vaut 0,125.
double crValue(String cr) => switch (cr.split('/')) {
  [final a, final b] => int.parse(a) / int.parse(b),
  _ => double.tryParse(cr) ?? 0,
};

class FoePicker extends ConsumerStatefulWidget {
  const FoePicker({
    super.key,
    required this.tableId,
    required this.encounterId,
  });

  final String tableId;
  final String encounterId;

  @override
  ConsumerState<FoePicker> createState() => _FoePickerState();
}

class _FoePickerState extends ConsumerState<FoePicker> {
  var _query = '';
  var _npcs = false;

  /// FP retenus, en indices dans la liste des FP ; `null` : tous.
  RangeValues? _range;

  Future<void> _add(String kind, String refId) => ref
      .read(encounterStoreProvider)
      .addGroup(widget.encounterId, kind: kind, refId: refId);

  Future<void> _chooseRange(List<String> crs) async {
    var range = _range ?? RangeValues(0, (crs.length - 1).toDouble());
    final l10n = AppLocalizations.of(context);
    final chosen = await showModalBottomSheet<RangeValues?>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheet) => SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.encounterCrRange(
                    crs[range.start.round()],
                    crs[range.end.round()],
                  ),
                ),
                RangeSlider(
                  values: range,
                  max: (crs.length - 1).toDouble(),
                  divisions: crs.length - 1,
                  onChanged: (v) => setSheet(() => range = v),
                ),
                OverflowBar(
                  alignment: MainAxisAlignment.end,
                  spacing: AppSpacing.sm,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.encounterCrAll),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, range),
                      child: Text(l10n.hiddenInfoSave),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    setState(() => _range = chosen);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final content = ref.watch(contentProvider).value;
    final npcs = ref.watch(tableNpcsProvider(widget.tableId)).value;
    if (content == null || npcs == null) {
      return const Center(child: CircularProgressIndicator());
    }
    // Copie : la liste triée du contenu est partagée.
    final monsters = [...sortedEntities(content, 'monster')]
      ..sort(
        (a, b) =>
            crValue((a.data as MonsterData).cr)
                .compareTo(crValue((b.data as MonsterData).cr)),
      );
    final crs = {for (final m in monsters) (m.data as MonsterData).cr}.toList();
    final range = _range;
    bool inRange(String? cr) =>
        range == null ||
        (cr != null &&
            crValue(cr) >= crValue(crs[range.start.round()]) &&
            crValue(cr) <= crValue(crs[range.end.round()]));
    final query = foldAccents(_query.trim());
    Widget addButton(String name, String kind, String refId) =>
        IconButton.filledTonal(
          tooltip: l10n.encounterAddNamed(name),
          icon: const Icon(Icons.add),
          onPressed: () => _add(kind, refId),
        );
    final rows = _npcs
        ? [
            for (final npc in npcs)
              if (foldAccents(npc.name).contains(query))
                if (monsterOf(content, npc.monsterId) case final monster?
                    when inRange(monster.cr))
                  ListTile(
                    title: Text(npc.name),
                    subtitle: Text(
                      l10n.encounterMonsterLine(
                        content.entity(npc.monsterId!)!.name,
                        monster.cr,
                        formatThousands(monster.xp),
                      ),
                    ),
                    trailing: addButton(npc.name, 'npc', npc.id),
                  )
                else if (npc.characterId != null && range == null)
                  ListTile(
                    title: Text(npc.name),
                    subtitle: Text(l10n.npcFullSheet),
                    trailing: addButton(npc.name, 'npc', npc.id),
                  ),
          ]
        : [
            // ponytail: 50 lignes après filtre, la recherche affine.
            for (final m
                in monsters
                    .where(
                      (m) =>
                          foldAccents(m.name).contains(query) &&
                          inRange((m.data as MonsterData).cr),
                    )
                    .take(50))
              ListTile(
                title: Text(m.name),
                subtitle: Text(
                  l10n.encounterMonsterLine(
                    l10n.creatureType(
                      (m.data as MonsterData).creatureType.name,
                    ),
                    (m.data as MonsterData).cr,
                    formatThousands((m.data as MonsterData).xp),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    sourceBadgeOf(l10n, content, '${m.id}'),
                    SizedBox(width: AppSpacing.xs),
                    addButton(m.name, 'monster', '${m.id}'),
                  ],
                ),
              ),
          ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: l10n.encounterPickerSearch,
            prefixIcon: const Icon(Icons.search),
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            ChoiceChip(
              label: Text(l10n.encounterPickerMonsters),
              selected: !_npcs,
              onSelected: (_) => setState(() => _npcs = false),
            ),
            ChoiceChip(
              label: Text(l10n.tabNpcs),
              selected: _npcs,
              onSelected: (_) => setState(() => _npcs = true),
            ),
            ActionChip(
              label: Text(
                range == null
                    ? l10n.encounterCrAll
                    : l10n.encounterCrRange(
                        crs[range.start.round()],
                        crs[range.end.round()],
                      ),
              ),
              onPressed: () => _chooseRange(crs),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.xs),
        if (rows.isEmpty)
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Text(l10n.encounterEmpty, style: text.bodyMedium),
          ),
        ...rows,
      ],
    );
  }
}
