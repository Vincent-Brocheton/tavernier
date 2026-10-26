import 'package:dnd_content/dnd_content.dart';

/// Contenu de règles actif : les entités des packs activés (cahier §11.2
/// `table_pack`), indexées par identifiant. Un pack plus loin dans la liste
/// remplace une entité de même identifiant.
final class ActiveContent {
  ActiveContent(Iterable<ContentPack> packs)
    : _byId = {
        for (final pack in packs)
          for (final entity in pack.entities) '${entity.id}': entity,
      };

  final Map<String, ContentEntity> _byId;

  ContentEntity? entity(String id) => _byId[id];
}
