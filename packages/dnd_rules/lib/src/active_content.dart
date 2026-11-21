import 'package:dnd_content/dnd_content.dart';

/// Contenu de règles actif : les entités des packs activés (cahier §11.2
/// `table_pack`), indexées par identifiant. Un pack plus loin dans la liste
/// remplace une entité de même identifiant.
///
/// Une entité bannie pour une table (EF-HB-10) est absente des énumérations
/// ([entities], [spellList]), donc des listes de choix ; [entity] la rend
/// toujours, pour qu'une fiche qui l'a déjà se calcule comme avant.
final class ActiveContent {
  ActiveContent(Iterable<ContentPack> packs, {Set<String> banned = const {}})
    : packs = List.unmodifiable(packs),
      banned = Set.unmodifiable(banned),
      _byId = {
        for (final pack in packs)
          for (final entity in pack.entities) '${entity.id}': entity,
      };

  /// Le même contenu, dont [ids] sont bannis.
  ActiveContent withBanned(Set<String> ids) =>
      ids.isEmpty && banned.isEmpty ? this : ActiveContent(packs, banned: ids);

  /// Le même contenu, où [entities] remplacent celles de même identifiant
  /// (contenu figé d'une fiche, EF-PJ-14).
  ActiveContent withOverrides(List<ContentEntity> entities) => entities.isEmpty
      ? this
      : ActiveContent([
          ...packs,
          ContentPack(manifest: packs.first.manifest, entities: entities),
        ], banned: banned);

  final List<ContentPack> packs;
  final Set<String> banned;
  final Map<String, ContentEntity> _byId;

  ContentEntity? entity(String id) => _byId[id];

  bool isBanned(String id) => banned.contains(id);

  Iterable<ContentEntity> get entities => banned.isEmpty
      ? _byId.values
      : _byId.values.where((e) => !banned.contains('${e.id}'));

  /// Liste de sorts de [classId] : celle de la classe, puis les sorts
  /// homebrew qui citent la classe (US-27), sans les sorts bannis.
  List<ContentId> spellList(String classId) => [
    for (final id in [
      ...?(entity(classId)?.data as ClassData?)?.spellList,
      ...?_extraSpells[classId],
    ])
      if (!banned.contains('$id')) id,
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
