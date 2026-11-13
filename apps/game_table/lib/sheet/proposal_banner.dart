// Proposition structurelle du MJ, côté joueur [F4b] (US-34, EF-PJ-16,
// COMPOSANTS §2.44).
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../account/account_providers.dart';
import '../creation/creation_providers.dart';
import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import 'conflicts.dart';
import 'sheet_page.dart' show characterProvider;

/// Propositions en attente pour la fiche [id], vues par son propriétaire
/// seulement : lui seul les accepte ou les refuse.
final myProposalsProvider = StreamProvider.autoDispose
    .family<List<CharacterProposal>, String>((ref, id) async* {
      final me = ref.watch(currentUserProvider.select((u) => u.value?.id));
      final store = ref.watch(characterStoreProvider);
      final access = await store.access(id);
      if (me == null || access == null || access.ownerUserId != me) {
        yield const [];
        return;
      }
      yield* store.watchPendingProposals(id);
    });

/// Ligne de l'aperçu : valeur touchée, avant, après.
typedef ProposalRow = ({String label, String before, String after});

/// Valeurs de la fiche que la proposition change.
List<ProposalRow> proposalRows(
  AppLocalizations l10n,
  ActiveContent content,
  CharacterInput before,
  CharacterInput after,
) {
  final a = computeSheet(before, content);
  final b = computeSheet(after, content);
  final beforeFeats = before.feats.map((f) => f.featId).toList();
  final afterFeats = after.feats.map((f) => f.featId).toList();
  final removedFeats = beforeFeats.where((f) => !afterFeats.contains(f));
  final addedFeats = afterFeats.where((f) => !beforeFeats.contains(f));
  final addedSkills = b.skillProficiencies.where(
    (s) => !a.skillProficiencies.contains(s),
  );
  final removedSkills = a.skillProficiencies.where(
    (s) => !b.skillProficiencies.contains(s),
  );
  // Le moteur donne des clés (`animal_handling`) : leurs noms du contenu.
  String skillNames(Iterable<String> keys) => [
    for (final skill in sortedEntities(content, 'skill'))
      if (keys.contains(skillKey(skill))) skill.name,
  ].join(', ');
  return [
    if (removedFeats.isNotEmpty || addedFeats.isNotEmpty)
      (
        label: l10n.proposalFeatRow,
        before: namesOf(content, removedFeats),
        after: namesOf(content, addedFeats),
      ),
    for (final code in abilityCodes)
      if (a.abilities[code]!.value != b.abilities[code]!.value)
        (
          label: namesOf(content, [abilityIdByCode[code]!]),
          before: '${a.abilities[code]!.value}',
          after: '${b.abilities[code]!.value}',
        ),
    if (a.initiative.value != b.initiative.value)
      (
        label: l10n.statInitiative,
        before: formatSigned(a.initiative.value),
        after: formatSigned(b.initiative.value),
      ),
    if (a.armorClass.value != b.armorClass.value)
      (
        label: l10n.statArmorClass,
        before: '${a.armorClass.value}',
        after: '${b.armorClass.value}',
      ),
    if (a.hitPointsMax.value != b.hitPointsMax.value)
      (
        label: l10n.statHitPoints,
        before: '${a.hitPointsMax.value}',
        after: '${b.hitPointsMax.value}',
      ),
    if (a.speedFeet != b.speedFeet)
      (
        label: l10n.statSpeed,
        before: formatFeet(a.speedFeet),
        after: formatFeet(b.speedFeet),
      ),
    if (addedSkills.isNotEmpty || removedSkills.isNotEmpty)
      (
        label: l10n.proposalSkillsRow,
        before: l10n.proposalSkillsCount(a.skillProficiencies.length),
        after: [
          if (addedSkills.isNotEmpty)
            l10n.proposalSkillsAdded(skillNames(addedSkills)),
          if (removedSkills.isNotEmpty)
            l10n.proposalSkillsRemoved(skillNames(removedSkills)),
        ].join(' '),
      ),
  ];
}

