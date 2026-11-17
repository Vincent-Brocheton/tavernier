// Nouveau PNJ en bloc de stats (US-18, EF-PNJ-01, [G5]) : nom, monstre de
// départ, dossier, attitude initiale.
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import '../tables/tables_providers.dart';
import 'npcs_providers.dart';

class NewNpcPage extends ConsumerStatefulWidget {
  const NewNpcPage({super.key, required this.tableId});

  final String tableId;

  @override
  ConsumerState<NewNpcPage> createState() => _NewNpcPageState();
}

class _NewNpcPageState extends ConsumerState<NewNpcPage> {
  final _name = TextEditingController();
  final _folder = TextEditingController();
  ContentEntity? _monster;
  var _attitude = Attitude.indifferent;
  var _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _folder.dispose();
    super.dispose();
  }

  bool get _ready => _name.text.trim().isNotEmpty && _monster != null;

  Future<void> _create() async {
    setState(() => _saving = true);
    final folder = _folder.text.trim();
    final id = await ref
        .read(npcStoreProvider)
        .create(
          tableId: widget.tableId,
          name: _name.text.trim(),
          folder: folder.isEmpty ? null : folder,
          monsterId: '${_monster!.id}',
          attitude: _attitude,
        );
    if (mounted) {
      context.pushReplacement('/tables/${widget.tableId}/pnj/$id');
    }
  }

  Future<void> _chooseMonster(ActiveContent content) async {
    final monster = await showModalBottomSheet<ContentEntity>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _MonsterPicker(content: content),
    );
    if (monster != null) setState(() => _monster = monster);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final content = ref.watch(contentProvider).value;
    final table = ref.watch(tableProvider(widget.tableId)).value;
    final folders = {
      for (final n
          in ref.watch(tableNpcsProvider(widget.tableId)).value ??
              const <Npc>[])
        ?n.folder,
    };
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.npcNew),
            if (table != null) Text(table.settings.name, style: text.bodySmall),
          ],
        ),
      ),
      body: content == null
          ? const Center(child: CircularProgressIndicator())
          : Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: ListView(
                  padding: EdgeInsets.all(AppSpacing.md),
                  children: [
                    Card(
                      margin: EdgeInsets.zero,
                      child: ListTile(
                        leading: const Icon(Icons.article_outlined),
                        title: Text(l10n.npcStatBlock),
                        subtitle: Text(l10n.npcStatBlockBody),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: _name,
                      decoration: InputDecoration(labelText: l10n.npcName),
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: AppSpacing.md),
                    InkWell(
                      onTap: () => _chooseMonster(content),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: l10n.npcFrom,
                          suffixIcon: const Icon(Icons.search),
                        ),
                        child: Text(switch (_monster) {
                          final m? => l10n.npcMonsterValue(
                            m.name,
                            packLabelOf(l10n, content, '${m.id}'),
                          ),
                          null => l10n.npcFromChoose,
                        }),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: _folder,
                      decoration: InputDecoration(labelText: l10n.npcFolder),
                    ),
                    if (folders.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: AppSpacing.xs),
                        child: Wrap(
                          spacing: AppSpacing.xs,
                          children: [
                            for (final f in folders)
                              ActionChip(
                                label: Text(f),
                                onPressed: () => _folder.text = f,
                              ),
                          ],
                        ),
                      ),
                    SizedBox(height: AppSpacing.md),
                    Text(l10n.npcAttitudeInitial, style: text.labelLarge),
                    SizedBox(height: AppSpacing.xs),
                    AttitudeSelector(
                      value: _attitude,
                      onChanged: (a) => setState(() => _attitude = a),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => context.pop(),
                          child: Text(l10n.cancel),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        FilledButton(
                          onPressed: _ready && !_saving ? _create : null,
                          child: Text(l10n.npcCreate),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

/// Amical, Indifférent ou Hostile, chacun avec son icône.
class AttitudeSelector extends StatelessWidget {
  const AttitudeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final Attitude value;
  final ValueChanged<Attitude> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SegmentedButton<Attitude>(
      segments: [
        for (final a in Attitude.values)
          ButtonSegment(
            value: a,
            label: Text(attitudeLabel(l10n, a).$1),
            icon: Icon(attitudeLabel(l10n, a).$2),
          ),
      ],
      selected: {value},
      showSelectedIcon: false,
      onSelectionChanged: (s) => onChanged(s.single),
    );
  }
}

/// Monstres du contenu actif, cherchés par nom (sans accents ni casse).
class _MonsterPicker extends StatefulWidget {
  const _MonsterPicker({required this.content});

  final ActiveContent content;

  @override
  State<_MonsterPicker> createState() => _MonsterPickerState();
}

class _MonsterPickerState extends State<_MonsterPicker> {
  var _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = foldAccents(_query.trim());
    final monsters = [
      for (final m in sortedEntities(widget.content, 'monster'))
        if (foldAccents(m.name).contains(query)) m,
    ];
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.8,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: l10n.npcMonsterSearch,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  // ponytail: 50 lignes, la recherche affine ; une liste
                  // paresseuse si les packs grossissent beaucoup.
                  for (final m in monsters.take(50))
                    ListTile(
                      title: Text(m.name),
                      subtitle: Text(
                        l10n.npcMonsterLine(
                          (m.data as MonsterData).cr,
                          packLabelOf(l10n, widget.content, '${m.id}'),
                        ),
                      ),
                      onTap: () => Navigator.pop(context, m),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
