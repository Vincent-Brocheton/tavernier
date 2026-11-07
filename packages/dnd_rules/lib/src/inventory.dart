import 'package:dnd_content/dnd_content.dart';

import 'active_content.dart';
import 'character_input.dart';

/// Objets harmonisés au maximum (SRD, « Harmonisation »).
const baseAttunementSlots = 3;

/// Soin d'un consommable.
typedef Consumable = ({int dice, int sides, int bonus, String action});

/// Soin de [entity], ou `null` si l'objet ne s'utilise pas.
Consumable? consumableOf(ContentEntity? entity) {
  for (final effect in entity?.effects ?? const <Effect>[]) {
    if (effect.op != 'consumable_heal') continue;
    final dice = (effect.args['dice']! as String).split('d');
    return (
      dice: int.parse(dice.first),
      sides: int.parse(dice.last),
      bonus: effect.args['bonus'] as int? ?? 0,
      action: effect.args['action']! as String,
    );
  }
  return null;
}

/// Un jet saisi doit pouvoir sortir de ces dés.
bool consumableRollValid(Consumable item, int roll) =>
    roll >= item.dice && roll <= item.dice * item.sides;

/// Pièces, de la plus précieuse à la moins précieuse.
const coinCodes = ['pp', 'gp', 'ep', 'sp', 'cp'];

CharacterInput _withItems(CharacterInput character, List<ItemInput> items) =>
    character.copyWith(items: items);

/// [character] avec un [itemId] de plus dans son sac.
CharacterInput addItem(CharacterInput character, String itemId) {
  final index = character.items.indexWhere((i) => i.itemId == itemId);
  return _withItems(character, [
    for (final (i, item) in character.items.indexed)
      i == index ? item.copyWith(quantity: item.quantity + 1) : item,
    if (index < 0) ItemInput(itemId: itemId, quantity: 1),
  ]);
}

/// [character] avec [quantity] exemplaires de l'objet de rang [index] ; à 0,
/// l'objet est retiré.
CharacterInput setItemQuantity(
  CharacterInput character,
  int index,
  int quantity,
) => _withItems(character, [
  for (final (i, item) in character.items.indexed)
    if (i != index)
      item
    else if (quantity > 0)
      item.copyWith(quantity: quantity),
]);

/// `armor` ou `shield` pour ce qui ne se porte qu'à un exemplaire.
String? _slotOf(ActiveContent content, String itemId) {
  if (content.entity(itemId)?.data case final ArmorData data) {
    return data.category == ArmorCategory.shield ? 'shield' : 'armor';
  }
  return null;
}

/// [character] avec l'objet de rang [index] équipé ou rangé. Une seule armure
/// et un seul bouclier : le précédent retourne au sac.
CharacterInput toggleEquipped(
  CharacterInput character,
  ActiveContent content,
  int index,
) {
  final target = character.items[index];
  final slot = _slotOf(content, target.itemId);
  return _withItems(character, [
    for (final (i, item) in character.items.indexed)
      if (i == index)
        item.copyWith(equipped: !item.equipped)
      else if (!target.equipped &&
          slot != null &&
          _slotOf(content, item.itemId) == slot)
        item.copyWith(equipped: false)
      else
        item,
  ]);
}

/// [character] avec l'harmonisation de l'objet de rang [index] inversée.
CharacterInput toggleAttuned(CharacterInput character, int index) =>
    _withItems(character, [
      for (final (i, item) in character.items.indexed)
        i == index ? item.copyWith(attuned: !item.attuned) : item,
    ]);

/// [character] avec [amount] pièces de [code].
CharacterInput setCoin(CharacterInput character, String code, int amount) =>
    character.copyWith(coins: {...character.coins, code: amount});