/// Encadré en tête de fiche : la plus ancienne proposition en attente, son
/// motif, l'aperçu avant et après, « Refuser » (avec message) et
/// « Accepter ».
class ProposalBanner extends ConsumerStatefulWidget {
  const ProposalBanner({
    super.key,
    required this.id,
    required this.content,
    required this.character,
  });

  final String id;
  final ActiveContent content;
  final CharacterInput character;

  @override
  ConsumerState<ProposalBanner> createState() => _ProposalBannerState();
}

class _ProposalBannerState extends ConsumerState<ProposalBanner> {
  final _reply = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  Future<void> _decide(
    CharacterProposal proposal, {
    required bool accept,
  }) async {
    setState(() => _busy = true);
    final store = ref.read(characterStoreProvider);
    try {
      if (accept) {
        final me = ref.read(currentUserProvider).value!.id;
        await store.acceptProposal(proposal, playerUserId: me);
        ref.invalidate(characterProvider(widget.id));
      } else {
        final reply = _reply.text.trim();
        await store.refuseProposal(proposal.id, reply.isEmpty ? null : reply);
      }
      _reply.clear();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final proposal = ref
        .watch(myProposalsProvider(widget.id))
        .value
        ?.firstOrNull;
    if (proposal == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final gm = switch (proposal.authorUserId) {
      final id? => ref.watch(pseudonymOfProvider(id)).value,
      null => null,
    };
    // Une modification illisible (contenu absent, format inconnu) ne casse
    // pas la fiche : pas d'aperçu, et seul le refus reste possible.
    List<ProposalRow>? rows;
    try {
      rows = proposalRows(
        l10n,
        widget.content,
        widget.character,
        proposal.applyTo(widget.character),
      );
    } on Object {
      rows = null;
    }
    final feat = rows
        ?.where((r) => r.label == l10n.proposalFeatRow)
        .firstOrNull;
    final summary = proposal.kind == 'feat' && feat != null
        ? l10n.proposalReplaceFeat(feat.before, feat.after)
        : l10n.proposalChangeSheet;
    Widget cell(String value, {TextStyle? style}) => Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Text(value, style: style),
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
        0,
      ),
      // Au plus la moitié de l'écran : les onglets restent visibles.
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height / 2,
        ),
        child: SingleChildScrollView(
          child: Semantics(
            liveRegion: true,
            child: Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadii.md),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: AppSpacing.sm,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.edit_note, color: scheme.onPrimaryContainer),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          l10n.proposalTitle(
                            gm ?? l10n.proposalSomeone,
                            summary,
                          ),
                          style: text.titleSmall!.copyWith(
                            color: scheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    l10n.proposalReason(proposal.reason),
                    style: text.bodyMedium!.copyWith(
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                  if (rows != null && rows.isNotEmpty)
                    Table(
                      columnWidths: const {0: FlexColumnWidth(1.2)},
                      children: [
                        TableRow(
                          children: [
                            for (final h in [
                              l10n.proposalValue,
                              l10n.proposalBefore,
                              l10n.proposalAfter,
                            ])
                              cell(h, style: text.labelMedium),
                          ],
                        ),
                        for (final row in rows)
                          TableRow(
                            children: [
                              cell(row.label, style: text.bodyMedium),
                              cell(row.before, style: text.bodyMedium),
                              cell(
                                row.after,
                                style: text.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  TextField(
                    controller: _reply,
                    decoration: InputDecoration(
                      labelText: l10n.proposalRefuseMessage,
                    ),
                    maxLines: null,
                  ),
                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      OutlinedButton(
                        onPressed: _busy
                            ? null
                            : () => _decide(proposal, accept: false),
                        child: Text(l10n.proposalRefuse),
                      ),
                      FilledButton(
                        onPressed: _busy || rows == null
                            ? null
                            : () => _decide(proposal, accept: true),
                        child: Text(l10n.proposalAccept),
                      ),
                    ],
                  ),
                  Text(
                    l10n.proposalAcceptNote,
                    style: text.bodySmall!.copyWith(
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
