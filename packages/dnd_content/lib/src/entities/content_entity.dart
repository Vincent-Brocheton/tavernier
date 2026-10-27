import 'package:json_annotation/json_annotation.dart';

import '../content_id.dart';
import '../content_issue.dart';
import '../dsl/effect.dart';
import 'entity_data.dart';

/// Types d'entités connus du format v1.
final Set<String> entityTypes = Set.unmodifiable(dataReaders.keys);

/// Types dont le texte de règles (`text.fr`) est obligatoire.
const typesWithRequiredText = {
  'feature',
  'condition',
  'feat',
  'mastery',
  'background',
  'spell',
};

const _envelopeKeys = {
  'id',
  'type',
  'name',
  'extends_id',
  'data',
  'effects',
  'text',
};

/// Entité de contenu : enveloppe commune et données propres à son type.
final class ContentEntity {
  const ContentEntity({
    required this.id,
    required this.name,
    required this.data,
    this.extendsId,
    this.effects = const [],
    this.textFr,
  });

  final ContentId id;
  final String name;
  final ContentId? extendsId;
  final EntityData data;
  final List<Effect> effects;
  final String? textFr;

  String get type => id.type;

  Map<String, Object?> toJson() => {
    'id': '$id',
    'type': type,
    'name': name,
    if (extendsId != null) 'extends_id': '$extendsId',
    'data': data.toJson(),
    if (effects.isNotEmpty) 'effects': [for (final e in effects) e.toJson()],
    if (textFr != null) 'text': {'fr': textFr},
  };
}

/// Lit une entité JSON ; [path] préfixe les chemins des problèmes.
({ContentEntity? entity, List<ContentIssue> issues}) parseEntity(
  Object? json,
  String path,
) {
  if (json is! Map<String, Object?>) {
    return (entity: null, issues: [ContentIssue(path, 'objet attendu')]);
  }
  final issues = <ContentIssue>[
    for (final key in json.keys)
      if (!_envelopeKeys.contains(key))
        ContentIssue('$path.$key', 'champ inconnu'),
  ];

  final type = json['type'];
  final reader = dataReaders[type];
  if (reader == null) {
    issues.add(ContentIssue('$path.type', 'type d\'entité inconnu : $type'));
  }

  final rawId = json['id'];
  final id = rawId is String ? ContentId.tryParse(rawId) : null;
  if (id == null) {
    issues.add(ContentIssue('$path.id', 'identifiant de contenu attendu'));
  } else if (id.type != type) {
    issues.add(
      ContentIssue(
        '$path.id',
        'le type de l\'id (${id.type}) diffère de « $type »',
      ),
    );
  }

  final name = json['name'];
  if (name is! String || name.trim().isEmpty) {
    issues.add(ContentIssue('$path.name', 'nom non vide attendu'));
  }

  final rawExtends = json['extends_id'];
  final extendsId = rawExtends is String
      ? ContentId.tryParse(rawExtends)
      : null;
  if (rawExtends != null && extendsId == null) {
    issues.add(
      ContentIssue('$path.extends_id', 'identifiant de contenu attendu'),
    );
  }

  final rawEffects = json['effects'] ?? const <Object?>[];
  final effects = <Effect>[];
  if (rawEffects is! List<Object?>) {
    issues.add(ContentIssue('$path.effects', 'liste attendue'));
  } else {
    for (var i = 0; i < rawEffects.length; i++) {
      final effectIssues = validateEffect(rawEffects[i], '$path.effects[$i]');
      issues.addAll(effectIssues);
      if (effectIssues.isEmpty) {
        effects.add(Effect.fromJson(rawEffects[i]! as Map<String, Object?>));
      }
    }
  }

  final text = json['text'];
  String? textFr;
  if (text is Map<String, Object?> &&
      text.keys.every((k) => k == 'fr') &&
      text['fr'] is String?) {
    textFr = text['fr'] as String?;
  } else if (text != null) {
    issues.add(ContentIssue('$path.text', 'objet { "fr": texte } attendu'));
  }
  if (typesWithRequiredText.contains(type) &&
      (textFr == null || textFr.trim().isEmpty)) {
    issues.add(
      ContentIssue(
        '$path.text',
        'texte de règles (text.fr) obligatoire pour « $type »',
      ),
    );
  }

  EntityData? data;
  final rawData = json['data'] ?? const <String, Object?>{};
  if (rawData is! Map<String, Object?>) {
    issues.add(ContentIssue('$path.data', 'objet attendu'));
  } else if (reader != null) {
    try {
      data = reader(rawData);
    } on CheckedFromJsonException catch (e) {
      issues.add(ContentIssue('$path.data${_keyPath(e)}', _message(e)));
    } on UnrecognizedKeysException catch (e) {
      issues.addAll([
        for (final key in e.unrecognizedKeys)
          ContentIssue('$path.data.$key', 'champ inconnu'),
      ]);
    }
  }

  if (issues.isNotEmpty || id == null || data == null) {
    return (entity: null, issues: issues);
  }
  return (
    entity: ContentEntity(
      id: id,
      name: name! as String,
      data: data,
      extendsId: extendsId,
      effects: effects,
      textFr: textFr,
    ),
    issues: issues,
  );
}

String _keyPath(CheckedFromJsonException e) {
  return switch (e.innerError) {
    UnrecognizedKeysException(:final unrecognizedKeys) =>
      '.${unrecognizedKeys.first}',
    MissingRequiredKeysException(:final missingKeys) => '.${missingKeys.first}',
    _ => e.key == null ? '' : '.${e.key}',
  };
}

String _message(CheckedFromJsonException e) => switch (e.innerError) {
  UnrecognizedKeysException() => 'champ inconnu',
  MissingRequiredKeysException() => 'champ requis absent',
  final inner => e.message ?? '$inner',
};
