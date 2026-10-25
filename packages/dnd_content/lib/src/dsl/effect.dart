import '../content_id.dart';
import '../content_issue.dart';
import 'op_schemas.dart';

/// Effet du DSL v1 : une opération, sa condition statique et ses champs.
final class Effect {
  const Effect({required this.op, this.when = const {}, this.args = const {}});

  /// À n'appeler qu'après [validateEffect].
  factory Effect.fromJson(Map<String, Object?> json) => Effect(
    op: json['op']! as String,
    when: (json['when'] as Map<String, Object?>?) ?? const {},
    args: {
      for (final MapEntry(:key, :value) in json.entries)
        if (key != 'op' && key != 'when') key: value,
    },
  );

  final String op;
  final Map<String, Object?> when;
  final Map<String, Object?> args;

  Map<String, Object?> toJson() => {
    'op': op,
    if (when.isNotEmpty) 'when': when,
    ...args,
  };
}

final _schemas = opSchemas(listField(validateEffect));

/// Les 22 opérations du DSL v1.
final Set<String> dslV1Ops = Set.unmodifiable(_schemas.keys);

/// Valide un effet JSON ; liste vide si l'effet est valide.
List<ContentIssue> validateEffect(Object? json, String path) {
  if (json is! Map<String, Object?>) {
    return [ContentIssue(path, 'objet d\'effet attendu')];
  }
  final op = json['op'];
  final schema = _schemas[op];
  if (schema == null) {
    return [ContentIssue('$path.op', 'opération inconnue du DSL v1 : $op')];
  }
  final issues = [
    ...checkObject(json, schema, path, ignored: const {'op', 'when'}),
    if (json.containsKey('when'))
      ...objectField(whenFields)(json['when'], '$path.when'),
  ];
  if (op == 'grant_proficiency' && json['ref'] is String) {
    final check = proficiencyRefChecks[json['kind']];
    if (check != null) issues.addAll(check(json['ref'], '$path.ref'));
  }
  if (fieldGroups[op] case (:final fields, :final exactlyOne)) {
    final present = fields.where(json.containsKey).length;
    if (present == 0 || (exactlyOne && present > 1)) {
      issues.add(
        ContentIssue(
          path,
          '${exactlyOne ? 'exactement un' : 'au moins un'} champ parmi ${fields.join(', ')}',
        ),
      );
    }
  }
  return issues;
}

/// Identifiants d'entités cités par un effet (hors clés de ressource).
Set<String> effectReferences(Effect effect) {
  final found = <String>{};
  void visit(Object? value) {
    switch (value) {
      case String():
        final type = ContentId.tryParse(value)?.type;
        if (type != null && type != 'resource') found.add(value);
      case Map<String, Object?>():
        value.values.forEach(visit);
      case List<Object?>():
        value.forEach(visit);
    }
  }

  visit(effect.args);
  return found;
}
