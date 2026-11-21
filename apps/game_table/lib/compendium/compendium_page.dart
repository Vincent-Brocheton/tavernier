// Compendium (US-30 lot c1, EF-CMP-01, [K1], [K2], [K5]) : recherche hors
// ligne parmi les packs actifs d'une table, ou parmi tous mes packs ; les
// entités bannies restent consultables, marquées « BANNI ».
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../creation/step_layout.dart' show foldAccents;
import '../homebrew/homebrew_page.dart' show typeLabel;
import '../homebrew/import_page.dart' show importedPacksProvider;
import '../l10n/app_localizations.dart';
import '../npcs/stat_block_view.dart';
import '../tables/tables_providers.dart';

/// Filtres de [K1] : un libellé et les types d'entités qu'il couvre.
enum CompendiumFilter { all, spells, feats, items, monsters, conditions }

const _types = {
  CompendiumFilter.spells: {'spell'},
  CompendiumFilter.feats: {'feat'},
  CompendiumFilter.items: {'weapon', 'armor', 'magic-item', 'item', 'tool'},
  CompendiumFilter.monsters: {'monster'},
  CompendiumFilter.conditions: {'condition'},
};

/// Types cherchés par « Tout » : ceux des filtres, et les origines et
/// classes d'un personnage.
final _allTypes = {
  for (final types in _types.values) ...types,
  'species',
  'background',
  'class',
  'subclass',
};

/// Une entité et le pack qui l'apporte.
typedef CompendiumEntry = ({ContentEntity entity, PackManifest pack});

/// Entrées des [packs], sans doublon d'identifiant (le dernier pack gagne).
List<CompendiumEntry> compendiumEntries(Iterable<ContentPack> packs) => {
  for (final p in packs)
    for (final e in p.entities)
      if (_allTypes.contains(e.type)) '${e.id}': (entity: e, pack: p.manifest),
}.values.toList();

/// Entrées de [entries] dont le nom contient [query] (sans accents ni
/// casse), pour [filter], triées par nom.
List<CompendiumEntry> searchCompendium(
  List<CompendiumEntry> entries,
  String query,
  CompendiumFilter filter,
) {
  final q = foldAccents(query.trim());
  if (q.isEmpty) return const [];
  return [
    for (final e in entries)
      if ((filter == CompendiumFilter.all ||
              _types[filter]!.contains(e.entity.type)) &&
          foldAccents(e.entity.name).contains(q))
        e,
  ]..sort(
    (a, b) => foldAccents(a.entity.name).compareTo(foldAccents(b.entity.name)),
  );
}

/// Distance d'édition entre deux chaînes (Levenshtein).
int editDistance(String a, String b) {
  var previous = List<int>.generate(b.length + 1, (i) => i);
  for (var i = 1; i <= a.length; i++) {
    final current = [i, ...List<int>.filled(b.length, 0)];
    for (var j = 1; j <= b.length; j++) {
      current[j] = [
        previous[j] + 1,
        current[j - 1] + 1,
        previous[j - 1] + (a[i - 1] == b[j - 1] ? 0 : 1),
      ].reduce((x, y) => x < y ? x : y);
    }
    previous = current;
  }
  return previous[b.length];
}

/// « Vouliez-vous dire » ([K5]) : les noms les plus proches de [query].
List<CompendiumEntry> suggestions(List<CompendiumEntry> entries, String query) {
  final q = foldAccents(query.trim());
  if (q.length < 3) return const [];
  final scored = [
    for (final e in entries) (e, editDistance(q, foldAccents(e.entity.name))),
  ]..sort((a, b) => a.$2.compareTo(b.$2));
  final limit = q.length < 6 ? 2 : 3;
  return [
    for (final (e, d) in scored.take(3))
      if (d <= limit) e,
  ];
}

/// Badge de source : « SRD », ou « {auteur} {version} ».
String sourceBadge(PackManifest pack) =>
    pack.origin == PackOrigin.srd ? 'SRD' : '${pack.author} ${pack.version}';

String _school(AppLocalizations l10n, SpellSchool school) => switch (school) {
  SpellSchool.abjuration => l10n.schoolAbjuration,
  SpellSchool.conjuration => l10n.schoolConjuration,
  SpellSchool.divination => l10n.schoolDivination,
  SpellSchool.enchantment => l10n.schoolEnchantment,
  SpellSchool.evocation => l10n.schoolEvocation,
  SpellSchool.illusion => l10n.schoolIllusion,
  SpellSchool.necromancy => l10n.schoolNecromancy,
  SpellSchool.transmutation => l10n.schoolTransmutation,
};

