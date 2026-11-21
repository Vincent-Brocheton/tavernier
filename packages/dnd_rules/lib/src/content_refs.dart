// Contenu homebrew figé par fiche (US-30 lot c2, EF-PJ-14) : une fiche garde
// la version et l'instantané de chaque entité homebrew qu'elle utilise ;
// quand la table change de version, elle se calcule avec son instantané
// jusqu'à ce que son propriétaire choisisse de migrer.
import 'dart:convert';

import 'package:dnd_content/dnd_content.dart';

import 'active_content.dart';
import 'character_input.dart';

/// Référence de contenu d'une fiche (cahier §11.1 `character_content_ref`).
/// [snapshot] : `{entities: [...], kept?: version}`, `kept` étant la version
/// que le joueur a choisi de ne pas prendre.
typedef ContentRef = ({
  String entityId,
  String packId,
  String packVersion,
  Map<String, Object?> snapshot,
});

/// Entité utilisée par une fiche qui a changé dans la version du contenu.
final class ContentChange {
  const ContentChange({
    required this.ref,
    required this.toVersion,
    required this.before,
    required this.after,
  });

  final ContentRef ref;
  final String toVersion;

  /// L'entité de l'instantané de la fiche, et celle du contenu.
  final ContentEntity before;
  final ContentEntity? after;

  String get entityId => ref.entityId;
  String get fromVersion => ref.packVersion;
}

/// Entités qu'utilise [character] : origines, classes, sous-classes, dons,
/// sorts, objets et armes de ses bottes.
Set<String> usedEntityIds(CharacterInput character) => {
  character.speciesId,
  character.backgroundId,
  for (final c in character.classLevels) ...[c.classId, ?c.subclassId],
  for (final f in character.feats) f.featId,
  ...character.spells.cantrips,
  ...character.spells.prepared,
  ...character.spells.spellbook,
  for (final i in character.items) i.itemId,
  for (final w in character.weaponMasteries) w.weaponId,
};

/// Pack qui apporte chaque entité du contenu (le dernier gagne).
Map<String, PackManifest> _packOf(ActiveContent content) => {
  for (final p in content.packs)
    for (final e in p.entities) '${e.id}': p.manifest,
};

/// Instantané d'une entité et de ses aptitudes, en JSON.
Map<String, Object?> entitySnapshot(ActiveContent content, String id) => {
  'entities': [
    for (final p in content.packs)
      for (final e in p.entities)
        if ('${e.id}' == id ||
            (e.data is FeatureData &&
                '${(e.data as FeatureData).source}' == id))
          jsonDecode(jsonEncode(e.toJson())),
  ],
};

List<Object?> _entitiesOf(Map<String, Object?> snapshot) =>
    (snapshot['entities'] as List<Object?>?) ?? const [];

/// Entités figées de la fiche et changements à décider.
({List<ContentEntity> frozen, List<ContentChange> changes}) freezeContent(
  List<ContentRef> refs,
  ActiveContent content,
) {
  final versions = {
    for (final p in content.packs) p.manifest.id: p.manifest.version,
  };
  final frozen = <ContentEntity>[];
  final changes = <ContentChange>[];
  for (final ref in refs) {
    final current = versions[ref.packId];
    if (current == null || current == ref.packVersion) continue;
    final entities = [
      for (final json in _entitiesOf(ref.snapshot))
        ?parseEntity(json, 'snapshot').entity,
    ];
    frozen.addAll(entities);
    final now = entitySnapshot(content, ref.entityId);
    final before = entities.where((e) => '${e.id}' == ref.entityId).firstOrNull;
    if (before != null &&
        jsonEncode(_entitiesOf(now)) != jsonEncode(_entitiesOf(ref.snapshot)) &&
        ref.snapshot['kept'] != current) {
      changes.add(
        ContentChange(
          ref: ref,
          toVersion: current,
          before: before,
          after: content.entity(ref.entityId),
        ),
      );
    }
  }
  return (frozen: frozen, changes: changes);
}

/// Références à créer, à suivre sans rien demander (instantané identique,
/// autre version) et à retirer, pour les seules entités homebrew.
({List<ContentRef> create, List<ContentRef> follow, List<String> remove})
contentRefsToRecord(
  CharacterInput character,
  ActiveContent content,
  List<ContentRef> refs,
) {
  final packs = _packOf(content);
  final used = {
    for (final id in usedEntityIds(character))
      if (packs[id] case final pack? when pack.origin != PackOrigin.srd) id,
  };
  final known = {for (final r in refs) r.entityId: r};
  return (
    create: [
      for (final id in used)
        if (!known.containsKey(id))
          (
            entityId: id,
            packId: packs[id]!.id,
            packVersion: packs[id]!.version,
            snapshot: entitySnapshot(content, id),
          ),
    ],
    follow: [
      for (final r in refs)
        if (packs[r.entityId] case final pack?
            when used.contains(r.entityId) &&
                pack.version != r.packVersion &&
                jsonEncode(_entitiesOf(entitySnapshot(content, r.entityId))) ==
                    jsonEncode(_entitiesOf(r.snapshot)))
          (
            entityId: r.entityId,
            packId: r.packId,
            packVersion: pack.version,
            snapshot: entitySnapshot(content, r.entityId),
          ),
    ],
    remove: [
      for (final r in refs)
        if (!usedEntityIds(character).contains(r.entityId)) r.entityId,
    ],
  );
}
