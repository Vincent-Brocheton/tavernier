import 'package:dnd_content/dnd_content.dart';

/// Contenu de règles actif : les entités des packs activés (cahier §11.2
/// `table_pack`), indexées par identifiant. Un pack plus loin dans la liste
/// remplace une entité de même identifiant.
final class ActiveContent {
  ActiveContent(Iterable<ContentPack> packs)
    : packs = List.unmodifiable(packs),
      _byId = {
        for (final pack in packs)
          for (final entity in pack.entities) '${entity.id}': entity,
      };

  final List<ContentPack> packs;
  final Map<String, ContentEntity> _byId;

  ContentEntity? entity(String id) => _byId[id];

  Iterable<ContentEntity> get entities => _byId.values;

  /// Liste de sorts de [classId] : celle de la classe, puis les sorts
  /// homebrew qui citent la classe (US-27).
  List<ContentId> spellList(String classId) => [
    ...?(entity(classId)?.data as ClassData?)?.spellList,
    ...?_extraSpells[classId],
  ];

  late final Map<String, List<ContentId>> _extraSpells = () {
    final byClass = <String, List<ContentId>>{};
    for (final e in entities) {
      if (e.data case SpellData(:final classes?)) {
        for (final c in classes) {
          (byClass['$c'] ??= []).add(e.id);
        }
      }
    }
    return byClass;
  }();
}
