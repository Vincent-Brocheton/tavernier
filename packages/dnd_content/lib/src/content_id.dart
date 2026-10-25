/// Identifiant stable d'une entité de contenu : `{namespace}:{type}:{slug}`
/// (cahier §10.3), par exemple `srd:background:soldier`.
final class ContentId {
  const ContentId._(this.namespace, this.type, this.slug);

  final String namespace;
  final String type;
  final String slug;

  static final _pattern = RegExp(
    r'^([a-z0-9]+(?:-[a-z0-9]+)*):([a-z]+(?:-[a-z]+)*):([a-z0-9]+(?:-[a-z0-9]+)*)$',
  );

  static bool isValid(String value) => _pattern.hasMatch(value);

  static ContentId? tryParse(String value) {
    final match = _pattern.firstMatch(value);
    if (match == null) return null;
    return ContentId._(match[1]!, match[2]!, match[3]!);
  }

  @override
  String toString() => '$namespace:$type:$slug';

  @override
  bool operator ==(Object other) =>
      other is ContentId && other.toString() == toString();

  @override
  int get hashCode => toString().hashCode;
}
