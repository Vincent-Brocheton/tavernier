// Bac à sable d'une entité homebrew (US-28, EF-HB-03, [H04]) : un prétiré
// sans puis avec l'entité, calculé par `dnd_rules`, sans rien enregistrer.
// Le contenu du test est celui de l'appareil, plus le brouillon tel qu'il
// est à l'écran.
import 'dart:math';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../l10n/app_localizations.dart';
import '../npcs/stat_block_view.dart';

/// Types qui se testent : ceux qui changent une fiche, et le monstre, dont
/// on voit le profil.
const sandboxTypes = {
  'feat',
  'background',
  'species',
  'class',
  'subclass',
  'weapon',
  'armor',
  'magic-item',
  'monster',
};

class SandboxPage extends ConsumerStatefulWidget {
  const SandboxPage({
    super.key,
    required this.manifest,
    required this.entities,
    required this.entityId,
  });

  final Map<String, Object?> manifest;
  final List<Map<String, Object?>> entities;
  final String entityId;

  @override
  ConsumerState<SandboxPage> createState() => _SandboxPageState();
}

class _SandboxPageState extends ConsumerState<SandboxPage> {
  String? _classId;
  int? _level;
  bool _shield = true;

  /// Contenu de l'appareil, plus les entités du brouillon qui se lisent.
  ActiveContent _content(ActiveContent device) {
    final manifest = PackManifest.parse(widget.manifest).manifest;
    if (manifest == null) return device;
    final entities = [
      for (final json in widget.entities) ?parseEntity(json, 'sandbox').entity,
    ];
    return ActiveContent([
      ...device.packs.where((p) => p.manifest.id != manifest.id),
      ContentPack(manifest: manifest, entities: entities),
    ]);
  }