/// Résumé d'une entité sous son nom ([K1]).
String entrySummary(AppLocalizations l10n, ContentEntity e) => switch (e.data) {
  SpellData(:final level, :final school, :final concentration) => [
    typeLabel(l10n, e.type),
    if (level == 0)
      l10n.cantripOf(_school(l10n, school))
    else
      l10n.spellOfLevel(_school(l10n, school), l10n.spellLevelName(level)),
    if (concentration) l10n.compendiumConcentration,
  ].join(' · '),
  MonsterData(:final creatureType, :final cr, :final xp) => [
    typeLabel(l10n, e.type),
    l10n.creatureType(creatureType.name),
    l10n.compendiumCr(cr, xp),
  ].join(' · '),
  _ => switch (e.type) {
    'condition' => l10n.compendiumCondition,
    _ => typeLabel(l10n, e.type),
  },
};

class CompendiumPage extends ConsumerStatefulWidget {
  const CompendiumPage({super.key});

  @override
  ConsumerState<CompendiumPage> createState() => _CompendiumPageState();
}

class _CompendiumPageState extends ConsumerState<CompendiumPage> {
  String? _tableId;
  bool _all = false;
  String _query = '';
  CompendiumFilter _filter = CompendiumFilter.all;

  /// Tout le contenu de mes packs, pour nommer ce que cite une fiche.
  ActiveContent _content = ActiveContent(const []);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final srd = ref.watch(srdPackProvider).value;
    if (srd == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final tables = [
      for (final t
          in ref.watch(myTablesProvider).value ?? const <TableSummary>[])
        if (!t.archived) t,
    ];
    final table =
        tables.where((t) => t.id == _tableId).firstOrNull ?? tables.firstOrNull;
    final all = _all || table == null;
    final active = {
      srd.manifest.id,
      for (final p
          in ref.watch(activePacksProvider).value ?? const <ActivePack>[])
        if (p.tableId == table?.id) p.packId,
    };
    // Mes packs : le SRD, puis la dernière version de chaque pack gardé.
    final latest = <String, ContentPack>{};
    final versions = [...?ref.watch(importedPacksProvider).value]
      ..sort((a, b) => compareVersions(a.version, b.version));
    for (final v in versions) {
      latest[v.packId] = v.pack;
    }
    final mine = [srd, ...latest.values];
    final scope = [
      for (final p in mine)
        if (all || active.contains(p.manifest.id)) p,
    ];
    final banned = table == null
        ? const <String>{}
        : ref.watch(bannedProvider(table.id)).value ?? const <String>{};

    _content = ActiveContent(mine);
    final entries = compendiumEntries(scope);
    final results = searchCompendium(entries, _query, _filter);
    final inactive = all
        ? const <CompendiumEntry>[]
        : searchCompendium(
            compendiumEntries([
              for (final p in mine)
                if (!active.contains(p.manifest.id)) p,
            ]),
            _query,
            _filter,
          );
    int count(CompendiumFilter f) =>
        searchCompendium(entries, _query, f).length;

    return ListView(
      padding: EdgeInsets.all(AppSpacing.md),
      children: [
        Text(l10n.navCompendium, style: text.headlineSmall),
        SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<String?>(
          initialValue: all ? null : table.id,
          isExpanded: true,
          decoration: InputDecoration(labelText: l10n.compendiumContext),
          items: [
            for (final t in tables)
              DropdownMenuItem(value: t.id, child: Text(t.settings.name)),
            DropdownMenuItem(child: Text(l10n.compendiumAllPacks)),
          ],
          onChanged: (v) => setState(() {
            _all = v == null;
            _tableId = v ?? _tableId;
          }),
        ),
        Text(
          l10n.compendiumScope(
            all ? l10n.compendiumAllPacks : table.settings.name,
            [for (final p in scope) p.manifest.name].join(', '),
          ),
          style: text.bodySmall,
        ),
        SizedBox(height: AppSpacing.sm),
        TextField(
          decoration: InputDecoration(
            labelText: l10n.compendiumSearch,
            prefixIcon: const Icon(Icons.search),
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: [
            for (final f in CompendiumFilter.values)
              ChoiceChip(
                label: Text(
                  _query.trim().isEmpty
                      ? _filterLabel(l10n, f)
                      : '${_filterLabel(l10n, f)} ${count(f)}',
                ),
                selected: _filter == f,
                onSelected: (_) => setState(() => _filter = f),
              ),
          ],
        ),
        Text(l10n.compendiumOffline, style: text.bodySmall),
        SizedBox(height: AppSpacing.sm),
        if (_query.trim().isEmpty)
          Text(l10n.compendiumHint, style: text.bodyMedium)
        else if (results.isEmpty)
          ..._noResult(l10n, entries, table, banned, all)
        else ...[
          Text(
            l10n
                .compendiumResults(
                  results.length,
                  all ? l10n.compendiumAllPacks : table.settings.name,
                )
                .toUpperCase(),
            style: text.labelMedium,
          ),
          for (final r in results) _tile(l10n, r, banned),
        ],
        if (inactive.isNotEmpty && results.isNotEmpty)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.info_outline),
            title: Text(
              l10n.compendiumInactive(
                inactive.length,
                inactive.first.entity.name,
                inactive.first.pack.name,
              ),
            ),
            trailing: TextButton(
              onPressed: () => setState(() => _all = true),
              child: Text(l10n.compendiumShow),
            ),
          ),
      ],
    );
  }

  String _filterLabel(AppLocalizations l10n, CompendiumFilter f) => switch (f) {
    CompendiumFilter.all => l10n.compendiumFilterAll,
    CompendiumFilter.spells => l10n.compendiumFilterSpells,
    CompendiumFilter.feats => l10n.compendiumFilterFeats,
    CompendiumFilter.items => l10n.compendiumFilterItems,
    CompendiumFilter.monsters => l10n.compendiumFilterMonsters,
    CompendiumFilter.conditions => l10n.compendiumFilterConditions,
  };

  Widget _tile(
    AppLocalizations l10n,
    CompendiumEntry r,
    Set<String> banned, {
    bool here = false,
  }) {
    final isBanned = banned.contains('${r.entity.id}');
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(r.entity.name),
      subtitle: Text(entrySummary(l10n, r.entity)),
      onTap: () => showAdaptiveSheet(
        context,
        _EntitySheet(entry: r, banned: isBanned, content: _content),
      ),
      trailing: Wrap(
        spacing: AppSpacing.xs,
        children: [
          if (isBanned)
            Chip(
              avatar: const Icon(Icons.block, size: 16),
              label: Text(
                here ? l10n.compendiumBannedHere : l10n.compendiumBanned,
              ),
            ),
          Chip(label: Text(sourceBadge(r.pack))),
        ],
      ),
    );
  }

  /// « Aucun résultat » ([K5]).
  List<Widget> _noResult(
    AppLocalizations l10n,
    List<CompendiumEntry> entries,
    TableSummary? table,
    Set<String> banned,
    bool all,
  ) {
    final text = Theme.of(context).textTheme;
    final near = suggestions(entries, _query);
    return [
      Text(l10n.compendiumNoResult, style: text.titleMedium),
      Text(
        all || table == null
            ? l10n.compendiumNoResultAll(_query.trim())
            : l10n.compendiumNoResultTable(_query.trim(), table.settings.name),
      ),
      if (near.isNotEmpty) ...[
        SizedBox(height: AppSpacing.sm),
        Text(l10n.compendiumDidYouMean, style: text.titleSmall),
        for (final r in near) ...[
          _tile(l10n, r, banned, here: true),
          if (banned.contains('${r.entity.id}'))
            Text(l10n.compendiumBannedHint, style: text.bodySmall),
        ],
      ],
      if (!all)
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => setState(() => _all = true),
            child: Text(l10n.compendiumSearchAll),
          ),
        ),
    ];
  }
}

/// Fiche d'une entité ([K1]) : consultable même bannie.
class _EntitySheet extends StatelessWidget {
  const _EntitySheet({
    required this.entry,
    required this.banned,
    required this.content,
  });

  final CompendiumEntry entry;
  final bool banned;
  final ActiveContent content;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final e = entry.entity;
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(e.name, style: text.headlineSmall),
          Text(entrySummary(l10n, e), style: text.bodyMedium),
          Text(l10n.compendiumSource(entry.pack.name), style: text.bodySmall),
          if (banned) ...[
            SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(Icons.block, size: 16),
                SizedBox(width: AppSpacing.xs),
                Expanded(child: Text(l10n.compendiumBannedHint)),
              ],
            ),
          ],
          SizedBox(height: AppSpacing.sm),
          if (e.data case final MonsterData monster)
            StatBlockView(monster: monster, content: content, name: e.name)
          else ...[
            if (e.data case final SpellData s) ...[
              for (final (label, value) in [
                (l10n.compendiumCasting, s.castingTime),
                (l10n.spellDuration, s.duration),
              ])
                Text('$label : $value', style: text.bodyMedium),
              SizedBox(height: AppSpacing.xs),
            ],
            Text(e.textFr ?? '', style: text.bodyMedium),
          ],
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
