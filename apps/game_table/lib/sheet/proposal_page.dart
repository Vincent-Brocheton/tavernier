// Proposition structurelle du MJ, côté MJ [F4a] (US-34, EF-PJ-16,
// COMPOSANTS §2.44) : remplacer un don, avec un motif obligatoire.
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import 'conflicts.dart';
import 'proposal_banner.dart';
import 'sheet_page.dart';

/// Adresse de l'envoi d'une proposition pour la fiche [id].
String proposalPath(String id) => '/characters/$id/proposer';

/// Catégories dont un don se remplace par un autre de la même catégorie,
/// sans prérequis à vérifier.
const _replaceable = {FeatCategory.origin, FeatCategory.fightingStyle};

/// Dons de [character] que le MJ peut proposer de remplacer.
List<FeatInput> replaceableFeats(
  ActiveContent content,
  CharacterInput character,
) => [
  for (final feat in character.feats)
    if (content.entity(feat.featId)?.data case final FeatData data
        when _replaceable.contains(data.category))
      feat,
];

/// Dons proposables à la place de [replaced] : même catégorie, ni lui ni un
/// don déjà pris (sauf répétable). L'Initié à la magie, dont les choix
/// dépendent d'une liste de sorts, n'est pas proposé.
List<ContentEntity> eligibleFeats(
  ActiveContent content,
  CharacterInput character,
  FeatInput replaced,
) {
  final category = (content.entity(replaced.featId)!.data as FeatData).category;
  final owned = {for (final f in character.feats) f.featId};
  return [
    for (final entity in sortedEntities(content, 'feat'))
      if (entity.data case final FeatData data
          when data.category == category &&
              '${entity.id}' != replaced.featId &&
              '${entity.id}' != magicInitiateFeat &&
              (data.repeatable || !owned.contains('${entity.id}')))
        entity,
  ];
}

/// Envoi d'une proposition [F4a] : don à remplacer, don proposé et ses
/// choix, aperçu avant et après, motif obligatoire.
class ProposalPage extends ConsumerStatefulWidget {
  const ProposalPage({super.key, required this.id});

  final String id;

  @override
  ConsumerState<ProposalPage> createState() => _ProposalPageState();
}

class _ProposalPageState extends ConsumerState<ProposalPage> {
  final _reason = TextEditingController();
  FeatInput? _replaced;
  String? _by;
  Map<String, List<String>> _choices = const {};
  bool _busy = false;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  void _leave() => context.canPop() ? context.pop() : context.go('/');

  Future<void> _send(
    CharacterInput character,
    ({String tableId, String ownerUserId, String me}) view,
    List<FeatInput> feats,
    String player,
  ) async {
    setState(() => _busy = true);
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(characterStoreProvider)
          .propose(
            characterId: widget.id,
            tableId: view.tableId,
            authorUserId: view.me,
            kind: 'feat',
            change: {
              'feats': [for (final f in feats) f.toJson()],
            },
            reason: _reason.text.trim(),
          );
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.proposalSent(player))),
      );
      _leave();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final content = ref.watch(contentProvider).value;
    final character = ref.watch(characterProvider(widget.id)).value;
    final view = ref.watch(gmProposalViewProvider(widget.id)).value;
    if (content == null || character == null || view == null) {
      return Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: _leave)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final player =
        ref.watch(pseudonymOfProvider(view.ownerUserId)).value ??
        l10n.proposalPlayer;
    final replaceable = replaceableFeats(content, character);
    final replaced = _replaced ?? replaceable.firstOrNull;
    final eligible = replaced == null
        ? const <ContentEntity>[]
        : eligibleFeats(content, character, replaced);
    final by = eligible.any((e) => '${e.id}' == _by) ? _by : null;
    final choices = by == null
        ? const <OpenChoice>[]
        : openChoices(content, [by]);
    final complete = choices.every(
      (c) => (_choices[c.id]?.length ?? 0) == c.count,
    );
    final feats = [
      for (final f in character.feats)
        if (f == replaced && by != null)
          FeatInput(
            featId: by,
            sourceType: f.sourceType,
            sourceRef: f.sourceRef,
            choices: {
              for (final c in choices) c.id: _choices[c.id] ?? const [],
            },
          )
        else
          f,
    ];
    final rows = by == null || !complete
        ? const <ProposalRow>[]
        : proposalRows(
            l10n,
            content,
            character,
            character.copyWith(feats: feats),
          );
    final canSend =
        !_busy && by != null && complete && _reason.text.trim().isNotEmpty;
    String featLabel(FeatInput f) =>
        '${namesOf(content, [f.featId])} (${namesOf(content, [f.sourceRef])})';

    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(onPressed: _leave),
        title: Text(l10n.proposalPageTitle(player)),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: EdgeInsets.all(AppSpacing.md),
              children: [
                Text(
                  l10n.proposalPageIntro(character.name),
                  style: text.bodyMedium,
                ),
                SizedBox(height: AppSpacing.md),
                if (replaced == null)
                  Text(l10n.proposalNoFeat, style: text.bodyMedium)
                else ...[
                  Text(l10n.proposalTypeFeat, style: text.titleSmall),
                  SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<FeatInput>(
                    initialValue: replaced,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l10n.proposalReplace,
                    ),
                    items: [
                      for (final f in replaceable)
                        DropdownMenuItem(value: f, child: Text(featLabel(f))),
                    ],
                    onChanged: (f) => setState(() {
                      _replaced = f;
                      _by = null;
                      _choices = const {};
                    }),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<String>(
                    key: ValueKey(replaced),
                    initialValue: by,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l10n.proposalBy),
                    items: [
                      for (final e in eligible)
                        DropdownMenuItem(value: '${e.id}', child: Text(e.name)),
                    ],
                    onChanged: (id) => setState(() {
                      _by = id;
                      _choices = const {};
                    }),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(l10n.proposalEligibleHint, style: text.bodySmall),
                  for (final choice in choices) ...[
                    SizedBox(height: AppSpacing.md),
                    Text(
                      l10n.proposalChoose(
                        choice.count,
                        _choices[choice.id]?.length ?? 0,
                      ),
                      style: text.titleSmall,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        for (final option in choice.options)
                          FilterChip(
                            label: Text(option.label),
                            selected:
                                _choices[choice.id]?.contains(option.pick) ??
                                false,
                            onSelected: (on) => setState(() {
                              final picked = [...?_choices[choice.id]];
                              if (on) {
                                if (picked.length >= choice.count) return;
                                picked.add(option.pick);
                              } else {
                                picked.remove(option.pick);
                              }
                              _choices = {..._choices, choice.id: picked};
                            }),
                          ),
                      ],
                    ),
                  ],
                  if (rows.isNotEmpty) ...[
                    SizedBox(height: AppSpacing.md),
                    ProposalPreview(rows: rows),
                  ],
                  SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _reason,
                    maxLines: null,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: l10n.proposalReasonLabel,
                    ),
                  ),
                ],
                SizedBox(height: AppSpacing.md),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    TextButton(onPressed: _leave, child: Text(l10n.cancel)),
                    FilledButton(
                      onPressed: canSend
                          ? () => _send(character, view, feats, player)
                          : null,
                      child: Text(l10n.proposalSend),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