  /// Problèmes de la vérification qui visent l'entité ou ses aptitudes.
  List<ContentIssue> _issues(ActiveContent device) {
    bool concerned(Map<String, Object?> e) =>
        e['id'] == widget.entityId ||
        (e['data'] as Map?)?['source'] == widget.entityId;
    return [
      for (final issue in checkDraft(
        widget.manifest,
        widget.entities,
        dependencies: device.entities,
      ))
        if (RegExp(r'^entities\[(\d+)\]').firstMatch(issue.path)?[1]
            case final i? when concerned(widget.entities[int.parse(i)]))
          issue,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final device = ref.watch(contentProvider).value;
    if (device == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final content = _content(device);
    final entity = content.entity(widget.entityId);
    final issues = _issues(device);
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.sandboxDraft('${widget.manifest['name']}'),
              style: text.bodySmall,
            ),
            Text(
              l10n.sandboxTitle(entity?.name ?? widget.entityId),
              style: text.titleLarge,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              avatar: const Icon(Icons.shield_outlined),
              label: Text(l10n.sandboxBanner),
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          if (entity == null)
            ..._unreadable(l10n, issues)
          else if (entity.data case final MonsterData monster)
            StatBlockView(monster: monster, content: content, name: entity.name)
          else
            ..._test(l10n, content, entity, issues),
        ],
      ),
    );
  }

  List<Widget> _unreadable(AppLocalizations l10n, List<ContentIssue> issues) =>
      [
        Text(l10n.sandboxUnreadable),
        for (final i in issues)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.error_outline),
            title: Text(i.message),
          ),
      ];

  List<Widget> _test(
    AppLocalizations l10n,
    ActiveContent content,
    ContentEntity entity,
    List<ContentIssue> issues,
  ) {
    final text = Theme.of(context).textTheme;
    final type = entity.type;
    final classes = [
      for (final e in content.entities)
        if (e.data is ClassData) e,
    ];
    final fixed = switch (entity.data) {
      ClassData() => '${entity.id}',
      SubclassData(:final parentClass) => '$parentClass',
      _ => null,
    };
    final classId =
        fixed ??
        _classId ??
        classes
            .where((c) => '${c.id}' == 'srd:class:fighter')
            .firstOrNull
            ?.id
            .toString() ??
        classes.firstOrNull?.id.toString();
    final classData = content.entity(classId ?? '')?.data;
    final minLevel = entity.data is SubclassData && classData is ClassData
        ? classData.subclassLevel
        : 1;
    final level = (_level ?? max(minLevel, 5)).clamp(minLevel, 20);

    // Fiche sans, puis avec l'entité.
    String? failure;
    SheetComparison? comparison;
    if (classId != null) {
      CharacterInput character({
        String? subclassId,
        String? speciesId,
        String? backgroundId,
        List<FeatInput> feats = const [],
        List<ItemInput> items = const [],
        String? cls,
      }) => sandboxCharacter(
        content,
        classId: cls ?? classId,
        level: level,
        subclassId: subclassId,
        shield: _shield,
        feats: feats,
        items: items,
        speciesId: speciesId ?? 'srd:species:human',
        backgroundId: backgroundId ?? 'srd:background:soldier',
      );
      final id = '${entity.id}';
      final withEntity = switch (type) {
        'feat' => character(
          feats: [FeatInput(featId: id, sourceType: 'test', sourceRef: 'test')],
        ),
        'background' => character(backgroundId: id),
        'species' => character(speciesId: id),
        'class' => character(cls: id),
        'subclass' => character(subclassId: id),
        _ => character(
          items: [
            ItemInput(
              itemId: id,
              quantity: 1,
              equipped: true,
              attuned: requiresAttunement(entity.data),
            ),
          ],
        ),
      };
      try {
        comparison = compareSheets(
          type == 'class' ? null : computeSheet(character(), content),
          computeSheet(withEntity, content),
        );
      } on Object catch (e) {
        failure = '$e';
      }
    }

    final controls = Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.sandboxCharacter, style: text.titleMedium),
            DropdownButtonFormField<String>(
              initialValue: classId,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.sandboxBase),
              items: [
                for (final c in classes)
                  DropdownMenuItem(
                    value: '${c.id}',
                    child: Text(l10n.sandboxPregen(c.name)),
                  ),
              ],
              onChanged: fixed == null
                  ? (v) => setState(() => _classId = v)
                  : null,
            ),
            SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(child: Text(l10n.sandboxLevel)),
                Text('$level', style: text.titleMedium),
              ],
            ),
            Slider(
              value: level.toDouble(),
              min: minLevel.toDouble(),
              max: 20,
              divisions: max(1, 20 - minLevel),
              label: '$level',
              onChanged: (v) => setState(() => _level = v.round()),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.sandboxShield),
              value: _shield,
              onChanged: (v) => setState(() => _shield = v),
            ),
            Text(l10n.sandboxHint, style: text.bodySmall),
          ],
        ),
      ),
    );

    final table = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final row in comparison?.rows ?? const <SheetRow>[])
          _row(l10n, content, row),
      ],
    );

    final errors = comparison?.addedErrors ?? const <IntegrityError>[];
    final result = Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.sandboxResult, style: text.titleMedium),
            SizedBox(height: AppSpacing.xs),
            if (failure != null)
              Text(l10n.sandboxFailed(failure))
            else if (errors.isEmpty)
              Text(l10n.sandboxOk(level))
            else
              for (final e in errors)
                Row(
                  children: [
                    const Icon(Icons.error_outline),
                    SizedBox(width: AppSpacing.xs),
                    Expanded(child: Text(e.message)),
                  ],
                ),
            if (issues.isNotEmpty) ...[
              SizedBox(height: AppSpacing.sm),
              Text(l10n.sandboxToFix, style: text.titleSmall),
              for (final i in issues) Text('· ${i.message}'),
            ],
          ],
        ),
      ),
    );

    final back = FilledButton.tonal(
      onPressed: () => Navigator.pop(context),
      child: Text(l10n.sandboxBack),
    );

    return [
      LayoutBuilder(
        builder: (context, constraints) => constraints.maxWidth >= 900
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 300, child: controls),
                  SizedBox(width: AppSpacing.md),
                  Expanded(child: table),
                  SizedBox(width: AppSpacing.md),
                  SizedBox(
                    width: 340,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        result,
                        SizedBox(height: AppSpacing.sm),
                        back,
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  controls,
                  SizedBox(height: AppSpacing.sm),
                  table,
                  SizedBox(height: AppSpacing.sm),
                  result,
                  SizedBox(height: AppSpacing.sm),
                  back,
                ],
              ),
      ),
    ];
  }

  /// Une ligne : valeur, sans, avec, source. Une valeur qui change porte
  /// une flèche, pas seulement une couleur.
  Widget _row(AppLocalizations l10n, ActiveContent content, SheetRow row) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    String name(String id) => content.entity(id)?.name ?? id;
    final label = switch (row.kind) {
      SheetRowKind.armorClass => l10n.sandboxAc,
      SheetRowKind.hitPoints => l10n.sandboxHp,
      SheetRowKind.initiative => l10n.statInitiative,
      SheetRowKind.speed => l10n.statSpeed,
      SheetRowKind.passivePerception => l10n.sandboxPassive,
      SheetRowKind.savingThrow => l10n.sandboxSave(
        name(abilityIdByCode[row.ref] ?? '${row.ref}'),
      ),
      SheetRowKind.skill || SheetRowKind.resource => name('${row.ref}'),
      SheetRowKind.darkvision => l10n.sandboxDarkvision,
      SheetRowKind.attacksPerAction => l10n.sandboxAttacks,
      SheetRowKind.spellSlot => l10n.classColumnSlots(int.parse('${row.ref}')),
      SheetRowKind.attack => l10n.sandboxAttack(name('${row.ref}')),
    };
    String show(String value) => switch (row.kind) {
      SheetRowKind.speed ||
      SheetRowKind.darkvision => formatFeet(int.parse(value)),
      _ => value,
    };
    final changed = row.before != null && row.before != row.after;
    final sources = [
      for (final s in row.sources)
        if (s.contains(':')) name(s),
    ];
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(
        [if (sources.isNotEmpty) l10n.sandboxSource(sources.join(', '))].join(),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (row.before case final before?) ...[
            Text(show(before), style: text.bodyMedium),
            Icon(
              changed ? Icons.arrow_forward : Icons.drag_handle,
              size: 16,
              semanticLabel: changed ? l10n.sandboxChanged : l10n.sandboxSame,
            ),
          ],
          Text(
            show(row.after),
            style: text.titleSmall?.copyWith(
              color: changed ? scheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}
