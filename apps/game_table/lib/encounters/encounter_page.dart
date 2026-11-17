// Page d'une rencontre (US-19) : titre, séance et adversaires, en lecture.
// La préparation [C1] la complète (lot c).
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../l10n/app_localizations.dart';
import '../npcs/npcs_providers.dart';
import '../sessions/sessions_providers.dart';
import '../tables/tables_providers.dart';
import 'encounters_providers.dart';

class EncounterPage extends ConsumerWidget {
  const EncounterPage({super.key, required this.tableId, required this.id});

  final String tableId;
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final table = ref.watch(tableProvider(tableId)).value;
    final content = ref.watch(contentProvider).value;
    final npcs = ref.watch(tableNpcsProvider(tableId)).value;
    final encounter =
        (ref.watch(tableEncountersProvider(tableId)).value ??
                const <Encounter>[])
            .where((e) => e.id == id)
            .firstOrNull;
    if (table == null || content == null || npcs == null || encounter == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final session =
        (ref.watch(tableSessionsProvider(tableId)).value ??
                const <GameSession>[])
            .where((s) => s.id == encounter.sessionId)
            .firstOrNull;
    final foes = foesOf(l10n, encounter, content, npcs);
    final levels = ref.watch(
      presentLevelsProvider((tableId: tableId, sessionId: encounter.sessionId)),
    );
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              [
                table.settings.name,
                if (session != null) l10n.sessionNumber(session.number),
              ].join(' · '),
              style: text.bodySmall,
            ),
            Text(encounter.title),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            session == null
                ? l10n.encounterReserve
                : l10n.sessionDate(session.date),
            style: text.bodyMedium,
          ),
          Text(encounterSummary(l10n, foes, levels), style: text.bodyMedium),
          SizedBox(height: AppSpacing.md),
          for (final foe in foes)
            ListTile(
              title: Text(foe.name),
              trailing: Text(
                foe.quantity > 1 ? l10n.encounterQuantity(foe.quantity) : '',
                style: text.titleMedium,
              ),
              subtitle: Text(l10n.encounterXp(formatThousands(foe.xp))),
            ),
        ],
      ),
    );
  }
}
