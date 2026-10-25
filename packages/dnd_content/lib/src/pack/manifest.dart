import '../content_issue.dart';
import '../dsl/op_schemas.dart';

/// Déclaration d'attribution exigée par la licence CC-BY-4.0 du SRD 5.2.1,
/// reproduite mot pour mot (cahier §1.3).
const srdAttributionFr =
    'Cette œuvre inclut du matériel issu du System Reference Document 5.2.1 '
    '(« SRD 5.2.1 ») de Wizards of the Coast LLC, disponible à l\'adresse '
    'https://www.dndbeyond.com/srd. Le SRD 5.2.1 est régi par la Licence '
    'Creative Commons Attribution 4.0 International, disponible à l\'adresse '
    'https://creativecommons.org/licenses/by/4.0/legalcode.';

/// Provenance d'un pack (cahier §11.1).
enum PackOrigin { srd, local, imported }

/// Dépendance d'un pack vers un autre (cahier §11.1 `pack_dependency`).
typedef PackDependency = ({String id, String versionRange});

/// Manifeste d'un pack (docs/packs/FORMAT_DNDPACK.md).
final class PackManifest {
  const PackManifest({
    required this.id,
    required this.namespace,
    required this.name,
    required this.version,
    required this.origin,
    required this.author,
    required this.licence,
    required this.locale,
    this.attribution,
    this.dslVersion = 1,
    this.dependencies = const [],
    this.entityCount,
    this.checksum,
  });

  static const format = 'dndpack';
  static const formatVersion = 1;

  final String id;
  final String namespace;
  final String name;
  final String version;
  final PackOrigin origin;
  final String author;
  final String licence;
  final String? attribution;
  final int dslVersion;
  final String locale;
  final List<PackDependency> dependencies;

  /// Calculés à l'écriture de l'archive.
  final int? entityCount;
  final String? checksum;

  PackManifest withContent({
    required int entityCount,
    required String checksum,
  }) => PackManifest(
    id: id,
    namespace: namespace,
    name: name,
    version: version,
    origin: origin,
    author: author,
    licence: licence,
    locale: locale,
    attribution: attribution,
    dslVersion: dslVersion,
    dependencies: dependencies,
    entityCount: entityCount,
    checksum: checksum,
  );

  Map<String, Object?> toJson() => {
    'format': format,
    'format_version': formatVersion,
    'id': id,
    'namespace': namespace,
    'name': name,
    'version': version,
    'origin': origin.name,
    'author': author,
    'licence': licence,
    if (attribution != null) 'attribution': attribution,
    'dsl_version': dslVersion,
    'locale': locale,
    'dependencies': [
      for (final d in dependencies)
        {'id': d.id, 'version_range': d.versionRange},
    ],
    if (entityCount != null) 'entity_count': entityCount,
    if (checksum != null) 'checksum': checksum,
  };

  static final _fields = {
    'format': FieldSpec(enumField([format]), required: true),
    'format_version': FieldSpec(
      enumField(['$formatVersion']).forInt,
      required: true,
    ),
    'id': FieldSpec(
      patternField(
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
        ),
        'UUID',
      ),
      required: true,
    ),
    'namespace': FieldSpec(
      patternField(RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$'), 'namespace'),
      required: true,
    ),
    'name': FieldSpec(stringField(), required: true),
    'version': FieldSpec(
      patternField(RegExp(r'^\d+\.\d+\.\d+$'), 'version semver'),
      required: true,
    ),
    'origin': FieldSpec(
      enumField(PackOrigin.values.map((o) => o.name)),
      required: true,
    ),
    'author': FieldSpec(stringField(), required: true),
    'licence': FieldSpec(stringField(), required: true),
    'attribution': FieldSpec(stringField()),
    'dsl_version': FieldSpec(enumField(['1']).forInt, required: true),
    'locale': FieldSpec(enumField(['fr']), required: true),
    'dependencies': FieldSpec(
      listField(
        objectField({
          'id': FieldSpec(stringField(), required: true),
          'version_range': FieldSpec(stringField(), required: true),
        }),
      ),
      required: true,
    ),
    'entity_count': FieldSpec(intField()),
    'checksum': FieldSpec(
      patternField(RegExp(r'^sha256:[0-9a-f]{64}$'), 'sha256:<hex>'),
    ),
  };

  /// Lit un manifeste ; problèmes non vides si le manifeste est invalide.
  static ({PackManifest? manifest, List<ContentIssue> issues}) parse(
    Object? json,
  ) {
    if (json is! Map<String, Object?>) {
      return (
        manifest: null,
        issues: [const ContentIssue('manifest', 'objet attendu')],
      );
    }
    final issues = checkObject(json, _fields, 'manifest');
    if (issues.isNotEmpty) return (manifest: null, issues: issues);
    return (
      manifest: PackManifest(
        id: json['id']! as String,
        namespace: json['namespace']! as String,
        name: json['name']! as String,
        version: json['version']! as String,
        origin: PackOrigin.values.byName(json['origin']! as String),
        author: json['author']! as String,
        licence: json['licence']! as String,
        attribution: json['attribution'] as String?,
        dslVersion: json['dsl_version']! as int,
        locale: json['locale']! as String,
        dependencies: [
          for (final d
              in (json['dependencies']! as List<Object?>)
                  .cast<Map<String, Object?>>())
            (
              id: d['id']! as String,
              versionRange: d['version_range']! as String,
            ),
        ],
        entityCount: json['entity_count'] as int?,
        checksum: json['checksum'] as String?,
      ),
      issues: const [],
    );
  }
}

extension on FieldCheck {
  /// Compare un entier à une liste de valeurs écrites en texte.
  FieldCheck get forInt =>
      (value, path) => this(value is int ? '$value' : value, path);
}
