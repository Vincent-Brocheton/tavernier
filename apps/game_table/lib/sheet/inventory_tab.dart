import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import 'sheet_page.dart';

String _coinName(AppLocalizations l10n, String code) => switch (code) {
  'pp' => l10n.coinPlatinum,
  'gp' => l10n.coinGold,
  'ep' => l10n.coinElectrum,
  'sp' => l10n.coinSilver,
  _ => l10n.coinCopper,
};

bool _needsAttunement(ContentEntity? entity) =>
    entity?.data is MagicItemData && (entity!.data as MagicItemData).attunement;

/// Une arme, une armure et un objet magique se portent.
bool _wearable(ContentEntity? entity) =>
    entity?.data is WeaponData ||
    entity?.data is ArmorData ||
    entity?.data is MagicItemData;

/// Onglet Inventaire [P15] (EF-PJ-10).
class InventoryTab extends ConsumerWidget {
  const InventoryTab({
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

  Future<void> _save(WidgetRef ref, CharacterInput next) async {
    await ref.read(characterStoreProvider).save(id, next);
    ref
      ..invalidate(characterProvider(id))
      ..invalidate(charactersProvider);
  }

  String _subtitle(AppLocalizations l10n, ContentEntity? entity) {
    final data = entity?.data;
    if (data is ArmorData) {
      return data.category == ArmorCategory.shield
          ? l10n.armorShieldBonus(data.baseAc)
          : l10n.armorClassValue(data.baseAc);
    }
    if (data is WeaponData) {
      final attack = sheet.attacks
          .where((a) => a.weaponId == '${entity!.id}')
          .firstOrNull;
      if (attack != null) {
        return '${formatSigned(attack.attackBonus)} · ${attack.damage}';
      }
    }
    return _needsAttunement(entity) ? l10n.attunementRequired : '';
  }

  Widget _row(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    int index,
  ) {
    final item = character.items[index];
    final entity = content.entity(item.itemId);
    final subtitle = _subtitle(l10n, entity);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(entity?.name ?? item.itemId),
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
      trailing: Text(l10n.itemQuantity(item.quantity)),
      onTap: () => showAdaptiveSheet(
        context,
        _ItemSheet(
          entity: entity,
          item: item,
          blockAttunement:
              !item.attuned && sheet.attunedCount >= sheet.attunementSlots,
          onEquip: () => _save(ref, toggleEquipped(character, content, index)),
          onAttune: () => _save(ref, toggleAttuned(character, index)),
          onQuantity: (quantity) =>
              _save(ref, setItemQuantity(character, index, quantity)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final items = character.items.indexed.toList();
    final worn = [
      for (final (i, item) in items)
        if (item.equipped) i,
    ];
    final bag = [
      for (final (i, item) in items)
        if (!item.equipped) i,
    ];
    return ListView(
      padding: EdgeInsets.all(AppSpacing.md),
      children: [
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final code in coinCodes)
              StatTile(
                value: '${character.coins[code] ?? 0}',
                label: _coinName(l10n, code),
                onTap: () => showAdaptiveSheet(
                  context,
                  _CoinSheet(
                    name: _coinName(l10n, code),
                    amount: character.coins[code] ?? 0,
                    onSave: (amount) =>
                        _save(ref, setCoin(character, code, amount)),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          l10n.attunementCount(sheet.attunedCount, sheet.attunementSlots),
          style: text.titleMedium,
        ),
        SizedBox(height: AppSpacing.sm),
        if (items.isEmpty) Text(l10n.emptyInventory, style: text.bodyMedium),
        if (worn.isNotEmpty) ...[
          Text(l10n.itemsWorn.toUpperCase(), style: text.labelMedium),
          for (final index in worn) _row(context, ref, l10n, index),
          SizedBox(height: AppSpacing.sm),
        ],
        if (bag.isNotEmpty) ...[
          Text(l10n.itemsBag.toUpperCase(), style: text.labelMedium),
          for (final index in bag) _row(context, ref, l10n, index),
          SizedBox(height: AppSpacing.sm),
        ],
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton(
            onPressed: () => showAdaptiveSheet(
              context,
              _AddItemSheet(
                content: content,
                onAdd: (id) => _save(ref, addItem(character, id)),
              ),
            ),
            child: Text(l10n.addItem),
          ),
        ),
      ],
    );
  }
}

/// Fiche d'un objet : équiper, s'harmoniser, quantité.
class _ItemSheet extends StatelessWidget {
  const _ItemSheet({
    required this.entity,
    required this.item,
    required this.blockAttunement,
    required this.onEquip,
    required this.onAttune,
    required this.onQuantity,
  });

  final ContentEntity? entity;
  final ItemInput item;
  final bool blockAttunement;
  final VoidCallback onEquip;
  final VoidCallback onAttune;
  final ValueChanged<int> onQuantity;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    void act(VoidCallback action) {
      action();
      Navigator.of(context).pop();
    }

    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(entity?.name ?? item.itemId, style: text.headlineSmall),
          if (entity?.textFr case final description?) ...[
            SizedBox(height: AppSpacing.xs),
            Text(description, style: text.bodyMedium),
          ],
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              IconButton(
                tooltip: l10n.removeOne,
                onPressed: () => act(() => onQuantity(item.quantity - 1)),
                icon: const Icon(Icons.remove),
              ),
              Text(l10n.itemQuantity(item.quantity), style: text.titleMedium),
              IconButton(
                tooltip: l10n.addOne,
                onPressed: () => act(() => onQuantity(item.quantity + 1)),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          if (blockAttunement && _needsAttunement(entity))
            Text(l10n.attunementFull, style: text.bodySmall),
          SizedBox(height: AppSpacing.xs),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.close),
              ),
              if (_needsAttunement(entity))
                OutlinedButton(
                  onPressed: blockAttunement ? null : () => act(onAttune),
                  child: Text(item.attuned ? l10n.endAttunement : l10n.attune),
                ),
              if (_wearable(entity))
                FilledButton(
                  onPressed: () => act(onEquip),
                  child: Text(item.equipped ? l10n.unequip : l10n.equip),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Saisie d'une pièce.
class _CoinSheet extends StatefulWidget {
  const _CoinSheet({
    required this.name,
    required this.amount,
    required this.onSave,
  });

  final String name;
  final int amount;
  final ValueChanged<int> onSave;

  @override
  State<_CoinSheet> createState() => _CoinSheetState();
}

class _CoinSheetState extends State<_CoinSheet> {
  late final _controller = TextEditingController(text: '${widget.amount}');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final amount = int.tryParse(_controller.text);
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(labelText: widget.name),
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.close),
              ),
              SizedBox(width: AppSpacing.xs),
              FilledButton(
                onPressed: amount == null || amount < 0
                    ? null
                    : () {
                        widget.onSave(amount);
                        Navigator.of(context).pop();
                      },
                child: Text(l10n.saveSpells),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Recherche d'un objet à ajouter.
class _AddItemSheet extends StatefulWidget {
  const _AddItemSheet({required this.content, required this.onAdd});

  final ActiveContent content;
  final ValueChanged<String> onAdd;

  @override
  State<_AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<_AddItemSheet> {
  static const _maxResults = 30;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final query = _query.toLowerCase();
    final matches = query.isEmpty
        ? const <ContentEntity>[]
        : [
            for (final type in ['weapon', 'armor', 'item', 'magic-item'])
              ...sortedEntities(
                widget.content,
                type,
              ).where((e) => e.name.toLowerCase().contains(query)),
          ];
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            autofocus: true,
            decoration: InputDecoration(labelText: l10n.searchItem),
            onChanged: (value) => setState(() => _query = value),
          ),
          SizedBox(height: AppSpacing.xs),
          if (query.isNotEmpty && matches.isEmpty)
            Text(l10n.noItemMatches, style: text.bodyMedium),
          for (final entity in matches.take(_maxResults))
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(entity.name),
              onTap: () {
                widget.onAdd('${entity.id}');
                Navigator.of(context).pop();
              },
            ),
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
