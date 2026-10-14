// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $StorageLocationsTable extends StorageLocations
    with TableInfo<$StorageLocationsTable, StorageLocationEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StorageLocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoAssetIdMeta = const VerificationMeta(
    'photoAssetId',
  );
  @override
  late final GeneratedColumn<String> photoAssetId = GeneratedColumn<String>(
    'photo_asset_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<String> archivedAt = GeneratedColumn<String>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    description,
    photoAssetId,
    archivedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'storage_locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<StorageLocationEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('photo_asset_id')) {
      context.handle(
        _photoAssetIdMeta,
        photoAssetId.isAcceptableOrUnknown(
          data['photo_asset_id']!,
          _photoAssetIdMeta,
        ),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StorageLocationEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StorageLocationEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      photoAssetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_asset_id'],
      ),
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}archived_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StorageLocationsTable createAlias(String alias) {
    return $StorageLocationsTable(attachedDatabase, alias);
  }
}

class StorageLocationEntry extends DataClass
    implements Insertable<StorageLocationEntry> {
  final String id;
  final String name;
  final String type;
  final String? description;
  final String? photoAssetId;
  final String? archivedAt;
  final String createdAt;
  final String updatedAt;
  const StorageLocationEntry({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    this.photoAssetId,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || photoAssetId != null) {
      map['photo_asset_id'] = Variable<String>(photoAssetId);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<String>(archivedAt);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  StorageLocationsCompanion toCompanion(bool nullToAbsent) {
    return StorageLocationsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      photoAssetId: photoAssetId == null && nullToAbsent
          ? const Value.absent()
          : Value(photoAssetId),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory StorageLocationEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StorageLocationEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      description: serializer.fromJson<String?>(json['description']),
      photoAssetId: serializer.fromJson<String?>(json['photoAssetId']),
      archivedAt: serializer.fromJson<String?>(json['archivedAt']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'description': serializer.toJson<String?>(description),
      'photoAssetId': serializer.toJson<String?>(photoAssetId),
      'archivedAt': serializer.toJson<String?>(archivedAt),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  StorageLocationEntry copyWith({
    String? id,
    String? name,
    String? type,
    Value<String?> description = const Value.absent(),
    Value<String?> photoAssetId = const Value.absent(),
    Value<String?> archivedAt = const Value.absent(),
    String? createdAt,
    String? updatedAt,
  }) => StorageLocationEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    description: description.present ? description.value : this.description,
    photoAssetId: photoAssetId.present ? photoAssetId.value : this.photoAssetId,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  StorageLocationEntry copyWithCompanion(StorageLocationsCompanion data) {
    return StorageLocationEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      description: data.description.present
          ? data.description.value
          : this.description,
      photoAssetId: data.photoAssetId.present
          ? data.photoAssetId.value
          : this.photoAssetId,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StorageLocationEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('photoAssetId: $photoAssetId, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    description,
    photoAssetId,
    archivedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StorageLocationEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.description == this.description &&
          other.photoAssetId == this.photoAssetId &&
          other.archivedAt == this.archivedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class StorageLocationsCompanion extends UpdateCompanion<StorageLocationEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String?> description;
  final Value<String?> photoAssetId;
  final Value<String?> archivedAt;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const StorageLocationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.photoAssetId = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StorageLocationsCompanion.insert({
    required String id,
    required String name,
    required String type,
    this.description = const Value.absent(),
    this.photoAssetId = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<StorageLocationEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? description,
    Expression<String>? photoAssetId,
    Expression<String>? archivedAt,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
      if (photoAssetId != null) 'photo_asset_id': photoAssetId,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StorageLocationsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String?>? description,
    Value<String?>? photoAssetId,
    Value<String?>? archivedAt,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return StorageLocationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      photoAssetId: photoAssetId ?? this.photoAssetId,
      archivedAt: archivedAt ?? this.archivedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (photoAssetId.present) {
      map['photo_asset_id'] = Variable<String>(photoAssetId.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<String>(archivedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StorageLocationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('photoAssetId: $photoAssetId, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryEntry extends DataClass implements Insertable<CategoryEntry> {
  final String id;
  final String name;
  final int sortOrder;
  const CategoryEntry({
    required this.id,
    required this.name,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      sortOrder: Value(sortOrder),
    );
  }

  factory CategoryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  CategoryEntry copyWith({String? id, String? name, int? sortOrder}) =>
      CategoryEntry(
        id: id ?? this.id,
        name: name ?? this.name,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  CategoryEntry copyWithCompanion(CategoriesCompanion data) {
    return CategoryEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder);
}

class CategoriesCompanion extends UpdateCompanion<CategoryEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<CategoryEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssetsTable extends Assets with TableInfo<$AssetsTable, AssetEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relativePathMeta = const VerificationMeta(
    'relativePath',
  );
  @override
  late final GeneratedColumn<String> relativePath = GeneratedColumn<String>(
    'relative_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sha256Meta = const VerificationMeta('sha256');
  @override
  late final GeneratedColumn<String> sha256 = GeneratedColumn<String>(
    'sha256',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalNameMeta = const VerificationMeta(
    'originalName',
  );
  @override
  late final GeneratedColumn<String> originalName = GeneratedColumn<String>(
    'original_name',
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    relativePath,
    mimeType,
    sizeBytes,
    sha256,
    originalName,
    kind,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assets';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssetEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('relative_path')) {
      context.handle(
        _relativePathMeta,
        relativePath.isAcceptableOrUnknown(
          data['relative_path']!,
          _relativePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relativePathMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeBytesMeta);
    }
    if (data.containsKey('sha256')) {
      context.handle(
        _sha256Meta,
        sha256.isAcceptableOrUnknown(data['sha256']!, _sha256Meta),
      );
    } else if (isInserting) {
      context.missing(_sha256Meta);
    }
    if (data.containsKey('original_name')) {
      context.handle(
        _originalNameMeta,
        originalName.isAcceptableOrUnknown(
          data['original_name']!,
          _originalNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalNameMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      relativePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relative_path'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      sha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sha256'],
      )!,
      originalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_name'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AssetsTable createAlias(String alias) {
    return $AssetsTable(attachedDatabase, alias);
  }
}

class AssetEntry extends DataClass implements Insertable<AssetEntry> {
  final String id;
  final String relativePath;
  final String mimeType;
  final int sizeBytes;
  final String sha256;
  final String originalName;
  final String kind;
  final String createdAt;
  const AssetEntry({
    required this.id,
    required this.relativePath,
    required this.mimeType,
    required this.sizeBytes,
    required this.sha256,
    required this.originalName,
    required this.kind,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['relative_path'] = Variable<String>(relativePath);
    map['mime_type'] = Variable<String>(mimeType);
    map['size_bytes'] = Variable<int>(sizeBytes);
    map['sha256'] = Variable<String>(sha256);
    map['original_name'] = Variable<String>(originalName);
    map['kind'] = Variable<String>(kind);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  AssetsCompanion toCompanion(bool nullToAbsent) {
    return AssetsCompanion(
      id: Value(id),
      relativePath: Value(relativePath),
      mimeType: Value(mimeType),
      sizeBytes: Value(sizeBytes),
      sha256: Value(sha256),
      originalName: Value(originalName),
      kind: Value(kind),
      createdAt: Value(createdAt),
    );
  }

  factory AssetEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetEntry(
      id: serializer.fromJson<String>(json['id']),
      relativePath: serializer.fromJson<String>(json['relativePath']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      sha256: serializer.fromJson<String>(json['sha256']),
      originalName: serializer.fromJson<String>(json['originalName']),
      kind: serializer.fromJson<String>(json['kind']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'relativePath': serializer.toJson<String>(relativePath),
      'mimeType': serializer.toJson<String>(mimeType),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'sha256': serializer.toJson<String>(sha256),
      'originalName': serializer.toJson<String>(originalName),
      'kind': serializer.toJson<String>(kind),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  AssetEntry copyWith({
    String? id,
    String? relativePath,
    String? mimeType,
    int? sizeBytes,
    String? sha256,
    String? originalName,
    String? kind,
    String? createdAt,
  }) => AssetEntry(
    id: id ?? this.id,
    relativePath: relativePath ?? this.relativePath,
    mimeType: mimeType ?? this.mimeType,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    sha256: sha256 ?? this.sha256,
    originalName: originalName ?? this.originalName,
    kind: kind ?? this.kind,
    createdAt: createdAt ?? this.createdAt,
  );
  AssetEntry copyWithCompanion(AssetsCompanion data) {
    return AssetEntry(
      id: data.id.present ? data.id.value : this.id,
      relativePath: data.relativePath.present
          ? data.relativePath.value
          : this.relativePath,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      sha256: data.sha256.present ? data.sha256.value : this.sha256,
      originalName: data.originalName.present
          ? data.originalName.value
          : this.originalName,
      kind: data.kind.present ? data.kind.value : this.kind,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetEntry(')
          ..write('id: $id, ')
          ..write('relativePath: $relativePath, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('sha256: $sha256, ')
          ..write('originalName: $originalName, ')
          ..write('kind: $kind, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    relativePath,
    mimeType,
    sizeBytes,
    sha256,
    originalName,
    kind,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetEntry &&
          other.id == this.id &&
          other.relativePath == this.relativePath &&
          other.mimeType == this.mimeType &&
          other.sizeBytes == this.sizeBytes &&
          other.sha256 == this.sha256 &&
          other.originalName == this.originalName &&
          other.kind == this.kind &&
          other.createdAt == this.createdAt);
}

class AssetsCompanion extends UpdateCompanion<AssetEntry> {
  final Value<String> id;
  final Value<String> relativePath;
  final Value<String> mimeType;
  final Value<int> sizeBytes;
  final Value<String> sha256;
  final Value<String> originalName;
  final Value<String> kind;
  final Value<String> createdAt;
  final Value<int> rowid;
  const AssetsCompanion({
    this.id = const Value.absent(),
    this.relativePath = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.sha256 = const Value.absent(),
    this.originalName = const Value.absent(),
    this.kind = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetsCompanion.insert({
    required String id,
    required String relativePath,
    required String mimeType,
    required int sizeBytes,
    required String sha256,
    required String originalName,
    required String kind,
    required String createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       relativePath = Value(relativePath),
       mimeType = Value(mimeType),
       sizeBytes = Value(sizeBytes),
       sha256 = Value(sha256),
       originalName = Value(originalName),
       kind = Value(kind),
       createdAt = Value(createdAt);
  static Insertable<AssetEntry> custom({
    Expression<String>? id,
    Expression<String>? relativePath,
    Expression<String>? mimeType,
    Expression<int>? sizeBytes,
    Expression<String>? sha256,
    Expression<String>? originalName,
    Expression<String>? kind,
    Expression<String>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (relativePath != null) 'relative_path': relativePath,
      if (mimeType != null) 'mime_type': mimeType,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (sha256 != null) 'sha256': sha256,
      if (originalName != null) 'original_name': originalName,
      if (kind != null) 'kind': kind,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetsCompanion copyWith({
    Value<String>? id,
    Value<String>? relativePath,
    Value<String>? mimeType,
    Value<int>? sizeBytes,
    Value<String>? sha256,
    Value<String>? originalName,
    Value<String>? kind,
    Value<String>? createdAt,
    Value<int>? rowid,
  }) {
    return AssetsCompanion(
      id: id ?? this.id,
      relativePath: relativePath ?? this.relativePath,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      sha256: sha256 ?? this.sha256,
      originalName: originalName ?? this.originalName,
      kind: kind ?? this.kind,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (relativePath.present) {
      map['relative_path'] = Variable<String>(relativePath.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (sha256.present) {
      map['sha256'] = Variable<String>(sha256.value);
    }
    if (originalName.present) {
      map['original_name'] = Variable<String>(originalName.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetsCompanion(')
          ..write('id: $id, ')
          ..write('relativePath: $relativePath, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('sha256: $sha256, ')
          ..write('originalName: $originalName, ')
          ..write('kind: $kind, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, ItemEntry> {
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 150,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('buah'),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _storageLocationIdMeta = const VerificationMeta(
    'storageLocationId',
  );
  @override
  late final GeneratedColumn<String> storageLocationId =
      GeneratedColumn<String>(
        'storage_location_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES storage_locations (id)',
        ),
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isImportantMeta = const VerificationMeta(
    'isImportant',
  );
  @override
  late final GeneratedColumn<bool> isImportant = GeneratedColumn<bool>(
    'is_important',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_important" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<String> archivedAt = GeneratedColumn<String>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    quantity,
    unit,
    categoryId,
    storageLocationId,
    notes,
    isImportant,
    archivedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('storage_location_id')) {
      context.handle(
        _storageLocationIdMeta,
        storageLocationId.isAcceptableOrUnknown(
          data['storage_location_id']!,
          _storageLocationIdMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_important')) {
      context.handle(
        _isImportantMeta,
        isImportant.isAcceptableOrUnknown(
          data['is_important']!,
          _isImportantMeta,
        ),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      storageLocationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}storage_location_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isImportant: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_important'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}archived_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }
}

class ItemEntry extends DataClass implements Insertable<ItemEntry> {
  final String id;
  final String name;
  final int quantity;
  final String unit;
  final String? categoryId;
  final String? storageLocationId;
  final String? notes;
  final bool isImportant;
  final String? archivedAt;
  final String createdAt;
  final String updatedAt;
  const ItemEntry({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    this.categoryId,
    this.storageLocationId,
    this.notes,
    required this.isImportant,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<int>(quantity);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || storageLocationId != null) {
      map['storage_location_id'] = Variable<String>(storageLocationId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_important'] = Variable<bool>(isImportant);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<String>(archivedAt);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      name: Value(name),
      quantity: Value(quantity),
      unit: Value(unit),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      storageLocationId: storageLocationId == null && nullToAbsent
          ? const Value.absent()
          : Value(storageLocationId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isImportant: Value(isImportant),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ItemEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      storageLocationId: serializer.fromJson<String?>(
        json['storageLocationId'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      isImportant: serializer.fromJson<bool>(json['isImportant']),
      archivedAt: serializer.fromJson<String?>(json['archivedAt']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<int>(quantity),
      'unit': serializer.toJson<String>(unit),
      'categoryId': serializer.toJson<String?>(categoryId),
      'storageLocationId': serializer.toJson<String?>(storageLocationId),
      'notes': serializer.toJson<String?>(notes),
      'isImportant': serializer.toJson<bool>(isImportant),
      'archivedAt': serializer.toJson<String?>(archivedAt),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  ItemEntry copyWith({
    String? id,
    String? name,
    int? quantity,
    String? unit,
    Value<String?> categoryId = const Value.absent(),
    Value<String?> storageLocationId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isImportant,
    Value<String?> archivedAt = const Value.absent(),
    String? createdAt,
    String? updatedAt,
  }) => ItemEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    storageLocationId: storageLocationId.present
        ? storageLocationId.value
        : this.storageLocationId,
    notes: notes.present ? notes.value : this.notes,
    isImportant: isImportant ?? this.isImportant,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ItemEntry copyWithCompanion(ItemsCompanion data) {
    return ItemEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      storageLocationId: data.storageLocationId.present
          ? data.storageLocationId.value
          : this.storageLocationId,
      notes: data.notes.present ? data.notes.value : this.notes,
      isImportant: data.isImportant.present
          ? data.isImportant.value
          : this.isImportant,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('categoryId: $categoryId, ')
          ..write('storageLocationId: $storageLocationId, ')
          ..write('notes: $notes, ')
          ..write('isImportant: $isImportant, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    quantity,
    unit,
    categoryId,
    storageLocationId,
    notes,
    isImportant,
    archivedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.categoryId == this.categoryId &&
          other.storageLocationId == this.storageLocationId &&
          other.notes == this.notes &&
          other.isImportant == this.isImportant &&
          other.archivedAt == this.archivedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ItemsCompanion extends UpdateCompanion<ItemEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> quantity;
  final Value<String> unit;
  final Value<String?> categoryId;
  final Value<String?> storageLocationId;
  final Value<String?> notes;
  final Value<bool> isImportant;
  final Value<String?> archivedAt;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.storageLocationId = const Value.absent(),
    this.notes = const Value.absent(),
    this.isImportant = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemsCompanion.insert({
    required String id,
    required String name,
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.storageLocationId = const Value.absent(),
    this.notes = const Value.absent(),
    this.isImportant = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ItemEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? quantity,
    Expression<String>? unit,
    Expression<String>? categoryId,
    Expression<String>? storageLocationId,
    Expression<String>? notes,
    Expression<bool>? isImportant,
    Expression<String>? archivedAt,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (categoryId != null) 'category_id': categoryId,
      if (storageLocationId != null) 'storage_location_id': storageLocationId,
      if (notes != null) 'notes': notes,
      if (isImportant != null) 'is_important': isImportant,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? quantity,
    Value<String>? unit,
    Value<String?>? categoryId,
    Value<String?>? storageLocationId,
    Value<String?>? notes,
    Value<bool>? isImportant,
    Value<String?>? archivedAt,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return ItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      categoryId: categoryId ?? this.categoryId,
      storageLocationId: storageLocationId ?? this.storageLocationId,
      notes: notes ?? this.notes,
      isImportant: isImportant ?? this.isImportant,
      archivedAt: archivedAt ?? this.archivedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (storageLocationId.present) {
      map['storage_location_id'] = Variable<String>(storageLocationId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isImportant.present) {
      map['is_important'] = Variable<bool>(isImportant.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<String>(archivedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
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
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('categoryId: $categoryId, ')
          ..write('storageLocationId: $storageLocationId, ')
          ..write('notes: $notes, ')
          ..write('isImportant: $isImportant, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemPhotosTable extends ItemPhotos
    with TableInfo<$ItemPhotosTable, ItemPhotoEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _assetIdMeta = const VerificationMeta(
    'assetId',
  );
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES assets (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, itemId, assetId, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemPhotoEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('asset_id')) {
      context.handle(
        _assetIdMeta,
        assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemPhotoEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemPhotoEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $ItemPhotosTable createAlias(String alias) {
    return $ItemPhotosTable(attachedDatabase, alias);
  }
}

class ItemPhotoEntry extends DataClass implements Insertable<ItemPhotoEntry> {
  final String id;
  final String itemId;
  final String assetId;
  final int sortOrder;
  const ItemPhotoEntry({
    required this.id,
    required this.itemId,
    required this.assetId,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item_id'] = Variable<String>(itemId);
    map['asset_id'] = Variable<String>(assetId);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  ItemPhotosCompanion toCompanion(bool nullToAbsent) {
    return ItemPhotosCompanion(
      id: Value(id),
      itemId: Value(itemId),
      assetId: Value(assetId),
      sortOrder: Value(sortOrder),
    );
  }

  factory ItemPhotoEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemPhotoEntry(
      id: serializer.fromJson<String>(json['id']),
      itemId: serializer.fromJson<String>(json['itemId']),
      assetId: serializer.fromJson<String>(json['assetId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'itemId': serializer.toJson<String>(itemId),
      'assetId': serializer.toJson<String>(assetId),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  ItemPhotoEntry copyWith({
    String? id,
    String? itemId,
    String? assetId,
    int? sortOrder,
  }) => ItemPhotoEntry(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    assetId: assetId ?? this.assetId,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  ItemPhotoEntry copyWithCompanion(ItemPhotosCompanion data) {
    return ItemPhotoEntry(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemPhotoEntry(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('assetId: $assetId, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, itemId, assetId, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemPhotoEntry &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.assetId == this.assetId &&
          other.sortOrder == this.sortOrder);
}

class ItemPhotosCompanion extends UpdateCompanion<ItemPhotoEntry> {
  final Value<String> id;
  final Value<String> itemId;
  final Value<String> assetId;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const ItemPhotosCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.assetId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemPhotosCompanion.insert({
    required String id,
    required String itemId,
    required String assetId,
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       itemId = Value(itemId),
       assetId = Value(assetId);
  static Insertable<ItemPhotoEntry> custom({
    Expression<String>? id,
    Expression<String>? itemId,
    Expression<String>? assetId,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (assetId != null) 'asset_id': assetId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemPhotosCompanion copyWith({
    Value<String>? id,
    Value<String>? itemId,
    Value<String>? assetId,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return ItemPhotosCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      assetId: assetId ?? this.assetId,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemPhotosCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('assetId: $assetId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TripsTable extends Trips with TableInfo<$TripsTable, TripEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateZoneIdMeta = const VerificationMeta(
    'dateZoneId',
  );
  @override
  late final GeneratedColumn<String> dateZoneId = GeneratedColumn<String>(
    'date_zone_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('planning'),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isPinnedMeta = const VerificationMeta(
    'isPinned',
  );
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    startDate,
    endDate,
    dateZoneId,
    status,
    isArchived,
    isPinned,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trips';
  @override
  VerificationContext validateIntegrity(
    Insertable<TripEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('date_zone_id')) {
      context.handle(
        _dateZoneIdMeta,
        dateZoneId.isAcceptableOrUnknown(
          data['date_zone_id']!,
          _dateZoneIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateZoneIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TripEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TripEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      ),
      dateZoneId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_zone_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pinned'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TripsTable createAlias(String alias) {
    return $TripsTable(attachedDatabase, alias);
  }
}

class TripEntry extends DataClass implements Insertable<TripEntry> {
  final String id;
  final String name;
  final String startDate;
  final String? endDate;
  final String dateZoneId;
  final String status;
  final bool isArchived;
  final bool isPinned;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  const TripEntry({
    required this.id,
    required this.name,
    required this.startDate,
    this.endDate,
    required this.dateZoneId,
    required this.status,
    required this.isArchived,
    required this.isPinned,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['start_date'] = Variable<String>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(endDate);
    }
    map['date_zone_id'] = Variable<String>(dateZoneId);
    map['status'] = Variable<String>(status);
    map['is_archived'] = Variable<bool>(isArchived);
    map['is_pinned'] = Variable<bool>(isPinned);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  TripsCompanion toCompanion(bool nullToAbsent) {
    return TripsCompanion(
      id: Value(id),
      name: Value(name),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      dateZoneId: Value(dateZoneId),
      status: Value(status),
      isArchived: Value(isArchived),
      isPinned: Value(isPinned),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TripEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TripEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      startDate: serializer.fromJson<String>(json['startDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
      dateZoneId: serializer.fromJson<String>(json['dateZoneId']),
      status: serializer.fromJson<String>(json['status']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'startDate': serializer.toJson<String>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
      'dateZoneId': serializer.toJson<String>(dateZoneId),
      'status': serializer.toJson<String>(status),
      'isArchived': serializer.toJson<bool>(isArchived),
      'isPinned': serializer.toJson<bool>(isPinned),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  TripEntry copyWith({
    String? id,
    String? name,
    String? startDate,
    Value<String?> endDate = const Value.absent(),
    String? dateZoneId,
    String? status,
    bool? isArchived,
    bool? isPinned,
    Value<String?> notes = const Value.absent(),
    String? createdAt,
    String? updatedAt,
  }) => TripEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    dateZoneId: dateZoneId ?? this.dateZoneId,
    status: status ?? this.status,
    isArchived: isArchived ?? this.isArchived,
    isPinned: isPinned ?? this.isPinned,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TripEntry copyWithCompanion(TripsCompanion data) {
    return TripEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      dateZoneId: data.dateZoneId.present
          ? data.dateZoneId.value
          : this.dateZoneId,
      status: data.status.present ? data.status.value : this.status,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TripEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('dateZoneId: $dateZoneId, ')
          ..write('status: $status, ')
          ..write('isArchived: $isArchived, ')
          ..write('isPinned: $isPinned, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    startDate,
    endDate,
    dateZoneId,
    status,
    isArchived,
    isPinned,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TripEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.dateZoneId == this.dateZoneId &&
          other.status == this.status &&
          other.isArchived == this.isArchived &&
          other.isPinned == this.isPinned &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TripsCompanion extends UpdateCompanion<TripEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> startDate;
  final Value<String?> endDate;
  final Value<String> dateZoneId;
  final Value<String> status;
  final Value<bool> isArchived;
  final Value<bool> isPinned;
  final Value<String?> notes;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const TripsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.dateZoneId = const Value.absent(),
    this.status = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TripsCompanion.insert({
    required String id,
    required String name,
    required String startDate,
    this.endDate = const Value.absent(),
    required String dateZoneId,
    this.status = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.notes = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       startDate = Value(startDate),
       dateZoneId = Value(dateZoneId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TripEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<String>? dateZoneId,
    Expression<String>? status,
    Expression<bool>? isArchived,
    Expression<bool>? isPinned,
    Expression<String>? notes,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (dateZoneId != null) 'date_zone_id': dateZoneId,
      if (status != null) 'status': status,
      if (isArchived != null) 'is_archived': isArchived,
      if (isPinned != null) 'is_pinned': isPinned,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TripsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? startDate,
    Value<String?>? endDate,
    Value<String>? dateZoneId,
    Value<String>? status,
    Value<bool>? isArchived,
    Value<bool>? isPinned,
    Value<String?>? notes,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return TripsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      dateZoneId: dateZoneId ?? this.dateZoneId,
      status: status ?? this.status,
      isArchived: isArchived ?? this.isArchived,
      isPinned: isPinned ?? this.isPinned,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (dateZoneId.present) {
      map['date_zone_id'] = Variable<String>(dateZoneId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('dateZoneId: $dateZoneId, ')
          ..write('status: $status, ')
          ..write('isArchived: $isArchived, ')
          ..write('isPinned: $isPinned, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TripStopsTable extends TripStops
    with TableInfo<$TripStopsTable, TripStopEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripStopsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _arrivalLocalMeta = const VerificationMeta(
    'arrivalLocal',
  );
  @override
  late final GeneratedColumn<String> arrivalLocal = GeneratedColumn<String>(
    'arrival_local',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _arrivalZoneMeta = const VerificationMeta(
    'arrivalZone',
  );
  @override
  late final GeneratedColumn<String> arrivalZone = GeneratedColumn<String>(
    'arrival_zone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _departureLocalMeta = const VerificationMeta(
    'departureLocal',
  );
  @override
  late final GeneratedColumn<String> departureLocal = GeneratedColumn<String>(
    'departure_local',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _departureZoneMeta = const VerificationMeta(
    'departureZone',
  );
  @override
  late final GeneratedColumn<String> departureZone = GeneratedColumn<String>(
    'departure_zone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    label,
    sortOrder,
    arrivalLocal,
    arrivalZone,
    departureLocal,
    departureZone,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trip_stops';
  @override
  VerificationContext validateIntegrity(
    Insertable<TripStopEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('arrival_local')) {
      context.handle(
        _arrivalLocalMeta,
        arrivalLocal.isAcceptableOrUnknown(
          data['arrival_local']!,
          _arrivalLocalMeta,
        ),
      );
    }
    if (data.containsKey('arrival_zone')) {
      context.handle(
        _arrivalZoneMeta,
        arrivalZone.isAcceptableOrUnknown(
          data['arrival_zone']!,
          _arrivalZoneMeta,
        ),
      );
    }
    if (data.containsKey('departure_local')) {
      context.handle(
        _departureLocalMeta,
        departureLocal.isAcceptableOrUnknown(
          data['departure_local']!,
          _departureLocalMeta,
        ),
      );
    }
    if (data.containsKey('departure_zone')) {
      context.handle(
        _departureZoneMeta,
        departureZone.isAcceptableOrUnknown(
          data['departure_zone']!,
          _departureZoneMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TripStopEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TripStopEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      arrivalLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arrival_local'],
      ),
      arrivalZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arrival_zone'],
      ),
      departureLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}departure_local'],
      ),
      departureZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}departure_zone'],
      ),
    );
  }

  @override
  $TripStopsTable createAlias(String alias) {
    return $TripStopsTable(attachedDatabase, alias);
  }
}

class TripStopEntry extends DataClass implements Insertable<TripStopEntry> {
  final String id;
  final String tripId;
  final String label;
  final int sortOrder;
  final String? arrivalLocal;
  final String? arrivalZone;
  final String? departureLocal;
  final String? departureZone;
  const TripStopEntry({
    required this.id,
    required this.tripId,
    required this.label,
    required this.sortOrder,
    this.arrivalLocal,
    this.arrivalZone,
    this.departureLocal,
    this.departureZone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_id'] = Variable<String>(tripId);
    map['label'] = Variable<String>(label);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || arrivalLocal != null) {
      map['arrival_local'] = Variable<String>(arrivalLocal);
    }
    if (!nullToAbsent || arrivalZone != null) {
      map['arrival_zone'] = Variable<String>(arrivalZone);
    }
    if (!nullToAbsent || departureLocal != null) {
      map['departure_local'] = Variable<String>(departureLocal);
    }
    if (!nullToAbsent || departureZone != null) {
      map['departure_zone'] = Variable<String>(departureZone);
    }
    return map;
  }

  TripStopsCompanion toCompanion(bool nullToAbsent) {
    return TripStopsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      label: Value(label),
      sortOrder: Value(sortOrder),
      arrivalLocal: arrivalLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(arrivalLocal),
      arrivalZone: arrivalZone == null && nullToAbsent
          ? const Value.absent()
          : Value(arrivalZone),
      departureLocal: departureLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(departureLocal),
      departureZone: departureZone == null && nullToAbsent
          ? const Value.absent()
          : Value(departureZone),
    );
  }

  factory TripStopEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TripStopEntry(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      label: serializer.fromJson<String>(json['label']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      arrivalLocal: serializer.fromJson<String?>(json['arrivalLocal']),
      arrivalZone: serializer.fromJson<String?>(json['arrivalZone']),
      departureLocal: serializer.fromJson<String?>(json['departureLocal']),
      departureZone: serializer.fromJson<String?>(json['departureZone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String>(tripId),
      'label': serializer.toJson<String>(label),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'arrivalLocal': serializer.toJson<String?>(arrivalLocal),
      'arrivalZone': serializer.toJson<String?>(arrivalZone),
      'departureLocal': serializer.toJson<String?>(departureLocal),
      'departureZone': serializer.toJson<String?>(departureZone),
    };
  }

  TripStopEntry copyWith({
    String? id,
    String? tripId,
    String? label,
    int? sortOrder,
    Value<String?> arrivalLocal = const Value.absent(),
    Value<String?> arrivalZone = const Value.absent(),
    Value<String?> departureLocal = const Value.absent(),
    Value<String?> departureZone = const Value.absent(),
  }) => TripStopEntry(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    label: label ?? this.label,
    sortOrder: sortOrder ?? this.sortOrder,
    arrivalLocal: arrivalLocal.present ? arrivalLocal.value : this.arrivalLocal,
    arrivalZone: arrivalZone.present ? arrivalZone.value : this.arrivalZone,
    departureLocal: departureLocal.present
        ? departureLocal.value
        : this.departureLocal,
    departureZone: departureZone.present
        ? departureZone.value
        : this.departureZone,
  );
  TripStopEntry copyWithCompanion(TripStopsCompanion data) {
    return TripStopEntry(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      label: data.label.present ? data.label.value : this.label,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      arrivalLocal: data.arrivalLocal.present
          ? data.arrivalLocal.value
          : this.arrivalLocal,
      arrivalZone: data.arrivalZone.present
          ? data.arrivalZone.value
          : this.arrivalZone,
      departureLocal: data.departureLocal.present
          ? data.departureLocal.value
          : this.departureLocal,
      departureZone: data.departureZone.present
          ? data.departureZone.value
          : this.departureZone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TripStopEntry(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('label: $label, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('arrivalLocal: $arrivalLocal, ')
          ..write('arrivalZone: $arrivalZone, ')
          ..write('departureLocal: $departureLocal, ')
          ..write('departureZone: $departureZone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tripId,
    label,
    sortOrder,
    arrivalLocal,
    arrivalZone,
    departureLocal,
    departureZone,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TripStopEntry &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.label == this.label &&
          other.sortOrder == this.sortOrder &&
          other.arrivalLocal == this.arrivalLocal &&
          other.arrivalZone == this.arrivalZone &&
          other.departureLocal == this.departureLocal &&
          other.departureZone == this.departureZone);
}

class TripStopsCompanion extends UpdateCompanion<TripStopEntry> {
  final Value<String> id;
  final Value<String> tripId;
  final Value<String> label;
  final Value<int> sortOrder;
  final Value<String?> arrivalLocal;
  final Value<String?> arrivalZone;
  final Value<String?> departureLocal;
  final Value<String?> departureZone;
  final Value<int> rowid;
  const TripStopsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.label = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.arrivalLocal = const Value.absent(),
    this.arrivalZone = const Value.absent(),
    this.departureLocal = const Value.absent(),
    this.departureZone = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TripStopsCompanion.insert({
    required String id,
    required String tripId,
    required String label,
    this.sortOrder = const Value.absent(),
    this.arrivalLocal = const Value.absent(),
    this.arrivalZone = const Value.absent(),
    this.departureLocal = const Value.absent(),
    this.departureZone = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tripId = Value(tripId),
       label = Value(label);
  static Insertable<TripStopEntry> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<String>? label,
    Expression<int>? sortOrder,
    Expression<String>? arrivalLocal,
    Expression<String>? arrivalZone,
    Expression<String>? departureLocal,
    Expression<String>? departureZone,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (label != null) 'label': label,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (arrivalLocal != null) 'arrival_local': arrivalLocal,
      if (arrivalZone != null) 'arrival_zone': arrivalZone,
      if (departureLocal != null) 'departure_local': departureLocal,
      if (departureZone != null) 'departure_zone': departureZone,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TripStopsCompanion copyWith({
    Value<String>? id,
    Value<String>? tripId,
    Value<String>? label,
    Value<int>? sortOrder,
    Value<String?>? arrivalLocal,
    Value<String?>? arrivalZone,
    Value<String?>? departureLocal,
    Value<String?>? departureZone,
    Value<int>? rowid,
  }) {
    return TripStopsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      label: label ?? this.label,
      sortOrder: sortOrder ?? this.sortOrder,
      arrivalLocal: arrivalLocal ?? this.arrivalLocal,
      arrivalZone: arrivalZone ?? this.arrivalZone,
      departureLocal: departureLocal ?? this.departureLocal,
      departureZone: departureZone ?? this.departureZone,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (arrivalLocal.present) {
      map['arrival_local'] = Variable<String>(arrivalLocal.value);
    }
    if (arrivalZone.present) {
      map['arrival_zone'] = Variable<String>(arrivalZone.value);
    }
    if (departureLocal.present) {
      map['departure_local'] = Variable<String>(departureLocal.value);
    }
    if (departureZone.present) {
      map['departure_zone'] = Variable<String>(departureZone.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripStopsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('label: $label, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('arrivalLocal: $arrivalLocal, ')
          ..write('arrivalZone: $arrivalZone, ')
          ..write('departureLocal: $departureLocal, ')
          ..write('departureZone: $departureZone, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TripBagsTable extends TripBags
    with TableInfo<$TripBagsTable, TripBagEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripBagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id) ON DELETE CASCADE',
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, tripId, name, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trip_bags';
  @override
  VerificationContext validateIntegrity(
    Insertable<TripBagEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
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
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TripBagEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TripBagEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $TripBagsTable createAlias(String alias) {
    return $TripBagsTable(attachedDatabase, alias);
  }
}

class TripBagEntry extends DataClass implements Insertable<TripBagEntry> {
  final String id;
  final String tripId;
  final String name;
  final String? description;
  const TripBagEntry({
    required this.id,
    required this.tripId,
    required this.name,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_id'] = Variable<String>(tripId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  TripBagsCompanion toCompanion(bool nullToAbsent) {
    return TripBagsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory TripBagEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TripBagEntry(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String>(tripId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
    };
  }

  TripBagEntry copyWith({
    String? id,
    String? tripId,
    String? name,
    Value<String?> description = const Value.absent(),
  }) => TripBagEntry(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
  );
  TripBagEntry copyWithCompanion(TripBagsCompanion data) {
    return TripBagEntry(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TripBagEntry(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('name: $name, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tripId, name, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TripBagEntry &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.name == this.name &&
          other.description == this.description);
}

class TripBagsCompanion extends UpdateCompanion<TripBagEntry> {
  final Value<String> id;
  final Value<String> tripId;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> rowid;
  const TripBagsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TripBagsCompanion.insert({
    required String id,
    required String tripId,
    required String name,
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tripId = Value(tripId),
       name = Value(name);
  static Insertable<TripBagEntry> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TripBagsCompanion copyWith({
    Value<String>? id,
    Value<String>? tripId,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? rowid,
  }) {
    return TripBagsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      name: name ?? this.name,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
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
    return (StringBuffer('TripBagsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BagCompartmentsTable extends BagCompartments
    with TableInfo<$BagCompartmentsTable, BagCompartmentEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BagCompartmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripBagIdMeta = const VerificationMeta(
    'tripBagId',
  );
  @override
  late final GeneratedColumn<String> tripBagId = GeneratedColumn<String>(
    'trip_bag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trip_bags (id) ON DELETE CASCADE',
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
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, tripBagId, name, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bag_compartments';
  @override
  VerificationContext validateIntegrity(
    Insertable<BagCompartmentEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_bag_id')) {
      context.handle(
        _tripBagIdMeta,
        tripBagId.isAcceptableOrUnknown(data['trip_bag_id']!, _tripBagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripBagIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BagCompartmentEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BagCompartmentEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripBagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_bag_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $BagCompartmentsTable createAlias(String alias) {
    return $BagCompartmentsTable(attachedDatabase, alias);
  }
}

class BagCompartmentEntry extends DataClass
    implements Insertable<BagCompartmentEntry> {
  final String id;
  final String tripBagId;
  final String name;
  final int sortOrder;
  const BagCompartmentEntry({
    required this.id,
    required this.tripBagId,
    required this.name,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_bag_id'] = Variable<String>(tripBagId);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  BagCompartmentsCompanion toCompanion(bool nullToAbsent) {
    return BagCompartmentsCompanion(
      id: Value(id),
      tripBagId: Value(tripBagId),
      name: Value(name),
      sortOrder: Value(sortOrder),
    );
  }

  factory BagCompartmentEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BagCompartmentEntry(
      id: serializer.fromJson<String>(json['id']),
      tripBagId: serializer.fromJson<String>(json['tripBagId']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripBagId': serializer.toJson<String>(tripBagId),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  BagCompartmentEntry copyWith({
    String? id,
    String? tripBagId,
    String? name,
    int? sortOrder,
  }) => BagCompartmentEntry(
    id: id ?? this.id,
    tripBagId: tripBagId ?? this.tripBagId,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  BagCompartmentEntry copyWithCompanion(BagCompartmentsCompanion data) {
    return BagCompartmentEntry(
      id: data.id.present ? data.id.value : this.id,
      tripBagId: data.tripBagId.present ? data.tripBagId.value : this.tripBagId,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BagCompartmentEntry(')
          ..write('id: $id, ')
          ..write('tripBagId: $tripBagId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tripBagId, name, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BagCompartmentEntry &&
          other.id == this.id &&
          other.tripBagId == this.tripBagId &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder);
}

class BagCompartmentsCompanion extends UpdateCompanion<BagCompartmentEntry> {
  final Value<String> id;
  final Value<String> tripBagId;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const BagCompartmentsCompanion({
    this.id = const Value.absent(),
    this.tripBagId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BagCompartmentsCompanion.insert({
    required String id,
    required String tripBagId,
    required String name,
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tripBagId = Value(tripBagId),
       name = Value(name);
  static Insertable<BagCompartmentEntry> custom({
    Expression<String>? id,
    Expression<String>? tripBagId,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripBagId != null) 'trip_bag_id': tripBagId,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BagCompartmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? tripBagId,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return BagCompartmentsCompanion(
      id: id ?? this.id,
      tripBagId: tripBagId ?? this.tripBagId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripBagId.present) {
      map['trip_bag_id'] = Variable<String>(tripBagId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BagCompartmentsCompanion(')
          ..write('id: $id, ')
          ..write('tripBagId: $tripBagId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TripItemsTable extends TripItems
    with TableInfo<$TripItemsTable, TripItemEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id)',
    ),
  );
  static const VerificationMeta _decisionMeta = const VerificationMeta(
    'decision',
  );
  @override
  late final GeneratedColumn<String> decision = GeneratedColumn<String>(
    'decision',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('carried'),
  );
  static const VerificationMeta _plannedQuantityMeta = const VerificationMeta(
    'plannedQuantity',
  );
  @override
  late final GeneratedColumn<int> plannedQuantity = GeneratedColumn<int>(
    'planned_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _packedQuantityMeta = const VerificationMeta(
    'packedQuantity',
  );
  @override
  late final GeneratedColumn<int> packedQuantity = GeneratedColumn<int>(
    'packed_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _inUseQuantityMeta = const VerificationMeta(
    'inUseQuantity',
  );
  @override
  late final GeneratedColumn<int> inUseQuantity = GeneratedColumn<int>(
    'in_use_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _tripBagIdMeta = const VerificationMeta(
    'tripBagId',
  );
  @override
  late final GeneratedColumn<String> tripBagId = GeneratedColumn<String>(
    'trip_bag_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trip_bags (id)',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameSnapshotMeta = const VerificationMeta(
    'nameSnapshot',
  );
  @override
  late final GeneratedColumn<String> nameSnapshot = GeneratedColumn<String>(
    'name_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceLabelSnapshotMeta =
      const VerificationMeta('sourceLabelSnapshot');
  @override
  late final GeneratedColumn<String> sourceLabelSnapshot =
      GeneratedColumn<String>(
        'source_label_snapshot',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastPhysicallyConfirmedAtMeta =
      const VerificationMeta('lastPhysicallyConfirmedAt');
  @override
  late final GeneratedColumn<String> lastPhysicallyConfirmedAt =
      GeneratedColumn<String>(
        'last_physically_confirmed_at',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _departureCheckConfirmedAtMeta =
      const VerificationMeta('departureCheckConfirmedAt');
  @override
  late final GeneratedColumn<String> departureCheckConfirmedAt =
      GeneratedColumn<String>(
        'departure_check_confirmed_at',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isPackedLastMeta = const VerificationMeta(
    'isPackedLast',
  );
  @override
  late final GeneratedColumn<bool> isPackedLast = GeneratedColumn<bool>(
    'is_packed_last',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_packed_last" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    itemId,
    decision,
    plannedQuantity,
    packedQuantity,
    inUseQuantity,
    tripBagId,
    notes,
    nameSnapshot,
    sourceLabelSnapshot,
    lastPhysicallyConfirmedAt,
    departureCheckConfirmedAt,
    isPackedLast,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trip_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<TripItemEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('decision')) {
      context.handle(
        _decisionMeta,
        decision.isAcceptableOrUnknown(data['decision']!, _decisionMeta),
      );
    }
    if (data.containsKey('planned_quantity')) {
      context.handle(
        _plannedQuantityMeta,
        plannedQuantity.isAcceptableOrUnknown(
          data['planned_quantity']!,
          _plannedQuantityMeta,
        ),
      );
    }
    if (data.containsKey('packed_quantity')) {
      context.handle(
        _packedQuantityMeta,
        packedQuantity.isAcceptableOrUnknown(
          data['packed_quantity']!,
          _packedQuantityMeta,
        ),
      );
    }
    if (data.containsKey('in_use_quantity')) {
      context.handle(
        _inUseQuantityMeta,
        inUseQuantity.isAcceptableOrUnknown(
          data['in_use_quantity']!,
          _inUseQuantityMeta,
        ),
      );
    }
    if (data.containsKey('trip_bag_id')) {
      context.handle(
        _tripBagIdMeta,
        tripBagId.isAcceptableOrUnknown(data['trip_bag_id']!, _tripBagIdMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('name_snapshot')) {
      context.handle(
        _nameSnapshotMeta,
        nameSnapshot.isAcceptableOrUnknown(
          data['name_snapshot']!,
          _nameSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameSnapshotMeta);
    }
    if (data.containsKey('source_label_snapshot')) {
      context.handle(
        _sourceLabelSnapshotMeta,
        sourceLabelSnapshot.isAcceptableOrUnknown(
          data['source_label_snapshot']!,
          _sourceLabelSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('last_physically_confirmed_at')) {
      context.handle(
        _lastPhysicallyConfirmedAtMeta,
        lastPhysicallyConfirmedAt.isAcceptableOrUnknown(
          data['last_physically_confirmed_at']!,
          _lastPhysicallyConfirmedAtMeta,
        ),
      );
    }
    if (data.containsKey('departure_check_confirmed_at')) {
      context.handle(
        _departureCheckConfirmedAtMeta,
        departureCheckConfirmedAt.isAcceptableOrUnknown(
          data['departure_check_confirmed_at']!,
          _departureCheckConfirmedAtMeta,
        ),
      );
    }
    if (data.containsKey('is_packed_last')) {
      context.handle(
        _isPackedLastMeta,
        isPackedLast.isAcceptableOrUnknown(
          data['is_packed_last']!,
          _isPackedLastMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {tripId, itemId},
  ];
  @override
  TripItemEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TripItemEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      decision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}decision'],
      )!,
      plannedQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_quantity'],
      )!,
      packedQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}packed_quantity'],
      )!,
      inUseQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}in_use_quantity'],
      )!,
      tripBagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_bag_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      nameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_snapshot'],
      )!,
      sourceLabelSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_label_snapshot'],
      ),
      lastPhysicallyConfirmedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_physically_confirmed_at'],
      ),
      departureCheckConfirmedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}departure_check_confirmed_at'],
      ),
      isPackedLast: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_packed_last'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TripItemsTable createAlias(String alias) {
    return $TripItemsTable(attachedDatabase, alias);
  }
}

class TripItemEntry extends DataClass implements Insertable<TripItemEntry> {
  final String id;
  final String tripId;
  final String itemId;
  final String decision;
  final int plannedQuantity;
  final int packedQuantity;
  final int inUseQuantity;
  final String? tripBagId;
  final String? notes;
  final String nameSnapshot;
  final String? sourceLabelSnapshot;
  final String? lastPhysicallyConfirmedAt;
  final String? departureCheckConfirmedAt;
  final bool isPackedLast;
  final String updatedAt;
  const TripItemEntry({
    required this.id,
    required this.tripId,
    required this.itemId,
    required this.decision,
    required this.plannedQuantity,
    required this.packedQuantity,
    required this.inUseQuantity,
    this.tripBagId,
    this.notes,
    required this.nameSnapshot,
    this.sourceLabelSnapshot,
    this.lastPhysicallyConfirmedAt,
    this.departureCheckConfirmedAt,
    required this.isPackedLast,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_id'] = Variable<String>(tripId);
    map['item_id'] = Variable<String>(itemId);
    map['decision'] = Variable<String>(decision);
    map['planned_quantity'] = Variable<int>(plannedQuantity);
    map['packed_quantity'] = Variable<int>(packedQuantity);
    map['in_use_quantity'] = Variable<int>(inUseQuantity);
    if (!nullToAbsent || tripBagId != null) {
      map['trip_bag_id'] = Variable<String>(tripBagId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['name_snapshot'] = Variable<String>(nameSnapshot);
    if (!nullToAbsent || sourceLabelSnapshot != null) {
      map['source_label_snapshot'] = Variable<String>(sourceLabelSnapshot);
    }
    if (!nullToAbsent || lastPhysicallyConfirmedAt != null) {
      map['last_physically_confirmed_at'] = Variable<String>(
        lastPhysicallyConfirmedAt,
      );
    }
    if (!nullToAbsent || departureCheckConfirmedAt != null) {
      map['departure_check_confirmed_at'] = Variable<String>(
        departureCheckConfirmedAt,
      );
    }
    map['is_packed_last'] = Variable<bool>(isPackedLast);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  TripItemsCompanion toCompanion(bool nullToAbsent) {
    return TripItemsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      itemId: Value(itemId),
      decision: Value(decision),
      plannedQuantity: Value(plannedQuantity),
      packedQuantity: Value(packedQuantity),
      inUseQuantity: Value(inUseQuantity),
      tripBagId: tripBagId == null && nullToAbsent
          ? const Value.absent()
          : Value(tripBagId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      nameSnapshot: Value(nameSnapshot),
      sourceLabelSnapshot: sourceLabelSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceLabelSnapshot),
      lastPhysicallyConfirmedAt:
          lastPhysicallyConfirmedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPhysicallyConfirmedAt),
      departureCheckConfirmedAt:
          departureCheckConfirmedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(departureCheckConfirmedAt),
      isPackedLast: Value(isPackedLast),
      updatedAt: Value(updatedAt),
    );
  }

  factory TripItemEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TripItemEntry(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      decision: serializer.fromJson<String>(json['decision']),
      plannedQuantity: serializer.fromJson<int>(json['plannedQuantity']),
      packedQuantity: serializer.fromJson<int>(json['packedQuantity']),
      inUseQuantity: serializer.fromJson<int>(json['inUseQuantity']),
      tripBagId: serializer.fromJson<String?>(json['tripBagId']),
      notes: serializer.fromJson<String?>(json['notes']),
      nameSnapshot: serializer.fromJson<String>(json['nameSnapshot']),
      sourceLabelSnapshot: serializer.fromJson<String?>(
        json['sourceLabelSnapshot'],
      ),
      lastPhysicallyConfirmedAt: serializer.fromJson<String?>(
        json['lastPhysicallyConfirmedAt'],
      ),
      departureCheckConfirmedAt: serializer.fromJson<String?>(
        json['departureCheckConfirmedAt'],
      ),
      isPackedLast: serializer.fromJson<bool>(json['isPackedLast']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String>(tripId),
      'itemId': serializer.toJson<String>(itemId),
      'decision': serializer.toJson<String>(decision),
      'plannedQuantity': serializer.toJson<int>(plannedQuantity),
      'packedQuantity': serializer.toJson<int>(packedQuantity),
      'inUseQuantity': serializer.toJson<int>(inUseQuantity),
      'tripBagId': serializer.toJson<String?>(tripBagId),
      'notes': serializer.toJson<String?>(notes),
      'nameSnapshot': serializer.toJson<String>(nameSnapshot),
      'sourceLabelSnapshot': serializer.toJson<String?>(sourceLabelSnapshot),
      'lastPhysicallyConfirmedAt': serializer.toJson<String?>(
        lastPhysicallyConfirmedAt,
      ),
      'departureCheckConfirmedAt': serializer.toJson<String?>(
        departureCheckConfirmedAt,
      ),
      'isPackedLast': serializer.toJson<bool>(isPackedLast),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  TripItemEntry copyWith({
    String? id,
    String? tripId,
    String? itemId,
    String? decision,
    int? plannedQuantity,
    int? packedQuantity,
    int? inUseQuantity,
    Value<String?> tripBagId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? nameSnapshot,
    Value<String?> sourceLabelSnapshot = const Value.absent(),
    Value<String?> lastPhysicallyConfirmedAt = const Value.absent(),
    Value<String?> departureCheckConfirmedAt = const Value.absent(),
    bool? isPackedLast,
    String? updatedAt,
  }) => TripItemEntry(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    itemId: itemId ?? this.itemId,
    decision: decision ?? this.decision,
    plannedQuantity: plannedQuantity ?? this.plannedQuantity,
    packedQuantity: packedQuantity ?? this.packedQuantity,
    inUseQuantity: inUseQuantity ?? this.inUseQuantity,
    tripBagId: tripBagId.present ? tripBagId.value : this.tripBagId,
    notes: notes.present ? notes.value : this.notes,
    nameSnapshot: nameSnapshot ?? this.nameSnapshot,
    sourceLabelSnapshot: sourceLabelSnapshot.present
        ? sourceLabelSnapshot.value
        : this.sourceLabelSnapshot,
    lastPhysicallyConfirmedAt: lastPhysicallyConfirmedAt.present
        ? lastPhysicallyConfirmedAt.value
        : this.lastPhysicallyConfirmedAt,
    departureCheckConfirmedAt: departureCheckConfirmedAt.present
        ? departureCheckConfirmedAt.value
        : this.departureCheckConfirmedAt,
    isPackedLast: isPackedLast ?? this.isPackedLast,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TripItemEntry copyWithCompanion(TripItemsCompanion data) {
    return TripItemEntry(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      decision: data.decision.present ? data.decision.value : this.decision,
      plannedQuantity: data.plannedQuantity.present
          ? data.plannedQuantity.value
          : this.plannedQuantity,
      packedQuantity: data.packedQuantity.present
          ? data.packedQuantity.value
          : this.packedQuantity,
      inUseQuantity: data.inUseQuantity.present
          ? data.inUseQuantity.value
          : this.inUseQuantity,
      tripBagId: data.tripBagId.present ? data.tripBagId.value : this.tripBagId,
      notes: data.notes.present ? data.notes.value : this.notes,
      nameSnapshot: data.nameSnapshot.present
          ? data.nameSnapshot.value
          : this.nameSnapshot,
      sourceLabelSnapshot: data.sourceLabelSnapshot.present
          ? data.sourceLabelSnapshot.value
          : this.sourceLabelSnapshot,
      lastPhysicallyConfirmedAt: data.lastPhysicallyConfirmedAt.present
          ? data.lastPhysicallyConfirmedAt.value
          : this.lastPhysicallyConfirmedAt,
      departureCheckConfirmedAt: data.departureCheckConfirmedAt.present
          ? data.departureCheckConfirmedAt.value
          : this.departureCheckConfirmedAt,
      isPackedLast: data.isPackedLast.present
          ? data.isPackedLast.value
          : this.isPackedLast,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TripItemEntry(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('itemId: $itemId, ')
          ..write('decision: $decision, ')
          ..write('plannedQuantity: $plannedQuantity, ')
          ..write('packedQuantity: $packedQuantity, ')
          ..write('inUseQuantity: $inUseQuantity, ')
          ..write('tripBagId: $tripBagId, ')
          ..write('notes: $notes, ')
          ..write('nameSnapshot: $nameSnapshot, ')
          ..write('sourceLabelSnapshot: $sourceLabelSnapshot, ')
          ..write('lastPhysicallyConfirmedAt: $lastPhysicallyConfirmedAt, ')
          ..write('departureCheckConfirmedAt: $departureCheckConfirmedAt, ')
          ..write('isPackedLast: $isPackedLast, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tripId,
    itemId,
    decision,
    plannedQuantity,
    packedQuantity,
    inUseQuantity,
    tripBagId,
    notes,
    nameSnapshot,
    sourceLabelSnapshot,
    lastPhysicallyConfirmedAt,
    departureCheckConfirmedAt,
    isPackedLast,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TripItemEntry &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.itemId == this.itemId &&
          other.decision == this.decision &&
          other.plannedQuantity == this.plannedQuantity &&
          other.packedQuantity == this.packedQuantity &&
          other.inUseQuantity == this.inUseQuantity &&
          other.tripBagId == this.tripBagId &&
          other.notes == this.notes &&
          other.nameSnapshot == this.nameSnapshot &&
          other.sourceLabelSnapshot == this.sourceLabelSnapshot &&
          other.lastPhysicallyConfirmedAt == this.lastPhysicallyConfirmedAt &&
          other.departureCheckConfirmedAt == this.departureCheckConfirmedAt &&
          other.isPackedLast == this.isPackedLast &&
          other.updatedAt == this.updatedAt);
}

class TripItemsCompanion extends UpdateCompanion<TripItemEntry> {
  final Value<String> id;
  final Value<String> tripId;
  final Value<String> itemId;
  final Value<String> decision;
  final Value<int> plannedQuantity;
  final Value<int> packedQuantity;
  final Value<int> inUseQuantity;
  final Value<String?> tripBagId;
  final Value<String?> notes;
  final Value<String> nameSnapshot;
  final Value<String?> sourceLabelSnapshot;
  final Value<String?> lastPhysicallyConfirmedAt;
  final Value<String?> departureCheckConfirmedAt;
  final Value<bool> isPackedLast;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const TripItemsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.decision = const Value.absent(),
    this.plannedQuantity = const Value.absent(),
    this.packedQuantity = const Value.absent(),
    this.inUseQuantity = const Value.absent(),
    this.tripBagId = const Value.absent(),
    this.notes = const Value.absent(),
    this.nameSnapshot = const Value.absent(),
    this.sourceLabelSnapshot = const Value.absent(),
    this.lastPhysicallyConfirmedAt = const Value.absent(),
    this.departureCheckConfirmedAt = const Value.absent(),
    this.isPackedLast = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TripItemsCompanion.insert({
    required String id,
    required String tripId,
    required String itemId,
    this.decision = const Value.absent(),
    this.plannedQuantity = const Value.absent(),
    this.packedQuantity = const Value.absent(),
    this.inUseQuantity = const Value.absent(),
    this.tripBagId = const Value.absent(),
    this.notes = const Value.absent(),
    required String nameSnapshot,
    this.sourceLabelSnapshot = const Value.absent(),
    this.lastPhysicallyConfirmedAt = const Value.absent(),
    this.departureCheckConfirmedAt = const Value.absent(),
    this.isPackedLast = const Value.absent(),
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tripId = Value(tripId),
       itemId = Value(itemId),
       nameSnapshot = Value(nameSnapshot),
       updatedAt = Value(updatedAt);
  static Insertable<TripItemEntry> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<String>? itemId,
    Expression<String>? decision,
    Expression<int>? plannedQuantity,
    Expression<int>? packedQuantity,
    Expression<int>? inUseQuantity,
    Expression<String>? tripBagId,
    Expression<String>? notes,
    Expression<String>? nameSnapshot,
    Expression<String>? sourceLabelSnapshot,
    Expression<String>? lastPhysicallyConfirmedAt,
    Expression<String>? departureCheckConfirmedAt,
    Expression<bool>? isPackedLast,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (itemId != null) 'item_id': itemId,
      if (decision != null) 'decision': decision,
      if (plannedQuantity != null) 'planned_quantity': plannedQuantity,
      if (packedQuantity != null) 'packed_quantity': packedQuantity,
      if (inUseQuantity != null) 'in_use_quantity': inUseQuantity,
      if (tripBagId != null) 'trip_bag_id': tripBagId,
      if (notes != null) 'notes': notes,
      if (nameSnapshot != null) 'name_snapshot': nameSnapshot,
      if (sourceLabelSnapshot != null)
        'source_label_snapshot': sourceLabelSnapshot,
      if (lastPhysicallyConfirmedAt != null)
        'last_physically_confirmed_at': lastPhysicallyConfirmedAt,
      if (departureCheckConfirmedAt != null)
        'departure_check_confirmed_at': departureCheckConfirmedAt,
      if (isPackedLast != null) 'is_packed_last': isPackedLast,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TripItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? tripId,
    Value<String>? itemId,
    Value<String>? decision,
    Value<int>? plannedQuantity,
    Value<int>? packedQuantity,
    Value<int>? inUseQuantity,
    Value<String?>? tripBagId,
    Value<String?>? notes,
    Value<String>? nameSnapshot,
    Value<String?>? sourceLabelSnapshot,
    Value<String?>? lastPhysicallyConfirmedAt,
    Value<String?>? departureCheckConfirmedAt,
    Value<bool>? isPackedLast,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return TripItemsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      itemId: itemId ?? this.itemId,
      decision: decision ?? this.decision,
      plannedQuantity: plannedQuantity ?? this.plannedQuantity,
      packedQuantity: packedQuantity ?? this.packedQuantity,
      inUseQuantity: inUseQuantity ?? this.inUseQuantity,
      tripBagId: tripBagId ?? this.tripBagId,
      notes: notes ?? this.notes,
      nameSnapshot: nameSnapshot ?? this.nameSnapshot,
      sourceLabelSnapshot: sourceLabelSnapshot ?? this.sourceLabelSnapshot,
      lastPhysicallyConfirmedAt:
          lastPhysicallyConfirmedAt ?? this.lastPhysicallyConfirmedAt,
      departureCheckConfirmedAt:
          departureCheckConfirmedAt ?? this.departureCheckConfirmedAt,
      isPackedLast: isPackedLast ?? this.isPackedLast,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (decision.present) {
      map['decision'] = Variable<String>(decision.value);
    }
    if (plannedQuantity.present) {
      map['planned_quantity'] = Variable<int>(plannedQuantity.value);
    }
    if (packedQuantity.present) {
      map['packed_quantity'] = Variable<int>(packedQuantity.value);
    }
    if (inUseQuantity.present) {
      map['in_use_quantity'] = Variable<int>(inUseQuantity.value);
    }
    if (tripBagId.present) {
      map['trip_bag_id'] = Variable<String>(tripBagId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (nameSnapshot.present) {
      map['name_snapshot'] = Variable<String>(nameSnapshot.value);
    }
    if (sourceLabelSnapshot.present) {
      map['source_label_snapshot'] = Variable<String>(
        sourceLabelSnapshot.value,
      );
    }
    if (lastPhysicallyConfirmedAt.present) {
      map['last_physically_confirmed_at'] = Variable<String>(
        lastPhysicallyConfirmedAt.value,
      );
    }
    if (departureCheckConfirmedAt.present) {
      map['departure_check_confirmed_at'] = Variable<String>(
        departureCheckConfirmedAt.value,
      );
    }
    if (isPackedLast.present) {
      map['is_packed_last'] = Variable<bool>(isPackedLast.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripItemsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('itemId: $itemId, ')
          ..write('decision: $decision, ')
          ..write('plannedQuantity: $plannedQuantity, ')
          ..write('packedQuantity: $packedQuantity, ')
          ..write('inUseQuantity: $inUseQuantity, ')
          ..write('tripBagId: $tripBagId, ')
          ..write('notes: $notes, ')
          ..write('nameSnapshot: $nameSnapshot, ')
          ..write('sourceLabelSnapshot: $sourceLabelSnapshot, ')
          ..write('lastPhysicallyConfirmedAt: $lastPhysicallyConfirmedAt, ')
          ..write('departureCheckConfirmedAt: $departureCheckConfirmedAt, ')
          ..write('isPackedLast: $isPackedLast, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemAllocationsTable extends ItemAllocations
    with TableInfo<$ItemAllocationsTable, ItemAllocationEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripItemIdMeta = const VerificationMeta(
    'tripItemId',
  );
  @override
  late final GeneratedColumn<String> tripItemId = GeneratedColumn<String>(
    'trip_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trip_items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _targetTypeMeta = const VerificationMeta(
    'targetType',
  );
  @override
  late final GeneratedColumn<String> targetType = GeneratedColumn<String>(
    'target_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('bag'),
  );
  static const VerificationMeta _tripBagIdMeta = const VerificationMeta(
    'tripBagId',
  );
  @override
  late final GeneratedColumn<String> tripBagId = GeneratedColumn<String>(
    'trip_bag_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trip_bags (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _compartmentIdMeta = const VerificationMeta(
    'compartmentId',
  );
  @override
  late final GeneratedColumn<String> compartmentId = GeneratedColumn<String>(
    'compartment_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bag_compartments (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastConfirmedAtMeta = const VerificationMeta(
    'lastConfirmedAt',
  );
  @override
  late final GeneratedColumn<String> lastConfirmedAt = GeneratedColumn<String>(
    'last_confirmed_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripItemId,
    targetType,
    tripBagId,
    compartmentId,
    quantity,
    notes,
    lastConfirmedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_allocations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemAllocationEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_item_id')) {
      context.handle(
        _tripItemIdMeta,
        tripItemId.isAcceptableOrUnknown(
          data['trip_item_id']!,
          _tripItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tripItemIdMeta);
    }
    if (data.containsKey('target_type')) {
      context.handle(
        _targetTypeMeta,
        targetType.isAcceptableOrUnknown(data['target_type']!, _targetTypeMeta),
      );
    }
    if (data.containsKey('trip_bag_id')) {
      context.handle(
        _tripBagIdMeta,
        tripBagId.isAcceptableOrUnknown(data['trip_bag_id']!, _tripBagIdMeta),
      );
    }
    if (data.containsKey('compartment_id')) {
      context.handle(
        _compartmentIdMeta,
        compartmentId.isAcceptableOrUnknown(
          data['compartment_id']!,
          _compartmentIdMeta,
        ),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('last_confirmed_at')) {
      context.handle(
        _lastConfirmedAtMeta,
        lastConfirmedAt.isAcceptableOrUnknown(
          data['last_confirmed_at']!,
          _lastConfirmedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemAllocationEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemAllocationEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_item_id'],
      )!,
      targetType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_type'],
      )!,
      tripBagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_bag_id'],
      ),
      compartmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}compartment_id'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      lastConfirmedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_confirmed_at'],
      ),
    );
  }

  @override
  $ItemAllocationsTable createAlias(String alias) {
    return $ItemAllocationsTable(attachedDatabase, alias);
  }
}

class ItemAllocationEntry extends DataClass
    implements Insertable<ItemAllocationEntry> {
  final String id;
  final String tripItemId;
  final String targetType;
  final String? tripBagId;
  final String? compartmentId;
  final int quantity;
  final String? notes;
  final String? lastConfirmedAt;
  const ItemAllocationEntry({
    required this.id,
    required this.tripItemId,
    required this.targetType,
    this.tripBagId,
    this.compartmentId,
    required this.quantity,
    this.notes,
    this.lastConfirmedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_item_id'] = Variable<String>(tripItemId);
    map['target_type'] = Variable<String>(targetType);
    if (!nullToAbsent || tripBagId != null) {
      map['trip_bag_id'] = Variable<String>(tripBagId);
    }
    if (!nullToAbsent || compartmentId != null) {
      map['compartment_id'] = Variable<String>(compartmentId);
    }
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || lastConfirmedAt != null) {
      map['last_confirmed_at'] = Variable<String>(lastConfirmedAt);
    }
    return map;
  }

  ItemAllocationsCompanion toCompanion(bool nullToAbsent) {
    return ItemAllocationsCompanion(
      id: Value(id),
      tripItemId: Value(tripItemId),
      targetType: Value(targetType),
      tripBagId: tripBagId == null && nullToAbsent
          ? const Value.absent()
          : Value(tripBagId),
      compartmentId: compartmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(compartmentId),
      quantity: Value(quantity),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      lastConfirmedAt: lastConfirmedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastConfirmedAt),
    );
  }

  factory ItemAllocationEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemAllocationEntry(
      id: serializer.fromJson<String>(json['id']),
      tripItemId: serializer.fromJson<String>(json['tripItemId']),
      targetType: serializer.fromJson<String>(json['targetType']),
      tripBagId: serializer.fromJson<String?>(json['tripBagId']),
      compartmentId: serializer.fromJson<String?>(json['compartmentId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      notes: serializer.fromJson<String?>(json['notes']),
      lastConfirmedAt: serializer.fromJson<String?>(json['lastConfirmedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripItemId': serializer.toJson<String>(tripItemId),
      'targetType': serializer.toJson<String>(targetType),
      'tripBagId': serializer.toJson<String?>(tripBagId),
      'compartmentId': serializer.toJson<String?>(compartmentId),
      'quantity': serializer.toJson<int>(quantity),
      'notes': serializer.toJson<String?>(notes),
      'lastConfirmedAt': serializer.toJson<String?>(lastConfirmedAt),
    };
  }

  ItemAllocationEntry copyWith({
    String? id,
    String? tripItemId,
    String? targetType,
    Value<String?> tripBagId = const Value.absent(),
    Value<String?> compartmentId = const Value.absent(),
    int? quantity,
    Value<String?> notes = const Value.absent(),
    Value<String?> lastConfirmedAt = const Value.absent(),
  }) => ItemAllocationEntry(
    id: id ?? this.id,
    tripItemId: tripItemId ?? this.tripItemId,
    targetType: targetType ?? this.targetType,
    tripBagId: tripBagId.present ? tripBagId.value : this.tripBagId,
    compartmentId: compartmentId.present
        ? compartmentId.value
        : this.compartmentId,
    quantity: quantity ?? this.quantity,
    notes: notes.present ? notes.value : this.notes,
    lastConfirmedAt: lastConfirmedAt.present
        ? lastConfirmedAt.value
        : this.lastConfirmedAt,
  );
  ItemAllocationEntry copyWithCompanion(ItemAllocationsCompanion data) {
    return ItemAllocationEntry(
      id: data.id.present ? data.id.value : this.id,
      tripItemId: data.tripItemId.present
          ? data.tripItemId.value
          : this.tripItemId,
      targetType: data.targetType.present
          ? data.targetType.value
          : this.targetType,
      tripBagId: data.tripBagId.present ? data.tripBagId.value : this.tripBagId,
      compartmentId: data.compartmentId.present
          ? data.compartmentId.value
          : this.compartmentId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      notes: data.notes.present ? data.notes.value : this.notes,
      lastConfirmedAt: data.lastConfirmedAt.present
          ? data.lastConfirmedAt.value
          : this.lastConfirmedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemAllocationEntry(')
          ..write('id: $id, ')
          ..write('tripItemId: $tripItemId, ')
          ..write('targetType: $targetType, ')
          ..write('tripBagId: $tripBagId, ')
          ..write('compartmentId: $compartmentId, ')
          ..write('quantity: $quantity, ')
          ..write('notes: $notes, ')
          ..write('lastConfirmedAt: $lastConfirmedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tripItemId,
    targetType,
    tripBagId,
    compartmentId,
    quantity,
    notes,
    lastConfirmedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemAllocationEntry &&
          other.id == this.id &&
          other.tripItemId == this.tripItemId &&
          other.targetType == this.targetType &&
          other.tripBagId == this.tripBagId &&
          other.compartmentId == this.compartmentId &&
          other.quantity == this.quantity &&
          other.notes == this.notes &&
          other.lastConfirmedAt == this.lastConfirmedAt);
}

class ItemAllocationsCompanion extends UpdateCompanion<ItemAllocationEntry> {
  final Value<String> id;
  final Value<String> tripItemId;
  final Value<String> targetType;
  final Value<String?> tripBagId;
  final Value<String?> compartmentId;
  final Value<int> quantity;
  final Value<String?> notes;
  final Value<String?> lastConfirmedAt;
  final Value<int> rowid;
  const ItemAllocationsCompanion({
    this.id = const Value.absent(),
    this.tripItemId = const Value.absent(),
    this.targetType = const Value.absent(),
    this.tripBagId = const Value.absent(),
    this.compartmentId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.notes = const Value.absent(),
    this.lastConfirmedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemAllocationsCompanion.insert({
    required String id,
    required String tripItemId,
    this.targetType = const Value.absent(),
    this.tripBagId = const Value.absent(),
    this.compartmentId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.notes = const Value.absent(),
    this.lastConfirmedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tripItemId = Value(tripItemId);
  static Insertable<ItemAllocationEntry> custom({
    Expression<String>? id,
    Expression<String>? tripItemId,
    Expression<String>? targetType,
    Expression<String>? tripBagId,
    Expression<String>? compartmentId,
    Expression<int>? quantity,
    Expression<String>? notes,
    Expression<String>? lastConfirmedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripItemId != null) 'trip_item_id': tripItemId,
      if (targetType != null) 'target_type': targetType,
      if (tripBagId != null) 'trip_bag_id': tripBagId,
      if (compartmentId != null) 'compartment_id': compartmentId,
      if (quantity != null) 'quantity': quantity,
      if (notes != null) 'notes': notes,
      if (lastConfirmedAt != null) 'last_confirmed_at': lastConfirmedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemAllocationsCompanion copyWith({
    Value<String>? id,
    Value<String>? tripItemId,
    Value<String>? targetType,
    Value<String?>? tripBagId,
    Value<String?>? compartmentId,
    Value<int>? quantity,
    Value<String?>? notes,
    Value<String?>? lastConfirmedAt,
    Value<int>? rowid,
  }) {
    return ItemAllocationsCompanion(
      id: id ?? this.id,
      tripItemId: tripItemId ?? this.tripItemId,
      targetType: targetType ?? this.targetType,
      tripBagId: tripBagId ?? this.tripBagId,
      compartmentId: compartmentId ?? this.compartmentId,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
      lastConfirmedAt: lastConfirmedAt ?? this.lastConfirmedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripItemId.present) {
      map['trip_item_id'] = Variable<String>(tripItemId.value);
    }
    if (targetType.present) {
      map['target_type'] = Variable<String>(targetType.value);
    }
    if (tripBagId.present) {
      map['trip_bag_id'] = Variable<String>(tripBagId.value);
    }
    if (compartmentId.present) {
      map['compartment_id'] = Variable<String>(compartmentId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (lastConfirmedAt.present) {
      map['last_confirmed_at'] = Variable<String>(lastConfirmedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('tripItemId: $tripItemId, ')
          ..write('targetType: $targetType, ')
          ..write('tripBagId: $tripBagId, ')
          ..write('compartmentId: $compartmentId, ')
          ..write('quantity: $quantity, ')
          ..write('notes: $notes, ')
          ..write('lastConfirmedAt: $lastConfirmedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScheduleEventsTable extends ScheduleEvents
    with TableInfo<$ScheduleEventsTable, ScheduleEventEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduleEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tripStopIdMeta = const VerificationMeta(
    'tripStopId',
  );
  @override
  late final GeneratedColumn<String> tripStopId = GeneratedColumn<String>(
    'trip_stop_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trip_stops (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  static const VerificationMeta _isDateOnlyMeta = const VerificationMeta(
    'isDateOnly',
  );
  @override
  late final GeneratedColumn<bool> isDateOnly = GeneratedColumn<bool>(
    'is_date_only',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_date_only" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localStartMeta = const VerificationMeta(
    'localStart',
  );
  @override
  late final GeneratedColumn<String> localStart = GeneratedColumn<String>(
    'local_start',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startZoneMeta = const VerificationMeta(
    'startZone',
  );
  @override
  late final GeneratedColumn<String> startZone = GeneratedColumn<String>(
    'start_zone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startUtcMeta = const VerificationMeta(
    'startUtc',
  );
  @override
  late final GeneratedColumn<String> startUtc = GeneratedColumn<String>(
    'start_utc',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localEndMeta = const VerificationMeta(
    'localEnd',
  );
  @override
  late final GeneratedColumn<String> localEnd = GeneratedColumn<String>(
    'local_end',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endZoneMeta = const VerificationMeta(
    'endZone',
  );
  @override
  late final GeneratedColumn<String> endZone = GeneratedColumn<String>(
    'end_zone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endUtcMeta = const VerificationMeta('endUtc');
  @override
  late final GeneratedColumn<String> endUtc = GeneratedColumn<String>(
    'end_utc',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationTextMeta = const VerificationMeta(
    'locationText',
  );
  @override
  late final GeneratedColumn<String> locationText = GeneratedColumn<String>(
    'location_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('planned'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    tripStopId,
    title,
    type,
    isDateOnly,
    localDate,
    localStart,
    startZone,
    startUtc,
    localEnd,
    endZone,
    endUtc,
    locationText,
    notes,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedule_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduleEventEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('trip_stop_id')) {
      context.handle(
        _tripStopIdMeta,
        tripStopId.isAcceptableOrUnknown(
          data['trip_stop_id']!,
          _tripStopIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('is_date_only')) {
      context.handle(
        _isDateOnlyMeta,
        isDateOnly.isAcceptableOrUnknown(
          data['is_date_only']!,
          _isDateOnlyMeta,
        ),
      );
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('local_start')) {
      context.handle(
        _localStartMeta,
        localStart.isAcceptableOrUnknown(data['local_start']!, _localStartMeta),
      );
    }
    if (data.containsKey('start_zone')) {
      context.handle(
        _startZoneMeta,
        startZone.isAcceptableOrUnknown(data['start_zone']!, _startZoneMeta),
      );
    }
    if (data.containsKey('start_utc')) {
      context.handle(
        _startUtcMeta,
        startUtc.isAcceptableOrUnknown(data['start_utc']!, _startUtcMeta),
      );
    }
    if (data.containsKey('local_end')) {
      context.handle(
        _localEndMeta,
        localEnd.isAcceptableOrUnknown(data['local_end']!, _localEndMeta),
      );
    }
    if (data.containsKey('end_zone')) {
      context.handle(
        _endZoneMeta,
        endZone.isAcceptableOrUnknown(data['end_zone']!, _endZoneMeta),
      );
    }
    if (data.containsKey('end_utc')) {
      context.handle(
        _endUtcMeta,
        endUtc.isAcceptableOrUnknown(data['end_utc']!, _endUtcMeta),
      );
    }
    if (data.containsKey('location_text')) {
      context.handle(
        _locationTextMeta,
        locationText.isAcceptableOrUnknown(
          data['location_text']!,
          _locationTextMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleEventEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleEventEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      tripStopId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_stop_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      isDateOnly: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_date_only'],
      )!,
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
      localStart: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_start'],
      ),
      startZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_zone'],
      ),
      startUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_utc'],
      ),
      localEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_end'],
      ),
      endZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_zone'],
      ),
      endUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_utc'],
      ),
      locationText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_text'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $ScheduleEventsTable createAlias(String alias) {
    return $ScheduleEventsTable(attachedDatabase, alias);
  }
}

class ScheduleEventEntry extends DataClass
    implements Insertable<ScheduleEventEntry> {
  final String id;
  final String tripId;
  final String? tripStopId;
  final String title;
  final String type;
  final bool isDateOnly;
  final String localDate;
  final String? localStart;
  final String? startZone;
  final String? startUtc;
  final String? localEnd;
  final String? endZone;
  final String? endUtc;
  final String? locationText;
  final String? notes;
  final String status;
  const ScheduleEventEntry({
    required this.id,
    required this.tripId,
    this.tripStopId,
    required this.title,
    required this.type,
    required this.isDateOnly,
    required this.localDate,
    this.localStart,
    this.startZone,
    this.startUtc,
    this.localEnd,
    this.endZone,
    this.endUtc,
    this.locationText,
    this.notes,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_id'] = Variable<String>(tripId);
    if (!nullToAbsent || tripStopId != null) {
      map['trip_stop_id'] = Variable<String>(tripStopId);
    }
    map['title'] = Variable<String>(title);
    map['type'] = Variable<String>(type);
    map['is_date_only'] = Variable<bool>(isDateOnly);
    map['local_date'] = Variable<String>(localDate);
    if (!nullToAbsent || localStart != null) {
      map['local_start'] = Variable<String>(localStart);
    }
    if (!nullToAbsent || startZone != null) {
      map['start_zone'] = Variable<String>(startZone);
    }
    if (!nullToAbsent || startUtc != null) {
      map['start_utc'] = Variable<String>(startUtc);
    }
    if (!nullToAbsent || localEnd != null) {
      map['local_end'] = Variable<String>(localEnd);
    }
    if (!nullToAbsent || endZone != null) {
      map['end_zone'] = Variable<String>(endZone);
    }
    if (!nullToAbsent || endUtc != null) {
      map['end_utc'] = Variable<String>(endUtc);
    }
    if (!nullToAbsent || locationText != null) {
      map['location_text'] = Variable<String>(locationText);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  ScheduleEventsCompanion toCompanion(bool nullToAbsent) {
    return ScheduleEventsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      tripStopId: tripStopId == null && nullToAbsent
          ? const Value.absent()
          : Value(tripStopId),
      title: Value(title),
      type: Value(type),
      isDateOnly: Value(isDateOnly),
      localDate: Value(localDate),
      localStart: localStart == null && nullToAbsent
          ? const Value.absent()
          : Value(localStart),
      startZone: startZone == null && nullToAbsent
          ? const Value.absent()
          : Value(startZone),
      startUtc: startUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(startUtc),
      localEnd: localEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(localEnd),
      endZone: endZone == null && nullToAbsent
          ? const Value.absent()
          : Value(endZone),
      endUtc: endUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(endUtc),
      locationText: locationText == null && nullToAbsent
          ? const Value.absent()
          : Value(locationText),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      status: Value(status),
    );
  }

  factory ScheduleEventEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleEventEntry(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      tripStopId: serializer.fromJson<String?>(json['tripStopId']),
      title: serializer.fromJson<String>(json['title']),
      type: serializer.fromJson<String>(json['type']),
      isDateOnly: serializer.fromJson<bool>(json['isDateOnly']),
      localDate: serializer.fromJson<String>(json['localDate']),
      localStart: serializer.fromJson<String?>(json['localStart']),
      startZone: serializer.fromJson<String?>(json['startZone']),
      startUtc: serializer.fromJson<String?>(json['startUtc']),
      localEnd: serializer.fromJson<String?>(json['localEnd']),
      endZone: serializer.fromJson<String?>(json['endZone']),
      endUtc: serializer.fromJson<String?>(json['endUtc']),
      locationText: serializer.fromJson<String?>(json['locationText']),
      notes: serializer.fromJson<String?>(json['notes']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String>(tripId),
      'tripStopId': serializer.toJson<String?>(tripStopId),
      'title': serializer.toJson<String>(title),
      'type': serializer.toJson<String>(type),
      'isDateOnly': serializer.toJson<bool>(isDateOnly),
      'localDate': serializer.toJson<String>(localDate),
      'localStart': serializer.toJson<String?>(localStart),
      'startZone': serializer.toJson<String?>(startZone),
      'startUtc': serializer.toJson<String?>(startUtc),
      'localEnd': serializer.toJson<String?>(localEnd),
      'endZone': serializer.toJson<String?>(endZone),
      'endUtc': serializer.toJson<String?>(endUtc),
      'locationText': serializer.toJson<String?>(locationText),
      'notes': serializer.toJson<String?>(notes),
      'status': serializer.toJson<String>(status),
    };
  }

  ScheduleEventEntry copyWith({
    String? id,
    String? tripId,
    Value<String?> tripStopId = const Value.absent(),
    String? title,
    String? type,
    bool? isDateOnly,
    String? localDate,
    Value<String?> localStart = const Value.absent(),
    Value<String?> startZone = const Value.absent(),
    Value<String?> startUtc = const Value.absent(),
    Value<String?> localEnd = const Value.absent(),
    Value<String?> endZone = const Value.absent(),
    Value<String?> endUtc = const Value.absent(),
    Value<String?> locationText = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? status,
  }) => ScheduleEventEntry(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    tripStopId: tripStopId.present ? tripStopId.value : this.tripStopId,
    title: title ?? this.title,
    type: type ?? this.type,
    isDateOnly: isDateOnly ?? this.isDateOnly,
    localDate: localDate ?? this.localDate,
    localStart: localStart.present ? localStart.value : this.localStart,
    startZone: startZone.present ? startZone.value : this.startZone,
    startUtc: startUtc.present ? startUtc.value : this.startUtc,
    localEnd: localEnd.present ? localEnd.value : this.localEnd,
    endZone: endZone.present ? endZone.value : this.endZone,
    endUtc: endUtc.present ? endUtc.value : this.endUtc,
    locationText: locationText.present ? locationText.value : this.locationText,
    notes: notes.present ? notes.value : this.notes,
    status: status ?? this.status,
  );
  ScheduleEventEntry copyWithCompanion(ScheduleEventsCompanion data) {
    return ScheduleEventEntry(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      tripStopId: data.tripStopId.present
          ? data.tripStopId.value
          : this.tripStopId,
      title: data.title.present ? data.title.value : this.title,
      type: data.type.present ? data.type.value : this.type,
      isDateOnly: data.isDateOnly.present
          ? data.isDateOnly.value
          : this.isDateOnly,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      localStart: data.localStart.present
          ? data.localStart.value
          : this.localStart,
      startZone: data.startZone.present ? data.startZone.value : this.startZone,
      startUtc: data.startUtc.present ? data.startUtc.value : this.startUtc,
      localEnd: data.localEnd.present ? data.localEnd.value : this.localEnd,
      endZone: data.endZone.present ? data.endZone.value : this.endZone,
      endUtc: data.endUtc.present ? data.endUtc.value : this.endUtc,
      locationText: data.locationText.present
          ? data.locationText.value
          : this.locationText,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleEventEntry(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('tripStopId: $tripStopId, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('isDateOnly: $isDateOnly, ')
          ..write('localDate: $localDate, ')
          ..write('localStart: $localStart, ')
          ..write('startZone: $startZone, ')
          ..write('startUtc: $startUtc, ')
          ..write('localEnd: $localEnd, ')
          ..write('endZone: $endZone, ')
          ..write('endUtc: $endUtc, ')
          ..write('locationText: $locationText, ')
          ..write('notes: $notes, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tripId,
    tripStopId,
    title,
    type,
    isDateOnly,
    localDate,
    localStart,
    startZone,
    startUtc,
    localEnd,
    endZone,
    endUtc,
    locationText,
    notes,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleEventEntry &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.tripStopId == this.tripStopId &&
          other.title == this.title &&
          other.type == this.type &&
          other.isDateOnly == this.isDateOnly &&
          other.localDate == this.localDate &&
          other.localStart == this.localStart &&
          other.startZone == this.startZone &&
          other.startUtc == this.startUtc &&
          other.localEnd == this.localEnd &&
          other.endZone == this.endZone &&
          other.endUtc == this.endUtc &&
          other.locationText == this.locationText &&
          other.notes == this.notes &&
          other.status == this.status);
}

class ScheduleEventsCompanion extends UpdateCompanion<ScheduleEventEntry> {
  final Value<String> id;
  final Value<String> tripId;
  final Value<String?> tripStopId;
  final Value<String> title;
  final Value<String> type;
  final Value<bool> isDateOnly;
  final Value<String> localDate;
  final Value<String?> localStart;
  final Value<String?> startZone;
  final Value<String?> startUtc;
  final Value<String?> localEnd;
  final Value<String?> endZone;
  final Value<String?> endUtc;
  final Value<String?> locationText;
  final Value<String?> notes;
  final Value<String> status;
  final Value<int> rowid;
  const ScheduleEventsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.tripStopId = const Value.absent(),
    this.title = const Value.absent(),
    this.type = const Value.absent(),
    this.isDateOnly = const Value.absent(),
    this.localDate = const Value.absent(),
    this.localStart = const Value.absent(),
    this.startZone = const Value.absent(),
    this.startUtc = const Value.absent(),
    this.localEnd = const Value.absent(),
    this.endZone = const Value.absent(),
    this.endUtc = const Value.absent(),
    this.locationText = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScheduleEventsCompanion.insert({
    required String id,
    required String tripId,
    this.tripStopId = const Value.absent(),
    required String title,
    required String type,
    this.isDateOnly = const Value.absent(),
    required String localDate,
    this.localStart = const Value.absent(),
    this.startZone = const Value.absent(),
    this.startUtc = const Value.absent(),
    this.localEnd = const Value.absent(),
    this.endZone = const Value.absent(),
    this.endUtc = const Value.absent(),
    this.locationText = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tripId = Value(tripId),
       title = Value(title),
       type = Value(type),
       localDate = Value(localDate);
  static Insertable<ScheduleEventEntry> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<String>? tripStopId,
    Expression<String>? title,
    Expression<String>? type,
    Expression<bool>? isDateOnly,
    Expression<String>? localDate,
    Expression<String>? localStart,
    Expression<String>? startZone,
    Expression<String>? startUtc,
    Expression<String>? localEnd,
    Expression<String>? endZone,
    Expression<String>? endUtc,
    Expression<String>? locationText,
    Expression<String>? notes,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (tripStopId != null) 'trip_stop_id': tripStopId,
      if (title != null) 'title': title,
      if (type != null) 'type': type,
      if (isDateOnly != null) 'is_date_only': isDateOnly,
      if (localDate != null) 'local_date': localDate,
      if (localStart != null) 'local_start': localStart,
      if (startZone != null) 'start_zone': startZone,
      if (startUtc != null) 'start_utc': startUtc,
      if (localEnd != null) 'local_end': localEnd,
      if (endZone != null) 'end_zone': endZone,
      if (endUtc != null) 'end_utc': endUtc,
      if (locationText != null) 'location_text': locationText,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScheduleEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? tripId,
    Value<String?>? tripStopId,
    Value<String>? title,
    Value<String>? type,
    Value<bool>? isDateOnly,
    Value<String>? localDate,
    Value<String?>? localStart,
    Value<String?>? startZone,
    Value<String?>? startUtc,
    Value<String?>? localEnd,
    Value<String?>? endZone,
    Value<String?>? endUtc,
    Value<String?>? locationText,
    Value<String?>? notes,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return ScheduleEventsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      tripStopId: tripStopId ?? this.tripStopId,
      title: title ?? this.title,
      type: type ?? this.type,
      isDateOnly: isDateOnly ?? this.isDateOnly,
      localDate: localDate ?? this.localDate,
      localStart: localStart ?? this.localStart,
      startZone: startZone ?? this.startZone,
      startUtc: startUtc ?? this.startUtc,
      localEnd: localEnd ?? this.localEnd,
      endZone: endZone ?? this.endZone,
      endUtc: endUtc ?? this.endUtc,
      locationText: locationText ?? this.locationText,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (tripStopId.present) {
      map['trip_stop_id'] = Variable<String>(tripStopId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (isDateOnly.present) {
      map['is_date_only'] = Variable<bool>(isDateOnly.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (localStart.present) {
      map['local_start'] = Variable<String>(localStart.value);
    }
    if (startZone.present) {
      map['start_zone'] = Variable<String>(startZone.value);
    }
    if (startUtc.present) {
      map['start_utc'] = Variable<String>(startUtc.value);
    }
    if (localEnd.present) {
      map['local_end'] = Variable<String>(localEnd.value);
    }
    if (endZone.present) {
      map['end_zone'] = Variable<String>(endZone.value);
    }
    if (endUtc.present) {
      map['end_utc'] = Variable<String>(endUtc.value);
    }
    if (locationText.present) {
      map['location_text'] = Variable<String>(locationText.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleEventsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('tripStopId: $tripStopId, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('isDateOnly: $isDateOnly, ')
          ..write('localDate: $localDate, ')
          ..write('localStart: $localStart, ')
          ..write('startZone: $startZone, ')
          ..write('startUtc: $startUtc, ')
          ..write('localEnd: $localEnd, ')
          ..write('endZone: $endZone, ')
          ..write('endUtc: $endUtc, ')
          ..write('locationText: $locationText, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TicketsTable extends Tickets with TableInfo<$TicketsTable, TicketEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TicketsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _scheduleEventIdMeta = const VerificationMeta(
    'scheduleEventId',
  );
  @override
  late final GeneratedColumn<String> scheduleEventId = GeneratedColumn<String>(
    'schedule_event_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES schedule_events (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bookingCodeMeta = const VerificationMeta(
    'bookingCode',
  );
  @override
  late final GeneratedColumn<String> bookingCode = GeneratedColumn<String>(
    'booking_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    scheduleEventId,
    title,
    provider,
    bookingCode,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tickets';
  @override
  VerificationContext validateIntegrity(
    Insertable<TicketEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('schedule_event_id')) {
      context.handle(
        _scheduleEventIdMeta,
        scheduleEventId.isAcceptableOrUnknown(
          data['schedule_event_id']!,
          _scheduleEventIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    }
    if (data.containsKey('booking_code')) {
      context.handle(
        _bookingCodeMeta,
        bookingCode.isAcceptableOrUnknown(
          data['booking_code']!,
          _bookingCodeMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TicketEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TicketEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      scheduleEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_event_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      ),
      bookingCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}booking_code'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $TicketsTable createAlias(String alias) {
    return $TicketsTable(attachedDatabase, alias);
  }
}

class TicketEntry extends DataClass implements Insertable<TicketEntry> {
  final String id;
  final String tripId;
  final String? scheduleEventId;
  final String title;
  final String? provider;
  final String? bookingCode;
  final String? notes;
  const TicketEntry({
    required this.id,
    required this.tripId,
    this.scheduleEventId,
    required this.title,
    this.provider,
    this.bookingCode,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_id'] = Variable<String>(tripId);
    if (!nullToAbsent || scheduleEventId != null) {
      map['schedule_event_id'] = Variable<String>(scheduleEventId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || provider != null) {
      map['provider'] = Variable<String>(provider);
    }
    if (!nullToAbsent || bookingCode != null) {
      map['booking_code'] = Variable<String>(bookingCode);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  TicketsCompanion toCompanion(bool nullToAbsent) {
    return TicketsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      scheduleEventId: scheduleEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduleEventId),
      title: Value(title),
      provider: provider == null && nullToAbsent
          ? const Value.absent()
          : Value(provider),
      bookingCode: bookingCode == null && nullToAbsent
          ? const Value.absent()
          : Value(bookingCode),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory TicketEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TicketEntry(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      scheduleEventId: serializer.fromJson<String?>(json['scheduleEventId']),
      title: serializer.fromJson<String>(json['title']),
      provider: serializer.fromJson<String?>(json['provider']),
      bookingCode: serializer.fromJson<String?>(json['bookingCode']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String>(tripId),
      'scheduleEventId': serializer.toJson<String?>(scheduleEventId),
      'title': serializer.toJson<String>(title),
      'provider': serializer.toJson<String?>(provider),
      'bookingCode': serializer.toJson<String?>(bookingCode),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  TicketEntry copyWith({
    String? id,
    String? tripId,
    Value<String?> scheduleEventId = const Value.absent(),
    String? title,
    Value<String?> provider = const Value.absent(),
    Value<String?> bookingCode = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => TicketEntry(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    scheduleEventId: scheduleEventId.present
        ? scheduleEventId.value
        : this.scheduleEventId,
    title: title ?? this.title,
    provider: provider.present ? provider.value : this.provider,
    bookingCode: bookingCode.present ? bookingCode.value : this.bookingCode,
    notes: notes.present ? notes.value : this.notes,
  );
  TicketEntry copyWithCompanion(TicketsCompanion data) {
    return TicketEntry(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      scheduleEventId: data.scheduleEventId.present
          ? data.scheduleEventId.value
          : this.scheduleEventId,
      title: data.title.present ? data.title.value : this.title,
      provider: data.provider.present ? data.provider.value : this.provider,
      bookingCode: data.bookingCode.present
          ? data.bookingCode.value
          : this.bookingCode,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TicketEntry(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('scheduleEventId: $scheduleEventId, ')
          ..write('title: $title, ')
          ..write('provider: $provider, ')
          ..write('bookingCode: $bookingCode, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tripId,
    scheduleEventId,
    title,
    provider,
    bookingCode,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TicketEntry &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.scheduleEventId == this.scheduleEventId &&
          other.title == this.title &&
          other.provider == this.provider &&
          other.bookingCode == this.bookingCode &&
          other.notes == this.notes);
}

class TicketsCompanion extends UpdateCompanion<TicketEntry> {
  final Value<String> id;
  final Value<String> tripId;
  final Value<String?> scheduleEventId;
  final Value<String> title;
  final Value<String?> provider;
  final Value<String?> bookingCode;
  final Value<String?> notes;
  final Value<int> rowid;
  const TicketsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.scheduleEventId = const Value.absent(),
    this.title = const Value.absent(),
    this.provider = const Value.absent(),
    this.bookingCode = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TicketsCompanion.insert({
    required String id,
    required String tripId,
    this.scheduleEventId = const Value.absent(),
    required String title,
    this.provider = const Value.absent(),
    this.bookingCode = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tripId = Value(tripId),
       title = Value(title);
  static Insertable<TicketEntry> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<String>? scheduleEventId,
    Expression<String>? title,
    Expression<String>? provider,
    Expression<String>? bookingCode,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (scheduleEventId != null) 'schedule_event_id': scheduleEventId,
      if (title != null) 'title': title,
      if (provider != null) 'provider': provider,
      if (bookingCode != null) 'booking_code': bookingCode,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TicketsCompanion copyWith({
    Value<String>? id,
    Value<String>? tripId,
    Value<String?>? scheduleEventId,
    Value<String>? title,
    Value<String?>? provider,
    Value<String?>? bookingCode,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return TicketsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      scheduleEventId: scheduleEventId ?? this.scheduleEventId,
      title: title ?? this.title,
      provider: provider ?? this.provider,
      bookingCode: bookingCode ?? this.bookingCode,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (scheduleEventId.present) {
      map['schedule_event_id'] = Variable<String>(scheduleEventId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (bookingCode.present) {
      map['booking_code'] = Variable<String>(bookingCode.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TicketsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('scheduleEventId: $scheduleEventId, ')
          ..write('title: $title, ')
          ..write('provider: $provider, ')
          ..write('bookingCode: $bookingCode, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TicketAttachmentsTable extends TicketAttachments
    with TableInfo<$TicketAttachmentsTable, TicketAttachmentEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TicketAttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ticketIdMeta = const VerificationMeta(
    'ticketId',
  );
  @override
  late final GeneratedColumn<String> ticketId = GeneratedColumn<String>(
    'ticket_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tickets (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _assetIdMeta = const VerificationMeta(
    'assetId',
  );
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES assets (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, ticketId, assetId, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ticket_attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<TicketAttachmentEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('ticket_id')) {
      context.handle(
        _ticketIdMeta,
        ticketId.isAcceptableOrUnknown(data['ticket_id']!, _ticketIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ticketIdMeta);
    }
    if (data.containsKey('asset_id')) {
      context.handle(
        _assetIdMeta,
        assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TicketAttachmentEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TicketAttachmentEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ticketId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ticket_id'],
      )!,
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $TicketAttachmentsTable createAlias(String alias) {
    return $TicketAttachmentsTable(attachedDatabase, alias);
  }
}

class TicketAttachmentEntry extends DataClass
    implements Insertable<TicketAttachmentEntry> {
  final String id;
  final String ticketId;
  final String assetId;
  final int sortOrder;
  const TicketAttachmentEntry({
    required this.id,
    required this.ticketId,
    required this.assetId,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['ticket_id'] = Variable<String>(ticketId);
    map['asset_id'] = Variable<String>(assetId);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  TicketAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return TicketAttachmentsCompanion(
      id: Value(id),
      ticketId: Value(ticketId),
      assetId: Value(assetId),
      sortOrder: Value(sortOrder),
    );
  }

  factory TicketAttachmentEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TicketAttachmentEntry(
      id: serializer.fromJson<String>(json['id']),
      ticketId: serializer.fromJson<String>(json['ticketId']),
      assetId: serializer.fromJson<String>(json['assetId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ticketId': serializer.toJson<String>(ticketId),
      'assetId': serializer.toJson<String>(assetId),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  TicketAttachmentEntry copyWith({
    String? id,
    String? ticketId,
    String? assetId,
    int? sortOrder,
  }) => TicketAttachmentEntry(
    id: id ?? this.id,
    ticketId: ticketId ?? this.ticketId,
    assetId: assetId ?? this.assetId,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  TicketAttachmentEntry copyWithCompanion(TicketAttachmentsCompanion data) {
    return TicketAttachmentEntry(
      id: data.id.present ? data.id.value : this.id,
      ticketId: data.ticketId.present ? data.ticketId.value : this.ticketId,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TicketAttachmentEntry(')
          ..write('id: $id, ')
          ..write('ticketId: $ticketId, ')
          ..write('assetId: $assetId, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ticketId, assetId, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TicketAttachmentEntry &&
          other.id == this.id &&
          other.ticketId == this.ticketId &&
          other.assetId == this.assetId &&
          other.sortOrder == this.sortOrder);
}

class TicketAttachmentsCompanion
    extends UpdateCompanion<TicketAttachmentEntry> {
  final Value<String> id;
  final Value<String> ticketId;
  final Value<String> assetId;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const TicketAttachmentsCompanion({
    this.id = const Value.absent(),
    this.ticketId = const Value.absent(),
    this.assetId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TicketAttachmentsCompanion.insert({
    required String id,
    required String ticketId,
    required String assetId,
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ticketId = Value(ticketId),
       assetId = Value(assetId);
  static Insertable<TicketAttachmentEntry> custom({
    Expression<String>? id,
    Expression<String>? ticketId,
    Expression<String>? assetId,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ticketId != null) 'ticket_id': ticketId,
      if (assetId != null) 'asset_id': assetId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TicketAttachmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? ticketId,
    Value<String>? assetId,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return TicketAttachmentsCompanion(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      assetId: assetId ?? this.assetId,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ticketId.present) {
      map['ticket_id'] = Variable<String>(ticketId.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TicketAttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('ticketId: $ticketId, ')
          ..write('assetId: $assetId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, ReminderEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduleEventIdMeta = const VerificationMeta(
    'scheduleEventId',
  );
  @override
  late final GeneratedColumn<String> scheduleEventId = GeneratedColumn<String>(
    'schedule_event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES schedule_events (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _triggerUtcMeta = const VerificationMeta(
    'triggerUtc',
  );
  @override
  late final GeneratedColumn<String> triggerUtc = GeneratedColumn<String>(
    'trigger_utc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notificationIdMeta = const VerificationMeta(
    'notificationId',
  );
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
    'notification_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _precisionPreferenceMeta =
      const VerificationMeta('precisionPreference');
  @override
  late final GeneratedColumn<String> precisionPreference =
      GeneratedColumn<String>(
        'precision_preference',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('exact'),
      );
  static const VerificationMeta _schedulingStateMeta = const VerificationMeta(
    'schedulingState',
  );
  @override
  late final GeneratedColumn<String> schedulingState = GeneratedColumn<String>(
    'scheduling_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    scheduleEventId,
    triggerUtc,
    notificationId,
    precisionPreference,
    schedulingState,
    enabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('schedule_event_id')) {
      context.handle(
        _scheduleEventIdMeta,
        scheduleEventId.isAcceptableOrUnknown(
          data['schedule_event_id']!,
          _scheduleEventIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduleEventIdMeta);
    }
    if (data.containsKey('trigger_utc')) {
      context.handle(
        _triggerUtcMeta,
        triggerUtc.isAcceptableOrUnknown(data['trigger_utc']!, _triggerUtcMeta),
      );
    } else if (isInserting) {
      context.missing(_triggerUtcMeta);
    }
    if (data.containsKey('notification_id')) {
      context.handle(
        _notificationIdMeta,
        notificationId.isAcceptableOrUnknown(
          data['notification_id']!,
          _notificationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notificationIdMeta);
    }
    if (data.containsKey('precision_preference')) {
      context.handle(
        _precisionPreferenceMeta,
        precisionPreference.isAcceptableOrUnknown(
          data['precision_preference']!,
          _precisionPreferenceMeta,
        ),
      );
    }
    if (data.containsKey('scheduling_state')) {
      context.handle(
        _schedulingStateMeta,
        schedulingState.isAcceptableOrUnknown(
          data['scheduling_state']!,
          _schedulingStateMeta,
        ),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      scheduleEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_event_id'],
      )!,
      triggerUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trigger_utc'],
      )!,
      notificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notification_id'],
      )!,
      precisionPreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}precision_preference'],
      )!,
      schedulingState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheduling_state'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class ReminderEntry extends DataClass implements Insertable<ReminderEntry> {
  final String id;
  final String scheduleEventId;
  final String triggerUtc;
  final int notificationId;
  final String precisionPreference;
  final String schedulingState;
  final bool enabled;
  const ReminderEntry({
    required this.id,
    required this.scheduleEventId,
    required this.triggerUtc,
    required this.notificationId,
    required this.precisionPreference,
    required this.schedulingState,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['schedule_event_id'] = Variable<String>(scheduleEventId);
    map['trigger_utc'] = Variable<String>(triggerUtc);
    map['notification_id'] = Variable<int>(notificationId);
    map['precision_preference'] = Variable<String>(precisionPreference);
    map['scheduling_state'] = Variable<String>(schedulingState);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      scheduleEventId: Value(scheduleEventId),
      triggerUtc: Value(triggerUtc),
      notificationId: Value(notificationId),
      precisionPreference: Value(precisionPreference),
      schedulingState: Value(schedulingState),
      enabled: Value(enabled),
    );
  }

  factory ReminderEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderEntry(
      id: serializer.fromJson<String>(json['id']),
      scheduleEventId: serializer.fromJson<String>(json['scheduleEventId']),
      triggerUtc: serializer.fromJson<String>(json['triggerUtc']),
      notificationId: serializer.fromJson<int>(json['notificationId']),
      precisionPreference: serializer.fromJson<String>(
        json['precisionPreference'],
      ),
      schedulingState: serializer.fromJson<String>(json['schedulingState']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'scheduleEventId': serializer.toJson<String>(scheduleEventId),
      'triggerUtc': serializer.toJson<String>(triggerUtc),
      'notificationId': serializer.toJson<int>(notificationId),
      'precisionPreference': serializer.toJson<String>(precisionPreference),
      'schedulingState': serializer.toJson<String>(schedulingState),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  ReminderEntry copyWith({
    String? id,
    String? scheduleEventId,
    String? triggerUtc,
    int? notificationId,
    String? precisionPreference,
    String? schedulingState,
    bool? enabled,
  }) => ReminderEntry(
    id: id ?? this.id,
    scheduleEventId: scheduleEventId ?? this.scheduleEventId,
    triggerUtc: triggerUtc ?? this.triggerUtc,
    notificationId: notificationId ?? this.notificationId,
    precisionPreference: precisionPreference ?? this.precisionPreference,
    schedulingState: schedulingState ?? this.schedulingState,
    enabled: enabled ?? this.enabled,
  );
  ReminderEntry copyWithCompanion(RemindersCompanion data) {
    return ReminderEntry(
      id: data.id.present ? data.id.value : this.id,
      scheduleEventId: data.scheduleEventId.present
          ? data.scheduleEventId.value
          : this.scheduleEventId,
      triggerUtc: data.triggerUtc.present
          ? data.triggerUtc.value
          : this.triggerUtc,
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      precisionPreference: data.precisionPreference.present
          ? data.precisionPreference.value
          : this.precisionPreference,
      schedulingState: data.schedulingState.present
          ? data.schedulingState.value
          : this.schedulingState,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderEntry(')
          ..write('id: $id, ')
          ..write('scheduleEventId: $scheduleEventId, ')
          ..write('triggerUtc: $triggerUtc, ')
          ..write('notificationId: $notificationId, ')
          ..write('precisionPreference: $precisionPreference, ')
          ..write('schedulingState: $schedulingState, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    scheduleEventId,
    triggerUtc,
    notificationId,
    precisionPreference,
    schedulingState,
    enabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderEntry &&
          other.id == this.id &&
          other.scheduleEventId == this.scheduleEventId &&
          other.triggerUtc == this.triggerUtc &&
          other.notificationId == this.notificationId &&
          other.precisionPreference == this.precisionPreference &&
          other.schedulingState == this.schedulingState &&
          other.enabled == this.enabled);
}

class RemindersCompanion extends UpdateCompanion<ReminderEntry> {
  final Value<String> id;
  final Value<String> scheduleEventId;
  final Value<String> triggerUtc;
  final Value<int> notificationId;
  final Value<String> precisionPreference;
  final Value<String> schedulingState;
  final Value<bool> enabled;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.scheduleEventId = const Value.absent(),
    this.triggerUtc = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.precisionPreference = const Value.absent(),
    this.schedulingState = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    required String id,
    required String scheduleEventId,
    required String triggerUtc,
    required int notificationId,
    this.precisionPreference = const Value.absent(),
    this.schedulingState = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       scheduleEventId = Value(scheduleEventId),
       triggerUtc = Value(triggerUtc),
       notificationId = Value(notificationId);
  static Insertable<ReminderEntry> custom({
    Expression<String>? id,
    Expression<String>? scheduleEventId,
    Expression<String>? triggerUtc,
    Expression<int>? notificationId,
    Expression<String>? precisionPreference,
    Expression<String>? schedulingState,
    Expression<bool>? enabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scheduleEventId != null) 'schedule_event_id': scheduleEventId,
      if (triggerUtc != null) 'trigger_utc': triggerUtc,
      if (notificationId != null) 'notification_id': notificationId,
      if (precisionPreference != null)
        'precision_preference': precisionPreference,
      if (schedulingState != null) 'scheduling_state': schedulingState,
      if (enabled != null) 'enabled': enabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith({
    Value<String>? id,
    Value<String>? scheduleEventId,
    Value<String>? triggerUtc,
    Value<int>? notificationId,
    Value<String>? precisionPreference,
    Value<String>? schedulingState,
    Value<bool>? enabled,
    Value<int>? rowid,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      scheduleEventId: scheduleEventId ?? this.scheduleEventId,
      triggerUtc: triggerUtc ?? this.triggerUtc,
      notificationId: notificationId ?? this.notificationId,
      precisionPreference: precisionPreference ?? this.precisionPreference,
      schedulingState: schedulingState ?? this.schedulingState,
      enabled: enabled ?? this.enabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (scheduleEventId.present) {
      map['schedule_event_id'] = Variable<String>(scheduleEventId.value);
    }
    if (triggerUtc.present) {
      map['trigger_utc'] = Variable<String>(triggerUtc.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    if (precisionPreference.present) {
      map['precision_preference'] = Variable<String>(precisionPreference.value);
    }
    if (schedulingState.present) {
      map['scheduling_state'] = Variable<String>(schedulingState.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('scheduleEventId: $scheduleEventId, ')
          ..write('triggerUtc: $triggerUtc, ')
          ..write('notificationId: $notificationId, ')
          ..write('precisionPreference: $precisionPreference, ')
          ..write('schedulingState: $schedulingState, ')
          ..write('enabled: $enabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReturnCheckpointsTable extends ReturnCheckpoints
    with TableInfo<$ReturnCheckpointsTable, ReturnCheckpointEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReturnCheckpointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tripStopIdMeta = const VerificationMeta(
    'tripStopId',
  );
  @override
  late final GeneratedColumn<String> tripStopId = GeneratedColumn<String>(
    'trip_stop_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trip_stops (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closedAtMeta = const VerificationMeta(
    'closedAt',
  );
  @override
  late final GeneratedColumn<String> closedAt = GeneratedColumn<String>(
    'closed_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _closeStateMeta = const VerificationMeta(
    'closeState',
  );
  @override
  late final GeneratedColumn<String> closeState = GeneratedColumn<String>(
    'close_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('open'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    tripStopId,
    title,
    createdAt,
    closedAt,
    closeState,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'return_checkpoints';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReturnCheckpointEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('trip_stop_id')) {
      context.handle(
        _tripStopIdMeta,
        tripStopId.isAcceptableOrUnknown(
          data['trip_stop_id']!,
          _tripStopIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    }
    if (data.containsKey('close_state')) {
      context.handle(
        _closeStateMeta,
        closeState.isAcceptableOrUnknown(data['close_state']!, _closeStateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReturnCheckpointEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReturnCheckpointEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      tripStopId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_stop_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}closed_at'],
      ),
      closeState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}close_state'],
      )!,
    );
  }

  @override
  $ReturnCheckpointsTable createAlias(String alias) {
    return $ReturnCheckpointsTable(attachedDatabase, alias);
  }
}

class ReturnCheckpointEntry extends DataClass
    implements Insertable<ReturnCheckpointEntry> {
  final String id;
  final String tripId;
  final String? tripStopId;
  final String title;
  final String createdAt;
  final String? closedAt;
  final String closeState;
  const ReturnCheckpointEntry({
    required this.id,
    required this.tripId,
    this.tripStopId,
    required this.title,
    required this.createdAt,
    this.closedAt,
    required this.closeState,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_id'] = Variable<String>(tripId);
    if (!nullToAbsent || tripStopId != null) {
      map['trip_stop_id'] = Variable<String>(tripStopId);
    }
    map['title'] = Variable<String>(title);
    map['created_at'] = Variable<String>(createdAt);
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<String>(closedAt);
    }
    map['close_state'] = Variable<String>(closeState);
    return map;
  }

  ReturnCheckpointsCompanion toCompanion(bool nullToAbsent) {
    return ReturnCheckpointsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      tripStopId: tripStopId == null && nullToAbsent
          ? const Value.absent()
          : Value(tripStopId),
      title: Value(title),
      createdAt: Value(createdAt),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
      closeState: Value(closeState),
    );
  }

  factory ReturnCheckpointEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReturnCheckpointEntry(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      tripStopId: serializer.fromJson<String?>(json['tripStopId']),
      title: serializer.fromJson<String>(json['title']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      closedAt: serializer.fromJson<String?>(json['closedAt']),
      closeState: serializer.fromJson<String>(json['closeState']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String>(tripId),
      'tripStopId': serializer.toJson<String?>(tripStopId),
      'title': serializer.toJson<String>(title),
      'createdAt': serializer.toJson<String>(createdAt),
      'closedAt': serializer.toJson<String?>(closedAt),
      'closeState': serializer.toJson<String>(closeState),
    };
  }

  ReturnCheckpointEntry copyWith({
    String? id,
    String? tripId,
    Value<String?> tripStopId = const Value.absent(),
    String? title,
    String? createdAt,
    Value<String?> closedAt = const Value.absent(),
    String? closeState,
  }) => ReturnCheckpointEntry(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    tripStopId: tripStopId.present ? tripStopId.value : this.tripStopId,
    title: title ?? this.title,
    createdAt: createdAt ?? this.createdAt,
    closedAt: closedAt.present ? closedAt.value : this.closedAt,
    closeState: closeState ?? this.closeState,
  );
  ReturnCheckpointEntry copyWithCompanion(ReturnCheckpointsCompanion data) {
    return ReturnCheckpointEntry(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      tripStopId: data.tripStopId.present
          ? data.tripStopId.value
          : this.tripStopId,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
      closeState: data.closeState.present
          ? data.closeState.value
          : this.closeState,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReturnCheckpointEntry(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('tripStopId: $tripStopId, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('closeState: $closeState')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tripId,
    tripStopId,
    title,
    createdAt,
    closedAt,
    closeState,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReturnCheckpointEntry &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.tripStopId == this.tripStopId &&
          other.title == this.title &&
          other.createdAt == this.createdAt &&
          other.closedAt == this.closedAt &&
          other.closeState == this.closeState);
}

class ReturnCheckpointsCompanion
    extends UpdateCompanion<ReturnCheckpointEntry> {
  final Value<String> id;
  final Value<String> tripId;
  final Value<String?> tripStopId;
  final Value<String> title;
  final Value<String> createdAt;
  final Value<String?> closedAt;
  final Value<String> closeState;
  final Value<int> rowid;
  const ReturnCheckpointsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.tripStopId = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.closeState = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReturnCheckpointsCompanion.insert({
    required String id,
    required String tripId,
    this.tripStopId = const Value.absent(),
    required String title,
    required String createdAt,
    this.closedAt = const Value.absent(),
    this.closeState = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tripId = Value(tripId),
       title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<ReturnCheckpointEntry> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<String>? tripStopId,
    Expression<String>? title,
    Expression<String>? createdAt,
    Expression<String>? closedAt,
    Expression<String>? closeState,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (tripStopId != null) 'trip_stop_id': tripStopId,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (closedAt != null) 'closed_at': closedAt,
      if (closeState != null) 'close_state': closeState,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReturnCheckpointsCompanion copyWith({
    Value<String>? id,
    Value<String>? tripId,
    Value<String?>? tripStopId,
    Value<String>? title,
    Value<String>? createdAt,
    Value<String?>? closedAt,
    Value<String>? closeState,
    Value<int>? rowid,
  }) {
    return ReturnCheckpointsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      tripStopId: tripStopId ?? this.tripStopId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      closedAt: closedAt ?? this.closedAt,
      closeState: closeState ?? this.closeState,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (tripStopId.present) {
      map['trip_stop_id'] = Variable<String>(tripStopId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<String>(closedAt.value);
    }
    if (closeState.present) {
      map['close_state'] = Variable<String>(closeState.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReturnCheckpointsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('tripStopId: $tripStopId, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('closeState: $closeState, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReturnEntriesTable extends ReturnEntries
    with TableInfo<$ReturnEntriesTable, ReturnEntryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReturnEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkpointIdMeta = const VerificationMeta(
    'checkpointId',
  );
  @override
  late final GeneratedColumn<String> checkpointId = GeneratedColumn<String>(
    'checkpoint_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES return_checkpoints (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tripItemIdMeta = const VerificationMeta(
    'tripItemId',
  );
  @override
  late final GeneratedColumn<String> tripItemId = GeneratedColumn<String>(
    'trip_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trip_items (id)',
    ),
  );
  static const VerificationMeta _nameSnapshotMeta = const VerificationMeta(
    'nameSnapshot',
  );
  @override
  late final GeneratedColumn<String> nameSnapshot = GeneratedColumn<String>(
    'name_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expectedQuantityMeta = const VerificationMeta(
    'expectedQuantity',
  );
  @override
  late final GeneratedColumn<int> expectedQuantity = GeneratedColumn<int>(
    'expected_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _returnedQuantityMeta = const VerificationMeta(
    'returnedQuantity',
  );
  @override
  late final GeneratedColumn<int> returnedQuantity = GeneratedColumn<int>(
    'returned_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _consumedQuantityMeta = const VerificationMeta(
    'consumedQuantity',
  );
  @override
  late final GeneratedColumn<int> consumedQuantity = GeneratedColumn<int>(
    'consumed_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _leftQuantityMeta = const VerificationMeta(
    'leftQuantity',
  );
  @override
  late final GeneratedColumn<int> leftQuantity = GeneratedColumn<int>(
    'left_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lostQuantityMeta = const VerificationMeta(
    'lostQuantity',
  );
  @override
  late final GeneratedColumn<int> lostQuantity = GeneratedColumn<int>(
    'lost_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    checkpointId,
    tripItemId,
    nameSnapshot,
    expectedQuantity,
    returnedQuantity,
    consumedQuantity,
    leftQuantity,
    lostQuantity,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'return_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReturnEntryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('checkpoint_id')) {
      context.handle(
        _checkpointIdMeta,
        checkpointId.isAcceptableOrUnknown(
          data['checkpoint_id']!,
          _checkpointIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_checkpointIdMeta);
    }
    if (data.containsKey('trip_item_id')) {
      context.handle(
        _tripItemIdMeta,
        tripItemId.isAcceptableOrUnknown(
          data['trip_item_id']!,
          _tripItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tripItemIdMeta);
    }
    if (data.containsKey('name_snapshot')) {
      context.handle(
        _nameSnapshotMeta,
        nameSnapshot.isAcceptableOrUnknown(
          data['name_snapshot']!,
          _nameSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameSnapshotMeta);
    }
    if (data.containsKey('expected_quantity')) {
      context.handle(
        _expectedQuantityMeta,
        expectedQuantity.isAcceptableOrUnknown(
          data['expected_quantity']!,
          _expectedQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expectedQuantityMeta);
    }
    if (data.containsKey('returned_quantity')) {
      context.handle(
        _returnedQuantityMeta,
        returnedQuantity.isAcceptableOrUnknown(
          data['returned_quantity']!,
          _returnedQuantityMeta,
        ),
      );
    }
    if (data.containsKey('consumed_quantity')) {
      context.handle(
        _consumedQuantityMeta,
        consumedQuantity.isAcceptableOrUnknown(
          data['consumed_quantity']!,
          _consumedQuantityMeta,
        ),
      );
    }
    if (data.containsKey('left_quantity')) {
      context.handle(
        _leftQuantityMeta,
        leftQuantity.isAcceptableOrUnknown(
          data['left_quantity']!,
          _leftQuantityMeta,
        ),
      );
    }
    if (data.containsKey('lost_quantity')) {
      context.handle(
        _lostQuantityMeta,
        lostQuantity.isAcceptableOrUnknown(
          data['lost_quantity']!,
          _lostQuantityMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReturnEntryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReturnEntryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      checkpointId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checkpoint_id'],
      )!,
      tripItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_item_id'],
      )!,
      nameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_snapshot'],
      )!,
      expectedQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expected_quantity'],
      )!,
      returnedQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}returned_quantity'],
      )!,
      consumedQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}consumed_quantity'],
      )!,
      leftQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}left_quantity'],
      )!,
      lostQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lost_quantity'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $ReturnEntriesTable createAlias(String alias) {
    return $ReturnEntriesTable(attachedDatabase, alias);
  }
}

class ReturnEntryEntry extends DataClass
    implements Insertable<ReturnEntryEntry> {
  final String id;
  final String checkpointId;
  final String tripItemId;
  final String nameSnapshot;
  final int expectedQuantity;
  final int returnedQuantity;
  final int consumedQuantity;
  final int leftQuantity;
  final int lostQuantity;
  final String? notes;
  const ReturnEntryEntry({
    required this.id,
    required this.checkpointId,
    required this.tripItemId,
    required this.nameSnapshot,
    required this.expectedQuantity,
    required this.returnedQuantity,
    required this.consumedQuantity,
    required this.leftQuantity,
    required this.lostQuantity,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['checkpoint_id'] = Variable<String>(checkpointId);
    map['trip_item_id'] = Variable<String>(tripItemId);
    map['name_snapshot'] = Variable<String>(nameSnapshot);
    map['expected_quantity'] = Variable<int>(expectedQuantity);
    map['returned_quantity'] = Variable<int>(returnedQuantity);
    map['consumed_quantity'] = Variable<int>(consumedQuantity);
    map['left_quantity'] = Variable<int>(leftQuantity);
    map['lost_quantity'] = Variable<int>(lostQuantity);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ReturnEntriesCompanion toCompanion(bool nullToAbsent) {
    return ReturnEntriesCompanion(
      id: Value(id),
      checkpointId: Value(checkpointId),
      tripItemId: Value(tripItemId),
      nameSnapshot: Value(nameSnapshot),
      expectedQuantity: Value(expectedQuantity),
      returnedQuantity: Value(returnedQuantity),
      consumedQuantity: Value(consumedQuantity),
      leftQuantity: Value(leftQuantity),
      lostQuantity: Value(lostQuantity),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory ReturnEntryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReturnEntryEntry(
      id: serializer.fromJson<String>(json['id']),
      checkpointId: serializer.fromJson<String>(json['checkpointId']),
      tripItemId: serializer.fromJson<String>(json['tripItemId']),
      nameSnapshot: serializer.fromJson<String>(json['nameSnapshot']),
      expectedQuantity: serializer.fromJson<int>(json['expectedQuantity']),
      returnedQuantity: serializer.fromJson<int>(json['returnedQuantity']),
      consumedQuantity: serializer.fromJson<int>(json['consumedQuantity']),
      leftQuantity: serializer.fromJson<int>(json['leftQuantity']),
      lostQuantity: serializer.fromJson<int>(json['lostQuantity']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'checkpointId': serializer.toJson<String>(checkpointId),
      'tripItemId': serializer.toJson<String>(tripItemId),
      'nameSnapshot': serializer.toJson<String>(nameSnapshot),
      'expectedQuantity': serializer.toJson<int>(expectedQuantity),
      'returnedQuantity': serializer.toJson<int>(returnedQuantity),
      'consumedQuantity': serializer.toJson<int>(consumedQuantity),
      'leftQuantity': serializer.toJson<int>(leftQuantity),
      'lostQuantity': serializer.toJson<int>(lostQuantity),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  ReturnEntryEntry copyWith({
    String? id,
    String? checkpointId,
    String? tripItemId,
    String? nameSnapshot,
    int? expectedQuantity,
    int? returnedQuantity,
    int? consumedQuantity,
    int? leftQuantity,
    int? lostQuantity,
    Value<String?> notes = const Value.absent(),
  }) => ReturnEntryEntry(
    id: id ?? this.id,
    checkpointId: checkpointId ?? this.checkpointId,
    tripItemId: tripItemId ?? this.tripItemId,
    nameSnapshot: nameSnapshot ?? this.nameSnapshot,
    expectedQuantity: expectedQuantity ?? this.expectedQuantity,
    returnedQuantity: returnedQuantity ?? this.returnedQuantity,
    consumedQuantity: consumedQuantity ?? this.consumedQuantity,
    leftQuantity: leftQuantity ?? this.leftQuantity,
    lostQuantity: lostQuantity ?? this.lostQuantity,
    notes: notes.present ? notes.value : this.notes,
  );
  ReturnEntryEntry copyWithCompanion(ReturnEntriesCompanion data) {
    return ReturnEntryEntry(
      id: data.id.present ? data.id.value : this.id,
      checkpointId: data.checkpointId.present
          ? data.checkpointId.value
          : this.checkpointId,
      tripItemId: data.tripItemId.present
          ? data.tripItemId.value
          : this.tripItemId,
      nameSnapshot: data.nameSnapshot.present
          ? data.nameSnapshot.value
          : this.nameSnapshot,
      expectedQuantity: data.expectedQuantity.present
          ? data.expectedQuantity.value
          : this.expectedQuantity,
      returnedQuantity: data.returnedQuantity.present
          ? data.returnedQuantity.value
          : this.returnedQuantity,
      consumedQuantity: data.consumedQuantity.present
          ? data.consumedQuantity.value
          : this.consumedQuantity,
      leftQuantity: data.leftQuantity.present
          ? data.leftQuantity.value
          : this.leftQuantity,
      lostQuantity: data.lostQuantity.present
          ? data.lostQuantity.value
          : this.lostQuantity,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReturnEntryEntry(')
          ..write('id: $id, ')
          ..write('checkpointId: $checkpointId, ')
          ..write('tripItemId: $tripItemId, ')
          ..write('nameSnapshot: $nameSnapshot, ')
          ..write('expectedQuantity: $expectedQuantity, ')
          ..write('returnedQuantity: $returnedQuantity, ')
          ..write('consumedQuantity: $consumedQuantity, ')
          ..write('leftQuantity: $leftQuantity, ')
          ..write('lostQuantity: $lostQuantity, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    checkpointId,
    tripItemId,
    nameSnapshot,
    expectedQuantity,
    returnedQuantity,
    consumedQuantity,
    leftQuantity,
    lostQuantity,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReturnEntryEntry &&
          other.id == this.id &&
          other.checkpointId == this.checkpointId &&
          other.tripItemId == this.tripItemId &&
          other.nameSnapshot == this.nameSnapshot &&
          other.expectedQuantity == this.expectedQuantity &&
          other.returnedQuantity == this.returnedQuantity &&
          other.consumedQuantity == this.consumedQuantity &&
          other.leftQuantity == this.leftQuantity &&
          other.lostQuantity == this.lostQuantity &&
          other.notes == this.notes);
}

class ReturnEntriesCompanion extends UpdateCompanion<ReturnEntryEntry> {
  final Value<String> id;
  final Value<String> checkpointId;
  final Value<String> tripItemId;
  final Value<String> nameSnapshot;
  final Value<int> expectedQuantity;
  final Value<int> returnedQuantity;
  final Value<int> consumedQuantity;
  final Value<int> leftQuantity;
  final Value<int> lostQuantity;
  final Value<String?> notes;
  final Value<int> rowid;
  const ReturnEntriesCompanion({
    this.id = const Value.absent(),
    this.checkpointId = const Value.absent(),
    this.tripItemId = const Value.absent(),
    this.nameSnapshot = const Value.absent(),
    this.expectedQuantity = const Value.absent(),
    this.returnedQuantity = const Value.absent(),
    this.consumedQuantity = const Value.absent(),
    this.leftQuantity = const Value.absent(),
    this.lostQuantity = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReturnEntriesCompanion.insert({
    required String id,
    required String checkpointId,
    required String tripItemId,
    required String nameSnapshot,
    required int expectedQuantity,
    this.returnedQuantity = const Value.absent(),
    this.consumedQuantity = const Value.absent(),
    this.leftQuantity = const Value.absent(),
    this.lostQuantity = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       checkpointId = Value(checkpointId),
       tripItemId = Value(tripItemId),
       nameSnapshot = Value(nameSnapshot),
       expectedQuantity = Value(expectedQuantity);
  static Insertable<ReturnEntryEntry> custom({
    Expression<String>? id,
    Expression<String>? checkpointId,
    Expression<String>? tripItemId,
    Expression<String>? nameSnapshot,
    Expression<int>? expectedQuantity,
    Expression<int>? returnedQuantity,
    Expression<int>? consumedQuantity,
    Expression<int>? leftQuantity,
    Expression<int>? lostQuantity,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (checkpointId != null) 'checkpoint_id': checkpointId,
      if (tripItemId != null) 'trip_item_id': tripItemId,
      if (nameSnapshot != null) 'name_snapshot': nameSnapshot,
      if (expectedQuantity != null) 'expected_quantity': expectedQuantity,
      if (returnedQuantity != null) 'returned_quantity': returnedQuantity,
      if (consumedQuantity != null) 'consumed_quantity': consumedQuantity,
      if (leftQuantity != null) 'left_quantity': leftQuantity,
      if (lostQuantity != null) 'lost_quantity': lostQuantity,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReturnEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? checkpointId,
    Value<String>? tripItemId,
    Value<String>? nameSnapshot,
    Value<int>? expectedQuantity,
    Value<int>? returnedQuantity,
    Value<int>? consumedQuantity,
    Value<int>? leftQuantity,
    Value<int>? lostQuantity,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return ReturnEntriesCompanion(
      id: id ?? this.id,
      checkpointId: checkpointId ?? this.checkpointId,
      tripItemId: tripItemId ?? this.tripItemId,
      nameSnapshot: nameSnapshot ?? this.nameSnapshot,
      expectedQuantity: expectedQuantity ?? this.expectedQuantity,
      returnedQuantity: returnedQuantity ?? this.returnedQuantity,
      consumedQuantity: consumedQuantity ?? this.consumedQuantity,
      leftQuantity: leftQuantity ?? this.leftQuantity,
      lostQuantity: lostQuantity ?? this.lostQuantity,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (checkpointId.present) {
      map['checkpoint_id'] = Variable<String>(checkpointId.value);
    }
    if (tripItemId.present) {
      map['trip_item_id'] = Variable<String>(tripItemId.value);
    }
    if (nameSnapshot.present) {
      map['name_snapshot'] = Variable<String>(nameSnapshot.value);
    }
    if (expectedQuantity.present) {
      map['expected_quantity'] = Variable<int>(expectedQuantity.value);
    }
    if (returnedQuantity.present) {
      map['returned_quantity'] = Variable<int>(returnedQuantity.value);
    }
    if (consumedQuantity.present) {
      map['consumed_quantity'] = Variable<int>(consumedQuantity.value);
    }
    if (leftQuantity.present) {
      map['left_quantity'] = Variable<int>(leftQuantity.value);
    }
    if (lostQuantity.present) {
      map['lost_quantity'] = Variable<int>(lostQuantity.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReturnEntriesCompanion(')
          ..write('id: $id, ')
          ..write('checkpointId: $checkpointId, ')
          ..write('tripItemId: $tripItemId, ')
          ..write('nameSnapshot: $nameSnapshot, ')
          ..write('expectedQuantity: $expectedQuantity, ')
          ..write('returnedQuantity: $returnedQuantity, ')
          ..write('consumedQuantity: $consumedQuantity, ')
          ..write('leftQuantity: $leftQuantity, ')
          ..write('lostQuantity: $lostQuantity, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PackingTemplatesTable extends PackingTemplates
    with TableInfo<$PackingTemplatesTable, PackingTemplateEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PackingTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, notes, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'packing_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<PackingTemplateEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PackingTemplateEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PackingTemplateEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PackingTemplatesTable createAlias(String alias) {
    return $PackingTemplatesTable(attachedDatabase, alias);
  }
}

class PackingTemplateEntry extends DataClass
    implements Insertable<PackingTemplateEntry> {
  final String id;
  final String name;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  const PackingTemplateEntry({
    required this.id,
    required this.name,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  PackingTemplatesCompanion toCompanion(bool nullToAbsent) {
    return PackingTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PackingTemplateEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PackingTemplateEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  PackingTemplateEntry copyWith({
    String? id,
    String? name,
    Value<String?> notes = const Value.absent(),
    String? createdAt,
    String? updatedAt,
  }) => PackingTemplateEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PackingTemplateEntry copyWithCompanion(PackingTemplatesCompanion data) {
    return PackingTemplateEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PackingTemplateEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PackingTemplateEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PackingTemplatesCompanion extends UpdateCompanion<PackingTemplateEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> notes;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const PackingTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PackingTemplatesCompanion.insert({
    required String id,
    required String name,
    this.notes = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PackingTemplateEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? notes,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PackingTemplatesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? notes,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return PackingTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PackingTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TemplateItemsTable extends TemplateItems
    with TableInfo<$TemplateItemsTable, TemplateItemEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemplateItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES packing_templates (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id)',
    ),
  );
  static const VerificationMeta _plannedQuantityMeta = const VerificationMeta(
    'plannedQuantity',
  );
  @override
  late final GeneratedColumn<int> plannedQuantity = GeneratedColumn<int>(
    'planned_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    templateId,
    itemId,
    plannedQuantity,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'template_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<TemplateItemEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('planned_quantity')) {
      context.handle(
        _plannedQuantityMeta,
        plannedQuantity.isAcceptableOrUnknown(
          data['planned_quantity']!,
          _plannedQuantityMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {templateId, itemId},
  ];
  @override
  TemplateItemEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TemplateItemEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      plannedQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_quantity'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $TemplateItemsTable createAlias(String alias) {
    return $TemplateItemsTable(attachedDatabase, alias);
  }
}

class TemplateItemEntry extends DataClass
    implements Insertable<TemplateItemEntry> {
  final String id;
  final String templateId;
  final String itemId;
  final int plannedQuantity;
  final String? notes;
  const TemplateItemEntry({
    required this.id,
    required this.templateId,
    required this.itemId,
    required this.plannedQuantity,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['template_id'] = Variable<String>(templateId);
    map['item_id'] = Variable<String>(itemId);
    map['planned_quantity'] = Variable<int>(plannedQuantity);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  TemplateItemsCompanion toCompanion(bool nullToAbsent) {
    return TemplateItemsCompanion(
      id: Value(id),
      templateId: Value(templateId),
      itemId: Value(itemId),
      plannedQuantity: Value(plannedQuantity),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory TemplateItemEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TemplateItemEntry(
      id: serializer.fromJson<String>(json['id']),
      templateId: serializer.fromJson<String>(json['templateId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      plannedQuantity: serializer.fromJson<int>(json['plannedQuantity']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'templateId': serializer.toJson<String>(templateId),
      'itemId': serializer.toJson<String>(itemId),
      'plannedQuantity': serializer.toJson<int>(plannedQuantity),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  TemplateItemEntry copyWith({
    String? id,
    String? templateId,
    String? itemId,
    int? plannedQuantity,
    Value<String?> notes = const Value.absent(),
  }) => TemplateItemEntry(
    id: id ?? this.id,
    templateId: templateId ?? this.templateId,
    itemId: itemId ?? this.itemId,
    plannedQuantity: plannedQuantity ?? this.plannedQuantity,
    notes: notes.present ? notes.value : this.notes,
  );
  TemplateItemEntry copyWithCompanion(TemplateItemsCompanion data) {
    return TemplateItemEntry(
      id: data.id.present ? data.id.value : this.id,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      plannedQuantity: data.plannedQuantity.present
          ? data.plannedQuantity.value
          : this.plannedQuantity,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TemplateItemEntry(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('itemId: $itemId, ')
          ..write('plannedQuantity: $plannedQuantity, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, templateId, itemId, plannedQuantity, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TemplateItemEntry &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.itemId == this.itemId &&
          other.plannedQuantity == this.plannedQuantity &&
          other.notes == this.notes);
}

class TemplateItemsCompanion extends UpdateCompanion<TemplateItemEntry> {
  final Value<String> id;
  final Value<String> templateId;
  final Value<String> itemId;
  final Value<int> plannedQuantity;
  final Value<String?> notes;
  final Value<int> rowid;
  const TemplateItemsCompanion({
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.plannedQuantity = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TemplateItemsCompanion.insert({
    required String id,
    required String templateId,
    required String itemId,
    this.plannedQuantity = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       templateId = Value(templateId),
       itemId = Value(itemId);
  static Insertable<TemplateItemEntry> custom({
    Expression<String>? id,
    Expression<String>? templateId,
    Expression<String>? itemId,
    Expression<int>? plannedQuantity,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (itemId != null) 'item_id': itemId,
      if (plannedQuantity != null) 'planned_quantity': plannedQuantity,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TemplateItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? templateId,
    Value<String>? itemId,
    Value<int>? plannedQuantity,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return TemplateItemsCompanion(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      itemId: itemId ?? this.itemId,
      plannedQuantity: plannedQuantity ?? this.plannedQuantity,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (plannedQuantity.present) {
      map['planned_quantity'] = Variable<int>(plannedQuantity.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemplateItemsCompanion(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('itemId: $itemId, ')
          ..write('plannedQuantity: $plannedQuantity, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSettingEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingEntry(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSettingEntry extends DataClass implements Insertable<AppSettingEntry> {
  final String key;
  final String value;
  const AppSettingEntry({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSettingEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingEntry(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSettingEntry copyWith({String? key, String? value}) =>
      AppSettingEntry(key: key ?? this.key, value: value ?? this.value);
  AppSettingEntry copyWithCompanion(AppSettingsCompanion data) {
    return AppSettingEntry(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingEntry(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingEntry &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSettingEntry> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSettingEntry> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DepartureManifestsTable extends DepartureManifests
    with TableInfo<$DepartureManifestsTable, DepartureManifestEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DepartureManifestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _departureNotesMeta = const VerificationMeta(
    'departureNotes',
  );
  @override
  late final GeneratedColumn<String> departureNotes = GeneratedColumn<String>(
    'departure_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDepartedWithIssuesMeta =
      const VerificationMeta('isDepartedWithIssues');
  @override
  late final GeneratedColumn<bool> isDepartedWithIssues = GeneratedColumn<bool>(
    'is_departed_with_issues',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_departed_with_issues" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _sourceLabelMeta = const VerificationMeta(
    'sourceLabel',
  );
  @override
  late final GeneratedColumn<String> sourceLabel = GeneratedColumn<String>(
    'source_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('departure_check'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    departureNotes,
    isDepartedWithIssues,
    version,
    sourceLabel,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'departure_manifests';
  @override
  VerificationContext validateIntegrity(
    Insertable<DepartureManifestEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('departure_notes')) {
      context.handle(
        _departureNotesMeta,
        departureNotes.isAcceptableOrUnknown(
          data['departure_notes']!,
          _departureNotesMeta,
        ),
      );
    }
    if (data.containsKey('is_departed_with_issues')) {
      context.handle(
        _isDepartedWithIssuesMeta,
        isDepartedWithIssues.isAcceptableOrUnknown(
          data['is_departed_with_issues']!,
          _isDepartedWithIssuesMeta,
        ),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('source_label')) {
      context.handle(
        _sourceLabelMeta,
        sourceLabel.isAcceptableOrUnknown(
          data['source_label']!,
          _sourceLabelMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DepartureManifestEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DepartureManifestEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      departureNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}departure_notes'],
      ),
      isDepartedWithIssues: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_departed_with_issues'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      sourceLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_label'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DepartureManifestsTable createAlias(String alias) {
    return $DepartureManifestsTable(attachedDatabase, alias);
  }
}

class DepartureManifestEntry extends DataClass
    implements Insertable<DepartureManifestEntry> {
  final String id;
  final String tripId;
  final String? departureNotes;
  final bool isDepartedWithIssues;
  final int version;
  final String sourceLabel;
  final String createdAt;
  const DepartureManifestEntry({
    required this.id,
    required this.tripId,
    this.departureNotes,
    required this.isDepartedWithIssues,
    required this.version,
    required this.sourceLabel,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_id'] = Variable<String>(tripId);
    if (!nullToAbsent || departureNotes != null) {
      map['departure_notes'] = Variable<String>(departureNotes);
    }
    map['is_departed_with_issues'] = Variable<bool>(isDepartedWithIssues);
    map['version'] = Variable<int>(version);
    map['source_label'] = Variable<String>(sourceLabel);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  DepartureManifestsCompanion toCompanion(bool nullToAbsent) {
    return DepartureManifestsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      departureNotes: departureNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(departureNotes),
      isDepartedWithIssues: Value(isDepartedWithIssues),
      version: Value(version),
      sourceLabel: Value(sourceLabel),
      createdAt: Value(createdAt),
    );
  }

  factory DepartureManifestEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DepartureManifestEntry(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      departureNotes: serializer.fromJson<String?>(json['departureNotes']),
      isDepartedWithIssues: serializer.fromJson<bool>(
        json['isDepartedWithIssues'],
      ),
      version: serializer.fromJson<int>(json['version']),
      sourceLabel: serializer.fromJson<String>(json['sourceLabel']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String>(tripId),
      'departureNotes': serializer.toJson<String?>(departureNotes),
      'isDepartedWithIssues': serializer.toJson<bool>(isDepartedWithIssues),
      'version': serializer.toJson<int>(version),
      'sourceLabel': serializer.toJson<String>(sourceLabel),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  DepartureManifestEntry copyWith({
    String? id,
    String? tripId,
    Value<String?> departureNotes = const Value.absent(),
    bool? isDepartedWithIssues,
    int? version,
    String? sourceLabel,
    String? createdAt,
  }) => DepartureManifestEntry(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    departureNotes: departureNotes.present
        ? departureNotes.value
        : this.departureNotes,
    isDepartedWithIssues: isDepartedWithIssues ?? this.isDepartedWithIssues,
    version: version ?? this.version,
    sourceLabel: sourceLabel ?? this.sourceLabel,
    createdAt: createdAt ?? this.createdAt,
  );
  DepartureManifestEntry copyWithCompanion(DepartureManifestsCompanion data) {
    return DepartureManifestEntry(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      departureNotes: data.departureNotes.present
          ? data.departureNotes.value
          : this.departureNotes,
      isDepartedWithIssues: data.isDepartedWithIssues.present
          ? data.isDepartedWithIssues.value
          : this.isDepartedWithIssues,
      version: data.version.present ? data.version.value : this.version,
      sourceLabel: data.sourceLabel.present
          ? data.sourceLabel.value
          : this.sourceLabel,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DepartureManifestEntry(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('departureNotes: $departureNotes, ')
          ..write('isDepartedWithIssues: $isDepartedWithIssues, ')
          ..write('version: $version, ')
          ..write('sourceLabel: $sourceLabel, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tripId,
    departureNotes,
    isDepartedWithIssues,
    version,
    sourceLabel,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DepartureManifestEntry &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.departureNotes == this.departureNotes &&
          other.isDepartedWithIssues == this.isDepartedWithIssues &&
          other.version == this.version &&
          other.sourceLabel == this.sourceLabel &&
          other.createdAt == this.createdAt);
}

class DepartureManifestsCompanion
    extends UpdateCompanion<DepartureManifestEntry> {
  final Value<String> id;
  final Value<String> tripId;
  final Value<String?> departureNotes;
  final Value<bool> isDepartedWithIssues;
  final Value<int> version;
  final Value<String> sourceLabel;
  final Value<String> createdAt;
  final Value<int> rowid;
  const DepartureManifestsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.departureNotes = const Value.absent(),
    this.isDepartedWithIssues = const Value.absent(),
    this.version = const Value.absent(),
    this.sourceLabel = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DepartureManifestsCompanion.insert({
    required String id,
    required String tripId,
    this.departureNotes = const Value.absent(),
    this.isDepartedWithIssues = const Value.absent(),
    this.version = const Value.absent(),
    this.sourceLabel = const Value.absent(),
    required String createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tripId = Value(tripId),
       createdAt = Value(createdAt);
  static Insertable<DepartureManifestEntry> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<String>? departureNotes,
    Expression<bool>? isDepartedWithIssues,
    Expression<int>? version,
    Expression<String>? sourceLabel,
    Expression<String>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (departureNotes != null) 'departure_notes': departureNotes,
      if (isDepartedWithIssues != null)
        'is_departed_with_issues': isDepartedWithIssues,
      if (version != null) 'version': version,
      if (sourceLabel != null) 'source_label': sourceLabel,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DepartureManifestsCompanion copyWith({
    Value<String>? id,
    Value<String>? tripId,
    Value<String?>? departureNotes,
    Value<bool>? isDepartedWithIssues,
    Value<int>? version,
    Value<String>? sourceLabel,
    Value<String>? createdAt,
    Value<int>? rowid,
  }) {
    return DepartureManifestsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      departureNotes: departureNotes ?? this.departureNotes,
      isDepartedWithIssues: isDepartedWithIssues ?? this.isDepartedWithIssues,
      version: version ?? this.version,
      sourceLabel: sourceLabel ?? this.sourceLabel,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (departureNotes.present) {
      map['departure_notes'] = Variable<String>(departureNotes.value);
    }
    if (isDepartedWithIssues.present) {
      map['is_departed_with_issues'] = Variable<bool>(
        isDepartedWithIssues.value,
      );
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (sourceLabel.present) {
      map['source_label'] = Variable<String>(sourceLabel.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DepartureManifestsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('departureNotes: $departureNotes, ')
          ..write('isDepartedWithIssues: $isDepartedWithIssues, ')
          ..write('version: $version, ')
          ..write('sourceLabel: $sourceLabel, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DepartureManifestItemsTable extends DepartureManifestItems
    with TableInfo<$DepartureManifestItemsTable, DepartureManifestItemEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DepartureManifestItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _manifestIdMeta = const VerificationMeta(
    'manifestId',
  );
  @override
  late final GeneratedColumn<String> manifestId = GeneratedColumn<String>(
    'manifest_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES departure_manifests (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tripItemIdMeta = const VerificationMeta(
    'tripItemId',
  );
  @override
  late final GeneratedColumn<String> tripItemId = GeneratedColumn<String>(
    'trip_item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itemNameSnapshotMeta = const VerificationMeta(
    'itemNameSnapshot',
  );
  @override
  late final GeneratedColumn<String> itemNameSnapshot = GeneratedColumn<String>(
    'item_name_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemUnitSnapshotMeta = const VerificationMeta(
    'itemUnitSnapshot',
  );
  @override
  late final GeneratedColumn<String> itemUnitSnapshot = GeneratedColumn<String>(
    'item_unit_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('buah'),
  );
  static const VerificationMeta _isImportantMeta = const VerificationMeta(
    'isImportant',
  );
  @override
  late final GeneratedColumn<bool> isImportant = GeneratedColumn<bool>(
    'is_important',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_important" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _storageLocationSnapshotMeta =
      const VerificationMeta('storageLocationSnapshot');
  @override
  late final GeneratedColumn<String> storageLocationSnapshot =
      GeneratedColumn<String>(
        'storage_location_snapshot',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _plannedQuantityMeta = const VerificationMeta(
    'plannedQuantity',
  );
  @override
  late final GeneratedColumn<int> plannedQuantity = GeneratedColumn<int>(
    'planned_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _carriedQuantityMeta = const VerificationMeta(
    'carriedQuantity',
  );
  @override
  late final GeneratedColumn<int> carriedQuantity = GeneratedColumn<int>(
    'carried_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deficiencyQuantityMeta =
      const VerificationMeta('deficiencyQuantity');
  @override
  late final GeneratedColumn<int> deficiencyQuantity = GeneratedColumn<int>(
    'deficiency_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _allocationsSnapshotMeta =
      const VerificationMeta('allocationsSnapshot');
  @override
  late final GeneratedColumn<String> allocationsSnapshot =
      GeneratedColumn<String>(
        'allocations_snapshot',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    manifestId,
    tripItemId,
    itemId,
    itemNameSnapshot,
    itemUnitSnapshot,
    isImportant,
    storageLocationSnapshot,
    plannedQuantity,
    carriedQuantity,
    deficiencyQuantity,
    allocationsSnapshot,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'departure_manifest_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<DepartureManifestItemEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('manifest_id')) {
      context.handle(
        _manifestIdMeta,
        manifestId.isAcceptableOrUnknown(data['manifest_id']!, _manifestIdMeta),
      );
    } else if (isInserting) {
      context.missing(_manifestIdMeta);
    }
    if (data.containsKey('trip_item_id')) {
      context.handle(
        _tripItemIdMeta,
        tripItemId.isAcceptableOrUnknown(
          data['trip_item_id']!,
          _tripItemIdMeta,
        ),
      );
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    }
    if (data.containsKey('item_name_snapshot')) {
      context.handle(
        _itemNameSnapshotMeta,
        itemNameSnapshot.isAcceptableOrUnknown(
          data['item_name_snapshot']!,
          _itemNameSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_itemNameSnapshotMeta);
    }
    if (data.containsKey('item_unit_snapshot')) {
      context.handle(
        _itemUnitSnapshotMeta,
        itemUnitSnapshot.isAcceptableOrUnknown(
          data['item_unit_snapshot']!,
          _itemUnitSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('is_important')) {
      context.handle(
        _isImportantMeta,
        isImportant.isAcceptableOrUnknown(
          data['is_important']!,
          _isImportantMeta,
        ),
      );
    }
    if (data.containsKey('storage_location_snapshot')) {
      context.handle(
        _storageLocationSnapshotMeta,
        storageLocationSnapshot.isAcceptableOrUnknown(
          data['storage_location_snapshot']!,
          _storageLocationSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('planned_quantity')) {
      context.handle(
        _plannedQuantityMeta,
        plannedQuantity.isAcceptableOrUnknown(
          data['planned_quantity']!,
          _plannedQuantityMeta,
        ),
      );
    }
    if (data.containsKey('carried_quantity')) {
      context.handle(
        _carriedQuantityMeta,
        carriedQuantity.isAcceptableOrUnknown(
          data['carried_quantity']!,
          _carriedQuantityMeta,
        ),
      );
    }
    if (data.containsKey('deficiency_quantity')) {
      context.handle(
        _deficiencyQuantityMeta,
        deficiencyQuantity.isAcceptableOrUnknown(
          data['deficiency_quantity']!,
          _deficiencyQuantityMeta,
        ),
      );
    }
    if (data.containsKey('allocations_snapshot')) {
      context.handle(
        _allocationsSnapshotMeta,
        allocationsSnapshot.isAcceptableOrUnknown(
          data['allocations_snapshot']!,
          _allocationsSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DepartureManifestItemEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DepartureManifestItemEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      manifestId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manifest_id'],
      )!,
      tripItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_item_id'],
      ),
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      ),
      itemNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_name_snapshot'],
      )!,
      itemUnitSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_unit_snapshot'],
      )!,
      isImportant: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_important'],
      )!,
      storageLocationSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}storage_location_snapshot'],
      ),
      plannedQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_quantity'],
      )!,
      carriedQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}carried_quantity'],
      )!,
      deficiencyQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deficiency_quantity'],
      )!,
      allocationsSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allocations_snapshot'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $DepartureManifestItemsTable createAlias(String alias) {
    return $DepartureManifestItemsTable(attachedDatabase, alias);
  }
}

class DepartureManifestItemEntry extends DataClass
    implements Insertable<DepartureManifestItemEntry> {
  final String id;
  final String manifestId;
  final String? tripItemId;
  final String? itemId;
  final String itemNameSnapshot;
  final String itemUnitSnapshot;
  final bool isImportant;
  final String? storageLocationSnapshot;
  final int plannedQuantity;
  final int carriedQuantity;
  final int deficiencyQuantity;
  final String? allocationsSnapshot;
  final String? notes;
  const DepartureManifestItemEntry({
    required this.id,
    required this.manifestId,
    this.tripItemId,
    this.itemId,
    required this.itemNameSnapshot,
    required this.itemUnitSnapshot,
    required this.isImportant,
    this.storageLocationSnapshot,
    required this.plannedQuantity,
    required this.carriedQuantity,
    required this.deficiencyQuantity,
    this.allocationsSnapshot,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['manifest_id'] = Variable<String>(manifestId);
    if (!nullToAbsent || tripItemId != null) {
      map['trip_item_id'] = Variable<String>(tripItemId);
    }
    if (!nullToAbsent || itemId != null) {
      map['item_id'] = Variable<String>(itemId);
    }
    map['item_name_snapshot'] = Variable<String>(itemNameSnapshot);
    map['item_unit_snapshot'] = Variable<String>(itemUnitSnapshot);
    map['is_important'] = Variable<bool>(isImportant);
    if (!nullToAbsent || storageLocationSnapshot != null) {
      map['storage_location_snapshot'] = Variable<String>(
        storageLocationSnapshot,
      );
    }
    map['planned_quantity'] = Variable<int>(plannedQuantity);
    map['carried_quantity'] = Variable<int>(carriedQuantity);
    map['deficiency_quantity'] = Variable<int>(deficiencyQuantity);
    if (!nullToAbsent || allocationsSnapshot != null) {
      map['allocations_snapshot'] = Variable<String>(allocationsSnapshot);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  DepartureManifestItemsCompanion toCompanion(bool nullToAbsent) {
    return DepartureManifestItemsCompanion(
      id: Value(id),
      manifestId: Value(manifestId),
      tripItemId: tripItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(tripItemId),
      itemId: itemId == null && nullToAbsent
          ? const Value.absent()
          : Value(itemId),
      itemNameSnapshot: Value(itemNameSnapshot),
      itemUnitSnapshot: Value(itemUnitSnapshot),
      isImportant: Value(isImportant),
      storageLocationSnapshot: storageLocationSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(storageLocationSnapshot),
      plannedQuantity: Value(plannedQuantity),
      carriedQuantity: Value(carriedQuantity),
      deficiencyQuantity: Value(deficiencyQuantity),
      allocationsSnapshot: allocationsSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(allocationsSnapshot),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory DepartureManifestItemEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DepartureManifestItemEntry(
      id: serializer.fromJson<String>(json['id']),
      manifestId: serializer.fromJson<String>(json['manifestId']),
      tripItemId: serializer.fromJson<String?>(json['tripItemId']),
      itemId: serializer.fromJson<String?>(json['itemId']),
      itemNameSnapshot: serializer.fromJson<String>(json['itemNameSnapshot']),
      itemUnitSnapshot: serializer.fromJson<String>(json['itemUnitSnapshot']),
      isImportant: serializer.fromJson<bool>(json['isImportant']),
      storageLocationSnapshot: serializer.fromJson<String?>(
        json['storageLocationSnapshot'],
      ),
      plannedQuantity: serializer.fromJson<int>(json['plannedQuantity']),
      carriedQuantity: serializer.fromJson<int>(json['carriedQuantity']),
      deficiencyQuantity: serializer.fromJson<int>(json['deficiencyQuantity']),
      allocationsSnapshot: serializer.fromJson<String?>(
        json['allocationsSnapshot'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'manifestId': serializer.toJson<String>(manifestId),
      'tripItemId': serializer.toJson<String?>(tripItemId),
      'itemId': serializer.toJson<String?>(itemId),
      'itemNameSnapshot': serializer.toJson<String>(itemNameSnapshot),
      'itemUnitSnapshot': serializer.toJson<String>(itemUnitSnapshot),
      'isImportant': serializer.toJson<bool>(isImportant),
      'storageLocationSnapshot': serializer.toJson<String?>(
        storageLocationSnapshot,
      ),
      'plannedQuantity': serializer.toJson<int>(plannedQuantity),
      'carriedQuantity': serializer.toJson<int>(carriedQuantity),
      'deficiencyQuantity': serializer.toJson<int>(deficiencyQuantity),
      'allocationsSnapshot': serializer.toJson<String?>(allocationsSnapshot),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  DepartureManifestItemEntry copyWith({
    String? id,
    String? manifestId,
    Value<String?> tripItemId = const Value.absent(),
    Value<String?> itemId = const Value.absent(),
    String? itemNameSnapshot,
    String? itemUnitSnapshot,
    bool? isImportant,
    Value<String?> storageLocationSnapshot = const Value.absent(),
    int? plannedQuantity,
    int? carriedQuantity,
    int? deficiencyQuantity,
    Value<String?> allocationsSnapshot = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => DepartureManifestItemEntry(
    id: id ?? this.id,
    manifestId: manifestId ?? this.manifestId,
    tripItemId: tripItemId.present ? tripItemId.value : this.tripItemId,
    itemId: itemId.present ? itemId.value : this.itemId,
    itemNameSnapshot: itemNameSnapshot ?? this.itemNameSnapshot,
    itemUnitSnapshot: itemUnitSnapshot ?? this.itemUnitSnapshot,
    isImportant: isImportant ?? this.isImportant,
    storageLocationSnapshot: storageLocationSnapshot.present
        ? storageLocationSnapshot.value
        : this.storageLocationSnapshot,
    plannedQuantity: plannedQuantity ?? this.plannedQuantity,
    carriedQuantity: carriedQuantity ?? this.carriedQuantity,
    deficiencyQuantity: deficiencyQuantity ?? this.deficiencyQuantity,
    allocationsSnapshot: allocationsSnapshot.present
        ? allocationsSnapshot.value
        : this.allocationsSnapshot,
    notes: notes.present ? notes.value : this.notes,
  );
  DepartureManifestItemEntry copyWithCompanion(
    DepartureManifestItemsCompanion data,
  ) {
    return DepartureManifestItemEntry(
      id: data.id.present ? data.id.value : this.id,
      manifestId: data.manifestId.present
          ? data.manifestId.value
          : this.manifestId,
      tripItemId: data.tripItemId.present
          ? data.tripItemId.value
          : this.tripItemId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      itemNameSnapshot: data.itemNameSnapshot.present
          ? data.itemNameSnapshot.value
          : this.itemNameSnapshot,
      itemUnitSnapshot: data.itemUnitSnapshot.present
          ? data.itemUnitSnapshot.value
          : this.itemUnitSnapshot,
      isImportant: data.isImportant.present
          ? data.isImportant.value
          : this.isImportant,
      storageLocationSnapshot: data.storageLocationSnapshot.present
          ? data.storageLocationSnapshot.value
          : this.storageLocationSnapshot,
      plannedQuantity: data.plannedQuantity.present
          ? data.plannedQuantity.value
          : this.plannedQuantity,
      carriedQuantity: data.carriedQuantity.present
          ? data.carriedQuantity.value
          : this.carriedQuantity,
      deficiencyQuantity: data.deficiencyQuantity.present
          ? data.deficiencyQuantity.value
          : this.deficiencyQuantity,
      allocationsSnapshot: data.allocationsSnapshot.present
          ? data.allocationsSnapshot.value
          : this.allocationsSnapshot,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DepartureManifestItemEntry(')
          ..write('id: $id, ')
          ..write('manifestId: $manifestId, ')
          ..write('tripItemId: $tripItemId, ')
          ..write('itemId: $itemId, ')
          ..write('itemNameSnapshot: $itemNameSnapshot, ')
          ..write('itemUnitSnapshot: $itemUnitSnapshot, ')
          ..write('isImportant: $isImportant, ')
          ..write('storageLocationSnapshot: $storageLocationSnapshot, ')
          ..write('plannedQuantity: $plannedQuantity, ')
          ..write('carriedQuantity: $carriedQuantity, ')
          ..write('deficiencyQuantity: $deficiencyQuantity, ')
          ..write('allocationsSnapshot: $allocationsSnapshot, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    manifestId,
    tripItemId,
    itemId,
    itemNameSnapshot,
    itemUnitSnapshot,
    isImportant,
    storageLocationSnapshot,
    plannedQuantity,
    carriedQuantity,
    deficiencyQuantity,
    allocationsSnapshot,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DepartureManifestItemEntry &&
          other.id == this.id &&
          other.manifestId == this.manifestId &&
          other.tripItemId == this.tripItemId &&
          other.itemId == this.itemId &&
          other.itemNameSnapshot == this.itemNameSnapshot &&
          other.itemUnitSnapshot == this.itemUnitSnapshot &&
          other.isImportant == this.isImportant &&
          other.storageLocationSnapshot == this.storageLocationSnapshot &&
          other.plannedQuantity == this.plannedQuantity &&
          other.carriedQuantity == this.carriedQuantity &&
          other.deficiencyQuantity == this.deficiencyQuantity &&
          other.allocationsSnapshot == this.allocationsSnapshot &&
          other.notes == this.notes);
}

class DepartureManifestItemsCompanion
    extends UpdateCompanion<DepartureManifestItemEntry> {
  final Value<String> id;
  final Value<String> manifestId;
  final Value<String?> tripItemId;
  final Value<String?> itemId;
  final Value<String> itemNameSnapshot;
  final Value<String> itemUnitSnapshot;
  final Value<bool> isImportant;
  final Value<String?> storageLocationSnapshot;
  final Value<int> plannedQuantity;
  final Value<int> carriedQuantity;
  final Value<int> deficiencyQuantity;
  final Value<String?> allocationsSnapshot;
  final Value<String?> notes;
  final Value<int> rowid;
  const DepartureManifestItemsCompanion({
    this.id = const Value.absent(),
    this.manifestId = const Value.absent(),
    this.tripItemId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.itemNameSnapshot = const Value.absent(),
    this.itemUnitSnapshot = const Value.absent(),
    this.isImportant = const Value.absent(),
    this.storageLocationSnapshot = const Value.absent(),
    this.plannedQuantity = const Value.absent(),
    this.carriedQuantity = const Value.absent(),
    this.deficiencyQuantity = const Value.absent(),
    this.allocationsSnapshot = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DepartureManifestItemsCompanion.insert({
    required String id,
    required String manifestId,
    this.tripItemId = const Value.absent(),
    this.itemId = const Value.absent(),
    required String itemNameSnapshot,
    this.itemUnitSnapshot = const Value.absent(),
    this.isImportant = const Value.absent(),
    this.storageLocationSnapshot = const Value.absent(),
    this.plannedQuantity = const Value.absent(),
    this.carriedQuantity = const Value.absent(),
    this.deficiencyQuantity = const Value.absent(),
    this.allocationsSnapshot = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       manifestId = Value(manifestId),
       itemNameSnapshot = Value(itemNameSnapshot);
  static Insertable<DepartureManifestItemEntry> custom({
    Expression<String>? id,
    Expression<String>? manifestId,
    Expression<String>? tripItemId,
    Expression<String>? itemId,
    Expression<String>? itemNameSnapshot,
    Expression<String>? itemUnitSnapshot,
    Expression<bool>? isImportant,
    Expression<String>? storageLocationSnapshot,
    Expression<int>? plannedQuantity,
    Expression<int>? carriedQuantity,
    Expression<int>? deficiencyQuantity,
    Expression<String>? allocationsSnapshot,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (manifestId != null) 'manifest_id': manifestId,
      if (tripItemId != null) 'trip_item_id': tripItemId,
      if (itemId != null) 'item_id': itemId,
      if (itemNameSnapshot != null) 'item_name_snapshot': itemNameSnapshot,
      if (itemUnitSnapshot != null) 'item_unit_snapshot': itemUnitSnapshot,
      if (isImportant != null) 'is_important': isImportant,
      if (storageLocationSnapshot != null)
        'storage_location_snapshot': storageLocationSnapshot,
      if (plannedQuantity != null) 'planned_quantity': plannedQuantity,
      if (carriedQuantity != null) 'carried_quantity': carriedQuantity,
      if (deficiencyQuantity != null) 'deficiency_quantity': deficiencyQuantity,
      if (allocationsSnapshot != null)
        'allocations_snapshot': allocationsSnapshot,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DepartureManifestItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? manifestId,
    Value<String?>? tripItemId,
    Value<String?>? itemId,
    Value<String>? itemNameSnapshot,
    Value<String>? itemUnitSnapshot,
    Value<bool>? isImportant,
    Value<String?>? storageLocationSnapshot,
    Value<int>? plannedQuantity,
    Value<int>? carriedQuantity,
    Value<int>? deficiencyQuantity,
    Value<String?>? allocationsSnapshot,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return DepartureManifestItemsCompanion(
      id: id ?? this.id,
      manifestId: manifestId ?? this.manifestId,
      tripItemId: tripItemId ?? this.tripItemId,
      itemId: itemId ?? this.itemId,
      itemNameSnapshot: itemNameSnapshot ?? this.itemNameSnapshot,
      itemUnitSnapshot: itemUnitSnapshot ?? this.itemUnitSnapshot,
      isImportant: isImportant ?? this.isImportant,
      storageLocationSnapshot:
          storageLocationSnapshot ?? this.storageLocationSnapshot,
      plannedQuantity: plannedQuantity ?? this.plannedQuantity,
      carriedQuantity: carriedQuantity ?? this.carriedQuantity,
      deficiencyQuantity: deficiencyQuantity ?? this.deficiencyQuantity,
      allocationsSnapshot: allocationsSnapshot ?? this.allocationsSnapshot,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (manifestId.present) {
      map['manifest_id'] = Variable<String>(manifestId.value);
    }
    if (tripItemId.present) {
      map['trip_item_id'] = Variable<String>(tripItemId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (itemNameSnapshot.present) {
      map['item_name_snapshot'] = Variable<String>(itemNameSnapshot.value);
    }
    if (itemUnitSnapshot.present) {
      map['item_unit_snapshot'] = Variable<String>(itemUnitSnapshot.value);
    }
    if (isImportant.present) {
      map['is_important'] = Variable<bool>(isImportant.value);
    }
    if (storageLocationSnapshot.present) {
      map['storage_location_snapshot'] = Variable<String>(
        storageLocationSnapshot.value,
      );
    }
    if (plannedQuantity.present) {
      map['planned_quantity'] = Variable<int>(plannedQuantity.value);
    }
    if (carriedQuantity.present) {
      map['carried_quantity'] = Variable<int>(carriedQuantity.value);
    }
    if (deficiencyQuantity.present) {
      map['deficiency_quantity'] = Variable<int>(deficiencyQuantity.value);
    }
    if (allocationsSnapshot.present) {
      map['allocations_snapshot'] = Variable<String>(allocationsSnapshot.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DepartureManifestItemsCompanion(')
          ..write('id: $id, ')
          ..write('manifestId: $manifestId, ')
          ..write('tripItemId: $tripItemId, ')
          ..write('itemId: $itemId, ')
          ..write('itemNameSnapshot: $itemNameSnapshot, ')
          ..write('itemUnitSnapshot: $itemUnitSnapshot, ')
          ..write('isImportant: $isImportant, ')
          ..write('storageLocationSnapshot: $storageLocationSnapshot, ')
          ..write('plannedQuantity: $plannedQuantity, ')
          ..write('carriedQuantity: $carriedQuantity, ')
          ..write('deficiencyQuantity: $deficiencyQuantity, ')
          ..write('allocationsSnapshot: $allocationsSnapshot, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StorageLocationsTable storageLocations = $StorageLocationsTable(
    this,
  );
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $AssetsTable assets = $AssetsTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final $ItemPhotosTable itemPhotos = $ItemPhotosTable(this);
  late final $TripsTable trips = $TripsTable(this);
  late final $TripStopsTable tripStops = $TripStopsTable(this);
  late final $TripBagsTable tripBags = $TripBagsTable(this);
  late final $BagCompartmentsTable bagCompartments = $BagCompartmentsTable(
    this,
  );
  late final $TripItemsTable tripItems = $TripItemsTable(this);
  late final $ItemAllocationsTable itemAllocations = $ItemAllocationsTable(
    this,
  );
  late final $ScheduleEventsTable scheduleEvents = $ScheduleEventsTable(this);
  late final $TicketsTable tickets = $TicketsTable(this);
  late final $TicketAttachmentsTable ticketAttachments =
      $TicketAttachmentsTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $ReturnCheckpointsTable returnCheckpoints =
      $ReturnCheckpointsTable(this);
  late final $ReturnEntriesTable returnEntries = $ReturnEntriesTable(this);
  late final $PackingTemplatesTable packingTemplates = $PackingTemplatesTable(
    this,
  );
  late final $TemplateItemsTable templateItems = $TemplateItemsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $DepartureManifestsTable departureManifests =
      $DepartureManifestsTable(this);
  late final $DepartureManifestItemsTable departureManifestItems =
      $DepartureManifestItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    storageLocations,
    categories,
    assets,
    items,
    itemPhotos,
    trips,
    tripStops,
    tripBags,
    bagCompartments,
    tripItems,
    itemAllocations,
    scheduleEvents,
    tickets,
    ticketAttachments,
    reminders,
    returnCheckpoints,
    returnEntries,
    packingTemplates,
    templateItems,
    appSettings,
    departureManifests,
    departureManifestItems,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('item_photos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'assets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('item_photos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'trips',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('trip_stops', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'trips',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('trip_bags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'trip_bags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('bag_compartments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'trips',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('trip_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'trip_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('item_allocations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'trip_bags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('item_allocations', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'bag_compartments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('item_allocations', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'trips',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('schedule_events', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'trips',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tickets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tickets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ticket_attachments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'assets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ticket_attachments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'schedule_events',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reminders', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'trips',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('return_checkpoints', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'return_checkpoints',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('return_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'packing_templates',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('template_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'trips',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('departure_manifests', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'departure_manifests',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('departure_manifest_items', kind: UpdateKind.delete),
      ],
    ),
  ]);
}

typedef $$StorageLocationsTableCreateCompanionBuilder =
    StorageLocationsCompanion Function({
      required String id,
      required String name,
      required String type,
      Value<String?> description,
      Value<String?> photoAssetId,
      Value<String?> archivedAt,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$StorageLocationsTableUpdateCompanionBuilder =
    StorageLocationsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> type,
      Value<String?> description,
      Value<String?> photoAssetId,
      Value<String?> archivedAt,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

final class $$StorageLocationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $StorageLocationsTable,
          StorageLocationEntry
        > {
  $$StorageLocationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ItemsTable, List<ItemEntry>> _itemsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.items,
    aliasName: 'storage_locations__id__items__storage_location_id',
  );

  $$ItemsTableProcessedTableManager get itemsRefs {
    final manager = $$ItemsTableTableManager($_db, $_db.items).filter(
      (f) => f.storageLocationId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_itemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StorageLocationsTableFilterComposer
    extends Composer<_$AppDatabase, $StorageLocationsTable> {
  $$StorageLocationsTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoAssetId => $composableBuilder(
    column: $table.photoAssetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> itemsRefs(
    Expression<bool> Function($$ItemsTableFilterComposer f) f,
  ) {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.storageLocationId,
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
}

class $$StorageLocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $StorageLocationsTable> {
  $$StorageLocationsTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoAssetId => $composableBuilder(
    column: $table.photoAssetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StorageLocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StorageLocationsTable> {
  $$StorageLocationsTableAnnotationComposer({
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

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoAssetId => $composableBuilder(
    column: $table.photoAssetId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> itemsRefs<T extends Object>(
    Expression<T> Function($$ItemsTableAnnotationComposer a) f,
  ) {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.storageLocationId,
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
}

class $$StorageLocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StorageLocationsTable,
          StorageLocationEntry,
          $$StorageLocationsTableFilterComposer,
          $$StorageLocationsTableOrderingComposer,
          $$StorageLocationsTableAnnotationComposer,
          $$StorageLocationsTableCreateCompanionBuilder,
          $$StorageLocationsTableUpdateCompanionBuilder,
          (StorageLocationEntry, $$StorageLocationsTableReferences),
          StorageLocationEntry,
          PrefetchHooks Function({bool itemsRefs})
        > {
  $$StorageLocationsTableTableManager(
    _$AppDatabase db,
    $StorageLocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StorageLocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StorageLocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StorageLocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> photoAssetId = const Value.absent(),
                Value<String?> archivedAt = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StorageLocationsCompanion(
                id: id,
                name: name,
                type: type,
                description: description,
                photoAssetId: photoAssetId,
                archivedAt: archivedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String type,
                Value<String?> description = const Value.absent(),
                Value<String?> photoAssetId = const Value.absent(),
                Value<String?> archivedAt = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => StorageLocationsCompanion.insert(
                id: id,
                name: name,
                type: type,
                description: description,
                photoAssetId: photoAssetId,
                archivedAt: archivedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StorageLocationsTable, StorageLocationEntry>(
                    table,
                  ),
                  $$StorageLocationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (itemsRefs) db.items],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itemsRefs)
                    await $_getPrefetchedData<
                      StorageLocationEntry,
                      $StorageLocationsTable,
                      ItemEntry
                    >(
                      currentTable: table,
                      referencedTable: $$StorageLocationsTableReferences
                          ._itemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$StorageLocationsTableReferences(
                            db,
                            table,
                            p0,
                          ).itemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.storageLocationId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$StorageLocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StorageLocationsTable,
      StorageLocationEntry,
      $$StorageLocationsTableFilterComposer,
      $$StorageLocationsTableOrderingComposer,
      $$StorageLocationsTableAnnotationComposer,
      $$StorageLocationsTableCreateCompanionBuilder,
      $$StorageLocationsTableUpdateCompanionBuilder,
      (StorageLocationEntry, $$StorageLocationsTableReferences),
      StorageLocationEntry,
      PrefetchHooks Function({bool itemsRefs})
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      required String name,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, CategoryEntry> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ItemsTable, List<ItemEntry>> _itemsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.items,
    aliasName: 'categories__id__items__category_id',
  );

  $$ItemsTableProcessedTableManager get itemsRefs {
    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
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

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> itemsRefs(
    Expression<bool> Function($$ItemsTableFilterComposer f) f,
  ) {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.categoryId,
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
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
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

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
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

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> itemsRefs<T extends Object>(
    Expression<T> Function($$ItemsTableAnnotationComposer a) f,
  ) {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.categoryId,
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
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryEntry,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (CategoryEntry, $$CategoriesTableReferences),
          CategoryEntry,
          PrefetchHooks Function({bool itemsRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, CategoryEntry>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (itemsRefs) db.items],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itemsRefs)
                    await $_getPrefetchedData<
                      CategoryEntry,
                      $CategoriesTable,
                      ItemEntry
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._itemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableReferences(db, table, p0).itemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryEntry,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (CategoryEntry, $$CategoriesTableReferences),
      CategoryEntry,
      PrefetchHooks Function({bool itemsRefs})
    >;
typedef $$AssetsTableCreateCompanionBuilder =
    AssetsCompanion Function({
      required String id,
      required String relativePath,
      required String mimeType,
      required int sizeBytes,
      required String sha256,
      required String originalName,
      required String kind,
      required String createdAt,
      Value<int> rowid,
    });
typedef $$AssetsTableUpdateCompanionBuilder =
    AssetsCompanion Function({
      Value<String> id,
      Value<String> relativePath,
      Value<String> mimeType,
      Value<int> sizeBytes,
      Value<String> sha256,
      Value<String> originalName,
      Value<String> kind,
      Value<String> createdAt,
      Value<int> rowid,
    });

final class $$AssetsTableReferences
    extends BaseReferences<_$AppDatabase, $AssetsTable, AssetEntry> {
  $$AssetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ItemPhotosTable, List<ItemPhotoEntry>>
  _itemPhotosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.itemPhotos,
    aliasName: 'assets__id__item_photos__asset_id',
  );

  $$ItemPhotosTableProcessedTableManager get itemPhotosRefs {
    final manager = $$ItemPhotosTableTableManager(
      $_db,
      $_db.itemPhotos,
    ).filter((f) => f.assetId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemPhotosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TicketAttachmentsTable,
    List<TicketAttachmentEntry>
  >
  _ticketAttachmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.ticketAttachments,
        aliasName: 'assets__id__ticket_attachments__asset_id',
      );

  $$TicketAttachmentsTableProcessedTableManager get ticketAttachmentsRefs {
    final manager = $$TicketAttachmentsTableTableManager(
      $_db,
      $_db.ticketAttachments,
    ).filter((f) => f.assetId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _ticketAttachmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AssetsTableFilterComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableFilterComposer({
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

  ColumnFilters<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalName => $composableBuilder(
    column: $table.originalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> itemPhotosRefs(
    Expression<bool> Function($$ItemPhotosTableFilterComposer f) f,
  ) {
    final $$ItemPhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemPhotos,
      getReferencedColumn: (t) => t.assetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemPhotosTableFilterComposer(
            $db: $db,
            $table: $db.itemPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ticketAttachmentsRefs(
    Expression<bool> Function($$TicketAttachmentsTableFilterComposer f) f,
  ) {
    final $$TicketAttachmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ticketAttachments,
      getReferencedColumn: (t) => t.assetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketAttachmentsTableFilterComposer(
            $db: $db,
            $table: $db.ticketAttachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableOrderingComposer({
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

  ColumnOrderings<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalName => $composableBuilder(
    column: $table.originalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<String> get sha256 =>
      $composableBuilder(column: $table.sha256, builder: (column) => column);

  GeneratedColumn<String> get originalName => $composableBuilder(
    column: $table.originalName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> itemPhotosRefs<T extends Object>(
    Expression<T> Function($$ItemPhotosTableAnnotationComposer a) f,
  ) {
    final $$ItemPhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemPhotos,
      getReferencedColumn: (t) => t.assetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemPhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.itemPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ticketAttachmentsRefs<T extends Object>(
    Expression<T> Function($$TicketAttachmentsTableAnnotationComposer a) f,
  ) {
    final $$TicketAttachmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.ticketAttachments,
          getReferencedColumn: (t) => t.assetId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TicketAttachmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.ticketAttachments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AssetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssetsTable,
          AssetEntry,
          $$AssetsTableFilterComposer,
          $$AssetsTableOrderingComposer,
          $$AssetsTableAnnotationComposer,
          $$AssetsTableCreateCompanionBuilder,
          $$AssetsTableUpdateCompanionBuilder,
          (AssetEntry, $$AssetsTableReferences),
          AssetEntry,
          PrefetchHooks Function({
            bool itemPhotosRefs,
            bool ticketAttachmentsRefs,
          })
        > {
  $$AssetsTableTableManager(_$AppDatabase db, $AssetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> relativePath = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<String> sha256 = const Value.absent(),
                Value<String> originalName = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetsCompanion(
                id: id,
                relativePath: relativePath,
                mimeType: mimeType,
                sizeBytes: sizeBytes,
                sha256: sha256,
                originalName: originalName,
                kind: kind,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String relativePath,
                required String mimeType,
                required int sizeBytes,
                required String sha256,
                required String originalName,
                required String kind,
                required String createdAt,
                Value<int> rowid = const Value.absent(),
              }) => AssetsCompanion.insert(
                id: id,
                relativePath: relativePath,
                mimeType: mimeType,
                sizeBytes: sizeBytes,
                sha256: sha256,
                originalName: originalName,
                kind: kind,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AssetsTable, AssetEntry>(table),
                  $$AssetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({itemPhotosRefs = false, ticketAttachmentsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (itemPhotosRefs) db.itemPhotos,
                    if (ticketAttachmentsRefs) db.ticketAttachments,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (itemPhotosRefs)
                        await $_getPrefetchedData<
                          AssetEntry,
                          $AssetsTable,
                          ItemPhotoEntry
                        >(
                          currentTable: table,
                          referencedTable: $$AssetsTableReferences
                              ._itemPhotosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AssetsTableReferences(
                                db,
                                table,
                                p0,
                              ).itemPhotosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.assetId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ticketAttachmentsRefs)
                        await $_getPrefetchedData<
                          AssetEntry,
                          $AssetsTable,
                          TicketAttachmentEntry
                        >(
                          currentTable: table,
                          referencedTable: $$AssetsTableReferences
                              ._ticketAttachmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AssetsTableReferences(
                                db,
                                table,
                                p0,
                              ).ticketAttachmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.assetId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AssetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssetsTable,
      AssetEntry,
      $$AssetsTableFilterComposer,
      $$AssetsTableOrderingComposer,
      $$AssetsTableAnnotationComposer,
      $$AssetsTableCreateCompanionBuilder,
      $$AssetsTableUpdateCompanionBuilder,
      (AssetEntry, $$AssetsTableReferences),
      AssetEntry,
      PrefetchHooks Function({bool itemPhotosRefs, bool ticketAttachmentsRefs})
    >;
typedef $$ItemsTableCreateCompanionBuilder =
    ItemsCompanion Function({
      required String id,
      required String name,
      Value<int> quantity,
      Value<String> unit,
      Value<String?> categoryId,
      Value<String?> storageLocationId,
      Value<String?> notes,
      Value<bool> isImportant,
      Value<String?> archivedAt,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$ItemsTableUpdateCompanionBuilder =
    ItemsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> quantity,
      Value<String> unit,
      Value<String?> categoryId,
      Value<String?> storageLocationId,
      Value<String?> notes,
      Value<bool> isImportant,
      Value<String?> archivedAt,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

final class $$ItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ItemsTable, ItemEntry> {
  $$ItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('items__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $StorageLocationsTable _storageLocationIdTable(_$AppDatabase db) => db
      .storageLocations
      .createAlias('items__storage_location_id__storage_locations__id');

  $$StorageLocationsTableProcessedTableManager? get storageLocationId {
    final $_column = $_itemColumn<String>('storage_location_id');
    if ($_column == null) return null;
    final manager = $$StorageLocationsTableTableManager(
      $_db,
      $_db.storageLocations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_storageLocationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ItemPhotosTable, List<ItemPhotoEntry>>
  _itemPhotosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.itemPhotos,
    aliasName: 'items__id__item_photos__item_id',
  );

  $$ItemPhotosTableProcessedTableManager get itemPhotosRefs {
    final manager = $$ItemPhotosTableTableManager(
      $_db,
      $_db.itemPhotos,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemPhotosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TripItemsTable, List<TripItemEntry>>
  _tripItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tripItems,
    aliasName: 'items__id__trip_items__item_id',
  );

  $$TripItemsTableProcessedTableManager get tripItemsRefs {
    final manager = $$TripItemsTableTableManager(
      $_db,
      $_db.tripItems,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tripItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TemplateItemsTable, List<TemplateItemEntry>>
  _templateItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.templateItems,
    aliasName: 'items__id__template_items__item_id',
  );

  $$TemplateItemsTableProcessedTableManager get templateItemsRefs {
    final manager = $$TemplateItemsTableTableManager(
      $_db,
      $_db.templateItems,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_templateItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ItemsTableFilterComposer extends Composer<_$AppDatabase, $ItemsTable> {
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

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isImportant => $composableBuilder(
    column: $table.isImportant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StorageLocationsTableFilterComposer get storageLocationId {
    final $$StorageLocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.storageLocationId,
      referencedTable: $db.storageLocations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StorageLocationsTableFilterComposer(
            $db: $db,
            $table: $db.storageLocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> itemPhotosRefs(
    Expression<bool> Function($$ItemPhotosTableFilterComposer f) f,
  ) {
    final $$ItemPhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemPhotos,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemPhotosTableFilterComposer(
            $db: $db,
            $table: $db.itemPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tripItemsRefs(
    Expression<bool> Function($$TripItemsTableFilterComposer f) f,
  ) {
    final $$TripItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tripItems,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripItemsTableFilterComposer(
            $db: $db,
            $table: $db.tripItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> templateItemsRefs(
    Expression<bool> Function($$TemplateItemsTableFilterComposer f) f,
  ) {
    final $$TemplateItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.templateItems,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplateItemsTableFilterComposer(
            $db: $db,
            $table: $db.templateItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
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

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isImportant => $composableBuilder(
    column: $table.isImportant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StorageLocationsTableOrderingComposer get storageLocationId {
    final $$StorageLocationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.storageLocationId,
      referencedTable: $db.storageLocations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StorageLocationsTableOrderingComposer(
            $db: $db,
            $table: $db.storageLocations,
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
    extends Composer<_$AppDatabase, $ItemsTable> {
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

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isImportant => $composableBuilder(
    column: $table.isImportant,
    builder: (column) => column,
  );

  GeneratedColumn<String> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StorageLocationsTableAnnotationComposer get storageLocationId {
    final $$StorageLocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.storageLocationId,
      referencedTable: $db.storageLocations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StorageLocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.storageLocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> itemPhotosRefs<T extends Object>(
    Expression<T> Function($$ItemPhotosTableAnnotationComposer a) f,
  ) {
    final $$ItemPhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemPhotos,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemPhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.itemPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tripItemsRefs<T extends Object>(
    Expression<T> Function($$TripItemsTableAnnotationComposer a) f,
  ) {
    final $$TripItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tripItems,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.tripItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> templateItemsRefs<T extends Object>(
    Expression<T> Function($$TemplateItemsTableAnnotationComposer a) f,
  ) {
    final $$TemplateItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.templateItems,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplateItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.templateItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemsTable,
          ItemEntry,
          $$ItemsTableFilterComposer,
          $$ItemsTableOrderingComposer,
          $$ItemsTableAnnotationComposer,
          $$ItemsTableCreateCompanionBuilder,
          $$ItemsTableUpdateCompanionBuilder,
          (ItemEntry, $$ItemsTableReferences),
          ItemEntry,
          PrefetchHooks Function({
            bool categoryId,
            bool storageLocationId,
            bool itemPhotosRefs,
            bool tripItemsRefs,
            bool templateItemsRefs,
          })
        > {
  $$ItemsTableTableManager(_$AppDatabase db, $ItemsTable table)
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
                Value<String> name = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> storageLocationId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isImportant = const Value.absent(),
                Value<String?> archivedAt = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemsCompanion(
                id: id,
                name: name,
                quantity: quantity,
                unit: unit,
                categoryId: categoryId,
                storageLocationId: storageLocationId,
                notes: notes,
                isImportant: isImportant,
                archivedAt: archivedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> quantity = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> storageLocationId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isImportant = const Value.absent(),
                Value<String?> archivedAt = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ItemsCompanion.insert(
                id: id,
                name: name,
                quantity: quantity,
                unit: unit,
                categoryId: categoryId,
                storageLocationId: storageLocationId,
                notes: notes,
                isImportant: isImportant,
                archivedAt: archivedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemsTable, ItemEntry>(table),
                  $$ItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                storageLocationId = false,
                itemPhotosRefs = false,
                tripItemsRefs = false,
                templateItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (itemPhotosRefs) db.itemPhotos,
                    if (tripItemsRefs) db.tripItems,
                    if (templateItemsRefs) db.templateItems,
                  ],
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
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable: $$ItemsTableReferences
                                        ._categoryIdTable(db),
                                    referencedColumn: $$ItemsTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (storageLocationId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.storageLocationId,
                                    referencedTable: $$ItemsTableReferences
                                        ._storageLocationIdTable(db),
                                    referencedColumn: $$ItemsTableReferences
                                        ._storageLocationIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (itemPhotosRefs)
                        await $_getPrefetchedData<
                          ItemEntry,
                          $ItemsTable,
                          ItemPhotoEntry
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._itemPhotosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).itemPhotosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tripItemsRefs)
                        await $_getPrefetchedData<
                          ItemEntry,
                          $ItemsTable,
                          TripItemEntry
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._tripItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).tripItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (templateItemsRefs)
                        await $_getPrefetchedData<
                          ItemEntry,
                          $ItemsTable,
                          TemplateItemEntry
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._templateItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).templateItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemsTable,
      ItemEntry,
      $$ItemsTableFilterComposer,
      $$ItemsTableOrderingComposer,
      $$ItemsTableAnnotationComposer,
      $$ItemsTableCreateCompanionBuilder,
      $$ItemsTableUpdateCompanionBuilder,
      (ItemEntry, $$ItemsTableReferences),
      ItemEntry,
      PrefetchHooks Function({
        bool categoryId,
        bool storageLocationId,
        bool itemPhotosRefs,
        bool tripItemsRefs,
        bool templateItemsRefs,
      })
    >;
typedef $$ItemPhotosTableCreateCompanionBuilder =
    ItemPhotosCompanion Function({
      required String id,
      required String itemId,
      required String assetId,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$ItemPhotosTableUpdateCompanionBuilder =
    ItemPhotosCompanion Function({
      Value<String> id,
      Value<String> itemId,
      Value<String> assetId,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$ItemPhotosTableReferences
    extends BaseReferences<_$AppDatabase, $ItemPhotosTable, ItemPhotoEntry> {
  $$ItemPhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _itemIdTable(_$AppDatabase db) =>
      db.items.createAlias('item_photos__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AssetsTable _assetIdTable(_$AppDatabase db) =>
      db.assets.createAlias('item_photos__asset_id__assets__id');

  $$AssetsTableProcessedTableManager get assetId {
    final $_column = $_itemColumn<String>('asset_id')!;

    final manager = $$AssetsTableTableManager(
      $_db,
      $_db.assets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItemPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $ItemPhotosTable> {
  $$ItemPhotosTableFilterComposer({
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

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }

  $$AssetsTableFilterComposer get assetId {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableFilterComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemPhotosTable> {
  $$ItemPhotosTableOrderingComposer({
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

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetsTableOrderingComposer get assetId {
    final $$AssetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableOrderingComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemPhotosTable> {
  $$ItemPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }

  $$AssetsTableAnnotationComposer get assetId {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableAnnotationComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemPhotosTable,
          ItemPhotoEntry,
          $$ItemPhotosTableFilterComposer,
          $$ItemPhotosTableOrderingComposer,
          $$ItemPhotosTableAnnotationComposer,
          $$ItemPhotosTableCreateCompanionBuilder,
          $$ItemPhotosTableUpdateCompanionBuilder,
          (ItemPhotoEntry, $$ItemPhotosTableReferences),
          ItemPhotoEntry,
          PrefetchHooks Function({bool itemId, bool assetId})
        > {
  $$ItemPhotosTableTableManager(_$AppDatabase db, $ItemPhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<String> assetId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemPhotosCompanion(
                id: id,
                itemId: itemId,
                assetId: assetId,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String itemId,
                required String assetId,
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemPhotosCompanion.insert(
                id: id,
                itemId: itemId,
                assetId: assetId,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemPhotosTable, ItemPhotoEntry>(table),
                  $$ItemPhotosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false, assetId = false}) {
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
                    if (itemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.itemId,
                                referencedTable: $$ItemPhotosTableReferences
                                    ._itemIdTable(db),
                                referencedColumn: $$ItemPhotosTableReferences
                                    ._itemIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (assetId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.assetId,
                                referencedTable: $$ItemPhotosTableReferences
                                    ._assetIdTable(db),
                                referencedColumn: $$ItemPhotosTableReferences
                                    ._assetIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$ItemPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemPhotosTable,
      ItemPhotoEntry,
      $$ItemPhotosTableFilterComposer,
      $$ItemPhotosTableOrderingComposer,
      $$ItemPhotosTableAnnotationComposer,
      $$ItemPhotosTableCreateCompanionBuilder,
      $$ItemPhotosTableUpdateCompanionBuilder,
      (ItemPhotoEntry, $$ItemPhotosTableReferences),
      ItemPhotoEntry,
      PrefetchHooks Function({bool itemId, bool assetId})
    >;
typedef $$TripsTableCreateCompanionBuilder =
    TripsCompanion Function({
      required String id,
      required String name,
      required String startDate,
      Value<String?> endDate,
      required String dateZoneId,
      Value<String> status,
      Value<bool> isArchived,
      Value<bool> isPinned,
      Value<String?> notes,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$TripsTableUpdateCompanionBuilder =
    TripsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> startDate,
      Value<String?> endDate,
      Value<String> dateZoneId,
      Value<String> status,
      Value<bool> isArchived,
      Value<bool> isPinned,
      Value<String?> notes,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

final class $$TripsTableReferences
    extends BaseReferences<_$AppDatabase, $TripsTable, TripEntry> {
  $$TripsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TripStopsTable, List<TripStopEntry>>
  _tripStopsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tripStops,
    aliasName: 'trips__id__trip_stops__trip_id',
  );

  $$TripStopsTableProcessedTableManager get tripStopsRefs {
    final manager = $$TripStopsTableTableManager(
      $_db,
      $_db.tripStops,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tripStopsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TripBagsTable, List<TripBagEntry>>
  _tripBagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tripBags,
    aliasName: 'trips__id__trip_bags__trip_id',
  );

  $$TripBagsTableProcessedTableManager get tripBagsRefs {
    final manager = $$TripBagsTableTableManager(
      $_db,
      $_db.tripBags,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tripBagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TripItemsTable, List<TripItemEntry>>
  _tripItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tripItems,
    aliasName: 'trips__id__trip_items__trip_id',
  );

  $$TripItemsTableProcessedTableManager get tripItemsRefs {
    final manager = $$TripItemsTableTableManager(
      $_db,
      $_db.tripItems,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tripItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ScheduleEventsTable, List<ScheduleEventEntry>>
  _scheduleEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.scheduleEvents,
    aliasName: 'trips__id__schedule_events__trip_id',
  );

  $$ScheduleEventsTableProcessedTableManager get scheduleEventsRefs {
    final manager = $$ScheduleEventsTableTableManager(
      $_db,
      $_db.scheduleEvents,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_scheduleEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TicketsTable, List<TicketEntry>>
  _ticketsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tickets,
    aliasName: 'trips__id__tickets__trip_id',
  );

  $$TicketsTableProcessedTableManager get ticketsRefs {
    final manager = $$TicketsTableTableManager(
      $_db,
      $_db.tickets,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ticketsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ReturnCheckpointsTable,
    List<ReturnCheckpointEntry>
  >
  _returnCheckpointsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.returnCheckpoints,
        aliasName: 'trips__id__return_checkpoints__trip_id',
      );

  $$ReturnCheckpointsTableProcessedTableManager get returnCheckpointsRefs {
    final manager = $$ReturnCheckpointsTableTableManager(
      $_db,
      $_db.returnCheckpoints,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _returnCheckpointsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $DepartureManifestsTable,
    List<DepartureManifestEntry>
  >
  _departureManifestsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.departureManifests,
        aliasName: 'trips__id__departure_manifests__trip_id',
      );

  $$DepartureManifestsTableProcessedTableManager get departureManifestsRefs {
    final manager = $$DepartureManifestsTableTableManager(
      $_db,
      $_db.departureManifests,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _departureManifestsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TripsTableFilterComposer extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableFilterComposer({
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

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateZoneId => $composableBuilder(
    column: $table.dateZoneId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tripStopsRefs(
    Expression<bool> Function($$TripStopsTableFilterComposer f) f,
  ) {
    final $$TripStopsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tripStops,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripStopsTableFilterComposer(
            $db: $db,
            $table: $db.tripStops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tripBagsRefs(
    Expression<bool> Function($$TripBagsTableFilterComposer f) f,
  ) {
    final $$TripBagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tripBags,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripBagsTableFilterComposer(
            $db: $db,
            $table: $db.tripBags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tripItemsRefs(
    Expression<bool> Function($$TripItemsTableFilterComposer f) f,
  ) {
    final $$TripItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tripItems,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripItemsTableFilterComposer(
            $db: $db,
            $table: $db.tripItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> scheduleEventsRefs(
    Expression<bool> Function($$ScheduleEventsTableFilterComposer f) f,
  ) {
    final $$ScheduleEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduleEvents,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleEventsTableFilterComposer(
            $db: $db,
            $table: $db.scheduleEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ticketsRefs(
    Expression<bool> Function($$TicketsTableFilterComposer f) f,
  ) {
    final $$TicketsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableFilterComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> returnCheckpointsRefs(
    Expression<bool> Function($$ReturnCheckpointsTableFilterComposer f) f,
  ) {
    final $$ReturnCheckpointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.returnCheckpoints,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReturnCheckpointsTableFilterComposer(
            $db: $db,
            $table: $db.returnCheckpoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> departureManifestsRefs(
    Expression<bool> Function($$DepartureManifestsTableFilterComposer f) f,
  ) {
    final $$DepartureManifestsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.departureManifests,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartureManifestsTableFilterComposer(
            $db: $db,
            $table: $db.departureManifests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TripsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableOrderingComposer({
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

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateZoneId => $composableBuilder(
    column: $table.dateZoneId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TripsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableAnnotationComposer({
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

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get dateZoneId => $composableBuilder(
    column: $table.dateZoneId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> tripStopsRefs<T extends Object>(
    Expression<T> Function($$TripStopsTableAnnotationComposer a) f,
  ) {
    final $$TripStopsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tripStops,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripStopsTableAnnotationComposer(
            $db: $db,
            $table: $db.tripStops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tripBagsRefs<T extends Object>(
    Expression<T> Function($$TripBagsTableAnnotationComposer a) f,
  ) {
    final $$TripBagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tripBags,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripBagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tripBags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tripItemsRefs<T extends Object>(
    Expression<T> Function($$TripItemsTableAnnotationComposer a) f,
  ) {
    final $$TripItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tripItems,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.tripItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> scheduleEventsRefs<T extends Object>(
    Expression<T> Function($$ScheduleEventsTableAnnotationComposer a) f,
  ) {
    final $$ScheduleEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduleEvents,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.scheduleEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ticketsRefs<T extends Object>(
    Expression<T> Function($$TicketsTableAnnotationComposer a) f,
  ) {
    final $$TicketsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableAnnotationComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> returnCheckpointsRefs<T extends Object>(
    Expression<T> Function($$ReturnCheckpointsTableAnnotationComposer a) f,
  ) {
    final $$ReturnCheckpointsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.returnCheckpoints,
          getReferencedColumn: (t) => t.tripId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReturnCheckpointsTableAnnotationComposer(
                $db: $db,
                $table: $db.returnCheckpoints,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> departureManifestsRefs<T extends Object>(
    Expression<T> Function($$DepartureManifestsTableAnnotationComposer a) f,
  ) {
    final $$DepartureManifestsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.departureManifests,
          getReferencedColumn: (t) => t.tripId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DepartureManifestsTableAnnotationComposer(
                $db: $db,
                $table: $db.departureManifests,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TripsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TripsTable,
          TripEntry,
          $$TripsTableFilterComposer,
          $$TripsTableOrderingComposer,
          $$TripsTableAnnotationComposer,
          $$TripsTableCreateCompanionBuilder,
          $$TripsTableUpdateCompanionBuilder,
          (TripEntry, $$TripsTableReferences),
          TripEntry,
          PrefetchHooks Function({
            bool tripStopsRefs,
            bool tripBagsRefs,
            bool tripItemsRefs,
            bool scheduleEventsRefs,
            bool ticketsRefs,
            bool returnCheckpointsRefs,
            bool departureManifestsRefs,
          })
        > {
  $$TripsTableTableManager(_$AppDatabase db, $TripsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<String> dateZoneId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripsCompanion(
                id: id,
                name: name,
                startDate: startDate,
                endDate: endDate,
                dateZoneId: dateZoneId,
                status: status,
                isArchived: isArchived,
                isPinned: isPinned,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String startDate,
                Value<String?> endDate = const Value.absent(),
                required String dateZoneId,
                Value<String> status = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TripsCompanion.insert(
                id: id,
                name: name,
                startDate: startDate,
                endDate: endDate,
                dateZoneId: dateZoneId,
                status: status,
                isArchived: isArchived,
                isPinned: isPinned,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TripsTable, TripEntry>(table),
                  $$TripsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                tripStopsRefs = false,
                tripBagsRefs = false,
                tripItemsRefs = false,
                scheduleEventsRefs = false,
                ticketsRefs = false,
                returnCheckpointsRefs = false,
                departureManifestsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (tripStopsRefs) db.tripStops,
                    if (tripBagsRefs) db.tripBags,
                    if (tripItemsRefs) db.tripItems,
                    if (scheduleEventsRefs) db.scheduleEvents,
                    if (ticketsRefs) db.tickets,
                    if (returnCheckpointsRefs) db.returnCheckpoints,
                    if (departureManifestsRefs) db.departureManifests,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (tripStopsRefs)
                        await $_getPrefetchedData<
                          TripEntry,
                          $TripsTable,
                          TripStopEntry
                        >(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._tripStopsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(
                                db,
                                table,
                                p0,
                              ).tripStopsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tripBagsRefs)
                        await $_getPrefetchedData<
                          TripEntry,
                          $TripsTable,
                          TripBagEntry
                        >(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._tripBagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(
                                db,
                                table,
                                p0,
                              ).tripBagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tripItemsRefs)
                        await $_getPrefetchedData<
                          TripEntry,
                          $TripsTable,
                          TripItemEntry
                        >(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._tripItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(
                                db,
                                table,
                                p0,
                              ).tripItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (scheduleEventsRefs)
                        await $_getPrefetchedData<
                          TripEntry,
                          $TripsTable,
                          ScheduleEventEntry
                        >(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._scheduleEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(
                                db,
                                table,
                                p0,
                              ).scheduleEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ticketsRefs)
                        await $_getPrefetchedData<
                          TripEntry,
                          $TripsTable,
                          TicketEntry
                        >(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._ticketsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(db, table, p0).ticketsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (returnCheckpointsRefs)
                        await $_getPrefetchedData<
                          TripEntry,
                          $TripsTable,
                          ReturnCheckpointEntry
                        >(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._returnCheckpointsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(
                                db,
                                table,
                                p0,
                              ).returnCheckpointsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (departureManifestsRefs)
                        await $_getPrefetchedData<
                          TripEntry,
                          $TripsTable,
                          DepartureManifestEntry
                        >(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._departureManifestsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(
                                db,
                                table,
                                p0,
                              ).departureManifestsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TripsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TripsTable,
      TripEntry,
      $$TripsTableFilterComposer,
      $$TripsTableOrderingComposer,
      $$TripsTableAnnotationComposer,
      $$TripsTableCreateCompanionBuilder,
      $$TripsTableUpdateCompanionBuilder,
      (TripEntry, $$TripsTableReferences),
      TripEntry,
      PrefetchHooks Function({
        bool tripStopsRefs,
        bool tripBagsRefs,
        bool tripItemsRefs,
        bool scheduleEventsRefs,
        bool ticketsRefs,
        bool returnCheckpointsRefs,
        bool departureManifestsRefs,
      })
    >;
typedef $$TripStopsTableCreateCompanionBuilder =
    TripStopsCompanion Function({
      required String id,
      required String tripId,
      required String label,
      Value<int> sortOrder,
      Value<String?> arrivalLocal,
      Value<String?> arrivalZone,
      Value<String?> departureLocal,
      Value<String?> departureZone,
      Value<int> rowid,
    });
typedef $$TripStopsTableUpdateCompanionBuilder =
    TripStopsCompanion Function({
      Value<String> id,
      Value<String> tripId,
      Value<String> label,
      Value<int> sortOrder,
      Value<String?> arrivalLocal,
      Value<String?> arrivalZone,
      Value<String?> departureLocal,
      Value<String?> departureZone,
      Value<int> rowid,
    });

final class $$TripStopsTableReferences
    extends BaseReferences<_$AppDatabase, $TripStopsTable, TripStopEntry> {
  $$TripStopsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) =>
      db.trips.createAlias('trip_stops__trip_id__trips__id');

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<String>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ScheduleEventsTable, List<ScheduleEventEntry>>
  _scheduleEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.scheduleEvents,
    aliasName: 'trip_stops__id__schedule_events__trip_stop_id',
  );

  $$ScheduleEventsTableProcessedTableManager get scheduleEventsRefs {
    final manager = $$ScheduleEventsTableTableManager(
      $_db,
      $_db.scheduleEvents,
    ).filter((f) => f.tripStopId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_scheduleEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ReturnCheckpointsTable,
    List<ReturnCheckpointEntry>
  >
  _returnCheckpointsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.returnCheckpoints,
        aliasName: 'trip_stops__id__return_checkpoints__trip_stop_id',
      );

  $$ReturnCheckpointsTableProcessedTableManager get returnCheckpointsRefs {
    final manager = $$ReturnCheckpointsTableTableManager(
      $_db,
      $_db.returnCheckpoints,
    ).filter((f) => f.tripStopId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _returnCheckpointsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TripStopsTableFilterComposer
    extends Composer<_$AppDatabase, $TripStopsTable> {
  $$TripStopsTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arrivalLocal => $composableBuilder(
    column: $table.arrivalLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arrivalZone => $composableBuilder(
    column: $table.arrivalZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get departureLocal => $composableBuilder(
    column: $table.departureLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get departureZone => $composableBuilder(
    column: $table.departureZone,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> scheduleEventsRefs(
    Expression<bool> Function($$ScheduleEventsTableFilterComposer f) f,
  ) {
    final $$ScheduleEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduleEvents,
      getReferencedColumn: (t) => t.tripStopId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleEventsTableFilterComposer(
            $db: $db,
            $table: $db.scheduleEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> returnCheckpointsRefs(
    Expression<bool> Function($$ReturnCheckpointsTableFilterComposer f) f,
  ) {
    final $$ReturnCheckpointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.returnCheckpoints,
      getReferencedColumn: (t) => t.tripStopId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReturnCheckpointsTableFilterComposer(
            $db: $db,
            $table: $db.returnCheckpoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TripStopsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripStopsTable> {
  $$TripStopsTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arrivalLocal => $composableBuilder(
    column: $table.arrivalLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arrivalZone => $composableBuilder(
    column: $table.arrivalZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get departureLocal => $composableBuilder(
    column: $table.departureLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get departureZone => $composableBuilder(
    column: $table.departureZone,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripStopsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripStopsTable> {
  $$TripStopsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get arrivalLocal => $composableBuilder(
    column: $table.arrivalLocal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get arrivalZone => $composableBuilder(
    column: $table.arrivalZone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get departureLocal => $composableBuilder(
    column: $table.departureLocal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get departureZone => $composableBuilder(
    column: $table.departureZone,
    builder: (column) => column,
  );

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> scheduleEventsRefs<T extends Object>(
    Expression<T> Function($$ScheduleEventsTableAnnotationComposer a) f,
  ) {
    final $$ScheduleEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduleEvents,
      getReferencedColumn: (t) => t.tripStopId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.scheduleEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> returnCheckpointsRefs<T extends Object>(
    Expression<T> Function($$ReturnCheckpointsTableAnnotationComposer a) f,
  ) {
    final $$ReturnCheckpointsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.returnCheckpoints,
          getReferencedColumn: (t) => t.tripStopId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReturnCheckpointsTableAnnotationComposer(
                $db: $db,
                $table: $db.returnCheckpoints,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TripStopsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TripStopsTable,
          TripStopEntry,
          $$TripStopsTableFilterComposer,
          $$TripStopsTableOrderingComposer,
          $$TripStopsTableAnnotationComposer,
          $$TripStopsTableCreateCompanionBuilder,
          $$TripStopsTableUpdateCompanionBuilder,
          (TripStopEntry, $$TripStopsTableReferences),
          TripStopEntry,
          PrefetchHooks Function({
            bool tripId,
            bool scheduleEventsRefs,
            bool returnCheckpointsRefs,
          })
        > {
  $$TripStopsTableTableManager(_$AppDatabase db, $TripStopsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripStopsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripStopsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripStopsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> arrivalLocal = const Value.absent(),
                Value<String?> arrivalZone = const Value.absent(),
                Value<String?> departureLocal = const Value.absent(),
                Value<String?> departureZone = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripStopsCompanion(
                id: id,
                tripId: tripId,
                label: label,
                sortOrder: sortOrder,
                arrivalLocal: arrivalLocal,
                arrivalZone: arrivalZone,
                departureLocal: departureLocal,
                departureZone: departureZone,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tripId,
                required String label,
                Value<int> sortOrder = const Value.absent(),
                Value<String?> arrivalLocal = const Value.absent(),
                Value<String?> arrivalZone = const Value.absent(),
                Value<String?> departureLocal = const Value.absent(),
                Value<String?> departureZone = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripStopsCompanion.insert(
                id: id,
                tripId: tripId,
                label: label,
                sortOrder: sortOrder,
                arrivalLocal: arrivalLocal,
                arrivalZone: arrivalZone,
                departureLocal: departureLocal,
                departureZone: departureZone,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TripStopsTable, TripStopEntry>(table),
                  $$TripStopsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                tripId = false,
                scheduleEventsRefs = false,
                returnCheckpointsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (scheduleEventsRefs) db.scheduleEvents,
                    if (returnCheckpointsRefs) db.returnCheckpoints,
                  ],
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
                        if (tripId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tripId,
                                    referencedTable: $$TripStopsTableReferences
                                        ._tripIdTable(db),
                                    referencedColumn: $$TripStopsTableReferences
                                        ._tripIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (scheduleEventsRefs)
                        await $_getPrefetchedData<
                          TripStopEntry,
                          $TripStopsTable,
                          ScheduleEventEntry
                        >(
                          currentTable: table,
                          referencedTable: $$TripStopsTableReferences
                              ._scheduleEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripStopsTableReferences(
                                db,
                                table,
                                p0,
                              ).scheduleEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripStopId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (returnCheckpointsRefs)
                        await $_getPrefetchedData<
                          TripStopEntry,
                          $TripStopsTable,
                          ReturnCheckpointEntry
                        >(
                          currentTable: table,
                          referencedTable: $$TripStopsTableReferences
                              ._returnCheckpointsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripStopsTableReferences(
                                db,
                                table,
                                p0,
                              ).returnCheckpointsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripStopId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TripStopsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TripStopsTable,
      TripStopEntry,
      $$TripStopsTableFilterComposer,
      $$TripStopsTableOrderingComposer,
      $$TripStopsTableAnnotationComposer,
      $$TripStopsTableCreateCompanionBuilder,
      $$TripStopsTableUpdateCompanionBuilder,
      (TripStopEntry, $$TripStopsTableReferences),
      TripStopEntry,
      PrefetchHooks Function({
        bool tripId,
        bool scheduleEventsRefs,
        bool returnCheckpointsRefs,
      })
    >;
typedef $$TripBagsTableCreateCompanionBuilder =
    TripBagsCompanion Function({
      required String id,
      required String tripId,
      required String name,
      Value<String?> description,
      Value<int> rowid,
    });
typedef $$TripBagsTableUpdateCompanionBuilder =
    TripBagsCompanion Function({
      Value<String> id,
      Value<String> tripId,
      Value<String> name,
      Value<String?> description,
      Value<int> rowid,
    });

final class $$TripBagsTableReferences
    extends BaseReferences<_$AppDatabase, $TripBagsTable, TripBagEntry> {
  $$TripBagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) =>
      db.trips.createAlias('trip_bags__trip_id__trips__id');

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<String>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BagCompartmentsTable, List<BagCompartmentEntry>>
  _bagCompartmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bagCompartments,
    aliasName: 'trip_bags__id__bag_compartments__trip_bag_id',
  );

  $$BagCompartmentsTableProcessedTableManager get bagCompartmentsRefs {
    final manager = $$BagCompartmentsTableTableManager(
      $_db,
      $_db.bagCompartments,
    ).filter((f) => f.tripBagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _bagCompartmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TripItemsTable, List<TripItemEntry>>
  _tripItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tripItems,
    aliasName: 'trip_bags__id__trip_items__trip_bag_id',
  );

  $$TripItemsTableProcessedTableManager get tripItemsRefs {
    final manager = $$TripItemsTableTableManager(
      $_db,
      $_db.tripItems,
    ).filter((f) => f.tripBagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tripItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ItemAllocationsTable, List<ItemAllocationEntry>>
  _itemAllocationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.itemAllocations,
    aliasName: 'trip_bags__id__item_allocations__trip_bag_id',
  );

  $$ItemAllocationsTableProcessedTableManager get itemAllocationsRefs {
    final manager = $$ItemAllocationsTableTableManager(
      $_db,
      $_db.itemAllocations,
    ).filter((f) => f.tripBagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _itemAllocationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TripBagsTableFilterComposer
    extends Composer<_$AppDatabase, $TripBagsTable> {
  $$TripBagsTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> bagCompartmentsRefs(
    Expression<bool> Function($$BagCompartmentsTableFilterComposer f) f,
  ) {
    final $$BagCompartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bagCompartments,
      getReferencedColumn: (t) => t.tripBagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BagCompartmentsTableFilterComposer(
            $db: $db,
            $table: $db.bagCompartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tripItemsRefs(
    Expression<bool> Function($$TripItemsTableFilterComposer f) f,
  ) {
    final $$TripItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tripItems,
      getReferencedColumn: (t) => t.tripBagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripItemsTableFilterComposer(
            $db: $db,
            $table: $db.tripItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> itemAllocationsRefs(
    Expression<bool> Function($$ItemAllocationsTableFilterComposer f) f,
  ) {
    final $$ItemAllocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemAllocations,
      getReferencedColumn: (t) => t.tripBagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemAllocationsTableFilterComposer(
            $db: $db,
            $table: $db.itemAllocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TripBagsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripBagsTable> {
  $$TripBagsTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripBagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripBagsTable> {
  $$TripBagsTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> bagCompartmentsRefs<T extends Object>(
    Expression<T> Function($$BagCompartmentsTableAnnotationComposer a) f,
  ) {
    final $$BagCompartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bagCompartments,
      getReferencedColumn: (t) => t.tripBagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BagCompartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.bagCompartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tripItemsRefs<T extends Object>(
    Expression<T> Function($$TripItemsTableAnnotationComposer a) f,
  ) {
    final $$TripItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tripItems,
      getReferencedColumn: (t) => t.tripBagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.tripItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> itemAllocationsRefs<T extends Object>(
    Expression<T> Function($$ItemAllocationsTableAnnotationComposer a) f,
  ) {
    final $$ItemAllocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemAllocations,
      getReferencedColumn: (t) => t.tripBagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemAllocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.itemAllocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TripBagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TripBagsTable,
          TripBagEntry,
          $$TripBagsTableFilterComposer,
          $$TripBagsTableOrderingComposer,
          $$TripBagsTableAnnotationComposer,
          $$TripBagsTableCreateCompanionBuilder,
          $$TripBagsTableUpdateCompanionBuilder,
          (TripBagEntry, $$TripBagsTableReferences),
          TripBagEntry,
          PrefetchHooks Function({
            bool tripId,
            bool bagCompartmentsRefs,
            bool tripItemsRefs,
            bool itemAllocationsRefs,
          })
        > {
  $$TripBagsTableTableManager(_$AppDatabase db, $TripBagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripBagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripBagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripBagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripBagsCompanion(
                id: id,
                tripId: tripId,
                name: name,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tripId,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripBagsCompanion.insert(
                id: id,
                tripId: tripId,
                name: name,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TripBagsTable, TripBagEntry>(table),
                  $$TripBagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                tripId = false,
                bagCompartmentsRefs = false,
                tripItemsRefs = false,
                itemAllocationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (bagCompartmentsRefs) db.bagCompartments,
                    if (tripItemsRefs) db.tripItems,
                    if (itemAllocationsRefs) db.itemAllocations,
                  ],
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
                        if (tripId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tripId,
                                    referencedTable: $$TripBagsTableReferences
                                        ._tripIdTable(db),
                                    referencedColumn: $$TripBagsTableReferences
                                        ._tripIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (bagCompartmentsRefs)
                        await $_getPrefetchedData<
                          TripBagEntry,
                          $TripBagsTable,
                          BagCompartmentEntry
                        >(
                          currentTable: table,
                          referencedTable: $$TripBagsTableReferences
                              ._bagCompartmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripBagsTableReferences(
                                db,
                                table,
                                p0,
                              ).bagCompartmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripBagId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tripItemsRefs)
                        await $_getPrefetchedData<
                          TripBagEntry,
                          $TripBagsTable,
                          TripItemEntry
                        >(
                          currentTable: table,
                          referencedTable: $$TripBagsTableReferences
                              ._tripItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripBagsTableReferences(
                                db,
                                table,
                                p0,
                              ).tripItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripBagId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (itemAllocationsRefs)
                        await $_getPrefetchedData<
                          TripBagEntry,
                          $TripBagsTable,
                          ItemAllocationEntry
                        >(
                          currentTable: table,
                          referencedTable: $$TripBagsTableReferences
                              ._itemAllocationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripBagsTableReferences(
                                db,
                                table,
                                p0,
                              ).itemAllocationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripBagId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TripBagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TripBagsTable,
      TripBagEntry,
      $$TripBagsTableFilterComposer,
      $$TripBagsTableOrderingComposer,
      $$TripBagsTableAnnotationComposer,
      $$TripBagsTableCreateCompanionBuilder,
      $$TripBagsTableUpdateCompanionBuilder,
      (TripBagEntry, $$TripBagsTableReferences),
      TripBagEntry,
      PrefetchHooks Function({
        bool tripId,
        bool bagCompartmentsRefs,
        bool tripItemsRefs,
        bool itemAllocationsRefs,
      })
    >;
typedef $$BagCompartmentsTableCreateCompanionBuilder =
    BagCompartmentsCompanion Function({
      required String id,
      required String tripBagId,
      required String name,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$BagCompartmentsTableUpdateCompanionBuilder =
    BagCompartmentsCompanion Function({
      Value<String> id,
      Value<String> tripBagId,
      Value<String> name,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$BagCompartmentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $BagCompartmentsTable,
          BagCompartmentEntry
        > {
  $$BagCompartmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TripBagsTable _tripBagIdTable(_$AppDatabase db) =>
      db.tripBags.createAlias('bag_compartments__trip_bag_id__trip_bags__id');

  $$TripBagsTableProcessedTableManager get tripBagId {
    final $_column = $_itemColumn<String>('trip_bag_id')!;

    final manager = $$TripBagsTableTableManager(
      $_db,
      $_db.tripBags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripBagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ItemAllocationsTable, List<ItemAllocationEntry>>
  _itemAllocationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.itemAllocations,
    aliasName: 'bag_compartments__id__item_allocations__compartment_id',
  );

  $$ItemAllocationsTableProcessedTableManager get itemAllocationsRefs {
    final manager = $$ItemAllocationsTableTableManager(
      $_db,
      $_db.itemAllocations,
    ).filter((f) => f.compartmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _itemAllocationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BagCompartmentsTableFilterComposer
    extends Composer<_$AppDatabase, $BagCompartmentsTable> {
  $$BagCompartmentsTableFilterComposer({
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

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$TripBagsTableFilterComposer get tripBagId {
    final $$TripBagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripBagId,
      referencedTable: $db.tripBags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripBagsTableFilterComposer(
            $db: $db,
            $table: $db.tripBags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> itemAllocationsRefs(
    Expression<bool> Function($$ItemAllocationsTableFilterComposer f) f,
  ) {
    final $$ItemAllocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemAllocations,
      getReferencedColumn: (t) => t.compartmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemAllocationsTableFilterComposer(
            $db: $db,
            $table: $db.itemAllocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BagCompartmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $BagCompartmentsTable> {
  $$BagCompartmentsTableOrderingComposer({
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

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripBagsTableOrderingComposer get tripBagId {
    final $$TripBagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripBagId,
      referencedTable: $db.tripBags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripBagsTableOrderingComposer(
            $db: $db,
            $table: $db.tripBags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BagCompartmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BagCompartmentsTable> {
  $$BagCompartmentsTableAnnotationComposer({
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

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$TripBagsTableAnnotationComposer get tripBagId {
    final $$TripBagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripBagId,
      referencedTable: $db.tripBags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripBagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tripBags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> itemAllocationsRefs<T extends Object>(
    Expression<T> Function($$ItemAllocationsTableAnnotationComposer a) f,
  ) {
    final $$ItemAllocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemAllocations,
      getReferencedColumn: (t) => t.compartmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemAllocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.itemAllocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BagCompartmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BagCompartmentsTable,
          BagCompartmentEntry,
          $$BagCompartmentsTableFilterComposer,
          $$BagCompartmentsTableOrderingComposer,
          $$BagCompartmentsTableAnnotationComposer,
          $$BagCompartmentsTableCreateCompanionBuilder,
          $$BagCompartmentsTableUpdateCompanionBuilder,
          (BagCompartmentEntry, $$BagCompartmentsTableReferences),
          BagCompartmentEntry,
          PrefetchHooks Function({bool tripBagId, bool itemAllocationsRefs})
        > {
  $$BagCompartmentsTableTableManager(
    _$AppDatabase db,
    $BagCompartmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BagCompartmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BagCompartmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BagCompartmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tripBagId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BagCompartmentsCompanion(
                id: id,
                tripBagId: tripBagId,
                name: name,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tripBagId,
                required String name,
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BagCompartmentsCompanion.insert(
                id: id,
                tripBagId: tripBagId,
                name: name,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BagCompartmentsTable, BagCompartmentEntry>(
                    table,
                  ),
                  $$BagCompartmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({tripBagId = false, itemAllocationsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (itemAllocationsRefs) db.itemAllocations,
                  ],
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
                        if (tripBagId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tripBagId,
                                    referencedTable:
                                        $$BagCompartmentsTableReferences
                                            ._tripBagIdTable(db),
                                    referencedColumn:
                                        $$BagCompartmentsTableReferences
                                            ._tripBagIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (itemAllocationsRefs)
                        await $_getPrefetchedData<
                          BagCompartmentEntry,
                          $BagCompartmentsTable,
                          ItemAllocationEntry
                        >(
                          currentTable: table,
                          referencedTable: $$BagCompartmentsTableReferences
                              ._itemAllocationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BagCompartmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).itemAllocationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.compartmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BagCompartmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BagCompartmentsTable,
      BagCompartmentEntry,
      $$BagCompartmentsTableFilterComposer,
      $$BagCompartmentsTableOrderingComposer,
      $$BagCompartmentsTableAnnotationComposer,
      $$BagCompartmentsTableCreateCompanionBuilder,
      $$BagCompartmentsTableUpdateCompanionBuilder,
      (BagCompartmentEntry, $$BagCompartmentsTableReferences),
      BagCompartmentEntry,
      PrefetchHooks Function({bool tripBagId, bool itemAllocationsRefs})
    >;
typedef $$TripItemsTableCreateCompanionBuilder =
    TripItemsCompanion Function({
      required String id,
      required String tripId,
      required String itemId,
      Value<String> decision,
      Value<int> plannedQuantity,
      Value<int> packedQuantity,
      Value<int> inUseQuantity,
      Value<String?> tripBagId,
      Value<String?> notes,
      required String nameSnapshot,
      Value<String?> sourceLabelSnapshot,
      Value<String?> lastPhysicallyConfirmedAt,
      Value<String?> departureCheckConfirmedAt,
      Value<bool> isPackedLast,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$TripItemsTableUpdateCompanionBuilder =
    TripItemsCompanion Function({
      Value<String> id,
      Value<String> tripId,
      Value<String> itemId,
      Value<String> decision,
      Value<int> plannedQuantity,
      Value<int> packedQuantity,
      Value<int> inUseQuantity,
      Value<String?> tripBagId,
      Value<String?> notes,
      Value<String> nameSnapshot,
      Value<String?> sourceLabelSnapshot,
      Value<String?> lastPhysicallyConfirmedAt,
      Value<String?> departureCheckConfirmedAt,
      Value<bool> isPackedLast,
      Value<String> updatedAt,
      Value<int> rowid,
    });

final class $$TripItemsTableReferences
    extends BaseReferences<_$AppDatabase, $TripItemsTable, TripItemEntry> {
  $$TripItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) =>
      db.trips.createAlias('trip_items__trip_id__trips__id');

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<String>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ItemsTable _itemIdTable(_$AppDatabase db) =>
      db.items.createAlias('trip_items__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TripBagsTable _tripBagIdTable(_$AppDatabase db) =>
      db.tripBags.createAlias('trip_items__trip_bag_id__trip_bags__id');

  $$TripBagsTableProcessedTableManager? get tripBagId {
    final $_column = $_itemColumn<String>('trip_bag_id');
    if ($_column == null) return null;
    final manager = $$TripBagsTableTableManager(
      $_db,
      $_db.tripBags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripBagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ItemAllocationsTable, List<ItemAllocationEntry>>
  _itemAllocationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.itemAllocations,
    aliasName: 'trip_items__id__item_allocations__trip_item_id',
  );

  $$ItemAllocationsTableProcessedTableManager get itemAllocationsRefs {
    final manager = $$ItemAllocationsTableTableManager(
      $_db,
      $_db.itemAllocations,
    ).filter((f) => f.tripItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _itemAllocationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReturnEntriesTable, List<ReturnEntryEntry>>
  _returnEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.returnEntries,
    aliasName: 'trip_items__id__return_entries__trip_item_id',
  );

  $$ReturnEntriesTableProcessedTableManager get returnEntriesRefs {
    final manager = $$ReturnEntriesTableTableManager(
      $_db,
      $_db.returnEntries,
    ).filter((f) => f.tripItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_returnEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TripItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TripItemsTable> {
  $$TripItemsTableFilterComposer({
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

  ColumnFilters<String> get decision => $composableBuilder(
    column: $table.decision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedQuantity => $composableBuilder(
    column: $table.plannedQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get packedQuantity => $composableBuilder(
    column: $table.packedQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get inUseQuantity => $composableBuilder(
    column: $table.inUseQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameSnapshot => $composableBuilder(
    column: $table.nameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceLabelSnapshot => $composableBuilder(
    column: $table.sourceLabelSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastPhysicallyConfirmedAt => $composableBuilder(
    column: $table.lastPhysicallyConfirmedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get departureCheckConfirmedAt => $composableBuilder(
    column: $table.departureCheckConfirmedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPackedLast => $composableBuilder(
    column: $table.isPackedLast,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }

  $$TripBagsTableFilterComposer get tripBagId {
    final $$TripBagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripBagId,
      referencedTable: $db.tripBags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripBagsTableFilterComposer(
            $db: $db,
            $table: $db.tripBags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> itemAllocationsRefs(
    Expression<bool> Function($$ItemAllocationsTableFilterComposer f) f,
  ) {
    final $$ItemAllocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemAllocations,
      getReferencedColumn: (t) => t.tripItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemAllocationsTableFilterComposer(
            $db: $db,
            $table: $db.itemAllocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> returnEntriesRefs(
    Expression<bool> Function($$ReturnEntriesTableFilterComposer f) f,
  ) {
    final $$ReturnEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.returnEntries,
      getReferencedColumn: (t) => t.tripItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReturnEntriesTableFilterComposer(
            $db: $db,
            $table: $db.returnEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TripItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripItemsTable> {
  $$TripItemsTableOrderingComposer({
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

  ColumnOrderings<String> get decision => $composableBuilder(
    column: $table.decision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedQuantity => $composableBuilder(
    column: $table.plannedQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get packedQuantity => $composableBuilder(
    column: $table.packedQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get inUseQuantity => $composableBuilder(
    column: $table.inUseQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameSnapshot => $composableBuilder(
    column: $table.nameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceLabelSnapshot => $composableBuilder(
    column: $table.sourceLabelSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastPhysicallyConfirmedAt => $composableBuilder(
    column: $table.lastPhysicallyConfirmedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get departureCheckConfirmedAt => $composableBuilder(
    column: $table.departureCheckConfirmedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPackedLast => $composableBuilder(
    column: $table.isPackedLast,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TripBagsTableOrderingComposer get tripBagId {
    final $$TripBagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripBagId,
      referencedTable: $db.tripBags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripBagsTableOrderingComposer(
            $db: $db,
            $table: $db.tripBags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripItemsTable> {
  $$TripItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get decision =>
      $composableBuilder(column: $table.decision, builder: (column) => column);

  GeneratedColumn<int> get plannedQuantity => $composableBuilder(
    column: $table.plannedQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get packedQuantity => $composableBuilder(
    column: $table.packedQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get inUseQuantity => $composableBuilder(
    column: $table.inUseQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get nameSnapshot => $composableBuilder(
    column: $table.nameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceLabelSnapshot => $composableBuilder(
    column: $table.sourceLabelSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastPhysicallyConfirmedAt => $composableBuilder(
    column: $table.lastPhysicallyConfirmedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get departureCheckConfirmedAt => $composableBuilder(
    column: $table.departureCheckConfirmedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPackedLast => $composableBuilder(
    column: $table.isPackedLast,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }

  $$TripBagsTableAnnotationComposer get tripBagId {
    final $$TripBagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripBagId,
      referencedTable: $db.tripBags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripBagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tripBags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> itemAllocationsRefs<T extends Object>(
    Expression<T> Function($$ItemAllocationsTableAnnotationComposer a) f,
  ) {
    final $$ItemAllocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemAllocations,
      getReferencedColumn: (t) => t.tripItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemAllocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.itemAllocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> returnEntriesRefs<T extends Object>(
    Expression<T> Function($$ReturnEntriesTableAnnotationComposer a) f,
  ) {
    final $$ReturnEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.returnEntries,
      getReferencedColumn: (t) => t.tripItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReturnEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.returnEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TripItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TripItemsTable,
          TripItemEntry,
          $$TripItemsTableFilterComposer,
          $$TripItemsTableOrderingComposer,
          $$TripItemsTableAnnotationComposer,
          $$TripItemsTableCreateCompanionBuilder,
          $$TripItemsTableUpdateCompanionBuilder,
          (TripItemEntry, $$TripItemsTableReferences),
          TripItemEntry,
          PrefetchHooks Function({
            bool tripId,
            bool itemId,
            bool tripBagId,
            bool itemAllocationsRefs,
            bool returnEntriesRefs,
          })
        > {
  $$TripItemsTableTableManager(_$AppDatabase db, $TripItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<String> decision = const Value.absent(),
                Value<int> plannedQuantity = const Value.absent(),
                Value<int> packedQuantity = const Value.absent(),
                Value<int> inUseQuantity = const Value.absent(),
                Value<String?> tripBagId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> nameSnapshot = const Value.absent(),
                Value<String?> sourceLabelSnapshot = const Value.absent(),
                Value<String?> lastPhysicallyConfirmedAt = const Value.absent(),
                Value<String?> departureCheckConfirmedAt = const Value.absent(),
                Value<bool> isPackedLast = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripItemsCompanion(
                id: id,
                tripId: tripId,
                itemId: itemId,
                decision: decision,
                plannedQuantity: plannedQuantity,
                packedQuantity: packedQuantity,
                inUseQuantity: inUseQuantity,
                tripBagId: tripBagId,
                notes: notes,
                nameSnapshot: nameSnapshot,
                sourceLabelSnapshot: sourceLabelSnapshot,
                lastPhysicallyConfirmedAt: lastPhysicallyConfirmedAt,
                departureCheckConfirmedAt: departureCheckConfirmedAt,
                isPackedLast: isPackedLast,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tripId,
                required String itemId,
                Value<String> decision = const Value.absent(),
                Value<int> plannedQuantity = const Value.absent(),
                Value<int> packedQuantity = const Value.absent(),
                Value<int> inUseQuantity = const Value.absent(),
                Value<String?> tripBagId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required String nameSnapshot,
                Value<String?> sourceLabelSnapshot = const Value.absent(),
                Value<String?> lastPhysicallyConfirmedAt = const Value.absent(),
                Value<String?> departureCheckConfirmedAt = const Value.absent(),
                Value<bool> isPackedLast = const Value.absent(),
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TripItemsCompanion.insert(
                id: id,
                tripId: tripId,
                itemId: itemId,
                decision: decision,
                plannedQuantity: plannedQuantity,
                packedQuantity: packedQuantity,
                inUseQuantity: inUseQuantity,
                tripBagId: tripBagId,
                notes: notes,
                nameSnapshot: nameSnapshot,
                sourceLabelSnapshot: sourceLabelSnapshot,
                lastPhysicallyConfirmedAt: lastPhysicallyConfirmedAt,
                departureCheckConfirmedAt: departureCheckConfirmedAt,
                isPackedLast: isPackedLast,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TripItemsTable, TripItemEntry>(table),
                  $$TripItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                tripId = false,
                itemId = false,
                tripBagId = false,
                itemAllocationsRefs = false,
                returnEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (itemAllocationsRefs) db.itemAllocations,
                    if (returnEntriesRefs) db.returnEntries,
                  ],
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
                        if (tripId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tripId,
                                    referencedTable: $$TripItemsTableReferences
                                        ._tripIdTable(db),
                                    referencedColumn: $$TripItemsTableReferences
                                        ._tripIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (itemId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.itemId,
                                    referencedTable: $$TripItemsTableReferences
                                        ._itemIdTable(db),
                                    referencedColumn: $$TripItemsTableReferences
                                        ._itemIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (tripBagId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tripBagId,
                                    referencedTable: $$TripItemsTableReferences
                                        ._tripBagIdTable(db),
                                    referencedColumn: $$TripItemsTableReferences
                                        ._tripBagIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (itemAllocationsRefs)
                        await $_getPrefetchedData<
                          TripItemEntry,
                          $TripItemsTable,
                          ItemAllocationEntry
                        >(
                          currentTable: table,
                          referencedTable: $$TripItemsTableReferences
                              ._itemAllocationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).itemAllocationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (returnEntriesRefs)
                        await $_getPrefetchedData<
                          TripItemEntry,
                          $TripItemsTable,
                          ReturnEntryEntry
                        >(
                          currentTable: table,
                          referencedTable: $$TripItemsTableReferences
                              ._returnEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).returnEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TripItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TripItemsTable,
      TripItemEntry,
      $$TripItemsTableFilterComposer,
      $$TripItemsTableOrderingComposer,
      $$TripItemsTableAnnotationComposer,
      $$TripItemsTableCreateCompanionBuilder,
      $$TripItemsTableUpdateCompanionBuilder,
      (TripItemEntry, $$TripItemsTableReferences),
      TripItemEntry,
      PrefetchHooks Function({
        bool tripId,
        bool itemId,
        bool tripBagId,
        bool itemAllocationsRefs,
        bool returnEntriesRefs,
      })
    >;
typedef $$ItemAllocationsTableCreateCompanionBuilder =
    ItemAllocationsCompanion Function({
      required String id,
      required String tripItemId,
      Value<String> targetType,
      Value<String?> tripBagId,
      Value<String?> compartmentId,
      Value<int> quantity,
      Value<String?> notes,
      Value<String?> lastConfirmedAt,
      Value<int> rowid,
    });
typedef $$ItemAllocationsTableUpdateCompanionBuilder =
    ItemAllocationsCompanion Function({
      Value<String> id,
      Value<String> tripItemId,
      Value<String> targetType,
      Value<String?> tripBagId,
      Value<String?> compartmentId,
      Value<int> quantity,
      Value<String?> notes,
      Value<String?> lastConfirmedAt,
      Value<int> rowid,
    });

final class $$ItemAllocationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ItemAllocationsTable,
          ItemAllocationEntry
        > {
  $$ItemAllocationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TripItemsTable _tripItemIdTable(_$AppDatabase db) => db.tripItems
      .createAlias('item_allocations__trip_item_id__trip_items__id');

  $$TripItemsTableProcessedTableManager get tripItemId {
    final $_column = $_itemColumn<String>('trip_item_id')!;

    final manager = $$TripItemsTableTableManager(
      $_db,
      $_db.tripItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TripBagsTable _tripBagIdTable(_$AppDatabase db) =>
      db.tripBags.createAlias('item_allocations__trip_bag_id__trip_bags__id');

  $$TripBagsTableProcessedTableManager? get tripBagId {
    final $_column = $_itemColumn<String>('trip_bag_id');
    if ($_column == null) return null;
    final manager = $$TripBagsTableTableManager(
      $_db,
      $_db.tripBags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripBagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BagCompartmentsTable _compartmentIdTable(_$AppDatabase db) => db
      .bagCompartments
      .createAlias('item_allocations__compartment_id__bag_compartments__id');

  $$BagCompartmentsTableProcessedTableManager? get compartmentId {
    final $_column = $_itemColumn<String>('compartment_id');
    if ($_column == null) return null;
    final manager = $$BagCompartmentsTableTableManager(
      $_db,
      $_db.bagCompartments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_compartmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItemAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $ItemAllocationsTable> {
  $$ItemAllocationsTableFilterComposer({
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

  ColumnFilters<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastConfirmedAt => $composableBuilder(
    column: $table.lastConfirmedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TripItemsTableFilterComposer get tripItemId {
    final $$TripItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripItemId,
      referencedTable: $db.tripItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripItemsTableFilterComposer(
            $db: $db,
            $table: $db.tripItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TripBagsTableFilterComposer get tripBagId {
    final $$TripBagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripBagId,
      referencedTable: $db.tripBags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripBagsTableFilterComposer(
            $db: $db,
            $table: $db.tripBags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BagCompartmentsTableFilterComposer get compartmentId {
    final $$BagCompartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.compartmentId,
      referencedTable: $db.bagCompartments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BagCompartmentsTableFilterComposer(
            $db: $db,
            $table: $db.bagCompartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemAllocationsTable> {
  $$ItemAllocationsTableOrderingComposer({
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

  ColumnOrderings<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastConfirmedAt => $composableBuilder(
    column: $table.lastConfirmedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripItemsTableOrderingComposer get tripItemId {
    final $$TripItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripItemId,
      referencedTable: $db.tripItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripItemsTableOrderingComposer(
            $db: $db,
            $table: $db.tripItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TripBagsTableOrderingComposer get tripBagId {
    final $$TripBagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripBagId,
      referencedTable: $db.tripBags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripBagsTableOrderingComposer(
            $db: $db,
            $table: $db.tripBags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BagCompartmentsTableOrderingComposer get compartmentId {
    final $$BagCompartmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.compartmentId,
      referencedTable: $db.bagCompartments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BagCompartmentsTableOrderingComposer(
            $db: $db,
            $table: $db.bagCompartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemAllocationsTable> {
  $$ItemAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get lastConfirmedAt => $composableBuilder(
    column: $table.lastConfirmedAt,
    builder: (column) => column,
  );

  $$TripItemsTableAnnotationComposer get tripItemId {
    final $$TripItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripItemId,
      referencedTable: $db.tripItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.tripItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TripBagsTableAnnotationComposer get tripBagId {
    final $$TripBagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripBagId,
      referencedTable: $db.tripBags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripBagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tripBags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BagCompartmentsTableAnnotationComposer get compartmentId {
    final $$BagCompartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.compartmentId,
      referencedTable: $db.bagCompartments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BagCompartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.bagCompartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemAllocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemAllocationsTable,
          ItemAllocationEntry,
          $$ItemAllocationsTableFilterComposer,
          $$ItemAllocationsTableOrderingComposer,
          $$ItemAllocationsTableAnnotationComposer,
          $$ItemAllocationsTableCreateCompanionBuilder,
          $$ItemAllocationsTableUpdateCompanionBuilder,
          (ItemAllocationEntry, $$ItemAllocationsTableReferences),
          ItemAllocationEntry,
          PrefetchHooks Function({
            bool tripItemId,
            bool tripBagId,
            bool compartmentId,
          })
        > {
  $$ItemAllocationsTableTableManager(
    _$AppDatabase db,
    $ItemAllocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemAllocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemAllocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemAllocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tripItemId = const Value.absent(),
                Value<String> targetType = const Value.absent(),
                Value<String?> tripBagId = const Value.absent(),
                Value<String?> compartmentId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> lastConfirmedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemAllocationsCompanion(
                id: id,
                tripItemId: tripItemId,
                targetType: targetType,
                tripBagId: tripBagId,
                compartmentId: compartmentId,
                quantity: quantity,
                notes: notes,
                lastConfirmedAt: lastConfirmedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tripItemId,
                Value<String> targetType = const Value.absent(),
                Value<String?> tripBagId = const Value.absent(),
                Value<String?> compartmentId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> lastConfirmedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemAllocationsCompanion.insert(
                id: id,
                tripItemId: tripItemId,
                targetType: targetType,
                tripBagId: tripBagId,
                compartmentId: compartmentId,
                quantity: quantity,
                notes: notes,
                lastConfirmedAt: lastConfirmedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemAllocationsTable, ItemAllocationEntry>(
                    table,
                  ),
                  $$ItemAllocationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({tripItemId = false, tripBagId = false, compartmentId = false}) {
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
                        if (tripItemId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tripItemId,
                                    referencedTable:
                                        $$ItemAllocationsTableReferences
                                            ._tripItemIdTable(db),
                                    referencedColumn:
                                        $$ItemAllocationsTableReferences
                                            ._tripItemIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (tripBagId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tripBagId,
                                    referencedTable:
                                        $$ItemAllocationsTableReferences
                                            ._tripBagIdTable(db),
                                    referencedColumn:
                                        $$ItemAllocationsTableReferences
                                            ._tripBagIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (compartmentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.compartmentId,
                                    referencedTable:
                                        $$ItemAllocationsTableReferences
                                            ._compartmentIdTable(db),
                                    referencedColumn:
                                        $$ItemAllocationsTableReferences
                                            ._compartmentIdTable(db)
                                            .id,
                                  )
                                  as T;
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

typedef $$ItemAllocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemAllocationsTable,
      ItemAllocationEntry,
      $$ItemAllocationsTableFilterComposer,
      $$ItemAllocationsTableOrderingComposer,
      $$ItemAllocationsTableAnnotationComposer,
      $$ItemAllocationsTableCreateCompanionBuilder,
      $$ItemAllocationsTableUpdateCompanionBuilder,
      (ItemAllocationEntry, $$ItemAllocationsTableReferences),
      ItemAllocationEntry,
      PrefetchHooks Function({
        bool tripItemId,
        bool tripBagId,
        bool compartmentId,
      })
    >;
typedef $$ScheduleEventsTableCreateCompanionBuilder =
    ScheduleEventsCompanion Function({
      required String id,
      required String tripId,
      Value<String?> tripStopId,
      required String title,
      required String type,
      Value<bool> isDateOnly,
      required String localDate,
      Value<String?> localStart,
      Value<String?> startZone,
      Value<String?> startUtc,
      Value<String?> localEnd,
      Value<String?> endZone,
      Value<String?> endUtc,
      Value<String?> locationText,
      Value<String?> notes,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$ScheduleEventsTableUpdateCompanionBuilder =
    ScheduleEventsCompanion Function({
      Value<String> id,
      Value<String> tripId,
      Value<String?> tripStopId,
      Value<String> title,
      Value<String> type,
      Value<bool> isDateOnly,
      Value<String> localDate,
      Value<String?> localStart,
      Value<String?> startZone,
      Value<String?> startUtc,
      Value<String?> localEnd,
      Value<String?> endZone,
      Value<String?> endUtc,
      Value<String?> locationText,
      Value<String?> notes,
      Value<String> status,
      Value<int> rowid,
    });

final class $$ScheduleEventsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ScheduleEventsTable,
          ScheduleEventEntry
        > {
  $$ScheduleEventsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TripsTable _tripIdTable(_$AppDatabase db) =>
      db.trips.createAlias('schedule_events__trip_id__trips__id');

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<String>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TripStopsTable _tripStopIdTable(_$AppDatabase db) =>
      db.tripStops.createAlias('schedule_events__trip_stop_id__trip_stops__id');

  $$TripStopsTableProcessedTableManager? get tripStopId {
    final $_column = $_itemColumn<String>('trip_stop_id');
    if ($_column == null) return null;
    final manager = $$TripStopsTableTableManager(
      $_db,
      $_db.tripStops,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripStopIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TicketsTable, List<TicketEntry>>
  _ticketsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tickets,
    aliasName: 'schedule_events__id__tickets__schedule_event_id',
  );

  $$TicketsTableProcessedTableManager get ticketsRefs {
    final manager = $$TicketsTableTableManager($_db, $_db.tickets).filter(
      (f) => f.scheduleEventId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_ticketsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemindersTable, List<ReminderEntry>>
  _remindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminders,
    aliasName: 'schedule_events__id__reminders__schedule_event_id',
  );

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager($_db, $_db.reminders).filter(
      (f) => f.scheduleEventId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ScheduleEventsTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduleEventsTable> {
  $$ScheduleEventsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDateOnly => $composableBuilder(
    column: $table.isDateOnly,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localStart => $composableBuilder(
    column: $table.localStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startZone => $composableBuilder(
    column: $table.startZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startUtc => $composableBuilder(
    column: $table.startUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localEnd => $composableBuilder(
    column: $table.localEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endZone => $composableBuilder(
    column: $table.endZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endUtc => $composableBuilder(
    column: $table.endUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationText => $composableBuilder(
    column: $table.locationText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TripStopsTableFilterComposer get tripStopId {
    final $$TripStopsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripStopId,
      referencedTable: $db.tripStops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripStopsTableFilterComposer(
            $db: $db,
            $table: $db.tripStops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ticketsRefs(
    Expression<bool> Function($$TicketsTableFilterComposer f) f,
  ) {
    final $$TicketsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.scheduleEventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableFilterComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> remindersRefs(
    Expression<bool> Function($$RemindersTableFilterComposer f) f,
  ) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.scheduleEventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableFilterComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ScheduleEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduleEventsTable> {
  $$ScheduleEventsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDateOnly => $composableBuilder(
    column: $table.isDateOnly,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localStart => $composableBuilder(
    column: $table.localStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startZone => $composableBuilder(
    column: $table.startZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startUtc => $composableBuilder(
    column: $table.startUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localEnd => $composableBuilder(
    column: $table.localEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endZone => $composableBuilder(
    column: $table.endZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endUtc => $composableBuilder(
    column: $table.endUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationText => $composableBuilder(
    column: $table.locationText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TripStopsTableOrderingComposer get tripStopId {
    final $$TripStopsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripStopId,
      referencedTable: $db.tripStops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripStopsTableOrderingComposer(
            $db: $db,
            $table: $db.tripStops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduleEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduleEventsTable> {
  $$ScheduleEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get isDateOnly => $composableBuilder(
    column: $table.isDateOnly,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<String> get localStart => $composableBuilder(
    column: $table.localStart,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startZone =>
      $composableBuilder(column: $table.startZone, builder: (column) => column);

  GeneratedColumn<String> get startUtc =>
      $composableBuilder(column: $table.startUtc, builder: (column) => column);

  GeneratedColumn<String> get localEnd =>
      $composableBuilder(column: $table.localEnd, builder: (column) => column);

  GeneratedColumn<String> get endZone =>
      $composableBuilder(column: $table.endZone, builder: (column) => column);

  GeneratedColumn<String> get endUtc =>
      $composableBuilder(column: $table.endUtc, builder: (column) => column);

  GeneratedColumn<String> get locationText => $composableBuilder(
    column: $table.locationText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TripStopsTableAnnotationComposer get tripStopId {
    final $$TripStopsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripStopId,
      referencedTable: $db.tripStops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripStopsTableAnnotationComposer(
            $db: $db,
            $table: $db.tripStops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ticketsRefs<T extends Object>(
    Expression<T> Function($$TicketsTableAnnotationComposer a) f,
  ) {
    final $$TicketsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.scheduleEventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableAnnotationComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> remindersRefs<T extends Object>(
    Expression<T> Function($$RemindersTableAnnotationComposer a) f,
  ) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.scheduleEventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ScheduleEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScheduleEventsTable,
          ScheduleEventEntry,
          $$ScheduleEventsTableFilterComposer,
          $$ScheduleEventsTableOrderingComposer,
          $$ScheduleEventsTableAnnotationComposer,
          $$ScheduleEventsTableCreateCompanionBuilder,
          $$ScheduleEventsTableUpdateCompanionBuilder,
          (ScheduleEventEntry, $$ScheduleEventsTableReferences),
          ScheduleEventEntry,
          PrefetchHooks Function({
            bool tripId,
            bool tripStopId,
            bool ticketsRefs,
            bool remindersRefs,
          })
        > {
  $$ScheduleEventsTableTableManager(
    _$AppDatabase db,
    $ScheduleEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduleEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduleEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScheduleEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<String?> tripStopId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<bool> isDateOnly = const Value.absent(),
                Value<String> localDate = const Value.absent(),
                Value<String?> localStart = const Value.absent(),
                Value<String?> startZone = const Value.absent(),
                Value<String?> startUtc = const Value.absent(),
                Value<String?> localEnd = const Value.absent(),
                Value<String?> endZone = const Value.absent(),
                Value<String?> endUtc = const Value.absent(),
                Value<String?> locationText = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScheduleEventsCompanion(
                id: id,
                tripId: tripId,
                tripStopId: tripStopId,
                title: title,
                type: type,
                isDateOnly: isDateOnly,
                localDate: localDate,
                localStart: localStart,
                startZone: startZone,
                startUtc: startUtc,
                localEnd: localEnd,
                endZone: endZone,
                endUtc: endUtc,
                locationText: locationText,
                notes: notes,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tripId,
                Value<String?> tripStopId = const Value.absent(),
                required String title,
                required String type,
                Value<bool> isDateOnly = const Value.absent(),
                required String localDate,
                Value<String?> localStart = const Value.absent(),
                Value<String?> startZone = const Value.absent(),
                Value<String?> startUtc = const Value.absent(),
                Value<String?> localEnd = const Value.absent(),
                Value<String?> endZone = const Value.absent(),
                Value<String?> endUtc = const Value.absent(),
                Value<String?> locationText = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScheduleEventsCompanion.insert(
                id: id,
                tripId: tripId,
                tripStopId: tripStopId,
                title: title,
                type: type,
                isDateOnly: isDateOnly,
                localDate: localDate,
                localStart: localStart,
                startZone: startZone,
                startUtc: startUtc,
                localEnd: localEnd,
                endZone: endZone,
                endUtc: endUtc,
                locationText: locationText,
                notes: notes,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ScheduleEventsTable, ScheduleEventEntry>(table),
                  $$ScheduleEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                tripId = false,
                tripStopId = false,
                ticketsRefs = false,
                remindersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ticketsRefs) db.tickets,
                    if (remindersRefs) db.reminders,
                  ],
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
                        if (tripId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tripId,
                                    referencedTable:
                                        $$ScheduleEventsTableReferences
                                            ._tripIdTable(db),
                                    referencedColumn:
                                        $$ScheduleEventsTableReferences
                                            ._tripIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (tripStopId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tripStopId,
                                    referencedTable:
                                        $$ScheduleEventsTableReferences
                                            ._tripStopIdTable(db),
                                    referencedColumn:
                                        $$ScheduleEventsTableReferences
                                            ._tripStopIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ticketsRefs)
                        await $_getPrefetchedData<
                          ScheduleEventEntry,
                          $ScheduleEventsTable,
                          TicketEntry
                        >(
                          currentTable: table,
                          referencedTable: $$ScheduleEventsTableReferences
                              ._ticketsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ScheduleEventsTableReferences(
                                db,
                                table,
                                p0,
                              ).ticketsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.scheduleEventId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (remindersRefs)
                        await $_getPrefetchedData<
                          ScheduleEventEntry,
                          $ScheduleEventsTable,
                          ReminderEntry
                        >(
                          currentTable: table,
                          referencedTable: $$ScheduleEventsTableReferences
                              ._remindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ScheduleEventsTableReferences(
                                db,
                                table,
                                p0,
                              ).remindersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.scheduleEventId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ScheduleEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScheduleEventsTable,
      ScheduleEventEntry,
      $$ScheduleEventsTableFilterComposer,
      $$ScheduleEventsTableOrderingComposer,
      $$ScheduleEventsTableAnnotationComposer,
      $$ScheduleEventsTableCreateCompanionBuilder,
      $$ScheduleEventsTableUpdateCompanionBuilder,
      (ScheduleEventEntry, $$ScheduleEventsTableReferences),
      ScheduleEventEntry,
      PrefetchHooks Function({
        bool tripId,
        bool tripStopId,
        bool ticketsRefs,
        bool remindersRefs,
      })
    >;
typedef $$TicketsTableCreateCompanionBuilder =
    TicketsCompanion Function({
      required String id,
      required String tripId,
      Value<String?> scheduleEventId,
      required String title,
      Value<String?> provider,
      Value<String?> bookingCode,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$TicketsTableUpdateCompanionBuilder =
    TicketsCompanion Function({
      Value<String> id,
      Value<String> tripId,
      Value<String?> scheduleEventId,
      Value<String> title,
      Value<String?> provider,
      Value<String?> bookingCode,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$TicketsTableReferences
    extends BaseReferences<_$AppDatabase, $TicketsTable, TicketEntry> {
  $$TicketsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) =>
      db.trips.createAlias('tickets__trip_id__trips__id');

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<String>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ScheduleEventsTable _scheduleEventIdTable(_$AppDatabase db) => db
      .scheduleEvents
      .createAlias('tickets__schedule_event_id__schedule_events__id');

  $$ScheduleEventsTableProcessedTableManager? get scheduleEventId {
    final $_column = $_itemColumn<String>('schedule_event_id');
    if ($_column == null) return null;
    final manager = $$ScheduleEventsTableTableManager(
      $_db,
      $_db.scheduleEvents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_scheduleEventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $TicketAttachmentsTable,
    List<TicketAttachmentEntry>
  >
  _ticketAttachmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.ticketAttachments,
        aliasName: 'tickets__id__ticket_attachments__ticket_id',
      );

  $$TicketAttachmentsTableProcessedTableManager get ticketAttachmentsRefs {
    final manager = $$TicketAttachmentsTableTableManager(
      $_db,
      $_db.ticketAttachments,
    ).filter((f) => f.ticketId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _ticketAttachmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TicketsTableFilterComposer
    extends Composer<_$AppDatabase, $TicketsTable> {
  $$TicketsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bookingCode => $composableBuilder(
    column: $table.bookingCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ScheduleEventsTableFilterComposer get scheduleEventId {
    final $$ScheduleEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleEventId,
      referencedTable: $db.scheduleEvents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleEventsTableFilterComposer(
            $db: $db,
            $table: $db.scheduleEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ticketAttachmentsRefs(
    Expression<bool> Function($$TicketAttachmentsTableFilterComposer f) f,
  ) {
    final $$TicketAttachmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ticketAttachments,
      getReferencedColumn: (t) => t.ticketId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketAttachmentsTableFilterComposer(
            $db: $db,
            $table: $db.ticketAttachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TicketsTableOrderingComposer
    extends Composer<_$AppDatabase, $TicketsTable> {
  $$TicketsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bookingCode => $composableBuilder(
    column: $table.bookingCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ScheduleEventsTableOrderingComposer get scheduleEventId {
    final $$ScheduleEventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleEventId,
      referencedTable: $db.scheduleEvents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleEventsTableOrderingComposer(
            $db: $db,
            $table: $db.scheduleEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TicketsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TicketsTable> {
  $$TicketsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get bookingCode => $composableBuilder(
    column: $table.bookingCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ScheduleEventsTableAnnotationComposer get scheduleEventId {
    final $$ScheduleEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleEventId,
      referencedTable: $db.scheduleEvents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.scheduleEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ticketAttachmentsRefs<T extends Object>(
    Expression<T> Function($$TicketAttachmentsTableAnnotationComposer a) f,
  ) {
    final $$TicketAttachmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.ticketAttachments,
          getReferencedColumn: (t) => t.ticketId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TicketAttachmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.ticketAttachments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TicketsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TicketsTable,
          TicketEntry,
          $$TicketsTableFilterComposer,
          $$TicketsTableOrderingComposer,
          $$TicketsTableAnnotationComposer,
          $$TicketsTableCreateCompanionBuilder,
          $$TicketsTableUpdateCompanionBuilder,
          (TicketEntry, $$TicketsTableReferences),
          TicketEntry,
          PrefetchHooks Function({
            bool tripId,
            bool scheduleEventId,
            bool ticketAttachmentsRefs,
          })
        > {
  $$TicketsTableTableManager(_$AppDatabase db, $TicketsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TicketsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TicketsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TicketsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<String?> scheduleEventId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> provider = const Value.absent(),
                Value<String?> bookingCode = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TicketsCompanion(
                id: id,
                tripId: tripId,
                scheduleEventId: scheduleEventId,
                title: title,
                provider: provider,
                bookingCode: bookingCode,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tripId,
                Value<String?> scheduleEventId = const Value.absent(),
                required String title,
                Value<String?> provider = const Value.absent(),
                Value<String?> bookingCode = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TicketsCompanion.insert(
                id: id,
                tripId: tripId,
                scheduleEventId: scheduleEventId,
                title: title,
                provider: provider,
                bookingCode: bookingCode,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TicketsTable, TicketEntry>(table),
                  $$TicketsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                tripId = false,
                scheduleEventId = false,
                ticketAttachmentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ticketAttachmentsRefs) db.ticketAttachments,
                  ],
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
                        if (tripId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tripId,
                                    referencedTable: $$TicketsTableReferences
                                        ._tripIdTable(db),
                                    referencedColumn: $$TicketsTableReferences
                                        ._tripIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (scheduleEventId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.scheduleEventId,
                                    referencedTable: $$TicketsTableReferences
                                        ._scheduleEventIdTable(db),
                                    referencedColumn: $$TicketsTableReferences
                                        ._scheduleEventIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ticketAttachmentsRefs)
                        await $_getPrefetchedData<
                          TicketEntry,
                          $TicketsTable,
                          TicketAttachmentEntry
                        >(
                          currentTable: table,
                          referencedTable: $$TicketsTableReferences
                              ._ticketAttachmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TicketsTableReferences(
                                db,
                                table,
                                p0,
                              ).ticketAttachmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ticketId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TicketsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TicketsTable,
      TicketEntry,
      $$TicketsTableFilterComposer,
      $$TicketsTableOrderingComposer,
      $$TicketsTableAnnotationComposer,
      $$TicketsTableCreateCompanionBuilder,
      $$TicketsTableUpdateCompanionBuilder,
      (TicketEntry, $$TicketsTableReferences),
      TicketEntry,
      PrefetchHooks Function({
        bool tripId,
        bool scheduleEventId,
        bool ticketAttachmentsRefs,
      })
    >;
typedef $$TicketAttachmentsTableCreateCompanionBuilder =
    TicketAttachmentsCompanion Function({
      required String id,
      required String ticketId,
      required String assetId,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$TicketAttachmentsTableUpdateCompanionBuilder =
    TicketAttachmentsCompanion Function({
      Value<String> id,
      Value<String> ticketId,
      Value<String> assetId,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$TicketAttachmentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TicketAttachmentsTable,
          TicketAttachmentEntry
        > {
  $$TicketAttachmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TicketsTable _ticketIdTable(_$AppDatabase db) =>
      db.tickets.createAlias('ticket_attachments__ticket_id__tickets__id');

  $$TicketsTableProcessedTableManager get ticketId {
    final $_column = $_itemColumn<String>('ticket_id')!;

    final manager = $$TicketsTableTableManager(
      $_db,
      $_db.tickets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ticketIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AssetsTable _assetIdTable(_$AppDatabase db) =>
      db.assets.createAlias('ticket_attachments__asset_id__assets__id');

  $$AssetsTableProcessedTableManager get assetId {
    final $_column = $_itemColumn<String>('asset_id')!;

    final manager = $$AssetsTableTableManager(
      $_db,
      $_db.assets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TicketAttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $TicketAttachmentsTable> {
  $$TicketAttachmentsTableFilterComposer({
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

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$TicketsTableFilterComposer get ticketId {
    final $$TicketsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ticketId,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableFilterComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetsTableFilterComposer get assetId {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableFilterComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TicketAttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $TicketAttachmentsTable> {
  $$TicketAttachmentsTableOrderingComposer({
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

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$TicketsTableOrderingComposer get ticketId {
    final $$TicketsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ticketId,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableOrderingComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetsTableOrderingComposer get assetId {
    final $$AssetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableOrderingComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TicketAttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TicketAttachmentsTable> {
  $$TicketAttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$TicketsTableAnnotationComposer get ticketId {
    final $$TicketsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ticketId,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableAnnotationComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetsTableAnnotationComposer get assetId {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableAnnotationComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TicketAttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TicketAttachmentsTable,
          TicketAttachmentEntry,
          $$TicketAttachmentsTableFilterComposer,
          $$TicketAttachmentsTableOrderingComposer,
          $$TicketAttachmentsTableAnnotationComposer,
          $$TicketAttachmentsTableCreateCompanionBuilder,
          $$TicketAttachmentsTableUpdateCompanionBuilder,
          (TicketAttachmentEntry, $$TicketAttachmentsTableReferences),
          TicketAttachmentEntry,
          PrefetchHooks Function({bool ticketId, bool assetId})
        > {
  $$TicketAttachmentsTableTableManager(
    _$AppDatabase db,
    $TicketAttachmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TicketAttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TicketAttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TicketAttachmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ticketId = const Value.absent(),
                Value<String> assetId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TicketAttachmentsCompanion(
                id: id,
                ticketId: ticketId,
                assetId: assetId,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ticketId,
                required String assetId,
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TicketAttachmentsCompanion.insert(
                id: id,
                ticketId: ticketId,
                assetId: assetId,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TicketAttachmentsTable, TicketAttachmentEntry>(
                    table,
                  ),
                  $$TicketAttachmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ticketId = false, assetId = false}) {
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
                    if (ticketId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ticketId,
                                referencedTable:
                                    $$TicketAttachmentsTableReferences
                                        ._ticketIdTable(db),
                                referencedColumn:
                                    $$TicketAttachmentsTableReferences
                                        ._ticketIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (assetId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.assetId,
                                referencedTable:
                                    $$TicketAttachmentsTableReferences
                                        ._assetIdTable(db),
                                referencedColumn:
                                    $$TicketAttachmentsTableReferences
                                        ._assetIdTable(db)
                                        .id,
                              )
                              as T;
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

typedef $$TicketAttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TicketAttachmentsTable,
      TicketAttachmentEntry,
      $$TicketAttachmentsTableFilterComposer,
      $$TicketAttachmentsTableOrderingComposer,
      $$TicketAttachmentsTableAnnotationComposer,
      $$TicketAttachmentsTableCreateCompanionBuilder,
      $$TicketAttachmentsTableUpdateCompanionBuilder,
      (TicketAttachmentEntry, $$TicketAttachmentsTableReferences),
      TicketAttachmentEntry,
      PrefetchHooks Function({bool ticketId, bool assetId})
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      required String id,
      required String scheduleEventId,
      required String triggerUtc,
      required int notificationId,
      Value<String> precisionPreference,
      Value<String> schedulingState,
      Value<bool> enabled,
      Value<int> rowid,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<String> id,
      Value<String> scheduleEventId,
      Value<String> triggerUtc,
      Value<int> notificationId,
      Value<String> precisionPreference,
      Value<String> schedulingState,
      Value<bool> enabled,
      Value<int> rowid,
    });

final class $$RemindersTableReferences
    extends BaseReferences<_$AppDatabase, $RemindersTable, ReminderEntry> {
  $$RemindersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ScheduleEventsTable _scheduleEventIdTable(_$AppDatabase db) => db
      .scheduleEvents
      .createAlias('reminders__schedule_event_id__schedule_events__id');

  $$ScheduleEventsTableProcessedTableManager get scheduleEventId {
    final $_column = $_itemColumn<String>('schedule_event_id')!;

    final manager = $$ScheduleEventsTableTableManager(
      $_db,
      $_db.scheduleEvents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_scheduleEventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
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

  ColumnFilters<String> get triggerUtc => $composableBuilder(
    column: $table.triggerUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get precisionPreference => $composableBuilder(
    column: $table.precisionPreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schedulingState => $composableBuilder(
    column: $table.schedulingState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  $$ScheduleEventsTableFilterComposer get scheduleEventId {
    final $$ScheduleEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleEventId,
      referencedTable: $db.scheduleEvents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleEventsTableFilterComposer(
            $db: $db,
            $table: $db.scheduleEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
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

  ColumnOrderings<String> get triggerUtc => $composableBuilder(
    column: $table.triggerUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get precisionPreference => $composableBuilder(
    column: $table.precisionPreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schedulingState => $composableBuilder(
    column: $table.schedulingState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  $$ScheduleEventsTableOrderingComposer get scheduleEventId {
    final $$ScheduleEventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleEventId,
      referencedTable: $db.scheduleEvents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleEventsTableOrderingComposer(
            $db: $db,
            $table: $db.scheduleEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get triggerUtc => $composableBuilder(
    column: $table.triggerUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get precisionPreference => $composableBuilder(
    column: $table.precisionPreference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get schedulingState => $composableBuilder(
    column: $table.schedulingState,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  $$ScheduleEventsTableAnnotationComposer get scheduleEventId {
    final $$ScheduleEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleEventId,
      referencedTable: $db.scheduleEvents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.scheduleEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          ReminderEntry,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (ReminderEntry, $$RemindersTableReferences),
          ReminderEntry,
          PrefetchHooks Function({bool scheduleEventId})
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> scheduleEventId = const Value.absent(),
                Value<String> triggerUtc = const Value.absent(),
                Value<int> notificationId = const Value.absent(),
                Value<String> precisionPreference = const Value.absent(),
                Value<String> schedulingState = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                scheduleEventId: scheduleEventId,
                triggerUtc: triggerUtc,
                notificationId: notificationId,
                precisionPreference: precisionPreference,
                schedulingState: schedulingState,
                enabled: enabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String scheduleEventId,
                required String triggerUtc,
                required int notificationId,
                Value<String> precisionPreference = const Value.absent(),
                Value<String> schedulingState = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                scheduleEventId: scheduleEventId,
                triggerUtc: triggerUtc,
                notificationId: notificationId,
                precisionPreference: precisionPreference,
                schedulingState: schedulingState,
                enabled: enabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RemindersTable, ReminderEntry>(table),
                  $$RemindersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({scheduleEventId = false}) {
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
                    if (scheduleEventId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.scheduleEventId,
                                referencedTable: $$RemindersTableReferences
                                    ._scheduleEventIdTable(db),
                                referencedColumn: $$RemindersTableReferences
                                    ._scheduleEventIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      ReminderEntry,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (ReminderEntry, $$RemindersTableReferences),
      ReminderEntry,
      PrefetchHooks Function({bool scheduleEventId})
    >;
typedef $$ReturnCheckpointsTableCreateCompanionBuilder =
    ReturnCheckpointsCompanion Function({
      required String id,
      required String tripId,
      Value<String?> tripStopId,
      required String title,
      required String createdAt,
      Value<String?> closedAt,
      Value<String> closeState,
      Value<int> rowid,
    });
typedef $$ReturnCheckpointsTableUpdateCompanionBuilder =
    ReturnCheckpointsCompanion Function({
      Value<String> id,
      Value<String> tripId,
      Value<String?> tripStopId,
      Value<String> title,
      Value<String> createdAt,
      Value<String?> closedAt,
      Value<String> closeState,
      Value<int> rowid,
    });

final class $$ReturnCheckpointsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReturnCheckpointsTable,
          ReturnCheckpointEntry
        > {
  $$ReturnCheckpointsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TripsTable _tripIdTable(_$AppDatabase db) =>
      db.trips.createAlias('return_checkpoints__trip_id__trips__id');

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<String>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TripStopsTable _tripStopIdTable(_$AppDatabase db) => db.tripStops
      .createAlias('return_checkpoints__trip_stop_id__trip_stops__id');

  $$TripStopsTableProcessedTableManager? get tripStopId {
    final $_column = $_itemColumn<String>('trip_stop_id');
    if ($_column == null) return null;
    final manager = $$TripStopsTableTableManager(
      $_db,
      $_db.tripStops,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripStopIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ReturnEntriesTable, List<ReturnEntryEntry>>
  _returnEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.returnEntries,
    aliasName: 'return_checkpoints__id__return_entries__checkpoint_id',
  );

  $$ReturnEntriesTableProcessedTableManager get returnEntriesRefs {
    final manager = $$ReturnEntriesTableTableManager(
      $_db,
      $_db.returnEntries,
    ).filter((f) => f.checkpointId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_returnEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ReturnCheckpointsTableFilterComposer
    extends Composer<_$AppDatabase, $ReturnCheckpointsTable> {
  $$ReturnCheckpointsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get closeState => $composableBuilder(
    column: $table.closeState,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TripStopsTableFilterComposer get tripStopId {
    final $$TripStopsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripStopId,
      referencedTable: $db.tripStops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripStopsTableFilterComposer(
            $db: $db,
            $table: $db.tripStops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> returnEntriesRefs(
    Expression<bool> Function($$ReturnEntriesTableFilterComposer f) f,
  ) {
    final $$ReturnEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.returnEntries,
      getReferencedColumn: (t) => t.checkpointId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReturnEntriesTableFilterComposer(
            $db: $db,
            $table: $db.returnEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReturnCheckpointsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReturnCheckpointsTable> {
  $$ReturnCheckpointsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get closeState => $composableBuilder(
    column: $table.closeState,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TripStopsTableOrderingComposer get tripStopId {
    final $$TripStopsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripStopId,
      referencedTable: $db.tripStops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripStopsTableOrderingComposer(
            $db: $db,
            $table: $db.tripStops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReturnCheckpointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReturnCheckpointsTable> {
  $$ReturnCheckpointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  GeneratedColumn<String> get closeState => $composableBuilder(
    column: $table.closeState,
    builder: (column) => column,
  );

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TripStopsTableAnnotationComposer get tripStopId {
    final $$TripStopsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripStopId,
      referencedTable: $db.tripStops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripStopsTableAnnotationComposer(
            $db: $db,
            $table: $db.tripStops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> returnEntriesRefs<T extends Object>(
    Expression<T> Function($$ReturnEntriesTableAnnotationComposer a) f,
  ) {
    final $$ReturnEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.returnEntries,
      getReferencedColumn: (t) => t.checkpointId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReturnEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.returnEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReturnCheckpointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReturnCheckpointsTable,
          ReturnCheckpointEntry,
          $$ReturnCheckpointsTableFilterComposer,
          $$ReturnCheckpointsTableOrderingComposer,
          $$ReturnCheckpointsTableAnnotationComposer,
          $$ReturnCheckpointsTableCreateCompanionBuilder,
          $$ReturnCheckpointsTableUpdateCompanionBuilder,
          (ReturnCheckpointEntry, $$ReturnCheckpointsTableReferences),
          ReturnCheckpointEntry,
          PrefetchHooks Function({
            bool tripId,
            bool tripStopId,
            bool returnEntriesRefs,
          })
        > {
  $$ReturnCheckpointsTableTableManager(
    _$AppDatabase db,
    $ReturnCheckpointsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReturnCheckpointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReturnCheckpointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReturnCheckpointsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<String?> tripStopId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String?> closedAt = const Value.absent(),
                Value<String> closeState = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReturnCheckpointsCompanion(
                id: id,
                tripId: tripId,
                tripStopId: tripStopId,
                title: title,
                createdAt: createdAt,
                closedAt: closedAt,
                closeState: closeState,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tripId,
                Value<String?> tripStopId = const Value.absent(),
                required String title,
                required String createdAt,
                Value<String?> closedAt = const Value.absent(),
                Value<String> closeState = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReturnCheckpointsCompanion.insert(
                id: id,
                tripId: tripId,
                tripStopId: tripStopId,
                title: title,
                createdAt: createdAt,
                closedAt: closedAt,
                closeState: closeState,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReturnCheckpointsTable, ReturnCheckpointEntry>(
                    table,
                  ),
                  $$ReturnCheckpointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                tripId = false,
                tripStopId = false,
                returnEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (returnEntriesRefs) db.returnEntries,
                  ],
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
                        if (tripId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tripId,
                                    referencedTable:
                                        $$ReturnCheckpointsTableReferences
                                            ._tripIdTable(db),
                                    referencedColumn:
                                        $$ReturnCheckpointsTableReferences
                                            ._tripIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (tripStopId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tripStopId,
                                    referencedTable:
                                        $$ReturnCheckpointsTableReferences
                                            ._tripStopIdTable(db),
                                    referencedColumn:
                                        $$ReturnCheckpointsTableReferences
                                            ._tripStopIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (returnEntriesRefs)
                        await $_getPrefetchedData<
                          ReturnCheckpointEntry,
                          $ReturnCheckpointsTable,
                          ReturnEntryEntry
                        >(
                          currentTable: table,
                          referencedTable: $$ReturnCheckpointsTableReferences
                              ._returnEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ReturnCheckpointsTableReferences(
                                db,
                                table,
                                p0,
                              ).returnEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.checkpointId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ReturnCheckpointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReturnCheckpointsTable,
      ReturnCheckpointEntry,
      $$ReturnCheckpointsTableFilterComposer,
      $$ReturnCheckpointsTableOrderingComposer,
      $$ReturnCheckpointsTableAnnotationComposer,
      $$ReturnCheckpointsTableCreateCompanionBuilder,
      $$ReturnCheckpointsTableUpdateCompanionBuilder,
      (ReturnCheckpointEntry, $$ReturnCheckpointsTableReferences),
      ReturnCheckpointEntry,
      PrefetchHooks Function({
        bool tripId,
        bool tripStopId,
        bool returnEntriesRefs,
      })
    >;
typedef $$ReturnEntriesTableCreateCompanionBuilder =
    ReturnEntriesCompanion Function({
      required String id,
      required String checkpointId,
      required String tripItemId,
      required String nameSnapshot,
      required int expectedQuantity,
      Value<int> returnedQuantity,
      Value<int> consumedQuantity,
      Value<int> leftQuantity,
      Value<int> lostQuantity,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$ReturnEntriesTableUpdateCompanionBuilder =
    ReturnEntriesCompanion Function({
      Value<String> id,
      Value<String> checkpointId,
      Value<String> tripItemId,
      Value<String> nameSnapshot,
      Value<int> expectedQuantity,
      Value<int> returnedQuantity,
      Value<int> consumedQuantity,
      Value<int> leftQuantity,
      Value<int> lostQuantity,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$ReturnEntriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $ReturnEntriesTable, ReturnEntryEntry> {
  $$ReturnEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ReturnCheckpointsTable _checkpointIdTable(_$AppDatabase db) => db
      .returnCheckpoints
      .createAlias('return_entries__checkpoint_id__return_checkpoints__id');

  $$ReturnCheckpointsTableProcessedTableManager get checkpointId {
    final $_column = $_itemColumn<String>('checkpoint_id')!;

    final manager = $$ReturnCheckpointsTableTableManager(
      $_db,
      $_db.returnCheckpoints,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_checkpointIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TripItemsTable _tripItemIdTable(_$AppDatabase db) =>
      db.tripItems.createAlias('return_entries__trip_item_id__trip_items__id');

  $$TripItemsTableProcessedTableManager get tripItemId {
    final $_column = $_itemColumn<String>('trip_item_id')!;

    final manager = $$TripItemsTableTableManager(
      $_db,
      $_db.tripItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReturnEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ReturnEntriesTable> {
  $$ReturnEntriesTableFilterComposer({
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

  ColumnFilters<String> get nameSnapshot => $composableBuilder(
    column: $table.nameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expectedQuantity => $composableBuilder(
    column: $table.expectedQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get returnedQuantity => $composableBuilder(
    column: $table.returnedQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get consumedQuantity => $composableBuilder(
    column: $table.consumedQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leftQuantity => $composableBuilder(
    column: $table.leftQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lostQuantity => $composableBuilder(
    column: $table.lostQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$ReturnCheckpointsTableFilterComposer get checkpointId {
    final $$ReturnCheckpointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkpointId,
      referencedTable: $db.returnCheckpoints,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReturnCheckpointsTableFilterComposer(
            $db: $db,
            $table: $db.returnCheckpoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TripItemsTableFilterComposer get tripItemId {
    final $$TripItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripItemId,
      referencedTable: $db.tripItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripItemsTableFilterComposer(
            $db: $db,
            $table: $db.tripItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReturnEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReturnEntriesTable> {
  $$ReturnEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get nameSnapshot => $composableBuilder(
    column: $table.nameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expectedQuantity => $composableBuilder(
    column: $table.expectedQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get returnedQuantity => $composableBuilder(
    column: $table.returnedQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get consumedQuantity => $composableBuilder(
    column: $table.consumedQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leftQuantity => $composableBuilder(
    column: $table.leftQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lostQuantity => $composableBuilder(
    column: $table.lostQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$ReturnCheckpointsTableOrderingComposer get checkpointId {
    final $$ReturnCheckpointsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkpointId,
      referencedTable: $db.returnCheckpoints,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReturnCheckpointsTableOrderingComposer(
            $db: $db,
            $table: $db.returnCheckpoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TripItemsTableOrderingComposer get tripItemId {
    final $$TripItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripItemId,
      referencedTable: $db.tripItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripItemsTableOrderingComposer(
            $db: $db,
            $table: $db.tripItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReturnEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReturnEntriesTable> {
  $$ReturnEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameSnapshot => $composableBuilder(
    column: $table.nameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expectedQuantity => $composableBuilder(
    column: $table.expectedQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get returnedQuantity => $composableBuilder(
    column: $table.returnedQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get consumedQuantity => $composableBuilder(
    column: $table.consumedQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get leftQuantity => $composableBuilder(
    column: $table.leftQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lostQuantity => $composableBuilder(
    column: $table.lostQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$ReturnCheckpointsTableAnnotationComposer get checkpointId {
    final $$ReturnCheckpointsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.checkpointId,
          referencedTable: $db.returnCheckpoints,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReturnCheckpointsTableAnnotationComposer(
                $db: $db,
                $table: $db.returnCheckpoints,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$TripItemsTableAnnotationComposer get tripItemId {
    final $$TripItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripItemId,
      referencedTable: $db.tripItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.tripItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReturnEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReturnEntriesTable,
          ReturnEntryEntry,
          $$ReturnEntriesTableFilterComposer,
          $$ReturnEntriesTableOrderingComposer,
          $$ReturnEntriesTableAnnotationComposer,
          $$ReturnEntriesTableCreateCompanionBuilder,
          $$ReturnEntriesTableUpdateCompanionBuilder,
          (ReturnEntryEntry, $$ReturnEntriesTableReferences),
          ReturnEntryEntry,
          PrefetchHooks Function({bool checkpointId, bool tripItemId})
        > {
  $$ReturnEntriesTableTableManager(_$AppDatabase db, $ReturnEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReturnEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReturnEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReturnEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> checkpointId = const Value.absent(),
                Value<String> tripItemId = const Value.absent(),
                Value<String> nameSnapshot = const Value.absent(),
                Value<int> expectedQuantity = const Value.absent(),
                Value<int> returnedQuantity = const Value.absent(),
                Value<int> consumedQuantity = const Value.absent(),
                Value<int> leftQuantity = const Value.absent(),
                Value<int> lostQuantity = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReturnEntriesCompanion(
                id: id,
                checkpointId: checkpointId,
                tripItemId: tripItemId,
                nameSnapshot: nameSnapshot,
                expectedQuantity: expectedQuantity,
                returnedQuantity: returnedQuantity,
                consumedQuantity: consumedQuantity,
                leftQuantity: leftQuantity,
                lostQuantity: lostQuantity,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String checkpointId,
                required String tripItemId,
                required String nameSnapshot,
                required int expectedQuantity,
                Value<int> returnedQuantity = const Value.absent(),
                Value<int> consumedQuantity = const Value.absent(),
                Value<int> leftQuantity = const Value.absent(),
                Value<int> lostQuantity = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReturnEntriesCompanion.insert(
                id: id,
                checkpointId: checkpointId,
                tripItemId: tripItemId,
                nameSnapshot: nameSnapshot,
                expectedQuantity: expectedQuantity,
                returnedQuantity: returnedQuantity,
                consumedQuantity: consumedQuantity,
                leftQuantity: leftQuantity,
                lostQuantity: lostQuantity,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReturnEntriesTable, ReturnEntryEntry>(table),
                  $$ReturnEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({checkpointId = false, tripItemId = false}) {
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
                    if (checkpointId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.checkpointId,
                                referencedTable: $$ReturnEntriesTableReferences
                                    ._checkpointIdTable(db),
                                referencedColumn: $$ReturnEntriesTableReferences
                                    ._checkpointIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (tripItemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tripItemId,
                                referencedTable: $$ReturnEntriesTableReferences
                                    ._tripItemIdTable(db),
                                referencedColumn: $$ReturnEntriesTableReferences
                                    ._tripItemIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$ReturnEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReturnEntriesTable,
      ReturnEntryEntry,
      $$ReturnEntriesTableFilterComposer,
      $$ReturnEntriesTableOrderingComposer,
      $$ReturnEntriesTableAnnotationComposer,
      $$ReturnEntriesTableCreateCompanionBuilder,
      $$ReturnEntriesTableUpdateCompanionBuilder,
      (ReturnEntryEntry, $$ReturnEntriesTableReferences),
      ReturnEntryEntry,
      PrefetchHooks Function({bool checkpointId, bool tripItemId})
    >;
typedef $$PackingTemplatesTableCreateCompanionBuilder =
    PackingTemplatesCompanion Function({
      required String id,
      required String name,
      Value<String?> notes,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$PackingTemplatesTableUpdateCompanionBuilder =
    PackingTemplatesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> notes,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

final class $$PackingTemplatesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PackingTemplatesTable,
          PackingTemplateEntry
        > {
  $$PackingTemplatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$TemplateItemsTable, List<TemplateItemEntry>>
  _templateItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.templateItems,
    aliasName: 'packing_templates__id__template_items__template_id',
  );

  $$TemplateItemsTableProcessedTableManager get templateItemsRefs {
    final manager = $$TemplateItemsTableTableManager(
      $_db,
      $_db.templateItems,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_templateItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PackingTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $PackingTemplatesTable> {
  $$PackingTemplatesTableFilterComposer({
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

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> templateItemsRefs(
    Expression<bool> Function($$TemplateItemsTableFilterComposer f) f,
  ) {
    final $$TemplateItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.templateItems,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplateItemsTableFilterComposer(
            $db: $db,
            $table: $db.templateItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PackingTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $PackingTemplatesTable> {
  $$PackingTemplatesTableOrderingComposer({
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

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PackingTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PackingTemplatesTable> {
  $$PackingTemplatesTableAnnotationComposer({
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

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> templateItemsRefs<T extends Object>(
    Expression<T> Function($$TemplateItemsTableAnnotationComposer a) f,
  ) {
    final $$TemplateItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.templateItems,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplateItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.templateItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PackingTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PackingTemplatesTable,
          PackingTemplateEntry,
          $$PackingTemplatesTableFilterComposer,
          $$PackingTemplatesTableOrderingComposer,
          $$PackingTemplatesTableAnnotationComposer,
          $$PackingTemplatesTableCreateCompanionBuilder,
          $$PackingTemplatesTableUpdateCompanionBuilder,
          (PackingTemplateEntry, $$PackingTemplatesTableReferences),
          PackingTemplateEntry,
          PrefetchHooks Function({bool templateItemsRefs})
        > {
  $$PackingTemplatesTableTableManager(
    _$AppDatabase db,
    $PackingTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PackingTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PackingTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PackingTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PackingTemplatesCompanion(
                id: id,
                name: name,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> notes = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PackingTemplatesCompanion.insert(
                id: id,
                name: name,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PackingTemplatesTable, PackingTemplateEntry>(
                    table,
                  ),
                  $$PackingTemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({templateItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (templateItemsRefs) db.templateItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (templateItemsRefs)
                    await $_getPrefetchedData<
                      PackingTemplateEntry,
                      $PackingTemplatesTable,
                      TemplateItemEntry
                    >(
                      currentTable: table,
                      referencedTable: $$PackingTemplatesTableReferences
                          ._templateItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PackingTemplatesTableReferences(
                            db,
                            table,
                            p0,
                          ).templateItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.templateId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PackingTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PackingTemplatesTable,
      PackingTemplateEntry,
      $$PackingTemplatesTableFilterComposer,
      $$PackingTemplatesTableOrderingComposer,
      $$PackingTemplatesTableAnnotationComposer,
      $$PackingTemplatesTableCreateCompanionBuilder,
      $$PackingTemplatesTableUpdateCompanionBuilder,
      (PackingTemplateEntry, $$PackingTemplatesTableReferences),
      PackingTemplateEntry,
      PrefetchHooks Function({bool templateItemsRefs})
    >;
typedef $$TemplateItemsTableCreateCompanionBuilder =
    TemplateItemsCompanion Function({
      required String id,
      required String templateId,
      required String itemId,
      Value<int> plannedQuantity,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$TemplateItemsTableUpdateCompanionBuilder =
    TemplateItemsCompanion Function({
      Value<String> id,
      Value<String> templateId,
      Value<String> itemId,
      Value<int> plannedQuantity,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$TemplateItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $TemplateItemsTable, TemplateItemEntry> {
  $$TemplateItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PackingTemplatesTable _templateIdTable(_$AppDatabase db) => db
      .packingTemplates
      .createAlias('template_items__template_id__packing_templates__id');

  $$PackingTemplatesTableProcessedTableManager get templateId {
    final $_column = $_itemColumn<String>('template_id')!;

    final manager = $$PackingTemplatesTableTableManager(
      $_db,
      $_db.packingTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ItemsTable _itemIdTable(_$AppDatabase db) =>
      db.items.createAlias('template_items__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TemplateItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TemplateItemsTable> {
  $$TemplateItemsTableFilterComposer({
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

  ColumnFilters<int> get plannedQuantity => $composableBuilder(
    column: $table.plannedQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$PackingTemplatesTableFilterComposer get templateId {
    final $$PackingTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.packingTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackingTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.packingTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }
}

class $$TemplateItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TemplateItemsTable> {
  $$TemplateItemsTableOrderingComposer({
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

  ColumnOrderings<int> get plannedQuantity => $composableBuilder(
    column: $table.plannedQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$PackingTemplatesTableOrderingComposer get templateId {
    final $$PackingTemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.packingTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackingTemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.packingTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TemplateItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemplateItemsTable> {
  $$TemplateItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get plannedQuantity => $composableBuilder(
    column: $table.plannedQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$PackingTemplatesTableAnnotationComposer get templateId {
    final $$PackingTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.packingTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackingTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.packingTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }
}

class $$TemplateItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TemplateItemsTable,
          TemplateItemEntry,
          $$TemplateItemsTableFilterComposer,
          $$TemplateItemsTableOrderingComposer,
          $$TemplateItemsTableAnnotationComposer,
          $$TemplateItemsTableCreateCompanionBuilder,
          $$TemplateItemsTableUpdateCompanionBuilder,
          (TemplateItemEntry, $$TemplateItemsTableReferences),
          TemplateItemEntry,
          PrefetchHooks Function({bool templateId, bool itemId})
        > {
  $$TemplateItemsTableTableManager(_$AppDatabase db, $TemplateItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemplateItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemplateItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemplateItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> templateId = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<int> plannedQuantity = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TemplateItemsCompanion(
                id: id,
                templateId: templateId,
                itemId: itemId,
                plannedQuantity: plannedQuantity,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String templateId,
                required String itemId,
                Value<int> plannedQuantity = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TemplateItemsCompanion.insert(
                id: id,
                templateId: templateId,
                itemId: itemId,
                plannedQuantity: plannedQuantity,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TemplateItemsTable, TemplateItemEntry>(table),
                  $$TemplateItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({templateId = false, itemId = false}) {
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
                    if (templateId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.templateId,
                                referencedTable: $$TemplateItemsTableReferences
                                    ._templateIdTable(db),
                                referencedColumn: $$TemplateItemsTableReferences
                                    ._templateIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (itemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.itemId,
                                referencedTable: $$TemplateItemsTableReferences
                                    ._itemIdTable(db),
                                referencedColumn: $$TemplateItemsTableReferences
                                    ._itemIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$TemplateItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TemplateItemsTable,
      TemplateItemEntry,
      $$TemplateItemsTableFilterComposer,
      $$TemplateItemsTableOrderingComposer,
      $$TemplateItemsTableAnnotationComposer,
      $$TemplateItemsTableCreateCompanionBuilder,
      $$TemplateItemsTableUpdateCompanionBuilder,
      (TemplateItemEntry, $$TemplateItemsTableReferences),
      TemplateItemEntry,
      PrefetchHooks Function({bool templateId, bool itemId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSettingEntry,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSettingEntry,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingEntry>,
          ),
          AppSettingEntry,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSettingEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppSettingsTable,
                    AppSettingEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSettingEntry,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSettingEntry,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingEntry>,
      ),
      AppSettingEntry,
      PrefetchHooks Function()
    >;
typedef $$DepartureManifestsTableCreateCompanionBuilder =
    DepartureManifestsCompanion Function({
      required String id,
      required String tripId,
      Value<String?> departureNotes,
      Value<bool> isDepartedWithIssues,
      Value<int> version,
      Value<String> sourceLabel,
      required String createdAt,
      Value<int> rowid,
    });
typedef $$DepartureManifestsTableUpdateCompanionBuilder =
    DepartureManifestsCompanion Function({
      Value<String> id,
      Value<String> tripId,
      Value<String?> departureNotes,
      Value<bool> isDepartedWithIssues,
      Value<int> version,
      Value<String> sourceLabel,
      Value<String> createdAt,
      Value<int> rowid,
    });

final class $$DepartureManifestsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DepartureManifestsTable,
          DepartureManifestEntry
        > {
  $$DepartureManifestsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TripsTable _tripIdTable(_$AppDatabase db) =>
      db.trips.createAlias('departure_manifests__trip_id__trips__id');

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<String>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $DepartureManifestItemsTable,
    List<DepartureManifestItemEntry>
  >
  _departureManifestItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.departureManifestItems,
        aliasName:
            'departure_manifests__id__departure_manifest_items__manifest_id',
      );

  $$DepartureManifestItemsTableProcessedTableManager
  get departureManifestItemsRefs {
    final manager = $$DepartureManifestItemsTableTableManager(
      $_db,
      $_db.departureManifestItems,
    ).filter((f) => f.manifestId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _departureManifestItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DepartureManifestsTableFilterComposer
    extends Composer<_$AppDatabase, $DepartureManifestsTable> {
  $$DepartureManifestsTableFilterComposer({
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

  ColumnFilters<String> get departureNotes => $composableBuilder(
    column: $table.departureNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDepartedWithIssues => $composableBuilder(
    column: $table.isDepartedWithIssues,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceLabel => $composableBuilder(
    column: $table.sourceLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> departureManifestItemsRefs(
    Expression<bool> Function($$DepartureManifestItemsTableFilterComposer f) f,
  ) {
    final $$DepartureManifestItemsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.departureManifestItems,
          getReferencedColumn: (t) => t.manifestId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DepartureManifestItemsTableFilterComposer(
                $db: $db,
                $table: $db.departureManifestItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DepartureManifestsTableOrderingComposer
    extends Composer<_$AppDatabase, $DepartureManifestsTable> {
  $$DepartureManifestsTableOrderingComposer({
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

  ColumnOrderings<String> get departureNotes => $composableBuilder(
    column: $table.departureNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDepartedWithIssues => $composableBuilder(
    column: $table.isDepartedWithIssues,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceLabel => $composableBuilder(
    column: $table.sourceLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DepartureManifestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DepartureManifestsTable> {
  $$DepartureManifestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get departureNotes => $composableBuilder(
    column: $table.departureNotes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDepartedWithIssues => $composableBuilder(
    column: $table.isDepartedWithIssues,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get sourceLabel => $composableBuilder(
    column: $table.sourceLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> departureManifestItemsRefs<T extends Object>(
    Expression<T> Function($$DepartureManifestItemsTableAnnotationComposer a) f,
  ) {
    final $$DepartureManifestItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.departureManifestItems,
          getReferencedColumn: (t) => t.manifestId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DepartureManifestItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.departureManifestItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DepartureManifestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DepartureManifestsTable,
          DepartureManifestEntry,
          $$DepartureManifestsTableFilterComposer,
          $$DepartureManifestsTableOrderingComposer,
          $$DepartureManifestsTableAnnotationComposer,
          $$DepartureManifestsTableCreateCompanionBuilder,
          $$DepartureManifestsTableUpdateCompanionBuilder,
          (DepartureManifestEntry, $$DepartureManifestsTableReferences),
          DepartureManifestEntry,
          PrefetchHooks Function({bool tripId, bool departureManifestItemsRefs})
        > {
  $$DepartureManifestsTableTableManager(
    _$AppDatabase db,
    $DepartureManifestsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DepartureManifestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DepartureManifestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DepartureManifestsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<String?> departureNotes = const Value.absent(),
                Value<bool> isDepartedWithIssues = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> sourceLabel = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DepartureManifestsCompanion(
                id: id,
                tripId: tripId,
                departureNotes: departureNotes,
                isDepartedWithIssues: isDepartedWithIssues,
                version: version,
                sourceLabel: sourceLabel,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tripId,
                Value<String?> departureNotes = const Value.absent(),
                Value<bool> isDepartedWithIssues = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> sourceLabel = const Value.absent(),
                required String createdAt,
                Value<int> rowid = const Value.absent(),
              }) => DepartureManifestsCompanion.insert(
                id: id,
                tripId: tripId,
                departureNotes: departureNotes,
                isDepartedWithIssues: isDepartedWithIssues,
                version: version,
                sourceLabel: sourceLabel,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DepartureManifestsTable, DepartureManifestEntry>(
                    table,
                  ),
                  $$DepartureManifestsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({tripId = false, departureManifestItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (departureManifestItemsRefs) db.departureManifestItems,
                  ],
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
                        if (tripId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tripId,
                                    referencedTable:
                                        $$DepartureManifestsTableReferences
                                            ._tripIdTable(db),
                                    referencedColumn:
                                        $$DepartureManifestsTableReferences
                                            ._tripIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (departureManifestItemsRefs)
                        await $_getPrefetchedData<
                          DepartureManifestEntry,
                          $DepartureManifestsTable,
                          DepartureManifestItemEntry
                        >(
                          currentTable: table,
                          referencedTable: $$DepartureManifestsTableReferences
                              ._departureManifestItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DepartureManifestsTableReferences(
                                db,
                                table,
                                p0,
                              ).departureManifestItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.manifestId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DepartureManifestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DepartureManifestsTable,
      DepartureManifestEntry,
      $$DepartureManifestsTableFilterComposer,
      $$DepartureManifestsTableOrderingComposer,
      $$DepartureManifestsTableAnnotationComposer,
      $$DepartureManifestsTableCreateCompanionBuilder,
      $$DepartureManifestsTableUpdateCompanionBuilder,
      (DepartureManifestEntry, $$DepartureManifestsTableReferences),
      DepartureManifestEntry,
      PrefetchHooks Function({bool tripId, bool departureManifestItemsRefs})
    >;
typedef $$DepartureManifestItemsTableCreateCompanionBuilder =
    DepartureManifestItemsCompanion Function({
      required String id,
      required String manifestId,
      Value<String?> tripItemId,
      Value<String?> itemId,
      required String itemNameSnapshot,
      Value<String> itemUnitSnapshot,
      Value<bool> isImportant,
      Value<String?> storageLocationSnapshot,
      Value<int> plannedQuantity,
      Value<int> carriedQuantity,
      Value<int> deficiencyQuantity,
      Value<String?> allocationsSnapshot,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$DepartureManifestItemsTableUpdateCompanionBuilder =
    DepartureManifestItemsCompanion Function({
      Value<String> id,
      Value<String> manifestId,
      Value<String?> tripItemId,
      Value<String?> itemId,
      Value<String> itemNameSnapshot,
      Value<String> itemUnitSnapshot,
      Value<bool> isImportant,
      Value<String?> storageLocationSnapshot,
      Value<int> plannedQuantity,
      Value<int> carriedQuantity,
      Value<int> deficiencyQuantity,
      Value<String?> allocationsSnapshot,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$DepartureManifestItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DepartureManifestItemsTable,
          DepartureManifestItemEntry
        > {
  $$DepartureManifestItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DepartureManifestsTable _manifestIdTable(_$AppDatabase db) =>
      db.departureManifests.createAlias(
        'departure_manifest_items__manifest_id__departure_manifests__id',
      );

  $$DepartureManifestsTableProcessedTableManager get manifestId {
    final $_column = $_itemColumn<String>('manifest_id')!;

    final manager = $$DepartureManifestsTableTableManager(
      $_db,
      $_db.departureManifests,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_manifestIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DepartureManifestItemsTableFilterComposer
    extends Composer<_$AppDatabase, $DepartureManifestItemsTable> {
  $$DepartureManifestItemsTableFilterComposer({
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

  ColumnFilters<String> get tripItemId => $composableBuilder(
    column: $table.tripItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemNameSnapshot => $composableBuilder(
    column: $table.itemNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemUnitSnapshot => $composableBuilder(
    column: $table.itemUnitSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isImportant => $composableBuilder(
    column: $table.isImportant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storageLocationSnapshot => $composableBuilder(
    column: $table.storageLocationSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedQuantity => $composableBuilder(
    column: $table.plannedQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get carriedQuantity => $composableBuilder(
    column: $table.carriedQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deficiencyQuantity => $composableBuilder(
    column: $table.deficiencyQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allocationsSnapshot => $composableBuilder(
    column: $table.allocationsSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$DepartureManifestsTableFilterComposer get manifestId {
    final $$DepartureManifestsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.manifestId,
      referencedTable: $db.departureManifests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartureManifestsTableFilterComposer(
            $db: $db,
            $table: $db.departureManifests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DepartureManifestItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $DepartureManifestItemsTable> {
  $$DepartureManifestItemsTableOrderingComposer({
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

  ColumnOrderings<String> get tripItemId => $composableBuilder(
    column: $table.tripItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemNameSnapshot => $composableBuilder(
    column: $table.itemNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemUnitSnapshot => $composableBuilder(
    column: $table.itemUnitSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isImportant => $composableBuilder(
    column: $table.isImportant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storageLocationSnapshot => $composableBuilder(
    column: $table.storageLocationSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedQuantity => $composableBuilder(
    column: $table.plannedQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get carriedQuantity => $composableBuilder(
    column: $table.carriedQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deficiencyQuantity => $composableBuilder(
    column: $table.deficiencyQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allocationsSnapshot => $composableBuilder(
    column: $table.allocationsSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$DepartureManifestsTableOrderingComposer get manifestId {
    final $$DepartureManifestsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.manifestId,
      referencedTable: $db.departureManifests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartureManifestsTableOrderingComposer(
            $db: $db,
            $table: $db.departureManifests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DepartureManifestItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DepartureManifestItemsTable> {
  $$DepartureManifestItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tripItemId => $composableBuilder(
    column: $table.tripItemId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get itemNameSnapshot => $composableBuilder(
    column: $table.itemNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itemUnitSnapshot => $composableBuilder(
    column: $table.itemUnitSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isImportant => $composableBuilder(
    column: $table.isImportant,
    builder: (column) => column,
  );

  GeneratedColumn<String> get storageLocationSnapshot => $composableBuilder(
    column: $table.storageLocationSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get plannedQuantity => $composableBuilder(
    column: $table.plannedQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get carriedQuantity => $composableBuilder(
    column: $table.carriedQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deficiencyQuantity => $composableBuilder(
    column: $table.deficiencyQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allocationsSnapshot => $composableBuilder(
    column: $table.allocationsSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$DepartureManifestsTableAnnotationComposer get manifestId {
    final $$DepartureManifestsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.manifestId,
          referencedTable: $db.departureManifests,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DepartureManifestsTableAnnotationComposer(
                $db: $db,
                $table: $db.departureManifests,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$DepartureManifestItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DepartureManifestItemsTable,
          DepartureManifestItemEntry,
          $$DepartureManifestItemsTableFilterComposer,
          $$DepartureManifestItemsTableOrderingComposer,
          $$DepartureManifestItemsTableAnnotationComposer,
          $$DepartureManifestItemsTableCreateCompanionBuilder,
          $$DepartureManifestItemsTableUpdateCompanionBuilder,
          (DepartureManifestItemEntry, $$DepartureManifestItemsTableReferences),
          DepartureManifestItemEntry,
          PrefetchHooks Function({bool manifestId})
        > {
  $$DepartureManifestItemsTableTableManager(
    _$AppDatabase db,
    $DepartureManifestItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DepartureManifestItemsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DepartureManifestItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DepartureManifestItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> manifestId = const Value.absent(),
                Value<String?> tripItemId = const Value.absent(),
                Value<String?> itemId = const Value.absent(),
                Value<String> itemNameSnapshot = const Value.absent(),
                Value<String> itemUnitSnapshot = const Value.absent(),
                Value<bool> isImportant = const Value.absent(),
                Value<String?> storageLocationSnapshot = const Value.absent(),
                Value<int> plannedQuantity = const Value.absent(),
                Value<int> carriedQuantity = const Value.absent(),
                Value<int> deficiencyQuantity = const Value.absent(),
                Value<String?> allocationsSnapshot = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DepartureManifestItemsCompanion(
                id: id,
                manifestId: manifestId,
                tripItemId: tripItemId,
                itemId: itemId,
                itemNameSnapshot: itemNameSnapshot,
                itemUnitSnapshot: itemUnitSnapshot,
                isImportant: isImportant,
                storageLocationSnapshot: storageLocationSnapshot,
                plannedQuantity: plannedQuantity,
                carriedQuantity: carriedQuantity,
                deficiencyQuantity: deficiencyQuantity,
                allocationsSnapshot: allocationsSnapshot,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String manifestId,
                Value<String?> tripItemId = const Value.absent(),
                Value<String?> itemId = const Value.absent(),
                required String itemNameSnapshot,
                Value<String> itemUnitSnapshot = const Value.absent(),
                Value<bool> isImportant = const Value.absent(),
                Value<String?> storageLocationSnapshot = const Value.absent(),
                Value<int> plannedQuantity = const Value.absent(),
                Value<int> carriedQuantity = const Value.absent(),
                Value<int> deficiencyQuantity = const Value.absent(),
                Value<String?> allocationsSnapshot = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DepartureManifestItemsCompanion.insert(
                id: id,
                manifestId: manifestId,
                tripItemId: tripItemId,
                itemId: itemId,
                itemNameSnapshot: itemNameSnapshot,
                itemUnitSnapshot: itemUnitSnapshot,
                isImportant: isImportant,
                storageLocationSnapshot: storageLocationSnapshot,
                plannedQuantity: plannedQuantity,
                carriedQuantity: carriedQuantity,
                deficiencyQuantity: deficiencyQuantity,
                allocationsSnapshot: allocationsSnapshot,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $DepartureManifestItemsTable,
                    DepartureManifestItemEntry
                  >(table),
                  $$DepartureManifestItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({manifestId = false}) {
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
                    if (manifestId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.manifestId,
                                referencedTable:
                                    $$DepartureManifestItemsTableReferences
                                        ._manifestIdTable(db),
                                referencedColumn:
                                    $$DepartureManifestItemsTableReferences
                                        ._manifestIdTable(db)
                                        .id,
                              )
                              as T;
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

typedef $$DepartureManifestItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DepartureManifestItemsTable,
      DepartureManifestItemEntry,
      $$DepartureManifestItemsTableFilterComposer,
      $$DepartureManifestItemsTableOrderingComposer,
      $$DepartureManifestItemsTableAnnotationComposer,
      $$DepartureManifestItemsTableCreateCompanionBuilder,
      $$DepartureManifestItemsTableUpdateCompanionBuilder,
      (DepartureManifestItemEntry, $$DepartureManifestItemsTableReferences),
      DepartureManifestItemEntry,
      PrefetchHooks Function({bool manifestId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StorageLocationsTableTableManager get storageLocations =>
      $$StorageLocationsTableTableManager(_db, _db.storageLocations);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$AssetsTableTableManager get assets =>
      $$AssetsTableTableManager(_db, _db.assets);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$ItemPhotosTableTableManager get itemPhotos =>
      $$ItemPhotosTableTableManager(_db, _db.itemPhotos);
  $$TripsTableTableManager get trips =>
      $$TripsTableTableManager(_db, _db.trips);
  $$TripStopsTableTableManager get tripStops =>
      $$TripStopsTableTableManager(_db, _db.tripStops);
  $$TripBagsTableTableManager get tripBags =>
      $$TripBagsTableTableManager(_db, _db.tripBags);
  $$BagCompartmentsTableTableManager get bagCompartments =>
      $$BagCompartmentsTableTableManager(_db, _db.bagCompartments);
  $$TripItemsTableTableManager get tripItems =>
      $$TripItemsTableTableManager(_db, _db.tripItems);
  $$ItemAllocationsTableTableManager get itemAllocations =>
      $$ItemAllocationsTableTableManager(_db, _db.itemAllocations);
  $$ScheduleEventsTableTableManager get scheduleEvents =>
      $$ScheduleEventsTableTableManager(_db, _db.scheduleEvents);
  $$TicketsTableTableManager get tickets =>
      $$TicketsTableTableManager(_db, _db.tickets);
  $$TicketAttachmentsTableTableManager get ticketAttachments =>
      $$TicketAttachmentsTableTableManager(_db, _db.ticketAttachments);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$ReturnCheckpointsTableTableManager get returnCheckpoints =>
      $$ReturnCheckpointsTableTableManager(_db, _db.returnCheckpoints);
  $$ReturnEntriesTableTableManager get returnEntries =>
      $$ReturnEntriesTableTableManager(_db, _db.returnEntries);
  $$PackingTemplatesTableTableManager get packingTemplates =>
      $$PackingTemplatesTableTableManager(_db, _db.packingTemplates);
  $$TemplateItemsTableTableManager get templateItems =>
      $$TemplateItemsTableTableManager(_db, _db.templateItems);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$DepartureManifestsTableTableManager get departureManifests =>
      $$DepartureManifestsTableTableManager(_db, _db.departureManifests);
  $$DepartureManifestItemsTableTableManager get departureManifestItems =>
      $$DepartureManifestItemsTableTableManager(
        _db,
        _db.departureManifestItems,
      );
}
