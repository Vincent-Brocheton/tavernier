// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class ContentSearch extends Table
    with
        TableInfo<ContentSearch, ContentSearchData>,
        VirtualTableInfo<ContentSearch, ContentSearchData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ContentSearch(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    entityId,
    type,
    packId,
    name,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_search';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentSearchData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  ContentSearchData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentSearchData(
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
    );
  }

  @override
  ContentSearch createAlias(String alias) {
    return ContentSearch(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
  @override
  String get moduleAndArgs =>
      'fts5(entity_id UNINDEXED, type UNINDEXED, pack_id UNINDEXED, name, description, tokenize = \'unicode61 remove_diacritics 2\')';
}

class ContentSearchData extends DataClass
    implements Insertable<ContentSearchData> {
  final String entityId;
  final String type;
  final String packId;
  final String name;
  final String description;
  const ContentSearchData({
    required this.entityId,
    required this.type,
    required this.packId,
    required this.name,
    required this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_id'] = Variable<String>(entityId);
    map['type'] = Variable<String>(type);
    map['pack_id'] = Variable<String>(packId);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    return map;
  }

  ContentSearchCompanion toCompanion(bool nullToAbsent) {
    return ContentSearchCompanion(
      entityId: Value(entityId),
      type: Value(type),
      packId: Value(packId),
      name: Value(name),
      description: Value(description),
    );
  }

  factory ContentSearchData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentSearchData(
      entityId: serializer.fromJson<String>(json['entity_id']),
      type: serializer.fromJson<String>(json['type']),
      packId: serializer.fromJson<String>(json['pack_id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entity_id': serializer.toJson<String>(entityId),
      'type': serializer.toJson<String>(type),
      'pack_id': serializer.toJson<String>(packId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
    };
  }

  ContentSearchData copyWith({
    String? entityId,
    String? type,
    String? packId,
    String? name,
    String? description,
  }) => ContentSearchData(
    entityId: entityId ?? this.entityId,
    type: type ?? this.type,
    packId: packId ?? this.packId,
    name: name ?? this.name,
    description: description ?? this.description,
  );
  ContentSearchData copyWithCompanion(ContentSearchCompanion data) {
    return ContentSearchData(
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      type: data.type.present ? data.type.value : this.type,
      packId: data.packId.present ? data.packId.value : this.packId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentSearchData(')
          ..write('entityId: $entityId, ')
          ..write('type: $type, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entityId, type, packId, name, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentSearchData &&
          other.entityId == this.entityId &&
          other.type == this.type &&
          other.packId == this.packId &&
          other.name == this.name &&
          other.description == this.description);
}

class ContentSearchCompanion extends UpdateCompanion<ContentSearchData> {
  final Value<String> entityId;
  final Value<String> type;
  final Value<String> packId;
  final Value<String> name;
  final Value<String> description;
  final Value<int> rowid;
  const ContentSearchCompanion({
    this.entityId = const Value.absent(),
    this.type = const Value.absent(),
    this.packId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentSearchCompanion.insert({
    required String entityId,
    required String type,
    required String packId,
    required String name,
    required String description,
    this.rowid = const Value.absent(),
  }) : entityId = Value(entityId),
       type = Value(type),
       packId = Value(packId),
       name = Value(name),
       description = Value(description);
  static Insertable<ContentSearchData> custom({
    Expression<String>? entityId,
    Expression<String>? type,
    Expression<String>? packId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityId != null) 'entity_id': entityId,
      if (type != null) 'type': type,
      if (packId != null) 'pack_id': packId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentSearchCompanion copyWith({
    Value<String>? entityId,
    Value<String>? type,
    Value<String>? packId,
    Value<String>? name,
    Value<String>? description,
    Value<int>? rowid,
  }) {
    return ContentSearchCompanion(
      entityId: entityId ?? this.entityId,
      type: type ?? this.type,
      packId: packId ?? this.packId,
      name: name ?? this.name,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentSearchCompanion(')
          ..write('entityId: $entityId, ')
          ..write('type: $type, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentPacksTable extends ContentPacks
    with TableInfo<$ContentPacksTable, ContentPackRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentPacksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namespaceMeta = const VerificationMeta(
    'namespace',
  );
  @override
  late final GeneratedColumn<String> namespace = GeneratedColumn<String>(
    'namespace',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _licenceMeta = const VerificationMeta(
    'licence',
  );
  @override
  late final GeneratedColumn<String> licence = GeneratedColumn<String>(
    'licence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attributionMeta = const VerificationMeta(
    'attribution',
  );
  @override
  late final GeneratedColumn<String> attribution = GeneratedColumn<String>(
    'attribution',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dslVersionMeta = const VerificationMeta(
    'dslVersion',
  );
  @override
  late final GeneratedColumn<int> dslVersion = GeneratedColumn<int>(
    'dsl_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checksumMeta = const VerificationMeta(
    'checksum',
  );
  @override
  late final GeneratedColumn<String> checksum = GeneratedColumn<String>(
    'checksum',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _signatureMeta = const VerificationMeta(
    'signature',
  );
  @override
  late final GeneratedColumn<String> signature = GeneratedColumn<String>(
    'signature',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    namespace,
    name,
    version,
    origin,
    author,
    licence,
    attribution,
    dslVersion,
    locale,
    checksum,
    signature,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_pack';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentPackRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('namespace')) {
      context.handle(
        _namespaceMeta,
        namespace.isAcceptableOrUnknown(data['namespace']!, _namespaceMeta),
      );
    } else if (isInserting) {
      context.missing(_namespaceMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('origin')) {
      context.handle(
        _originMeta,
        origin.isAcceptableOrUnknown(data['origin']!, _originMeta),
      );
    } else if (isInserting) {
      context.missing(_originMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('licence')) {
      context.handle(
        _licenceMeta,
        licence.isAcceptableOrUnknown(data['licence']!, _licenceMeta),
      );
    } else if (isInserting) {
      context.missing(_licenceMeta);
    }
    if (data.containsKey('attribution')) {
      context.handle(
        _attributionMeta,
        attribution.isAcceptableOrUnknown(
          data['attribution']!,
          _attributionMeta,
        ),
      );
    }
    if (data.containsKey('dsl_version')) {
      context.handle(
        _dslVersionMeta,
        dslVersion.isAcceptableOrUnknown(data['dsl_version']!, _dslVersionMeta),
      );
    } else if (isInserting) {
      context.missing(_dslVersionMeta);
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    } else if (isInserting) {
      context.missing(_localeMeta);
    }
    if (data.containsKey('checksum')) {
      context.handle(
        _checksumMeta,
        checksum.isAcceptableOrUnknown(data['checksum']!, _checksumMeta),
      );
    }
    if (data.containsKey('signature')) {
      context.handle(
        _signatureMeta,
        signature.isAcceptableOrUnknown(data['signature']!, _signatureMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContentPackRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentPackRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      namespace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}namespace'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      origin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      )!,
      licence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}licence'],
      )!,
      attribution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attribution'],
      ),
      dslVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dsl_version'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      checksum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checksum'],
      ),
      signature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signature'],
      ),
    );
  }

  @override
  $ContentPacksTable createAlias(String alias) {
    return $ContentPacksTable(attachedDatabase, alias);
  }
}

class ContentPackRow extends DataClass implements Insertable<ContentPackRow> {
  final String id;
  final String namespace;
  final String name;
  final String version;
  final String origin;
  final String author;
  final String licence;
  final String? attribution;
  final int dslVersion;
  final String locale;
  final String? checksum;
  final String? signature;
  const ContentPackRow({
    required this.id,
    required this.namespace,
    required this.name,
    required this.version,
    required this.origin,
    required this.author,
    required this.licence,
    this.attribution,
    required this.dslVersion,
    required this.locale,
    this.checksum,
    this.signature,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['namespace'] = Variable<String>(namespace);
    map['name'] = Variable<String>(name);
    map['version'] = Variable<String>(version);
    map['origin'] = Variable<String>(origin);
    map['author'] = Variable<String>(author);
    map['licence'] = Variable<String>(licence);
    if (!nullToAbsent || attribution != null) {
      map['attribution'] = Variable<String>(attribution);
    }
    map['dsl_version'] = Variable<int>(dslVersion);
    map['locale'] = Variable<String>(locale);
    if (!nullToAbsent || checksum != null) {
      map['checksum'] = Variable<String>(checksum);
    }
    if (!nullToAbsent || signature != null) {
      map['signature'] = Variable<String>(signature);
    }
    return map;
  }

  ContentPacksCompanion toCompanion(bool nullToAbsent) {
    return ContentPacksCompanion(
      id: Value(id),
      namespace: Value(namespace),
      name: Value(name),
      version: Value(version),
      origin: Value(origin),
      author: Value(author),
      licence: Value(licence),
      attribution: attribution == null && nullToAbsent
          ? const Value.absent()
          : Value(attribution),
      dslVersion: Value(dslVersion),
      locale: Value(locale),
      checksum: checksum == null && nullToAbsent
          ? const Value.absent()
          : Value(checksum),
      signature: signature == null && nullToAbsent
          ? const Value.absent()
          : Value(signature),
    );
  }

  factory ContentPackRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentPackRow(
      id: serializer.fromJson<String>(json['id']),
      namespace: serializer.fromJson<String>(json['namespace']),
      name: serializer.fromJson<String>(json['name']),
      version: serializer.fromJson<String>(json['version']),
      origin: serializer.fromJson<String>(json['origin']),
      author: serializer.fromJson<String>(json['author']),
      licence: serializer.fromJson<String>(json['licence']),
      attribution: serializer.fromJson<String?>(json['attribution']),
      dslVersion: serializer.fromJson<int>(json['dslVersion']),
      locale: serializer.fromJson<String>(json['locale']),
      checksum: serializer.fromJson<String?>(json['checksum']),
      signature: serializer.fromJson<String?>(json['signature']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'namespace': serializer.toJson<String>(namespace),
      'name': serializer.toJson<String>(name),
      'version': serializer.toJson<String>(version),
      'origin': serializer.toJson<String>(origin),
      'author': serializer.toJson<String>(author),
      'licence': serializer.toJson<String>(licence),
      'attribution': serializer.toJson<String?>(attribution),
      'dslVersion': serializer.toJson<int>(dslVersion),
      'locale': serializer.toJson<String>(locale),
      'checksum': serializer.toJson<String?>(checksum),
      'signature': serializer.toJson<String?>(signature),
    };
  }

  ContentPackRow copyWith({
    String? id,
    String? namespace,
    String? name,
    String? version,
    String? origin,
    String? author,
    String? licence,
    Value<String?> attribution = const Value.absent(),
    int? dslVersion,
    String? locale,
    Value<String?> checksum = const Value.absent(),
    Value<String?> signature = const Value.absent(),
  }) => ContentPackRow(
    id: id ?? this.id,
    namespace: namespace ?? this.namespace,
    name: name ?? this.name,
    version: version ?? this.version,
    origin: origin ?? this.origin,
    author: author ?? this.author,
    licence: licence ?? this.licence,
    attribution: attribution.present ? attribution.value : this.attribution,
    dslVersion: dslVersion ?? this.dslVersion,
    locale: locale ?? this.locale,
    checksum: checksum.present ? checksum.value : this.checksum,
    signature: signature.present ? signature.value : this.signature,
  );
  ContentPackRow copyWithCompanion(ContentPacksCompanion data) {
    return ContentPackRow(
      id: data.id.present ? data.id.value : this.id,
      namespace: data.namespace.present ? data.namespace.value : this.namespace,
      name: data.name.present ? data.name.value : this.name,
      version: data.version.present ? data.version.value : this.version,
      origin: data.origin.present ? data.origin.value : this.origin,
      author: data.author.present ? data.author.value : this.author,
      licence: data.licence.present ? data.licence.value : this.licence,
      attribution: data.attribution.present
          ? data.attribution.value
          : this.attribution,
      dslVersion: data.dslVersion.present
          ? data.dslVersion.value
          : this.dslVersion,
      locale: data.locale.present ? data.locale.value : this.locale,
      checksum: data.checksum.present ? data.checksum.value : this.checksum,
      signature: data.signature.present ? data.signature.value : this.signature,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentPackRow(')
          ..write('id: $id, ')
          ..write('namespace: $namespace, ')
          ..write('name: $name, ')
          ..write('version: $version, ')
          ..write('origin: $origin, ')
          ..write('author: $author, ')
          ..write('licence: $licence, ')
          ..write('attribution: $attribution, ')
          ..write('dslVersion: $dslVersion, ')
          ..write('locale: $locale, ')
          ..write('checksum: $checksum, ')
          ..write('signature: $signature')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    namespace,
    name,
    version,
    origin,
    author,
    licence,
    attribution,
    dslVersion,
    locale,
    checksum,
    signature,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentPackRow &&
          other.id == this.id &&
          other.namespace == this.namespace &&
          other.name == this.name &&
          other.version == this.version &&
          other.origin == this.origin &&
          other.author == this.author &&
          other.licence == this.licence &&
          other.attribution == this.attribution &&
          other.dslVersion == this.dslVersion &&
          other.locale == this.locale &&
          other.checksum == this.checksum &&
          other.signature == this.signature);
}

class ContentPacksCompanion extends UpdateCompanion<ContentPackRow> {
  final Value<String> id;
  final Value<String> namespace;
  final Value<String> name;
  final Value<String> version;
  final Value<String> origin;
  final Value<String> author;
  final Value<String> licence;
  final Value<String?> attribution;
  final Value<int> dslVersion;
  final Value<String> locale;
  final Value<String?> checksum;
  final Value<String?> signature;
  final Value<int> rowid;
  const ContentPacksCompanion({
    this.id = const Value.absent(),
    this.namespace = const Value.absent(),
    this.name = const Value.absent(),
    this.version = const Value.absent(),
    this.origin = const Value.absent(),
    this.author = const Value.absent(),
    this.licence = const Value.absent(),
    this.attribution = const Value.absent(),
    this.dslVersion = const Value.absent(),
    this.locale = const Value.absent(),
    this.checksum = const Value.absent(),
    this.signature = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentPacksCompanion.insert({
    required String id,
    required String namespace,
    required String name,
    required String version,
    required String origin,
    required String author,
    required String licence,
    this.attribution = const Value.absent(),
    required int dslVersion,
    required String locale,
    this.checksum = const Value.absent(),
    this.signature = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       namespace = Value(namespace),
       name = Value(name),
       version = Value(version),
       origin = Value(origin),
       author = Value(author),
       licence = Value(licence),
       dslVersion = Value(dslVersion),
       locale = Value(locale);
  static Insertable<ContentPackRow> custom({
    Expression<String>? id,
    Expression<String>? namespace,
    Expression<String>? name,
    Expression<String>? version,
    Expression<String>? origin,
    Expression<String>? author,
    Expression<String>? licence,
    Expression<String>? attribution,
    Expression<int>? dslVersion,
    Expression<String>? locale,
    Expression<String>? checksum,
    Expression<String>? signature,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (namespace != null) 'namespace': namespace,
      if (name != null) 'name': name,
      if (version != null) 'version': version,
      if (origin != null) 'origin': origin,
      if (author != null) 'author': author,
      if (licence != null) 'licence': licence,
      if (attribution != null) 'attribution': attribution,
      if (dslVersion != null) 'dsl_version': dslVersion,
      if (locale != null) 'locale': locale,
      if (checksum != null) 'checksum': checksum,
      if (signature != null) 'signature': signature,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentPacksCompanion copyWith({
    Value<String>? id,
    Value<String>? namespace,
    Value<String>? name,
    Value<String>? version,
    Value<String>? origin,
    Value<String>? author,
    Value<String>? licence,
    Value<String?>? attribution,
    Value<int>? dslVersion,
    Value<String>? locale,
    Value<String?>? checksum,
    Value<String?>? signature,
    Value<int>? rowid,
  }) {
    return ContentPacksCompanion(
      id: id ?? this.id,
      namespace: namespace ?? this.namespace,
      name: name ?? this.name,
      version: version ?? this.version,
      origin: origin ?? this.origin,
      author: author ?? this.author,
      licence: licence ?? this.licence,
      attribution: attribution ?? this.attribution,
      dslVersion: dslVersion ?? this.dslVersion,
      locale: locale ?? this.locale,
      checksum: checksum ?? this.checksum,
      signature: signature ?? this.signature,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (namespace.present) {
      map['namespace'] = Variable<String>(namespace.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (licence.present) {
      map['licence'] = Variable<String>(licence.value);
    }
    if (attribution.present) {
      map['attribution'] = Variable<String>(attribution.value);
    }
    if (dslVersion.present) {
      map['dsl_version'] = Variable<int>(dslVersion.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (checksum.present) {
      map['checksum'] = Variable<String>(checksum.value);
    }
    if (signature.present) {
      map['signature'] = Variable<String>(signature.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentPacksCompanion(')
          ..write('id: $id, ')
          ..write('namespace: $namespace, ')
          ..write('name: $name, ')
          ..write('version: $version, ')
          ..write('origin: $origin, ')
          ..write('author: $author, ')
          ..write('licence: $licence, ')
          ..write('attribution: $attribution, ')
          ..write('dslVersion: $dslVersion, ')
          ..write('locale: $locale, ')
          ..write('checksum: $checksum, ')
          ..write('signature: $signature, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PackDependenciesTable extends PackDependencies
    with TableInfo<$PackDependenciesTable, PackDependencyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PackDependenciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dependsOnPackIdMeta = const VerificationMeta(
    'dependsOnPackId',
  );
  @override
  late final GeneratedColumn<String> dependsOnPackId = GeneratedColumn<String>(
    'depends_on_pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionRangeMeta = const VerificationMeta(
    'versionRange',
  );
  @override
  late final GeneratedColumn<String> versionRange = GeneratedColumn<String>(
    'version_range',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [packId, dependsOnPackId, versionRange];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pack_dependency';
  @override
  VerificationContext validateIntegrity(
    Insertable<PackDependencyRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('depends_on_pack_id')) {
      context.handle(
        _dependsOnPackIdMeta,
        dependsOnPackId.isAcceptableOrUnknown(
          data['depends_on_pack_id']!,
          _dependsOnPackIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dependsOnPackIdMeta);
    }
    if (data.containsKey('version_range')) {
      context.handle(
        _versionRangeMeta,
        versionRange.isAcceptableOrUnknown(
          data['version_range']!,
          _versionRangeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_versionRangeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {packId, dependsOnPackId};
  @override
  PackDependencyRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PackDependencyRow(
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      dependsOnPackId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}depends_on_pack_id'],
      )!,
      versionRange: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version_range'],
      )!,
    );
  }

  @override
  $PackDependenciesTable createAlias(String alias) {
    return $PackDependenciesTable(attachedDatabase, alias);
  }
}

class PackDependencyRow extends DataClass
    implements Insertable<PackDependencyRow> {
  final String packId;
  final String dependsOnPackId;
  final String versionRange;
  const PackDependencyRow({
    required this.packId,
    required this.dependsOnPackId,
    required this.versionRange,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pack_id'] = Variable<String>(packId);
    map['depends_on_pack_id'] = Variable<String>(dependsOnPackId);
    map['version_range'] = Variable<String>(versionRange);
    return map;
  }

  PackDependenciesCompanion toCompanion(bool nullToAbsent) {
    return PackDependenciesCompanion(
      packId: Value(packId),
      dependsOnPackId: Value(dependsOnPackId),
      versionRange: Value(versionRange),
    );
  }

  factory PackDependencyRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PackDependencyRow(
      packId: serializer.fromJson<String>(json['packId']),
      dependsOnPackId: serializer.fromJson<String>(json['dependsOnPackId']),
      versionRange: serializer.fromJson<String>(json['versionRange']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packId': serializer.toJson<String>(packId),
      'dependsOnPackId': serializer.toJson<String>(dependsOnPackId),
      'versionRange': serializer.toJson<String>(versionRange),
    };
  }

  PackDependencyRow copyWith({
    String? packId,
    String? dependsOnPackId,
    String? versionRange,
  }) => PackDependencyRow(
    packId: packId ?? this.packId,
    dependsOnPackId: dependsOnPackId ?? this.dependsOnPackId,
    versionRange: versionRange ?? this.versionRange,
  );
  PackDependencyRow copyWithCompanion(PackDependenciesCompanion data) {
    return PackDependencyRow(
      packId: data.packId.present ? data.packId.value : this.packId,
      dependsOnPackId: data.dependsOnPackId.present
          ? data.dependsOnPackId.value
          : this.dependsOnPackId,
      versionRange: data.versionRange.present
          ? data.versionRange.value
          : this.versionRange,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PackDependencyRow(')
          ..write('packId: $packId, ')
          ..write('dependsOnPackId: $dependsOnPackId, ')
          ..write('versionRange: $versionRange')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(packId, dependsOnPackId, versionRange);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PackDependencyRow &&
          other.packId == this.packId &&
          other.dependsOnPackId == this.dependsOnPackId &&
          other.versionRange == this.versionRange);
}

class PackDependenciesCompanion extends UpdateCompanion<PackDependencyRow> {
  final Value<String> packId;
  final Value<String> dependsOnPackId;
  final Value<String> versionRange;
  final Value<int> rowid;
  const PackDependenciesCompanion({
    this.packId = const Value.absent(),
    this.dependsOnPackId = const Value.absent(),
    this.versionRange = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PackDependenciesCompanion.insert({
    required String packId,
    required String dependsOnPackId,
    required String versionRange,
    this.rowid = const Value.absent(),
  }) : packId = Value(packId),
       dependsOnPackId = Value(dependsOnPackId),
       versionRange = Value(versionRange);
  static Insertable<PackDependencyRow> custom({
    Expression<String>? packId,
    Expression<String>? dependsOnPackId,
    Expression<String>? versionRange,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packId != null) 'pack_id': packId,
      if (dependsOnPackId != null) 'depends_on_pack_id': dependsOnPackId,
      if (versionRange != null) 'version_range': versionRange,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PackDependenciesCompanion copyWith({
    Value<String>? packId,
    Value<String>? dependsOnPackId,
    Value<String>? versionRange,
    Value<int>? rowid,
  }) {
    return PackDependenciesCompanion(
      packId: packId ?? this.packId,
      dependsOnPackId: dependsOnPackId ?? this.dependsOnPackId,
      versionRange: versionRange ?? this.versionRange,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (dependsOnPackId.present) {
      map['depends_on_pack_id'] = Variable<String>(dependsOnPackId.value);
    }
    if (versionRange.present) {
      map['version_range'] = Variable<String>(versionRange.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PackDependenciesCompanion(')
          ..write('packId: $packId, ')
          ..write('dependsOnPackId: $dependsOnPackId, ')
          ..write('versionRange: $versionRange, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AbilitiesTable extends Abilities
    with TableInfo<$AbilitiesTable, AbilityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AbilitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extendsIdMeta = const VerificationMeta(
    'extendsId',
  );
  @override
  late final GeneratedColumn<String> extendsId = GeneratedColumn<String>(
    'extends_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _abbreviationMeta = const VerificationMeta(
    'abbreviation',
  );
  @override
  late final GeneratedColumn<String> abbreviation = GeneratedColumn<String>(
    'abbreviation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packId,
    name,
    extendsId,
    abbreviation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ability';
  @override
  VerificationContext validateIntegrity(
    Insertable<AbilityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('extends_id')) {
      context.handle(
        _extendsIdMeta,
        extendsId.isAcceptableOrUnknown(data['extends_id']!, _extendsIdMeta),
      );
    }
    if (data.containsKey('abbreviation')) {
      context.handle(
        _abbreviationMeta,
        abbreviation.isAcceptableOrUnknown(
          data['abbreviation']!,
          _abbreviationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_abbreviationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AbilityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AbilityRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      extendsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extends_id'],
      ),
      abbreviation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}abbreviation'],
      )!,
    );
  }

  @override
  $AbilitiesTable createAlias(String alias) {
    return $AbilitiesTable(attachedDatabase, alias);
  }
}

class AbilityRow extends DataClass implements Insertable<AbilityRow> {
  final String id;
  final String packId;
  final String name;
  final String? extendsId;
  final String abbreviation;
  const AbilityRow({
    required this.id,
    required this.packId,
    required this.name,
    this.extendsId,
    required this.abbreviation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || extendsId != null) {
      map['extends_id'] = Variable<String>(extendsId);
    }
    map['abbreviation'] = Variable<String>(abbreviation);
    return map;
  }

  AbilitiesCompanion toCompanion(bool nullToAbsent) {
    return AbilitiesCompanion(
      id: Value(id),
      packId: Value(packId),
      name: Value(name),
      extendsId: extendsId == null && nullToAbsent
          ? const Value.absent()
          : Value(extendsId),
      abbreviation: Value(abbreviation),
    );
  }

  factory AbilityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AbilityRow(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      name: serializer.fromJson<String>(json['name']),
      extendsId: serializer.fromJson<String?>(json['extendsId']),
      abbreviation: serializer.fromJson<String>(json['abbreviation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'name': serializer.toJson<String>(name),
      'extendsId': serializer.toJson<String?>(extendsId),
      'abbreviation': serializer.toJson<String>(abbreviation),
    };
  }

  AbilityRow copyWith({
    String? id,
    String? packId,
    String? name,
    Value<String?> extendsId = const Value.absent(),
    String? abbreviation,
  }) => AbilityRow(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    name: name ?? this.name,
    extendsId: extendsId.present ? extendsId.value : this.extendsId,
    abbreviation: abbreviation ?? this.abbreviation,
  );
  AbilityRow copyWithCompanion(AbilitiesCompanion data) {
    return AbilityRow(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      name: data.name.present ? data.name.value : this.name,
      extendsId: data.extendsId.present ? data.extendsId.value : this.extendsId,
      abbreviation: data.abbreviation.present
          ? data.abbreviation.value
          : this.abbreviation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AbilityRow(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('abbreviation: $abbreviation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, packId, name, extendsId, abbreviation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AbilityRow &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.name == this.name &&
          other.extendsId == this.extendsId &&
          other.abbreviation == this.abbreviation);
}

class AbilitiesCompanion extends UpdateCompanion<AbilityRow> {
  final Value<String> id;
  final Value<String> packId;
  final Value<String> name;
  final Value<String?> extendsId;
  final Value<String> abbreviation;
  final Value<int> rowid;
  const AbilitiesCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.name = const Value.absent(),
    this.extendsId = const Value.absent(),
    this.abbreviation = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AbilitiesCompanion.insert({
    required String id,
    required String packId,
    required String name,
    this.extendsId = const Value.absent(),
    required String abbreviation,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       name = Value(name),
       abbreviation = Value(abbreviation);
  static Insertable<AbilityRow> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<String>? name,
    Expression<String>? extendsId,
    Expression<String>? abbreviation,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (name != null) 'name': name,
      if (extendsId != null) 'extends_id': extendsId,
      if (abbreviation != null) 'abbreviation': abbreviation,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AbilitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<String>? name,
    Value<String?>? extendsId,
    Value<String>? abbreviation,
    Value<int>? rowid,
  }) {
    return AbilitiesCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      name: name ?? this.name,
      extendsId: extendsId ?? this.extendsId,
      abbreviation: abbreviation ?? this.abbreviation,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (extendsId.present) {
      map['extends_id'] = Variable<String>(extendsId.value);
    }
    if (abbreviation.present) {
      map['abbreviation'] = Variable<String>(abbreviation.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AbilitiesCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('abbreviation: $abbreviation, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SkillsTable extends Skills with TableInfo<$SkillsTable, SkillRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SkillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extendsIdMeta = const VerificationMeta(
    'extendsId',
  );
  @override
  late final GeneratedColumn<String> extendsId = GeneratedColumn<String>(
    'extends_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _abilityIdMeta = const VerificationMeta(
    'abilityId',
  );
  @override
  late final GeneratedColumn<String> abilityId = GeneratedColumn<String>(
    'ability_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packId,
    name,
    extendsId,
    abilityId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'skill';
  @override
  VerificationContext validateIntegrity(
    Insertable<SkillRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('extends_id')) {
      context.handle(
        _extendsIdMeta,
        extendsId.isAcceptableOrUnknown(data['extends_id']!, _extendsIdMeta),
      );
    }
    if (data.containsKey('ability_id')) {
      context.handle(
        _abilityIdMeta,
        abilityId.isAcceptableOrUnknown(data['ability_id']!, _abilityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_abilityIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SkillRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SkillRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      extendsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extends_id'],
      ),
      abilityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ability_id'],
      )!,
    );
  }

  @override
  $SkillsTable createAlias(String alias) {
    return $SkillsTable(attachedDatabase, alias);
  }
}

class SkillRow extends DataClass implements Insertable<SkillRow> {
  final String id;
  final String packId;
  final String name;
  final String? extendsId;
  final String abilityId;
  const SkillRow({
    required this.id,
    required this.packId,
    required this.name,
    this.extendsId,
    required this.abilityId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || extendsId != null) {
      map['extends_id'] = Variable<String>(extendsId);
    }
    map['ability_id'] = Variable<String>(abilityId);
    return map;
  }

  SkillsCompanion toCompanion(bool nullToAbsent) {
    return SkillsCompanion(
      id: Value(id),
      packId: Value(packId),
      name: Value(name),
      extendsId: extendsId == null && nullToAbsent
          ? const Value.absent()
          : Value(extendsId),
      abilityId: Value(abilityId),
    );
  }

  factory SkillRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SkillRow(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      name: serializer.fromJson<String>(json['name']),
      extendsId: serializer.fromJson<String?>(json['extendsId']),
      abilityId: serializer.fromJson<String>(json['abilityId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'name': serializer.toJson<String>(name),
      'extendsId': serializer.toJson<String?>(extendsId),
      'abilityId': serializer.toJson<String>(abilityId),
    };
  }

  SkillRow copyWith({
    String? id,
    String? packId,
    String? name,
    Value<String?> extendsId = const Value.absent(),
    String? abilityId,
  }) => SkillRow(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    name: name ?? this.name,
    extendsId: extendsId.present ? extendsId.value : this.extendsId,
    abilityId: abilityId ?? this.abilityId,
  );
  SkillRow copyWithCompanion(SkillsCompanion data) {
    return SkillRow(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      name: data.name.present ? data.name.value : this.name,
      extendsId: data.extendsId.present ? data.extendsId.value : this.extendsId,
      abilityId: data.abilityId.present ? data.abilityId.value : this.abilityId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SkillRow(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('abilityId: $abilityId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, packId, name, extendsId, abilityId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SkillRow &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.name == this.name &&
          other.extendsId == this.extendsId &&
          other.abilityId == this.abilityId);
}

class SkillsCompanion extends UpdateCompanion<SkillRow> {
  final Value<String> id;
  final Value<String> packId;
  final Value<String> name;
  final Value<String?> extendsId;
  final Value<String> abilityId;
  final Value<int> rowid;
  const SkillsCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.name = const Value.absent(),
    this.extendsId = const Value.absent(),
    this.abilityId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SkillsCompanion.insert({
    required String id,
    required String packId,
    required String name,
    this.extendsId = const Value.absent(),
    required String abilityId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       name = Value(name),
       abilityId = Value(abilityId);
  static Insertable<SkillRow> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<String>? name,
    Expression<String>? extendsId,
    Expression<String>? abilityId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (name != null) 'name': name,
      if (extendsId != null) 'extends_id': extendsId,
      if (abilityId != null) 'ability_id': abilityId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SkillsCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<String>? name,
    Value<String?>? extendsId,
    Value<String>? abilityId,
    Value<int>? rowid,
  }) {
    return SkillsCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      name: name ?? this.name,
      extendsId: extendsId ?? this.extendsId,
      abilityId: abilityId ?? this.abilityId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (extendsId.present) {
      map['extends_id'] = Variable<String>(extendsId.value);
    }
    if (abilityId.present) {
      map['ability_id'] = Variable<String>(abilityId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SkillsCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('abilityId: $abilityId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LanguagesTable extends Languages
    with TableInfo<$LanguagesTable, LanguageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LanguagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extendsIdMeta = const VerificationMeta(
    'extendsId',
  );
  @override
  late final GeneratedColumn<String> extendsId = GeneratedColumn<String>(
    'extends_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, packId, name, extendsId, category];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'language';
  @override
  VerificationContext validateIntegrity(
    Insertable<LanguageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('extends_id')) {
      context.handle(
        _extendsIdMeta,
        extendsId.isAcceptableOrUnknown(data['extends_id']!, _extendsIdMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LanguageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LanguageRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      extendsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extends_id'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
    );
  }

  @override
  $LanguagesTable createAlias(String alias) {
    return $LanguagesTable(attachedDatabase, alias);
  }
}

class LanguageRow extends DataClass implements Insertable<LanguageRow> {
  final String id;
  final String packId;
  final String name;
  final String? extendsId;
  final String category;
  const LanguageRow({
    required this.id,
    required this.packId,
    required this.name,
    this.extendsId,
    required this.category,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || extendsId != null) {
      map['extends_id'] = Variable<String>(extendsId);
    }
    map['category'] = Variable<String>(category);
    return map;
  }

  LanguagesCompanion toCompanion(bool nullToAbsent) {
    return LanguagesCompanion(
      id: Value(id),
      packId: Value(packId),
      name: Value(name),
      extendsId: extendsId == null && nullToAbsent
          ? const Value.absent()
          : Value(extendsId),
      category: Value(category),
    );
  }

  factory LanguageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LanguageRow(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      name: serializer.fromJson<String>(json['name']),
      extendsId: serializer.fromJson<String?>(json['extendsId']),
      category: serializer.fromJson<String>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'name': serializer.toJson<String>(name),
      'extendsId': serializer.toJson<String?>(extendsId),
      'category': serializer.toJson<String>(category),
    };
  }

  LanguageRow copyWith({
    String? id,
    String? packId,
    String? name,
    Value<String?> extendsId = const Value.absent(),
    String? category,
  }) => LanguageRow(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    name: name ?? this.name,
    extendsId: extendsId.present ? extendsId.value : this.extendsId,
    category: category ?? this.category,
  );
  LanguageRow copyWithCompanion(LanguagesCompanion data) {
    return LanguageRow(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      name: data.name.present ? data.name.value : this.name,
      extendsId: data.extendsId.present ? data.extendsId.value : this.extendsId,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LanguageRow(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, packId, name, extendsId, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LanguageRow &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.name == this.name &&
          other.extendsId == this.extendsId &&
          other.category == this.category);
}

class LanguagesCompanion extends UpdateCompanion<LanguageRow> {
  final Value<String> id;
  final Value<String> packId;
  final Value<String> name;
  final Value<String?> extendsId;
  final Value<String> category;
  final Value<int> rowid;
  const LanguagesCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.name = const Value.absent(),
    this.extendsId = const Value.absent(),
    this.category = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LanguagesCompanion.insert({
    required String id,
    required String packId,
    required String name,
    this.extendsId = const Value.absent(),
    required String category,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       name = Value(name),
       category = Value(category);
  static Insertable<LanguageRow> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<String>? name,
    Expression<String>? extendsId,
    Expression<String>? category,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (name != null) 'name': name,
      if (extendsId != null) 'extends_id': extendsId,
      if (category != null) 'category': category,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LanguagesCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<String>? name,
    Value<String?>? extendsId,
    Value<String>? category,
    Value<int>? rowid,
  }) {
    return LanguagesCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      name: name ?? this.name,
      extendsId: extendsId ?? this.extendsId,
      category: category ?? this.category,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (extendsId.present) {
      map['extends_id'] = Variable<String>(extendsId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LanguagesCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('category: $category, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConditionsTable extends Conditions
    with TableInfo<$ConditionsTable, ConditionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConditionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extendsIdMeta = const VerificationMeta(
    'extendsId',
  );
  @override
  late final GeneratedColumn<String> extendsId = GeneratedColumn<String>(
    'extends_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, packId, name, extendsId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'condition';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConditionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('extends_id')) {
      context.handle(
        _extendsIdMeta,
        extendsId.isAcceptableOrUnknown(data['extends_id']!, _extendsIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConditionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConditionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      extendsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extends_id'],
      ),
    );
  }

  @override
  $ConditionsTable createAlias(String alias) {
    return $ConditionsTable(attachedDatabase, alias);
  }
}

class ConditionRow extends DataClass implements Insertable<ConditionRow> {
  final String id;
  final String packId;
  final String name;
  final String? extendsId;
  const ConditionRow({
    required this.id,
    required this.packId,
    required this.name,
    this.extendsId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || extendsId != null) {
      map['extends_id'] = Variable<String>(extendsId);
    }
    return map;
  }

  ConditionsCompanion toCompanion(bool nullToAbsent) {
    return ConditionsCompanion(
      id: Value(id),
      packId: Value(packId),
      name: Value(name),
      extendsId: extendsId == null && nullToAbsent
          ? const Value.absent()
          : Value(extendsId),
    );
  }

  factory ConditionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConditionRow(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      name: serializer.fromJson<String>(json['name']),
      extendsId: serializer.fromJson<String?>(json['extendsId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'name': serializer.toJson<String>(name),
      'extendsId': serializer.toJson<String?>(extendsId),
    };
  }

  ConditionRow copyWith({
    String? id,
    String? packId,
    String? name,
    Value<String?> extendsId = const Value.absent(),
  }) => ConditionRow(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    name: name ?? this.name,
    extendsId: extendsId.present ? extendsId.value : this.extendsId,
  );
  ConditionRow copyWithCompanion(ConditionsCompanion data) {
    return ConditionRow(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      name: data.name.present ? data.name.value : this.name,
      extendsId: data.extendsId.present ? data.extendsId.value : this.extendsId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConditionRow(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, packId, name, extendsId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConditionRow &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.name == this.name &&
          other.extendsId == this.extendsId);
}

class ConditionsCompanion extends UpdateCompanion<ConditionRow> {
  final Value<String> id;
  final Value<String> packId;
  final Value<String> name;
  final Value<String?> extendsId;
  final Value<int> rowid;
  const ConditionsCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.name = const Value.absent(),
    this.extendsId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConditionsCompanion.insert({
    required String id,
    required String packId,
    required String name,
    this.extendsId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       name = Value(name);
  static Insertable<ConditionRow> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<String>? name,
    Expression<String>? extendsId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (name != null) 'name': name,
      if (extendsId != null) 'extends_id': extendsId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConditionsCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<String>? name,
    Value<String?>? extendsId,
    Value<int>? rowid,
  }) {
    return ConditionsCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      name: name ?? this.name,
      extendsId: extendsId ?? this.extendsId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (extendsId.present) {
      map['extends_id'] = Variable<String>(extendsId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConditionsCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DamageTypesTable extends DamageTypes
    with TableInfo<$DamageTypesTable, DamageTypeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DamageTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extendsIdMeta = const VerificationMeta(
    'extendsId',
  );
  @override
  late final GeneratedColumn<String> extendsId = GeneratedColumn<String>(
    'extends_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, packId, name, extendsId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'damage_type';
  @override
  VerificationContext validateIntegrity(
    Insertable<DamageTypeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('extends_id')) {
      context.handle(
        _extendsIdMeta,
        extendsId.isAcceptableOrUnknown(data['extends_id']!, _extendsIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DamageTypeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DamageTypeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      extendsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extends_id'],
      ),
    );
  }

  @override
  $DamageTypesTable createAlias(String alias) {
    return $DamageTypesTable(attachedDatabase, alias);
  }
}

class DamageTypeRow extends DataClass implements Insertable<DamageTypeRow> {
  final String id;
  final String packId;
  final String name;
  final String? extendsId;
  const DamageTypeRow({
    required this.id,
    required this.packId,
    required this.name,
    this.extendsId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || extendsId != null) {
      map['extends_id'] = Variable<String>(extendsId);
    }
    return map;
  }

  DamageTypesCompanion toCompanion(bool nullToAbsent) {
    return DamageTypesCompanion(
      id: Value(id),
      packId: Value(packId),
      name: Value(name),
      extendsId: extendsId == null && nullToAbsent
          ? const Value.absent()
          : Value(extendsId),
    );
  }

  factory DamageTypeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DamageTypeRow(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      name: serializer.fromJson<String>(json['name']),
      extendsId: serializer.fromJson<String?>(json['extendsId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'name': serializer.toJson<String>(name),
      'extendsId': serializer.toJson<String?>(extendsId),
    };
  }

  DamageTypeRow copyWith({
    String? id,
    String? packId,
    String? name,
    Value<String?> extendsId = const Value.absent(),
  }) => DamageTypeRow(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    name: name ?? this.name,
    extendsId: extendsId.present ? extendsId.value : this.extendsId,
  );
  DamageTypeRow copyWithCompanion(DamageTypesCompanion data) {
    return DamageTypeRow(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      name: data.name.present ? data.name.value : this.name,
      extendsId: data.extendsId.present ? data.extendsId.value : this.extendsId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DamageTypeRow(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, packId, name, extendsId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DamageTypeRow &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.name == this.name &&
          other.extendsId == this.extendsId);
}

class DamageTypesCompanion extends UpdateCompanion<DamageTypeRow> {
  final Value<String> id;
  final Value<String> packId;
  final Value<String> name;
  final Value<String?> extendsId;
  final Value<int> rowid;
  const DamageTypesCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.name = const Value.absent(),
    this.extendsId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DamageTypesCompanion.insert({
    required String id,
    required String packId,
    required String name,
    this.extendsId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       name = Value(name);
  static Insertable<DamageTypeRow> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<String>? name,
    Expression<String>? extendsId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (name != null) 'name': name,
      if (extendsId != null) 'extends_id': extendsId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DamageTypesCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<String>? name,
    Value<String?>? extendsId,
    Value<int>? rowid,
  }) {
    return DamageTypesCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      name: name ?? this.name,
      extendsId: extendsId ?? this.extendsId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (extendsId.present) {
      map['extends_id'] = Variable<String>(extendsId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DamageTypesCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MasteryPropertiesTable extends MasteryProperties
    with TableInfo<$MasteryPropertiesTable, MasteryPropertyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MasteryPropertiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extendsIdMeta = const VerificationMeta(
    'extendsId',
  );
  @override
  late final GeneratedColumn<String> extendsId = GeneratedColumn<String>(
    'extends_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, packId, name, extendsId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mastery_property';
  @override
  VerificationContext validateIntegrity(
    Insertable<MasteryPropertyRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('extends_id')) {
      context.handle(
        _extendsIdMeta,
        extendsId.isAcceptableOrUnknown(data['extends_id']!, _extendsIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MasteryPropertyRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MasteryPropertyRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      extendsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extends_id'],
      ),
    );
  }

  @override
  $MasteryPropertiesTable createAlias(String alias) {
    return $MasteryPropertiesTable(attachedDatabase, alias);
  }
}

class MasteryPropertyRow extends DataClass
    implements Insertable<MasteryPropertyRow> {
  final String id;
  final String packId;
  final String name;
  final String? extendsId;
  const MasteryPropertyRow({
    required this.id,
    required this.packId,
    required this.name,
    this.extendsId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || extendsId != null) {
      map['extends_id'] = Variable<String>(extendsId);
    }
    return map;
  }

  MasteryPropertiesCompanion toCompanion(bool nullToAbsent) {
    return MasteryPropertiesCompanion(
      id: Value(id),
      packId: Value(packId),
      name: Value(name),
      extendsId: extendsId == null && nullToAbsent
          ? const Value.absent()
          : Value(extendsId),
    );
  }

  factory MasteryPropertyRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MasteryPropertyRow(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      name: serializer.fromJson<String>(json['name']),
      extendsId: serializer.fromJson<String?>(json['extendsId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'name': serializer.toJson<String>(name),
      'extendsId': serializer.toJson<String?>(extendsId),
    };
  }

  MasteryPropertyRow copyWith({
    String? id,
    String? packId,
    String? name,
    Value<String?> extendsId = const Value.absent(),
  }) => MasteryPropertyRow(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    name: name ?? this.name,
    extendsId: extendsId.present ? extendsId.value : this.extendsId,
  );
  MasteryPropertyRow copyWithCompanion(MasteryPropertiesCompanion data) {
    return MasteryPropertyRow(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      name: data.name.present ? data.name.value : this.name,
      extendsId: data.extendsId.present ? data.extendsId.value : this.extendsId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MasteryPropertyRow(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, packId, name, extendsId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MasteryPropertyRow &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.name == this.name &&
          other.extendsId == this.extendsId);
}

class MasteryPropertiesCompanion extends UpdateCompanion<MasteryPropertyRow> {
  final Value<String> id;
  final Value<String> packId;
  final Value<String> name;
  final Value<String?> extendsId;
  final Value<int> rowid;
  const MasteryPropertiesCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.name = const Value.absent(),
    this.extendsId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MasteryPropertiesCompanion.insert({
    required String id,
    required String packId,
    required String name,
    this.extendsId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       name = Value(name);
  static Insertable<MasteryPropertyRow> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<String>? name,
    Expression<String>? extendsId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (name != null) 'name': name,
      if (extendsId != null) 'extends_id': extendsId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MasteryPropertiesCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<String>? name,
    Value<String?>? extendsId,
    Value<int>? rowid,
  }) {
    return MasteryPropertiesCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      name: name ?? this.name,
      extendsId: extendsId ?? this.extendsId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (extendsId.present) {
      map['extends_id'] = Variable<String>(extendsId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MasteryPropertiesCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeaponsTable extends Weapons with TableInfo<$WeaponsTable, WeaponRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeaponsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extendsIdMeta = const VerificationMeta(
    'extendsId',
  );
  @override
  late final GeneratedColumn<String> extendsId = GeneratedColumn<String>(
    'extends_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _damageMeta = const VerificationMeta('damage');
  @override
  late final GeneratedColumn<String> damage = GeneratedColumn<String>(
    'damage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _damageTypeIdMeta = const VerificationMeta(
    'damageTypeId',
  );
  @override
  late final GeneratedColumn<String> damageTypeId = GeneratedColumn<String>(
    'damage_type_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _propertiesMeta = const VerificationMeta(
    'properties',
  );
  @override
  late final GeneratedColumn<String> properties = GeneratedColumn<String>(
    'properties',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versatileDamageMeta = const VerificationMeta(
    'versatileDamage',
  );
  @override
  late final GeneratedColumn<String> versatileDamage = GeneratedColumn<String>(
    'versatile_damage',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rangeNormalFeetMeta = const VerificationMeta(
    'rangeNormalFeet',
  );
  @override
  late final GeneratedColumn<int> rangeNormalFeet = GeneratedColumn<int>(
    'range_normal_feet',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rangeLongFeetMeta = const VerificationMeta(
    'rangeLongFeet',
  );
  @override
  late final GeneratedColumn<int> rangeLongFeet = GeneratedColumn<int>(
    'range_long_feet',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _masteryPropertyIdMeta = const VerificationMeta(
    'masteryPropertyId',
  );
  @override
  late final GeneratedColumn<String> masteryPropertyId =
      GeneratedColumn<String>(
        'mastery_property_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costCpMeta = const VerificationMeta('costCp');
  @override
  late final GeneratedColumn<int> costCp = GeneratedColumn<int>(
    'cost_cp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packId,
    name,
    extendsId,
    category,
    kind,
    damage,
    damageTypeId,
    properties,
    versatileDamage,
    rangeNormalFeet,
    rangeLongFeet,
    masteryPropertyId,
    weightKg,
    costCp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weapon';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeaponRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('extends_id')) {
      context.handle(
        _extendsIdMeta,
        extendsId.isAcceptableOrUnknown(data['extends_id']!, _extendsIdMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('damage')) {
      context.handle(
        _damageMeta,
        damage.isAcceptableOrUnknown(data['damage']!, _damageMeta),
      );
    } else if (isInserting) {
      context.missing(_damageMeta);
    }
    if (data.containsKey('damage_type_id')) {
      context.handle(
        _damageTypeIdMeta,
        damageTypeId.isAcceptableOrUnknown(
          data['damage_type_id']!,
          _damageTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_damageTypeIdMeta);
    }
    if (data.containsKey('properties')) {
      context.handle(
        _propertiesMeta,
        properties.isAcceptableOrUnknown(data['properties']!, _propertiesMeta),
      );
    } else if (isInserting) {
      context.missing(_propertiesMeta);
    }
    if (data.containsKey('versatile_damage')) {
      context.handle(
        _versatileDamageMeta,
        versatileDamage.isAcceptableOrUnknown(
          data['versatile_damage']!,
          _versatileDamageMeta,
        ),
      );
    }
    if (data.containsKey('range_normal_feet')) {
      context.handle(
        _rangeNormalFeetMeta,
        rangeNormalFeet.isAcceptableOrUnknown(
          data['range_normal_feet']!,
          _rangeNormalFeetMeta,
        ),
      );
    }
    if (data.containsKey('range_long_feet')) {
      context.handle(
        _rangeLongFeetMeta,
        rangeLongFeet.isAcceptableOrUnknown(
          data['range_long_feet']!,
          _rangeLongFeetMeta,
        ),
      );
    }
    if (data.containsKey('mastery_property_id')) {
      context.handle(
        _masteryPropertyIdMeta,
        masteryPropertyId.isAcceptableOrUnknown(
          data['mastery_property_id']!,
          _masteryPropertyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_masteryPropertyIdMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('cost_cp')) {
      context.handle(
        _costCpMeta,
        costCp.isAcceptableOrUnknown(data['cost_cp']!, _costCpMeta),
      );
    } else if (isInserting) {
      context.missing(_costCpMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeaponRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeaponRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      extendsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extends_id'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      damage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}damage'],
      )!,
      damageTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}damage_type_id'],
      )!,
      properties: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}properties'],
      )!,
      versatileDamage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}versatile_damage'],
      ),
      rangeNormalFeet: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}range_normal_feet'],
      ),
      rangeLongFeet: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}range_long_feet'],
      ),
      masteryPropertyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mastery_property_id'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      costCp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_cp'],
      )!,
    );
  }

  @override
  $WeaponsTable createAlias(String alias) {
    return $WeaponsTable(attachedDatabase, alias);
  }
}

class WeaponRow extends DataClass implements Insertable<WeaponRow> {
  final String id;
  final String packId;
  final String name;
  final String? extendsId;
  final String category;
  final String kind;
  final String damage;
  final String damageTypeId;
  final String properties;
  final String? versatileDamage;
  final int? rangeNormalFeet;
  final int? rangeLongFeet;
  final String masteryPropertyId;
  final double? weightKg;
  final int costCp;
  const WeaponRow({
    required this.id,
    required this.packId,
    required this.name,
    this.extendsId,
    required this.category,
    required this.kind,
    required this.damage,
    required this.damageTypeId,
    required this.properties,
    this.versatileDamage,
    this.rangeNormalFeet,
    this.rangeLongFeet,
    required this.masteryPropertyId,
    this.weightKg,
    required this.costCp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || extendsId != null) {
      map['extends_id'] = Variable<String>(extendsId);
    }
    map['category'] = Variable<String>(category);
    map['kind'] = Variable<String>(kind);
    map['damage'] = Variable<String>(damage);
    map['damage_type_id'] = Variable<String>(damageTypeId);
    map['properties'] = Variable<String>(properties);
    if (!nullToAbsent || versatileDamage != null) {
      map['versatile_damage'] = Variable<String>(versatileDamage);
    }
    if (!nullToAbsent || rangeNormalFeet != null) {
      map['range_normal_feet'] = Variable<int>(rangeNormalFeet);
    }
    if (!nullToAbsent || rangeLongFeet != null) {
      map['range_long_feet'] = Variable<int>(rangeLongFeet);
    }
    map['mastery_property_id'] = Variable<String>(masteryPropertyId);
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    map['cost_cp'] = Variable<int>(costCp);
    return map;
  }

  WeaponsCompanion toCompanion(bool nullToAbsent) {
    return WeaponsCompanion(
      id: Value(id),
      packId: Value(packId),
      name: Value(name),
      extendsId: extendsId == null && nullToAbsent
          ? const Value.absent()
          : Value(extendsId),
      category: Value(category),
      kind: Value(kind),
      damage: Value(damage),
      damageTypeId: Value(damageTypeId),
      properties: Value(properties),
      versatileDamage: versatileDamage == null && nullToAbsent
          ? const Value.absent()
          : Value(versatileDamage),
      rangeNormalFeet: rangeNormalFeet == null && nullToAbsent
          ? const Value.absent()
          : Value(rangeNormalFeet),
      rangeLongFeet: rangeLongFeet == null && nullToAbsent
          ? const Value.absent()
          : Value(rangeLongFeet),
      masteryPropertyId: Value(masteryPropertyId),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      costCp: Value(costCp),
    );
  }

  factory WeaponRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeaponRow(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      name: serializer.fromJson<String>(json['name']),
      extendsId: serializer.fromJson<String?>(json['extendsId']),
      category: serializer.fromJson<String>(json['category']),
      kind: serializer.fromJson<String>(json['kind']),
      damage: serializer.fromJson<String>(json['damage']),
      damageTypeId: serializer.fromJson<String>(json['damageTypeId']),
      properties: serializer.fromJson<String>(json['properties']),
      versatileDamage: serializer.fromJson<String?>(json['versatileDamage']),
      rangeNormalFeet: serializer.fromJson<int?>(json['rangeNormalFeet']),
      rangeLongFeet: serializer.fromJson<int?>(json['rangeLongFeet']),
      masteryPropertyId: serializer.fromJson<String>(json['masteryPropertyId']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      costCp: serializer.fromJson<int>(json['costCp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'name': serializer.toJson<String>(name),
      'extendsId': serializer.toJson<String?>(extendsId),
      'category': serializer.toJson<String>(category),
      'kind': serializer.toJson<String>(kind),
      'damage': serializer.toJson<String>(damage),
      'damageTypeId': serializer.toJson<String>(damageTypeId),
      'properties': serializer.toJson<String>(properties),
      'versatileDamage': serializer.toJson<String?>(versatileDamage),
      'rangeNormalFeet': serializer.toJson<int?>(rangeNormalFeet),
      'rangeLongFeet': serializer.toJson<int?>(rangeLongFeet),
      'masteryPropertyId': serializer.toJson<String>(masteryPropertyId),
      'weightKg': serializer.toJson<double?>(weightKg),
      'costCp': serializer.toJson<int>(costCp),
    };
  }

  WeaponRow copyWith({
    String? id,
    String? packId,
    String? name,
    Value<String?> extendsId = const Value.absent(),
    String? category,
    String? kind,
    String? damage,
    String? damageTypeId,
    String? properties,
    Value<String?> versatileDamage = const Value.absent(),
    Value<int?> rangeNormalFeet = const Value.absent(),
    Value<int?> rangeLongFeet = const Value.absent(),
    String? masteryPropertyId,
    Value<double?> weightKg = const Value.absent(),
    int? costCp,
  }) => WeaponRow(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    name: name ?? this.name,
    extendsId: extendsId.present ? extendsId.value : this.extendsId,
    category: category ?? this.category,
    kind: kind ?? this.kind,
    damage: damage ?? this.damage,
    damageTypeId: damageTypeId ?? this.damageTypeId,
    properties: properties ?? this.properties,
    versatileDamage: versatileDamage.present
        ? versatileDamage.value
        : this.versatileDamage,
    rangeNormalFeet: rangeNormalFeet.present
        ? rangeNormalFeet.value
        : this.rangeNormalFeet,
    rangeLongFeet: rangeLongFeet.present
        ? rangeLongFeet.value
        : this.rangeLongFeet,
    masteryPropertyId: masteryPropertyId ?? this.masteryPropertyId,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    costCp: costCp ?? this.costCp,
  );
  WeaponRow copyWithCompanion(WeaponsCompanion data) {
    return WeaponRow(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      name: data.name.present ? data.name.value : this.name,
      extendsId: data.extendsId.present ? data.extendsId.value : this.extendsId,
      category: data.category.present ? data.category.value : this.category,
      kind: data.kind.present ? data.kind.value : this.kind,
      damage: data.damage.present ? data.damage.value : this.damage,
      damageTypeId: data.damageTypeId.present
          ? data.damageTypeId.value
          : this.damageTypeId,
      properties: data.properties.present
          ? data.properties.value
          : this.properties,
      versatileDamage: data.versatileDamage.present
          ? data.versatileDamage.value
          : this.versatileDamage,
      rangeNormalFeet: data.rangeNormalFeet.present
          ? data.rangeNormalFeet.value
          : this.rangeNormalFeet,
      rangeLongFeet: data.rangeLongFeet.present
          ? data.rangeLongFeet.value
          : this.rangeLongFeet,
      masteryPropertyId: data.masteryPropertyId.present
          ? data.masteryPropertyId.value
          : this.masteryPropertyId,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      costCp: data.costCp.present ? data.costCp.value : this.costCp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeaponRow(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('category: $category, ')
          ..write('kind: $kind, ')
          ..write('damage: $damage, ')
          ..write('damageTypeId: $damageTypeId, ')
          ..write('properties: $properties, ')
          ..write('versatileDamage: $versatileDamage, ')
          ..write('rangeNormalFeet: $rangeNormalFeet, ')
          ..write('rangeLongFeet: $rangeLongFeet, ')
          ..write('masteryPropertyId: $masteryPropertyId, ')
          ..write('weightKg: $weightKg, ')
          ..write('costCp: $costCp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    packId,
    name,
    extendsId,
    category,
    kind,
    damage,
    damageTypeId,
    properties,
    versatileDamage,
    rangeNormalFeet,
    rangeLongFeet,
    masteryPropertyId,
    weightKg,
    costCp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeaponRow &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.name == this.name &&
          other.extendsId == this.extendsId &&
          other.category == this.category &&
          other.kind == this.kind &&
          other.damage == this.damage &&
          other.damageTypeId == this.damageTypeId &&
          other.properties == this.properties &&
          other.versatileDamage == this.versatileDamage &&
          other.rangeNormalFeet == this.rangeNormalFeet &&
          other.rangeLongFeet == this.rangeLongFeet &&
          other.masteryPropertyId == this.masteryPropertyId &&
          other.weightKg == this.weightKg &&
          other.costCp == this.costCp);
}

class WeaponsCompanion extends UpdateCompanion<WeaponRow> {
  final Value<String> id;
  final Value<String> packId;
  final Value<String> name;
  final Value<String?> extendsId;
  final Value<String> category;
  final Value<String> kind;
  final Value<String> damage;
  final Value<String> damageTypeId;
  final Value<String> properties;
  final Value<String?> versatileDamage;
  final Value<int?> rangeNormalFeet;
  final Value<int?> rangeLongFeet;
  final Value<String> masteryPropertyId;
  final Value<double?> weightKg;
  final Value<int> costCp;
  final Value<int> rowid;
  const WeaponsCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.name = const Value.absent(),
    this.extendsId = const Value.absent(),
    this.category = const Value.absent(),
    this.kind = const Value.absent(),
    this.damage = const Value.absent(),
    this.damageTypeId = const Value.absent(),
    this.properties = const Value.absent(),
    this.versatileDamage = const Value.absent(),
    this.rangeNormalFeet = const Value.absent(),
    this.rangeLongFeet = const Value.absent(),
    this.masteryPropertyId = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.costCp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeaponsCompanion.insert({
    required String id,
    required String packId,
    required String name,
    this.extendsId = const Value.absent(),
    required String category,
    required String kind,
    required String damage,
    required String damageTypeId,
    required String properties,
    this.versatileDamage = const Value.absent(),
    this.rangeNormalFeet = const Value.absent(),
    this.rangeLongFeet = const Value.absent(),
    required String masteryPropertyId,
    this.weightKg = const Value.absent(),
    required int costCp,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       name = Value(name),
       category = Value(category),
       kind = Value(kind),
       damage = Value(damage),
       damageTypeId = Value(damageTypeId),
       properties = Value(properties),
       masteryPropertyId = Value(masteryPropertyId),
       costCp = Value(costCp);
  static Insertable<WeaponRow> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<String>? name,
    Expression<String>? extendsId,
    Expression<String>? category,
    Expression<String>? kind,
    Expression<String>? damage,
    Expression<String>? damageTypeId,
    Expression<String>? properties,
    Expression<String>? versatileDamage,
    Expression<int>? rangeNormalFeet,
    Expression<int>? rangeLongFeet,
    Expression<String>? masteryPropertyId,
    Expression<double>? weightKg,
    Expression<int>? costCp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (name != null) 'name': name,
      if (extendsId != null) 'extends_id': extendsId,
      if (category != null) 'category': category,
      if (kind != null) 'kind': kind,
      if (damage != null) 'damage': damage,
      if (damageTypeId != null) 'damage_type_id': damageTypeId,
      if (properties != null) 'properties': properties,
      if (versatileDamage != null) 'versatile_damage': versatileDamage,
      if (rangeNormalFeet != null) 'range_normal_feet': rangeNormalFeet,
      if (rangeLongFeet != null) 'range_long_feet': rangeLongFeet,
      if (masteryPropertyId != null) 'mastery_property_id': masteryPropertyId,
      if (weightKg != null) 'weight_kg': weightKg,
      if (costCp != null) 'cost_cp': costCp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeaponsCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<String>? name,
    Value<String?>? extendsId,
    Value<String>? category,
    Value<String>? kind,
    Value<String>? damage,
    Value<String>? damageTypeId,
    Value<String>? properties,
    Value<String?>? versatileDamage,
    Value<int?>? rangeNormalFeet,
    Value<int?>? rangeLongFeet,
    Value<String>? masteryPropertyId,
    Value<double?>? weightKg,
    Value<int>? costCp,
    Value<int>? rowid,
  }) {
    return WeaponsCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      name: name ?? this.name,
      extendsId: extendsId ?? this.extendsId,
      category: category ?? this.category,
      kind: kind ?? this.kind,
      damage: damage ?? this.damage,
      damageTypeId: damageTypeId ?? this.damageTypeId,
      properties: properties ?? this.properties,
      versatileDamage: versatileDamage ?? this.versatileDamage,
      rangeNormalFeet: rangeNormalFeet ?? this.rangeNormalFeet,
      rangeLongFeet: rangeLongFeet ?? this.rangeLongFeet,
      masteryPropertyId: masteryPropertyId ?? this.masteryPropertyId,
      weightKg: weightKg ?? this.weightKg,
      costCp: costCp ?? this.costCp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (extendsId.present) {
      map['extends_id'] = Variable<String>(extendsId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (damage.present) {
      map['damage'] = Variable<String>(damage.value);
    }
    if (damageTypeId.present) {
      map['damage_type_id'] = Variable<String>(damageTypeId.value);
    }
    if (properties.present) {
      map['properties'] = Variable<String>(properties.value);
    }
    if (versatileDamage.present) {
      map['versatile_damage'] = Variable<String>(versatileDamage.value);
    }
    if (rangeNormalFeet.present) {
      map['range_normal_feet'] = Variable<int>(rangeNormalFeet.value);
    }
    if (rangeLongFeet.present) {
      map['range_long_feet'] = Variable<int>(rangeLongFeet.value);
    }
    if (masteryPropertyId.present) {
      map['mastery_property_id'] = Variable<String>(masteryPropertyId.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (costCp.present) {
      map['cost_cp'] = Variable<int>(costCp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeaponsCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('category: $category, ')
          ..write('kind: $kind, ')
          ..write('damage: $damage, ')
          ..write('damageTypeId: $damageTypeId, ')
          ..write('properties: $properties, ')
          ..write('versatileDamage: $versatileDamage, ')
          ..write('rangeNormalFeet: $rangeNormalFeet, ')
          ..write('rangeLongFeet: $rangeLongFeet, ')
          ..write('masteryPropertyId: $masteryPropertyId, ')
          ..write('weightKg: $weightKg, ')
          ..write('costCp: $costCp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ArmorsTable extends Armors with TableInfo<$ArmorsTable, ArmorRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArmorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extendsIdMeta = const VerificationMeta(
    'extendsId',
  );
  @override
  late final GeneratedColumn<String> extendsId = GeneratedColumn<String>(
    'extends_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseAcMeta = const VerificationMeta('baseAc');
  @override
  late final GeneratedColumn<int> baseAc = GeneratedColumn<int>(
    'base_ac',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dexCapMeta = const VerificationMeta('dexCap');
  @override
  late final GeneratedColumn<int> dexCap = GeneratedColumn<int>(
    'dex_cap',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _strRequirementMeta = const VerificationMeta(
    'strRequirement',
  );
  @override
  late final GeneratedColumn<int> strRequirement = GeneratedColumn<int>(
    'str_requirement',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stealthDisadvantageMeta =
      const VerificationMeta('stealthDisadvantage');
  @override
  late final GeneratedColumn<bool> stealthDisadvantage = GeneratedColumn<bool>(
    'stealth_disadvantage',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("stealth_disadvantage" IN (0, 1))',
    ),
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costCpMeta = const VerificationMeta('costCp');
  @override
  late final GeneratedColumn<int> costCp = GeneratedColumn<int>(
    'cost_cp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packId,
    name,
    extendsId,
    category,
    baseAc,
    dexCap,
    strRequirement,
    stealthDisadvantage,
    weightKg,
    costCp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'armor';
  @override
  VerificationContext validateIntegrity(
    Insertable<ArmorRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('extends_id')) {
      context.handle(
        _extendsIdMeta,
        extendsId.isAcceptableOrUnknown(data['extends_id']!, _extendsIdMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('base_ac')) {
      context.handle(
        _baseAcMeta,
        baseAc.isAcceptableOrUnknown(data['base_ac']!, _baseAcMeta),
      );
    } else if (isInserting) {
      context.missing(_baseAcMeta);
    }
    if (data.containsKey('dex_cap')) {
      context.handle(
        _dexCapMeta,
        dexCap.isAcceptableOrUnknown(data['dex_cap']!, _dexCapMeta),
      );
    }
    if (data.containsKey('str_requirement')) {
      context.handle(
        _strRequirementMeta,
        strRequirement.isAcceptableOrUnknown(
          data['str_requirement']!,
          _strRequirementMeta,
        ),
      );
    }
    if (data.containsKey('stealth_disadvantage')) {
      context.handle(
        _stealthDisadvantageMeta,
        stealthDisadvantage.isAcceptableOrUnknown(
          data['stealth_disadvantage']!,
          _stealthDisadvantageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_stealthDisadvantageMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('cost_cp')) {
      context.handle(
        _costCpMeta,
        costCp.isAcceptableOrUnknown(data['cost_cp']!, _costCpMeta),
      );
    } else if (isInserting) {
      context.missing(_costCpMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ArmorRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArmorRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      extendsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extends_id'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      baseAc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_ac'],
      )!,
      dexCap: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dex_cap'],
      ),
      strRequirement: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}str_requirement'],
      ),
      stealthDisadvantage: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}stealth_disadvantage'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      costCp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_cp'],
      )!,
    );
  }

  @override
  $ArmorsTable createAlias(String alias) {
    return $ArmorsTable(attachedDatabase, alias);
  }
}

class ArmorRow extends DataClass implements Insertable<ArmorRow> {
  final String id;
  final String packId;
  final String name;
  final String? extendsId;
  final String category;
  final int baseAc;
  final int? dexCap;
  final int? strRequirement;
  final bool stealthDisadvantage;
  final double weightKg;
  final int costCp;
  const ArmorRow({
    required this.id,
    required this.packId,
    required this.name,
    this.extendsId,
    required this.category,
    required this.baseAc,
    this.dexCap,
    this.strRequirement,
    required this.stealthDisadvantage,
    required this.weightKg,
    required this.costCp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || extendsId != null) {
      map['extends_id'] = Variable<String>(extendsId);
    }
    map['category'] = Variable<String>(category);
    map['base_ac'] = Variable<int>(baseAc);
    if (!nullToAbsent || dexCap != null) {
      map['dex_cap'] = Variable<int>(dexCap);
    }
    if (!nullToAbsent || strRequirement != null) {
      map['str_requirement'] = Variable<int>(strRequirement);
    }
    map['stealth_disadvantage'] = Variable<bool>(stealthDisadvantage);
    map['weight_kg'] = Variable<double>(weightKg);
    map['cost_cp'] = Variable<int>(costCp);
    return map;
  }

  ArmorsCompanion toCompanion(bool nullToAbsent) {
    return ArmorsCompanion(
      id: Value(id),
      packId: Value(packId),
      name: Value(name),
      extendsId: extendsId == null && nullToAbsent
          ? const Value.absent()
          : Value(extendsId),
      category: Value(category),
      baseAc: Value(baseAc),
      dexCap: dexCap == null && nullToAbsent
          ? const Value.absent()
          : Value(dexCap),
      strRequirement: strRequirement == null && nullToAbsent
          ? const Value.absent()
          : Value(strRequirement),
      stealthDisadvantage: Value(stealthDisadvantage),
      weightKg: Value(weightKg),
      costCp: Value(costCp),
    );
  }

  factory ArmorRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArmorRow(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      name: serializer.fromJson<String>(json['name']),
      extendsId: serializer.fromJson<String?>(json['extendsId']),
      category: serializer.fromJson<String>(json['category']),
      baseAc: serializer.fromJson<int>(json['baseAc']),
      dexCap: serializer.fromJson<int?>(json['dexCap']),
      strRequirement: serializer.fromJson<int?>(json['strRequirement']),
      stealthDisadvantage: serializer.fromJson<bool>(
        json['stealthDisadvantage'],
      ),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      costCp: serializer.fromJson<int>(json['costCp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'name': serializer.toJson<String>(name),
      'extendsId': serializer.toJson<String?>(extendsId),
      'category': serializer.toJson<String>(category),
      'baseAc': serializer.toJson<int>(baseAc),
      'dexCap': serializer.toJson<int?>(dexCap),
      'strRequirement': serializer.toJson<int?>(strRequirement),
      'stealthDisadvantage': serializer.toJson<bool>(stealthDisadvantage),
      'weightKg': serializer.toJson<double>(weightKg),
      'costCp': serializer.toJson<int>(costCp),
    };
  }

  ArmorRow copyWith({
    String? id,
    String? packId,
    String? name,
    Value<String?> extendsId = const Value.absent(),
    String? category,
    int? baseAc,
    Value<int?> dexCap = const Value.absent(),
    Value<int?> strRequirement = const Value.absent(),
    bool? stealthDisadvantage,
    double? weightKg,
    int? costCp,
  }) => ArmorRow(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    name: name ?? this.name,
    extendsId: extendsId.present ? extendsId.value : this.extendsId,
    category: category ?? this.category,
    baseAc: baseAc ?? this.baseAc,
    dexCap: dexCap.present ? dexCap.value : this.dexCap,
    strRequirement: strRequirement.present
        ? strRequirement.value
        : this.strRequirement,
    stealthDisadvantage: stealthDisadvantage ?? this.stealthDisadvantage,
    weightKg: weightKg ?? this.weightKg,
    costCp: costCp ?? this.costCp,
  );
  ArmorRow copyWithCompanion(ArmorsCompanion data) {
    return ArmorRow(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      name: data.name.present ? data.name.value : this.name,
      extendsId: data.extendsId.present ? data.extendsId.value : this.extendsId,
      category: data.category.present ? data.category.value : this.category,
      baseAc: data.baseAc.present ? data.baseAc.value : this.baseAc,
      dexCap: data.dexCap.present ? data.dexCap.value : this.dexCap,
      strRequirement: data.strRequirement.present
          ? data.strRequirement.value
          : this.strRequirement,
      stealthDisadvantage: data.stealthDisadvantage.present
          ? data.stealthDisadvantage.value
          : this.stealthDisadvantage,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      costCp: data.costCp.present ? data.costCp.value : this.costCp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ArmorRow(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('category: $category, ')
          ..write('baseAc: $baseAc, ')
          ..write('dexCap: $dexCap, ')
          ..write('strRequirement: $strRequirement, ')
          ..write('stealthDisadvantage: $stealthDisadvantage, ')
          ..write('weightKg: $weightKg, ')
          ..write('costCp: $costCp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    packId,
    name,
    extendsId,
    category,
    baseAc,
    dexCap,
    strRequirement,
    stealthDisadvantage,
    weightKg,
    costCp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArmorRow &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.name == this.name &&
          other.extendsId == this.extendsId &&
          other.category == this.category &&
          other.baseAc == this.baseAc &&
          other.dexCap == this.dexCap &&
          other.strRequirement == this.strRequirement &&
          other.stealthDisadvantage == this.stealthDisadvantage &&
          other.weightKg == this.weightKg &&
          other.costCp == this.costCp);
}

class ArmorsCompanion extends UpdateCompanion<ArmorRow> {
  final Value<String> id;
  final Value<String> packId;
  final Value<String> name;
  final Value<String?> extendsId;
  final Value<String> category;
  final Value<int> baseAc;
  final Value<int?> dexCap;
  final Value<int?> strRequirement;
  final Value<bool> stealthDisadvantage;
  final Value<double> weightKg;
  final Value<int> costCp;
  final Value<int> rowid;
  const ArmorsCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.name = const Value.absent(),
    this.extendsId = const Value.absent(),
    this.category = const Value.absent(),
    this.baseAc = const Value.absent(),
    this.dexCap = const Value.absent(),
    this.strRequirement = const Value.absent(),
    this.stealthDisadvantage = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.costCp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArmorsCompanion.insert({
    required String id,
    required String packId,
    required String name,
    this.extendsId = const Value.absent(),
    required String category,
    required int baseAc,
    this.dexCap = const Value.absent(),
    this.strRequirement = const Value.absent(),
    required bool stealthDisadvantage,
    required double weightKg,
    required int costCp,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       name = Value(name),
       category = Value(category),
       baseAc = Value(baseAc),
       stealthDisadvantage = Value(stealthDisadvantage),
       weightKg = Value(weightKg),
       costCp = Value(costCp);
  static Insertable<ArmorRow> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<String>? name,
    Expression<String>? extendsId,
    Expression<String>? category,
    Expression<int>? baseAc,
    Expression<int>? dexCap,
    Expression<int>? strRequirement,
    Expression<bool>? stealthDisadvantage,
    Expression<double>? weightKg,
    Expression<int>? costCp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (name != null) 'name': name,
      if (extendsId != null) 'extends_id': extendsId,
      if (category != null) 'category': category,
      if (baseAc != null) 'base_ac': baseAc,
      if (dexCap != null) 'dex_cap': dexCap,
      if (strRequirement != null) 'str_requirement': strRequirement,
      if (stealthDisadvantage != null)
        'stealth_disadvantage': stealthDisadvantage,
      if (weightKg != null) 'weight_kg': weightKg,
      if (costCp != null) 'cost_cp': costCp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArmorsCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<String>? name,
    Value<String?>? extendsId,
    Value<String>? category,
    Value<int>? baseAc,
    Value<int?>? dexCap,
    Value<int?>? strRequirement,
    Value<bool>? stealthDisadvantage,
    Value<double>? weightKg,
    Value<int>? costCp,
    Value<int>? rowid,
  }) {
    return ArmorsCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      name: name ?? this.name,
      extendsId: extendsId ?? this.extendsId,
      category: category ?? this.category,
      baseAc: baseAc ?? this.baseAc,
      dexCap: dexCap ?? this.dexCap,
      strRequirement: strRequirement ?? this.strRequirement,
      stealthDisadvantage: stealthDisadvantage ?? this.stealthDisadvantage,
      weightKg: weightKg ?? this.weightKg,
      costCp: costCp ?? this.costCp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (extendsId.present) {
      map['extends_id'] = Variable<String>(extendsId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (baseAc.present) {
      map['base_ac'] = Variable<int>(baseAc.value);
    }
    if (dexCap.present) {
      map['dex_cap'] = Variable<int>(dexCap.value);
    }
    if (strRequirement.present) {
      map['str_requirement'] = Variable<int>(strRequirement.value);
    }
    if (stealthDisadvantage.present) {
      map['stealth_disadvantage'] = Variable<bool>(stealthDisadvantage.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (costCp.present) {
      map['cost_cp'] = Variable<int>(costCp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArmorsCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('category: $category, ')
          ..write('baseAc: $baseAc, ')
          ..write('dexCap: $dexCap, ')
          ..write('strRequirement: $strRequirement, ')
          ..write('stealthDisadvantage: $stealthDisadvantage, ')
          ..write('weightKg: $weightKg, ')
          ..write('costCp: $costCp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ToolsTable extends Tools with TableInfo<$ToolsTable, ToolRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ToolsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extendsIdMeta = const VerificationMeta(
    'extendsId',
  );
  @override
  late final GeneratedColumn<String> extendsId = GeneratedColumn<String>(
    'extends_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _abilityIdMeta = const VerificationMeta(
    'abilityId',
  );
  @override
  late final GeneratedColumn<String> abilityId = GeneratedColumn<String>(
    'ability_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costCpMeta = const VerificationMeta('costCp');
  @override
  late final GeneratedColumn<int> costCp = GeneratedColumn<int>(
    'cost_cp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packId,
    name,
    extendsId,
    category,
    abilityId,
    weightKg,
    costCp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tool';
  @override
  VerificationContext validateIntegrity(
    Insertable<ToolRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('extends_id')) {
      context.handle(
        _extendsIdMeta,
        extendsId.isAcceptableOrUnknown(data['extends_id']!, _extendsIdMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('ability_id')) {
      context.handle(
        _abilityIdMeta,
        abilityId.isAcceptableOrUnknown(data['ability_id']!, _abilityIdMeta),
      );
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('cost_cp')) {
      context.handle(
        _costCpMeta,
        costCp.isAcceptableOrUnknown(data['cost_cp']!, _costCpMeta),
      );
    } else if (isInserting) {
      context.missing(_costCpMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ToolRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ToolRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      extendsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extends_id'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      abilityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ability_id'],
      ),
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      costCp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_cp'],
      )!,
    );
  }

  @override
  $ToolsTable createAlias(String alias) {
    return $ToolsTable(attachedDatabase, alias);
  }
}

class ToolRow extends DataClass implements Insertable<ToolRow> {
  final String id;
  final String packId;
  final String name;
  final String? extendsId;
  final String category;
  final String? abilityId;
  final double? weightKg;
  final int costCp;
  const ToolRow({
    required this.id,
    required this.packId,
    required this.name,
    this.extendsId,
    required this.category,
    this.abilityId,
    this.weightKg,
    required this.costCp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || extendsId != null) {
      map['extends_id'] = Variable<String>(extendsId);
    }
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || abilityId != null) {
      map['ability_id'] = Variable<String>(abilityId);
    }
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    map['cost_cp'] = Variable<int>(costCp);
    return map;
  }

  ToolsCompanion toCompanion(bool nullToAbsent) {
    return ToolsCompanion(
      id: Value(id),
      packId: Value(packId),
      name: Value(name),
      extendsId: extendsId == null && nullToAbsent
          ? const Value.absent()
          : Value(extendsId),
      category: Value(category),
      abilityId: abilityId == null && nullToAbsent
          ? const Value.absent()
          : Value(abilityId),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      costCp: Value(costCp),
    );
  }

  factory ToolRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ToolRow(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      name: serializer.fromJson<String>(json['name']),
      extendsId: serializer.fromJson<String?>(json['extendsId']),
      category: serializer.fromJson<String>(json['category']),
      abilityId: serializer.fromJson<String?>(json['abilityId']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      costCp: serializer.fromJson<int>(json['costCp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'name': serializer.toJson<String>(name),
      'extendsId': serializer.toJson<String?>(extendsId),
      'category': serializer.toJson<String>(category),
      'abilityId': serializer.toJson<String?>(abilityId),
      'weightKg': serializer.toJson<double?>(weightKg),
      'costCp': serializer.toJson<int>(costCp),
    };
  }

  ToolRow copyWith({
    String? id,
    String? packId,
    String? name,
    Value<String?> extendsId = const Value.absent(),
    String? category,
    Value<String?> abilityId = const Value.absent(),
    Value<double?> weightKg = const Value.absent(),
    int? costCp,
  }) => ToolRow(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    name: name ?? this.name,
    extendsId: extendsId.present ? extendsId.value : this.extendsId,
    category: category ?? this.category,
    abilityId: abilityId.present ? abilityId.value : this.abilityId,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    costCp: costCp ?? this.costCp,
  );
  ToolRow copyWithCompanion(ToolsCompanion data) {
    return ToolRow(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      name: data.name.present ? data.name.value : this.name,
      extendsId: data.extendsId.present ? data.extendsId.value : this.extendsId,
      category: data.category.present ? data.category.value : this.category,
      abilityId: data.abilityId.present ? data.abilityId.value : this.abilityId,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      costCp: data.costCp.present ? data.costCp.value : this.costCp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ToolRow(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('category: $category, ')
          ..write('abilityId: $abilityId, ')
          ..write('weightKg: $weightKg, ')
          ..write('costCp: $costCp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    packId,
    name,
    extendsId,
    category,
    abilityId,
    weightKg,
    costCp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ToolRow &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.name == this.name &&
          other.extendsId == this.extendsId &&
          other.category == this.category &&
          other.abilityId == this.abilityId &&
          other.weightKg == this.weightKg &&
          other.costCp == this.costCp);
}

class ToolsCompanion extends UpdateCompanion<ToolRow> {
  final Value<String> id;
  final Value<String> packId;
  final Value<String> name;
  final Value<String?> extendsId;
  final Value<String> category;
  final Value<String?> abilityId;
  final Value<double?> weightKg;
  final Value<int> costCp;
  final Value<int> rowid;
  const ToolsCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.name = const Value.absent(),
    this.extendsId = const Value.absent(),
    this.category = const Value.absent(),
    this.abilityId = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.costCp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ToolsCompanion.insert({
    required String id,
    required String packId,
    required String name,
    this.extendsId = const Value.absent(),
    required String category,
    this.abilityId = const Value.absent(),
    this.weightKg = const Value.absent(),
    required int costCp,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       name = Value(name),
       category = Value(category),
       costCp = Value(costCp);
  static Insertable<ToolRow> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<String>? name,
    Expression<String>? extendsId,
    Expression<String>? category,
    Expression<String>? abilityId,
    Expression<double>? weightKg,
    Expression<int>? costCp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (name != null) 'name': name,
      if (extendsId != null) 'extends_id': extendsId,
      if (category != null) 'category': category,
      if (abilityId != null) 'ability_id': abilityId,
      if (weightKg != null) 'weight_kg': weightKg,
      if (costCp != null) 'cost_cp': costCp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ToolsCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<String>? name,
    Value<String?>? extendsId,
    Value<String>? category,
    Value<String?>? abilityId,
    Value<double?>? weightKg,
    Value<int>? costCp,
    Value<int>? rowid,
  }) {
    return ToolsCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      name: name ?? this.name,
      extendsId: extendsId ?? this.extendsId,
      category: category ?? this.category,
      abilityId: abilityId ?? this.abilityId,
      weightKg: weightKg ?? this.weightKg,
      costCp: costCp ?? this.costCp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (extendsId.present) {
      map['extends_id'] = Variable<String>(extendsId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (abilityId.present) {
      map['ability_id'] = Variable<String>(abilityId.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (costCp.present) {
      map['cost_cp'] = Variable<int>(costCp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ToolsCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('category: $category, ')
          ..write('abilityId: $abilityId, ')
          ..write('weightKg: $weightKg, ')
          ..write('costCp: $costCp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, ItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extendsIdMeta = const VerificationMeta(
    'extendsId',
  );
  @override
  late final GeneratedColumn<String> extendsId = GeneratedColumn<String>(
    'extends_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costCpMeta = const VerificationMeta('costCp');
  @override
  late final GeneratedColumn<int> costCp = GeneratedColumn<int>(
    'cost_cp',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rarityMeta = const VerificationMeta('rarity');
  @override
  late final GeneratedColumn<String> rarity = GeneratedColumn<String>(
    'rarity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attunementMeta = const VerificationMeta(
    'attunement',
  );
  @override
  late final GeneratedColumn<bool> attunement = GeneratedColumn<bool>(
    'attunement',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("attunement" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packId,
    name,
    extendsId,
    weightKg,
    costCp,
    rarity,
    attunement,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('extends_id')) {
      context.handle(
        _extendsIdMeta,
        extendsId.isAcceptableOrUnknown(data['extends_id']!, _extendsIdMeta),
      );
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('cost_cp')) {
      context.handle(
        _costCpMeta,
        costCp.isAcceptableOrUnknown(data['cost_cp']!, _costCpMeta),
      );
    }
    if (data.containsKey('rarity')) {
      context.handle(
        _rarityMeta,
        rarity.isAcceptableOrUnknown(data['rarity']!, _rarityMeta),
      );
    }
    if (data.containsKey('attunement')) {
      context.handle(
        _attunementMeta,
        attunement.isAcceptableOrUnknown(data['attunement']!, _attunementMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      extendsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extends_id'],
      ),
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      costCp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_cp'],
      ),
      rarity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rarity'],
      ),
      attunement: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}attunement'],
      )!,
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }
}

class ItemRow extends DataClass implements Insertable<ItemRow> {
  final String id;
  final String packId;
  final String name;
  final String? extendsId;
  final double? weightKg;
  final int? costCp;
  final String? rarity;
  final bool attunement;
  const ItemRow({
    required this.id,
    required this.packId,
    required this.name,
    this.extendsId,
    this.weightKg,
    this.costCp,
    this.rarity,
    required this.attunement,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || extendsId != null) {
      map['extends_id'] = Variable<String>(extendsId);
    }
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || costCp != null) {
      map['cost_cp'] = Variable<int>(costCp);
    }
    if (!nullToAbsent || rarity != null) {
      map['rarity'] = Variable<String>(rarity);
    }
    map['attunement'] = Variable<bool>(attunement);
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      packId: Value(packId),
      name: Value(name),
      extendsId: extendsId == null && nullToAbsent
          ? const Value.absent()
          : Value(extendsId),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      costCp: costCp == null && nullToAbsent
          ? const Value.absent()
          : Value(costCp),
      rarity: rarity == null && nullToAbsent
          ? const Value.absent()
          : Value(rarity),
      attunement: Value(attunement),
    );
  }

  factory ItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemRow(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      name: serializer.fromJson<String>(json['name']),
      extendsId: serializer.fromJson<String?>(json['extendsId']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      costCp: serializer.fromJson<int?>(json['costCp']),
      rarity: serializer.fromJson<String?>(json['rarity']),
      attunement: serializer.fromJson<bool>(json['attunement']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'name': serializer.toJson<String>(name),
      'extendsId': serializer.toJson<String?>(extendsId),
      'weightKg': serializer.toJson<double?>(weightKg),
      'costCp': serializer.toJson<int?>(costCp),
      'rarity': serializer.toJson<String?>(rarity),
      'attunement': serializer.toJson<bool>(attunement),
    };
  }

  ItemRow copyWith({
    String? id,
    String? packId,
    String? name,
    Value<String?> extendsId = const Value.absent(),
    Value<double?> weightKg = const Value.absent(),
    Value<int?> costCp = const Value.absent(),
    Value<String?> rarity = const Value.absent(),
    bool? attunement,
  }) => ItemRow(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    name: name ?? this.name,
    extendsId: extendsId.present ? extendsId.value : this.extendsId,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    costCp: costCp.present ? costCp.value : this.costCp,
    rarity: rarity.present ? rarity.value : this.rarity,
    attunement: attunement ?? this.attunement,
  );
  ItemRow copyWithCompanion(ItemsCompanion data) {
    return ItemRow(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      name: data.name.present ? data.name.value : this.name,
      extendsId: data.extendsId.present ? data.extendsId.value : this.extendsId,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      costCp: data.costCp.present ? data.costCp.value : this.costCp,
      rarity: data.rarity.present ? data.rarity.value : this.rarity,
      attunement: data.attunement.present
          ? data.attunement.value
          : this.attunement,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemRow(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('weightKg: $weightKg, ')
          ..write('costCp: $costCp, ')
          ..write('rarity: $rarity, ')
          ..write('attunement: $attunement')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    packId,
    name,
    extendsId,
    weightKg,
    costCp,
    rarity,
    attunement,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemRow &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.name == this.name &&
          other.extendsId == this.extendsId &&
          other.weightKg == this.weightKg &&
          other.costCp == this.costCp &&
          other.rarity == this.rarity &&
          other.attunement == this.attunement);
}

class ItemsCompanion extends UpdateCompanion<ItemRow> {
  final Value<String> id;
  final Value<String> packId;
  final Value<String> name;
  final Value<String?> extendsId;
  final Value<double?> weightKg;
  final Value<int?> costCp;
  final Value<String?> rarity;
  final Value<bool> attunement;
  final Value<int> rowid;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.name = const Value.absent(),
    this.extendsId = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.costCp = const Value.absent(),
    this.rarity = const Value.absent(),
    this.attunement = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemsCompanion.insert({
    required String id,
    required String packId,
    required String name,
    this.extendsId = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.costCp = const Value.absent(),
    this.rarity = const Value.absent(),
    this.attunement = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       name = Value(name);
  static Insertable<ItemRow> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<String>? name,
    Expression<String>? extendsId,
    Expression<double>? weightKg,
    Expression<int>? costCp,
    Expression<String>? rarity,
    Expression<bool>? attunement,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (name != null) 'name': name,
      if (extendsId != null) 'extends_id': extendsId,
      if (weightKg != null) 'weight_kg': weightKg,
      if (costCp != null) 'cost_cp': costCp,
      if (rarity != null) 'rarity': rarity,
      if (attunement != null) 'attunement': attunement,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<String>? name,
    Value<String?>? extendsId,
    Value<double?>? weightKg,
    Value<int?>? costCp,
    Value<String?>? rarity,
    Value<bool>? attunement,
    Value<int>? rowid,
  }) {
    return ItemsCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      name: name ?? this.name,
      extendsId: extendsId ?? this.extendsId,
      weightKg: weightKg ?? this.weightKg,
      costCp: costCp ?? this.costCp,
      rarity: rarity ?? this.rarity,
      attunement: attunement ?? this.attunement,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (extendsId.present) {
      map['extends_id'] = Variable<String>(extendsId.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (costCp.present) {
      map['cost_cp'] = Variable<int>(costCp.value);
    }
    if (rarity.present) {
      map['rarity'] = Variable<String>(rarity.value);
    }
    if (attunement.present) {
      map['attunement'] = Variable<bool>(attunement.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('weightKg: $weightKg, ')
          ..write('costCp: $costCp, ')
          ..write('rarity: $rarity, ')
          ..write('attunement: $attunement, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BackgroundsTable extends Backgrounds
    with TableInfo<$BackgroundsTable, BackgroundRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BackgroundsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extendsIdMeta = const VerificationMeta(
    'extendsId',
  );
  @override
  late final GeneratedColumn<String> extendsId = GeneratedColumn<String>(
    'extends_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originFeatIdMeta = const VerificationMeta(
    'originFeatId',
  );
  @override
  late final GeneratedColumn<String> originFeatId = GeneratedColumn<String>(
    'origin_feat_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originFeatChoicesMeta = const VerificationMeta(
    'originFeatChoices',
  );
  @override
  late final GeneratedColumn<String> originFeatChoices =
      GeneratedColumn<String>(
        'origin_feat_choices',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _toolChoiceCategoryMeta =
      const VerificationMeta('toolChoiceCategory');
  @override
  late final GeneratedColumn<String> toolChoiceCategory =
      GeneratedColumn<String>(
        'tool_choice_category',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _goldAMeta = const VerificationMeta('goldA');
  @override
  late final GeneratedColumn<int> goldA = GeneratedColumn<int>(
    'gold_a',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _equipmentGoldAltMeta = const VerificationMeta(
    'equipmentGoldAlt',
  );
  @override
  late final GeneratedColumn<int> equipmentGoldAlt = GeneratedColumn<int>(
    'equipment_gold_alt',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packId,
    name,
    extendsId,
    originFeatId,
    originFeatChoices,
    toolChoiceCategory,
    goldA,
    equipmentGoldAlt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'background';
  @override
  VerificationContext validateIntegrity(
    Insertable<BackgroundRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('extends_id')) {
      context.handle(
        _extendsIdMeta,
        extendsId.isAcceptableOrUnknown(data['extends_id']!, _extendsIdMeta),
      );
    }
    if (data.containsKey('origin_feat_id')) {
      context.handle(
        _originFeatIdMeta,
        originFeatId.isAcceptableOrUnknown(
          data['origin_feat_id']!,
          _originFeatIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originFeatIdMeta);
    }
    if (data.containsKey('origin_feat_choices')) {
      context.handle(
        _originFeatChoicesMeta,
        originFeatChoices.isAcceptableOrUnknown(
          data['origin_feat_choices']!,
          _originFeatChoicesMeta,
        ),
      );
    }
    if (data.containsKey('tool_choice_category')) {
      context.handle(
        _toolChoiceCategoryMeta,
        toolChoiceCategory.isAcceptableOrUnknown(
          data['tool_choice_category']!,
          _toolChoiceCategoryMeta,
        ),
      );
    }
    if (data.containsKey('gold_a')) {
      context.handle(
        _goldAMeta,
        goldA.isAcceptableOrUnknown(data['gold_a']!, _goldAMeta),
      );
    } else if (isInserting) {
      context.missing(_goldAMeta);
    }
    if (data.containsKey('equipment_gold_alt')) {
      context.handle(
        _equipmentGoldAltMeta,
        equipmentGoldAlt.isAcceptableOrUnknown(
          data['equipment_gold_alt']!,
          _equipmentGoldAltMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_equipmentGoldAltMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BackgroundRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BackgroundRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      extendsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extends_id'],
      ),
      originFeatId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_feat_id'],
      )!,
      originFeatChoices: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_feat_choices'],
      ),
      toolChoiceCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tool_choice_category'],
      ),
      goldA: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gold_a'],
      )!,
      equipmentGoldAlt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipment_gold_alt'],
      )!,
    );
  }

  @override
  $BackgroundsTable createAlias(String alias) {
    return $BackgroundsTable(attachedDatabase, alias);
  }
}

class BackgroundRow extends DataClass implements Insertable<BackgroundRow> {
  final String id;
  final String packId;
  final String name;
  final String? extendsId;
  final String originFeatId;
  final String? originFeatChoices;
  final String? toolChoiceCategory;
  final int goldA;
  final int equipmentGoldAlt;
  const BackgroundRow({
    required this.id,
    required this.packId,
    required this.name,
    this.extendsId,
    required this.originFeatId,
    this.originFeatChoices,
    this.toolChoiceCategory,
    required this.goldA,
    required this.equipmentGoldAlt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || extendsId != null) {
      map['extends_id'] = Variable<String>(extendsId);
    }
    map['origin_feat_id'] = Variable<String>(originFeatId);
    if (!nullToAbsent || originFeatChoices != null) {
      map['origin_feat_choices'] = Variable<String>(originFeatChoices);
    }
    if (!nullToAbsent || toolChoiceCategory != null) {
      map['tool_choice_category'] = Variable<String>(toolChoiceCategory);
    }
    map['gold_a'] = Variable<int>(goldA);
    map['equipment_gold_alt'] = Variable<int>(equipmentGoldAlt);
    return map;
  }

  BackgroundsCompanion toCompanion(bool nullToAbsent) {
    return BackgroundsCompanion(
      id: Value(id),
      packId: Value(packId),
      name: Value(name),
      extendsId: extendsId == null && nullToAbsent
          ? const Value.absent()
          : Value(extendsId),
      originFeatId: Value(originFeatId),
      originFeatChoices: originFeatChoices == null && nullToAbsent
          ? const Value.absent()
          : Value(originFeatChoices),
      toolChoiceCategory: toolChoiceCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(toolChoiceCategory),
      goldA: Value(goldA),
      equipmentGoldAlt: Value(equipmentGoldAlt),
    );
  }

  factory BackgroundRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BackgroundRow(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      name: serializer.fromJson<String>(json['name']),
      extendsId: serializer.fromJson<String?>(json['extendsId']),
      originFeatId: serializer.fromJson<String>(json['originFeatId']),
      originFeatChoices: serializer.fromJson<String?>(
        json['originFeatChoices'],
      ),
      toolChoiceCategory: serializer.fromJson<String?>(
        json['toolChoiceCategory'],
      ),
      goldA: serializer.fromJson<int>(json['goldA']),
      equipmentGoldAlt: serializer.fromJson<int>(json['equipmentGoldAlt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'name': serializer.toJson<String>(name),
      'extendsId': serializer.toJson<String?>(extendsId),
      'originFeatId': serializer.toJson<String>(originFeatId),
      'originFeatChoices': serializer.toJson<String?>(originFeatChoices),
      'toolChoiceCategory': serializer.toJson<String?>(toolChoiceCategory),
      'goldA': serializer.toJson<int>(goldA),
      'equipmentGoldAlt': serializer.toJson<int>(equipmentGoldAlt),
    };
  }

  BackgroundRow copyWith({
    String? id,
    String? packId,
    String? name,
    Value<String?> extendsId = const Value.absent(),
    String? originFeatId,
    Value<String?> originFeatChoices = const Value.absent(),
    Value<String?> toolChoiceCategory = const Value.absent(),
    int? goldA,
    int? equipmentGoldAlt,
  }) => BackgroundRow(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    name: name ?? this.name,
    extendsId: extendsId.present ? extendsId.value : this.extendsId,
    originFeatId: originFeatId ?? this.originFeatId,
    originFeatChoices: originFeatChoices.present
        ? originFeatChoices.value
        : this.originFeatChoices,
    toolChoiceCategory: toolChoiceCategory.present
        ? toolChoiceCategory.value
        : this.toolChoiceCategory,
    goldA: goldA ?? this.goldA,
    equipmentGoldAlt: equipmentGoldAlt ?? this.equipmentGoldAlt,
  );
  BackgroundRow copyWithCompanion(BackgroundsCompanion data) {
    return BackgroundRow(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      name: data.name.present ? data.name.value : this.name,
      extendsId: data.extendsId.present ? data.extendsId.value : this.extendsId,
      originFeatId: data.originFeatId.present
          ? data.originFeatId.value
          : this.originFeatId,
      originFeatChoices: data.originFeatChoices.present
          ? data.originFeatChoices.value
          : this.originFeatChoices,
      toolChoiceCategory: data.toolChoiceCategory.present
          ? data.toolChoiceCategory.value
          : this.toolChoiceCategory,
      goldA: data.goldA.present ? data.goldA.value : this.goldA,
      equipmentGoldAlt: data.equipmentGoldAlt.present
          ? data.equipmentGoldAlt.value
          : this.equipmentGoldAlt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BackgroundRow(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('originFeatId: $originFeatId, ')
          ..write('originFeatChoices: $originFeatChoices, ')
          ..write('toolChoiceCategory: $toolChoiceCategory, ')
          ..write('goldA: $goldA, ')
          ..write('equipmentGoldAlt: $equipmentGoldAlt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    packId,
    name,
    extendsId,
    originFeatId,
    originFeatChoices,
    toolChoiceCategory,
    goldA,
    equipmentGoldAlt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BackgroundRow &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.name == this.name &&
          other.extendsId == this.extendsId &&
          other.originFeatId == this.originFeatId &&
          other.originFeatChoices == this.originFeatChoices &&
          other.toolChoiceCategory == this.toolChoiceCategory &&
          other.goldA == this.goldA &&
          other.equipmentGoldAlt == this.equipmentGoldAlt);
}

class BackgroundsCompanion extends UpdateCompanion<BackgroundRow> {
  final Value<String> id;
  final Value<String> packId;
  final Value<String> name;
  final Value<String?> extendsId;
  final Value<String> originFeatId;
  final Value<String?> originFeatChoices;
  final Value<String?> toolChoiceCategory;
  final Value<int> goldA;
  final Value<int> equipmentGoldAlt;
  final Value<int> rowid;
  const BackgroundsCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.name = const Value.absent(),
    this.extendsId = const Value.absent(),
    this.originFeatId = const Value.absent(),
    this.originFeatChoices = const Value.absent(),
    this.toolChoiceCategory = const Value.absent(),
    this.goldA = const Value.absent(),
    this.equipmentGoldAlt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BackgroundsCompanion.insert({
    required String id,
    required String packId,
    required String name,
    this.extendsId = const Value.absent(),
    required String originFeatId,
    this.originFeatChoices = const Value.absent(),
    this.toolChoiceCategory = const Value.absent(),
    required int goldA,
    required int equipmentGoldAlt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       name = Value(name),
       originFeatId = Value(originFeatId),
       goldA = Value(goldA),
       equipmentGoldAlt = Value(equipmentGoldAlt);
  static Insertable<BackgroundRow> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<String>? name,
    Expression<String>? extendsId,
    Expression<String>? originFeatId,
    Expression<String>? originFeatChoices,
    Expression<String>? toolChoiceCategory,
    Expression<int>? goldA,
    Expression<int>? equipmentGoldAlt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (name != null) 'name': name,
      if (extendsId != null) 'extends_id': extendsId,
      if (originFeatId != null) 'origin_feat_id': originFeatId,
      if (originFeatChoices != null) 'origin_feat_choices': originFeatChoices,
      if (toolChoiceCategory != null)
        'tool_choice_category': toolChoiceCategory,
      if (goldA != null) 'gold_a': goldA,
      if (equipmentGoldAlt != null) 'equipment_gold_alt': equipmentGoldAlt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BackgroundsCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<String>? name,
    Value<String?>? extendsId,
    Value<String>? originFeatId,
    Value<String?>? originFeatChoices,
    Value<String?>? toolChoiceCategory,
    Value<int>? goldA,
    Value<int>? equipmentGoldAlt,
    Value<int>? rowid,
  }) {
    return BackgroundsCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      name: name ?? this.name,
      extendsId: extendsId ?? this.extendsId,
      originFeatId: originFeatId ?? this.originFeatId,
      originFeatChoices: originFeatChoices ?? this.originFeatChoices,
      toolChoiceCategory: toolChoiceCategory ?? this.toolChoiceCategory,
      goldA: goldA ?? this.goldA,
      equipmentGoldAlt: equipmentGoldAlt ?? this.equipmentGoldAlt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (extendsId.present) {
      map['extends_id'] = Variable<String>(extendsId.value);
    }
    if (originFeatId.present) {
      map['origin_feat_id'] = Variable<String>(originFeatId.value);
    }
    if (originFeatChoices.present) {
      map['origin_feat_choices'] = Variable<String>(originFeatChoices.value);
    }
    if (toolChoiceCategory.present) {
      map['tool_choice_category'] = Variable<String>(toolChoiceCategory.value);
    }
    if (goldA.present) {
      map['gold_a'] = Variable<int>(goldA.value);
    }
    if (equipmentGoldAlt.present) {
      map['equipment_gold_alt'] = Variable<int>(equipmentGoldAlt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BackgroundsCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('originFeatId: $originFeatId, ')
          ..write('originFeatChoices: $originFeatChoices, ')
          ..write('toolChoiceCategory: $toolChoiceCategory, ')
          ..write('goldA: $goldA, ')
          ..write('equipmentGoldAlt: $equipmentGoldAlt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BackgroundAbilitiesTable extends BackgroundAbilities
    with TableInfo<$BackgroundAbilitiesTable, BackgroundAbilityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BackgroundAbilitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _backgroundIdMeta = const VerificationMeta(
    'backgroundId',
  );
  @override
  late final GeneratedColumn<String> backgroundId = GeneratedColumn<String>(
    'background_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _abilityIdMeta = const VerificationMeta(
    'abilityId',
  );
  @override
  late final GeneratedColumn<String> abilityId = GeneratedColumn<String>(
    'ability_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    packId,
    backgroundId,
    position,
    abilityId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'background_ability';
  @override
  VerificationContext validateIntegrity(
    Insertable<BackgroundAbilityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('background_id')) {
      context.handle(
        _backgroundIdMeta,
        backgroundId.isAcceptableOrUnknown(
          data['background_id']!,
          _backgroundIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_backgroundIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('ability_id')) {
      context.handle(
        _abilityIdMeta,
        abilityId.isAcceptableOrUnknown(data['ability_id']!, _abilityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_abilityIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {backgroundId, position};
  @override
  BackgroundAbilityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BackgroundAbilityRow(
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      backgroundId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}background_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      abilityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ability_id'],
      )!,
    );
  }

  @override
  $BackgroundAbilitiesTable createAlias(String alias) {
    return $BackgroundAbilitiesTable(attachedDatabase, alias);
  }
}

class BackgroundAbilityRow extends DataClass
    implements Insertable<BackgroundAbilityRow> {
  final String packId;
  final String backgroundId;
  final int position;
  final String abilityId;
  const BackgroundAbilityRow({
    required this.packId,
    required this.backgroundId,
    required this.position,
    required this.abilityId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pack_id'] = Variable<String>(packId);
    map['background_id'] = Variable<String>(backgroundId);
    map['position'] = Variable<int>(position);
    map['ability_id'] = Variable<String>(abilityId);
    return map;
  }

  BackgroundAbilitiesCompanion toCompanion(bool nullToAbsent) {
    return BackgroundAbilitiesCompanion(
      packId: Value(packId),
      backgroundId: Value(backgroundId),
      position: Value(position),
      abilityId: Value(abilityId),
    );
  }

  factory BackgroundAbilityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BackgroundAbilityRow(
      packId: serializer.fromJson<String>(json['packId']),
      backgroundId: serializer.fromJson<String>(json['backgroundId']),
      position: serializer.fromJson<int>(json['position']),
      abilityId: serializer.fromJson<String>(json['abilityId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packId': serializer.toJson<String>(packId),
      'backgroundId': serializer.toJson<String>(backgroundId),
      'position': serializer.toJson<int>(position),
      'abilityId': serializer.toJson<String>(abilityId),
    };
  }

  BackgroundAbilityRow copyWith({
    String? packId,
    String? backgroundId,
    int? position,
    String? abilityId,
  }) => BackgroundAbilityRow(
    packId: packId ?? this.packId,
    backgroundId: backgroundId ?? this.backgroundId,
    position: position ?? this.position,
    abilityId: abilityId ?? this.abilityId,
  );
  BackgroundAbilityRow copyWithCompanion(BackgroundAbilitiesCompanion data) {
    return BackgroundAbilityRow(
      packId: data.packId.present ? data.packId.value : this.packId,
      backgroundId: data.backgroundId.present
          ? data.backgroundId.value
          : this.backgroundId,
      position: data.position.present ? data.position.value : this.position,
      abilityId: data.abilityId.present ? data.abilityId.value : this.abilityId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BackgroundAbilityRow(')
          ..write('packId: $packId, ')
          ..write('backgroundId: $backgroundId, ')
          ..write('position: $position, ')
          ..write('abilityId: $abilityId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(packId, backgroundId, position, abilityId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BackgroundAbilityRow &&
          other.packId == this.packId &&
          other.backgroundId == this.backgroundId &&
          other.position == this.position &&
          other.abilityId == this.abilityId);
}

class BackgroundAbilitiesCompanion
    extends UpdateCompanion<BackgroundAbilityRow> {
  final Value<String> packId;
  final Value<String> backgroundId;
  final Value<int> position;
  final Value<String> abilityId;
  final Value<int> rowid;
  const BackgroundAbilitiesCompanion({
    this.packId = const Value.absent(),
    this.backgroundId = const Value.absent(),
    this.position = const Value.absent(),
    this.abilityId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BackgroundAbilitiesCompanion.insert({
    required String packId,
    required String backgroundId,
    required int position,
    required String abilityId,
    this.rowid = const Value.absent(),
  }) : packId = Value(packId),
       backgroundId = Value(backgroundId),
       position = Value(position),
       abilityId = Value(abilityId);
  static Insertable<BackgroundAbilityRow> custom({
    Expression<String>? packId,
    Expression<String>? backgroundId,
    Expression<int>? position,
    Expression<String>? abilityId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packId != null) 'pack_id': packId,
      if (backgroundId != null) 'background_id': backgroundId,
      if (position != null) 'position': position,
      if (abilityId != null) 'ability_id': abilityId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BackgroundAbilitiesCompanion copyWith({
    Value<String>? packId,
    Value<String>? backgroundId,
    Value<int>? position,
    Value<String>? abilityId,
    Value<int>? rowid,
  }) {
    return BackgroundAbilitiesCompanion(
      packId: packId ?? this.packId,
      backgroundId: backgroundId ?? this.backgroundId,
      position: position ?? this.position,
      abilityId: abilityId ?? this.abilityId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (backgroundId.present) {
      map['background_id'] = Variable<String>(backgroundId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (abilityId.present) {
      map['ability_id'] = Variable<String>(abilityId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BackgroundAbilitiesCompanion(')
          ..write('packId: $packId, ')
          ..write('backgroundId: $backgroundId, ')
          ..write('position: $position, ')
          ..write('abilityId: $abilityId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BackgroundProficienciesTable extends BackgroundProficiencies
    with TableInfo<$BackgroundProficienciesTable, BackgroundProficiencyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BackgroundProficienciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _backgroundIdMeta = const VerificationMeta(
    'backgroundId',
  );
  @override
  late final GeneratedColumn<String> backgroundId = GeneratedColumn<String>(
    'background_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refIdMeta = const VerificationMeta('refId');
  @override
  late final GeneratedColumn<String> refId = GeneratedColumn<String>(
    'ref_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    packId,
    backgroundId,
    position,
    type,
    refId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'background_proficiency';
  @override
  VerificationContext validateIntegrity(
    Insertable<BackgroundProficiencyRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('background_id')) {
      context.handle(
        _backgroundIdMeta,
        backgroundId.isAcceptableOrUnknown(
          data['background_id']!,
          _backgroundIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_backgroundIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('ref_id')) {
      context.handle(
        _refIdMeta,
        refId.isAcceptableOrUnknown(data['ref_id']!, _refIdMeta),
      );
    } else if (isInserting) {
      context.missing(_refIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {backgroundId, position};
  @override
  BackgroundProficiencyRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BackgroundProficiencyRow(
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      backgroundId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}background_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      refId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref_id'],
      )!,
    );
  }

  @override
  $BackgroundProficienciesTable createAlias(String alias) {
    return $BackgroundProficienciesTable(attachedDatabase, alias);
  }
}

class BackgroundProficiencyRow extends DataClass
    implements Insertable<BackgroundProficiencyRow> {
  final String packId;
  final String backgroundId;
  final int position;

  /// `skill` ou `tool`.
  final String type;
  final String refId;
  const BackgroundProficiencyRow({
    required this.packId,
    required this.backgroundId,
    required this.position,
    required this.type,
    required this.refId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pack_id'] = Variable<String>(packId);
    map['background_id'] = Variable<String>(backgroundId);
    map['position'] = Variable<int>(position);
    map['type'] = Variable<String>(type);
    map['ref_id'] = Variable<String>(refId);
    return map;
  }

  BackgroundProficienciesCompanion toCompanion(bool nullToAbsent) {
    return BackgroundProficienciesCompanion(
      packId: Value(packId),
      backgroundId: Value(backgroundId),
      position: Value(position),
      type: Value(type),
      refId: Value(refId),
    );
  }

  factory BackgroundProficiencyRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BackgroundProficiencyRow(
      packId: serializer.fromJson<String>(json['packId']),
      backgroundId: serializer.fromJson<String>(json['backgroundId']),
      position: serializer.fromJson<int>(json['position']),
      type: serializer.fromJson<String>(json['type']),
      refId: serializer.fromJson<String>(json['refId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packId': serializer.toJson<String>(packId),
      'backgroundId': serializer.toJson<String>(backgroundId),
      'position': serializer.toJson<int>(position),
      'type': serializer.toJson<String>(type),
      'refId': serializer.toJson<String>(refId),
    };
  }

  BackgroundProficiencyRow copyWith({
    String? packId,
    String? backgroundId,
    int? position,
    String? type,
    String? refId,
  }) => BackgroundProficiencyRow(
    packId: packId ?? this.packId,
    backgroundId: backgroundId ?? this.backgroundId,
    position: position ?? this.position,
    type: type ?? this.type,
    refId: refId ?? this.refId,
  );
  BackgroundProficiencyRow copyWithCompanion(
    BackgroundProficienciesCompanion data,
  ) {
    return BackgroundProficiencyRow(
      packId: data.packId.present ? data.packId.value : this.packId,
      backgroundId: data.backgroundId.present
          ? data.backgroundId.value
          : this.backgroundId,
      position: data.position.present ? data.position.value : this.position,
      type: data.type.present ? data.type.value : this.type,
      refId: data.refId.present ? data.refId.value : this.refId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BackgroundProficiencyRow(')
          ..write('packId: $packId, ')
          ..write('backgroundId: $backgroundId, ')
          ..write('position: $position, ')
          ..write('type: $type, ')
          ..write('refId: $refId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(packId, backgroundId, position, type, refId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BackgroundProficiencyRow &&
          other.packId == this.packId &&
          other.backgroundId == this.backgroundId &&
          other.position == this.position &&
          other.type == this.type &&
          other.refId == this.refId);
}

class BackgroundProficienciesCompanion
    extends UpdateCompanion<BackgroundProficiencyRow> {
  final Value<String> packId;
  final Value<String> backgroundId;
  final Value<int> position;
  final Value<String> type;
  final Value<String> refId;
  final Value<int> rowid;
  const BackgroundProficienciesCompanion({
    this.packId = const Value.absent(),
    this.backgroundId = const Value.absent(),
    this.position = const Value.absent(),
    this.type = const Value.absent(),
    this.refId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BackgroundProficienciesCompanion.insert({
    required String packId,
    required String backgroundId,
    required int position,
    required String type,
    required String refId,
    this.rowid = const Value.absent(),
  }) : packId = Value(packId),
       backgroundId = Value(backgroundId),
       position = Value(position),
       type = Value(type),
       refId = Value(refId);
  static Insertable<BackgroundProficiencyRow> custom({
    Expression<String>? packId,
    Expression<String>? backgroundId,
    Expression<int>? position,
    Expression<String>? type,
    Expression<String>? refId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packId != null) 'pack_id': packId,
      if (backgroundId != null) 'background_id': backgroundId,
      if (position != null) 'position': position,
      if (type != null) 'type': type,
      if (refId != null) 'ref_id': refId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BackgroundProficienciesCompanion copyWith({
    Value<String>? packId,
    Value<String>? backgroundId,
    Value<int>? position,
    Value<String>? type,
    Value<String>? refId,
    Value<int>? rowid,
  }) {
    return BackgroundProficienciesCompanion(
      packId: packId ?? this.packId,
      backgroundId: backgroundId ?? this.backgroundId,
      position: position ?? this.position,
      type: type ?? this.type,
      refId: refId ?? this.refId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (backgroundId.present) {
      map['background_id'] = Variable<String>(backgroundId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (refId.present) {
      map['ref_id'] = Variable<String>(refId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BackgroundProficienciesCompanion(')
          ..write('packId: $packId, ')
          ..write('backgroundId: $backgroundId, ')
          ..write('position: $position, ')
          ..write('type: $type, ')
          ..write('refId: $refId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BackgroundEquipmentOptionsTable extends BackgroundEquipmentOptions
    with
        TableInfo<
          $BackgroundEquipmentOptionsTable,
          BackgroundEquipmentOptionRow
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BackgroundEquipmentOptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _backgroundIdMeta = const VerificationMeta(
    'backgroundId',
  );
  @override
  late final GeneratedColumn<String> backgroundId = GeneratedColumn<String>(
    'background_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionMeta = const VerificationMeta('option');
  @override
  late final GeneratedColumn<String> option = GeneratedColumn<String>(
    'option',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemsMeta = const VerificationMeta('items');
  @override
  late final GeneratedColumn<String> items = GeneratedColumn<String>(
    'items',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [packId, backgroundId, option, items];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'background_equipment_option';
  @override
  VerificationContext validateIntegrity(
    Insertable<BackgroundEquipmentOptionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('background_id')) {
      context.handle(
        _backgroundIdMeta,
        backgroundId.isAcceptableOrUnknown(
          data['background_id']!,
          _backgroundIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_backgroundIdMeta);
    }
    if (data.containsKey('option')) {
      context.handle(
        _optionMeta,
        option.isAcceptableOrUnknown(data['option']!, _optionMeta),
      );
    } else if (isInserting) {
      context.missing(_optionMeta);
    }
    if (data.containsKey('items')) {
      context.handle(
        _itemsMeta,
        items.isAcceptableOrUnknown(data['items']!, _itemsMeta),
      );
    } else if (isInserting) {
      context.missing(_itemsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {backgroundId, option};
  @override
  BackgroundEquipmentOptionRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BackgroundEquipmentOptionRow(
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      backgroundId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}background_id'],
      )!,
      option: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}option'],
      )!,
      items: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}items'],
      )!,
    );
  }

  @override
  $BackgroundEquipmentOptionsTable createAlias(String alias) {
    return $BackgroundEquipmentOptionsTable(attachedDatabase, alias);
  }
}

class BackgroundEquipmentOptionRow extends DataClass
    implements Insertable<BackgroundEquipmentOptionRow> {
  final String packId;
  final String backgroundId;
  final String option;
  final String items;
  const BackgroundEquipmentOptionRow({
    required this.packId,
    required this.backgroundId,
    required this.option,
    required this.items,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pack_id'] = Variable<String>(packId);
    map['background_id'] = Variable<String>(backgroundId);
    map['option'] = Variable<String>(option);
    map['items'] = Variable<String>(items);
    return map;
  }

  BackgroundEquipmentOptionsCompanion toCompanion(bool nullToAbsent) {
    return BackgroundEquipmentOptionsCompanion(
      packId: Value(packId),
      backgroundId: Value(backgroundId),
      option: Value(option),
      items: Value(items),
    );
  }

  factory BackgroundEquipmentOptionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BackgroundEquipmentOptionRow(
      packId: serializer.fromJson<String>(json['packId']),
      backgroundId: serializer.fromJson<String>(json['backgroundId']),
      option: serializer.fromJson<String>(json['option']),
      items: serializer.fromJson<String>(json['items']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packId': serializer.toJson<String>(packId),
      'backgroundId': serializer.toJson<String>(backgroundId),
      'option': serializer.toJson<String>(option),
      'items': serializer.toJson<String>(items),
    };
  }

  BackgroundEquipmentOptionRow copyWith({
    String? packId,
    String? backgroundId,
    String? option,
    String? items,
  }) => BackgroundEquipmentOptionRow(
    packId: packId ?? this.packId,
    backgroundId: backgroundId ?? this.backgroundId,
    option: option ?? this.option,
    items: items ?? this.items,
  );
  BackgroundEquipmentOptionRow copyWithCompanion(
    BackgroundEquipmentOptionsCompanion data,
  ) {
    return BackgroundEquipmentOptionRow(
      packId: data.packId.present ? data.packId.value : this.packId,
      backgroundId: data.backgroundId.present
          ? data.backgroundId.value
          : this.backgroundId,
      option: data.option.present ? data.option.value : this.option,
      items: data.items.present ? data.items.value : this.items,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BackgroundEquipmentOptionRow(')
          ..write('packId: $packId, ')
          ..write('backgroundId: $backgroundId, ')
          ..write('option: $option, ')
          ..write('items: $items')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(packId, backgroundId, option, items);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BackgroundEquipmentOptionRow &&
          other.packId == this.packId &&
          other.backgroundId == this.backgroundId &&
          other.option == this.option &&
          other.items == this.items);
}

class BackgroundEquipmentOptionsCompanion
    extends UpdateCompanion<BackgroundEquipmentOptionRow> {
  final Value<String> packId;
  final Value<String> backgroundId;
  final Value<String> option;
  final Value<String> items;
  final Value<int> rowid;
  const BackgroundEquipmentOptionsCompanion({
    this.packId = const Value.absent(),
    this.backgroundId = const Value.absent(),
    this.option = const Value.absent(),
    this.items = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BackgroundEquipmentOptionsCompanion.insert({
    required String packId,
    required String backgroundId,
    required String option,
    required String items,
    this.rowid = const Value.absent(),
  }) : packId = Value(packId),
       backgroundId = Value(backgroundId),
       option = Value(option),
       items = Value(items);
  static Insertable<BackgroundEquipmentOptionRow> custom({
    Expression<String>? packId,
    Expression<String>? backgroundId,
    Expression<String>? option,
    Expression<String>? items,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packId != null) 'pack_id': packId,
      if (backgroundId != null) 'background_id': backgroundId,
      if (option != null) 'option': option,
      if (items != null) 'items': items,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BackgroundEquipmentOptionsCompanion copyWith({
    Value<String>? packId,
    Value<String>? backgroundId,
    Value<String>? option,
    Value<String>? items,
    Value<int>? rowid,
  }) {
    return BackgroundEquipmentOptionsCompanion(
      packId: packId ?? this.packId,
      backgroundId: backgroundId ?? this.backgroundId,
      option: option ?? this.option,
      items: items ?? this.items,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (backgroundId.present) {
      map['background_id'] = Variable<String>(backgroundId.value);
    }
    if (option.present) {
      map['option'] = Variable<String>(option.value);
    }
    if (items.present) {
      map['items'] = Variable<String>(items.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BackgroundEquipmentOptionsCompanion(')
          ..write('packId: $packId, ')
          ..write('backgroundId: $backgroundId, ')
          ..write('option: $option, ')
          ..write('items: $items, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FeatsTable extends Feats with TableInfo<$FeatsTable, FeatRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extendsIdMeta = const VerificationMeta(
    'extendsId',
  );
  @override
  late final GeneratedColumn<String> extendsId = GeneratedColumn<String>(
    'extends_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prerequisitesMeta = const VerificationMeta(
    'prerequisites',
  );
  @override
  late final GeneratedColumn<String> prerequisites = GeneratedColumn<String>(
    'prerequisites',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatableMeta = const VerificationMeta(
    'repeatable',
  );
  @override
  late final GeneratedColumn<bool> repeatable = GeneratedColumn<bool>(
    'repeatable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("repeatable" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packId,
    name,
    extendsId,
    category,
    prerequisites,
    repeatable,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feat';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeatRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('extends_id')) {
      context.handle(
        _extendsIdMeta,
        extendsId.isAcceptableOrUnknown(data['extends_id']!, _extendsIdMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('prerequisites')) {
      context.handle(
        _prerequisitesMeta,
        prerequisites.isAcceptableOrUnknown(
          data['prerequisites']!,
          _prerequisitesMeta,
        ),
      );
    }
    if (data.containsKey('repeatable')) {
      context.handle(
        _repeatableMeta,
        repeatable.isAcceptableOrUnknown(data['repeatable']!, _repeatableMeta),
      );
    } else if (isInserting) {
      context.missing(_repeatableMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeatRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeatRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      extendsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extends_id'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      prerequisites: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prerequisites'],
      ),
      repeatable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}repeatable'],
      )!,
    );
  }

  @override
  $FeatsTable createAlias(String alias) {
    return $FeatsTable(attachedDatabase, alias);
  }
}

class FeatRow extends DataClass implements Insertable<FeatRow> {
  final String id;
  final String packId;
  final String name;
  final String? extendsId;
  final String category;
  final String? prerequisites;
  final bool repeatable;
  const FeatRow({
    required this.id,
    required this.packId,
    required this.name,
    this.extendsId,
    required this.category,
    this.prerequisites,
    required this.repeatable,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || extendsId != null) {
      map['extends_id'] = Variable<String>(extendsId);
    }
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || prerequisites != null) {
      map['prerequisites'] = Variable<String>(prerequisites);
    }
    map['repeatable'] = Variable<bool>(repeatable);
    return map;
  }

  FeatsCompanion toCompanion(bool nullToAbsent) {
    return FeatsCompanion(
      id: Value(id),
      packId: Value(packId),
      name: Value(name),
      extendsId: extendsId == null && nullToAbsent
          ? const Value.absent()
          : Value(extendsId),
      category: Value(category),
      prerequisites: prerequisites == null && nullToAbsent
          ? const Value.absent()
          : Value(prerequisites),
      repeatable: Value(repeatable),
    );
  }

  factory FeatRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeatRow(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      name: serializer.fromJson<String>(json['name']),
      extendsId: serializer.fromJson<String?>(json['extendsId']),
      category: serializer.fromJson<String>(json['category']),
      prerequisites: serializer.fromJson<String?>(json['prerequisites']),
      repeatable: serializer.fromJson<bool>(json['repeatable']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'name': serializer.toJson<String>(name),
      'extendsId': serializer.toJson<String?>(extendsId),
      'category': serializer.toJson<String>(category),
      'prerequisites': serializer.toJson<String?>(prerequisites),
      'repeatable': serializer.toJson<bool>(repeatable),
    };
  }

  FeatRow copyWith({
    String? id,
    String? packId,
    String? name,
    Value<String?> extendsId = const Value.absent(),
    String? category,
    Value<String?> prerequisites = const Value.absent(),
    bool? repeatable,
  }) => FeatRow(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    name: name ?? this.name,
    extendsId: extendsId.present ? extendsId.value : this.extendsId,
    category: category ?? this.category,
    prerequisites: prerequisites.present
        ? prerequisites.value
        : this.prerequisites,
    repeatable: repeatable ?? this.repeatable,
  );
  FeatRow copyWithCompanion(FeatsCompanion data) {
    return FeatRow(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      name: data.name.present ? data.name.value : this.name,
      extendsId: data.extendsId.present ? data.extendsId.value : this.extendsId,
      category: data.category.present ? data.category.value : this.category,
      prerequisites: data.prerequisites.present
          ? data.prerequisites.value
          : this.prerequisites,
      repeatable: data.repeatable.present
          ? data.repeatable.value
          : this.repeatable,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeatRow(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('category: $category, ')
          ..write('prerequisites: $prerequisites, ')
          ..write('repeatable: $repeatable')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    packId,
    name,
    extendsId,
    category,
    prerequisites,
    repeatable,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeatRow &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.name == this.name &&
          other.extendsId == this.extendsId &&
          other.category == this.category &&
          other.prerequisites == this.prerequisites &&
          other.repeatable == this.repeatable);
}

class FeatsCompanion extends UpdateCompanion<FeatRow> {
  final Value<String> id;
  final Value<String> packId;
  final Value<String> name;
  final Value<String?> extendsId;
  final Value<String> category;
  final Value<String?> prerequisites;
  final Value<bool> repeatable;
  final Value<int> rowid;
  const FeatsCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.name = const Value.absent(),
    this.extendsId = const Value.absent(),
    this.category = const Value.absent(),
    this.prerequisites = const Value.absent(),
    this.repeatable = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FeatsCompanion.insert({
    required String id,
    required String packId,
    required String name,
    this.extendsId = const Value.absent(),
    required String category,
    this.prerequisites = const Value.absent(),
    required bool repeatable,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       name = Value(name),
       category = Value(category),
       repeatable = Value(repeatable);
  static Insertable<FeatRow> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<String>? name,
    Expression<String>? extendsId,
    Expression<String>? category,
    Expression<String>? prerequisites,
    Expression<bool>? repeatable,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (name != null) 'name': name,
      if (extendsId != null) 'extends_id': extendsId,
      if (category != null) 'category': category,
      if (prerequisites != null) 'prerequisites': prerequisites,
      if (repeatable != null) 'repeatable': repeatable,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FeatsCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<String>? name,
    Value<String?>? extendsId,
    Value<String>? category,
    Value<String?>? prerequisites,
    Value<bool>? repeatable,
    Value<int>? rowid,
  }) {
    return FeatsCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      name: name ?? this.name,
      extendsId: extendsId ?? this.extendsId,
      category: category ?? this.category,
      prerequisites: prerequisites ?? this.prerequisites,
      repeatable: repeatable ?? this.repeatable,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (extendsId.present) {
      map['extends_id'] = Variable<String>(extendsId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (prerequisites.present) {
      map['prerequisites'] = Variable<String>(prerequisites.value);
    }
    if (repeatable.present) {
      map['repeatable'] = Variable<bool>(repeatable.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeatsCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('category: $category, ')
          ..write('prerequisites: $prerequisites, ')
          ..write('repeatable: $repeatable, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SpeciesTableTable extends SpeciesTable
    with TableInfo<$SpeciesTableTable, SpeciesRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpeciesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extendsIdMeta = const VerificationMeta(
    'extendsId',
  );
  @override
  late final GeneratedColumn<String> extendsId = GeneratedColumn<String>(
    'extends_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creatureTypeMeta = const VerificationMeta(
    'creatureType',
  );
  @override
  late final GeneratedColumn<String> creatureType = GeneratedColumn<String>(
    'creature_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizesMeta = const VerificationMeta('sizes');
  @override
  late final GeneratedColumn<String> sizes = GeneratedColumn<String>(
    'sizes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speedFeetMeta = const VerificationMeta(
    'speedFeet',
  );
  @override
  late final GeneratedColumn<int> speedFeet = GeneratedColumn<int>(
    'speed_feet',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packId,
    name,
    extendsId,
    creatureType,
    sizes,
    speedFeet,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'species';
  @override
  VerificationContext validateIntegrity(
    Insertable<SpeciesRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('extends_id')) {
      context.handle(
        _extendsIdMeta,
        extendsId.isAcceptableOrUnknown(data['extends_id']!, _extendsIdMeta),
      );
    }
    if (data.containsKey('creature_type')) {
      context.handle(
        _creatureTypeMeta,
        creatureType.isAcceptableOrUnknown(
          data['creature_type']!,
          _creatureTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_creatureTypeMeta);
    }
    if (data.containsKey('sizes')) {
      context.handle(
        _sizesMeta,
        sizes.isAcceptableOrUnknown(data['sizes']!, _sizesMeta),
      );
    } else if (isInserting) {
      context.missing(_sizesMeta);
    }
    if (data.containsKey('speed_feet')) {
      context.handle(
        _speedFeetMeta,
        speedFeet.isAcceptableOrUnknown(data['speed_feet']!, _speedFeetMeta),
      );
    } else if (isInserting) {
      context.missing(_speedFeetMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpeciesRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpeciesRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      extendsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extends_id'],
      ),
      creatureType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creature_type'],
      )!,
      sizes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sizes'],
      )!,
      speedFeet: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}speed_feet'],
      )!,
    );
  }

  @override
  $SpeciesTableTable createAlias(String alias) {
    return $SpeciesTableTable(attachedDatabase, alias);
  }
}

class SpeciesRow extends DataClass implements Insertable<SpeciesRow> {
  final String id;
  final String packId;
  final String name;
  final String? extendsId;
  final String creatureType;
  final String sizes;
  final int speedFeet;
  const SpeciesRow({
    required this.id,
    required this.packId,
    required this.name,
    this.extendsId,
    required this.creatureType,
    required this.sizes,
    required this.speedFeet,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || extendsId != null) {
      map['extends_id'] = Variable<String>(extendsId);
    }
    map['creature_type'] = Variable<String>(creatureType);
    map['sizes'] = Variable<String>(sizes);
    map['speed_feet'] = Variable<int>(speedFeet);
    return map;
  }

  SpeciesTableCompanion toCompanion(bool nullToAbsent) {
    return SpeciesTableCompanion(
      id: Value(id),
      packId: Value(packId),
      name: Value(name),
      extendsId: extendsId == null && nullToAbsent
          ? const Value.absent()
          : Value(extendsId),
      creatureType: Value(creatureType),
      sizes: Value(sizes),
      speedFeet: Value(speedFeet),
    );
  }

  factory SpeciesRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpeciesRow(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      name: serializer.fromJson<String>(json['name']),
      extendsId: serializer.fromJson<String?>(json['extendsId']),
      creatureType: serializer.fromJson<String>(json['creatureType']),
      sizes: serializer.fromJson<String>(json['sizes']),
      speedFeet: serializer.fromJson<int>(json['speedFeet']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'name': serializer.toJson<String>(name),
      'extendsId': serializer.toJson<String?>(extendsId),
      'creatureType': serializer.toJson<String>(creatureType),
      'sizes': serializer.toJson<String>(sizes),
      'speedFeet': serializer.toJson<int>(speedFeet),
    };
  }

  SpeciesRow copyWith({
    String? id,
    String? packId,
    String? name,
    Value<String?> extendsId = const Value.absent(),
    String? creatureType,
    String? sizes,
    int? speedFeet,
  }) => SpeciesRow(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    name: name ?? this.name,
    extendsId: extendsId.present ? extendsId.value : this.extendsId,
    creatureType: creatureType ?? this.creatureType,
    sizes: sizes ?? this.sizes,
    speedFeet: speedFeet ?? this.speedFeet,
  );
  SpeciesRow copyWithCompanion(SpeciesTableCompanion data) {
    return SpeciesRow(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      name: data.name.present ? data.name.value : this.name,
      extendsId: data.extendsId.present ? data.extendsId.value : this.extendsId,
      creatureType: data.creatureType.present
          ? data.creatureType.value
          : this.creatureType,
      sizes: data.sizes.present ? data.sizes.value : this.sizes,
      speedFeet: data.speedFeet.present ? data.speedFeet.value : this.speedFeet,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpeciesRow(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('creatureType: $creatureType, ')
          ..write('sizes: $sizes, ')
          ..write('speedFeet: $speedFeet')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, packId, name, extendsId, creatureType, sizes, speedFeet);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpeciesRow &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.name == this.name &&
          other.extendsId == this.extendsId &&
          other.creatureType == this.creatureType &&
          other.sizes == this.sizes &&
          other.speedFeet == this.speedFeet);
}

class SpeciesTableCompanion extends UpdateCompanion<SpeciesRow> {
  final Value<String> id;
  final Value<String> packId;
  final Value<String> name;
  final Value<String?> extendsId;
  final Value<String> creatureType;
  final Value<String> sizes;
  final Value<int> speedFeet;
  final Value<int> rowid;
  const SpeciesTableCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.name = const Value.absent(),
    this.extendsId = const Value.absent(),
    this.creatureType = const Value.absent(),
    this.sizes = const Value.absent(),
    this.speedFeet = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpeciesTableCompanion.insert({
    required String id,
    required String packId,
    required String name,
    this.extendsId = const Value.absent(),
    required String creatureType,
    required String sizes,
    required int speedFeet,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       name = Value(name),
       creatureType = Value(creatureType),
       sizes = Value(sizes),
       speedFeet = Value(speedFeet);
  static Insertable<SpeciesRow> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<String>? name,
    Expression<String>? extendsId,
    Expression<String>? creatureType,
    Expression<String>? sizes,
    Expression<int>? speedFeet,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (name != null) 'name': name,
      if (extendsId != null) 'extends_id': extendsId,
      if (creatureType != null) 'creature_type': creatureType,
      if (sizes != null) 'sizes': sizes,
      if (speedFeet != null) 'speed_feet': speedFeet,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpeciesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<String>? name,
    Value<String?>? extendsId,
    Value<String>? creatureType,
    Value<String>? sizes,
    Value<int>? speedFeet,
    Value<int>? rowid,
  }) {
    return SpeciesTableCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      name: name ?? this.name,
      extendsId: extendsId ?? this.extendsId,
      creatureType: creatureType ?? this.creatureType,
      sizes: sizes ?? this.sizes,
      speedFeet: speedFeet ?? this.speedFeet,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (extendsId.present) {
      map['extends_id'] = Variable<String>(extendsId.value);
    }
    if (creatureType.present) {
      map['creature_type'] = Variable<String>(creatureType.value);
    }
    if (sizes.present) {
      map['sizes'] = Variable<String>(sizes.value);
    }
    if (speedFeet.present) {
      map['speed_feet'] = Variable<int>(speedFeet.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpeciesTableCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('creatureType: $creatureType, ')
          ..write('sizes: $sizes, ')
          ..write('speedFeet: $speedFeet, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SpeciesTraitsTable extends SpeciesTraits
    with TableInfo<$SpeciesTraitsTable, SpeciesTraitRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpeciesTraitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _speciesIdMeta = const VerificationMeta(
    'speciesId',
  );
  @override
  late final GeneratedColumn<String> speciesId = GeneratedColumn<String>(
    'species_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _featureIdMeta = const VerificationMeta(
    'featureId',
  );
  @override
  late final GeneratedColumn<String> featureId = GeneratedColumn<String>(
    'feature_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    packId,
    speciesId,
    position,
    featureId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'species_trait';
  @override
  VerificationContext validateIntegrity(
    Insertable<SpeciesTraitRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('species_id')) {
      context.handle(
        _speciesIdMeta,
        speciesId.isAcceptableOrUnknown(data['species_id']!, _speciesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_speciesIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('feature_id')) {
      context.handle(
        _featureIdMeta,
        featureId.isAcceptableOrUnknown(data['feature_id']!, _featureIdMeta),
      );
    } else if (isInserting) {
      context.missing(_featureIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {speciesId, position};
  @override
  SpeciesTraitRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpeciesTraitRow(
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      speciesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}species_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      featureId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feature_id'],
      )!,
    );
  }

  @override
  $SpeciesTraitsTable createAlias(String alias) {
    return $SpeciesTraitsTable(attachedDatabase, alias);
  }
}

class SpeciesTraitRow extends DataClass implements Insertable<SpeciesTraitRow> {
  final String packId;
  final String speciesId;
  final int position;
  final String featureId;
  const SpeciesTraitRow({
    required this.packId,
    required this.speciesId,
    required this.position,
    required this.featureId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pack_id'] = Variable<String>(packId);
    map['species_id'] = Variable<String>(speciesId);
    map['position'] = Variable<int>(position);
    map['feature_id'] = Variable<String>(featureId);
    return map;
  }

  SpeciesTraitsCompanion toCompanion(bool nullToAbsent) {
    return SpeciesTraitsCompanion(
      packId: Value(packId),
      speciesId: Value(speciesId),
      position: Value(position),
      featureId: Value(featureId),
    );
  }

  factory SpeciesTraitRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpeciesTraitRow(
      packId: serializer.fromJson<String>(json['packId']),
      speciesId: serializer.fromJson<String>(json['speciesId']),
      position: serializer.fromJson<int>(json['position']),
      featureId: serializer.fromJson<String>(json['featureId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packId': serializer.toJson<String>(packId),
      'speciesId': serializer.toJson<String>(speciesId),
      'position': serializer.toJson<int>(position),
      'featureId': serializer.toJson<String>(featureId),
    };
  }

  SpeciesTraitRow copyWith({
    String? packId,
    String? speciesId,
    int? position,
    String? featureId,
  }) => SpeciesTraitRow(
    packId: packId ?? this.packId,
    speciesId: speciesId ?? this.speciesId,
    position: position ?? this.position,
    featureId: featureId ?? this.featureId,
  );
  SpeciesTraitRow copyWithCompanion(SpeciesTraitsCompanion data) {
    return SpeciesTraitRow(
      packId: data.packId.present ? data.packId.value : this.packId,
      speciesId: data.speciesId.present ? data.speciesId.value : this.speciesId,
      position: data.position.present ? data.position.value : this.position,
      featureId: data.featureId.present ? data.featureId.value : this.featureId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpeciesTraitRow(')
          ..write('packId: $packId, ')
          ..write('speciesId: $speciesId, ')
          ..write('position: $position, ')
          ..write('featureId: $featureId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(packId, speciesId, position, featureId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpeciesTraitRow &&
          other.packId == this.packId &&
          other.speciesId == this.speciesId &&
          other.position == this.position &&
          other.featureId == this.featureId);
}

class SpeciesTraitsCompanion extends UpdateCompanion<SpeciesTraitRow> {
  final Value<String> packId;
  final Value<String> speciesId;
  final Value<int> position;
  final Value<String> featureId;
  final Value<int> rowid;
  const SpeciesTraitsCompanion({
    this.packId = const Value.absent(),
    this.speciesId = const Value.absent(),
    this.position = const Value.absent(),
    this.featureId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpeciesTraitsCompanion.insert({
    required String packId,
    required String speciesId,
    required int position,
    required String featureId,
    this.rowid = const Value.absent(),
  }) : packId = Value(packId),
       speciesId = Value(speciesId),
       position = Value(position),
       featureId = Value(featureId);
  static Insertable<SpeciesTraitRow> custom({
    Expression<String>? packId,
    Expression<String>? speciesId,
    Expression<int>? position,
    Expression<String>? featureId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packId != null) 'pack_id': packId,
      if (speciesId != null) 'species_id': speciesId,
      if (position != null) 'position': position,
      if (featureId != null) 'feature_id': featureId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpeciesTraitsCompanion copyWith({
    Value<String>? packId,
    Value<String>? speciesId,
    Value<int>? position,
    Value<String>? featureId,
    Value<int>? rowid,
  }) {
    return SpeciesTraitsCompanion(
      packId: packId ?? this.packId,
      speciesId: speciesId ?? this.speciesId,
      position: position ?? this.position,
      featureId: featureId ?? this.featureId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (speciesId.present) {
      map['species_id'] = Variable<String>(speciesId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (featureId.present) {
      map['feature_id'] = Variable<String>(featureId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpeciesTraitsCompanion(')
          ..write('packId: $packId, ')
          ..write('speciesId: $speciesId, ')
          ..write('position: $position, ')
          ..write('featureId: $featureId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClassesTable extends Classes with TableInfo<$ClassesTable, ClassRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClassesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extendsIdMeta = const VerificationMeta(
    'extendsId',
  );
  @override
  late final GeneratedColumn<String> extendsId = GeneratedColumn<String>(
    'extends_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hitDieMeta = const VerificationMeta('hitDie');
  @override
  late final GeneratedColumn<int> hitDie = GeneratedColumn<int>(
    'hit_die',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _primaryAbilitiesMeta = const VerificationMeta(
    'primaryAbilities',
  );
  @override
  late final GeneratedColumn<String> primaryAbilities = GeneratedColumn<String>(
    'primary_abilities',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savingThrowsMeta = const VerificationMeta(
    'savingThrows',
  );
  @override
  late final GeneratedColumn<String> savingThrows = GeneratedColumn<String>(
    'saving_throws',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skillChoiceCountMeta = const VerificationMeta(
    'skillChoiceCount',
  );
  @override
  late final GeneratedColumn<int> skillChoiceCount = GeneratedColumn<int>(
    'skill_choice_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skillChoicesMeta = const VerificationMeta(
    'skillChoices',
  );
  @override
  late final GeneratedColumn<String> skillChoices = GeneratedColumn<String>(
    'skill_choices',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weaponProficienciesMeta =
      const VerificationMeta('weaponProficiencies');
  @override
  late final GeneratedColumn<String> weaponProficiencies =
      GeneratedColumn<String>(
        'weapon_proficiencies',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _armorTrainingMeta = const VerificationMeta(
    'armorTraining',
  );
  @override
  late final GeneratedColumn<String> armorTraining = GeneratedColumn<String>(
    'armor_training',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subclassLevelMeta = const VerificationMeta(
    'subclassLevel',
  );
  @override
  late final GeneratedColumn<int> subclassLevel = GeneratedColumn<int>(
    'subclass_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packId,
    name,
    extendsId,
    hitDie,
    primaryAbilities,
    savingThrows,
    skillChoiceCount,
    skillChoices,
    weaponProficiencies,
    armorTraining,
    subclassLevel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'class';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClassRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('extends_id')) {
      context.handle(
        _extendsIdMeta,
        extendsId.isAcceptableOrUnknown(data['extends_id']!, _extendsIdMeta),
      );
    }
    if (data.containsKey('hit_die')) {
      context.handle(
        _hitDieMeta,
        hitDie.isAcceptableOrUnknown(data['hit_die']!, _hitDieMeta),
      );
    } else if (isInserting) {
      context.missing(_hitDieMeta);
    }
    if (data.containsKey('primary_abilities')) {
      context.handle(
        _primaryAbilitiesMeta,
        primaryAbilities.isAcceptableOrUnknown(
          data['primary_abilities']!,
          _primaryAbilitiesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_primaryAbilitiesMeta);
    }
    if (data.containsKey('saving_throws')) {
      context.handle(
        _savingThrowsMeta,
        savingThrows.isAcceptableOrUnknown(
          data['saving_throws']!,
          _savingThrowsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_savingThrowsMeta);
    }
    if (data.containsKey('skill_choice_count')) {
      context.handle(
        _skillChoiceCountMeta,
        skillChoiceCount.isAcceptableOrUnknown(
          data['skill_choice_count']!,
          _skillChoiceCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_skillChoiceCountMeta);
    }
    if (data.containsKey('skill_choices')) {
      context.handle(
        _skillChoicesMeta,
        skillChoices.isAcceptableOrUnknown(
          data['skill_choices']!,
          _skillChoicesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_skillChoicesMeta);
    }
    if (data.containsKey('weapon_proficiencies')) {
      context.handle(
        _weaponProficienciesMeta,
        weaponProficiencies.isAcceptableOrUnknown(
          data['weapon_proficiencies']!,
          _weaponProficienciesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weaponProficienciesMeta);
    }
    if (data.containsKey('armor_training')) {
      context.handle(
        _armorTrainingMeta,
        armorTraining.isAcceptableOrUnknown(
          data['armor_training']!,
          _armorTrainingMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_armorTrainingMeta);
    }
    if (data.containsKey('subclass_level')) {
      context.handle(
        _subclassLevelMeta,
        subclassLevel.isAcceptableOrUnknown(
          data['subclass_level']!,
          _subclassLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subclassLevelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClassRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClassRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      extendsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extends_id'],
      ),
      hitDie: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hit_die'],
      )!,
      primaryAbilities: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_abilities'],
      )!,
      savingThrows: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}saving_throws'],
      )!,
      skillChoiceCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}skill_choice_count'],
      )!,
      skillChoices: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}skill_choices'],
      )!,
      weaponProficiencies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weapon_proficiencies'],
      )!,
      armorTraining: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}armor_training'],
      )!,
      subclassLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subclass_level'],
      )!,
    );
  }

  @override
  $ClassesTable createAlias(String alias) {
    return $ClassesTable(attachedDatabase, alias);
  }
}

class ClassRow extends DataClass implements Insertable<ClassRow> {
  final String id;
  final String packId;
  final String name;
  final String? extendsId;
  final int hitDie;
  final String primaryAbilities;
  final String savingThrows;
  final int skillChoiceCount;
  final String skillChoices;
  final String weaponProficiencies;
  final String armorTraining;
  final int subclassLevel;
  const ClassRow({
    required this.id,
    required this.packId,
    required this.name,
    this.extendsId,
    required this.hitDie,
    required this.primaryAbilities,
    required this.savingThrows,
    required this.skillChoiceCount,
    required this.skillChoices,
    required this.weaponProficiencies,
    required this.armorTraining,
    required this.subclassLevel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || extendsId != null) {
      map['extends_id'] = Variable<String>(extendsId);
    }
    map['hit_die'] = Variable<int>(hitDie);
    map['primary_abilities'] = Variable<String>(primaryAbilities);
    map['saving_throws'] = Variable<String>(savingThrows);
    map['skill_choice_count'] = Variable<int>(skillChoiceCount);
    map['skill_choices'] = Variable<String>(skillChoices);
    map['weapon_proficiencies'] = Variable<String>(weaponProficiencies);
    map['armor_training'] = Variable<String>(armorTraining);
    map['subclass_level'] = Variable<int>(subclassLevel);
    return map;
  }

  ClassesCompanion toCompanion(bool nullToAbsent) {
    return ClassesCompanion(
      id: Value(id),
      packId: Value(packId),
      name: Value(name),
      extendsId: extendsId == null && nullToAbsent
          ? const Value.absent()
          : Value(extendsId),
      hitDie: Value(hitDie),
      primaryAbilities: Value(primaryAbilities),
      savingThrows: Value(savingThrows),
      skillChoiceCount: Value(skillChoiceCount),
      skillChoices: Value(skillChoices),
      weaponProficiencies: Value(weaponProficiencies),
      armorTraining: Value(armorTraining),
      subclassLevel: Value(subclassLevel),
    );
  }

  factory ClassRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClassRow(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      name: serializer.fromJson<String>(json['name']),
      extendsId: serializer.fromJson<String?>(json['extendsId']),
      hitDie: serializer.fromJson<int>(json['hitDie']),
      primaryAbilities: serializer.fromJson<String>(json['primaryAbilities']),
      savingThrows: serializer.fromJson<String>(json['savingThrows']),
      skillChoiceCount: serializer.fromJson<int>(json['skillChoiceCount']),
      skillChoices: serializer.fromJson<String>(json['skillChoices']),
      weaponProficiencies: serializer.fromJson<String>(
        json['weaponProficiencies'],
      ),
      armorTraining: serializer.fromJson<String>(json['armorTraining']),
      subclassLevel: serializer.fromJson<int>(json['subclassLevel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'name': serializer.toJson<String>(name),
      'extendsId': serializer.toJson<String?>(extendsId),
      'hitDie': serializer.toJson<int>(hitDie),
      'primaryAbilities': serializer.toJson<String>(primaryAbilities),
      'savingThrows': serializer.toJson<String>(savingThrows),
      'skillChoiceCount': serializer.toJson<int>(skillChoiceCount),
      'skillChoices': serializer.toJson<String>(skillChoices),
      'weaponProficiencies': serializer.toJson<String>(weaponProficiencies),
      'armorTraining': serializer.toJson<String>(armorTraining),
      'subclassLevel': serializer.toJson<int>(subclassLevel),
    };
  }

  ClassRow copyWith({
    String? id,
    String? packId,
    String? name,
    Value<String?> extendsId = const Value.absent(),
    int? hitDie,
    String? primaryAbilities,
    String? savingThrows,
    int? skillChoiceCount,
    String? skillChoices,
    String? weaponProficiencies,
    String? armorTraining,
    int? subclassLevel,
  }) => ClassRow(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    name: name ?? this.name,
    extendsId: extendsId.present ? extendsId.value : this.extendsId,
    hitDie: hitDie ?? this.hitDie,
    primaryAbilities: primaryAbilities ?? this.primaryAbilities,
    savingThrows: savingThrows ?? this.savingThrows,
    skillChoiceCount: skillChoiceCount ?? this.skillChoiceCount,
    skillChoices: skillChoices ?? this.skillChoices,
    weaponProficiencies: weaponProficiencies ?? this.weaponProficiencies,
    armorTraining: armorTraining ?? this.armorTraining,
    subclassLevel: subclassLevel ?? this.subclassLevel,
  );
  ClassRow copyWithCompanion(ClassesCompanion data) {
    return ClassRow(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      name: data.name.present ? data.name.value : this.name,
      extendsId: data.extendsId.present ? data.extendsId.value : this.extendsId,
      hitDie: data.hitDie.present ? data.hitDie.value : this.hitDie,
      primaryAbilities: data.primaryAbilities.present
          ? data.primaryAbilities.value
          : this.primaryAbilities,
      savingThrows: data.savingThrows.present
          ? data.savingThrows.value
          : this.savingThrows,
      skillChoiceCount: data.skillChoiceCount.present
          ? data.skillChoiceCount.value
          : this.skillChoiceCount,
      skillChoices: data.skillChoices.present
          ? data.skillChoices.value
          : this.skillChoices,
      weaponProficiencies: data.weaponProficiencies.present
          ? data.weaponProficiencies.value
          : this.weaponProficiencies,
      armorTraining: data.armorTraining.present
          ? data.armorTraining.value
          : this.armorTraining,
      subclassLevel: data.subclassLevel.present
          ? data.subclassLevel.value
          : this.subclassLevel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClassRow(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('hitDie: $hitDie, ')
          ..write('primaryAbilities: $primaryAbilities, ')
          ..write('savingThrows: $savingThrows, ')
          ..write('skillChoiceCount: $skillChoiceCount, ')
          ..write('skillChoices: $skillChoices, ')
          ..write('weaponProficiencies: $weaponProficiencies, ')
          ..write('armorTraining: $armorTraining, ')
          ..write('subclassLevel: $subclassLevel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    packId,
    name,
    extendsId,
    hitDie,
    primaryAbilities,
    savingThrows,
    skillChoiceCount,
    skillChoices,
    weaponProficiencies,
    armorTraining,
    subclassLevel,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassRow &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.name == this.name &&
          other.extendsId == this.extendsId &&
          other.hitDie == this.hitDie &&
          other.primaryAbilities == this.primaryAbilities &&
          other.savingThrows == this.savingThrows &&
          other.skillChoiceCount == this.skillChoiceCount &&
          other.skillChoices == this.skillChoices &&
          other.weaponProficiencies == this.weaponProficiencies &&
          other.armorTraining == this.armorTraining &&
          other.subclassLevel == this.subclassLevel);
}

class ClassesCompanion extends UpdateCompanion<ClassRow> {
  final Value<String> id;
  final Value<String> packId;
  final Value<String> name;
  final Value<String?> extendsId;
  final Value<int> hitDie;
  final Value<String> primaryAbilities;
  final Value<String> savingThrows;
  final Value<int> skillChoiceCount;
  final Value<String> skillChoices;
  final Value<String> weaponProficiencies;
  final Value<String> armorTraining;
  final Value<int> subclassLevel;
  final Value<int> rowid;
  const ClassesCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.name = const Value.absent(),
    this.extendsId = const Value.absent(),
    this.hitDie = const Value.absent(),
    this.primaryAbilities = const Value.absent(),
    this.savingThrows = const Value.absent(),
    this.skillChoiceCount = const Value.absent(),
    this.skillChoices = const Value.absent(),
    this.weaponProficiencies = const Value.absent(),
    this.armorTraining = const Value.absent(),
    this.subclassLevel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClassesCompanion.insert({
    required String id,
    required String packId,
    required String name,
    this.extendsId = const Value.absent(),
    required int hitDie,
    required String primaryAbilities,
    required String savingThrows,
    required int skillChoiceCount,
    required String skillChoices,
    required String weaponProficiencies,
    required String armorTraining,
    required int subclassLevel,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       name = Value(name),
       hitDie = Value(hitDie),
       primaryAbilities = Value(primaryAbilities),
       savingThrows = Value(savingThrows),
       skillChoiceCount = Value(skillChoiceCount),
       skillChoices = Value(skillChoices),
       weaponProficiencies = Value(weaponProficiencies),
       armorTraining = Value(armorTraining),
       subclassLevel = Value(subclassLevel);
  static Insertable<ClassRow> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<String>? name,
    Expression<String>? extendsId,
    Expression<int>? hitDie,
    Expression<String>? primaryAbilities,
    Expression<String>? savingThrows,
    Expression<int>? skillChoiceCount,
    Expression<String>? skillChoices,
    Expression<String>? weaponProficiencies,
    Expression<String>? armorTraining,
    Expression<int>? subclassLevel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (name != null) 'name': name,
      if (extendsId != null) 'extends_id': extendsId,
      if (hitDie != null) 'hit_die': hitDie,
      if (primaryAbilities != null) 'primary_abilities': primaryAbilities,
      if (savingThrows != null) 'saving_throws': savingThrows,
      if (skillChoiceCount != null) 'skill_choice_count': skillChoiceCount,
      if (skillChoices != null) 'skill_choices': skillChoices,
      if (weaponProficiencies != null)
        'weapon_proficiencies': weaponProficiencies,
      if (armorTraining != null) 'armor_training': armorTraining,
      if (subclassLevel != null) 'subclass_level': subclassLevel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClassesCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<String>? name,
    Value<String?>? extendsId,
    Value<int>? hitDie,
    Value<String>? primaryAbilities,
    Value<String>? savingThrows,
    Value<int>? skillChoiceCount,
    Value<String>? skillChoices,
    Value<String>? weaponProficiencies,
    Value<String>? armorTraining,
    Value<int>? subclassLevel,
    Value<int>? rowid,
  }) {
    return ClassesCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      name: name ?? this.name,
      extendsId: extendsId ?? this.extendsId,
      hitDie: hitDie ?? this.hitDie,
      primaryAbilities: primaryAbilities ?? this.primaryAbilities,
      savingThrows: savingThrows ?? this.savingThrows,
      skillChoiceCount: skillChoiceCount ?? this.skillChoiceCount,
      skillChoices: skillChoices ?? this.skillChoices,
      weaponProficiencies: weaponProficiencies ?? this.weaponProficiencies,
      armorTraining: armorTraining ?? this.armorTraining,
      subclassLevel: subclassLevel ?? this.subclassLevel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (extendsId.present) {
      map['extends_id'] = Variable<String>(extendsId.value);
    }
    if (hitDie.present) {
      map['hit_die'] = Variable<int>(hitDie.value);
    }
    if (primaryAbilities.present) {
      map['primary_abilities'] = Variable<String>(primaryAbilities.value);
    }
    if (savingThrows.present) {
      map['saving_throws'] = Variable<String>(savingThrows.value);
    }
    if (skillChoiceCount.present) {
      map['skill_choice_count'] = Variable<int>(skillChoiceCount.value);
    }
    if (skillChoices.present) {
      map['skill_choices'] = Variable<String>(skillChoices.value);
    }
    if (weaponProficiencies.present) {
      map['weapon_proficiencies'] = Variable<String>(weaponProficiencies.value);
    }
    if (armorTraining.present) {
      map['armor_training'] = Variable<String>(armorTraining.value);
    }
    if (subclassLevel.present) {
      map['subclass_level'] = Variable<int>(subclassLevel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassesCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('hitDie: $hitDie, ')
          ..write('primaryAbilities: $primaryAbilities, ')
          ..write('savingThrows: $savingThrows, ')
          ..write('skillChoiceCount: $skillChoiceCount, ')
          ..write('skillChoices: $skillChoices, ')
          ..write('weaponProficiencies: $weaponProficiencies, ')
          ..write('armorTraining: $armorTraining, ')
          ..write('subclassLevel: $subclassLevel, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClassLevelsTable extends ClassLevels
    with TableInfo<$ClassLevelsTable, ClassLevelRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClassLevelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _classIdMeta = const VerificationMeta(
    'classId',
  );
  @override
  late final GeneratedColumn<String> classId = GeneratedColumn<String>(
    'class_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profBonusMeta = const VerificationMeta(
    'profBonus',
  );
  @override
  late final GeneratedColumn<int> profBonus = GeneratedColumn<int>(
    'prof_bonus',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _featuresMeta = const VerificationMeta(
    'features',
  );
  @override
  late final GeneratedColumn<String> features = GeneratedColumn<String>(
    'features',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _columnsMeta = const VerificationMeta(
    'columns',
  );
  @override
  late final GeneratedColumn<String> columns = GeneratedColumn<String>(
    'columns',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    packId,
    classId,
    level,
    profBonus,
    features,
    columns,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'class_level';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClassLevelRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('class_id')) {
      context.handle(
        _classIdMeta,
        classId.isAcceptableOrUnknown(data['class_id']!, _classIdMeta),
      );
    } else if (isInserting) {
      context.missing(_classIdMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('prof_bonus')) {
      context.handle(
        _profBonusMeta,
        profBonus.isAcceptableOrUnknown(data['prof_bonus']!, _profBonusMeta),
      );
    } else if (isInserting) {
      context.missing(_profBonusMeta);
    }
    if (data.containsKey('features')) {
      context.handle(
        _featuresMeta,
        features.isAcceptableOrUnknown(data['features']!, _featuresMeta),
      );
    } else if (isInserting) {
      context.missing(_featuresMeta);
    }
    if (data.containsKey('columns')) {
      context.handle(
        _columnsMeta,
        columns.isAcceptableOrUnknown(data['columns']!, _columnsMeta),
      );
    } else if (isInserting) {
      context.missing(_columnsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {classId, level};
  @override
  ClassLevelRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClassLevelRow(
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      classId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_id'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      profBonus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prof_bonus'],
      )!,
      features: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}features'],
      )!,
      columns: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}columns'],
      )!,
    );
  }

  @override
  $ClassLevelsTable createAlias(String alias) {
    return $ClassLevelsTable(attachedDatabase, alias);
  }
}

class ClassLevelRow extends DataClass implements Insertable<ClassLevelRow> {
  final String packId;
  final String classId;
  final int level;
  final int profBonus;
  final String features;

  /// Colonnes de la table de classe (bottes, Second souffle, emplacements…).
  final String columns;
  const ClassLevelRow({
    required this.packId,
    required this.classId,
    required this.level,
    required this.profBonus,
    required this.features,
    required this.columns,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pack_id'] = Variable<String>(packId);
    map['class_id'] = Variable<String>(classId);
    map['level'] = Variable<int>(level);
    map['prof_bonus'] = Variable<int>(profBonus);
    map['features'] = Variable<String>(features);
    map['columns'] = Variable<String>(columns);
    return map;
  }

  ClassLevelsCompanion toCompanion(bool nullToAbsent) {
    return ClassLevelsCompanion(
      packId: Value(packId),
      classId: Value(classId),
      level: Value(level),
      profBonus: Value(profBonus),
      features: Value(features),
      columns: Value(columns),
    );
  }

  factory ClassLevelRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClassLevelRow(
      packId: serializer.fromJson<String>(json['packId']),
      classId: serializer.fromJson<String>(json['classId']),
      level: serializer.fromJson<int>(json['level']),
      profBonus: serializer.fromJson<int>(json['profBonus']),
      features: serializer.fromJson<String>(json['features']),
      columns: serializer.fromJson<String>(json['columns']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packId': serializer.toJson<String>(packId),
      'classId': serializer.toJson<String>(classId),
      'level': serializer.toJson<int>(level),
      'profBonus': serializer.toJson<int>(profBonus),
      'features': serializer.toJson<String>(features),
      'columns': serializer.toJson<String>(columns),
    };
  }

  ClassLevelRow copyWith({
    String? packId,
    String? classId,
    int? level,
    int? profBonus,
    String? features,
    String? columns,
  }) => ClassLevelRow(
    packId: packId ?? this.packId,
    classId: classId ?? this.classId,
    level: level ?? this.level,
    profBonus: profBonus ?? this.profBonus,
    features: features ?? this.features,
    columns: columns ?? this.columns,
  );
  ClassLevelRow copyWithCompanion(ClassLevelsCompanion data) {
    return ClassLevelRow(
      packId: data.packId.present ? data.packId.value : this.packId,
      classId: data.classId.present ? data.classId.value : this.classId,
      level: data.level.present ? data.level.value : this.level,
      profBonus: data.profBonus.present ? data.profBonus.value : this.profBonus,
      features: data.features.present ? data.features.value : this.features,
      columns: data.columns.present ? data.columns.value : this.columns,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClassLevelRow(')
          ..write('packId: $packId, ')
          ..write('classId: $classId, ')
          ..write('level: $level, ')
          ..write('profBonus: $profBonus, ')
          ..write('features: $features, ')
          ..write('columns: $columns')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(packId, classId, level, profBonus, features, columns);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassLevelRow &&
          other.packId == this.packId &&
          other.classId == this.classId &&
          other.level == this.level &&
          other.profBonus == this.profBonus &&
          other.features == this.features &&
          other.columns == this.columns);
}

class ClassLevelsCompanion extends UpdateCompanion<ClassLevelRow> {
  final Value<String> packId;
  final Value<String> classId;
  final Value<int> level;
  final Value<int> profBonus;
  final Value<String> features;
  final Value<String> columns;
  final Value<int> rowid;
  const ClassLevelsCompanion({
    this.packId = const Value.absent(),
    this.classId = const Value.absent(),
    this.level = const Value.absent(),
    this.profBonus = const Value.absent(),
    this.features = const Value.absent(),
    this.columns = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClassLevelsCompanion.insert({
    required String packId,
    required String classId,
    required int level,
    required int profBonus,
    required String features,
    required String columns,
    this.rowid = const Value.absent(),
  }) : packId = Value(packId),
       classId = Value(classId),
       level = Value(level),
       profBonus = Value(profBonus),
       features = Value(features),
       columns = Value(columns);
  static Insertable<ClassLevelRow> custom({
    Expression<String>? packId,
    Expression<String>? classId,
    Expression<int>? level,
    Expression<int>? profBonus,
    Expression<String>? features,
    Expression<String>? columns,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packId != null) 'pack_id': packId,
      if (classId != null) 'class_id': classId,
      if (level != null) 'level': level,
      if (profBonus != null) 'prof_bonus': profBonus,
      if (features != null) 'features': features,
      if (columns != null) 'columns': columns,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClassLevelsCompanion copyWith({
    Value<String>? packId,
    Value<String>? classId,
    Value<int>? level,
    Value<int>? profBonus,
    Value<String>? features,
    Value<String>? columns,
    Value<int>? rowid,
  }) {
    return ClassLevelsCompanion(
      packId: packId ?? this.packId,
      classId: classId ?? this.classId,
      level: level ?? this.level,
      profBonus: profBonus ?? this.profBonus,
      features: features ?? this.features,
      columns: columns ?? this.columns,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (classId.present) {
      map['class_id'] = Variable<String>(classId.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (profBonus.present) {
      map['prof_bonus'] = Variable<int>(profBonus.value);
    }
    if (features.present) {
      map['features'] = Variable<String>(features.value);
    }
    if (columns.present) {
      map['columns'] = Variable<String>(columns.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassLevelsCompanion(')
          ..write('packId: $packId, ')
          ..write('classId: $classId, ')
          ..write('level: $level, ')
          ..write('profBonus: $profBonus, ')
          ..write('features: $features, ')
          ..write('columns: $columns, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubclassesTable extends Subclasses
    with TableInfo<$SubclassesTable, SubclassRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubclassesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extendsIdMeta = const VerificationMeta(
    'extendsId',
  );
  @override
  late final GeneratedColumn<String> extendsId = GeneratedColumn<String>(
    'extends_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentClassIdMeta = const VerificationMeta(
    'parentClassId',
  );
  @override
  late final GeneratedColumn<String> parentClassId = GeneratedColumn<String>(
    'parent_class_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packId,
    name,
    extendsId,
    parentClassId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subclass';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubclassRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('extends_id')) {
      context.handle(
        _extendsIdMeta,
        extendsId.isAcceptableOrUnknown(data['extends_id']!, _extendsIdMeta),
      );
    }
    if (data.containsKey('parent_class_id')) {
      context.handle(
        _parentClassIdMeta,
        parentClassId.isAcceptableOrUnknown(
          data['parent_class_id']!,
          _parentClassIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parentClassIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubclassRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubclassRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      extendsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extends_id'],
      ),
      parentClassId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_class_id'],
      )!,
    );
  }

  @override
  $SubclassesTable createAlias(String alias) {
    return $SubclassesTable(attachedDatabase, alias);
  }
}

class SubclassRow extends DataClass implements Insertable<SubclassRow> {
  final String id;
  final String packId;
  final String name;
  final String? extendsId;
  final String parentClassId;
  const SubclassRow({
    required this.id,
    required this.packId,
    required this.name,
    this.extendsId,
    required this.parentClassId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || extendsId != null) {
      map['extends_id'] = Variable<String>(extendsId);
    }
    map['parent_class_id'] = Variable<String>(parentClassId);
    return map;
  }

  SubclassesCompanion toCompanion(bool nullToAbsent) {
    return SubclassesCompanion(
      id: Value(id),
      packId: Value(packId),
      name: Value(name),
      extendsId: extendsId == null && nullToAbsent
          ? const Value.absent()
          : Value(extendsId),
      parentClassId: Value(parentClassId),
    );
  }

  factory SubclassRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubclassRow(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      name: serializer.fromJson<String>(json['name']),
      extendsId: serializer.fromJson<String?>(json['extendsId']),
      parentClassId: serializer.fromJson<String>(json['parentClassId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'name': serializer.toJson<String>(name),
      'extendsId': serializer.toJson<String?>(extendsId),
      'parentClassId': serializer.toJson<String>(parentClassId),
    };
  }

  SubclassRow copyWith({
    String? id,
    String? packId,
    String? name,
    Value<String?> extendsId = const Value.absent(),
    String? parentClassId,
  }) => SubclassRow(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    name: name ?? this.name,
    extendsId: extendsId.present ? extendsId.value : this.extendsId,
    parentClassId: parentClassId ?? this.parentClassId,
  );
  SubclassRow copyWithCompanion(SubclassesCompanion data) {
    return SubclassRow(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      name: data.name.present ? data.name.value : this.name,
      extendsId: data.extendsId.present ? data.extendsId.value : this.extendsId,
      parentClassId: data.parentClassId.present
          ? data.parentClassId.value
          : this.parentClassId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubclassRow(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('parentClassId: $parentClassId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, packId, name, extendsId, parentClassId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubclassRow &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.name == this.name &&
          other.extendsId == this.extendsId &&
          other.parentClassId == this.parentClassId);
}

class SubclassesCompanion extends UpdateCompanion<SubclassRow> {
  final Value<String> id;
  final Value<String> packId;
  final Value<String> name;
  final Value<String?> extendsId;
  final Value<String> parentClassId;
  final Value<int> rowid;
  const SubclassesCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.name = const Value.absent(),
    this.extendsId = const Value.absent(),
    this.parentClassId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubclassesCompanion.insert({
    required String id,
    required String packId,
    required String name,
    this.extendsId = const Value.absent(),
    required String parentClassId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       name = Value(name),
       parentClassId = Value(parentClassId);
  static Insertable<SubclassRow> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<String>? name,
    Expression<String>? extendsId,
    Expression<String>? parentClassId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (name != null) 'name': name,
      if (extendsId != null) 'extends_id': extendsId,
      if (parentClassId != null) 'parent_class_id': parentClassId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubclassesCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<String>? name,
    Value<String?>? extendsId,
    Value<String>? parentClassId,
    Value<int>? rowid,
  }) {
    return SubclassesCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      name: name ?? this.name,
      extendsId: extendsId ?? this.extendsId,
      parentClassId: parentClassId ?? this.parentClassId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (extendsId.present) {
      map['extends_id'] = Variable<String>(extendsId.value);
    }
    if (parentClassId.present) {
      map['parent_class_id'] = Variable<String>(parentClassId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubclassesCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('parentClassId: $parentClassId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubclassFeaturesTable extends SubclassFeatures
    with TableInfo<$SubclassFeaturesTable, SubclassFeatureRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubclassFeaturesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _subclassIdMeta = const VerificationMeta(
    'subclassId',
  );
  @override
  late final GeneratedColumn<String> subclassId = GeneratedColumn<String>(
    'subclass_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _featureIdMeta = const VerificationMeta(
    'featureId',
  );
  @override
  late final GeneratedColumn<String> featureId = GeneratedColumn<String>(
    'feature_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    packId,
    subclassId,
    position,
    featureId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subclass_feature';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubclassFeatureRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('subclass_id')) {
      context.handle(
        _subclassIdMeta,
        subclassId.isAcceptableOrUnknown(data['subclass_id']!, _subclassIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subclassIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('feature_id')) {
      context.handle(
        _featureIdMeta,
        featureId.isAcceptableOrUnknown(data['feature_id']!, _featureIdMeta),
      );
    } else if (isInserting) {
      context.missing(_featureIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {subclassId, position};
  @override
  SubclassFeatureRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubclassFeatureRow(
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      subclassId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subclass_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      featureId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feature_id'],
      )!,
    );
  }

  @override
  $SubclassFeaturesTable createAlias(String alias) {
    return $SubclassFeaturesTable(attachedDatabase, alias);
  }
}

class SubclassFeatureRow extends DataClass
    implements Insertable<SubclassFeatureRow> {
  final String packId;
  final String subclassId;
  final int position;
  final String featureId;
  const SubclassFeatureRow({
    required this.packId,
    required this.subclassId,
    required this.position,
    required this.featureId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pack_id'] = Variable<String>(packId);
    map['subclass_id'] = Variable<String>(subclassId);
    map['position'] = Variable<int>(position);
    map['feature_id'] = Variable<String>(featureId);
    return map;
  }

  SubclassFeaturesCompanion toCompanion(bool nullToAbsent) {
    return SubclassFeaturesCompanion(
      packId: Value(packId),
      subclassId: Value(subclassId),
      position: Value(position),
      featureId: Value(featureId),
    );
  }

  factory SubclassFeatureRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubclassFeatureRow(
      packId: serializer.fromJson<String>(json['packId']),
      subclassId: serializer.fromJson<String>(json['subclassId']),
      position: serializer.fromJson<int>(json['position']),
      featureId: serializer.fromJson<String>(json['featureId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packId': serializer.toJson<String>(packId),
      'subclassId': serializer.toJson<String>(subclassId),
      'position': serializer.toJson<int>(position),
      'featureId': serializer.toJson<String>(featureId),
    };
  }

  SubclassFeatureRow copyWith({
    String? packId,
    String? subclassId,
    int? position,
    String? featureId,
  }) => SubclassFeatureRow(
    packId: packId ?? this.packId,
    subclassId: subclassId ?? this.subclassId,
    position: position ?? this.position,
    featureId: featureId ?? this.featureId,
  );
  SubclassFeatureRow copyWithCompanion(SubclassFeaturesCompanion data) {
    return SubclassFeatureRow(
      packId: data.packId.present ? data.packId.value : this.packId,
      subclassId: data.subclassId.present
          ? data.subclassId.value
          : this.subclassId,
      position: data.position.present ? data.position.value : this.position,
      featureId: data.featureId.present ? data.featureId.value : this.featureId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubclassFeatureRow(')
          ..write('packId: $packId, ')
          ..write('subclassId: $subclassId, ')
          ..write('position: $position, ')
          ..write('featureId: $featureId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(packId, subclassId, position, featureId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubclassFeatureRow &&
          other.packId == this.packId &&
          other.subclassId == this.subclassId &&
          other.position == this.position &&
          other.featureId == this.featureId);
}

class SubclassFeaturesCompanion extends UpdateCompanion<SubclassFeatureRow> {
  final Value<String> packId;
  final Value<String> subclassId;
  final Value<int> position;
  final Value<String> featureId;
  final Value<int> rowid;
  const SubclassFeaturesCompanion({
    this.packId = const Value.absent(),
    this.subclassId = const Value.absent(),
    this.position = const Value.absent(),
    this.featureId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubclassFeaturesCompanion.insert({
    required String packId,
    required String subclassId,
    required int position,
    required String featureId,
    this.rowid = const Value.absent(),
  }) : packId = Value(packId),
       subclassId = Value(subclassId),
       position = Value(position),
       featureId = Value(featureId);
  static Insertable<SubclassFeatureRow> custom({
    Expression<String>? packId,
    Expression<String>? subclassId,
    Expression<int>? position,
    Expression<String>? featureId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packId != null) 'pack_id': packId,
      if (subclassId != null) 'subclass_id': subclassId,
      if (position != null) 'position': position,
      if (featureId != null) 'feature_id': featureId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubclassFeaturesCompanion copyWith({
    Value<String>? packId,
    Value<String>? subclassId,
    Value<int>? position,
    Value<String>? featureId,
    Value<int>? rowid,
  }) {
    return SubclassFeaturesCompanion(
      packId: packId ?? this.packId,
      subclassId: subclassId ?? this.subclassId,
      position: position ?? this.position,
      featureId: featureId ?? this.featureId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (subclassId.present) {
      map['subclass_id'] = Variable<String>(subclassId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (featureId.present) {
      map['feature_id'] = Variable<String>(featureId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubclassFeaturesCompanion(')
          ..write('packId: $packId, ')
          ..write('subclassId: $subclassId, ')
          ..write('position: $position, ')
          ..write('featureId: $featureId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FeaturesTable extends Features
    with TableInfo<$FeaturesTable, FeatureRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeaturesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extendsIdMeta = const VerificationMeta(
    'extendsId',
  );
  @override
  late final GeneratedColumn<String> extendsId = GeneratedColumn<String>(
    'extends_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packId,
    name,
    extendsId,
    sourceId,
    level,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feature';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeatureRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('extends_id')) {
      context.handle(
        _extendsIdMeta,
        extendsId.isAcceptableOrUnknown(data['extends_id']!, _extendsIdMeta),
      );
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeatureRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeatureRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      extendsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extends_id'],
      ),
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      ),
    );
  }

  @override
  $FeaturesTable createAlias(String alias) {
    return $FeaturesTable(attachedDatabase, alias);
  }
}

class FeatureRow extends DataClass implements Insertable<FeatureRow> {
  final String id;
  final String packId;
  final String name;
  final String? extendsId;
  final String sourceId;
  final int? level;
  const FeatureRow({
    required this.id,
    required this.packId,
    required this.name,
    this.extendsId,
    required this.sourceId,
    this.level,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || extendsId != null) {
      map['extends_id'] = Variable<String>(extendsId);
    }
    map['source_id'] = Variable<String>(sourceId);
    if (!nullToAbsent || level != null) {
      map['level'] = Variable<int>(level);
    }
    return map;
  }

  FeaturesCompanion toCompanion(bool nullToAbsent) {
    return FeaturesCompanion(
      id: Value(id),
      packId: Value(packId),
      name: Value(name),
      extendsId: extendsId == null && nullToAbsent
          ? const Value.absent()
          : Value(extendsId),
      sourceId: Value(sourceId),
      level: level == null && nullToAbsent
          ? const Value.absent()
          : Value(level),
    );
  }

  factory FeatureRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeatureRow(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      name: serializer.fromJson<String>(json['name']),
      extendsId: serializer.fromJson<String?>(json['extendsId']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      level: serializer.fromJson<int?>(json['level']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'name': serializer.toJson<String>(name),
      'extendsId': serializer.toJson<String?>(extendsId),
      'sourceId': serializer.toJson<String>(sourceId),
      'level': serializer.toJson<int?>(level),
    };
  }

  FeatureRow copyWith({
    String? id,
    String? packId,
    String? name,
    Value<String?> extendsId = const Value.absent(),
    String? sourceId,
    Value<int?> level = const Value.absent(),
  }) => FeatureRow(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    name: name ?? this.name,
    extendsId: extendsId.present ? extendsId.value : this.extendsId,
    sourceId: sourceId ?? this.sourceId,
    level: level.present ? level.value : this.level,
  );
  FeatureRow copyWithCompanion(FeaturesCompanion data) {
    return FeatureRow(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      name: data.name.present ? data.name.value : this.name,
      extendsId: data.extendsId.present ? data.extendsId.value : this.extendsId,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      level: data.level.present ? data.level.value : this.level,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeatureRow(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('sourceId: $sourceId, ')
          ..write('level: $level')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, packId, name, extendsId, sourceId, level);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeatureRow &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.name == this.name &&
          other.extendsId == this.extendsId &&
          other.sourceId == this.sourceId &&
          other.level == this.level);
}

class FeaturesCompanion extends UpdateCompanion<FeatureRow> {
  final Value<String> id;
  final Value<String> packId;
  final Value<String> name;
  final Value<String?> extendsId;
  final Value<String> sourceId;
  final Value<int?> level;
  final Value<int> rowid;
  const FeaturesCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.name = const Value.absent(),
    this.extendsId = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.level = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FeaturesCompanion.insert({
    required String id,
    required String packId,
    required String name,
    this.extendsId = const Value.absent(),
    required String sourceId,
    this.level = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       name = Value(name),
       sourceId = Value(sourceId);
  static Insertable<FeatureRow> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<String>? name,
    Expression<String>? extendsId,
    Expression<String>? sourceId,
    Expression<int>? level,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (name != null) 'name': name,
      if (extendsId != null) 'extends_id': extendsId,
      if (sourceId != null) 'source_id': sourceId,
      if (level != null) 'level': level,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FeaturesCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<String>? name,
    Value<String?>? extendsId,
    Value<String>? sourceId,
    Value<int?>? level,
    Value<int>? rowid,
  }) {
    return FeaturesCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      name: name ?? this.name,
      extendsId: extendsId ?? this.extendsId,
      sourceId: sourceId ?? this.sourceId,
      level: level ?? this.level,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (extendsId.present) {
      map['extends_id'] = Variable<String>(extendsId.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeaturesCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('sourceId: $sourceId, ')
          ..write('level: $level, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SpellsTable extends Spells with TableInfo<$SpellsTable, SpellRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpellsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extendsIdMeta = const VerificationMeta(
    'extendsId',
  );
  @override
  late final GeneratedColumn<String> extendsId = GeneratedColumn<String>(
    'extends_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schoolMeta = const VerificationMeta('school');
  @override
  late final GeneratedColumn<String> school = GeneratedColumn<String>(
    'school',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _castingTimeMeta = const VerificationMeta(
    'castingTime',
  );
  @override
  late final GeneratedColumn<String> castingTime = GeneratedColumn<String>(
    'casting_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rangeMeta = const VerificationMeta('range');
  @override
  late final GeneratedColumn<String> range = GeneratedColumn<String>(
    'range',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _componentsMeta = const VerificationMeta(
    'components',
  );
  @override
  late final GeneratedColumn<String> components = GeneratedColumn<String>(
    'components',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _materialCostCpMeta = const VerificationMeta(
    'materialCostCp',
  );
  @override
  late final GeneratedColumn<int> materialCostCp = GeneratedColumn<int>(
    'material_cost_cp',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _materialConsumedMeta = const VerificationMeta(
    'materialConsumed',
  );
  @override
  late final GeneratedColumn<bool> materialConsumed = GeneratedColumn<bool>(
    'material_consumed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("material_consumed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<String> duration = GeneratedColumn<String>(
    'duration',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _concentrationMeta = const VerificationMeta(
    'concentration',
  );
  @override
  late final GeneratedColumn<bool> concentration = GeneratedColumn<bool>(
    'concentration',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("concentration" IN (0, 1))',
    ),
  );
  static const VerificationMeta _ritualMeta = const VerificationMeta('ritual');
  @override
  late final GeneratedColumn<bool> ritual = GeneratedColumn<bool>(
    'ritual',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ritual" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packId,
    name,
    extendsId,
    level,
    school,
    castingTime,
    range,
    components,
    materialCostCp,
    materialConsumed,
    duration,
    concentration,
    ritual,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'spell';
  @override
  VerificationContext validateIntegrity(
    Insertable<SpellRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('extends_id')) {
      context.handle(
        _extendsIdMeta,
        extendsId.isAcceptableOrUnknown(data['extends_id']!, _extendsIdMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('school')) {
      context.handle(
        _schoolMeta,
        school.isAcceptableOrUnknown(data['school']!, _schoolMeta),
      );
    } else if (isInserting) {
      context.missing(_schoolMeta);
    }
    if (data.containsKey('casting_time')) {
      context.handle(
        _castingTimeMeta,
        castingTime.isAcceptableOrUnknown(
          data['casting_time']!,
          _castingTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_castingTimeMeta);
    }
    if (data.containsKey('range')) {
      context.handle(
        _rangeMeta,
        range.isAcceptableOrUnknown(data['range']!, _rangeMeta),
      );
    } else if (isInserting) {
      context.missing(_rangeMeta);
    }
    if (data.containsKey('components')) {
      context.handle(
        _componentsMeta,
        components.isAcceptableOrUnknown(data['components']!, _componentsMeta),
      );
    } else if (isInserting) {
      context.missing(_componentsMeta);
    }
    if (data.containsKey('material_cost_cp')) {
      context.handle(
        _materialCostCpMeta,
        materialCostCp.isAcceptableOrUnknown(
          data['material_cost_cp']!,
          _materialCostCpMeta,
        ),
      );
    }
    if (data.containsKey('material_consumed')) {
      context.handle(
        _materialConsumedMeta,
        materialConsumed.isAcceptableOrUnknown(
          data['material_consumed']!,
          _materialConsumedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_materialConsumedMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('concentration')) {
      context.handle(
        _concentrationMeta,
        concentration.isAcceptableOrUnknown(
          data['concentration']!,
          _concentrationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_concentrationMeta);
    }
    if (data.containsKey('ritual')) {
      context.handle(
        _ritualMeta,
        ritual.isAcceptableOrUnknown(data['ritual']!, _ritualMeta),
      );
    } else if (isInserting) {
      context.missing(_ritualMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpellRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpellRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      extendsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extends_id'],
      ),
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      school: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school'],
      )!,
      castingTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}casting_time'],
      )!,
      range: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}range'],
      )!,
      components: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}components'],
      )!,
      materialCostCp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}material_cost_cp'],
      ),
      materialConsumed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}material_consumed'],
      )!,
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}duration'],
      )!,
      concentration: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}concentration'],
      )!,
      ritual: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ritual'],
      )!,
    );
  }

  @override
  $SpellsTable createAlias(String alias) {
    return $SpellsTable(attachedDatabase, alias);
  }
}

class SpellRow extends DataClass implements Insertable<SpellRow> {
  final String id;
  final String packId;
  final String name;
  final String? extendsId;
  final int level;
  final String school;
  final String castingTime;
  final String range;
  final String components;
  final int? materialCostCp;
  final bool materialConsumed;
  final String duration;
  final bool concentration;
  final bool ritual;
  const SpellRow({
    required this.id,
    required this.packId,
    required this.name,
    this.extendsId,
    required this.level,
    required this.school,
    required this.castingTime,
    required this.range,
    required this.components,
    this.materialCostCp,
    required this.materialConsumed,
    required this.duration,
    required this.concentration,
    required this.ritual,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || extendsId != null) {
      map['extends_id'] = Variable<String>(extendsId);
    }
    map['level'] = Variable<int>(level);
    map['school'] = Variable<String>(school);
    map['casting_time'] = Variable<String>(castingTime);
    map['range'] = Variable<String>(range);
    map['components'] = Variable<String>(components);
    if (!nullToAbsent || materialCostCp != null) {
      map['material_cost_cp'] = Variable<int>(materialCostCp);
    }
    map['material_consumed'] = Variable<bool>(materialConsumed);
    map['duration'] = Variable<String>(duration);
    map['concentration'] = Variable<bool>(concentration);
    map['ritual'] = Variable<bool>(ritual);
    return map;
  }

  SpellsCompanion toCompanion(bool nullToAbsent) {
    return SpellsCompanion(
      id: Value(id),
      packId: Value(packId),
      name: Value(name),
      extendsId: extendsId == null && nullToAbsent
          ? const Value.absent()
          : Value(extendsId),
      level: Value(level),
      school: Value(school),
      castingTime: Value(castingTime),
      range: Value(range),
      components: Value(components),
      materialCostCp: materialCostCp == null && nullToAbsent
          ? const Value.absent()
          : Value(materialCostCp),
      materialConsumed: Value(materialConsumed),
      duration: Value(duration),
      concentration: Value(concentration),
      ritual: Value(ritual),
    );
  }

  factory SpellRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpellRow(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      name: serializer.fromJson<String>(json['name']),
      extendsId: serializer.fromJson<String?>(json['extendsId']),
      level: serializer.fromJson<int>(json['level']),
      school: serializer.fromJson<String>(json['school']),
      castingTime: serializer.fromJson<String>(json['castingTime']),
      range: serializer.fromJson<String>(json['range']),
      components: serializer.fromJson<String>(json['components']),
      materialCostCp: serializer.fromJson<int?>(json['materialCostCp']),
      materialConsumed: serializer.fromJson<bool>(json['materialConsumed']),
      duration: serializer.fromJson<String>(json['duration']),
      concentration: serializer.fromJson<bool>(json['concentration']),
      ritual: serializer.fromJson<bool>(json['ritual']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'name': serializer.toJson<String>(name),
      'extendsId': serializer.toJson<String?>(extendsId),
      'level': serializer.toJson<int>(level),
      'school': serializer.toJson<String>(school),
      'castingTime': serializer.toJson<String>(castingTime),
      'range': serializer.toJson<String>(range),
      'components': serializer.toJson<String>(components),
      'materialCostCp': serializer.toJson<int?>(materialCostCp),
      'materialConsumed': serializer.toJson<bool>(materialConsumed),
      'duration': serializer.toJson<String>(duration),
      'concentration': serializer.toJson<bool>(concentration),
      'ritual': serializer.toJson<bool>(ritual),
    };
  }

  SpellRow copyWith({
    String? id,
    String? packId,
    String? name,
    Value<String?> extendsId = const Value.absent(),
    int? level,
    String? school,
    String? castingTime,
    String? range,
    String? components,
    Value<int?> materialCostCp = const Value.absent(),
    bool? materialConsumed,
    String? duration,
    bool? concentration,
    bool? ritual,
  }) => SpellRow(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    name: name ?? this.name,
    extendsId: extendsId.present ? extendsId.value : this.extendsId,
    level: level ?? this.level,
    school: school ?? this.school,
    castingTime: castingTime ?? this.castingTime,
    range: range ?? this.range,
    components: components ?? this.components,
    materialCostCp: materialCostCp.present
        ? materialCostCp.value
        : this.materialCostCp,
    materialConsumed: materialConsumed ?? this.materialConsumed,
    duration: duration ?? this.duration,
    concentration: concentration ?? this.concentration,
    ritual: ritual ?? this.ritual,
  );
  SpellRow copyWithCompanion(SpellsCompanion data) {
    return SpellRow(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      name: data.name.present ? data.name.value : this.name,
      extendsId: data.extendsId.present ? data.extendsId.value : this.extendsId,
      level: data.level.present ? data.level.value : this.level,
      school: data.school.present ? data.school.value : this.school,
      castingTime: data.castingTime.present
          ? data.castingTime.value
          : this.castingTime,
      range: data.range.present ? data.range.value : this.range,
      components: data.components.present
          ? data.components.value
          : this.components,
      materialCostCp: data.materialCostCp.present
          ? data.materialCostCp.value
          : this.materialCostCp,
      materialConsumed: data.materialConsumed.present
          ? data.materialConsumed.value
          : this.materialConsumed,
      duration: data.duration.present ? data.duration.value : this.duration,
      concentration: data.concentration.present
          ? data.concentration.value
          : this.concentration,
      ritual: data.ritual.present ? data.ritual.value : this.ritual,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpellRow(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('level: $level, ')
          ..write('school: $school, ')
          ..write('castingTime: $castingTime, ')
          ..write('range: $range, ')
          ..write('components: $components, ')
          ..write('materialCostCp: $materialCostCp, ')
          ..write('materialConsumed: $materialConsumed, ')
          ..write('duration: $duration, ')
          ..write('concentration: $concentration, ')
          ..write('ritual: $ritual')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    packId,
    name,
    extendsId,
    level,
    school,
    castingTime,
    range,
    components,
    materialCostCp,
    materialConsumed,
    duration,
    concentration,
    ritual,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpellRow &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.name == this.name &&
          other.extendsId == this.extendsId &&
          other.level == this.level &&
          other.school == this.school &&
          other.castingTime == this.castingTime &&
          other.range == this.range &&
          other.components == this.components &&
          other.materialCostCp == this.materialCostCp &&
          other.materialConsumed == this.materialConsumed &&
          other.duration == this.duration &&
          other.concentration == this.concentration &&
          other.ritual == this.ritual);
}

class SpellsCompanion extends UpdateCompanion<SpellRow> {
  final Value<String> id;
  final Value<String> packId;
  final Value<String> name;
  final Value<String?> extendsId;
  final Value<int> level;
  final Value<String> school;
  final Value<String> castingTime;
  final Value<String> range;
  final Value<String> components;
  final Value<int?> materialCostCp;
  final Value<bool> materialConsumed;
  final Value<String> duration;
  final Value<bool> concentration;
  final Value<bool> ritual;
  final Value<int> rowid;
  const SpellsCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.name = const Value.absent(),
    this.extendsId = const Value.absent(),
    this.level = const Value.absent(),
    this.school = const Value.absent(),
    this.castingTime = const Value.absent(),
    this.range = const Value.absent(),
    this.components = const Value.absent(),
    this.materialCostCp = const Value.absent(),
    this.materialConsumed = const Value.absent(),
    this.duration = const Value.absent(),
    this.concentration = const Value.absent(),
    this.ritual = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpellsCompanion.insert({
    required String id,
    required String packId,
    required String name,
    this.extendsId = const Value.absent(),
    required int level,
    required String school,
    required String castingTime,
    required String range,
    required String components,
    this.materialCostCp = const Value.absent(),
    required bool materialConsumed,
    required String duration,
    required bool concentration,
    required bool ritual,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       name = Value(name),
       level = Value(level),
       school = Value(school),
       castingTime = Value(castingTime),
       range = Value(range),
       components = Value(components),
       materialConsumed = Value(materialConsumed),
       duration = Value(duration),
       concentration = Value(concentration),
       ritual = Value(ritual);
  static Insertable<SpellRow> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<String>? name,
    Expression<String>? extendsId,
    Expression<int>? level,
    Expression<String>? school,
    Expression<String>? castingTime,
    Expression<String>? range,
    Expression<String>? components,
    Expression<int>? materialCostCp,
    Expression<bool>? materialConsumed,
    Expression<String>? duration,
    Expression<bool>? concentration,
    Expression<bool>? ritual,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (name != null) 'name': name,
      if (extendsId != null) 'extends_id': extendsId,
      if (level != null) 'level': level,
      if (school != null) 'school': school,
      if (castingTime != null) 'casting_time': castingTime,
      if (range != null) 'range': range,
      if (components != null) 'components': components,
      if (materialCostCp != null) 'material_cost_cp': materialCostCp,
      if (materialConsumed != null) 'material_consumed': materialConsumed,
      if (duration != null) 'duration': duration,
      if (concentration != null) 'concentration': concentration,
      if (ritual != null) 'ritual': ritual,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpellsCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<String>? name,
    Value<String?>? extendsId,
    Value<int>? level,
    Value<String>? school,
    Value<String>? castingTime,
    Value<String>? range,
    Value<String>? components,
    Value<int?>? materialCostCp,
    Value<bool>? materialConsumed,
    Value<String>? duration,
    Value<bool>? concentration,
    Value<bool>? ritual,
    Value<int>? rowid,
  }) {
    return SpellsCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      name: name ?? this.name,
      extendsId: extendsId ?? this.extendsId,
      level: level ?? this.level,
      school: school ?? this.school,
      castingTime: castingTime ?? this.castingTime,
      range: range ?? this.range,
      components: components ?? this.components,
      materialCostCp: materialCostCp ?? this.materialCostCp,
      materialConsumed: materialConsumed ?? this.materialConsumed,
      duration: duration ?? this.duration,
      concentration: concentration ?? this.concentration,
      ritual: ritual ?? this.ritual,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (extendsId.present) {
      map['extends_id'] = Variable<String>(extendsId.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (school.present) {
      map['school'] = Variable<String>(school.value);
    }
    if (castingTime.present) {
      map['casting_time'] = Variable<String>(castingTime.value);
    }
    if (range.present) {
      map['range'] = Variable<String>(range.value);
    }
    if (components.present) {
      map['components'] = Variable<String>(components.value);
    }
    if (materialCostCp.present) {
      map['material_cost_cp'] = Variable<int>(materialCostCp.value);
    }
    if (materialConsumed.present) {
      map['material_consumed'] = Variable<bool>(materialConsumed.value);
    }
    if (duration.present) {
      map['duration'] = Variable<String>(duration.value);
    }
    if (concentration.present) {
      map['concentration'] = Variable<bool>(concentration.value);
    }
    if (ritual.present) {
      map['ritual'] = Variable<bool>(ritual.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpellsCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('level: $level, ')
          ..write('school: $school, ')
          ..write('castingTime: $castingTime, ')
          ..write('range: $range, ')
          ..write('components: $components, ')
          ..write('materialCostCp: $materialCostCp, ')
          ..write('materialConsumed: $materialConsumed, ')
          ..write('duration: $duration, ')
          ..write('concentration: $concentration, ')
          ..write('ritual: $ritual, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SpellClassesTable extends SpellClasses
    with TableInfo<$SpellClassesTable, SpellClassRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpellClassesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _spellIdMeta = const VerificationMeta(
    'spellId',
  );
  @override
  late final GeneratedColumn<String> spellId = GeneratedColumn<String>(
    'spell_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _classIdMeta = const VerificationMeta(
    'classId',
  );
  @override
  late final GeneratedColumn<String> classId = GeneratedColumn<String>(
    'class_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [packId, spellId, classId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'spell_class';
  @override
  VerificationContext validateIntegrity(
    Insertable<SpellClassRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('spell_id')) {
      context.handle(
        _spellIdMeta,
        spellId.isAcceptableOrUnknown(data['spell_id']!, _spellIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spellIdMeta);
    }
    if (data.containsKey('class_id')) {
      context.handle(
        _classIdMeta,
        classId.isAcceptableOrUnknown(data['class_id']!, _classIdMeta),
      );
    } else if (isInserting) {
      context.missing(_classIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {spellId, classId};
  @override
  SpellClassRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpellClassRow(
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      spellId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spell_id'],
      )!,
      classId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_id'],
      )!,
    );
  }

  @override
  $SpellClassesTable createAlias(String alias) {
    return $SpellClassesTable(attachedDatabase, alias);
  }
}

class SpellClassRow extends DataClass implements Insertable<SpellClassRow> {
  final String packId;
  final String spellId;
  final String classId;
  const SpellClassRow({
    required this.packId,
    required this.spellId,
    required this.classId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pack_id'] = Variable<String>(packId);
    map['spell_id'] = Variable<String>(spellId);
    map['class_id'] = Variable<String>(classId);
    return map;
  }

  SpellClassesCompanion toCompanion(bool nullToAbsent) {
    return SpellClassesCompanion(
      packId: Value(packId),
      spellId: Value(spellId),
      classId: Value(classId),
    );
  }

  factory SpellClassRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpellClassRow(
      packId: serializer.fromJson<String>(json['packId']),
      spellId: serializer.fromJson<String>(json['spellId']),
      classId: serializer.fromJson<String>(json['classId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packId': serializer.toJson<String>(packId),
      'spellId': serializer.toJson<String>(spellId),
      'classId': serializer.toJson<String>(classId),
    };
  }

  SpellClassRow copyWith({String? packId, String? spellId, String? classId}) =>
      SpellClassRow(
        packId: packId ?? this.packId,
        spellId: spellId ?? this.spellId,
        classId: classId ?? this.classId,
      );
  SpellClassRow copyWithCompanion(SpellClassesCompanion data) {
    return SpellClassRow(
      packId: data.packId.present ? data.packId.value : this.packId,
      spellId: data.spellId.present ? data.spellId.value : this.spellId,
      classId: data.classId.present ? data.classId.value : this.classId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpellClassRow(')
          ..write('packId: $packId, ')
          ..write('spellId: $spellId, ')
          ..write('classId: $classId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(packId, spellId, classId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpellClassRow &&
          other.packId == this.packId &&
          other.spellId == this.spellId &&
          other.classId == this.classId);
}

class SpellClassesCompanion extends UpdateCompanion<SpellClassRow> {
  final Value<String> packId;
  final Value<String> spellId;
  final Value<String> classId;
  final Value<int> rowid;
  const SpellClassesCompanion({
    this.packId = const Value.absent(),
    this.spellId = const Value.absent(),
    this.classId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpellClassesCompanion.insert({
    required String packId,
    required String spellId,
    required String classId,
    this.rowid = const Value.absent(),
  }) : packId = Value(packId),
       spellId = Value(spellId),
       classId = Value(classId);
  static Insertable<SpellClassRow> custom({
    Expression<String>? packId,
    Expression<String>? spellId,
    Expression<String>? classId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packId != null) 'pack_id': packId,
      if (spellId != null) 'spell_id': spellId,
      if (classId != null) 'class_id': classId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpellClassesCompanion copyWith({
    Value<String>? packId,
    Value<String>? spellId,
    Value<String>? classId,
    Value<int>? rowid,
  }) {
    return SpellClassesCompanion(
      packId: packId ?? this.packId,
      spellId: spellId ?? this.spellId,
      classId: classId ?? this.classId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (spellId.present) {
      map['spell_id'] = Variable<String>(spellId.value);
    }
    if (classId.present) {
      map['class_id'] = Variable<String>(classId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpellClassesCompanion(')
          ..write('packId: $packId, ')
          ..write('spellId: $spellId, ')
          ..write('classId: $classId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MonstersTable extends Monsters
    with TableInfo<$MonstersTable, MonsterRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonstersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extendsIdMeta = const VerificationMeta(
    'extendsId',
  );
  @override
  late final GeneratedColumn<String> extendsId = GeneratedColumn<String>(
    'extends_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creatureTypeMeta = const VerificationMeta(
    'creatureType',
  );
  @override
  late final GeneratedColumn<String> creatureType = GeneratedColumn<String>(
    'creature_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _challengeRatingMeta = const VerificationMeta(
    'challengeRating',
  );
  @override
  late final GeneratedColumn<String> challengeRating = GeneratedColumn<String>(
    'challenge_rating',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
    'xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intelligenceMeta = const VerificationMeta(
    'intelligence',
  );
  @override
  late final GeneratedColumn<int> intelligence = GeneratedColumn<int>(
    'intelligence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statBlockMeta = const VerificationMeta(
    'statBlock',
  );
  @override
  late final GeneratedColumn<String> statBlock = GeneratedColumn<String>(
    'stat_block',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packId,
    name,
    extendsId,
    creatureType,
    challengeRating,
    xp,
    intelligence,
    statBlock,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monster';
  @override
  VerificationContext validateIntegrity(
    Insertable<MonsterRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('extends_id')) {
      context.handle(
        _extendsIdMeta,
        extendsId.isAcceptableOrUnknown(data['extends_id']!, _extendsIdMeta),
      );
    }
    if (data.containsKey('creature_type')) {
      context.handle(
        _creatureTypeMeta,
        creatureType.isAcceptableOrUnknown(
          data['creature_type']!,
          _creatureTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_creatureTypeMeta);
    }
    if (data.containsKey('challenge_rating')) {
      context.handle(
        _challengeRatingMeta,
        challengeRating.isAcceptableOrUnknown(
          data['challenge_rating']!,
          _challengeRatingMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_challengeRatingMeta);
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    } else if (isInserting) {
      context.missing(_xpMeta);
    }
    if (data.containsKey('intelligence')) {
      context.handle(
        _intelligenceMeta,
        intelligence.isAcceptableOrUnknown(
          data['intelligence']!,
          _intelligenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_intelligenceMeta);
    }
    if (data.containsKey('stat_block')) {
      context.handle(
        _statBlockMeta,
        statBlock.isAcceptableOrUnknown(data['stat_block']!, _statBlockMeta),
      );
    } else if (isInserting) {
      context.missing(_statBlockMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MonsterRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonsterRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      extendsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extends_id'],
      ),
      creatureType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creature_type'],
      )!,
      challengeRating: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}challenge_rating'],
      )!,
      xp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp'],
      )!,
      intelligence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intelligence'],
      )!,
      statBlock: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stat_block'],
      )!,
    );
  }

  @override
  $MonstersTable createAlias(String alias) {
    return $MonstersTable(attachedDatabase, alias);
  }
}

class MonsterRow extends DataClass implements Insertable<MonsterRow> {
  final String id;
  final String packId;
  final String name;
  final String? extendsId;
  final String creatureType;
  final String challengeRating;
  final int xp;
  final int intelligence;
  final String statBlock;
  const MonsterRow({
    required this.id,
    required this.packId,
    required this.name,
    this.extendsId,
    required this.creatureType,
    required this.challengeRating,
    required this.xp,
    required this.intelligence,
    required this.statBlock,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || extendsId != null) {
      map['extends_id'] = Variable<String>(extendsId);
    }
    map['creature_type'] = Variable<String>(creatureType);
    map['challenge_rating'] = Variable<String>(challengeRating);
    map['xp'] = Variable<int>(xp);
    map['intelligence'] = Variable<int>(intelligence);
    map['stat_block'] = Variable<String>(statBlock);
    return map;
  }

  MonstersCompanion toCompanion(bool nullToAbsent) {
    return MonstersCompanion(
      id: Value(id),
      packId: Value(packId),
      name: Value(name),
      extendsId: extendsId == null && nullToAbsent
          ? const Value.absent()
          : Value(extendsId),
      creatureType: Value(creatureType),
      challengeRating: Value(challengeRating),
      xp: Value(xp),
      intelligence: Value(intelligence),
      statBlock: Value(statBlock),
    );
  }

  factory MonsterRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonsterRow(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      name: serializer.fromJson<String>(json['name']),
      extendsId: serializer.fromJson<String?>(json['extendsId']),
      creatureType: serializer.fromJson<String>(json['creatureType']),
      challengeRating: serializer.fromJson<String>(json['challengeRating']),
      xp: serializer.fromJson<int>(json['xp']),
      intelligence: serializer.fromJson<int>(json['intelligence']),
      statBlock: serializer.fromJson<String>(json['statBlock']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'name': serializer.toJson<String>(name),
      'extendsId': serializer.toJson<String?>(extendsId),
      'creatureType': serializer.toJson<String>(creatureType),
      'challengeRating': serializer.toJson<String>(challengeRating),
      'xp': serializer.toJson<int>(xp),
      'intelligence': serializer.toJson<int>(intelligence),
      'statBlock': serializer.toJson<String>(statBlock),
    };
  }

  MonsterRow copyWith({
    String? id,
    String? packId,
    String? name,
    Value<String?> extendsId = const Value.absent(),
    String? creatureType,
    String? challengeRating,
    int? xp,
    int? intelligence,
    String? statBlock,
  }) => MonsterRow(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    name: name ?? this.name,
    extendsId: extendsId.present ? extendsId.value : this.extendsId,
    creatureType: creatureType ?? this.creatureType,
    challengeRating: challengeRating ?? this.challengeRating,
    xp: xp ?? this.xp,
    intelligence: intelligence ?? this.intelligence,
    statBlock: statBlock ?? this.statBlock,
  );
  MonsterRow copyWithCompanion(MonstersCompanion data) {
    return MonsterRow(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      name: data.name.present ? data.name.value : this.name,
      extendsId: data.extendsId.present ? data.extendsId.value : this.extendsId,
      creatureType: data.creatureType.present
          ? data.creatureType.value
          : this.creatureType,
      challengeRating: data.challengeRating.present
          ? data.challengeRating.value
          : this.challengeRating,
      xp: data.xp.present ? data.xp.value : this.xp,
      intelligence: data.intelligence.present
          ? data.intelligence.value
          : this.intelligence,
      statBlock: data.statBlock.present ? data.statBlock.value : this.statBlock,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonsterRow(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('creatureType: $creatureType, ')
          ..write('challengeRating: $challengeRating, ')
          ..write('xp: $xp, ')
          ..write('intelligence: $intelligence, ')
          ..write('statBlock: $statBlock')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    packId,
    name,
    extendsId,
    creatureType,
    challengeRating,
    xp,
    intelligence,
    statBlock,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonsterRow &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.name == this.name &&
          other.extendsId == this.extendsId &&
          other.creatureType == this.creatureType &&
          other.challengeRating == this.challengeRating &&
          other.xp == this.xp &&
          other.intelligence == this.intelligence &&
          other.statBlock == this.statBlock);
}

class MonstersCompanion extends UpdateCompanion<MonsterRow> {
  final Value<String> id;
  final Value<String> packId;
  final Value<String> name;
  final Value<String?> extendsId;
  final Value<String> creatureType;
  final Value<String> challengeRating;
  final Value<int> xp;
  final Value<int> intelligence;
  final Value<String> statBlock;
  final Value<int> rowid;
  const MonstersCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.name = const Value.absent(),
    this.extendsId = const Value.absent(),
    this.creatureType = const Value.absent(),
    this.challengeRating = const Value.absent(),
    this.xp = const Value.absent(),
    this.intelligence = const Value.absent(),
    this.statBlock = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MonstersCompanion.insert({
    required String id,
    required String packId,
    required String name,
    this.extendsId = const Value.absent(),
    required String creatureType,
    required String challengeRating,
    required int xp,
    required int intelligence,
    required String statBlock,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       name = Value(name),
       creatureType = Value(creatureType),
       challengeRating = Value(challengeRating),
       xp = Value(xp),
       intelligence = Value(intelligence),
       statBlock = Value(statBlock);
  static Insertable<MonsterRow> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<String>? name,
    Expression<String>? extendsId,
    Expression<String>? creatureType,
    Expression<String>? challengeRating,
    Expression<int>? xp,
    Expression<int>? intelligence,
    Expression<String>? statBlock,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (name != null) 'name': name,
      if (extendsId != null) 'extends_id': extendsId,
      if (creatureType != null) 'creature_type': creatureType,
      if (challengeRating != null) 'challenge_rating': challengeRating,
      if (xp != null) 'xp': xp,
      if (intelligence != null) 'intelligence': intelligence,
      if (statBlock != null) 'stat_block': statBlock,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MonstersCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<String>? name,
    Value<String?>? extendsId,
    Value<String>? creatureType,
    Value<String>? challengeRating,
    Value<int>? xp,
    Value<int>? intelligence,
    Value<String>? statBlock,
    Value<int>? rowid,
  }) {
    return MonstersCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      name: name ?? this.name,
      extendsId: extendsId ?? this.extendsId,
      creatureType: creatureType ?? this.creatureType,
      challengeRating: challengeRating ?? this.challengeRating,
      xp: xp ?? this.xp,
      intelligence: intelligence ?? this.intelligence,
      statBlock: statBlock ?? this.statBlock,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (extendsId.present) {
      map['extends_id'] = Variable<String>(extendsId.value);
    }
    if (creatureType.present) {
      map['creature_type'] = Variable<String>(creatureType.value);
    }
    if (challengeRating.present) {
      map['challenge_rating'] = Variable<String>(challengeRating.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (intelligence.present) {
      map['intelligence'] = Variable<int>(intelligence.value);
    }
    if (statBlock.present) {
      map['stat_block'] = Variable<String>(statBlock.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonstersCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('name: $name, ')
          ..write('extendsId: $extendsId, ')
          ..write('creatureType: $creatureType, ')
          ..write('challengeRating: $challengeRating, ')
          ..write('xp: $xp, ')
          ..write('intelligence: $intelligence, ')
          ..write('statBlock: $statBlock, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MonsterActionsTable extends MonsterActions
    with TableInfo<$MonsterActionsTable, MonsterActionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonsterActionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _monsterIdMeta = const VerificationMeta(
    'monsterId',
  );
  @override
  late final GeneratedColumn<String> monsterId = GeneratedColumn<String>(
    'monster_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rechargeMeta = const VerificationMeta(
    'recharge',
  );
  @override
  late final GeneratedColumn<String> recharge = GeneratedColumn<String>(
    'recharge',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    packId,
    monsterId,
    position,
    kind,
    name,
    recharge,
    data,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monster_action';
  @override
  VerificationContext validateIntegrity(
    Insertable<MonsterActionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('monster_id')) {
      context.handle(
        _monsterIdMeta,
        monsterId.isAcceptableOrUnknown(data['monster_id']!, _monsterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_monsterIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('recharge')) {
      context.handle(
        _rechargeMeta,
        recharge.isAcceptableOrUnknown(data['recharge']!, _rechargeMeta),
      );
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {monsterId, position};
  @override
  MonsterActionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonsterActionRow(
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      monsterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}monster_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      recharge: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recharge'],
      ),
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
    );
  }

  @override
  $MonsterActionsTable createAlias(String alias) {
    return $MonsterActionsTable(attachedDatabase, alias);
  }
}

class MonsterActionRow extends DataClass
    implements Insertable<MonsterActionRow> {
  final String packId;
  final String monsterId;
  final int position;

  /// `action`, `bonus`, `reaction`, `legendary`…
  final String kind;
  final String name;
  final String? recharge;
  final String data;
  const MonsterActionRow({
    required this.packId,
    required this.monsterId,
    required this.position,
    required this.kind,
    required this.name,
    this.recharge,
    required this.data,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pack_id'] = Variable<String>(packId);
    map['monster_id'] = Variable<String>(monsterId);
    map['position'] = Variable<int>(position);
    map['kind'] = Variable<String>(kind);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || recharge != null) {
      map['recharge'] = Variable<String>(recharge);
    }
    map['data'] = Variable<String>(data);
    return map;
  }

  MonsterActionsCompanion toCompanion(bool nullToAbsent) {
    return MonsterActionsCompanion(
      packId: Value(packId),
      monsterId: Value(monsterId),
      position: Value(position),
      kind: Value(kind),
      name: Value(name),
      recharge: recharge == null && nullToAbsent
          ? const Value.absent()
          : Value(recharge),
      data: Value(data),
    );
  }

  factory MonsterActionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonsterActionRow(
      packId: serializer.fromJson<String>(json['packId']),
      monsterId: serializer.fromJson<String>(json['monsterId']),
      position: serializer.fromJson<int>(json['position']),
      kind: serializer.fromJson<String>(json['kind']),
      name: serializer.fromJson<String>(json['name']),
      recharge: serializer.fromJson<String?>(json['recharge']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packId': serializer.toJson<String>(packId),
      'monsterId': serializer.toJson<String>(monsterId),
      'position': serializer.toJson<int>(position),
      'kind': serializer.toJson<String>(kind),
      'name': serializer.toJson<String>(name),
      'recharge': serializer.toJson<String?>(recharge),
      'data': serializer.toJson<String>(data),
    };
  }

  MonsterActionRow copyWith({
    String? packId,
    String? monsterId,
    int? position,
    String? kind,
    String? name,
    Value<String?> recharge = const Value.absent(),
    String? data,
  }) => MonsterActionRow(
    packId: packId ?? this.packId,
    monsterId: monsterId ?? this.monsterId,
    position: position ?? this.position,
    kind: kind ?? this.kind,
    name: name ?? this.name,
    recharge: recharge.present ? recharge.value : this.recharge,
    data: data ?? this.data,
  );
  MonsterActionRow copyWithCompanion(MonsterActionsCompanion data) {
    return MonsterActionRow(
      packId: data.packId.present ? data.packId.value : this.packId,
      monsterId: data.monsterId.present ? data.monsterId.value : this.monsterId,
      position: data.position.present ? data.position.value : this.position,
      kind: data.kind.present ? data.kind.value : this.kind,
      name: data.name.present ? data.name.value : this.name,
      recharge: data.recharge.present ? data.recharge.value : this.recharge,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonsterActionRow(')
          ..write('packId: $packId, ')
          ..write('monsterId: $monsterId, ')
          ..write('position: $position, ')
          ..write('kind: $kind, ')
          ..write('name: $name, ')
          ..write('recharge: $recharge, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(packId, monsterId, position, kind, name, recharge, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonsterActionRow &&
          other.packId == this.packId &&
          other.monsterId == this.monsterId &&
          other.position == this.position &&
          other.kind == this.kind &&
          other.name == this.name &&
          other.recharge == this.recharge &&
          other.data == this.data);
}

class MonsterActionsCompanion extends UpdateCompanion<MonsterActionRow> {
  final Value<String> packId;
  final Value<String> monsterId;
  final Value<int> position;
  final Value<String> kind;
  final Value<String> name;
  final Value<String?> recharge;
  final Value<String> data;
  final Value<int> rowid;
  const MonsterActionsCompanion({
    this.packId = const Value.absent(),
    this.monsterId = const Value.absent(),
    this.position = const Value.absent(),
    this.kind = const Value.absent(),
    this.name = const Value.absent(),
    this.recharge = const Value.absent(),
    this.data = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MonsterActionsCompanion.insert({
    required String packId,
    required String monsterId,
    required int position,
    required String kind,
    required String name,
    this.recharge = const Value.absent(),
    required String data,
    this.rowid = const Value.absent(),
  }) : packId = Value(packId),
       monsterId = Value(monsterId),
       position = Value(position),
       kind = Value(kind),
       name = Value(name),
       data = Value(data);
  static Insertable<MonsterActionRow> custom({
    Expression<String>? packId,
    Expression<String>? monsterId,
    Expression<int>? position,
    Expression<String>? kind,
    Expression<String>? name,
    Expression<String>? recharge,
    Expression<String>? data,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packId != null) 'pack_id': packId,
      if (monsterId != null) 'monster_id': monsterId,
      if (position != null) 'position': position,
      if (kind != null) 'kind': kind,
      if (name != null) 'name': name,
      if (recharge != null) 'recharge': recharge,
      if (data != null) 'data': data,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MonsterActionsCompanion copyWith({
    Value<String>? packId,
    Value<String>? monsterId,
    Value<int>? position,
    Value<String>? kind,
    Value<String>? name,
    Value<String?>? recharge,
    Value<String>? data,
    Value<int>? rowid,
  }) {
    return MonsterActionsCompanion(
      packId: packId ?? this.packId,
      monsterId: monsterId ?? this.monsterId,
      position: position ?? this.position,
      kind: kind ?? this.kind,
      name: name ?? this.name,
      recharge: recharge ?? this.recharge,
      data: data ?? this.data,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (monsterId.present) {
      map['monster_id'] = Variable<String>(monsterId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (recharge.present) {
      map['recharge'] = Variable<String>(recharge.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonsterActionsCompanion(')
          ..write('packId: $packId, ')
          ..write('monsterId: $monsterId, ')
          ..write('position: $position, ')
          ..write('kind: $kind, ')
          ..write('name: $name, ')
          ..write('recharge: $recharge, ')
          ..write('data: $data, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudyRevealsTable extends StudyReveals
    with TableInfo<$StudyRevealsTable, StudyRevealRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyRevealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _monsterIdMeta = const VerificationMeta(
    'monsterId',
  );
  @override
  late final GeneratedColumn<String> monsterId = GeneratedColumn<String>(
    'monster_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dcMeta = const VerificationMeta('dc');
  @override
  late final GeneratedColumn<int> dc = GeneratedColumn<int>(
    'dc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revealTextMeta = const VerificationMeta(
    'revealText',
  );
  @override
  late final GeneratedColumn<String> revealText = GeneratedColumn<String>(
    'reveal_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [packId, monsterId, dc, revealText];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_reveal';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyRevealRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('monster_id')) {
      context.handle(
        _monsterIdMeta,
        monsterId.isAcceptableOrUnknown(data['monster_id']!, _monsterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_monsterIdMeta);
    }
    if (data.containsKey('dc')) {
      context.handle(_dcMeta, dc.isAcceptableOrUnknown(data['dc']!, _dcMeta));
    } else if (isInserting) {
      context.missing(_dcMeta);
    }
    if (data.containsKey('reveal_text')) {
      context.handle(
        _revealTextMeta,
        revealText.isAcceptableOrUnknown(data['reveal_text']!, _revealTextMeta),
      );
    } else if (isInserting) {
      context.missing(_revealTextMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {monsterId, dc};
  @override
  StudyRevealRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyRevealRow(
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      monsterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}monster_id'],
      )!,
      dc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dc'],
      )!,
      revealText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reveal_text'],
      )!,
    );
  }

  @override
  $StudyRevealsTable createAlias(String alias) {
    return $StudyRevealsTable(attachedDatabase, alias);
  }
}

class StudyRevealRow extends DataClass implements Insertable<StudyRevealRow> {
  final String packId;
  final String monsterId;
  final int dc;
  final String revealText;
  const StudyRevealRow({
    required this.packId,
    required this.monsterId,
    required this.dc,
    required this.revealText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pack_id'] = Variable<String>(packId);
    map['monster_id'] = Variable<String>(monsterId);
    map['dc'] = Variable<int>(dc);
    map['reveal_text'] = Variable<String>(revealText);
    return map;
  }

  StudyRevealsCompanion toCompanion(bool nullToAbsent) {
    return StudyRevealsCompanion(
      packId: Value(packId),
      monsterId: Value(monsterId),
      dc: Value(dc),
      revealText: Value(revealText),
    );
  }

  factory StudyRevealRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyRevealRow(
      packId: serializer.fromJson<String>(json['packId']),
      monsterId: serializer.fromJson<String>(json['monsterId']),
      dc: serializer.fromJson<int>(json['dc']),
      revealText: serializer.fromJson<String>(json['revealText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packId': serializer.toJson<String>(packId),
      'monsterId': serializer.toJson<String>(monsterId),
      'dc': serializer.toJson<int>(dc),
      'revealText': serializer.toJson<String>(revealText),
    };
  }

  StudyRevealRow copyWith({
    String? packId,
    String? monsterId,
    int? dc,
    String? revealText,
  }) => StudyRevealRow(
    packId: packId ?? this.packId,
    monsterId: monsterId ?? this.monsterId,
    dc: dc ?? this.dc,
    revealText: revealText ?? this.revealText,
  );
  StudyRevealRow copyWithCompanion(StudyRevealsCompanion data) {
    return StudyRevealRow(
      packId: data.packId.present ? data.packId.value : this.packId,
      monsterId: data.monsterId.present ? data.monsterId.value : this.monsterId,
      dc: data.dc.present ? data.dc.value : this.dc,
      revealText: data.revealText.present
          ? data.revealText.value
          : this.revealText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyRevealRow(')
          ..write('packId: $packId, ')
          ..write('monsterId: $monsterId, ')
          ..write('dc: $dc, ')
          ..write('revealText: $revealText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(packId, monsterId, dc, revealText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyRevealRow &&
          other.packId == this.packId &&
          other.monsterId == this.monsterId &&
          other.dc == this.dc &&
          other.revealText == this.revealText);
}

class StudyRevealsCompanion extends UpdateCompanion<StudyRevealRow> {
  final Value<String> packId;
  final Value<String> monsterId;
  final Value<int> dc;
  final Value<String> revealText;
  final Value<int> rowid;
  const StudyRevealsCompanion({
    this.packId = const Value.absent(),
    this.monsterId = const Value.absent(),
    this.dc = const Value.absent(),
    this.revealText = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyRevealsCompanion.insert({
    required String packId,
    required String monsterId,
    required int dc,
    required String revealText,
    this.rowid = const Value.absent(),
  }) : packId = Value(packId),
       monsterId = Value(monsterId),
       dc = Value(dc),
       revealText = Value(revealText);
  static Insertable<StudyRevealRow> custom({
    Expression<String>? packId,
    Expression<String>? monsterId,
    Expression<int>? dc,
    Expression<String>? revealText,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packId != null) 'pack_id': packId,
      if (monsterId != null) 'monster_id': monsterId,
      if (dc != null) 'dc': dc,
      if (revealText != null) 'reveal_text': revealText,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyRevealsCompanion copyWith({
    Value<String>? packId,
    Value<String>? monsterId,
    Value<int>? dc,
    Value<String>? revealText,
    Value<int>? rowid,
  }) {
    return StudyRevealsCompanion(
      packId: packId ?? this.packId,
      monsterId: monsterId ?? this.monsterId,
      dc: dc ?? this.dc,
      revealText: revealText ?? this.revealText,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (monsterId.present) {
      map['monster_id'] = Variable<String>(monsterId.value);
    }
    if (dc.present) {
      map['dc'] = Variable<int>(dc.value);
    }
    if (revealText.present) {
      map['reveal_text'] = Variable<String>(revealText.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyRevealsCompanion(')
          ..write('packId: $packId, ')
          ..write('monsterId: $monsterId, ')
          ..write('dc: $dc, ')
          ..write('revealText: $revealText, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EffectsTable extends Effects with TableInfo<$EffectsTable, EffectRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EffectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerTypeMeta = const VerificationMeta(
    'ownerType',
  );
  @override
  late final GeneratedColumn<String> ownerType = GeneratedColumn<String>(
    'owner_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    packId,
    ownerId,
    ownerType,
    position,
    payload,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'effect';
  @override
  VerificationContext validateIntegrity(
    Insertable<EffectRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('owner_type')) {
      context.handle(
        _ownerTypeMeta,
        ownerType.isAcceptableOrUnknown(data['owner_type']!, _ownerTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerTypeMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ownerId, position};
  @override
  EffectRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EffectRow(
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      ownerType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_type'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
    );
  }

  @override
  $EffectsTable createAlias(String alias) {
    return $EffectsTable(attachedDatabase, alias);
  }
}

class EffectRow extends DataClass implements Insertable<EffectRow> {
  final String packId;
  final String ownerId;
  final String ownerType;
  final int position;
  final String payload;
  const EffectRow({
    required this.packId,
    required this.ownerId,
    required this.ownerType,
    required this.position,
    required this.payload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pack_id'] = Variable<String>(packId);
    map['owner_id'] = Variable<String>(ownerId);
    map['owner_type'] = Variable<String>(ownerType);
    map['position'] = Variable<int>(position);
    map['payload'] = Variable<String>(payload);
    return map;
  }

  EffectsCompanion toCompanion(bool nullToAbsent) {
    return EffectsCompanion(
      packId: Value(packId),
      ownerId: Value(ownerId),
      ownerType: Value(ownerType),
      position: Value(position),
      payload: Value(payload),
    );
  }

  factory EffectRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EffectRow(
      packId: serializer.fromJson<String>(json['packId']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      ownerType: serializer.fromJson<String>(json['ownerType']),
      position: serializer.fromJson<int>(json['position']),
      payload: serializer.fromJson<String>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packId': serializer.toJson<String>(packId),
      'ownerId': serializer.toJson<String>(ownerId),
      'ownerType': serializer.toJson<String>(ownerType),
      'position': serializer.toJson<int>(position),
      'payload': serializer.toJson<String>(payload),
    };
  }

  EffectRow copyWith({
    String? packId,
    String? ownerId,
    String? ownerType,
    int? position,
    String? payload,
  }) => EffectRow(
    packId: packId ?? this.packId,
    ownerId: ownerId ?? this.ownerId,
    ownerType: ownerType ?? this.ownerType,
    position: position ?? this.position,
    payload: payload ?? this.payload,
  );
  EffectRow copyWithCompanion(EffectsCompanion data) {
    return EffectRow(
      packId: data.packId.present ? data.packId.value : this.packId,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      ownerType: data.ownerType.present ? data.ownerType.value : this.ownerType,
      position: data.position.present ? data.position.value : this.position,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EffectRow(')
          ..write('packId: $packId, ')
          ..write('ownerId: $ownerId, ')
          ..write('ownerType: $ownerType, ')
          ..write('position: $position, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(packId, ownerId, ownerType, position, payload);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EffectRow &&
          other.packId == this.packId &&
          other.ownerId == this.ownerId &&
          other.ownerType == this.ownerType &&
          other.position == this.position &&
          other.payload == this.payload);
}

class EffectsCompanion extends UpdateCompanion<EffectRow> {
  final Value<String> packId;
  final Value<String> ownerId;
  final Value<String> ownerType;
  final Value<int> position;
  final Value<String> payload;
  final Value<int> rowid;
  const EffectsCompanion({
    this.packId = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.ownerType = const Value.absent(),
    this.position = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EffectsCompanion.insert({
    required String packId,
    required String ownerId,
    required String ownerType,
    required int position,
    required String payload,
    this.rowid = const Value.absent(),
  }) : packId = Value(packId),
       ownerId = Value(ownerId),
       ownerType = Value(ownerType),
       position = Value(position),
       payload = Value(payload);
  static Insertable<EffectRow> custom({
    Expression<String>? packId,
    Expression<String>? ownerId,
    Expression<String>? ownerType,
    Expression<int>? position,
    Expression<String>? payload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packId != null) 'pack_id': packId,
      if (ownerId != null) 'owner_id': ownerId,
      if (ownerType != null) 'owner_type': ownerType,
      if (position != null) 'position': position,
      if (payload != null) 'payload': payload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EffectsCompanion copyWith({
    Value<String>? packId,
    Value<String>? ownerId,
    Value<String>? ownerType,
    Value<int>? position,
    Value<String>? payload,
    Value<int>? rowid,
  }) {
    return EffectsCompanion(
      packId: packId ?? this.packId,
      ownerId: ownerId ?? this.ownerId,
      ownerType: ownerType ?? this.ownerType,
      position: position ?? this.position,
      payload: payload ?? this.payload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (ownerType.present) {
      map['owner_type'] = Variable<String>(ownerType.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EffectsCompanion(')
          ..write('packId: $packId, ')
          ..write('ownerId: $ownerId, ')
          ..write('ownerType: $ownerType, ')
          ..write('position: $position, ')
          ..write('payload: $payload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntityTextsTable extends EntityTexts
    with TableInfo<$EntityTextsTable, EntityTextRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntityTextsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_pack (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [packId, entityId, locale, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entity_text';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntityTextRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    } else if (isInserting) {
      context.missing(_localeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityId, locale};
  @override
  EntityTextRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntityTextRow(
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
    );
  }

  @override
  $EntityTextsTable createAlias(String alias) {
    return $EntityTextsTable(attachedDatabase, alias);
  }
}

class EntityTextRow extends DataClass implements Insertable<EntityTextRow> {
  final String packId;
  final String entityId;
  final String locale;
  final String description;
  const EntityTextRow({
    required this.packId,
    required this.entityId,
    required this.locale,
    required this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pack_id'] = Variable<String>(packId);
    map['entity_id'] = Variable<String>(entityId);
    map['locale'] = Variable<String>(locale);
    map['description'] = Variable<String>(description);
    return map;
  }

  EntityTextsCompanion toCompanion(bool nullToAbsent) {
    return EntityTextsCompanion(
      packId: Value(packId),
      entityId: Value(entityId),
      locale: Value(locale),
      description: Value(description),
    );
  }

  factory EntityTextRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntityTextRow(
      packId: serializer.fromJson<String>(json['packId']),
      entityId: serializer.fromJson<String>(json['entityId']),
      locale: serializer.fromJson<String>(json['locale']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packId': serializer.toJson<String>(packId),
      'entityId': serializer.toJson<String>(entityId),
      'locale': serializer.toJson<String>(locale),
      'description': serializer.toJson<String>(description),
    };
  }

  EntityTextRow copyWith({
    String? packId,
    String? entityId,
    String? locale,
    String? description,
  }) => EntityTextRow(
    packId: packId ?? this.packId,
    entityId: entityId ?? this.entityId,
    locale: locale ?? this.locale,
    description: description ?? this.description,
  );
  EntityTextRow copyWithCompanion(EntityTextsCompanion data) {
    return EntityTextRow(
      packId: data.packId.present ? data.packId.value : this.packId,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      locale: data.locale.present ? data.locale.value : this.locale,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntityTextRow(')
          ..write('packId: $packId, ')
          ..write('entityId: $entityId, ')
          ..write('locale: $locale, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(packId, entityId, locale, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntityTextRow &&
          other.packId == this.packId &&
          other.entityId == this.entityId &&
          other.locale == this.locale &&
          other.description == this.description);
}

class EntityTextsCompanion extends UpdateCompanion<EntityTextRow> {
  final Value<String> packId;
  final Value<String> entityId;
  final Value<String> locale;
  final Value<String> description;
  final Value<int> rowid;
  const EntityTextsCompanion({
    this.packId = const Value.absent(),
    this.entityId = const Value.absent(),
    this.locale = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntityTextsCompanion.insert({
    required String packId,
    required String entityId,
    required String locale,
    required String description,
    this.rowid = const Value.absent(),
  }) : packId = Value(packId),
       entityId = Value(entityId),
       locale = Value(locale),
       description = Value(description);
  static Insertable<EntityTextRow> custom({
    Expression<String>? packId,
    Expression<String>? entityId,
    Expression<String>? locale,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packId != null) 'pack_id': packId,
      if (entityId != null) 'entity_id': entityId,
      if (locale != null) 'locale': locale,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntityTextsCompanion copyWith({
    Value<String>? packId,
    Value<String>? entityId,
    Value<String>? locale,
    Value<String>? description,
    Value<int>? rowid,
  }) {
    return EntityTextsCompanion(
      packId: packId ?? this.packId,
      entityId: entityId ?? this.entityId,
      locale: locale ?? this.locale,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntityTextsCompanion(')
          ..write('packId: $packId, ')
          ..write('entityId: $entityId, ')
          ..write('locale: $locale, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$TavernierDatabase extends GeneratedDatabase {
  _$TavernierDatabase(QueryExecutor e) : super(e);
  $TavernierDatabaseManager get managers => $TavernierDatabaseManager(this);
  late final ContentSearch contentSearch = ContentSearch(this);
  late final $ContentPacksTable contentPacks = $ContentPacksTable(this);
  late final $PackDependenciesTable packDependencies = $PackDependenciesTable(
    this,
  );
  late final $AbilitiesTable abilities = $AbilitiesTable(this);
  late final $SkillsTable skills = $SkillsTable(this);
  late final $LanguagesTable languages = $LanguagesTable(this);
  late final $ConditionsTable conditions = $ConditionsTable(this);
  late final $DamageTypesTable damageTypes = $DamageTypesTable(this);
  late final $MasteryPropertiesTable masteryProperties =
      $MasteryPropertiesTable(this);
  late final $WeaponsTable weapons = $WeaponsTable(this);
  late final $ArmorsTable armors = $ArmorsTable(this);
  late final $ToolsTable tools = $ToolsTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final $BackgroundsTable backgrounds = $BackgroundsTable(this);
  late final $BackgroundAbilitiesTable backgroundAbilities =
      $BackgroundAbilitiesTable(this);
  late final $BackgroundProficienciesTable backgroundProficiencies =
      $BackgroundProficienciesTable(this);
  late final $BackgroundEquipmentOptionsTable backgroundEquipmentOptions =
      $BackgroundEquipmentOptionsTable(this);
  late final $FeatsTable feats = $FeatsTable(this);
  late final $SpeciesTableTable speciesTable = $SpeciesTableTable(this);
  late final $SpeciesTraitsTable speciesTraits = $SpeciesTraitsTable(this);
  late final $ClassesTable classes = $ClassesTable(this);
  late final $ClassLevelsTable classLevels = $ClassLevelsTable(this);
  late final $SubclassesTable subclasses = $SubclassesTable(this);
  late final $SubclassFeaturesTable subclassFeatures = $SubclassFeaturesTable(
    this,
  );
  late final $FeaturesTable features = $FeaturesTable(this);
  late final $SpellsTable spells = $SpellsTable(this);
  late final $SpellClassesTable spellClasses = $SpellClassesTable(this);
  late final $MonstersTable monsters = $MonstersTable(this);
  late final $MonsterActionsTable monsterActions = $MonsterActionsTable(this);
  late final $StudyRevealsTable studyReveals = $StudyRevealsTable(this);
  late final $EffectsTable effects = $EffectsTable(this);
  late final $EntityTextsTable entityTexts = $EntityTextsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    contentSearch,
    contentPacks,
    packDependencies,
    abilities,
    skills,
    languages,
    conditions,
    damageTypes,
    masteryProperties,
    weapons,
    armors,
    tools,
    items,
    backgrounds,
    backgroundAbilities,
    backgroundProficiencies,
    backgroundEquipmentOptions,
    feats,
    speciesTable,
    speciesTraits,
    classes,
    classLevels,
    subclasses,
    subclassFeatures,
    features,
    spells,
    spellClasses,
    monsters,
    monsterActions,
    studyReveals,
    effects,
    entityTexts,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('pack_dependency', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ability', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('skill', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('language', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('condition', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('damage_type', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('mastery_property', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('weapon', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('armor', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tool', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('item', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('background', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('background_ability', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('background_proficiency', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('background_equipment_option', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('feat', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('species', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('species_trait', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('class', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('class_level', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('subclass', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('subclass_feature', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('feature', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('spell', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('spell_class', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('monster', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('monster_action', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('study_reveal', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('effect', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_pack',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('entity_text', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $ContentSearchCreateCompanionBuilder = ContentSearchCompanion Function({
  required String entityId,
  required String type,
  required String packId,
  required String name,
  required String description,
  Value<int> rowid,
});
typedef $ContentSearchUpdateCompanionBuilder = ContentSearchCompanion Function({
  Value<String> entityId,
  Value<String> type,
  Value<String> packId,
  Value<String> name,
  Value<String> description,
  Value<int> rowid,
});

class $ContentSearchFilterComposer
    extends Composer<_$TavernierDatabase, ContentSearch> {
  $ContentSearchFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $ContentSearchOrderingComposer
    extends Composer<_$TavernierDatabase, ContentSearch> {
  $ContentSearchOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $ContentSearchAnnotationComposer
    extends Composer<_$TavernierDatabase, ContentSearch> {
  $ContentSearchAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get packId =>
      $composableBuilder(column: $table.packId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $ContentSearchTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          ContentSearch,
          ContentSearchData,
          $ContentSearchFilterComposer,
          $ContentSearchOrderingComposer,
          $ContentSearchAnnotationComposer,
          $ContentSearchCreateCompanionBuilder,
          $ContentSearchUpdateCompanionBuilder,
          (
            ContentSearchData,
            BaseReferences<
              _$TavernierDatabase,
              ContentSearch,
              ContentSearchData
            >,
          ),
          ContentSearchData,
          PrefetchHooks Function()
        > {
  $ContentSearchTableManager(_$TavernierDatabase db, ContentSearch table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ContentSearchFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ContentSearchOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ContentSearchAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entityId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentSearchCompanion(
                entityId: entityId,
                type: type,
                packId: packId,
                name: name,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entityId,
                required String type,
                required String packId,
                required String name,
                required String description,
                Value<int> rowid = const Value.absent(),
              }) => ContentSearchCompanion.insert(
                entityId: entityId,
                type: type,
                packId: packId,
                name: name,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<ContentSearch, ContentSearchData>(table),
                  BaseReferences<
                    _$TavernierDatabase,
                    ContentSearch,
                    ContentSearchData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $ContentSearchProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      ContentSearch,
      ContentSearchData,
      $ContentSearchFilterComposer,
      $ContentSearchOrderingComposer,
      $ContentSearchAnnotationComposer,
      $ContentSearchCreateCompanionBuilder,
      $ContentSearchUpdateCompanionBuilder,
      (
        ContentSearchData,
        BaseReferences<_$TavernierDatabase, ContentSearch, ContentSearchData>,
      ),
      ContentSearchData,
      PrefetchHooks Function()
    >;
typedef $$ContentPacksTableCreateCompanionBuilder =
    ContentPacksCompanion Function({
      required String id,
      required String namespace,
      required String name,
      required String version,
      required String origin,
      required String author,
      required String licence,
      Value<String?> attribution,
      required int dslVersion,
      required String locale,
      Value<String?> checksum,
      Value<String?> signature,
      Value<int> rowid,
    });
typedef $$ContentPacksTableUpdateCompanionBuilder =
    ContentPacksCompanion Function({
      Value<String> id,
      Value<String> namespace,
      Value<String> name,
      Value<String> version,
      Value<String> origin,
      Value<String> author,
      Value<String> licence,
      Value<String?> attribution,
      Value<int> dslVersion,
      Value<String> locale,
      Value<String?> checksum,
      Value<String?> signature,
      Value<int> rowid,
    });

final class $$ContentPacksTableReferences
    extends
        BaseReferences<
          _$TavernierDatabase,
          $ContentPacksTable,
          ContentPackRow
        > {
  $$ContentPacksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PackDependenciesTable, List<PackDependencyRow>>
  _packDependenciesRefsTable(_$TavernierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.packDependencies,
        aliasName: 'content_pack__id__pack_dependency__pack_id',
      );

  $$PackDependenciesTableProcessedTableManager get packDependenciesRefs {
    final manager = $$PackDependenciesTableTableManager(
      $_db,
      $_db.packDependencies,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _packDependenciesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AbilitiesTable, List<AbilityRow>>
  _abilitiesRefsTable(_$TavernierDatabase db) => MultiTypedResultKey.fromTable(
    db.abilities,
    aliasName: 'content_pack__id__ability__pack_id',
  );

  $$AbilitiesTableProcessedTableManager get abilitiesRefs {
    final manager = $$AbilitiesTableTableManager(
      $_db,
      $_db.abilities,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_abilitiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SkillsTable, List<SkillRow>> _skillsRefsTable(
    _$TavernierDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.skills,
    aliasName: 'content_pack__id__skill__pack_id',
  );

  $$SkillsTableProcessedTableManager get skillsRefs {
    final manager = $$SkillsTableTableManager(
      $_db,
      $_db.skills,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_skillsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LanguagesTable, List<LanguageRow>>
  _languagesRefsTable(_$TavernierDatabase db) => MultiTypedResultKey.fromTable(
    db.languages,
    aliasName: 'content_pack__id__language__pack_id',
  );

  $$LanguagesTableProcessedTableManager get languagesRefs {
    final manager = $$LanguagesTableTableManager(
      $_db,
      $_db.languages,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_languagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ConditionsTable, List<ConditionRow>>
  _conditionsRefsTable(_$TavernierDatabase db) => MultiTypedResultKey.fromTable(
    db.conditions,
    aliasName: 'content_pack__id__condition__pack_id',
  );

  $$ConditionsTableProcessedTableManager get conditionsRefs {
    final manager = $$ConditionsTableTableManager(
      $_db,
      $_db.conditions,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_conditionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DamageTypesTable, List<DamageTypeRow>>
  _damageTypesRefsTable(_$TavernierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.damageTypes,
        aliasName: 'content_pack__id__damage_type__pack_id',
      );

  $$DamageTypesTableProcessedTableManager get damageTypesRefs {
    final manager = $$DamageTypesTableTableManager(
      $_db,
      $_db.damageTypes,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_damageTypesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MasteryPropertiesTable, List<MasteryPropertyRow>>
  _masteryPropertiesRefsTable(_$TavernierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.masteryProperties,
        aliasName: 'content_pack__id__mastery_property__pack_id',
      );

  $$MasteryPropertiesTableProcessedTableManager get masteryPropertiesRefs {
    final manager = $$MasteryPropertiesTableTableManager(
      $_db,
      $_db.masteryProperties,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _masteryPropertiesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WeaponsTable, List<WeaponRow>> _weaponsRefsTable(
    _$TavernierDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.weapons,
    aliasName: 'content_pack__id__weapon__pack_id',
  );

  $$WeaponsTableProcessedTableManager get weaponsRefs {
    final manager = $$WeaponsTableTableManager(
      $_db,
      $_db.weapons,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_weaponsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ArmorsTable, List<ArmorRow>> _armorsRefsTable(
    _$TavernierDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.armors,
    aliasName: 'content_pack__id__armor__pack_id',
  );

  $$ArmorsTableProcessedTableManager get armorsRefs {
    final manager = $$ArmorsTableTableManager(
      $_db,
      $_db.armors,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_armorsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ToolsTable, List<ToolRow>> _toolsRefsTable(
    _$TavernierDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tools,
    aliasName: 'content_pack__id__tool__pack_id',
  );

  $$ToolsTableProcessedTableManager get toolsRefs {
    final manager = $$ToolsTableTableManager(
      $_db,
      $_db.tools,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_toolsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ItemsTable, List<ItemRow>> _itemsRefsTable(
    _$TavernierDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.items,
    aliasName: 'content_pack__id__item__pack_id',
  );

  $$ItemsTableProcessedTableManager get itemsRefs {
    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BackgroundsTable, List<BackgroundRow>>
  _backgroundsRefsTable(_$TavernierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.backgrounds,
        aliasName: 'content_pack__id__background__pack_id',
      );

  $$BackgroundsTableProcessedTableManager get backgroundsRefs {
    final manager = $$BackgroundsTableTableManager(
      $_db,
      $_db.backgrounds,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_backgroundsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $BackgroundAbilitiesTable,
    List<BackgroundAbilityRow>
  >
  _backgroundAbilitiesRefsTable(_$TavernierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.backgroundAbilities,
        aliasName: 'content_pack__id__background_ability__pack_id',
      );

  $$BackgroundAbilitiesTableProcessedTableManager get backgroundAbilitiesRefs {
    final manager = $$BackgroundAbilitiesTableTableManager(
      $_db,
      $_db.backgroundAbilities,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _backgroundAbilitiesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $BackgroundProficienciesTable,
    List<BackgroundProficiencyRow>
  >
  _backgroundProficienciesRefsTable(_$TavernierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.backgroundProficiencies,
        aliasName: 'content_pack__id__background_proficiency__pack_id',
      );

  $$BackgroundProficienciesTableProcessedTableManager
  get backgroundProficienciesRefs {
    final manager = $$BackgroundProficienciesTableTableManager(
      $_db,
      $_db.backgroundProficiencies,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _backgroundProficienciesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $BackgroundEquipmentOptionsTable,
    List<BackgroundEquipmentOptionRow>
  >
  _backgroundEquipmentOptionsRefsTable(_$TavernierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.backgroundEquipmentOptions,
        aliasName: 'content_pack__id__background_equipment_option__pack_id',
      );

  $$BackgroundEquipmentOptionsTableProcessedTableManager
  get backgroundEquipmentOptionsRefs {
    final manager = $$BackgroundEquipmentOptionsTableTableManager(
      $_db,
      $_db.backgroundEquipmentOptions,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _backgroundEquipmentOptionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FeatsTable, List<FeatRow>> _featsRefsTable(
    _$TavernierDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.feats,
    aliasName: 'content_pack__id__feat__pack_id',
  );

  $$FeatsTableProcessedTableManager get featsRefs {
    final manager = $$FeatsTableTableManager(
      $_db,
      $_db.feats,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_featsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SpeciesTableTable, List<SpeciesRow>>
  _speciesTableRefsTable(_$TavernierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.speciesTable,
        aliasName: 'content_pack__id__species__pack_id',
      );

  $$SpeciesTableTableProcessedTableManager get speciesTableRefs {
    final manager = $$SpeciesTableTableTableManager(
      $_db,
      $_db.speciesTable,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_speciesTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SpeciesTraitsTable, List<SpeciesTraitRow>>
  _speciesTraitsRefsTable(_$TavernierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.speciesTraits,
        aliasName: 'content_pack__id__species_trait__pack_id',
      );

  $$SpeciesTraitsTableProcessedTableManager get speciesTraitsRefs {
    final manager = $$SpeciesTraitsTableTableManager(
      $_db,
      $_db.speciesTraits,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_speciesTraitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ClassesTable, List<ClassRow>> _classesRefsTable(
    _$TavernierDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.classes,
    aliasName: 'content_pack__id__class__pack_id',
  );

  $$ClassesTableProcessedTableManager get classesRefs {
    final manager = $$ClassesTableTableManager(
      $_db,
      $_db.classes,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_classesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ClassLevelsTable, List<ClassLevelRow>>
  _classLevelsRefsTable(_$TavernierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.classLevels,
        aliasName: 'content_pack__id__class_level__pack_id',
      );

  $$ClassLevelsTableProcessedTableManager get classLevelsRefs {
    final manager = $$ClassLevelsTableTableManager(
      $_db,
      $_db.classLevels,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_classLevelsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SubclassesTable, List<SubclassRow>>
  _subclassesRefsTable(_$TavernierDatabase db) => MultiTypedResultKey.fromTable(
    db.subclasses,
    aliasName: 'content_pack__id__subclass__pack_id',
  );

  $$SubclassesTableProcessedTableManager get subclassesRefs {
    final manager = $$SubclassesTableTableManager(
      $_db,
      $_db.subclasses,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_subclassesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SubclassFeaturesTable, List<SubclassFeatureRow>>
  _subclassFeaturesRefsTable(_$TavernierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.subclassFeatures,
        aliasName: 'content_pack__id__subclass_feature__pack_id',
      );

  $$SubclassFeaturesTableProcessedTableManager get subclassFeaturesRefs {
    final manager = $$SubclassFeaturesTableTableManager(
      $_db,
      $_db.subclassFeatures,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _subclassFeaturesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FeaturesTable, List<FeatureRow>>
  _featuresRefsTable(_$TavernierDatabase db) => MultiTypedResultKey.fromTable(
    db.features,
    aliasName: 'content_pack__id__feature__pack_id',
  );

  $$FeaturesTableProcessedTableManager get featuresRefs {
    final manager = $$FeaturesTableTableManager(
      $_db,
      $_db.features,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_featuresRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SpellsTable, List<SpellRow>> _spellsRefsTable(
    _$TavernierDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.spells,
    aliasName: 'content_pack__id__spell__pack_id',
  );

  $$SpellsTableProcessedTableManager get spellsRefs {
    final manager = $$SpellsTableTableManager(
      $_db,
      $_db.spells,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_spellsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SpellClassesTable, List<SpellClassRow>>
  _spellClassesRefsTable(_$TavernierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.spellClasses,
        aliasName: 'content_pack__id__spell_class__pack_id',
      );

  $$SpellClassesTableProcessedTableManager get spellClassesRefs {
    final manager = $$SpellClassesTableTableManager(
      $_db,
      $_db.spellClasses,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_spellClassesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MonstersTable, List<MonsterRow>>
  _monstersRefsTable(_$TavernierDatabase db) => MultiTypedResultKey.fromTable(
    db.monsters,
    aliasName: 'content_pack__id__monster__pack_id',
  );

  $$MonstersTableProcessedTableManager get monstersRefs {
    final manager = $$MonstersTableTableManager(
      $_db,
      $_db.monsters,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_monstersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MonsterActionsTable, List<MonsterActionRow>>
  _monsterActionsRefsTable(_$TavernierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.monsterActions,
        aliasName: 'content_pack__id__monster_action__pack_id',
      );

  $$MonsterActionsTableProcessedTableManager get monsterActionsRefs {
    final manager = $$MonsterActionsTableTableManager(
      $_db,
      $_db.monsterActions,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_monsterActionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StudyRevealsTable, List<StudyRevealRow>>
  _studyRevealsRefsTable(_$TavernierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.studyReveals,
        aliasName: 'content_pack__id__study_reveal__pack_id',
      );

  $$StudyRevealsTableProcessedTableManager get studyRevealsRefs {
    final manager = $$StudyRevealsTableTableManager(
      $_db,
      $_db.studyReveals,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_studyRevealsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EffectsTable, List<EffectRow>> _effectsRefsTable(
    _$TavernierDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.effects,
    aliasName: 'content_pack__id__effect__pack_id',
  );

  $$EffectsTableProcessedTableManager get effectsRefs {
    final manager = $$EffectsTableTableManager(
      $_db,
      $_db.effects,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_effectsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EntityTextsTable, List<EntityTextRow>>
  _entityTextsRefsTable(_$TavernierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.entityTexts,
        aliasName: 'content_pack__id__entity_text__pack_id',
      );

  $$EntityTextsTableProcessedTableManager get entityTextsRefs {
    final manager = $$EntityTextsTableTableManager(
      $_db,
      $_db.entityTexts,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_entityTextsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ContentPacksTableFilterComposer
    extends Composer<_$TavernierDatabase, $ContentPacksTable> {
  $$ContentPacksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get namespace => $composableBuilder(
    column: $table.namespace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get licence => $composableBuilder(
    column: $table.licence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attribution => $composableBuilder(
    column: $table.attribution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dslVersion => $composableBuilder(
    column: $table.dslVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checksum => $composableBuilder(
    column: $table.checksum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signature => $composableBuilder(
    column: $table.signature,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> packDependenciesRefs(
    Expression<bool> Function($$PackDependenciesTableFilterComposer f) f,
  ) {
    final $$PackDependenciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.packDependencies,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackDependenciesTableFilterComposer(
            $db: $db,
            $table: $db.packDependencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> abilitiesRefs(
    Expression<bool> Function($$AbilitiesTableFilterComposer f) f,
  ) {
    final $$AbilitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.abilities,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AbilitiesTableFilterComposer(
            $db: $db,
            $table: $db.abilities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> skillsRefs(
    Expression<bool> Function($$SkillsTableFilterComposer f) f,
  ) {
    final $$SkillsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.skills,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SkillsTableFilterComposer(
            $db: $db,
            $table: $db.skills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> languagesRefs(
    Expression<bool> Function($$LanguagesTableFilterComposer f) f,
  ) {
    final $$LanguagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.languages,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LanguagesTableFilterComposer(
            $db: $db,
            $table: $db.languages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> conditionsRefs(
    Expression<bool> Function($$ConditionsTableFilterComposer f) f,
  ) {
    final $$ConditionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.conditions,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConditionsTableFilterComposer(
            $db: $db,
            $table: $db.conditions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> damageTypesRefs(
    Expression<bool> Function($$DamageTypesTableFilterComposer f) f,
  ) {
    final $$DamageTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.damageTypes,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DamageTypesTableFilterComposer(
            $db: $db,
            $table: $db.damageTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> masteryPropertiesRefs(
    Expression<bool> Function($$MasteryPropertiesTableFilterComposer f) f,
  ) {
    final $$MasteryPropertiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.masteryProperties,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MasteryPropertiesTableFilterComposer(
            $db: $db,
            $table: $db.masteryProperties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> weaponsRefs(
    Expression<bool> Function($$WeaponsTableFilterComposer f) f,
  ) {
    final $$WeaponsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weapons,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeaponsTableFilterComposer(
            $db: $db,
            $table: $db.weapons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> armorsRefs(
    Expression<bool> Function($$ArmorsTableFilterComposer f) f,
  ) {
    final $$ArmorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.armors,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArmorsTableFilterComposer(
            $db: $db,
            $table: $db.armors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> toolsRefs(
    Expression<bool> Function($$ToolsTableFilterComposer f) f,
  ) {
    final $$ToolsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tools,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ToolsTableFilterComposer(
            $db: $db,
            $table: $db.tools,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> itemsRefs(
    Expression<bool> Function($$ItemsTableFilterComposer f) f,
  ) {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> backgroundsRefs(
    Expression<bool> Function($$BackgroundsTableFilterComposer f) f,
  ) {
    final $$BackgroundsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.backgrounds,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BackgroundsTableFilterComposer(
            $db: $db,
            $table: $db.backgrounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> backgroundAbilitiesRefs(
    Expression<bool> Function($$BackgroundAbilitiesTableFilterComposer f) f,
  ) {
    final $$BackgroundAbilitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.backgroundAbilities,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BackgroundAbilitiesTableFilterComposer(
            $db: $db,
            $table: $db.backgroundAbilities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> backgroundProficienciesRefs(
    Expression<bool> Function($$BackgroundProficienciesTableFilterComposer f) f,
  ) {
    final $$BackgroundProficienciesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.backgroundProficiencies,
          getReferencedColumn: (t) => t.packId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BackgroundProficienciesTableFilterComposer(
                $db: $db,
                $table: $db.backgroundProficiencies,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> backgroundEquipmentOptionsRefs(
    Expression<bool> Function($$BackgroundEquipmentOptionsTableFilterComposer f)
    f,
  ) {
    final $$BackgroundEquipmentOptionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.backgroundEquipmentOptions,
          getReferencedColumn: (t) => t.packId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BackgroundEquipmentOptionsTableFilterComposer(
                $db: $db,
                $table: $db.backgroundEquipmentOptions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> featsRefs(
    Expression<bool> Function($$FeatsTableFilterComposer f) f,
  ) {
    final $$FeatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.feats,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeatsTableFilterComposer(
            $db: $db,
            $table: $db.feats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> speciesTableRefs(
    Expression<bool> Function($$SpeciesTableTableFilterComposer f) f,
  ) {
    final $$SpeciesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.speciesTable,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesTableTableFilterComposer(
            $db: $db,
            $table: $db.speciesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> speciesTraitsRefs(
    Expression<bool> Function($$SpeciesTraitsTableFilterComposer f) f,
  ) {
    final $$SpeciesTraitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.speciesTraits,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesTraitsTableFilterComposer(
            $db: $db,
            $table: $db.speciesTraits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> classesRefs(
    Expression<bool> Function($$ClassesTableFilterComposer f) f,
  ) {
    final $$ClassesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classes,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassesTableFilterComposer(
            $db: $db,
            $table: $db.classes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> classLevelsRefs(
    Expression<bool> Function($$ClassLevelsTableFilterComposer f) f,
  ) {
    final $$ClassLevelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classLevels,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassLevelsTableFilterComposer(
            $db: $db,
            $table: $db.classLevels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> subclassesRefs(
    Expression<bool> Function($$SubclassesTableFilterComposer f) f,
  ) {
    final $$SubclassesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subclasses,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubclassesTableFilterComposer(
            $db: $db,
            $table: $db.subclasses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> subclassFeaturesRefs(
    Expression<bool> Function($$SubclassFeaturesTableFilterComposer f) f,
  ) {
    final $$SubclassFeaturesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subclassFeatures,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubclassFeaturesTableFilterComposer(
            $db: $db,
            $table: $db.subclassFeatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> featuresRefs(
    Expression<bool> Function($$FeaturesTableFilterComposer f) f,
  ) {
    final $$FeaturesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.features,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeaturesTableFilterComposer(
            $db: $db,
            $table: $db.features,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> spellsRefs(
    Expression<bool> Function($$SpellsTableFilterComposer f) f,
  ) {
    final $$SpellsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.spells,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpellsTableFilterComposer(
            $db: $db,
            $table: $db.spells,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> spellClassesRefs(
    Expression<bool> Function($$SpellClassesTableFilterComposer f) f,
  ) {
    final $$SpellClassesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.spellClasses,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpellClassesTableFilterComposer(
            $db: $db,
            $table: $db.spellClasses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> monstersRefs(
    Expression<bool> Function($$MonstersTableFilterComposer f) f,
  ) {
    final $$MonstersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.monsters,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonstersTableFilterComposer(
            $db: $db,
            $table: $db.monsters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> monsterActionsRefs(
    Expression<bool> Function($$MonsterActionsTableFilterComposer f) f,
  ) {
    final $$MonsterActionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.monsterActions,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonsterActionsTableFilterComposer(
            $db: $db,
            $table: $db.monsterActions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> studyRevealsRefs(
    Expression<bool> Function($$StudyRevealsTableFilterComposer f) f,
  ) {
    final $$StudyRevealsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyReveals,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyRevealsTableFilterComposer(
            $db: $db,
            $table: $db.studyReveals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> effectsRefs(
    Expression<bool> Function($$EffectsTableFilterComposer f) f,
  ) {
    final $$EffectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.effects,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EffectsTableFilterComposer(
            $db: $db,
            $table: $db.effects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> entityTextsRefs(
    Expression<bool> Function($$EntityTextsTableFilterComposer f) f,
  ) {
    final $$EntityTextsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entityTexts,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntityTextsTableFilterComposer(
            $db: $db,
            $table: $db.entityTexts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ContentPacksTableOrderingComposer
    extends Composer<_$TavernierDatabase, $ContentPacksTable> {
  $$ContentPacksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get namespace => $composableBuilder(
    column: $table.namespace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get licence => $composableBuilder(
    column: $table.licence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attribution => $composableBuilder(
    column: $table.attribution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dslVersion => $composableBuilder(
    column: $table.dslVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checksum => $composableBuilder(
    column: $table.checksum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signature => $composableBuilder(
    column: $table.signature,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentPacksTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $ContentPacksTable> {
  $$ContentPacksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get namespace =>
      $composableBuilder(column: $table.namespace, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get licence =>
      $composableBuilder(column: $table.licence, builder: (column) => column);

  GeneratedColumn<String> get attribution => $composableBuilder(
    column: $table.attribution,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dslVersion => $composableBuilder(
    column: $table.dslVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get checksum =>
      $composableBuilder(column: $table.checksum, builder: (column) => column);

  GeneratedColumn<String> get signature =>
      $composableBuilder(column: $table.signature, builder: (column) => column);

  Expression<T> packDependenciesRefs<T extends Object>(
    Expression<T> Function($$PackDependenciesTableAnnotationComposer a) f,
  ) {
    final $$PackDependenciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.packDependencies,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackDependenciesTableAnnotationComposer(
            $db: $db,
            $table: $db.packDependencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> abilitiesRefs<T extends Object>(
    Expression<T> Function($$AbilitiesTableAnnotationComposer a) f,
  ) {
    final $$AbilitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.abilities,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AbilitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.abilities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> skillsRefs<T extends Object>(
    Expression<T> Function($$SkillsTableAnnotationComposer a) f,
  ) {
    final $$SkillsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.skills,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SkillsTableAnnotationComposer(
            $db: $db,
            $table: $db.skills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> languagesRefs<T extends Object>(
    Expression<T> Function($$LanguagesTableAnnotationComposer a) f,
  ) {
    final $$LanguagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.languages,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LanguagesTableAnnotationComposer(
            $db: $db,
            $table: $db.languages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> conditionsRefs<T extends Object>(
    Expression<T> Function($$ConditionsTableAnnotationComposer a) f,
  ) {
    final $$ConditionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.conditions,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConditionsTableAnnotationComposer(
            $db: $db,
            $table: $db.conditions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> damageTypesRefs<T extends Object>(
    Expression<T> Function($$DamageTypesTableAnnotationComposer a) f,
  ) {
    final $$DamageTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.damageTypes,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DamageTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.damageTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> masteryPropertiesRefs<T extends Object>(
    Expression<T> Function($$MasteryPropertiesTableAnnotationComposer a) f,
  ) {
    final $$MasteryPropertiesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.masteryProperties,
          getReferencedColumn: (t) => t.packId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MasteryPropertiesTableAnnotationComposer(
                $db: $db,
                $table: $db.masteryProperties,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> weaponsRefs<T extends Object>(
    Expression<T> Function($$WeaponsTableAnnotationComposer a) f,
  ) {
    final $$WeaponsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weapons,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeaponsTableAnnotationComposer(
            $db: $db,
            $table: $db.weapons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> armorsRefs<T extends Object>(
    Expression<T> Function($$ArmorsTableAnnotationComposer a) f,
  ) {
    final $$ArmorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.armors,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArmorsTableAnnotationComposer(
            $db: $db,
            $table: $db.armors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> toolsRefs<T extends Object>(
    Expression<T> Function($$ToolsTableAnnotationComposer a) f,
  ) {
    final $$ToolsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tools,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ToolsTableAnnotationComposer(
            $db: $db,
            $table: $db.tools,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> itemsRefs<T extends Object>(
    Expression<T> Function($$ItemsTableAnnotationComposer a) f,
  ) {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> backgroundsRefs<T extends Object>(
    Expression<T> Function($$BackgroundsTableAnnotationComposer a) f,
  ) {
    final $$BackgroundsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.backgrounds,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BackgroundsTableAnnotationComposer(
            $db: $db,
            $table: $db.backgrounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> backgroundAbilitiesRefs<T extends Object>(
    Expression<T> Function($$BackgroundAbilitiesTableAnnotationComposer a) f,
  ) {
    final $$BackgroundAbilitiesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.backgroundAbilities,
          getReferencedColumn: (t) => t.packId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BackgroundAbilitiesTableAnnotationComposer(
                $db: $db,
                $table: $db.backgroundAbilities,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> backgroundProficienciesRefs<T extends Object>(
    Expression<T> Function($$BackgroundProficienciesTableAnnotationComposer a)
    f,
  ) {
    final $$BackgroundProficienciesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.backgroundProficiencies,
          getReferencedColumn: (t) => t.packId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BackgroundProficienciesTableAnnotationComposer(
                $db: $db,
                $table: $db.backgroundProficiencies,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> backgroundEquipmentOptionsRefs<T extends Object>(
    Expression<T> Function(
      $$BackgroundEquipmentOptionsTableAnnotationComposer a,
    )
    f,
  ) {
    final $$BackgroundEquipmentOptionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.backgroundEquipmentOptions,
          getReferencedColumn: (t) => t.packId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BackgroundEquipmentOptionsTableAnnotationComposer(
                $db: $db,
                $table: $db.backgroundEquipmentOptions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> featsRefs<T extends Object>(
    Expression<T> Function($$FeatsTableAnnotationComposer a) f,
  ) {
    final $$FeatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.feats,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeatsTableAnnotationComposer(
            $db: $db,
            $table: $db.feats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> speciesTableRefs<T extends Object>(
    Expression<T> Function($$SpeciesTableTableAnnotationComposer a) f,
  ) {
    final $$SpeciesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.speciesTable,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.speciesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> speciesTraitsRefs<T extends Object>(
    Expression<T> Function($$SpeciesTraitsTableAnnotationComposer a) f,
  ) {
    final $$SpeciesTraitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.speciesTraits,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesTraitsTableAnnotationComposer(
            $db: $db,
            $table: $db.speciesTraits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> classesRefs<T extends Object>(
    Expression<T> Function($$ClassesTableAnnotationComposer a) f,
  ) {
    final $$ClassesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classes,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassesTableAnnotationComposer(
            $db: $db,
            $table: $db.classes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> classLevelsRefs<T extends Object>(
    Expression<T> Function($$ClassLevelsTableAnnotationComposer a) f,
  ) {
    final $$ClassLevelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classLevels,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassLevelsTableAnnotationComposer(
            $db: $db,
            $table: $db.classLevels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> subclassesRefs<T extends Object>(
    Expression<T> Function($$SubclassesTableAnnotationComposer a) f,
  ) {
    final $$SubclassesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subclasses,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubclassesTableAnnotationComposer(
            $db: $db,
            $table: $db.subclasses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> subclassFeaturesRefs<T extends Object>(
    Expression<T> Function($$SubclassFeaturesTableAnnotationComposer a) f,
  ) {
    final $$SubclassFeaturesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subclassFeatures,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubclassFeaturesTableAnnotationComposer(
            $db: $db,
            $table: $db.subclassFeatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> featuresRefs<T extends Object>(
    Expression<T> Function($$FeaturesTableAnnotationComposer a) f,
  ) {
    final $$FeaturesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.features,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeaturesTableAnnotationComposer(
            $db: $db,
            $table: $db.features,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> spellsRefs<T extends Object>(
    Expression<T> Function($$SpellsTableAnnotationComposer a) f,
  ) {
    final $$SpellsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.spells,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpellsTableAnnotationComposer(
            $db: $db,
            $table: $db.spells,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> spellClassesRefs<T extends Object>(
    Expression<T> Function($$SpellClassesTableAnnotationComposer a) f,
  ) {
    final $$SpellClassesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.spellClasses,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpellClassesTableAnnotationComposer(
            $db: $db,
            $table: $db.spellClasses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> monstersRefs<T extends Object>(
    Expression<T> Function($$MonstersTableAnnotationComposer a) f,
  ) {
    final $$MonstersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.monsters,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonstersTableAnnotationComposer(
            $db: $db,
            $table: $db.monsters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> monsterActionsRefs<T extends Object>(
    Expression<T> Function($$MonsterActionsTableAnnotationComposer a) f,
  ) {
    final $$MonsterActionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.monsterActions,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonsterActionsTableAnnotationComposer(
            $db: $db,
            $table: $db.monsterActions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> studyRevealsRefs<T extends Object>(
    Expression<T> Function($$StudyRevealsTableAnnotationComposer a) f,
  ) {
    final $$StudyRevealsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyReveals,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyRevealsTableAnnotationComposer(
            $db: $db,
            $table: $db.studyReveals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> effectsRefs<T extends Object>(
    Expression<T> Function($$EffectsTableAnnotationComposer a) f,
  ) {
    final $$EffectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.effects,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EffectsTableAnnotationComposer(
            $db: $db,
            $table: $db.effects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> entityTextsRefs<T extends Object>(
    Expression<T> Function($$EntityTextsTableAnnotationComposer a) f,
  ) {
    final $$EntityTextsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entityTexts,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntityTextsTableAnnotationComposer(
            $db: $db,
            $table: $db.entityTexts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ContentPacksTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $ContentPacksTable,
          ContentPackRow,
          $$ContentPacksTableFilterComposer,
          $$ContentPacksTableOrderingComposer,
          $$ContentPacksTableAnnotationComposer,
          $$ContentPacksTableCreateCompanionBuilder,
          $$ContentPacksTableUpdateCompanionBuilder,
          (ContentPackRow, $$ContentPacksTableReferences),
          ContentPackRow,
          PrefetchHooks Function({
            bool packDependenciesRefs,
            bool abilitiesRefs,
            bool skillsRefs,
            bool languagesRefs,
            bool conditionsRefs,
            bool damageTypesRefs,
            bool masteryPropertiesRefs,
            bool weaponsRefs,
            bool armorsRefs,
            bool toolsRefs,
            bool itemsRefs,
            bool backgroundsRefs,
            bool backgroundAbilitiesRefs,
            bool backgroundProficienciesRefs,
            bool backgroundEquipmentOptionsRefs,
            bool featsRefs,
            bool speciesTableRefs,
            bool speciesTraitsRefs,
            bool classesRefs,
            bool classLevelsRefs,
            bool subclassesRefs,
            bool subclassFeaturesRefs,
            bool featuresRefs,
            bool spellsRefs,
            bool spellClassesRefs,
            bool monstersRefs,
            bool monsterActionsRefs,
            bool studyRevealsRefs,
            bool effectsRefs,
            bool entityTextsRefs,
          })
        > {
  $$ContentPacksTableTableManager(
    _$TavernierDatabase db,
    $ContentPacksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentPacksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentPacksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentPacksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> namespace = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<String> origin = const Value.absent(),
                Value<String> author = const Value.absent(),
                Value<String> licence = const Value.absent(),
                Value<String?> attribution = const Value.absent(),
                Value<int> dslVersion = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String?> checksum = const Value.absent(),
                Value<String?> signature = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentPacksCompanion(
                id: id,
                namespace: namespace,
                name: name,
                version: version,
                origin: origin,
                author: author,
                licence: licence,
                attribution: attribution,
                dslVersion: dslVersion,
                locale: locale,
                checksum: checksum,
                signature: signature,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String namespace,
                required String name,
                required String version,
                required String origin,
                required String author,
                required String licence,
                Value<String?> attribution = const Value.absent(),
                required int dslVersion,
                required String locale,
                Value<String?> checksum = const Value.absent(),
                Value<String?> signature = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentPacksCompanion.insert(
                id: id,
                namespace: namespace,
                name: name,
                version: version,
                origin: origin,
                author: author,
                licence: licence,
                attribution: attribution,
                dslVersion: dslVersion,
                locale: locale,
                checksum: checksum,
                signature: signature,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContentPacksTable, ContentPackRow>(table),
                  $$ContentPacksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                packDependenciesRefs = false,
                abilitiesRefs = false,
                skillsRefs = false,
                languagesRefs = false,
                conditionsRefs = false,
                damageTypesRefs = false,
                masteryPropertiesRefs = false,
                weaponsRefs = false,
                armorsRefs = false,
                toolsRefs = false,
                itemsRefs = false,
                backgroundsRefs = false,
                backgroundAbilitiesRefs = false,
                backgroundProficienciesRefs = false,
                backgroundEquipmentOptionsRefs = false,
                featsRefs = false,
                speciesTableRefs = false,
                speciesTraitsRefs = false,
                classesRefs = false,
                classLevelsRefs = false,
                subclassesRefs = false,
                subclassFeaturesRefs = false,
                featuresRefs = false,
                spellsRefs = false,
                spellClassesRefs = false,
                monstersRefs = false,
                monsterActionsRefs = false,
                studyRevealsRefs = false,
                effectsRefs = false,
                entityTextsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (packDependenciesRefs) db.packDependencies,
                    if (abilitiesRefs) db.abilities,
                    if (skillsRefs) db.skills,
                    if (languagesRefs) db.languages,
                    if (conditionsRefs) db.conditions,
                    if (damageTypesRefs) db.damageTypes,
                    if (masteryPropertiesRefs) db.masteryProperties,
                    if (weaponsRefs) db.weapons,
                    if (armorsRefs) db.armors,
                    if (toolsRefs) db.tools,
                    if (itemsRefs) db.items,
                    if (backgroundsRefs) db.backgrounds,
                    if (backgroundAbilitiesRefs) db.backgroundAbilities,
                    if (backgroundProficienciesRefs) db.backgroundProficiencies,
                    if (backgroundEquipmentOptionsRefs)
                      db.backgroundEquipmentOptions,
                    if (featsRefs) db.feats,
                    if (speciesTableRefs) db.speciesTable,
                    if (speciesTraitsRefs) db.speciesTraits,
                    if (classesRefs) db.classes,
                    if (classLevelsRefs) db.classLevels,
                    if (subclassesRefs) db.subclasses,
                    if (subclassFeaturesRefs) db.subclassFeatures,
                    if (featuresRefs) db.features,
                    if (spellsRefs) db.spells,
                    if (spellClassesRefs) db.spellClasses,
                    if (monstersRefs) db.monsters,
                    if (monsterActionsRefs) db.monsterActions,
                    if (studyRevealsRefs) db.studyReveals,
                    if (effectsRefs) db.effects,
                    if (entityTextsRefs) db.entityTexts,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (packDependenciesRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          PackDependencyRow,
                          $PackDependenciesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._packDependenciesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).packDependenciesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (abilitiesRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          AbilityRow,
                          $AbilitiesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._abilitiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).abilitiesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (skillsRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          SkillRow,
                          $SkillsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._skillsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).skillsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (languagesRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          LanguageRow,
                          $LanguagesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._languagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).languagesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (conditionsRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          ConditionRow,
                          $ConditionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._conditionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).conditionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (damageTypesRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          DamageTypeRow,
                          $DamageTypesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._damageTypesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).damageTypesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (masteryPropertiesRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          MasteryPropertyRow,
                          $MasteryPropertiesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._masteryPropertiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).masteryPropertiesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (weaponsRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          WeaponRow,
                          $WeaponsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._weaponsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).weaponsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (armorsRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          ArmorRow,
                          $ArmorsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._armorsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).armorsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (toolsRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          ToolRow,
                          $ToolsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._toolsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).toolsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (itemsRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          ItemRow,
                          $ItemsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._itemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).itemsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (backgroundsRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          BackgroundRow,
                          $BackgroundsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._backgroundsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).backgroundsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (backgroundAbilitiesRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          BackgroundAbilityRow,
                          $BackgroundAbilitiesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._backgroundAbilitiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).backgroundAbilitiesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (backgroundProficienciesRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          BackgroundProficiencyRow,
                          $BackgroundProficienciesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._backgroundProficienciesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).backgroundProficienciesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (backgroundEquipmentOptionsRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          BackgroundEquipmentOptionRow,
                          $BackgroundEquipmentOptionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._backgroundEquipmentOptionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).backgroundEquipmentOptionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (featsRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          FeatRow,
                          $FeatsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._featsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).featsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (speciesTableRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          SpeciesRow,
                          $SpeciesTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._speciesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).speciesTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (speciesTraitsRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          SpeciesTraitRow,
                          $SpeciesTraitsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._speciesTraitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).speciesTraitsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (classesRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          ClassRow,
                          $ClassesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._classesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).classesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (classLevelsRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          ClassLevelRow,
                          $ClassLevelsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._classLevelsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).classLevelsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (subclassesRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          SubclassRow,
                          $SubclassesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._subclassesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).subclassesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (subclassFeaturesRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          SubclassFeatureRow,
                          $SubclassFeaturesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._subclassFeaturesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).subclassFeaturesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (featuresRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          FeatureRow,
                          $FeaturesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._featuresRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).featuresRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (spellsRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          SpellRow,
                          $SpellsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._spellsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).spellsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (spellClassesRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          SpellClassRow,
                          $SpellClassesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._spellClassesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).spellClassesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (monstersRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          MonsterRow,
                          $MonstersTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._monstersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).monstersRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (monsterActionsRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          MonsterActionRow,
                          $MonsterActionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._monsterActionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).monsterActionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (studyRevealsRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          StudyRevealRow,
                          $StudyRevealsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._studyRevealsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).studyRevealsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (effectsRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          EffectRow,
                          $EffectsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._effectsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).effectsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                      if (entityTextsRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentPackRow,
                          $ContentPacksTable,
                          EntityTextRow,
                          $EntityTextsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._entityTextsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).entityTextsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pack_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ContentPacksTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $ContentPacksTable,
      ContentPackRow,
      $$ContentPacksTableFilterComposer,
      $$ContentPacksTableOrderingComposer,
      $$ContentPacksTableAnnotationComposer,
      $$ContentPacksTableCreateCompanionBuilder,
      $$ContentPacksTableUpdateCompanionBuilder,
      (ContentPackRow, $$ContentPacksTableReferences),
      ContentPackRow,
      PrefetchHooks Function({
        bool packDependenciesRefs,
        bool abilitiesRefs,
        bool skillsRefs,
        bool languagesRefs,
        bool conditionsRefs,
        bool damageTypesRefs,
        bool masteryPropertiesRefs,
        bool weaponsRefs,
        bool armorsRefs,
        bool toolsRefs,
        bool itemsRefs,
        bool backgroundsRefs,
        bool backgroundAbilitiesRefs,
        bool backgroundProficienciesRefs,
        bool backgroundEquipmentOptionsRefs,
        bool featsRefs,
        bool speciesTableRefs,
        bool speciesTraitsRefs,
        bool classesRefs,
        bool classLevelsRefs,
        bool subclassesRefs,
        bool subclassFeaturesRefs,
        bool featuresRefs,
        bool spellsRefs,
        bool spellClassesRefs,
        bool monstersRefs,
        bool monsterActionsRefs,
        bool studyRevealsRefs,
        bool effectsRefs,
        bool entityTextsRefs,
      })
    >;
typedef $$PackDependenciesTableCreateCompanionBuilder =
    PackDependenciesCompanion Function({
      required String packId,
      required String dependsOnPackId,
      required String versionRange,
      Value<int> rowid,
    });
typedef $$PackDependenciesTableUpdateCompanionBuilder =
    PackDependenciesCompanion Function({
      Value<String> packId,
      Value<String> dependsOnPackId,
      Value<String> versionRange,
      Value<int> rowid,
    });

final class $$PackDependenciesTableReferences
    extends
        BaseReferences<
          _$TavernierDatabase,
          $PackDependenciesTable,
          PackDependencyRow
        > {
  $$PackDependenciesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('pack_dependency__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PackDependenciesTableFilterComposer
    extends Composer<_$TavernierDatabase, $PackDependenciesTable> {
  $$PackDependenciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dependsOnPackId => $composableBuilder(
    column: $table.dependsOnPackId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get versionRange => $composableBuilder(
    column: $table.versionRange,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PackDependenciesTableOrderingComposer
    extends Composer<_$TavernierDatabase, $PackDependenciesTable> {
  $$PackDependenciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dependsOnPackId => $composableBuilder(
    column: $table.dependsOnPackId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get versionRange => $composableBuilder(
    column: $table.versionRange,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PackDependenciesTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $PackDependenciesTable> {
  $$PackDependenciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dependsOnPackId => $composableBuilder(
    column: $table.dependsOnPackId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get versionRange => $composableBuilder(
    column: $table.versionRange,
    builder: (column) => column,
  );

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PackDependenciesTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $PackDependenciesTable,
          PackDependencyRow,
          $$PackDependenciesTableFilterComposer,
          $$PackDependenciesTableOrderingComposer,
          $$PackDependenciesTableAnnotationComposer,
          $$PackDependenciesTableCreateCompanionBuilder,
          $$PackDependenciesTableUpdateCompanionBuilder,
          (PackDependencyRow, $$PackDependenciesTableReferences),
          PackDependencyRow,
          PrefetchHooks Function({bool packId})
        > {
  $$PackDependenciesTableTableManager(
    _$TavernierDatabase db,
    $PackDependenciesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PackDependenciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PackDependenciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PackDependenciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> packId = const Value.absent(),
                Value<String> dependsOnPackId = const Value.absent(),
                Value<String> versionRange = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PackDependenciesCompanion(
                packId: packId,
                dependsOnPackId: dependsOnPackId,
                versionRange: versionRange,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packId,
                required String dependsOnPackId,
                required String versionRange,
                Value<int> rowid = const Value.absent(),
              }) => PackDependenciesCompanion.insert(
                packId: packId,
                dependsOnPackId: dependsOnPackId,
                versionRange: versionRange,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PackDependenciesTable, PackDependencyRow>(table),
                  $$PackDependenciesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$PackDependenciesTableReferences
                            ._packIdTable(db),
                        referencedColumn: $$PackDependenciesTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PackDependenciesTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $PackDependenciesTable,
      PackDependencyRow,
      $$PackDependenciesTableFilterComposer,
      $$PackDependenciesTableOrderingComposer,
      $$PackDependenciesTableAnnotationComposer,
      $$PackDependenciesTableCreateCompanionBuilder,
      $$PackDependenciesTableUpdateCompanionBuilder,
      (PackDependencyRow, $$PackDependenciesTableReferences),
      PackDependencyRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$AbilitiesTableCreateCompanionBuilder = AbilitiesCompanion Function({
  required String id,
  required String packId,
  required String name,
  Value<String?> extendsId,
  required String abbreviation,
  Value<int> rowid,
});
typedef $$AbilitiesTableUpdateCompanionBuilder = AbilitiesCompanion Function({
  Value<String> id,
  Value<String> packId,
  Value<String> name,
  Value<String?> extendsId,
  Value<String> abbreviation,
  Value<int> rowid,
});

final class $$AbilitiesTableReferences
    extends BaseReferences<_$TavernierDatabase, $AbilitiesTable, AbilityRow> {
  $$AbilitiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('ability__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AbilitiesTableFilterComposer
    extends Composer<_$TavernierDatabase, $AbilitiesTable> {
  $$AbilitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abbreviation => $composableBuilder(
    column: $table.abbreviation,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AbilitiesTableOrderingComposer
    extends Composer<_$TavernierDatabase, $AbilitiesTable> {
  $$AbilitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abbreviation => $composableBuilder(
    column: $table.abbreviation,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AbilitiesTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $AbilitiesTable> {
  $$AbilitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get extendsId =>
      $composableBuilder(column: $table.extendsId, builder: (column) => column);

  GeneratedColumn<String> get abbreviation => $composableBuilder(
    column: $table.abbreviation,
    builder: (column) => column,
  );

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AbilitiesTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $AbilitiesTable,
          AbilityRow,
          $$AbilitiesTableFilterComposer,
          $$AbilitiesTableOrderingComposer,
          $$AbilitiesTableAnnotationComposer,
          $$AbilitiesTableCreateCompanionBuilder,
          $$AbilitiesTableUpdateCompanionBuilder,
          (AbilityRow, $$AbilitiesTableReferences),
          AbilityRow,
          PrefetchHooks Function({bool packId})
        > {
  $$AbilitiesTableTableManager(_$TavernierDatabase db, $AbilitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AbilitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AbilitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AbilitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> extendsId = const Value.absent(),
                Value<String> abbreviation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AbilitiesCompanion(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                abbreviation: abbreviation,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required String name,
                Value<String?> extendsId = const Value.absent(),
                required String abbreviation,
                Value<int> rowid = const Value.absent(),
              }) => AbilitiesCompanion.insert(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                abbreviation: abbreviation,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AbilitiesTable, AbilityRow>(table),
                  $$AbilitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$AbilitiesTableReferences
                            ._packIdTable(db),
                        referencedColumn: $$AbilitiesTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AbilitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $AbilitiesTable,
      AbilityRow,
      $$AbilitiesTableFilterComposer,
      $$AbilitiesTableOrderingComposer,
      $$AbilitiesTableAnnotationComposer,
      $$AbilitiesTableCreateCompanionBuilder,
      $$AbilitiesTableUpdateCompanionBuilder,
      (AbilityRow, $$AbilitiesTableReferences),
      AbilityRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$SkillsTableCreateCompanionBuilder = SkillsCompanion Function({
  required String id,
  required String packId,
  required String name,
  Value<String?> extendsId,
  required String abilityId,
  Value<int> rowid,
});
typedef $$SkillsTableUpdateCompanionBuilder = SkillsCompanion Function({
  Value<String> id,
  Value<String> packId,
  Value<String> name,
  Value<String?> extendsId,
  Value<String> abilityId,
  Value<int> rowid,
});

final class $$SkillsTableReferences
    extends BaseReferences<_$TavernierDatabase, $SkillsTable, SkillRow> {
  $$SkillsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('skill__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SkillsTableFilterComposer
    extends Composer<_$TavernierDatabase, $SkillsTable> {
  $$SkillsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abilityId => $composableBuilder(
    column: $table.abilityId,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SkillsTableOrderingComposer
    extends Composer<_$TavernierDatabase, $SkillsTable> {
  $$SkillsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abilityId => $composableBuilder(
    column: $table.abilityId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SkillsTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $SkillsTable> {
  $$SkillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get extendsId =>
      $composableBuilder(column: $table.extendsId, builder: (column) => column);

  GeneratedColumn<String> get abilityId =>
      $composableBuilder(column: $table.abilityId, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SkillsTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $SkillsTable,
          SkillRow,
          $$SkillsTableFilterComposer,
          $$SkillsTableOrderingComposer,
          $$SkillsTableAnnotationComposer,
          $$SkillsTableCreateCompanionBuilder,
          $$SkillsTableUpdateCompanionBuilder,
          (SkillRow, $$SkillsTableReferences),
          SkillRow,
          PrefetchHooks Function({bool packId})
        > {
  $$SkillsTableTableManager(_$TavernierDatabase db, $SkillsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SkillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SkillsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SkillsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> extendsId = const Value.absent(),
                Value<String> abilityId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SkillsCompanion(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                abilityId: abilityId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required String name,
                Value<String?> extendsId = const Value.absent(),
                required String abilityId,
                Value<int> rowid = const Value.absent(),
              }) => SkillsCompanion.insert(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                abilityId: abilityId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SkillsTable, SkillRow>(table),
                  $$SkillsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$SkillsTableReferences._packIdTable(
                          db,
                        ),
                        referencedColumn: $$SkillsTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SkillsTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $SkillsTable,
      SkillRow,
      $$SkillsTableFilterComposer,
      $$SkillsTableOrderingComposer,
      $$SkillsTableAnnotationComposer,
      $$SkillsTableCreateCompanionBuilder,
      $$SkillsTableUpdateCompanionBuilder,
      (SkillRow, $$SkillsTableReferences),
      SkillRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$LanguagesTableCreateCompanionBuilder = LanguagesCompanion Function({
  required String id,
  required String packId,
  required String name,
  Value<String?> extendsId,
  required String category,
  Value<int> rowid,
});
typedef $$LanguagesTableUpdateCompanionBuilder = LanguagesCompanion Function({
  Value<String> id,
  Value<String> packId,
  Value<String> name,
  Value<String?> extendsId,
  Value<String> category,
  Value<int> rowid,
});

final class $$LanguagesTableReferences
    extends BaseReferences<_$TavernierDatabase, $LanguagesTable, LanguageRow> {
  $$LanguagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('language__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LanguagesTableFilterComposer
    extends Composer<_$TavernierDatabase, $LanguagesTable> {
  $$LanguagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LanguagesTableOrderingComposer
    extends Composer<_$TavernierDatabase, $LanguagesTable> {
  $$LanguagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LanguagesTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $LanguagesTable> {
  $$LanguagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get extendsId =>
      $composableBuilder(column: $table.extendsId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LanguagesTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $LanguagesTable,
          LanguageRow,
          $$LanguagesTableFilterComposer,
          $$LanguagesTableOrderingComposer,
          $$LanguagesTableAnnotationComposer,
          $$LanguagesTableCreateCompanionBuilder,
          $$LanguagesTableUpdateCompanionBuilder,
          (LanguageRow, $$LanguagesTableReferences),
          LanguageRow,
          PrefetchHooks Function({bool packId})
        > {
  $$LanguagesTableTableManager(_$TavernierDatabase db, $LanguagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LanguagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LanguagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LanguagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> extendsId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LanguagesCompanion(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                category: category,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required String name,
                Value<String?> extendsId = const Value.absent(),
                required String category,
                Value<int> rowid = const Value.absent(),
              }) => LanguagesCompanion.insert(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                category: category,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LanguagesTable, LanguageRow>(table),
                  $$LanguagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$LanguagesTableReferences
                            ._packIdTable(db),
                        referencedColumn: $$LanguagesTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LanguagesTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $LanguagesTable,
      LanguageRow,
      $$LanguagesTableFilterComposer,
      $$LanguagesTableOrderingComposer,
      $$LanguagesTableAnnotationComposer,
      $$LanguagesTableCreateCompanionBuilder,
      $$LanguagesTableUpdateCompanionBuilder,
      (LanguageRow, $$LanguagesTableReferences),
      LanguageRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$ConditionsTableCreateCompanionBuilder = ConditionsCompanion Function({
  required String id,
  required String packId,
  required String name,
  Value<String?> extendsId,
  Value<int> rowid,
});
typedef $$ConditionsTableUpdateCompanionBuilder = ConditionsCompanion Function({
  Value<String> id,
  Value<String> packId,
  Value<String> name,
  Value<String?> extendsId,
  Value<int> rowid,
});

final class $$ConditionsTableReferences
    extends
        BaseReferences<_$TavernierDatabase, $ConditionsTable, ConditionRow> {
  $$ConditionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('condition__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ConditionsTableFilterComposer
    extends Composer<_$TavernierDatabase, $ConditionsTable> {
  $$ConditionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConditionsTableOrderingComposer
    extends Composer<_$TavernierDatabase, $ConditionsTable> {
  $$ConditionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConditionsTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $ConditionsTable> {
  $$ConditionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get extendsId =>
      $composableBuilder(column: $table.extendsId, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConditionsTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $ConditionsTable,
          ConditionRow,
          $$ConditionsTableFilterComposer,
          $$ConditionsTableOrderingComposer,
          $$ConditionsTableAnnotationComposer,
          $$ConditionsTableCreateCompanionBuilder,
          $$ConditionsTableUpdateCompanionBuilder,
          (ConditionRow, $$ConditionsTableReferences),
          ConditionRow,
          PrefetchHooks Function({bool packId})
        > {
  $$ConditionsTableTableManager(_$TavernierDatabase db, $ConditionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConditionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConditionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConditionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> extendsId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConditionsCompanion(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required String name,
                Value<String?> extendsId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConditionsCompanion.insert(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ConditionsTable, ConditionRow>(table),
                  $$ConditionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$ConditionsTableReferences
                            ._packIdTable(db),
                        referencedColumn: $$ConditionsTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ConditionsTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $ConditionsTable,
      ConditionRow,
      $$ConditionsTableFilterComposer,
      $$ConditionsTableOrderingComposer,
      $$ConditionsTableAnnotationComposer,
      $$ConditionsTableCreateCompanionBuilder,
      $$ConditionsTableUpdateCompanionBuilder,
      (ConditionRow, $$ConditionsTableReferences),
      ConditionRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$DamageTypesTableCreateCompanionBuilder =
    DamageTypesCompanion Function({
      required String id,
      required String packId,
      required String name,
      Value<String?> extendsId,
      Value<int> rowid,
    });
typedef $$DamageTypesTableUpdateCompanionBuilder =
    DamageTypesCompanion Function({
      Value<String> id,
      Value<String> packId,
      Value<String> name,
      Value<String?> extendsId,
      Value<int> rowid,
    });

final class $$DamageTypesTableReferences
    extends
        BaseReferences<_$TavernierDatabase, $DamageTypesTable, DamageTypeRow> {
  $$DamageTypesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('damage_type__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DamageTypesTableFilterComposer
    extends Composer<_$TavernierDatabase, $DamageTypesTable> {
  $$DamageTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DamageTypesTableOrderingComposer
    extends Composer<_$TavernierDatabase, $DamageTypesTable> {
  $$DamageTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DamageTypesTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $DamageTypesTable> {
  $$DamageTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get extendsId =>
      $composableBuilder(column: $table.extendsId, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DamageTypesTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $DamageTypesTable,
          DamageTypeRow,
          $$DamageTypesTableFilterComposer,
          $$DamageTypesTableOrderingComposer,
          $$DamageTypesTableAnnotationComposer,
          $$DamageTypesTableCreateCompanionBuilder,
          $$DamageTypesTableUpdateCompanionBuilder,
          (DamageTypeRow, $$DamageTypesTableReferences),
          DamageTypeRow,
          PrefetchHooks Function({bool packId})
        > {
  $$DamageTypesTableTableManager(
    _$TavernierDatabase db,
    $DamageTypesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DamageTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DamageTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DamageTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> extendsId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DamageTypesCompanion(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required String name,
                Value<String?> extendsId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DamageTypesCompanion.insert(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DamageTypesTable, DamageTypeRow>(table),
                  $$DamageTypesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$DamageTypesTableReferences
                            ._packIdTable(db),
                        referencedColumn: $$DamageTypesTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DamageTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $DamageTypesTable,
      DamageTypeRow,
      $$DamageTypesTableFilterComposer,
      $$DamageTypesTableOrderingComposer,
      $$DamageTypesTableAnnotationComposer,
      $$DamageTypesTableCreateCompanionBuilder,
      $$DamageTypesTableUpdateCompanionBuilder,
      (DamageTypeRow, $$DamageTypesTableReferences),
      DamageTypeRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$MasteryPropertiesTableCreateCompanionBuilder =
    MasteryPropertiesCompanion Function({
      required String id,
      required String packId,
      required String name,
      Value<String?> extendsId,
      Value<int> rowid,
    });
typedef $$MasteryPropertiesTableUpdateCompanionBuilder =
    MasteryPropertiesCompanion Function({
      Value<String> id,
      Value<String> packId,
      Value<String> name,
      Value<String?> extendsId,
      Value<int> rowid,
    });

final class $$MasteryPropertiesTableReferences
    extends
        BaseReferences<
          _$TavernierDatabase,
          $MasteryPropertiesTable,
          MasteryPropertyRow
        > {
  $$MasteryPropertiesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) => db
      .contentPacks
      .createAlias('mastery_property__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MasteryPropertiesTableFilterComposer
    extends Composer<_$TavernierDatabase, $MasteryPropertiesTable> {
  $$MasteryPropertiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MasteryPropertiesTableOrderingComposer
    extends Composer<_$TavernierDatabase, $MasteryPropertiesTable> {
  $$MasteryPropertiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MasteryPropertiesTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $MasteryPropertiesTable> {
  $$MasteryPropertiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get extendsId =>
      $composableBuilder(column: $table.extendsId, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MasteryPropertiesTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $MasteryPropertiesTable,
          MasteryPropertyRow,
          $$MasteryPropertiesTableFilterComposer,
          $$MasteryPropertiesTableOrderingComposer,
          $$MasteryPropertiesTableAnnotationComposer,
          $$MasteryPropertiesTableCreateCompanionBuilder,
          $$MasteryPropertiesTableUpdateCompanionBuilder,
          (MasteryPropertyRow, $$MasteryPropertiesTableReferences),
          MasteryPropertyRow,
          PrefetchHooks Function({bool packId})
        > {
  $$MasteryPropertiesTableTableManager(
    _$TavernierDatabase db,
    $MasteryPropertiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MasteryPropertiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MasteryPropertiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MasteryPropertiesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> extendsId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MasteryPropertiesCompanion(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required String name,
                Value<String?> extendsId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MasteryPropertiesCompanion.insert(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MasteryPropertiesTable, MasteryPropertyRow>(
                    table,
                  ),
                  $$MasteryPropertiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$MasteryPropertiesTableReferences
                            ._packIdTable(db),
                        referencedColumn: $$MasteryPropertiesTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MasteryPropertiesTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $MasteryPropertiesTable,
      MasteryPropertyRow,
      $$MasteryPropertiesTableFilterComposer,
      $$MasteryPropertiesTableOrderingComposer,
      $$MasteryPropertiesTableAnnotationComposer,
      $$MasteryPropertiesTableCreateCompanionBuilder,
      $$MasteryPropertiesTableUpdateCompanionBuilder,
      (MasteryPropertyRow, $$MasteryPropertiesTableReferences),
      MasteryPropertyRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$WeaponsTableCreateCompanionBuilder = WeaponsCompanion Function({
  required String id,
  required String packId,
  required String name,
  Value<String?> extendsId,
  required String category,
  required String kind,
  required String damage,
  required String damageTypeId,
  required String properties,
  Value<String?> versatileDamage,
  Value<int?> rangeNormalFeet,
  Value<int?> rangeLongFeet,
  required String masteryPropertyId,
  Value<double?> weightKg,
  required int costCp,
  Value<int> rowid,
});
typedef $$WeaponsTableUpdateCompanionBuilder = WeaponsCompanion Function({
  Value<String> id,
  Value<String> packId,
  Value<String> name,
  Value<String?> extendsId,
  Value<String> category,
  Value<String> kind,
  Value<String> damage,
  Value<String> damageTypeId,
  Value<String> properties,
  Value<String?> versatileDamage,
  Value<int?> rangeNormalFeet,
  Value<int?> rangeLongFeet,
  Value<String> masteryPropertyId,
  Value<double?> weightKg,
  Value<int> costCp,
  Value<int> rowid,
});

final class $$WeaponsTableReferences
    extends BaseReferences<_$TavernierDatabase, $WeaponsTable, WeaponRow> {
  $$WeaponsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('weapon__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WeaponsTableFilterComposer
    extends Composer<_$TavernierDatabase, $WeaponsTable> {
  $$WeaponsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get damage => $composableBuilder(
    column: $table.damage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get damageTypeId => $composableBuilder(
    column: $table.damageTypeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get properties => $composableBuilder(
    column: $table.properties,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get versatileDamage => $composableBuilder(
    column: $table.versatileDamage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rangeNormalFeet => $composableBuilder(
    column: $table.rangeNormalFeet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rangeLongFeet => $composableBuilder(
    column: $table.rangeLongFeet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get masteryPropertyId => $composableBuilder(
    column: $table.masteryPropertyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costCp => $composableBuilder(
    column: $table.costCp,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeaponsTableOrderingComposer
    extends Composer<_$TavernierDatabase, $WeaponsTable> {
  $$WeaponsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get damage => $composableBuilder(
    column: $table.damage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get damageTypeId => $composableBuilder(
    column: $table.damageTypeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get properties => $composableBuilder(
    column: $table.properties,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get versatileDamage => $composableBuilder(
    column: $table.versatileDamage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rangeNormalFeet => $composableBuilder(
    column: $table.rangeNormalFeet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rangeLongFeet => $composableBuilder(
    column: $table.rangeLongFeet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get masteryPropertyId => $composableBuilder(
    column: $table.masteryPropertyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costCp => $composableBuilder(
    column: $table.costCp,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeaponsTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $WeaponsTable> {
  $$WeaponsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get extendsId =>
      $composableBuilder(column: $table.extendsId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get damage =>
      $composableBuilder(column: $table.damage, builder: (column) => column);

  GeneratedColumn<String> get damageTypeId => $composableBuilder(
    column: $table.damageTypeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get properties => $composableBuilder(
    column: $table.properties,
    builder: (column) => column,
  );

  GeneratedColumn<String> get versatileDamage => $composableBuilder(
    column: $table.versatileDamage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rangeNormalFeet => $composableBuilder(
    column: $table.rangeNormalFeet,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rangeLongFeet => $composableBuilder(
    column: $table.rangeLongFeet,
    builder: (column) => column,
  );

  GeneratedColumn<String> get masteryPropertyId => $composableBuilder(
    column: $table.masteryPropertyId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get costCp =>
      $composableBuilder(column: $table.costCp, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeaponsTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $WeaponsTable,
          WeaponRow,
          $$WeaponsTableFilterComposer,
          $$WeaponsTableOrderingComposer,
          $$WeaponsTableAnnotationComposer,
          $$WeaponsTableCreateCompanionBuilder,
          $$WeaponsTableUpdateCompanionBuilder,
          (WeaponRow, $$WeaponsTableReferences),
          WeaponRow,
          PrefetchHooks Function({bool packId})
        > {
  $$WeaponsTableTableManager(_$TavernierDatabase db, $WeaponsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeaponsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeaponsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeaponsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> extendsId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> damage = const Value.absent(),
                Value<String> damageTypeId = const Value.absent(),
                Value<String> properties = const Value.absent(),
                Value<String?> versatileDamage = const Value.absent(),
                Value<int?> rangeNormalFeet = const Value.absent(),
                Value<int?> rangeLongFeet = const Value.absent(),
                Value<String> masteryPropertyId = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<int> costCp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeaponsCompanion(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                category: category,
                kind: kind,
                damage: damage,
                damageTypeId: damageTypeId,
                properties: properties,
                versatileDamage: versatileDamage,
                rangeNormalFeet: rangeNormalFeet,
                rangeLongFeet: rangeLongFeet,
                masteryPropertyId: masteryPropertyId,
                weightKg: weightKg,
                costCp: costCp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required String name,
                Value<String?> extendsId = const Value.absent(),
                required String category,
                required String kind,
                required String damage,
                required String damageTypeId,
                required String properties,
                Value<String?> versatileDamage = const Value.absent(),
                Value<int?> rangeNormalFeet = const Value.absent(),
                Value<int?> rangeLongFeet = const Value.absent(),
                required String masteryPropertyId,
                Value<double?> weightKg = const Value.absent(),
                required int costCp,
                Value<int> rowid = const Value.absent(),
              }) => WeaponsCompanion.insert(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                category: category,
                kind: kind,
                damage: damage,
                damageTypeId: damageTypeId,
                properties: properties,
                versatileDamage: versatileDamage,
                rangeNormalFeet: rangeNormalFeet,
                rangeLongFeet: rangeLongFeet,
                masteryPropertyId: masteryPropertyId,
                weightKg: weightKg,
                costCp: costCp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeaponsTable, WeaponRow>(table),
                  $$WeaponsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$WeaponsTableReferences._packIdTable(
                          db,
                        ),
                        referencedColumn: $$WeaponsTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WeaponsTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $WeaponsTable,
      WeaponRow,
      $$WeaponsTableFilterComposer,
      $$WeaponsTableOrderingComposer,
      $$WeaponsTableAnnotationComposer,
      $$WeaponsTableCreateCompanionBuilder,
      $$WeaponsTableUpdateCompanionBuilder,
      (WeaponRow, $$WeaponsTableReferences),
      WeaponRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$ArmorsTableCreateCompanionBuilder = ArmorsCompanion Function({
  required String id,
  required String packId,
  required String name,
  Value<String?> extendsId,
  required String category,
  required int baseAc,
  Value<int?> dexCap,
  Value<int?> strRequirement,
  required bool stealthDisadvantage,
  required double weightKg,
  required int costCp,
  Value<int> rowid,
});
typedef $$ArmorsTableUpdateCompanionBuilder = ArmorsCompanion Function({
  Value<String> id,
  Value<String> packId,
  Value<String> name,
  Value<String?> extendsId,
  Value<String> category,
  Value<int> baseAc,
  Value<int?> dexCap,
  Value<int?> strRequirement,
  Value<bool> stealthDisadvantage,
  Value<double> weightKg,
  Value<int> costCp,
  Value<int> rowid,
});

final class $$ArmorsTableReferences
    extends BaseReferences<_$TavernierDatabase, $ArmorsTable, ArmorRow> {
  $$ArmorsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('armor__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ArmorsTableFilterComposer
    extends Composer<_$TavernierDatabase, $ArmorsTable> {
  $$ArmorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseAc => $composableBuilder(
    column: $table.baseAc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dexCap => $composableBuilder(
    column: $table.dexCap,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get strRequirement => $composableBuilder(
    column: $table.strRequirement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get stealthDisadvantage => $composableBuilder(
    column: $table.stealthDisadvantage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costCp => $composableBuilder(
    column: $table.costCp,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ArmorsTableOrderingComposer
    extends Composer<_$TavernierDatabase, $ArmorsTable> {
  $$ArmorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseAc => $composableBuilder(
    column: $table.baseAc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dexCap => $composableBuilder(
    column: $table.dexCap,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get strRequirement => $composableBuilder(
    column: $table.strRequirement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get stealthDisadvantage => $composableBuilder(
    column: $table.stealthDisadvantage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costCp => $composableBuilder(
    column: $table.costCp,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ArmorsTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $ArmorsTable> {
  $$ArmorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get extendsId =>
      $composableBuilder(column: $table.extendsId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get baseAc =>
      $composableBuilder(column: $table.baseAc, builder: (column) => column);

  GeneratedColumn<int> get dexCap =>
      $composableBuilder(column: $table.dexCap, builder: (column) => column);

  GeneratedColumn<int> get strRequirement => $composableBuilder(
    column: $table.strRequirement,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get stealthDisadvantage => $composableBuilder(
    column: $table.stealthDisadvantage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get costCp =>
      $composableBuilder(column: $table.costCp, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ArmorsTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $ArmorsTable,
          ArmorRow,
          $$ArmorsTableFilterComposer,
          $$ArmorsTableOrderingComposer,
          $$ArmorsTableAnnotationComposer,
          $$ArmorsTableCreateCompanionBuilder,
          $$ArmorsTableUpdateCompanionBuilder,
          (ArmorRow, $$ArmorsTableReferences),
          ArmorRow,
          PrefetchHooks Function({bool packId})
        > {
  $$ArmorsTableTableManager(_$TavernierDatabase db, $ArmorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArmorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArmorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArmorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> extendsId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> baseAc = const Value.absent(),
                Value<int?> dexCap = const Value.absent(),
                Value<int?> strRequirement = const Value.absent(),
                Value<bool> stealthDisadvantage = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<int> costCp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArmorsCompanion(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                category: category,
                baseAc: baseAc,
                dexCap: dexCap,
                strRequirement: strRequirement,
                stealthDisadvantage: stealthDisadvantage,
                weightKg: weightKg,
                costCp: costCp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required String name,
                Value<String?> extendsId = const Value.absent(),
                required String category,
                required int baseAc,
                Value<int?> dexCap = const Value.absent(),
                Value<int?> strRequirement = const Value.absent(),
                required bool stealthDisadvantage,
                required double weightKg,
                required int costCp,
                Value<int> rowid = const Value.absent(),
              }) => ArmorsCompanion.insert(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                category: category,
                baseAc: baseAc,
                dexCap: dexCap,
                strRequirement: strRequirement,
                stealthDisadvantage: stealthDisadvantage,
                weightKg: weightKg,
                costCp: costCp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ArmorsTable, ArmorRow>(table),
                  $$ArmorsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$ArmorsTableReferences._packIdTable(
                          db,
                        ),
                        referencedColumn: $$ArmorsTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ArmorsTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $ArmorsTable,
      ArmorRow,
      $$ArmorsTableFilterComposer,
      $$ArmorsTableOrderingComposer,
      $$ArmorsTableAnnotationComposer,
      $$ArmorsTableCreateCompanionBuilder,
      $$ArmorsTableUpdateCompanionBuilder,
      (ArmorRow, $$ArmorsTableReferences),
      ArmorRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$ToolsTableCreateCompanionBuilder = ToolsCompanion Function({
  required String id,
  required String packId,
  required String name,
  Value<String?> extendsId,
  required String category,
  Value<String?> abilityId,
  Value<double?> weightKg,
  required int costCp,
  Value<int> rowid,
});
typedef $$ToolsTableUpdateCompanionBuilder = ToolsCompanion Function({
  Value<String> id,
  Value<String> packId,
  Value<String> name,
  Value<String?> extendsId,
  Value<String> category,
  Value<String?> abilityId,
  Value<double?> weightKg,
  Value<int> costCp,
  Value<int> rowid,
});

final class $$ToolsTableReferences
    extends BaseReferences<_$TavernierDatabase, $ToolsTable, ToolRow> {
  $$ToolsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('tool__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ToolsTableFilterComposer
    extends Composer<_$TavernierDatabase, $ToolsTable> {
  $$ToolsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abilityId => $composableBuilder(
    column: $table.abilityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costCp => $composableBuilder(
    column: $table.costCp,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ToolsTableOrderingComposer
    extends Composer<_$TavernierDatabase, $ToolsTable> {
  $$ToolsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abilityId => $composableBuilder(
    column: $table.abilityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costCp => $composableBuilder(
    column: $table.costCp,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ToolsTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $ToolsTable> {
  $$ToolsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get extendsId =>
      $composableBuilder(column: $table.extendsId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get abilityId =>
      $composableBuilder(column: $table.abilityId, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get costCp =>
      $composableBuilder(column: $table.costCp, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ToolsTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $ToolsTable,
          ToolRow,
          $$ToolsTableFilterComposer,
          $$ToolsTableOrderingComposer,
          $$ToolsTableAnnotationComposer,
          $$ToolsTableCreateCompanionBuilder,
          $$ToolsTableUpdateCompanionBuilder,
          (ToolRow, $$ToolsTableReferences),
          ToolRow,
          PrefetchHooks Function({bool packId})
        > {
  $$ToolsTableTableManager(_$TavernierDatabase db, $ToolsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ToolsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ToolsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ToolsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> extendsId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> abilityId = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<int> costCp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ToolsCompanion(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                category: category,
                abilityId: abilityId,
                weightKg: weightKg,
                costCp: costCp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required String name,
                Value<String?> extendsId = const Value.absent(),
                required String category,
                Value<String?> abilityId = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                required int costCp,
                Value<int> rowid = const Value.absent(),
              }) => ToolsCompanion.insert(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                category: category,
                abilityId: abilityId,
                weightKg: weightKg,
                costCp: costCp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ToolsTable, ToolRow>(table),
                  $$ToolsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$ToolsTableReferences._packIdTable(
                          db,
                        ),
                        referencedColumn: $$ToolsTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ToolsTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $ToolsTable,
      ToolRow,
      $$ToolsTableFilterComposer,
      $$ToolsTableOrderingComposer,
      $$ToolsTableAnnotationComposer,
      $$ToolsTableCreateCompanionBuilder,
      $$ToolsTableUpdateCompanionBuilder,
      (ToolRow, $$ToolsTableReferences),
      ToolRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$ItemsTableCreateCompanionBuilder = ItemsCompanion Function({
  required String id,
  required String packId,
  required String name,
  Value<String?> extendsId,
  Value<double?> weightKg,
  Value<int?> costCp,
  Value<String?> rarity,
  Value<bool> attunement,
  Value<int> rowid,
});
typedef $$ItemsTableUpdateCompanionBuilder = ItemsCompanion Function({
  Value<String> id,
  Value<String> packId,
  Value<String> name,
  Value<String?> extendsId,
  Value<double?> weightKg,
  Value<int?> costCp,
  Value<String?> rarity,
  Value<bool> attunement,
  Value<int> rowid,
});

final class $$ItemsTableReferences
    extends BaseReferences<_$TavernierDatabase, $ItemsTable, ItemRow> {
  $$ItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('item__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItemsTableFilterComposer
    extends Composer<_$TavernierDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costCp => $composableBuilder(
    column: $table.costCp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rarity => $composableBuilder(
    column: $table.rarity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get attunement => $composableBuilder(
    column: $table.attunement,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemsTableOrderingComposer
    extends Composer<_$TavernierDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costCp => $composableBuilder(
    column: $table.costCp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rarity => $composableBuilder(
    column: $table.rarity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get attunement => $composableBuilder(
    column: $table.attunement,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemsTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $ItemsTable> {
  $$ItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get extendsId =>
      $composableBuilder(column: $table.extendsId, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get costCp =>
      $composableBuilder(column: $table.costCp, builder: (column) => column);

  GeneratedColumn<String> get rarity =>
      $composableBuilder(column: $table.rarity, builder: (column) => column);

  GeneratedColumn<bool> get attunement => $composableBuilder(
    column: $table.attunement,
    builder: (column) => column,
  );

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemsTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $ItemsTable,
          ItemRow,
          $$ItemsTableFilterComposer,
          $$ItemsTableOrderingComposer,
          $$ItemsTableAnnotationComposer,
          $$ItemsTableCreateCompanionBuilder,
          $$ItemsTableUpdateCompanionBuilder,
          (ItemRow, $$ItemsTableReferences),
          ItemRow,
          PrefetchHooks Function({bool packId})
        > {
  $$ItemsTableTableManager(_$TavernierDatabase db, $ItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> extendsId = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<int?> costCp = const Value.absent(),
                Value<String?> rarity = const Value.absent(),
                Value<bool> attunement = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemsCompanion(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                weightKg: weightKg,
                costCp: costCp,
                rarity: rarity,
                attunement: attunement,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required String name,
                Value<String?> extendsId = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<int?> costCp = const Value.absent(),
                Value<String?> rarity = const Value.absent(),
                Value<bool> attunement = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemsCompanion.insert(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                weightKg: weightKg,
                costCp: costCp,
                rarity: rarity,
                attunement: attunement,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemsTable, ItemRow>(table),
                  $$ItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$ItemsTableReferences._packIdTable(
                          db,
                        ),
                        referencedColumn: $$ItemsTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $ItemsTable,
      ItemRow,
      $$ItemsTableFilterComposer,
      $$ItemsTableOrderingComposer,
      $$ItemsTableAnnotationComposer,
      $$ItemsTableCreateCompanionBuilder,
      $$ItemsTableUpdateCompanionBuilder,
      (ItemRow, $$ItemsTableReferences),
      ItemRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$BackgroundsTableCreateCompanionBuilder =
    BackgroundsCompanion Function({
      required String id,
      required String packId,
      required String name,
      Value<String?> extendsId,
      required String originFeatId,
      Value<String?> originFeatChoices,
      Value<String?> toolChoiceCategory,
      required int goldA,
      required int equipmentGoldAlt,
      Value<int> rowid,
    });
typedef $$BackgroundsTableUpdateCompanionBuilder =
    BackgroundsCompanion Function({
      Value<String> id,
      Value<String> packId,
      Value<String> name,
      Value<String?> extendsId,
      Value<String> originFeatId,
      Value<String?> originFeatChoices,
      Value<String?> toolChoiceCategory,
      Value<int> goldA,
      Value<int> equipmentGoldAlt,
      Value<int> rowid,
    });

final class $$BackgroundsTableReferences
    extends
        BaseReferences<_$TavernierDatabase, $BackgroundsTable, BackgroundRow> {
  $$BackgroundsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('background__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BackgroundsTableFilterComposer
    extends Composer<_$TavernierDatabase, $BackgroundsTable> {
  $$BackgroundsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originFeatId => $composableBuilder(
    column: $table.originFeatId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originFeatChoices => $composableBuilder(
    column: $table.originFeatChoices,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toolChoiceCategory => $composableBuilder(
    column: $table.toolChoiceCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goldA => $composableBuilder(
    column: $table.goldA,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get equipmentGoldAlt => $composableBuilder(
    column: $table.equipmentGoldAlt,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BackgroundsTableOrderingComposer
    extends Composer<_$TavernierDatabase, $BackgroundsTable> {
  $$BackgroundsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originFeatId => $composableBuilder(
    column: $table.originFeatId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originFeatChoices => $composableBuilder(
    column: $table.originFeatChoices,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toolChoiceCategory => $composableBuilder(
    column: $table.toolChoiceCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goldA => $composableBuilder(
    column: $table.goldA,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get equipmentGoldAlt => $composableBuilder(
    column: $table.equipmentGoldAlt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BackgroundsTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $BackgroundsTable> {
  $$BackgroundsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get extendsId =>
      $composableBuilder(column: $table.extendsId, builder: (column) => column);

  GeneratedColumn<String> get originFeatId => $composableBuilder(
    column: $table.originFeatId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originFeatChoices => $composableBuilder(
    column: $table.originFeatChoices,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toolChoiceCategory => $composableBuilder(
    column: $table.toolChoiceCategory,
    builder: (column) => column,
  );

  GeneratedColumn<int> get goldA =>
      $composableBuilder(column: $table.goldA, builder: (column) => column);

  GeneratedColumn<int> get equipmentGoldAlt => $composableBuilder(
    column: $table.equipmentGoldAlt,
    builder: (column) => column,
  );

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BackgroundsTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $BackgroundsTable,
          BackgroundRow,
          $$BackgroundsTableFilterComposer,
          $$BackgroundsTableOrderingComposer,
          $$BackgroundsTableAnnotationComposer,
          $$BackgroundsTableCreateCompanionBuilder,
          $$BackgroundsTableUpdateCompanionBuilder,
          (BackgroundRow, $$BackgroundsTableReferences),
          BackgroundRow,
          PrefetchHooks Function({bool packId})
        > {
  $$BackgroundsTableTableManager(
    _$TavernierDatabase db,
    $BackgroundsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BackgroundsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BackgroundsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BackgroundsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> extendsId = const Value.absent(),
                Value<String> originFeatId = const Value.absent(),
                Value<String?> originFeatChoices = const Value.absent(),
                Value<String?> toolChoiceCategory = const Value.absent(),
                Value<int> goldA = const Value.absent(),
                Value<int> equipmentGoldAlt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BackgroundsCompanion(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                originFeatId: originFeatId,
                originFeatChoices: originFeatChoices,
                toolChoiceCategory: toolChoiceCategory,
                goldA: goldA,
                equipmentGoldAlt: equipmentGoldAlt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required String name,
                Value<String?> extendsId = const Value.absent(),
                required String originFeatId,
                Value<String?> originFeatChoices = const Value.absent(),
                Value<String?> toolChoiceCategory = const Value.absent(),
                required int goldA,
                required int equipmentGoldAlt,
                Value<int> rowid = const Value.absent(),
              }) => BackgroundsCompanion.insert(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                originFeatId: originFeatId,
                originFeatChoices: originFeatChoices,
                toolChoiceCategory: toolChoiceCategory,
                goldA: goldA,
                equipmentGoldAlt: equipmentGoldAlt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BackgroundsTable, BackgroundRow>(table),
                  $$BackgroundsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$BackgroundsTableReferences
                            ._packIdTable(db),
                        referencedColumn: $$BackgroundsTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BackgroundsTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $BackgroundsTable,
      BackgroundRow,
      $$BackgroundsTableFilterComposer,
      $$BackgroundsTableOrderingComposer,
      $$BackgroundsTableAnnotationComposer,
      $$BackgroundsTableCreateCompanionBuilder,
      $$BackgroundsTableUpdateCompanionBuilder,
      (BackgroundRow, $$BackgroundsTableReferences),
      BackgroundRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$BackgroundAbilitiesTableCreateCompanionBuilder =
    BackgroundAbilitiesCompanion Function({
      required String packId,
      required String backgroundId,
      required int position,
      required String abilityId,
      Value<int> rowid,
    });
typedef $$BackgroundAbilitiesTableUpdateCompanionBuilder =
    BackgroundAbilitiesCompanion Function({
      Value<String> packId,
      Value<String> backgroundId,
      Value<int> position,
      Value<String> abilityId,
      Value<int> rowid,
    });

final class $$BackgroundAbilitiesTableReferences
    extends
        BaseReferences<
          _$TavernierDatabase,
          $BackgroundAbilitiesTable,
          BackgroundAbilityRow
        > {
  $$BackgroundAbilitiesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) => db
      .contentPacks
      .createAlias('background_ability__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BackgroundAbilitiesTableFilterComposer
    extends Composer<_$TavernierDatabase, $BackgroundAbilitiesTable> {
  $$BackgroundAbilitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get backgroundId => $composableBuilder(
    column: $table.backgroundId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abilityId => $composableBuilder(
    column: $table.abilityId,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BackgroundAbilitiesTableOrderingComposer
    extends Composer<_$TavernierDatabase, $BackgroundAbilitiesTable> {
  $$BackgroundAbilitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get backgroundId => $composableBuilder(
    column: $table.backgroundId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abilityId => $composableBuilder(
    column: $table.abilityId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BackgroundAbilitiesTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $BackgroundAbilitiesTable> {
  $$BackgroundAbilitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get backgroundId => $composableBuilder(
    column: $table.backgroundId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get abilityId =>
      $composableBuilder(column: $table.abilityId, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BackgroundAbilitiesTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $BackgroundAbilitiesTable,
          BackgroundAbilityRow,
          $$BackgroundAbilitiesTableFilterComposer,
          $$BackgroundAbilitiesTableOrderingComposer,
          $$BackgroundAbilitiesTableAnnotationComposer,
          $$BackgroundAbilitiesTableCreateCompanionBuilder,
          $$BackgroundAbilitiesTableUpdateCompanionBuilder,
          (BackgroundAbilityRow, $$BackgroundAbilitiesTableReferences),
          BackgroundAbilityRow,
          PrefetchHooks Function({bool packId})
        > {
  $$BackgroundAbilitiesTableTableManager(
    _$TavernierDatabase db,
    $BackgroundAbilitiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BackgroundAbilitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BackgroundAbilitiesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BackgroundAbilitiesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> packId = const Value.absent(),
                Value<String> backgroundId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> abilityId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BackgroundAbilitiesCompanion(
                packId: packId,
                backgroundId: backgroundId,
                position: position,
                abilityId: abilityId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packId,
                required String backgroundId,
                required int position,
                required String abilityId,
                Value<int> rowid = const Value.absent(),
              }) => BackgroundAbilitiesCompanion.insert(
                packId: packId,
                backgroundId: backgroundId,
                position: position,
                abilityId: abilityId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BackgroundAbilitiesTable, BackgroundAbilityRow>(
                    table,
                  ),
                  $$BackgroundAbilitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$BackgroundAbilitiesTableReferences
                            ._packIdTable(db),
                        referencedColumn: $$BackgroundAbilitiesTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BackgroundAbilitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $BackgroundAbilitiesTable,
      BackgroundAbilityRow,
      $$BackgroundAbilitiesTableFilterComposer,
      $$BackgroundAbilitiesTableOrderingComposer,
      $$BackgroundAbilitiesTableAnnotationComposer,
      $$BackgroundAbilitiesTableCreateCompanionBuilder,
      $$BackgroundAbilitiesTableUpdateCompanionBuilder,
      (BackgroundAbilityRow, $$BackgroundAbilitiesTableReferences),
      BackgroundAbilityRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$BackgroundProficienciesTableCreateCompanionBuilder =
    BackgroundProficienciesCompanion Function({
      required String packId,
      required String backgroundId,
      required int position,
      required String type,
      required String refId,
      Value<int> rowid,
    });
typedef $$BackgroundProficienciesTableUpdateCompanionBuilder =
    BackgroundProficienciesCompanion Function({
      Value<String> packId,
      Value<String> backgroundId,
      Value<int> position,
      Value<String> type,
      Value<String> refId,
      Value<int> rowid,
    });

final class $$BackgroundProficienciesTableReferences
    extends
        BaseReferences<
          _$TavernierDatabase,
          $BackgroundProficienciesTable,
          BackgroundProficiencyRow
        > {
  $$BackgroundProficienciesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) => db
      .contentPacks
      .createAlias('background_proficiency__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BackgroundProficienciesTableFilterComposer
    extends Composer<_$TavernierDatabase, $BackgroundProficienciesTable> {
  $$BackgroundProficienciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get backgroundId => $composableBuilder(
    column: $table.backgroundId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BackgroundProficienciesTableOrderingComposer
    extends Composer<_$TavernierDatabase, $BackgroundProficienciesTable> {
  $$BackgroundProficienciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get backgroundId => $composableBuilder(
    column: $table.backgroundId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BackgroundProficienciesTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $BackgroundProficienciesTable> {
  $$BackgroundProficienciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get backgroundId => $composableBuilder(
    column: $table.backgroundId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get refId =>
      $composableBuilder(column: $table.refId, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BackgroundProficienciesTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $BackgroundProficienciesTable,
          BackgroundProficiencyRow,
          $$BackgroundProficienciesTableFilterComposer,
          $$BackgroundProficienciesTableOrderingComposer,
          $$BackgroundProficienciesTableAnnotationComposer,
          $$BackgroundProficienciesTableCreateCompanionBuilder,
          $$BackgroundProficienciesTableUpdateCompanionBuilder,
          (BackgroundProficiencyRow, $$BackgroundProficienciesTableReferences),
          BackgroundProficiencyRow,
          PrefetchHooks Function({bool packId})
        > {
  $$BackgroundProficienciesTableTableManager(
    _$TavernierDatabase db,
    $BackgroundProficienciesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BackgroundProficienciesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$BackgroundProficienciesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BackgroundProficienciesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> packId = const Value.absent(),
                Value<String> backgroundId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> refId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BackgroundProficienciesCompanion(
                packId: packId,
                backgroundId: backgroundId,
                position: position,
                type: type,
                refId: refId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packId,
                required String backgroundId,
                required int position,
                required String type,
                required String refId,
                Value<int> rowid = const Value.absent(),
              }) => BackgroundProficienciesCompanion.insert(
                packId: packId,
                backgroundId: backgroundId,
                position: position,
                type: type,
                refId: refId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $BackgroundProficienciesTable,
                    BackgroundProficiencyRow
                  >(table),
                  $$BackgroundProficienciesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable:
                            $$BackgroundProficienciesTableReferences
                                ._packIdTable(db),
                        referencedColumn:
                            $$BackgroundProficienciesTableReferences
                                ._packIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BackgroundProficienciesTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $BackgroundProficienciesTable,
      BackgroundProficiencyRow,
      $$BackgroundProficienciesTableFilterComposer,
      $$BackgroundProficienciesTableOrderingComposer,
      $$BackgroundProficienciesTableAnnotationComposer,
      $$BackgroundProficienciesTableCreateCompanionBuilder,
      $$BackgroundProficienciesTableUpdateCompanionBuilder,
      (BackgroundProficiencyRow, $$BackgroundProficienciesTableReferences),
      BackgroundProficiencyRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$BackgroundEquipmentOptionsTableCreateCompanionBuilder =
    BackgroundEquipmentOptionsCompanion Function({
      required String packId,
      required String backgroundId,
      required String option,
      required String items,
      Value<int> rowid,
    });
typedef $$BackgroundEquipmentOptionsTableUpdateCompanionBuilder =
    BackgroundEquipmentOptionsCompanion Function({
      Value<String> packId,
      Value<String> backgroundId,
      Value<String> option,
      Value<String> items,
      Value<int> rowid,
    });

final class $$BackgroundEquipmentOptionsTableReferences
    extends
        BaseReferences<
          _$TavernierDatabase,
          $BackgroundEquipmentOptionsTable,
          BackgroundEquipmentOptionRow
        > {
  $$BackgroundEquipmentOptionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) => db
      .contentPacks
      .createAlias('background_equipment_option__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BackgroundEquipmentOptionsTableFilterComposer
    extends Composer<_$TavernierDatabase, $BackgroundEquipmentOptionsTable> {
  $$BackgroundEquipmentOptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get backgroundId => $composableBuilder(
    column: $table.backgroundId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get option => $composableBuilder(
    column: $table.option,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get items => $composableBuilder(
    column: $table.items,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BackgroundEquipmentOptionsTableOrderingComposer
    extends Composer<_$TavernierDatabase, $BackgroundEquipmentOptionsTable> {
  $$BackgroundEquipmentOptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get backgroundId => $composableBuilder(
    column: $table.backgroundId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get option => $composableBuilder(
    column: $table.option,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get items => $composableBuilder(
    column: $table.items,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BackgroundEquipmentOptionsTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $BackgroundEquipmentOptionsTable> {
  $$BackgroundEquipmentOptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get backgroundId => $composableBuilder(
    column: $table.backgroundId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get option =>
      $composableBuilder(column: $table.option, builder: (column) => column);

  GeneratedColumn<String> get items =>
      $composableBuilder(column: $table.items, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BackgroundEquipmentOptionsTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $BackgroundEquipmentOptionsTable,
          BackgroundEquipmentOptionRow,
          $$BackgroundEquipmentOptionsTableFilterComposer,
          $$BackgroundEquipmentOptionsTableOrderingComposer,
          $$BackgroundEquipmentOptionsTableAnnotationComposer,
          $$BackgroundEquipmentOptionsTableCreateCompanionBuilder,
          $$BackgroundEquipmentOptionsTableUpdateCompanionBuilder,
          (
            BackgroundEquipmentOptionRow,
            $$BackgroundEquipmentOptionsTableReferences,
          ),
          BackgroundEquipmentOptionRow,
          PrefetchHooks Function({bool packId})
        > {
  $$BackgroundEquipmentOptionsTableTableManager(
    _$TavernierDatabase db,
    $BackgroundEquipmentOptionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BackgroundEquipmentOptionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$BackgroundEquipmentOptionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BackgroundEquipmentOptionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> packId = const Value.absent(),
                Value<String> backgroundId = const Value.absent(),
                Value<String> option = const Value.absent(),
                Value<String> items = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BackgroundEquipmentOptionsCompanion(
                packId: packId,
                backgroundId: backgroundId,
                option: option,
                items: items,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packId,
                required String backgroundId,
                required String option,
                required String items,
                Value<int> rowid = const Value.absent(),
              }) => BackgroundEquipmentOptionsCompanion.insert(
                packId: packId,
                backgroundId: backgroundId,
                option: option,
                items: items,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $BackgroundEquipmentOptionsTable,
                    BackgroundEquipmentOptionRow
                  >(table),
                  $$BackgroundEquipmentOptionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable:
                            $$BackgroundEquipmentOptionsTableReferences
                                ._packIdTable(db),
                        referencedColumn:
                            $$BackgroundEquipmentOptionsTableReferences
                                ._packIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BackgroundEquipmentOptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $BackgroundEquipmentOptionsTable,
      BackgroundEquipmentOptionRow,
      $$BackgroundEquipmentOptionsTableFilterComposer,
      $$BackgroundEquipmentOptionsTableOrderingComposer,
      $$BackgroundEquipmentOptionsTableAnnotationComposer,
      $$BackgroundEquipmentOptionsTableCreateCompanionBuilder,
      $$BackgroundEquipmentOptionsTableUpdateCompanionBuilder,
      (
        BackgroundEquipmentOptionRow,
        $$BackgroundEquipmentOptionsTableReferences,
      ),
      BackgroundEquipmentOptionRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$FeatsTableCreateCompanionBuilder = FeatsCompanion Function({
  required String id,
  required String packId,
  required String name,
  Value<String?> extendsId,
  required String category,
  Value<String?> prerequisites,
  required bool repeatable,
  Value<int> rowid,
});
typedef $$FeatsTableUpdateCompanionBuilder = FeatsCompanion Function({
  Value<String> id,
  Value<String> packId,
  Value<String> name,
  Value<String?> extendsId,
  Value<String> category,
  Value<String?> prerequisites,
  Value<bool> repeatable,
  Value<int> rowid,
});

final class $$FeatsTableReferences
    extends BaseReferences<_$TavernierDatabase, $FeatsTable, FeatRow> {
  $$FeatsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('feat__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FeatsTableFilterComposer
    extends Composer<_$TavernierDatabase, $FeatsTable> {
  $$FeatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prerequisites => $composableBuilder(
    column: $table.prerequisites,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get repeatable => $composableBuilder(
    column: $table.repeatable,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeatsTableOrderingComposer
    extends Composer<_$TavernierDatabase, $FeatsTable> {
  $$FeatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prerequisites => $composableBuilder(
    column: $table.prerequisites,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get repeatable => $composableBuilder(
    column: $table.repeatable,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeatsTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $FeatsTable> {
  $$FeatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get extendsId =>
      $composableBuilder(column: $table.extendsId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get prerequisites => $composableBuilder(
    column: $table.prerequisites,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get repeatable => $composableBuilder(
    column: $table.repeatable,
    builder: (column) => column,
  );

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeatsTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $FeatsTable,
          FeatRow,
          $$FeatsTableFilterComposer,
          $$FeatsTableOrderingComposer,
          $$FeatsTableAnnotationComposer,
          $$FeatsTableCreateCompanionBuilder,
          $$FeatsTableUpdateCompanionBuilder,
          (FeatRow, $$FeatsTableReferences),
          FeatRow,
          PrefetchHooks Function({bool packId})
        > {
  $$FeatsTableTableManager(_$TavernierDatabase db, $FeatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> extendsId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> prerequisites = const Value.absent(),
                Value<bool> repeatable = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FeatsCompanion(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                category: category,
                prerequisites: prerequisites,
                repeatable: repeatable,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required String name,
                Value<String?> extendsId = const Value.absent(),
                required String category,
                Value<String?> prerequisites = const Value.absent(),
                required bool repeatable,
                Value<int> rowid = const Value.absent(),
              }) => FeatsCompanion.insert(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                category: category,
                prerequisites: prerequisites,
                repeatable: repeatable,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FeatsTable, FeatRow>(table),
                  $$FeatsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$FeatsTableReferences._packIdTable(
                          db,
                        ),
                        referencedColumn: $$FeatsTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FeatsTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $FeatsTable,
      FeatRow,
      $$FeatsTableFilterComposer,
      $$FeatsTableOrderingComposer,
      $$FeatsTableAnnotationComposer,
      $$FeatsTableCreateCompanionBuilder,
      $$FeatsTableUpdateCompanionBuilder,
      (FeatRow, $$FeatsTableReferences),
      FeatRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$SpeciesTableTableCreateCompanionBuilder =
    SpeciesTableCompanion Function({
      required String id,
      required String packId,
      required String name,
      Value<String?> extendsId,
      required String creatureType,
      required String sizes,
      required int speedFeet,
      Value<int> rowid,
    });
typedef $$SpeciesTableTableUpdateCompanionBuilder =
    SpeciesTableCompanion Function({
      Value<String> id,
      Value<String> packId,
      Value<String> name,
      Value<String?> extendsId,
      Value<String> creatureType,
      Value<String> sizes,
      Value<int> speedFeet,
      Value<int> rowid,
    });

final class $$SpeciesTableTableReferences
    extends
        BaseReferences<_$TavernierDatabase, $SpeciesTableTable, SpeciesRow> {
  $$SpeciesTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('species__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SpeciesTableTableFilterComposer
    extends Composer<_$TavernierDatabase, $SpeciesTableTable> {
  $$SpeciesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creatureType => $composableBuilder(
    column: $table.creatureType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sizes => $composableBuilder(
    column: $table.sizes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get speedFeet => $composableBuilder(
    column: $table.speedFeet,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpeciesTableTableOrderingComposer
    extends Composer<_$TavernierDatabase, $SpeciesTableTable> {
  $$SpeciesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creatureType => $composableBuilder(
    column: $table.creatureType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sizes => $composableBuilder(
    column: $table.sizes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get speedFeet => $composableBuilder(
    column: $table.speedFeet,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpeciesTableTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $SpeciesTableTable> {
  $$SpeciesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get extendsId =>
      $composableBuilder(column: $table.extendsId, builder: (column) => column);

  GeneratedColumn<String> get creatureType => $composableBuilder(
    column: $table.creatureType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sizes =>
      $composableBuilder(column: $table.sizes, builder: (column) => column);

  GeneratedColumn<int> get speedFeet =>
      $composableBuilder(column: $table.speedFeet, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpeciesTableTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $SpeciesTableTable,
          SpeciesRow,
          $$SpeciesTableTableFilterComposer,
          $$SpeciesTableTableOrderingComposer,
          $$SpeciesTableTableAnnotationComposer,
          $$SpeciesTableTableCreateCompanionBuilder,
          $$SpeciesTableTableUpdateCompanionBuilder,
          (SpeciesRow, $$SpeciesTableTableReferences),
          SpeciesRow,
          PrefetchHooks Function({bool packId})
        > {
  $$SpeciesTableTableTableManager(
    _$TavernierDatabase db,
    $SpeciesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpeciesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpeciesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpeciesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> extendsId = const Value.absent(),
                Value<String> creatureType = const Value.absent(),
                Value<String> sizes = const Value.absent(),
                Value<int> speedFeet = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SpeciesTableCompanion(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                creatureType: creatureType,
                sizes: sizes,
                speedFeet: speedFeet,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required String name,
                Value<String?> extendsId = const Value.absent(),
                required String creatureType,
                required String sizes,
                required int speedFeet,
                Value<int> rowid = const Value.absent(),
              }) => SpeciesTableCompanion.insert(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                creatureType: creatureType,
                sizes: sizes,
                speedFeet: speedFeet,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SpeciesTableTable, SpeciesRow>(table),
                  $$SpeciesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$SpeciesTableTableReferences
                            ._packIdTable(db),
                        referencedColumn: $$SpeciesTableTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SpeciesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $SpeciesTableTable,
      SpeciesRow,
      $$SpeciesTableTableFilterComposer,
      $$SpeciesTableTableOrderingComposer,
      $$SpeciesTableTableAnnotationComposer,
      $$SpeciesTableTableCreateCompanionBuilder,
      $$SpeciesTableTableUpdateCompanionBuilder,
      (SpeciesRow, $$SpeciesTableTableReferences),
      SpeciesRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$SpeciesTraitsTableCreateCompanionBuilder =
    SpeciesTraitsCompanion Function({
      required String packId,
      required String speciesId,
      required int position,
      required String featureId,
      Value<int> rowid,
    });
typedef $$SpeciesTraitsTableUpdateCompanionBuilder =
    SpeciesTraitsCompanion Function({
      Value<String> packId,
      Value<String> speciesId,
      Value<int> position,
      Value<String> featureId,
      Value<int> rowid,
    });

final class $$SpeciesTraitsTableReferences
    extends
        BaseReferences<
          _$TavernierDatabase,
          $SpeciesTraitsTable,
          SpeciesTraitRow
        > {
  $$SpeciesTraitsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('species_trait__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SpeciesTraitsTableFilterComposer
    extends Composer<_$TavernierDatabase, $SpeciesTraitsTable> {
  $$SpeciesTraitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get speciesId => $composableBuilder(
    column: $table.speciesId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get featureId => $composableBuilder(
    column: $table.featureId,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpeciesTraitsTableOrderingComposer
    extends Composer<_$TavernierDatabase, $SpeciesTraitsTable> {
  $$SpeciesTraitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get speciesId => $composableBuilder(
    column: $table.speciesId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get featureId => $composableBuilder(
    column: $table.featureId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpeciesTraitsTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $SpeciesTraitsTable> {
  $$SpeciesTraitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get speciesId =>
      $composableBuilder(column: $table.speciesId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get featureId =>
      $composableBuilder(column: $table.featureId, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpeciesTraitsTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $SpeciesTraitsTable,
          SpeciesTraitRow,
          $$SpeciesTraitsTableFilterComposer,
          $$SpeciesTraitsTableOrderingComposer,
          $$SpeciesTraitsTableAnnotationComposer,
          $$SpeciesTraitsTableCreateCompanionBuilder,
          $$SpeciesTraitsTableUpdateCompanionBuilder,
          (SpeciesTraitRow, $$SpeciesTraitsTableReferences),
          SpeciesTraitRow,
          PrefetchHooks Function({bool packId})
        > {
  $$SpeciesTraitsTableTableManager(
    _$TavernierDatabase db,
    $SpeciesTraitsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpeciesTraitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpeciesTraitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpeciesTraitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> packId = const Value.absent(),
                Value<String> speciesId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> featureId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SpeciesTraitsCompanion(
                packId: packId,
                speciesId: speciesId,
                position: position,
                featureId: featureId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packId,
                required String speciesId,
                required int position,
                required String featureId,
                Value<int> rowid = const Value.absent(),
              }) => SpeciesTraitsCompanion.insert(
                packId: packId,
                speciesId: speciesId,
                position: position,
                featureId: featureId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SpeciesTraitsTable, SpeciesTraitRow>(table),
                  $$SpeciesTraitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$SpeciesTraitsTableReferences
                            ._packIdTable(db),
                        referencedColumn: $$SpeciesTraitsTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SpeciesTraitsTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $SpeciesTraitsTable,
      SpeciesTraitRow,
      $$SpeciesTraitsTableFilterComposer,
      $$SpeciesTraitsTableOrderingComposer,
      $$SpeciesTraitsTableAnnotationComposer,
      $$SpeciesTraitsTableCreateCompanionBuilder,
      $$SpeciesTraitsTableUpdateCompanionBuilder,
      (SpeciesTraitRow, $$SpeciesTraitsTableReferences),
      SpeciesTraitRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$ClassesTableCreateCompanionBuilder = ClassesCompanion Function({
  required String id,
  required String packId,
  required String name,
  Value<String?> extendsId,
  required int hitDie,
  required String primaryAbilities,
  required String savingThrows,
  required int skillChoiceCount,
  required String skillChoices,
  required String weaponProficiencies,
  required String armorTraining,
  required int subclassLevel,
  Value<int> rowid,
});
typedef $$ClassesTableUpdateCompanionBuilder = ClassesCompanion Function({
  Value<String> id,
  Value<String> packId,
  Value<String> name,
  Value<String?> extendsId,
  Value<int> hitDie,
  Value<String> primaryAbilities,
  Value<String> savingThrows,
  Value<int> skillChoiceCount,
  Value<String> skillChoices,
  Value<String> weaponProficiencies,
  Value<String> armorTraining,
  Value<int> subclassLevel,
  Value<int> rowid,
});

final class $$ClassesTableReferences
    extends BaseReferences<_$TavernierDatabase, $ClassesTable, ClassRow> {
  $$ClassesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('class__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ClassesTableFilterComposer
    extends Composer<_$TavernierDatabase, $ClassesTable> {
  $$ClassesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hitDie => $composableBuilder(
    column: $table.hitDie,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryAbilities => $composableBuilder(
    column: $table.primaryAbilities,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get savingThrows => $composableBuilder(
    column: $table.savingThrows,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get skillChoiceCount => $composableBuilder(
    column: $table.skillChoiceCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get skillChoices => $composableBuilder(
    column: $table.skillChoices,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weaponProficiencies => $composableBuilder(
    column: $table.weaponProficiencies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get armorTraining => $composableBuilder(
    column: $table.armorTraining,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subclassLevel => $composableBuilder(
    column: $table.subclassLevel,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClassesTableOrderingComposer
    extends Composer<_$TavernierDatabase, $ClassesTable> {
  $$ClassesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hitDie => $composableBuilder(
    column: $table.hitDie,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryAbilities => $composableBuilder(
    column: $table.primaryAbilities,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get savingThrows => $composableBuilder(
    column: $table.savingThrows,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get skillChoiceCount => $composableBuilder(
    column: $table.skillChoiceCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skillChoices => $composableBuilder(
    column: $table.skillChoices,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weaponProficiencies => $composableBuilder(
    column: $table.weaponProficiencies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get armorTraining => $composableBuilder(
    column: $table.armorTraining,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subclassLevel => $composableBuilder(
    column: $table.subclassLevel,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClassesTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $ClassesTable> {
  $$ClassesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get extendsId =>
      $composableBuilder(column: $table.extendsId, builder: (column) => column);

  GeneratedColumn<int> get hitDie =>
      $composableBuilder(column: $table.hitDie, builder: (column) => column);

  GeneratedColumn<String> get primaryAbilities => $composableBuilder(
    column: $table.primaryAbilities,
    builder: (column) => column,
  );

  GeneratedColumn<String> get savingThrows => $composableBuilder(
    column: $table.savingThrows,
    builder: (column) => column,
  );

  GeneratedColumn<int> get skillChoiceCount => $composableBuilder(
    column: $table.skillChoiceCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get skillChoices => $composableBuilder(
    column: $table.skillChoices,
    builder: (column) => column,
  );

  GeneratedColumn<String> get weaponProficiencies => $composableBuilder(
    column: $table.weaponProficiencies,
    builder: (column) => column,
  );

  GeneratedColumn<String> get armorTraining => $composableBuilder(
    column: $table.armorTraining,
    builder: (column) => column,
  );

  GeneratedColumn<int> get subclassLevel => $composableBuilder(
    column: $table.subclassLevel,
    builder: (column) => column,
  );

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClassesTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $ClassesTable,
          ClassRow,
          $$ClassesTableFilterComposer,
          $$ClassesTableOrderingComposer,
          $$ClassesTableAnnotationComposer,
          $$ClassesTableCreateCompanionBuilder,
          $$ClassesTableUpdateCompanionBuilder,
          (ClassRow, $$ClassesTableReferences),
          ClassRow,
          PrefetchHooks Function({bool packId})
        > {
  $$ClassesTableTableManager(_$TavernierDatabase db, $ClassesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClassesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClassesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClassesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> extendsId = const Value.absent(),
                Value<int> hitDie = const Value.absent(),
                Value<String> primaryAbilities = const Value.absent(),
                Value<String> savingThrows = const Value.absent(),
                Value<int> skillChoiceCount = const Value.absent(),
                Value<String> skillChoices = const Value.absent(),
                Value<String> weaponProficiencies = const Value.absent(),
                Value<String> armorTraining = const Value.absent(),
                Value<int> subclassLevel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClassesCompanion(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                hitDie: hitDie,
                primaryAbilities: primaryAbilities,
                savingThrows: savingThrows,
                skillChoiceCount: skillChoiceCount,
                skillChoices: skillChoices,
                weaponProficiencies: weaponProficiencies,
                armorTraining: armorTraining,
                subclassLevel: subclassLevel,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required String name,
                Value<String?> extendsId = const Value.absent(),
                required int hitDie,
                required String primaryAbilities,
                required String savingThrows,
                required int skillChoiceCount,
                required String skillChoices,
                required String weaponProficiencies,
                required String armorTraining,
                required int subclassLevel,
                Value<int> rowid = const Value.absent(),
              }) => ClassesCompanion.insert(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                hitDie: hitDie,
                primaryAbilities: primaryAbilities,
                savingThrows: savingThrows,
                skillChoiceCount: skillChoiceCount,
                skillChoices: skillChoices,
                weaponProficiencies: weaponProficiencies,
                armorTraining: armorTraining,
                subclassLevel: subclassLevel,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ClassesTable, ClassRow>(table),
                  $$ClassesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$ClassesTableReferences._packIdTable(
                          db,
                        ),
                        referencedColumn: $$ClassesTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ClassesTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $ClassesTable,
      ClassRow,
      $$ClassesTableFilterComposer,
      $$ClassesTableOrderingComposer,
      $$ClassesTableAnnotationComposer,
      $$ClassesTableCreateCompanionBuilder,
      $$ClassesTableUpdateCompanionBuilder,
      (ClassRow, $$ClassesTableReferences),
      ClassRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$ClassLevelsTableCreateCompanionBuilder =
    ClassLevelsCompanion Function({
      required String packId,
      required String classId,
      required int level,
      required int profBonus,
      required String features,
      required String columns,
      Value<int> rowid,
    });
typedef $$ClassLevelsTableUpdateCompanionBuilder =
    ClassLevelsCompanion Function({
      Value<String> packId,
      Value<String> classId,
      Value<int> level,
      Value<int> profBonus,
      Value<String> features,
      Value<String> columns,
      Value<int> rowid,
    });

final class $$ClassLevelsTableReferences
    extends
        BaseReferences<_$TavernierDatabase, $ClassLevelsTable, ClassLevelRow> {
  $$ClassLevelsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('class_level__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ClassLevelsTableFilterComposer
    extends Composer<_$TavernierDatabase, $ClassLevelsTable> {
  $$ClassLevelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get classId => $composableBuilder(
    column: $table.classId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get profBonus => $composableBuilder(
    column: $table.profBonus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get features => $composableBuilder(
    column: $table.features,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get columns => $composableBuilder(
    column: $table.columns,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClassLevelsTableOrderingComposer
    extends Composer<_$TavernierDatabase, $ClassLevelsTable> {
  $$ClassLevelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get classId => $composableBuilder(
    column: $table.classId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get profBonus => $composableBuilder(
    column: $table.profBonus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get features => $composableBuilder(
    column: $table.features,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get columns => $composableBuilder(
    column: $table.columns,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClassLevelsTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $ClassLevelsTable> {
  $$ClassLevelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get classId =>
      $composableBuilder(column: $table.classId, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get profBonus =>
      $composableBuilder(column: $table.profBonus, builder: (column) => column);

  GeneratedColumn<String> get features =>
      $composableBuilder(column: $table.features, builder: (column) => column);

  GeneratedColumn<String> get columns =>
      $composableBuilder(column: $table.columns, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClassLevelsTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $ClassLevelsTable,
          ClassLevelRow,
          $$ClassLevelsTableFilterComposer,
          $$ClassLevelsTableOrderingComposer,
          $$ClassLevelsTableAnnotationComposer,
          $$ClassLevelsTableCreateCompanionBuilder,
          $$ClassLevelsTableUpdateCompanionBuilder,
          (ClassLevelRow, $$ClassLevelsTableReferences),
          ClassLevelRow,
          PrefetchHooks Function({bool packId})
        > {
  $$ClassLevelsTableTableManager(
    _$TavernierDatabase db,
    $ClassLevelsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClassLevelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClassLevelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClassLevelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> packId = const Value.absent(),
                Value<String> classId = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> profBonus = const Value.absent(),
                Value<String> features = const Value.absent(),
                Value<String> columns = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClassLevelsCompanion(
                packId: packId,
                classId: classId,
                level: level,
                profBonus: profBonus,
                features: features,
                columns: columns,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packId,
                required String classId,
                required int level,
                required int profBonus,
                required String features,
                required String columns,
                Value<int> rowid = const Value.absent(),
              }) => ClassLevelsCompanion.insert(
                packId: packId,
                classId: classId,
                level: level,
                profBonus: profBonus,
                features: features,
                columns: columns,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ClassLevelsTable, ClassLevelRow>(table),
                  $$ClassLevelsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$ClassLevelsTableReferences
                            ._packIdTable(db),
                        referencedColumn: $$ClassLevelsTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ClassLevelsTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $ClassLevelsTable,
      ClassLevelRow,
      $$ClassLevelsTableFilterComposer,
      $$ClassLevelsTableOrderingComposer,
      $$ClassLevelsTableAnnotationComposer,
      $$ClassLevelsTableCreateCompanionBuilder,
      $$ClassLevelsTableUpdateCompanionBuilder,
      (ClassLevelRow, $$ClassLevelsTableReferences),
      ClassLevelRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$SubclassesTableCreateCompanionBuilder = SubclassesCompanion Function({
  required String id,
  required String packId,
  required String name,
  Value<String?> extendsId,
  required String parentClassId,
  Value<int> rowid,
});
typedef $$SubclassesTableUpdateCompanionBuilder = SubclassesCompanion Function({
  Value<String> id,
  Value<String> packId,
  Value<String> name,
  Value<String?> extendsId,
  Value<String> parentClassId,
  Value<int> rowid,
});

final class $$SubclassesTableReferences
    extends BaseReferences<_$TavernierDatabase, $SubclassesTable, SubclassRow> {
  $$SubclassesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('subclass__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SubclassesTableFilterComposer
    extends Composer<_$TavernierDatabase, $SubclassesTable> {
  $$SubclassesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentClassId => $composableBuilder(
    column: $table.parentClassId,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubclassesTableOrderingComposer
    extends Composer<_$TavernierDatabase, $SubclassesTable> {
  $$SubclassesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentClassId => $composableBuilder(
    column: $table.parentClassId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubclassesTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $SubclassesTable> {
  $$SubclassesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get extendsId =>
      $composableBuilder(column: $table.extendsId, builder: (column) => column);

  GeneratedColumn<String> get parentClassId => $composableBuilder(
    column: $table.parentClassId,
    builder: (column) => column,
  );

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubclassesTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $SubclassesTable,
          SubclassRow,
          $$SubclassesTableFilterComposer,
          $$SubclassesTableOrderingComposer,
          $$SubclassesTableAnnotationComposer,
          $$SubclassesTableCreateCompanionBuilder,
          $$SubclassesTableUpdateCompanionBuilder,
          (SubclassRow, $$SubclassesTableReferences),
          SubclassRow,
          PrefetchHooks Function({bool packId})
        > {
  $$SubclassesTableTableManager(_$TavernierDatabase db, $SubclassesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubclassesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubclassesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubclassesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> extendsId = const Value.absent(),
                Value<String> parentClassId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubclassesCompanion(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                parentClassId: parentClassId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required String name,
                Value<String?> extendsId = const Value.absent(),
                required String parentClassId,
                Value<int> rowid = const Value.absent(),
              }) => SubclassesCompanion.insert(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                parentClassId: parentClassId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SubclassesTable, SubclassRow>(table),
                  $$SubclassesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$SubclassesTableReferences
                            ._packIdTable(db),
                        referencedColumn: $$SubclassesTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SubclassesTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $SubclassesTable,
      SubclassRow,
      $$SubclassesTableFilterComposer,
      $$SubclassesTableOrderingComposer,
      $$SubclassesTableAnnotationComposer,
      $$SubclassesTableCreateCompanionBuilder,
      $$SubclassesTableUpdateCompanionBuilder,
      (SubclassRow, $$SubclassesTableReferences),
      SubclassRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$SubclassFeaturesTableCreateCompanionBuilder =
    SubclassFeaturesCompanion Function({
      required String packId,
      required String subclassId,
      required int position,
      required String featureId,
      Value<int> rowid,
    });
typedef $$SubclassFeaturesTableUpdateCompanionBuilder =
    SubclassFeaturesCompanion Function({
      Value<String> packId,
      Value<String> subclassId,
      Value<int> position,
      Value<String> featureId,
      Value<int> rowid,
    });

final class $$SubclassFeaturesTableReferences
    extends
        BaseReferences<
          _$TavernierDatabase,
          $SubclassFeaturesTable,
          SubclassFeatureRow
        > {
  $$SubclassFeaturesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) => db
      .contentPacks
      .createAlias('subclass_feature__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SubclassFeaturesTableFilterComposer
    extends Composer<_$TavernierDatabase, $SubclassFeaturesTable> {
  $$SubclassFeaturesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get subclassId => $composableBuilder(
    column: $table.subclassId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get featureId => $composableBuilder(
    column: $table.featureId,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubclassFeaturesTableOrderingComposer
    extends Composer<_$TavernierDatabase, $SubclassFeaturesTable> {
  $$SubclassFeaturesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get subclassId => $composableBuilder(
    column: $table.subclassId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get featureId => $composableBuilder(
    column: $table.featureId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubclassFeaturesTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $SubclassFeaturesTable> {
  $$SubclassFeaturesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get subclassId => $composableBuilder(
    column: $table.subclassId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get featureId =>
      $composableBuilder(column: $table.featureId, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubclassFeaturesTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $SubclassFeaturesTable,
          SubclassFeatureRow,
          $$SubclassFeaturesTableFilterComposer,
          $$SubclassFeaturesTableOrderingComposer,
          $$SubclassFeaturesTableAnnotationComposer,
          $$SubclassFeaturesTableCreateCompanionBuilder,
          $$SubclassFeaturesTableUpdateCompanionBuilder,
          (SubclassFeatureRow, $$SubclassFeaturesTableReferences),
          SubclassFeatureRow,
          PrefetchHooks Function({bool packId})
        > {
  $$SubclassFeaturesTableTableManager(
    _$TavernierDatabase db,
    $SubclassFeaturesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubclassFeaturesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubclassFeaturesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubclassFeaturesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> packId = const Value.absent(),
                Value<String> subclassId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> featureId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubclassFeaturesCompanion(
                packId: packId,
                subclassId: subclassId,
                position: position,
                featureId: featureId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packId,
                required String subclassId,
                required int position,
                required String featureId,
                Value<int> rowid = const Value.absent(),
              }) => SubclassFeaturesCompanion.insert(
                packId: packId,
                subclassId: subclassId,
                position: position,
                featureId: featureId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SubclassFeaturesTable, SubclassFeatureRow>(
                    table,
                  ),
                  $$SubclassFeaturesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$SubclassFeaturesTableReferences
                            ._packIdTable(db),
                        referencedColumn: $$SubclassFeaturesTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SubclassFeaturesTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $SubclassFeaturesTable,
      SubclassFeatureRow,
      $$SubclassFeaturesTableFilterComposer,
      $$SubclassFeaturesTableOrderingComposer,
      $$SubclassFeaturesTableAnnotationComposer,
      $$SubclassFeaturesTableCreateCompanionBuilder,
      $$SubclassFeaturesTableUpdateCompanionBuilder,
      (SubclassFeatureRow, $$SubclassFeaturesTableReferences),
      SubclassFeatureRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$FeaturesTableCreateCompanionBuilder = FeaturesCompanion Function({
  required String id,
  required String packId,
  required String name,
  Value<String?> extendsId,
  required String sourceId,
  Value<int?> level,
  Value<int> rowid,
});
typedef $$FeaturesTableUpdateCompanionBuilder = FeaturesCompanion Function({
  Value<String> id,
  Value<String> packId,
  Value<String> name,
  Value<String?> extendsId,
  Value<String> sourceId,
  Value<int?> level,
  Value<int> rowid,
});

final class $$FeaturesTableReferences
    extends BaseReferences<_$TavernierDatabase, $FeaturesTable, FeatureRow> {
  $$FeaturesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('feature__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FeaturesTableFilterComposer
    extends Composer<_$TavernierDatabase, $FeaturesTable> {
  $$FeaturesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeaturesTableOrderingComposer
    extends Composer<_$TavernierDatabase, $FeaturesTable> {
  $$FeaturesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeaturesTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $FeaturesTable> {
  $$FeaturesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get extendsId =>
      $composableBuilder(column: $table.extendsId, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeaturesTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $FeaturesTable,
          FeatureRow,
          $$FeaturesTableFilterComposer,
          $$FeaturesTableOrderingComposer,
          $$FeaturesTableAnnotationComposer,
          $$FeaturesTableCreateCompanionBuilder,
          $$FeaturesTableUpdateCompanionBuilder,
          (FeatureRow, $$FeaturesTableReferences),
          FeatureRow,
          PrefetchHooks Function({bool packId})
        > {
  $$FeaturesTableTableManager(_$TavernierDatabase db, $FeaturesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeaturesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeaturesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeaturesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> extendsId = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<int?> level = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FeaturesCompanion(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                sourceId: sourceId,
                level: level,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required String name,
                Value<String?> extendsId = const Value.absent(),
                required String sourceId,
                Value<int?> level = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FeaturesCompanion.insert(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                sourceId: sourceId,
                level: level,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FeaturesTable, FeatureRow>(table),
                  $$FeaturesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$FeaturesTableReferences._packIdTable(
                          db,
                        ),
                        referencedColumn: $$FeaturesTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FeaturesTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $FeaturesTable,
      FeatureRow,
      $$FeaturesTableFilterComposer,
      $$FeaturesTableOrderingComposer,
      $$FeaturesTableAnnotationComposer,
      $$FeaturesTableCreateCompanionBuilder,
      $$FeaturesTableUpdateCompanionBuilder,
      (FeatureRow, $$FeaturesTableReferences),
      FeatureRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$SpellsTableCreateCompanionBuilder = SpellsCompanion Function({
  required String id,
  required String packId,
  required String name,
  Value<String?> extendsId,
  required int level,
  required String school,
  required String castingTime,
  required String range,
  required String components,
  Value<int?> materialCostCp,
  required bool materialConsumed,
  required String duration,
  required bool concentration,
  required bool ritual,
  Value<int> rowid,
});
typedef $$SpellsTableUpdateCompanionBuilder = SpellsCompanion Function({
  Value<String> id,
  Value<String> packId,
  Value<String> name,
  Value<String?> extendsId,
  Value<int> level,
  Value<String> school,
  Value<String> castingTime,
  Value<String> range,
  Value<String> components,
  Value<int?> materialCostCp,
  Value<bool> materialConsumed,
  Value<String> duration,
  Value<bool> concentration,
  Value<bool> ritual,
  Value<int> rowid,
});

final class $$SpellsTableReferences
    extends BaseReferences<_$TavernierDatabase, $SpellsTable, SpellRow> {
  $$SpellsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('spell__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SpellsTableFilterComposer
    extends Composer<_$TavernierDatabase, $SpellsTable> {
  $$SpellsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get school => $composableBuilder(
    column: $table.school,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get castingTime => $composableBuilder(
    column: $table.castingTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get range => $composableBuilder(
    column: $table.range,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get components => $composableBuilder(
    column: $table.components,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get materialCostCp => $composableBuilder(
    column: $table.materialCostCp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get materialConsumed => $composableBuilder(
    column: $table.materialConsumed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get concentration => $composableBuilder(
    column: $table.concentration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ritual => $composableBuilder(
    column: $table.ritual,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpellsTableOrderingComposer
    extends Composer<_$TavernierDatabase, $SpellsTable> {
  $$SpellsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get school => $composableBuilder(
    column: $table.school,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get castingTime => $composableBuilder(
    column: $table.castingTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get range => $composableBuilder(
    column: $table.range,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get components => $composableBuilder(
    column: $table.components,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get materialCostCp => $composableBuilder(
    column: $table.materialCostCp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get materialConsumed => $composableBuilder(
    column: $table.materialConsumed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get concentration => $composableBuilder(
    column: $table.concentration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ritual => $composableBuilder(
    column: $table.ritual,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpellsTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $SpellsTable> {
  $$SpellsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get extendsId =>
      $composableBuilder(column: $table.extendsId, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get school =>
      $composableBuilder(column: $table.school, builder: (column) => column);

  GeneratedColumn<String> get castingTime => $composableBuilder(
    column: $table.castingTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get range =>
      $composableBuilder(column: $table.range, builder: (column) => column);

  GeneratedColumn<String> get components => $composableBuilder(
    column: $table.components,
    builder: (column) => column,
  );

  GeneratedColumn<int> get materialCostCp => $composableBuilder(
    column: $table.materialCostCp,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get materialConsumed => $composableBuilder(
    column: $table.materialConsumed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<bool> get concentration => $composableBuilder(
    column: $table.concentration,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get ritual =>
      $composableBuilder(column: $table.ritual, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpellsTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $SpellsTable,
          SpellRow,
          $$SpellsTableFilterComposer,
          $$SpellsTableOrderingComposer,
          $$SpellsTableAnnotationComposer,
          $$SpellsTableCreateCompanionBuilder,
          $$SpellsTableUpdateCompanionBuilder,
          (SpellRow, $$SpellsTableReferences),
          SpellRow,
          PrefetchHooks Function({bool packId})
        > {
  $$SpellsTableTableManager(_$TavernierDatabase db, $SpellsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpellsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpellsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpellsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> extendsId = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String> school = const Value.absent(),
                Value<String> castingTime = const Value.absent(),
                Value<String> range = const Value.absent(),
                Value<String> components = const Value.absent(),
                Value<int?> materialCostCp = const Value.absent(),
                Value<bool> materialConsumed = const Value.absent(),
                Value<String> duration = const Value.absent(),
                Value<bool> concentration = const Value.absent(),
                Value<bool> ritual = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SpellsCompanion(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                level: level,
                school: school,
                castingTime: castingTime,
                range: range,
                components: components,
                materialCostCp: materialCostCp,
                materialConsumed: materialConsumed,
                duration: duration,
                concentration: concentration,
                ritual: ritual,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required String name,
                Value<String?> extendsId = const Value.absent(),
                required int level,
                required String school,
                required String castingTime,
                required String range,
                required String components,
                Value<int?> materialCostCp = const Value.absent(),
                required bool materialConsumed,
                required String duration,
                required bool concentration,
                required bool ritual,
                Value<int> rowid = const Value.absent(),
              }) => SpellsCompanion.insert(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                level: level,
                school: school,
                castingTime: castingTime,
                range: range,
                components: components,
                materialCostCp: materialCostCp,
                materialConsumed: materialConsumed,
                duration: duration,
                concentration: concentration,
                ritual: ritual,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SpellsTable, SpellRow>(table),
                  $$SpellsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$SpellsTableReferences._packIdTable(
                          db,
                        ),
                        referencedColumn: $$SpellsTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SpellsTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $SpellsTable,
      SpellRow,
      $$SpellsTableFilterComposer,
      $$SpellsTableOrderingComposer,
      $$SpellsTableAnnotationComposer,
      $$SpellsTableCreateCompanionBuilder,
      $$SpellsTableUpdateCompanionBuilder,
      (SpellRow, $$SpellsTableReferences),
      SpellRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$SpellClassesTableCreateCompanionBuilder =
    SpellClassesCompanion Function({
      required String packId,
      required String spellId,
      required String classId,
      Value<int> rowid,
    });
typedef $$SpellClassesTableUpdateCompanionBuilder =
    SpellClassesCompanion Function({
      Value<String> packId,
      Value<String> spellId,
      Value<String> classId,
      Value<int> rowid,
    });

final class $$SpellClassesTableReferences
    extends
        BaseReferences<_$TavernierDatabase, $SpellClassesTable, SpellClassRow> {
  $$SpellClassesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('spell_class__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SpellClassesTableFilterComposer
    extends Composer<_$TavernierDatabase, $SpellClassesTable> {
  $$SpellClassesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get spellId => $composableBuilder(
    column: $table.spellId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classId => $composableBuilder(
    column: $table.classId,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpellClassesTableOrderingComposer
    extends Composer<_$TavernierDatabase, $SpellClassesTable> {
  $$SpellClassesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get spellId => $composableBuilder(
    column: $table.spellId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classId => $composableBuilder(
    column: $table.classId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpellClassesTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $SpellClassesTable> {
  $$SpellClassesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get spellId =>
      $composableBuilder(column: $table.spellId, builder: (column) => column);

  GeneratedColumn<String> get classId =>
      $composableBuilder(column: $table.classId, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpellClassesTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $SpellClassesTable,
          SpellClassRow,
          $$SpellClassesTableFilterComposer,
          $$SpellClassesTableOrderingComposer,
          $$SpellClassesTableAnnotationComposer,
          $$SpellClassesTableCreateCompanionBuilder,
          $$SpellClassesTableUpdateCompanionBuilder,
          (SpellClassRow, $$SpellClassesTableReferences),
          SpellClassRow,
          PrefetchHooks Function({bool packId})
        > {
  $$SpellClassesTableTableManager(
    _$TavernierDatabase db,
    $SpellClassesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpellClassesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpellClassesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpellClassesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> packId = const Value.absent(),
                Value<String> spellId = const Value.absent(),
                Value<String> classId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SpellClassesCompanion(
                packId: packId,
                spellId: spellId,
                classId: classId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packId,
                required String spellId,
                required String classId,
                Value<int> rowid = const Value.absent(),
              }) => SpellClassesCompanion.insert(
                packId: packId,
                spellId: spellId,
                classId: classId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SpellClassesTable, SpellClassRow>(table),
                  $$SpellClassesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$SpellClassesTableReferences
                            ._packIdTable(db),
                        referencedColumn: $$SpellClassesTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SpellClassesTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $SpellClassesTable,
      SpellClassRow,
      $$SpellClassesTableFilterComposer,
      $$SpellClassesTableOrderingComposer,
      $$SpellClassesTableAnnotationComposer,
      $$SpellClassesTableCreateCompanionBuilder,
      $$SpellClassesTableUpdateCompanionBuilder,
      (SpellClassRow, $$SpellClassesTableReferences),
      SpellClassRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$MonstersTableCreateCompanionBuilder = MonstersCompanion Function({
  required String id,
  required String packId,
  required String name,
  Value<String?> extendsId,
  required String creatureType,
  required String challengeRating,
  required int xp,
  required int intelligence,
  required String statBlock,
  Value<int> rowid,
});
typedef $$MonstersTableUpdateCompanionBuilder = MonstersCompanion Function({
  Value<String> id,
  Value<String> packId,
  Value<String> name,
  Value<String?> extendsId,
  Value<String> creatureType,
  Value<String> challengeRating,
  Value<int> xp,
  Value<int> intelligence,
  Value<String> statBlock,
  Value<int> rowid,
});

final class $$MonstersTableReferences
    extends BaseReferences<_$TavernierDatabase, $MonstersTable, MonsterRow> {
  $$MonstersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('monster__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MonstersTableFilterComposer
    extends Composer<_$TavernierDatabase, $MonstersTable> {
  $$MonstersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creatureType => $composableBuilder(
    column: $table.creatureType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get challengeRating => $composableBuilder(
    column: $table.challengeRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intelligence => $composableBuilder(
    column: $table.intelligence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statBlock => $composableBuilder(
    column: $table.statBlock,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MonstersTableOrderingComposer
    extends Composer<_$TavernierDatabase, $MonstersTable> {
  $$MonstersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extendsId => $composableBuilder(
    column: $table.extendsId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creatureType => $composableBuilder(
    column: $table.creatureType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get challengeRating => $composableBuilder(
    column: $table.challengeRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intelligence => $composableBuilder(
    column: $table.intelligence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statBlock => $composableBuilder(
    column: $table.statBlock,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MonstersTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $MonstersTable> {
  $$MonstersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get extendsId =>
      $composableBuilder(column: $table.extendsId, builder: (column) => column);

  GeneratedColumn<String> get creatureType => $composableBuilder(
    column: $table.creatureType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get challengeRating => $composableBuilder(
    column: $table.challengeRating,
    builder: (column) => column,
  );

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);

  GeneratedColumn<int> get intelligence => $composableBuilder(
    column: $table.intelligence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get statBlock =>
      $composableBuilder(column: $table.statBlock, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MonstersTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $MonstersTable,
          MonsterRow,
          $$MonstersTableFilterComposer,
          $$MonstersTableOrderingComposer,
          $$MonstersTableAnnotationComposer,
          $$MonstersTableCreateCompanionBuilder,
          $$MonstersTableUpdateCompanionBuilder,
          (MonsterRow, $$MonstersTableReferences),
          MonsterRow,
          PrefetchHooks Function({bool packId})
        > {
  $$MonstersTableTableManager(_$TavernierDatabase db, $MonstersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonstersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonstersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonstersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> extendsId = const Value.absent(),
                Value<String> creatureType = const Value.absent(),
                Value<String> challengeRating = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<int> intelligence = const Value.absent(),
                Value<String> statBlock = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MonstersCompanion(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                creatureType: creatureType,
                challengeRating: challengeRating,
                xp: xp,
                intelligence: intelligence,
                statBlock: statBlock,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required String name,
                Value<String?> extendsId = const Value.absent(),
                required String creatureType,
                required String challengeRating,
                required int xp,
                required int intelligence,
                required String statBlock,
                Value<int> rowid = const Value.absent(),
              }) => MonstersCompanion.insert(
                id: id,
                packId: packId,
                name: name,
                extendsId: extendsId,
                creatureType: creatureType,
                challengeRating: challengeRating,
                xp: xp,
                intelligence: intelligence,
                statBlock: statBlock,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MonstersTable, MonsterRow>(table),
                  $$MonstersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$MonstersTableReferences._packIdTable(
                          db,
                        ),
                        referencedColumn: $$MonstersTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MonstersTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $MonstersTable,
      MonsterRow,
      $$MonstersTableFilterComposer,
      $$MonstersTableOrderingComposer,
      $$MonstersTableAnnotationComposer,
      $$MonstersTableCreateCompanionBuilder,
      $$MonstersTableUpdateCompanionBuilder,
      (MonsterRow, $$MonstersTableReferences),
      MonsterRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$MonsterActionsTableCreateCompanionBuilder =
    MonsterActionsCompanion Function({
      required String packId,
      required String monsterId,
      required int position,
      required String kind,
      required String name,
      Value<String?> recharge,
      required String data,
      Value<int> rowid,
    });
typedef $$MonsterActionsTableUpdateCompanionBuilder =
    MonsterActionsCompanion Function({
      Value<String> packId,
      Value<String> monsterId,
      Value<int> position,
      Value<String> kind,
      Value<String> name,
      Value<String?> recharge,
      Value<String> data,
      Value<int> rowid,
    });

final class $$MonsterActionsTableReferences
    extends
        BaseReferences<
          _$TavernierDatabase,
          $MonsterActionsTable,
          MonsterActionRow
        > {
  $$MonsterActionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('monster_action__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MonsterActionsTableFilterComposer
    extends Composer<_$TavernierDatabase, $MonsterActionsTable> {
  $$MonsterActionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get monsterId => $composableBuilder(
    column: $table.monsterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recharge => $composableBuilder(
    column: $table.recharge,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MonsterActionsTableOrderingComposer
    extends Composer<_$TavernierDatabase, $MonsterActionsTable> {
  $$MonsterActionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get monsterId => $composableBuilder(
    column: $table.monsterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recharge => $composableBuilder(
    column: $table.recharge,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MonsterActionsTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $MonsterActionsTable> {
  $$MonsterActionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get monsterId =>
      $composableBuilder(column: $table.monsterId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get recharge =>
      $composableBuilder(column: $table.recharge, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MonsterActionsTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $MonsterActionsTable,
          MonsterActionRow,
          $$MonsterActionsTableFilterComposer,
          $$MonsterActionsTableOrderingComposer,
          $$MonsterActionsTableAnnotationComposer,
          $$MonsterActionsTableCreateCompanionBuilder,
          $$MonsterActionsTableUpdateCompanionBuilder,
          (MonsterActionRow, $$MonsterActionsTableReferences),
          MonsterActionRow,
          PrefetchHooks Function({bool packId})
        > {
  $$MonsterActionsTableTableManager(
    _$TavernierDatabase db,
    $MonsterActionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonsterActionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonsterActionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonsterActionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> packId = const Value.absent(),
                Value<String> monsterId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> recharge = const Value.absent(),
                Value<String> data = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MonsterActionsCompanion(
                packId: packId,
                monsterId: monsterId,
                position: position,
                kind: kind,
                name: name,
                recharge: recharge,
                data: data,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packId,
                required String monsterId,
                required int position,
                required String kind,
                required String name,
                Value<String?> recharge = const Value.absent(),
                required String data,
                Value<int> rowid = const Value.absent(),
              }) => MonsterActionsCompanion.insert(
                packId: packId,
                monsterId: monsterId,
                position: position,
                kind: kind,
                name: name,
                recharge: recharge,
                data: data,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MonsterActionsTable, MonsterActionRow>(table),
                  $$MonsterActionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$MonsterActionsTableReferences
                            ._packIdTable(db),
                        referencedColumn: $$MonsterActionsTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MonsterActionsTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $MonsterActionsTable,
      MonsterActionRow,
      $$MonsterActionsTableFilterComposer,
      $$MonsterActionsTableOrderingComposer,
      $$MonsterActionsTableAnnotationComposer,
      $$MonsterActionsTableCreateCompanionBuilder,
      $$MonsterActionsTableUpdateCompanionBuilder,
      (MonsterActionRow, $$MonsterActionsTableReferences),
      MonsterActionRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$StudyRevealsTableCreateCompanionBuilder =
    StudyRevealsCompanion Function({
      required String packId,
      required String monsterId,
      required int dc,
      required String revealText,
      Value<int> rowid,
    });
typedef $$StudyRevealsTableUpdateCompanionBuilder =
    StudyRevealsCompanion Function({
      Value<String> packId,
      Value<String> monsterId,
      Value<int> dc,
      Value<String> revealText,
      Value<int> rowid,
    });

final class $$StudyRevealsTableReferences
    extends
        BaseReferences<
          _$TavernierDatabase,
          $StudyRevealsTable,
          StudyRevealRow
        > {
  $$StudyRevealsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('study_reveal__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StudyRevealsTableFilterComposer
    extends Composer<_$TavernierDatabase, $StudyRevealsTable> {
  $$StudyRevealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get monsterId => $composableBuilder(
    column: $table.monsterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dc => $composableBuilder(
    column: $table.dc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revealText => $composableBuilder(
    column: $table.revealText,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyRevealsTableOrderingComposer
    extends Composer<_$TavernierDatabase, $StudyRevealsTable> {
  $$StudyRevealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get monsterId => $composableBuilder(
    column: $table.monsterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dc => $composableBuilder(
    column: $table.dc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revealText => $composableBuilder(
    column: $table.revealText,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyRevealsTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $StudyRevealsTable> {
  $$StudyRevealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get monsterId =>
      $composableBuilder(column: $table.monsterId, builder: (column) => column);

  GeneratedColumn<int> get dc =>
      $composableBuilder(column: $table.dc, builder: (column) => column);

  GeneratedColumn<String> get revealText => $composableBuilder(
    column: $table.revealText,
    builder: (column) => column,
  );

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyRevealsTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $StudyRevealsTable,
          StudyRevealRow,
          $$StudyRevealsTableFilterComposer,
          $$StudyRevealsTableOrderingComposer,
          $$StudyRevealsTableAnnotationComposer,
          $$StudyRevealsTableCreateCompanionBuilder,
          $$StudyRevealsTableUpdateCompanionBuilder,
          (StudyRevealRow, $$StudyRevealsTableReferences),
          StudyRevealRow,
          PrefetchHooks Function({bool packId})
        > {
  $$StudyRevealsTableTableManager(
    _$TavernierDatabase db,
    $StudyRevealsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyRevealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyRevealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyRevealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> packId = const Value.absent(),
                Value<String> monsterId = const Value.absent(),
                Value<int> dc = const Value.absent(),
                Value<String> revealText = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyRevealsCompanion(
                packId: packId,
                monsterId: monsterId,
                dc: dc,
                revealText: revealText,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packId,
                required String monsterId,
                required int dc,
                required String revealText,
                Value<int> rowid = const Value.absent(),
              }) => StudyRevealsCompanion.insert(
                packId: packId,
                monsterId: monsterId,
                dc: dc,
                revealText: revealText,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StudyRevealsTable, StudyRevealRow>(table),
                  $$StudyRevealsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$StudyRevealsTableReferences
                            ._packIdTable(db),
                        referencedColumn: $$StudyRevealsTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StudyRevealsTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $StudyRevealsTable,
      StudyRevealRow,
      $$StudyRevealsTableFilterComposer,
      $$StudyRevealsTableOrderingComposer,
      $$StudyRevealsTableAnnotationComposer,
      $$StudyRevealsTableCreateCompanionBuilder,
      $$StudyRevealsTableUpdateCompanionBuilder,
      (StudyRevealRow, $$StudyRevealsTableReferences),
      StudyRevealRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$EffectsTableCreateCompanionBuilder = EffectsCompanion Function({
  required String packId,
  required String ownerId,
  required String ownerType,
  required int position,
  required String payload,
  Value<int> rowid,
});
typedef $$EffectsTableUpdateCompanionBuilder = EffectsCompanion Function({
  Value<String> packId,
  Value<String> ownerId,
  Value<String> ownerType,
  Value<int> position,
  Value<String> payload,
  Value<int> rowid,
});

final class $$EffectsTableReferences
    extends BaseReferences<_$TavernierDatabase, $EffectsTable, EffectRow> {
  $$EffectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('effect__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EffectsTableFilterComposer
    extends Composer<_$TavernierDatabase, $EffectsTable> {
  $$EffectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerType => $composableBuilder(
    column: $table.ownerType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EffectsTableOrderingComposer
    extends Composer<_$TavernierDatabase, $EffectsTable> {
  $$EffectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerType => $composableBuilder(
    column: $table.ownerType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EffectsTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $EffectsTable> {
  $$EffectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get ownerType =>
      $composableBuilder(column: $table.ownerType, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EffectsTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $EffectsTable,
          EffectRow,
          $$EffectsTableFilterComposer,
          $$EffectsTableOrderingComposer,
          $$EffectsTableAnnotationComposer,
          $$EffectsTableCreateCompanionBuilder,
          $$EffectsTableUpdateCompanionBuilder,
          (EffectRow, $$EffectsTableReferences),
          EffectRow,
          PrefetchHooks Function({bool packId})
        > {
  $$EffectsTableTableManager(_$TavernierDatabase db, $EffectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EffectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EffectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EffectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> packId = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<String> ownerType = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EffectsCompanion(
                packId: packId,
                ownerId: ownerId,
                ownerType: ownerType,
                position: position,
                payload: payload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packId,
                required String ownerId,
                required String ownerType,
                required int position,
                required String payload,
                Value<int> rowid = const Value.absent(),
              }) => EffectsCompanion.insert(
                packId: packId,
                ownerId: ownerId,
                ownerType: ownerType,
                position: position,
                payload: payload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EffectsTable, EffectRow>(table),
                  $$EffectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$EffectsTableReferences._packIdTable(
                          db,
                        ),
                        referencedColumn: $$EffectsTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EffectsTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $EffectsTable,
      EffectRow,
      $$EffectsTableFilterComposer,
      $$EffectsTableOrderingComposer,
      $$EffectsTableAnnotationComposer,
      $$EffectsTableCreateCompanionBuilder,
      $$EffectsTableUpdateCompanionBuilder,
      (EffectRow, $$EffectsTableReferences),
      EffectRow,
      PrefetchHooks Function({bool packId})
    >;
typedef $$EntityTextsTableCreateCompanionBuilder =
    EntityTextsCompanion Function({
      required String packId,
      required String entityId,
      required String locale,
      required String description,
      Value<int> rowid,
    });
typedef $$EntityTextsTableUpdateCompanionBuilder =
    EntityTextsCompanion Function({
      Value<String> packId,
      Value<String> entityId,
      Value<String> locale,
      Value<String> description,
      Value<int> rowid,
    });

final class $$EntityTextsTableReferences
    extends
        BaseReferences<_$TavernierDatabase, $EntityTextsTable, EntityTextRow> {
  $$EntityTextsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$TavernierDatabase db) =>
      db.contentPacks.createAlias('entity_text__pack_id__content_pack__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EntityTextsTableFilterComposer
    extends Composer<_$TavernierDatabase, $EntityTextsTable> {
  $$EntityTextsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntityTextsTableOrderingComposer
    extends Composer<_$TavernierDatabase, $EntityTextsTable> {
  $$EntityTextsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntityTextsTableAnnotationComposer
    extends Composer<_$TavernierDatabase, $EntityTextsTable> {
  $$EntityTextsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntityTextsTableTableManager
    extends
        RootTableManager<
          _$TavernierDatabase,
          $EntityTextsTable,
          EntityTextRow,
          $$EntityTextsTableFilterComposer,
          $$EntityTextsTableOrderingComposer,
          $$EntityTextsTableAnnotationComposer,
          $$EntityTextsTableCreateCompanionBuilder,
          $$EntityTextsTableUpdateCompanionBuilder,
          (EntityTextRow, $$EntityTextsTableReferences),
          EntityTextRow,
          PrefetchHooks Function({bool packId})
        > {
  $$EntityTextsTableTableManager(
    _$TavernierDatabase db,
    $EntityTextsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntityTextsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntityTextsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntityTextsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> packId = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntityTextsCompanion(
                packId: packId,
                entityId: entityId,
                locale: locale,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packId,
                required String entityId,
                required String locale,
                required String description,
                Value<int> rowid = const Value.absent(),
              }) => EntityTextsCompanion.insert(
                packId: packId,
                entityId: entityId,
                locale: locale,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EntityTextsTable, EntityTextRow>(table),
                  $$EntityTextsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packId,
                        referencedTable: $$EntityTextsTableReferences
                            ._packIdTable(db),
                        referencedColumn: $$EntityTextsTableReferences
                            ._packIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EntityTextsTableProcessedTableManager =
    ProcessedTableManager<
      _$TavernierDatabase,
      $EntityTextsTable,
      EntityTextRow,
      $$EntityTextsTableFilterComposer,
      $$EntityTextsTableOrderingComposer,
      $$EntityTextsTableAnnotationComposer,
      $$EntityTextsTableCreateCompanionBuilder,
      $$EntityTextsTableUpdateCompanionBuilder,
      (EntityTextRow, $$EntityTextsTableReferences),
      EntityTextRow,
      PrefetchHooks Function({bool packId})
    >;

class $TavernierDatabaseManager {
  final _$TavernierDatabase _db;
  $TavernierDatabaseManager(this._db);
  $ContentSearchTableManager get contentSearch =>
      $ContentSearchTableManager(_db, _db.contentSearch);
  $$ContentPacksTableTableManager get contentPacks =>
      $$ContentPacksTableTableManager(_db, _db.contentPacks);
  $$PackDependenciesTableTableManager get packDependencies =>
      $$PackDependenciesTableTableManager(_db, _db.packDependencies);
  $$AbilitiesTableTableManager get abilities =>
      $$AbilitiesTableTableManager(_db, _db.abilities);
  $$SkillsTableTableManager get skills =>
      $$SkillsTableTableManager(_db, _db.skills);
  $$LanguagesTableTableManager get languages =>
      $$LanguagesTableTableManager(_db, _db.languages);
  $$ConditionsTableTableManager get conditions =>
      $$ConditionsTableTableManager(_db, _db.conditions);
  $$DamageTypesTableTableManager get damageTypes =>
      $$DamageTypesTableTableManager(_db, _db.damageTypes);
  $$MasteryPropertiesTableTableManager get masteryProperties =>
      $$MasteryPropertiesTableTableManager(_db, _db.masteryProperties);
  $$WeaponsTableTableManager get weapons =>
      $$WeaponsTableTableManager(_db, _db.weapons);
  $$ArmorsTableTableManager get armors =>
      $$ArmorsTableTableManager(_db, _db.armors);
  $$ToolsTableTableManager get tools =>
      $$ToolsTableTableManager(_db, _db.tools);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$BackgroundsTableTableManager get backgrounds =>
      $$BackgroundsTableTableManager(_db, _db.backgrounds);
  $$BackgroundAbilitiesTableTableManager get backgroundAbilities =>
      $$BackgroundAbilitiesTableTableManager(_db, _db.backgroundAbilities);
  $$BackgroundProficienciesTableTableManager get backgroundProficiencies =>
      $$BackgroundProficienciesTableTableManager(
        _db,
        _db.backgroundProficiencies,
      );
  $$BackgroundEquipmentOptionsTableTableManager
  get backgroundEquipmentOptions =>
      $$BackgroundEquipmentOptionsTableTableManager(
        _db,
        _db.backgroundEquipmentOptions,
      );
  $$FeatsTableTableManager get feats =>
      $$FeatsTableTableManager(_db, _db.feats);
  $$SpeciesTableTableTableManager get speciesTable =>
      $$SpeciesTableTableTableManager(_db, _db.speciesTable);
  $$SpeciesTraitsTableTableManager get speciesTraits =>
      $$SpeciesTraitsTableTableManager(_db, _db.speciesTraits);
  $$ClassesTableTableManager get classes =>
      $$ClassesTableTableManager(_db, _db.classes);
  $$ClassLevelsTableTableManager get classLevels =>
      $$ClassLevelsTableTableManager(_db, _db.classLevels);
  $$SubclassesTableTableManager get subclasses =>
      $$SubclassesTableTableManager(_db, _db.subclasses);
  $$SubclassFeaturesTableTableManager get subclassFeatures =>
      $$SubclassFeaturesTableTableManager(_db, _db.subclassFeatures);
  $$FeaturesTableTableManager get features =>
      $$FeaturesTableTableManager(_db, _db.features);
  $$SpellsTableTableManager get spells =>
      $$SpellsTableTableManager(_db, _db.spells);
  $$SpellClassesTableTableManager get spellClasses =>
      $$SpellClassesTableTableManager(_db, _db.spellClasses);
  $$MonstersTableTableManager get monsters =>
      $$MonstersTableTableManager(_db, _db.monsters);
  $$MonsterActionsTableTableManager get monsterActions =>
      $$MonsterActionsTableTableManager(_db, _db.monsterActions);
  $$StudyRevealsTableTableManager get studyReveals =>
      $$StudyRevealsTableTableManager(_db, _db.studyReveals);
  $$EffectsTableTableManager get effects =>
      $$EffectsTableTableManager(_db, _db.effects);
  $$EntityTextsTableTableManager get entityTexts =>
      $$EntityTextsTableTableManager(_db, _db.entityTexts);
}
