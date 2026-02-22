// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $WorkoutTypesTable extends WorkoutTypes
    with TableInfo<$WorkoutTypesTable, WorkoutType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('fitness_center'));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, name, icon, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_types';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutType> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutType(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $WorkoutTypesTable createAlias(String alias) {
    return $WorkoutTypesTable(attachedDatabase, alias);
  }
}

class WorkoutType extends DataClass implements Insertable<WorkoutType> {
  final int id;
  final String name;
  final String icon;
  final int sortOrder;
  const WorkoutType(
      {required this.id,
      required this.name,
      required this.icon,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  WorkoutTypesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutTypesCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      sortOrder: Value(sortOrder),
    );
  }

  factory WorkoutType.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutType(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  WorkoutType copyWith({int? id, String? name, String? icon, int? sortOrder}) =>
      WorkoutType(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  WorkoutType copyWithCompanion(WorkoutTypesCompanion data) {
    return WorkoutType(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutType(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutType &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.sortOrder == this.sortOrder);
}

class WorkoutTypesCompanion extends UpdateCompanion<WorkoutType> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<int> sortOrder;
  const WorkoutTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  WorkoutTypesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : name = Value(name);
  static Insertable<WorkoutType> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  WorkoutTypesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? icon,
      Value<int>? sortOrder}) {
    return WorkoutTypesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _typeIdMeta = const VerificationMeta('typeId');
  @override
  late final GeneratedColumn<int> typeId = GeneratedColumn<int>(
      'type_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES workout_types (id)'));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _defaultSetsMeta =
      const VerificationMeta('defaultSets');
  @override
  late final GeneratedColumn<int> defaultSets = GeneratedColumn<int>(
      'default_sets', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _defaultRepsMeta =
      const VerificationMeta('defaultReps');
  @override
  late final GeneratedColumn<int> defaultReps = GeneratedColumn<int>(
      'default_reps', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(10));
  static const VerificationMeta _defaultWeightMeta =
      const VerificationMeta('defaultWeight');
  @override
  late final GeneratedColumn<double> defaultWeight = GeneratedColumn<double>(
      'default_weight', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _defaultDurationMeta =
      const VerificationMeta('defaultDuration');
  @override
  late final GeneratedColumn<int> defaultDuration = GeneratedColumn<int>(
      'default_duration', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        typeId,
        category,
        defaultSets,
        defaultReps,
        defaultWeight,
        defaultDuration,
        note,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(Insertable<Exercise> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type_id')) {
      context.handle(_typeIdMeta,
          typeId.isAcceptableOrUnknown(data['type_id']!, _typeIdMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('default_sets')) {
      context.handle(
          _defaultSetsMeta,
          defaultSets.isAcceptableOrUnknown(
              data['default_sets']!, _defaultSetsMeta));
    }
    if (data.containsKey('default_reps')) {
      context.handle(
          _defaultRepsMeta,
          defaultReps.isAcceptableOrUnknown(
              data['default_reps']!, _defaultRepsMeta));
    }
    if (data.containsKey('default_weight')) {
      context.handle(
          _defaultWeightMeta,
          defaultWeight.isAcceptableOrUnknown(
              data['default_weight']!, _defaultWeightMeta));
    }
    if (data.containsKey('default_duration')) {
      context.handle(
          _defaultDurationMeta,
          defaultDuration.isAcceptableOrUnknown(
              data['default_duration']!, _defaultDurationMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      typeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type_id']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      defaultSets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}default_sets'])!,
      defaultReps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}default_reps'])!,
      defaultWeight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}default_weight']),
      defaultDuration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}default_duration']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final String id;
  final String name;
  final int? typeId;
  final String? category;
  final int defaultSets;
  final int defaultReps;
  final double? defaultWeight;
  final int? defaultDuration;
  final String? note;
  final DateTime createdAt;
  const Exercise(
      {required this.id,
      required this.name,
      this.typeId,
      this.category,
      required this.defaultSets,
      required this.defaultReps,
      this.defaultWeight,
      this.defaultDuration,
      this.note,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || typeId != null) {
      map['type_id'] = Variable<int>(typeId);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['default_sets'] = Variable<int>(defaultSets);
    map['default_reps'] = Variable<int>(defaultReps);
    if (!nullToAbsent || defaultWeight != null) {
      map['default_weight'] = Variable<double>(defaultWeight);
    }
    if (!nullToAbsent || defaultDuration != null) {
      map['default_duration'] = Variable<int>(defaultDuration);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      typeId:
          typeId == null && nullToAbsent ? const Value.absent() : Value(typeId),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      defaultSets: Value(defaultSets),
      defaultReps: Value(defaultReps),
      defaultWeight: defaultWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultWeight),
      defaultDuration: defaultDuration == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultDuration),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory Exercise.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      typeId: serializer.fromJson<int?>(json['typeId']),
      category: serializer.fromJson<String?>(json['category']),
      defaultSets: serializer.fromJson<int>(json['defaultSets']),
      defaultReps: serializer.fromJson<int>(json['defaultReps']),
      defaultWeight: serializer.fromJson<double?>(json['defaultWeight']),
      defaultDuration: serializer.fromJson<int?>(json['defaultDuration']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'typeId': serializer.toJson<int?>(typeId),
      'category': serializer.toJson<String?>(category),
      'defaultSets': serializer.toJson<int>(defaultSets),
      'defaultReps': serializer.toJson<int>(defaultReps),
      'defaultWeight': serializer.toJson<double?>(defaultWeight),
      'defaultDuration': serializer.toJson<int?>(defaultDuration),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Exercise copyWith(
          {String? id,
          String? name,
          Value<int?> typeId = const Value.absent(),
          Value<String?> category = const Value.absent(),
          int? defaultSets,
          int? defaultReps,
          Value<double?> defaultWeight = const Value.absent(),
          Value<int?> defaultDuration = const Value.absent(),
          Value<String?> note = const Value.absent(),
          DateTime? createdAt}) =>
      Exercise(
        id: id ?? this.id,
        name: name ?? this.name,
        typeId: typeId.present ? typeId.value : this.typeId,
        category: category.present ? category.value : this.category,
        defaultSets: defaultSets ?? this.defaultSets,
        defaultReps: defaultReps ?? this.defaultReps,
        defaultWeight:
            defaultWeight.present ? defaultWeight.value : this.defaultWeight,
        defaultDuration: defaultDuration.present
            ? defaultDuration.value
            : this.defaultDuration,
        note: note.present ? note.value : this.note,
        createdAt: createdAt ?? this.createdAt,
      );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      typeId: data.typeId.present ? data.typeId.value : this.typeId,
      category: data.category.present ? data.category.value : this.category,
      defaultSets:
          data.defaultSets.present ? data.defaultSets.value : this.defaultSets,
      defaultReps:
          data.defaultReps.present ? data.defaultReps.value : this.defaultReps,
      defaultWeight: data.defaultWeight.present
          ? data.defaultWeight.value
          : this.defaultWeight,
      defaultDuration: data.defaultDuration.present
          ? data.defaultDuration.value
          : this.defaultDuration,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('typeId: $typeId, ')
          ..write('category: $category, ')
          ..write('defaultSets: $defaultSets, ')
          ..write('defaultReps: $defaultReps, ')
          ..write('defaultWeight: $defaultWeight, ')
          ..write('defaultDuration: $defaultDuration, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, typeId, category, defaultSets,
      defaultReps, defaultWeight, defaultDuration, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.typeId == this.typeId &&
          other.category == this.category &&
          other.defaultSets == this.defaultSets &&
          other.defaultReps == this.defaultReps &&
          other.defaultWeight == this.defaultWeight &&
          other.defaultDuration == this.defaultDuration &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<String> id;
  final Value<String> name;
  final Value<int?> typeId;
  final Value<String?> category;
  final Value<int> defaultSets;
  final Value<int> defaultReps;
  final Value<double?> defaultWeight;
  final Value<int?> defaultDuration;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.typeId = const Value.absent(),
    this.category = const Value.absent(),
    this.defaultSets = const Value.absent(),
    this.defaultReps = const Value.absent(),
    this.defaultWeight = const Value.absent(),
    this.defaultDuration = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExercisesCompanion.insert({
    required String id,
    required String name,
    this.typeId = const Value.absent(),
    this.category = const Value.absent(),
    this.defaultSets = const Value.absent(),
    this.defaultReps = const Value.absent(),
    this.defaultWeight = const Value.absent(),
    this.defaultDuration = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt);
  static Insertable<Exercise> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? typeId,
    Expression<String>? category,
    Expression<int>? defaultSets,
    Expression<int>? defaultReps,
    Expression<double>? defaultWeight,
    Expression<int>? defaultDuration,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (typeId != null) 'type_id': typeId,
      if (category != null) 'category': category,
      if (defaultSets != null) 'default_sets': defaultSets,
      if (defaultReps != null) 'default_reps': defaultReps,
      if (defaultWeight != null) 'default_weight': defaultWeight,
      if (defaultDuration != null) 'default_duration': defaultDuration,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExercisesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int?>? typeId,
      Value<String?>? category,
      Value<int>? defaultSets,
      Value<int>? defaultReps,
      Value<double?>? defaultWeight,
      Value<int?>? defaultDuration,
      Value<String?>? note,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      typeId: typeId ?? this.typeId,
      category: category ?? this.category,
      defaultSets: defaultSets ?? this.defaultSets,
      defaultReps: defaultReps ?? this.defaultReps,
      defaultWeight: defaultWeight ?? this.defaultWeight,
      defaultDuration: defaultDuration ?? this.defaultDuration,
      note: note ?? this.note,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (typeId.present) {
      map['type_id'] = Variable<int>(typeId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (defaultSets.present) {
      map['default_sets'] = Variable<int>(defaultSets.value);
    }
    if (defaultReps.present) {
      map['default_reps'] = Variable<int>(defaultReps.value);
    }
    if (defaultWeight.present) {
      map['default_weight'] = Variable<double>(defaultWeight.value);
    }
    if (defaultDuration.present) {
      map['default_duration'] = Variable<int>(defaultDuration.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('typeId: $typeId, ')
          ..write('category: $category, ')
          ..write('defaultSets: $defaultSets, ')
          ..write('defaultReps: $defaultReps, ')
          ..write('defaultWeight: $defaultWeight, ')
          ..write('defaultDuration: $defaultDuration, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeIdMeta = const VerificationMeta('typeId');
  @override
  late final GeneratedColumn<int> typeId = GeneratedColumn<int>(
      'type_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES workout_types (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('completed'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, typeId, date, note, status, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type_id')) {
      context.handle(_typeIdMeta,
          typeId.isAcceptableOrUnknown(data['type_id']!, _typeIdMeta));
    } else if (isInserting) {
      context.missing(_typeIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      typeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSession extends DataClass implements Insertable<WorkoutSession> {
  final String id;
  final int typeId;
  final DateTime date;
  final String? note;
  final String status;
  final DateTime createdAt;
  const WorkoutSession(
      {required this.id,
      required this.typeId,
      required this.date,
      this.note,
      required this.status,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type_id'] = Variable<int>(typeId);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      typeId: Value(typeId),
      date: Value(date),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSession(
      id: serializer.fromJson<String>(json['id']),
      typeId: serializer.fromJson<int>(json['typeId']),
      date: serializer.fromJson<DateTime>(json['date']),
      note: serializer.fromJson<String?>(json['note']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'typeId': serializer.toJson<int>(typeId),
      'date': serializer.toJson<DateTime>(date),
      'note': serializer.toJson<String?>(note),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WorkoutSession copyWith(
          {String? id,
          int? typeId,
          DateTime? date,
          Value<String?> note = const Value.absent(),
          String? status,
          DateTime? createdAt}) =>
      WorkoutSession(
        id: id ?? this.id,
        typeId: typeId ?? this.typeId,
        date: date ?? this.date,
        note: note.present ? note.value : this.note,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
  WorkoutSession copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSession(
      id: data.id.present ? data.id.value : this.id,
      typeId: data.typeId.present ? data.typeId.value : this.typeId,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSession(')
          ..write('id: $id, ')
          ..write('typeId: $typeId, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, typeId, date, note, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSession &&
          other.id == this.id &&
          other.typeId == this.typeId &&
          other.date == this.date &&
          other.note == this.note &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSession> {
  final Value<String> id;
  final Value<int> typeId;
  final Value<DateTime> date;
  final Value<String?> note;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.typeId = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    required String id,
    required int typeId,
    required DateTime date,
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        typeId = Value(typeId),
        date = Value(date),
        createdAt = Value(createdAt);
  static Insertable<WorkoutSession> custom({
    Expression<String>? id,
    Expression<int>? typeId,
    Expression<DateTime>? date,
    Expression<String>? note,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (typeId != null) 'type_id': typeId,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSessionsCompanion copyWith(
      {Value<String>? id,
      Value<int>? typeId,
      Value<DateTime>? date,
      Value<String?>? note,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      typeId: typeId ?? this.typeId,
      date: date ?? this.date,
      note: note ?? this.note,
      status: status ?? this.status,
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
    if (typeId.present) {
      map['type_id'] = Variable<int>(typeId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('typeId: $typeId, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetsTable extends WorkoutSets
    with TableInfo<$WorkoutSetsTable, WorkoutSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workout_sessions (id)'));
  static const VerificationMeta _exerciseIdMeta =
      const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
      'exercise_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES exercises (id)'));
  static const VerificationMeta _setNumberMeta =
      const VerificationMeta('setNumber');
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
      'set_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<String> weight = GeneratedColumn<String>(
      'weight', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
      'reps', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, sessionId, exerciseId, setNumber, weight, reps, isCompleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sets';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutSet> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
          _exerciseIdMeta,
          exerciseId.isAcceptableOrUnknown(
              data['exercise_id']!, _exerciseIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('set_number')) {
      context.handle(_setNumberMeta,
          setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta));
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSet(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id'])!,
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercise_id'])!,
      setNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}set_number'])!,
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weight'])!,
      reps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reps'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
    );
  }

  @override
  $WorkoutSetsTable createAlias(String alias) {
    return $WorkoutSetsTable(attachedDatabase, alias);
  }
}

class WorkoutSet extends DataClass implements Insertable<WorkoutSet> {
  final String id;
  final String sessionId;
  final String exerciseId;
  final int setNumber;
  final String weight;
  final int reps;
  final bool isCompleted;
  const WorkoutSet(
      {required this.id,
      required this.sessionId,
      required this.exerciseId,
      required this.setNumber,
      required this.weight,
      required this.reps,
      required this.isCompleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['set_number'] = Variable<int>(setNumber);
    map['weight'] = Variable<String>(weight);
    map['reps'] = Variable<int>(reps);
    map['is_completed'] = Variable<bool>(isCompleted);
    return map;
  }

  WorkoutSetsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      exerciseId: Value(exerciseId),
      setNumber: Value(setNumber),
      weight: Value(weight),
      reps: Value(reps),
      isCompleted: Value(isCompleted),
    );
  }

  factory WorkoutSet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSet(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      weight: serializer.fromJson<String>(json['weight']),
      reps: serializer.fromJson<int>(json['reps']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'setNumber': serializer.toJson<int>(setNumber),
      'weight': serializer.toJson<String>(weight),
      'reps': serializer.toJson<int>(reps),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  WorkoutSet copyWith(
          {String? id,
          String? sessionId,
          String? exerciseId,
          int? setNumber,
          String? weight,
          int? reps,
          bool? isCompleted}) =>
      WorkoutSet(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        exerciseId: exerciseId ?? this.exerciseId,
        setNumber: setNumber ?? this.setNumber,
        weight: weight ?? this.weight,
        reps: reps ?? this.reps,
        isCompleted: isCompleted ?? this.isCompleted,
      );
  WorkoutSet copyWithCompanion(WorkoutSetsCompanion data) {
    return WorkoutSet(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      weight: data.weight.present ? data.weight.value : this.weight,
      reps: data.reps.present ? data.reps.value : this.reps,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSet(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, sessionId, exerciseId, setNumber, weight, reps, isCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSet &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exerciseId == this.exerciseId &&
          other.setNumber == this.setNumber &&
          other.weight == this.weight &&
          other.reps == this.reps &&
          other.isCompleted == this.isCompleted);
}

class WorkoutSetsCompanion extends UpdateCompanion<WorkoutSet> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> exerciseId;
  final Value<int> setNumber;
  final Value<String> weight;
  final Value<int> reps;
  final Value<bool> isCompleted;
  final Value<int> rowid;
  const WorkoutSetsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.weight = const Value.absent(),
    this.reps = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSetsCompanion.insert({
    required String id,
    required String sessionId,
    required String exerciseId,
    required int setNumber,
    this.weight = const Value.absent(),
    this.reps = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sessionId = Value(sessionId),
        exerciseId = Value(exerciseId),
        setNumber = Value(setNumber);
  static Insertable<WorkoutSet> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? exerciseId,
    Expression<int>? setNumber,
    Expression<String>? weight,
    Expression<int>? reps,
    Expression<bool>? isCompleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (setNumber != null) 'set_number': setNumber,
      if (weight != null) 'weight': weight,
      if (reps != null) 'reps': reps,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSetsCompanion copyWith(
      {Value<String>? id,
      Value<String>? sessionId,
      Value<String>? exerciseId,
      Value<int>? setNumber,
      Value<String>? weight,
      Value<int>? reps,
      Value<bool>? isCompleted,
      Value<int>? rowid}) {
    return WorkoutSetsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      setNumber: setNumber ?? this.setNumber,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      isCompleted: isCompleted ?? this.isCompleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (weight.present) {
      map['weight'] = Variable<String>(weight.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutPlansTable extends WorkoutPlans
    with TableInfo<$WorkoutPlansTable, WorkoutPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _cycleDaysMeta =
      const VerificationMeta('cycleDays');
  @override
  late final GeneratedColumn<int> cycleDays = GeneratedColumn<int>(
      'cycle_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, cycleDays, isActive, startDate, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_plans';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutPlan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('cycle_days')) {
      context.handle(_cycleDaysMeta,
          cycleDays.isAcceptableOrUnknown(data['cycle_days']!, _cycleDaysMeta));
    } else if (isInserting) {
      context.missing(_cycleDaysMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutPlan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      cycleDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cycle_days'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $WorkoutPlansTable createAlias(String alias) {
    return $WorkoutPlansTable(attachedDatabase, alias);
  }
}

class WorkoutPlan extends DataClass implements Insertable<WorkoutPlan> {
  final String id;
  final String name;
  final int cycleDays;
  final bool isActive;
  final DateTime startDate;
  final DateTime createdAt;
  const WorkoutPlan(
      {required this.id,
      required this.name,
      required this.cycleDays,
      required this.isActive,
      required this.startDate,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['cycle_days'] = Variable<int>(cycleDays);
    map['is_active'] = Variable<bool>(isActive);
    map['start_date'] = Variable<DateTime>(startDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WorkoutPlansCompanion toCompanion(bool nullToAbsent) {
    return WorkoutPlansCompanion(
      id: Value(id),
      name: Value(name),
      cycleDays: Value(cycleDays),
      isActive: Value(isActive),
      startDate: Value(startDate),
      createdAt: Value(createdAt),
    );
  }

  factory WorkoutPlan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutPlan(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      cycleDays: serializer.fromJson<int>(json['cycleDays']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'cycleDays': serializer.toJson<int>(cycleDays),
      'isActive': serializer.toJson<bool>(isActive),
      'startDate': serializer.toJson<DateTime>(startDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WorkoutPlan copyWith(
          {String? id,
          String? name,
          int? cycleDays,
          bool? isActive,
          DateTime? startDate,
          DateTime? createdAt}) =>
      WorkoutPlan(
        id: id ?? this.id,
        name: name ?? this.name,
        cycleDays: cycleDays ?? this.cycleDays,
        isActive: isActive ?? this.isActive,
        startDate: startDate ?? this.startDate,
        createdAt: createdAt ?? this.createdAt,
      );
  WorkoutPlan copyWithCompanion(WorkoutPlansCompanion data) {
    return WorkoutPlan(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      cycleDays: data.cycleDays.present ? data.cycleDays.value : this.cycleDays,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlan(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('cycleDays: $cycleDays, ')
          ..write('isActive: $isActive, ')
          ..write('startDate: $startDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, cycleDays, isActive, startDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutPlan &&
          other.id == this.id &&
          other.name == this.name &&
          other.cycleDays == this.cycleDays &&
          other.isActive == this.isActive &&
          other.startDate == this.startDate &&
          other.createdAt == this.createdAt);
}

class WorkoutPlansCompanion extends UpdateCompanion<WorkoutPlan> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> cycleDays;
  final Value<bool> isActive;
  final Value<DateTime> startDate;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const WorkoutPlansCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.cycleDays = const Value.absent(),
    this.isActive = const Value.absent(),
    this.startDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutPlansCompanion.insert({
    required String id,
    required String name,
    required int cycleDays,
    this.isActive = const Value.absent(),
    required DateTime startDate,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        cycleDays = Value(cycleDays),
        startDate = Value(startDate),
        createdAt = Value(createdAt);
  static Insertable<WorkoutPlan> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? cycleDays,
    Expression<bool>? isActive,
    Expression<DateTime>? startDate,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (cycleDays != null) 'cycle_days': cycleDays,
      if (isActive != null) 'is_active': isActive,
      if (startDate != null) 'start_date': startDate,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutPlansCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? cycleDays,
      Value<bool>? isActive,
      Value<DateTime>? startDate,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return WorkoutPlansCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      cycleDays: cycleDays ?? this.cycleDays,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (cycleDays.present) {
      map['cycle_days'] = Variable<int>(cycleDays.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlansCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('cycleDays: $cycleDays, ')
          ..write('isActive: $isActive, ')
          ..write('startDate: $startDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlanDaysTable extends PlanDays with TableInfo<$PlanDaysTable, PlanDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
      'plan_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dayIndexMeta =
      const VerificationMeta('dayIndex');
  @override
  late final GeneratedColumn<int> dayIndex = GeneratedColumn<int>(
      'day_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isRestDayMeta =
      const VerificationMeta('isRestDay');
  @override
  late final GeneratedColumn<bool> isRestDay = GeneratedColumn<bool>(
      'is_rest_day', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_rest_day" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, planId, dayIndex, isRestDay, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_days';
  @override
  VerificationContext validateIntegrity(Insertable<PlanDay> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(_planIdMeta,
          planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta));
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('day_index')) {
      context.handle(_dayIndexMeta,
          dayIndex.isAcceptableOrUnknown(data['day_index']!, _dayIndexMeta));
    } else if (isInserting) {
      context.missing(_dayIndexMeta);
    }
    if (data.containsKey('is_rest_day')) {
      context.handle(
          _isRestDayMeta,
          isRestDay.isAcceptableOrUnknown(
              data['is_rest_day']!, _isRestDayMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanDay(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      planId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plan_id'])!,
      dayIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day_index'])!,
      isRestDay: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_rest_day'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $PlanDaysTable createAlias(String alias) {
    return $PlanDaysTable(attachedDatabase, alias);
  }
}

class PlanDay extends DataClass implements Insertable<PlanDay> {
  final String id;
  final String planId;
  final int dayIndex;
  final bool isRestDay;
  final String? note;
  const PlanDay(
      {required this.id,
      required this.planId,
      required this.dayIndex,
      required this.isRestDay,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['plan_id'] = Variable<String>(planId);
    map['day_index'] = Variable<int>(dayIndex);
    map['is_rest_day'] = Variable<bool>(isRestDay);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  PlanDaysCompanion toCompanion(bool nullToAbsent) {
    return PlanDaysCompanion(
      id: Value(id),
      planId: Value(planId),
      dayIndex: Value(dayIndex),
      isRestDay: Value(isRestDay),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory PlanDay.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanDay(
      id: serializer.fromJson<String>(json['id']),
      planId: serializer.fromJson<String>(json['planId']),
      dayIndex: serializer.fromJson<int>(json['dayIndex']),
      isRestDay: serializer.fromJson<bool>(json['isRestDay']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'planId': serializer.toJson<String>(planId),
      'dayIndex': serializer.toJson<int>(dayIndex),
      'isRestDay': serializer.toJson<bool>(isRestDay),
      'note': serializer.toJson<String?>(note),
    };
  }

  PlanDay copyWith(
          {String? id,
          String? planId,
          int? dayIndex,
          bool? isRestDay,
          Value<String?> note = const Value.absent()}) =>
      PlanDay(
        id: id ?? this.id,
        planId: planId ?? this.planId,
        dayIndex: dayIndex ?? this.dayIndex,
        isRestDay: isRestDay ?? this.isRestDay,
        note: note.present ? note.value : this.note,
      );
  PlanDay copyWithCompanion(PlanDaysCompanion data) {
    return PlanDay(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      dayIndex: data.dayIndex.present ? data.dayIndex.value : this.dayIndex,
      isRestDay: data.isRestDay.present ? data.isRestDay.value : this.isRestDay,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanDay(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('isRestDay: $isRestDay, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, planId, dayIndex, isRestDay, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanDay &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.dayIndex == this.dayIndex &&
          other.isRestDay == this.isRestDay &&
          other.note == this.note);
}

class PlanDaysCompanion extends UpdateCompanion<PlanDay> {
  final Value<String> id;
  final Value<String> planId;
  final Value<int> dayIndex;
  final Value<bool> isRestDay;
  final Value<String?> note;
  final Value<int> rowid;
  const PlanDaysCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.dayIndex = const Value.absent(),
    this.isRestDay = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlanDaysCompanion.insert({
    required String id,
    required String planId,
    required int dayIndex,
    this.isRestDay = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        planId = Value(planId),
        dayIndex = Value(dayIndex);
  static Insertable<PlanDay> custom({
    Expression<String>? id,
    Expression<String>? planId,
    Expression<int>? dayIndex,
    Expression<bool>? isRestDay,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (dayIndex != null) 'day_index': dayIndex,
      if (isRestDay != null) 'is_rest_day': isRestDay,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlanDaysCompanion copyWith(
      {Value<String>? id,
      Value<String>? planId,
      Value<int>? dayIndex,
      Value<bool>? isRestDay,
      Value<String?>? note,
      Value<int>? rowid}) {
    return PlanDaysCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      dayIndex: dayIndex ?? this.dayIndex,
      isRestDay: isRestDay ?? this.isRestDay,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (dayIndex.present) {
      map['day_index'] = Variable<int>(dayIndex.value);
    }
    if (isRestDay.present) {
      map['is_rest_day'] = Variable<bool>(isRestDay.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanDaysCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('isRestDay: $isRestDay, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DayExercisesTable extends DayExercises
    with TableInfo<$DayExercisesTable, DayExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _planDayIdMeta =
      const VerificationMeta('planDayId');
  @override
  late final GeneratedColumn<String> planDayId = GeneratedColumn<String>(
      'plan_day_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _exerciseIdMeta =
      const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
      'exercise_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _targetSetsMeta =
      const VerificationMeta('targetSets');
  @override
  late final GeneratedColumn<int> targetSets = GeneratedColumn<int>(
      'target_sets', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _targetRepsMeta =
      const VerificationMeta('targetReps');
  @override
  late final GeneratedColumn<int> targetReps = GeneratedColumn<int>(
      'target_reps', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _targetWeightMeta =
      const VerificationMeta('targetWeight');
  @override
  late final GeneratedColumn<double> targetWeight = GeneratedColumn<double>(
      'target_weight', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        planDayId,
        exerciseId,
        orderIndex,
        targetSets,
        targetReps,
        targetWeight
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_exercises';
  @override
  VerificationContext validateIntegrity(Insertable<DayExercise> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('plan_day_id')) {
      context.handle(
          _planDayIdMeta,
          planDayId.isAcceptableOrUnknown(
              data['plan_day_id']!, _planDayIdMeta));
    } else if (isInserting) {
      context.missing(_planDayIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
          _exerciseIdMeta,
          exerciseId.isAcceptableOrUnknown(
              data['exercise_id']!, _exerciseIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('target_sets')) {
      context.handle(
          _targetSetsMeta,
          targetSets.isAcceptableOrUnknown(
              data['target_sets']!, _targetSetsMeta));
    } else if (isInserting) {
      context.missing(_targetSetsMeta);
    }
    if (data.containsKey('target_reps')) {
      context.handle(
          _targetRepsMeta,
          targetReps.isAcceptableOrUnknown(
              data['target_reps']!, _targetRepsMeta));
    } else if (isInserting) {
      context.missing(_targetRepsMeta);
    }
    if (data.containsKey('target_weight')) {
      context.handle(
          _targetWeightMeta,
          targetWeight.isAcceptableOrUnknown(
              data['target_weight']!, _targetWeightMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DayExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayExercise(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      planDayId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plan_day_id'])!,
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercise_id'])!,
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
      targetSets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_sets'])!,
      targetReps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_reps'])!,
      targetWeight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}target_weight']),
    );
  }

  @override
  $DayExercisesTable createAlias(String alias) {
    return $DayExercisesTable(attachedDatabase, alias);
  }
}

class DayExercise extends DataClass implements Insertable<DayExercise> {
  final String id;
  final String planDayId;
  final String exerciseId;
  final int orderIndex;
  final int targetSets;
  final int targetReps;
  final double? targetWeight;
  const DayExercise(
      {required this.id,
      required this.planDayId,
      required this.exerciseId,
      required this.orderIndex,
      required this.targetSets,
      required this.targetReps,
      this.targetWeight});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['plan_day_id'] = Variable<String>(planDayId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['order_index'] = Variable<int>(orderIndex);
    map['target_sets'] = Variable<int>(targetSets);
    map['target_reps'] = Variable<int>(targetReps);
    if (!nullToAbsent || targetWeight != null) {
      map['target_weight'] = Variable<double>(targetWeight);
    }
    return map;
  }

  DayExercisesCompanion toCompanion(bool nullToAbsent) {
    return DayExercisesCompanion(
      id: Value(id),
      planDayId: Value(planDayId),
      exerciseId: Value(exerciseId),
      orderIndex: Value(orderIndex),
      targetSets: Value(targetSets),
      targetReps: Value(targetReps),
      targetWeight: targetWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(targetWeight),
    );
  }

  factory DayExercise.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayExercise(
      id: serializer.fromJson<String>(json['id']),
      planDayId: serializer.fromJson<String>(json['planDayId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      targetSets: serializer.fromJson<int>(json['targetSets']),
      targetReps: serializer.fromJson<int>(json['targetReps']),
      targetWeight: serializer.fromJson<double?>(json['targetWeight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'planDayId': serializer.toJson<String>(planDayId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'targetSets': serializer.toJson<int>(targetSets),
      'targetReps': serializer.toJson<int>(targetReps),
      'targetWeight': serializer.toJson<double?>(targetWeight),
    };
  }

  DayExercise copyWith(
          {String? id,
          String? planDayId,
          String? exerciseId,
          int? orderIndex,
          int? targetSets,
          int? targetReps,
          Value<double?> targetWeight = const Value.absent()}) =>
      DayExercise(
        id: id ?? this.id,
        planDayId: planDayId ?? this.planDayId,
        exerciseId: exerciseId ?? this.exerciseId,
        orderIndex: orderIndex ?? this.orderIndex,
        targetSets: targetSets ?? this.targetSets,
        targetReps: targetReps ?? this.targetReps,
        targetWeight:
            targetWeight.present ? targetWeight.value : this.targetWeight,
      );
  DayExercise copyWithCompanion(DayExercisesCompanion data) {
    return DayExercise(
      id: data.id.present ? data.id.value : this.id,
      planDayId: data.planDayId.present ? data.planDayId.value : this.planDayId,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
      targetSets:
          data.targetSets.present ? data.targetSets.value : this.targetSets,
      targetReps:
          data.targetReps.present ? data.targetReps.value : this.targetReps,
      targetWeight: data.targetWeight.present
          ? data.targetWeight.value
          : this.targetWeight,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayExercise(')
          ..write('id: $id, ')
          ..write('planDayId: $planDayId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('targetSets: $targetSets, ')
          ..write('targetReps: $targetReps, ')
          ..write('targetWeight: $targetWeight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, planDayId, exerciseId, orderIndex,
      targetSets, targetReps, targetWeight);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayExercise &&
          other.id == this.id &&
          other.planDayId == this.planDayId &&
          other.exerciseId == this.exerciseId &&
          other.orderIndex == this.orderIndex &&
          other.targetSets == this.targetSets &&
          other.targetReps == this.targetReps &&
          other.targetWeight == this.targetWeight);
}

class DayExercisesCompanion extends UpdateCompanion<DayExercise> {
  final Value<String> id;
  final Value<String> planDayId;
  final Value<String> exerciseId;
  final Value<int> orderIndex;
  final Value<int> targetSets;
  final Value<int> targetReps;
  final Value<double?> targetWeight;
  final Value<int> rowid;
  const DayExercisesCompanion({
    this.id = const Value.absent(),
    this.planDayId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.targetSets = const Value.absent(),
    this.targetReps = const Value.absent(),
    this.targetWeight = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DayExercisesCompanion.insert({
    required String id,
    required String planDayId,
    required String exerciseId,
    required int orderIndex,
    required int targetSets,
    required int targetReps,
    this.targetWeight = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        planDayId = Value(planDayId),
        exerciseId = Value(exerciseId),
        orderIndex = Value(orderIndex),
        targetSets = Value(targetSets),
        targetReps = Value(targetReps);
  static Insertable<DayExercise> custom({
    Expression<String>? id,
    Expression<String>? planDayId,
    Expression<String>? exerciseId,
    Expression<int>? orderIndex,
    Expression<int>? targetSets,
    Expression<int>? targetReps,
    Expression<double>? targetWeight,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planDayId != null) 'plan_day_id': planDayId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (targetSets != null) 'target_sets': targetSets,
      if (targetReps != null) 'target_reps': targetReps,
      if (targetWeight != null) 'target_weight': targetWeight,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DayExercisesCompanion copyWith(
      {Value<String>? id,
      Value<String>? planDayId,
      Value<String>? exerciseId,
      Value<int>? orderIndex,
      Value<int>? targetSets,
      Value<int>? targetReps,
      Value<double?>? targetWeight,
      Value<int>? rowid}) {
    return DayExercisesCompanion(
      id: id ?? this.id,
      planDayId: planDayId ?? this.planDayId,
      exerciseId: exerciseId ?? this.exerciseId,
      orderIndex: orderIndex ?? this.orderIndex,
      targetSets: targetSets ?? this.targetSets,
      targetReps: targetReps ?? this.targetReps,
      targetWeight: targetWeight ?? this.targetWeight,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (planDayId.present) {
      map['plan_day_id'] = Variable<String>(planDayId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (targetSets.present) {
      map['target_sets'] = Variable<int>(targetSets.value);
    }
    if (targetReps.present) {
      map['target_reps'] = Variable<int>(targetReps.value);
    }
    if (targetWeight.present) {
      map['target_weight'] = Variable<double>(targetWeight.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayExercisesCompanion(')
          ..write('id: $id, ')
          ..write('planDayId: $planDayId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('targetSets: $targetSets, ')
          ..write('targetReps: $targetReps, ')
          ..write('targetWeight: $targetWeight, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyRecordsTable extends DailyRecords
    with TableInfo<$DailyRecordsTable, DailyRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _planDayIdMeta =
      const VerificationMeta('planDayId');
  @override
  late final GeneratedColumn<String> planDayId = GeneratedColumn<String>(
      'plan_day_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _skipReasonMeta =
      const VerificationMeta('skipReason');
  @override
  late final GeneratedColumn<String> skipReason = GeneratedColumn<String>(
      'skip_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, planDayId, status, skipReason, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_records';
  @override
  VerificationContext validateIntegrity(Insertable<DailyRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('plan_day_id')) {
      context.handle(
          _planDayIdMeta,
          planDayId.isAcceptableOrUnknown(
              data['plan_day_id']!, _planDayIdMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('skip_reason')) {
      context.handle(
          _skipReasonMeta,
          skipReason.isAcceptableOrUnknown(
              data['skip_reason']!, _skipReasonMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      planDayId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plan_day_id']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      skipReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}skip_reason']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $DailyRecordsTable createAlias(String alias) {
    return $DailyRecordsTable(attachedDatabase, alias);
  }
}

class DailyRecord extends DataClass implements Insertable<DailyRecord> {
  final String id;
  final DateTime date;
  final String? planDayId;
  final String status;
  final String? skipReason;
  final String? note;
  const DailyRecord(
      {required this.id,
      required this.date,
      this.planDayId,
      required this.status,
      this.skipReason,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || planDayId != null) {
      map['plan_day_id'] = Variable<String>(planDayId);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || skipReason != null) {
      map['skip_reason'] = Variable<String>(skipReason);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  DailyRecordsCompanion toCompanion(bool nullToAbsent) {
    return DailyRecordsCompanion(
      id: Value(id),
      date: Value(date),
      planDayId: planDayId == null && nullToAbsent
          ? const Value.absent()
          : Value(planDayId),
      status: Value(status),
      skipReason: skipReason == null && nullToAbsent
          ? const Value.absent()
          : Value(skipReason),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory DailyRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyRecord(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      planDayId: serializer.fromJson<String?>(json['planDayId']),
      status: serializer.fromJson<String>(json['status']),
      skipReason: serializer.fromJson<String?>(json['skipReason']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'planDayId': serializer.toJson<String?>(planDayId),
      'status': serializer.toJson<String>(status),
      'skipReason': serializer.toJson<String?>(skipReason),
      'note': serializer.toJson<String?>(note),
    };
  }

  DailyRecord copyWith(
          {String? id,
          DateTime? date,
          Value<String?> planDayId = const Value.absent(),
          String? status,
          Value<String?> skipReason = const Value.absent(),
          Value<String?> note = const Value.absent()}) =>
      DailyRecord(
        id: id ?? this.id,
        date: date ?? this.date,
        planDayId: planDayId.present ? planDayId.value : this.planDayId,
        status: status ?? this.status,
        skipReason: skipReason.present ? skipReason.value : this.skipReason,
        note: note.present ? note.value : this.note,
      );
  DailyRecord copyWithCompanion(DailyRecordsCompanion data) {
    return DailyRecord(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      planDayId: data.planDayId.present ? data.planDayId.value : this.planDayId,
      status: data.status.present ? data.status.value : this.status,
      skipReason:
          data.skipReason.present ? data.skipReason.value : this.skipReason,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyRecord(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('planDayId: $planDayId, ')
          ..write('status: $status, ')
          ..write('skipReason: $skipReason, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, planDayId, status, skipReason, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyRecord &&
          other.id == this.id &&
          other.date == this.date &&
          other.planDayId == this.planDayId &&
          other.status == this.status &&
          other.skipReason == this.skipReason &&
          other.note == this.note);
}

class DailyRecordsCompanion extends UpdateCompanion<DailyRecord> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<String?> planDayId;
  final Value<String> status;
  final Value<String?> skipReason;
  final Value<String?> note;
  final Value<int> rowid;
  const DailyRecordsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.planDayId = const Value.absent(),
    this.status = const Value.absent(),
    this.skipReason = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyRecordsCompanion.insert({
    required String id,
    required DateTime date,
    this.planDayId = const Value.absent(),
    required String status,
    this.skipReason = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        date = Value(date),
        status = Value(status);
  static Insertable<DailyRecord> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<String>? planDayId,
    Expression<String>? status,
    Expression<String>? skipReason,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (planDayId != null) 'plan_day_id': planDayId,
      if (status != null) 'status': status,
      if (skipReason != null) 'skip_reason': skipReason,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyRecordsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? date,
      Value<String?>? planDayId,
      Value<String>? status,
      Value<String?>? skipReason,
      Value<String?>? note,
      Value<int>? rowid}) {
    return DailyRecordsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      planDayId: planDayId ?? this.planDayId,
      status: status ?? this.status,
      skipReason: skipReason ?? this.skipReason,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (planDayId.present) {
      map['plan_day_id'] = Variable<String>(planDayId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (skipReason.present) {
      map['skip_reason'] = Variable<String>(skipReason.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyRecordsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('planDayId: $planDayId, ')
          ..write('status: $status, ')
          ..write('skipReason: $skipReason, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExerciseRecordsTable extends ExerciseRecords
    with TableInfo<$ExerciseRecordsTable, ExerciseRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dailyRecordIdMeta =
      const VerificationMeta('dailyRecordId');
  @override
  late final GeneratedColumn<String> dailyRecordId = GeneratedColumn<String>(
      'daily_record_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _exerciseIdMeta =
      const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
      'exercise_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actualSetsMeta =
      const VerificationMeta('actualSets');
  @override
  late final GeneratedColumn<int> actualSets = GeneratedColumn<int>(
      'actual_sets', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _actualRepsMeta =
      const VerificationMeta('actualReps');
  @override
  late final GeneratedColumn<String> actualReps = GeneratedColumn<String>(
      'actual_reps', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actualWeightMeta =
      const VerificationMeta('actualWeight');
  @override
  late final GeneratedColumn<String> actualWeight = GeneratedColumn<String>(
      'actual_weight', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        dailyRecordId,
        exerciseId,
        actualSets,
        actualReps,
        actualWeight,
        isCompleted,
        note
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_records';
  @override
  VerificationContext validateIntegrity(Insertable<ExerciseRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('daily_record_id')) {
      context.handle(
          _dailyRecordIdMeta,
          dailyRecordId.isAcceptableOrUnknown(
              data['daily_record_id']!, _dailyRecordIdMeta));
    } else if (isInserting) {
      context.missing(_dailyRecordIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
          _exerciseIdMeta,
          exerciseId.isAcceptableOrUnknown(
              data['exercise_id']!, _exerciseIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('actual_sets')) {
      context.handle(
          _actualSetsMeta,
          actualSets.isAcceptableOrUnknown(
              data['actual_sets']!, _actualSetsMeta));
    } else if (isInserting) {
      context.missing(_actualSetsMeta);
    }
    if (data.containsKey('actual_reps')) {
      context.handle(
          _actualRepsMeta,
          actualReps.isAcceptableOrUnknown(
              data['actual_reps']!, _actualRepsMeta));
    } else if (isInserting) {
      context.missing(_actualRepsMeta);
    }
    if (data.containsKey('actual_weight')) {
      context.handle(
          _actualWeightMeta,
          actualWeight.isAcceptableOrUnknown(
              data['actual_weight']!, _actualWeightMeta));
    } else if (isInserting) {
      context.missing(_actualWeightMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      dailyRecordId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}daily_record_id'])!,
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercise_id'])!,
      actualSets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}actual_sets'])!,
      actualReps: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}actual_reps'])!,
      actualWeight: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}actual_weight'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $ExerciseRecordsTable createAlias(String alias) {
    return $ExerciseRecordsTable(attachedDatabase, alias);
  }
}

class ExerciseRecord extends DataClass implements Insertable<ExerciseRecord> {
  final String id;
  final String dailyRecordId;
  final String exerciseId;
  final int actualSets;
  final String actualReps;
  final String actualWeight;
  final bool isCompleted;
  final String? note;
  const ExerciseRecord(
      {required this.id,
      required this.dailyRecordId,
      required this.exerciseId,
      required this.actualSets,
      required this.actualReps,
      required this.actualWeight,
      required this.isCompleted,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['daily_record_id'] = Variable<String>(dailyRecordId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['actual_sets'] = Variable<int>(actualSets);
    map['actual_reps'] = Variable<String>(actualReps);
    map['actual_weight'] = Variable<String>(actualWeight);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  ExerciseRecordsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseRecordsCompanion(
      id: Value(id),
      dailyRecordId: Value(dailyRecordId),
      exerciseId: Value(exerciseId),
      actualSets: Value(actualSets),
      actualReps: Value(actualReps),
      actualWeight: Value(actualWeight),
      isCompleted: Value(isCompleted),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory ExerciseRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseRecord(
      id: serializer.fromJson<String>(json['id']),
      dailyRecordId: serializer.fromJson<String>(json['dailyRecordId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      actualSets: serializer.fromJson<int>(json['actualSets']),
      actualReps: serializer.fromJson<String>(json['actualReps']),
      actualWeight: serializer.fromJson<String>(json['actualWeight']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dailyRecordId': serializer.toJson<String>(dailyRecordId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'actualSets': serializer.toJson<int>(actualSets),
      'actualReps': serializer.toJson<String>(actualReps),
      'actualWeight': serializer.toJson<String>(actualWeight),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'note': serializer.toJson<String?>(note),
    };
  }

  ExerciseRecord copyWith(
          {String? id,
          String? dailyRecordId,
          String? exerciseId,
          int? actualSets,
          String? actualReps,
          String? actualWeight,
          bool? isCompleted,
          Value<String?> note = const Value.absent()}) =>
      ExerciseRecord(
        id: id ?? this.id,
        dailyRecordId: dailyRecordId ?? this.dailyRecordId,
        exerciseId: exerciseId ?? this.exerciseId,
        actualSets: actualSets ?? this.actualSets,
        actualReps: actualReps ?? this.actualReps,
        actualWeight: actualWeight ?? this.actualWeight,
        isCompleted: isCompleted ?? this.isCompleted,
        note: note.present ? note.value : this.note,
      );
  ExerciseRecord copyWithCompanion(ExerciseRecordsCompanion data) {
    return ExerciseRecord(
      id: data.id.present ? data.id.value : this.id,
      dailyRecordId: data.dailyRecordId.present
          ? data.dailyRecordId.value
          : this.dailyRecordId,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      actualSets:
          data.actualSets.present ? data.actualSets.value : this.actualSets,
      actualReps:
          data.actualReps.present ? data.actualReps.value : this.actualReps,
      actualWeight: data.actualWeight.present
          ? data.actualWeight.value
          : this.actualWeight,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseRecord(')
          ..write('id: $id, ')
          ..write('dailyRecordId: $dailyRecordId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('actualSets: $actualSets, ')
          ..write('actualReps: $actualReps, ')
          ..write('actualWeight: $actualWeight, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dailyRecordId, exerciseId, actualSets,
      actualReps, actualWeight, isCompleted, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseRecord &&
          other.id == this.id &&
          other.dailyRecordId == this.dailyRecordId &&
          other.exerciseId == this.exerciseId &&
          other.actualSets == this.actualSets &&
          other.actualReps == this.actualReps &&
          other.actualWeight == this.actualWeight &&
          other.isCompleted == this.isCompleted &&
          other.note == this.note);
}

class ExerciseRecordsCompanion extends UpdateCompanion<ExerciseRecord> {
  final Value<String> id;
  final Value<String> dailyRecordId;
  final Value<String> exerciseId;
  final Value<int> actualSets;
  final Value<String> actualReps;
  final Value<String> actualWeight;
  final Value<bool> isCompleted;
  final Value<String?> note;
  final Value<int> rowid;
  const ExerciseRecordsCompanion({
    this.id = const Value.absent(),
    this.dailyRecordId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.actualSets = const Value.absent(),
    this.actualReps = const Value.absent(),
    this.actualWeight = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciseRecordsCompanion.insert({
    required String id,
    required String dailyRecordId,
    required String exerciseId,
    required int actualSets,
    required String actualReps,
    required String actualWeight,
    this.isCompleted = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        dailyRecordId = Value(dailyRecordId),
        exerciseId = Value(exerciseId),
        actualSets = Value(actualSets),
        actualReps = Value(actualReps),
        actualWeight = Value(actualWeight);
  static Insertable<ExerciseRecord> custom({
    Expression<String>? id,
    Expression<String>? dailyRecordId,
    Expression<String>? exerciseId,
    Expression<int>? actualSets,
    Expression<String>? actualReps,
    Expression<String>? actualWeight,
    Expression<bool>? isCompleted,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dailyRecordId != null) 'daily_record_id': dailyRecordId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (actualSets != null) 'actual_sets': actualSets,
      if (actualReps != null) 'actual_reps': actualReps,
      if (actualWeight != null) 'actual_weight': actualWeight,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciseRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? dailyRecordId,
      Value<String>? exerciseId,
      Value<int>? actualSets,
      Value<String>? actualReps,
      Value<String>? actualWeight,
      Value<bool>? isCompleted,
      Value<String?>? note,
      Value<int>? rowid}) {
    return ExerciseRecordsCompanion(
      id: id ?? this.id,
      dailyRecordId: dailyRecordId ?? this.dailyRecordId,
      exerciseId: exerciseId ?? this.exerciseId,
      actualSets: actualSets ?? this.actualSets,
      actualReps: actualReps ?? this.actualReps,
      actualWeight: actualWeight ?? this.actualWeight,
      isCompleted: isCompleted ?? this.isCompleted,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dailyRecordId.present) {
      map['daily_record_id'] = Variable<String>(dailyRecordId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (actualSets.present) {
      map['actual_sets'] = Variable<int>(actualSets.value);
    }
    if (actualReps.present) {
      map['actual_reps'] = Variable<String>(actualReps.value);
    }
    if (actualWeight.present) {
      map['actual_weight'] = Variable<String>(actualWeight.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseRecordsCompanion(')
          ..write('id: $id, ')
          ..write('dailyRecordId: $dailyRecordId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('actualSets: $actualSets, ')
          ..write('actualReps: $actualReps, ')
          ..write('actualWeight: $actualWeight, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _currentPlanIdMeta =
      const VerificationMeta('currentPlanId');
  @override
  late final GeneratedColumn<String> currentPlanId = GeneratedColumn<String>(
      'current_plan_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currentCycleDayMeta =
      const VerificationMeta('currentCycleDay');
  @override
  late final GeneratedColumn<int> currentCycleDay = GeneratedColumn<int>(
      'current_cycle_day', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastActiveDateMeta =
      const VerificationMeta('lastActiveDate');
  @override
  late final GeneratedColumn<DateTime> lastActiveDate =
      GeneratedColumn<DateTime>('last_active_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _skipHistoryMeta =
      const VerificationMeta('skipHistory');
  @override
  late final GeneratedColumn<String> skipHistory = GeneratedColumn<String>(
      'skip_history', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, currentPlanId, currentCycleDay, lastActiveDate, skipHistory];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('current_plan_id')) {
      context.handle(
          _currentPlanIdMeta,
          currentPlanId.isAcceptableOrUnknown(
              data['current_plan_id']!, _currentPlanIdMeta));
    }
    if (data.containsKey('current_cycle_day')) {
      context.handle(
          _currentCycleDayMeta,
          currentCycleDay.isAcceptableOrUnknown(
              data['current_cycle_day']!, _currentCycleDayMeta));
    }
    if (data.containsKey('last_active_date')) {
      context.handle(
          _lastActiveDateMeta,
          lastActiveDate.isAcceptableOrUnknown(
              data['last_active_date']!, _lastActiveDateMeta));
    }
    if (data.containsKey('skip_history')) {
      context.handle(
          _skipHistoryMeta,
          skipHistory.isAcceptableOrUnknown(
              data['skip_history']!, _skipHistoryMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      currentPlanId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}current_plan_id']),
      currentCycleDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_cycle_day'])!,
      lastActiveDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_active_date']),
      skipHistory: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}skip_history']),
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final String? currentPlanId;
  final int currentCycleDay;
  final DateTime? lastActiveDate;
  final String? skipHistory;
  const AppSetting(
      {required this.id,
      this.currentPlanId,
      required this.currentCycleDay,
      this.lastActiveDate,
      this.skipHistory});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || currentPlanId != null) {
      map['current_plan_id'] = Variable<String>(currentPlanId);
    }
    map['current_cycle_day'] = Variable<int>(currentCycleDay);
    if (!nullToAbsent || lastActiveDate != null) {
      map['last_active_date'] = Variable<DateTime>(lastActiveDate);
    }
    if (!nullToAbsent || skipHistory != null) {
      map['skip_history'] = Variable<String>(skipHistory);
    }
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      currentPlanId: currentPlanId == null && nullToAbsent
          ? const Value.absent()
          : Value(currentPlanId),
      currentCycleDay: Value(currentCycleDay),
      lastActiveDate: lastActiveDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastActiveDate),
      skipHistory: skipHistory == null && nullToAbsent
          ? const Value.absent()
          : Value(skipHistory),
    );
  }

  factory AppSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      currentPlanId: serializer.fromJson<String?>(json['currentPlanId']),
      currentCycleDay: serializer.fromJson<int>(json['currentCycleDay']),
      lastActiveDate: serializer.fromJson<DateTime?>(json['lastActiveDate']),
      skipHistory: serializer.fromJson<String?>(json['skipHistory']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currentPlanId': serializer.toJson<String?>(currentPlanId),
      'currentCycleDay': serializer.toJson<int>(currentCycleDay),
      'lastActiveDate': serializer.toJson<DateTime?>(lastActiveDate),
      'skipHistory': serializer.toJson<String?>(skipHistory),
    };
  }

  AppSetting copyWith(
          {int? id,
          Value<String?> currentPlanId = const Value.absent(),
          int? currentCycleDay,
          Value<DateTime?> lastActiveDate = const Value.absent(),
          Value<String?> skipHistory = const Value.absent()}) =>
      AppSetting(
        id: id ?? this.id,
        currentPlanId:
            currentPlanId.present ? currentPlanId.value : this.currentPlanId,
        currentCycleDay: currentCycleDay ?? this.currentCycleDay,
        lastActiveDate:
            lastActiveDate.present ? lastActiveDate.value : this.lastActiveDate,
        skipHistory: skipHistory.present ? skipHistory.value : this.skipHistory,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      currentPlanId: data.currentPlanId.present
          ? data.currentPlanId.value
          : this.currentPlanId,
      currentCycleDay: data.currentCycleDay.present
          ? data.currentCycleDay.value
          : this.currentCycleDay,
      lastActiveDate: data.lastActiveDate.present
          ? data.lastActiveDate.value
          : this.lastActiveDate,
      skipHistory:
          data.skipHistory.present ? data.skipHistory.value : this.skipHistory,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('currentPlanId: $currentPlanId, ')
          ..write('currentCycleDay: $currentCycleDay, ')
          ..write('lastActiveDate: $lastActiveDate, ')
          ..write('skipHistory: $skipHistory')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, currentPlanId, currentCycleDay, lastActiveDate, skipHistory);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.currentPlanId == this.currentPlanId &&
          other.currentCycleDay == this.currentCycleDay &&
          other.lastActiveDate == this.lastActiveDate &&
          other.skipHistory == this.skipHistory);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<String?> currentPlanId;
  final Value<int> currentCycleDay;
  final Value<DateTime?> lastActiveDate;
  final Value<String?> skipHistory;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.currentPlanId = const Value.absent(),
    this.currentCycleDay = const Value.absent(),
    this.lastActiveDate = const Value.absent(),
    this.skipHistory = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.currentPlanId = const Value.absent(),
    this.currentCycleDay = const Value.absent(),
    this.lastActiveDate = const Value.absent(),
    this.skipHistory = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<String>? currentPlanId,
    Expression<int>? currentCycleDay,
    Expression<DateTime>? lastActiveDate,
    Expression<String>? skipHistory,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currentPlanId != null) 'current_plan_id': currentPlanId,
      if (currentCycleDay != null) 'current_cycle_day': currentCycleDay,
      if (lastActiveDate != null) 'last_active_date': lastActiveDate,
      if (skipHistory != null) 'skip_history': skipHistory,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? currentPlanId,
      Value<int>? currentCycleDay,
      Value<DateTime?>? lastActiveDate,
      Value<String?>? skipHistory}) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      currentPlanId: currentPlanId ?? this.currentPlanId,
      currentCycleDay: currentCycleDay ?? this.currentCycleDay,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      skipHistory: skipHistory ?? this.skipHistory,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currentPlanId.present) {
      map['current_plan_id'] = Variable<String>(currentPlanId.value);
    }
    if (currentCycleDay.present) {
      map['current_cycle_day'] = Variable<int>(currentCycleDay.value);
    }
    if (lastActiveDate.present) {
      map['last_active_date'] = Variable<DateTime>(lastActiveDate.value);
    }
    if (skipHistory.present) {
      map['skip_history'] = Variable<String>(skipHistory.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('currentPlanId: $currentPlanId, ')
          ..write('currentCycleDay: $currentCycleDay, ')
          ..write('lastActiveDate: $lastActiveDate, ')
          ..write('skipHistory: $skipHistory')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkoutTypesTable workoutTypes = $WorkoutTypesTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $WorkoutSessionsTable workoutSessions =
      $WorkoutSessionsTable(this);
  late final $WorkoutSetsTable workoutSets = $WorkoutSetsTable(this);
  late final $WorkoutPlansTable workoutPlans = $WorkoutPlansTable(this);
  late final $PlanDaysTable planDays = $PlanDaysTable(this);
  late final $DayExercisesTable dayExercises = $DayExercisesTable(this);
  late final $DailyRecordsTable dailyRecords = $DailyRecordsTable(this);
  late final $ExerciseRecordsTable exerciseRecords =
      $ExerciseRecordsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        workoutTypes,
        exercises,
        workoutSessions,
        workoutSets,
        workoutPlans,
        planDays,
        dayExercises,
        dailyRecords,
        exerciseRecords,
        appSettings
      ];
}

typedef $$WorkoutTypesTableCreateCompanionBuilder = WorkoutTypesCompanion
    Function({
  Value<int> id,
  required String name,
  Value<String> icon,
  Value<int> sortOrder,
});
typedef $$WorkoutTypesTableUpdateCompanionBuilder = WorkoutTypesCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> icon,
  Value<int> sortOrder,
});

final class $$WorkoutTypesTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutTypesTable, WorkoutType> {
  $$WorkoutTypesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExercisesTable, List<Exercise>>
      _exercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.exercises,
          aliasName:
              $_aliasNameGenerator(db.workoutTypes.id, db.exercises.typeId));

  $$ExercisesTableProcessedTableManager get exercisesRefs {
    final manager = $$ExercisesTableTableManager($_db, $_db.exercises)
        .filter((f) => f.typeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_exercisesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$WorkoutSessionsTable, List<WorkoutSession>>
      _workoutSessionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.workoutSessions,
              aliasName: $_aliasNameGenerator(
                  db.workoutTypes.id, db.workoutSessions.typeId));

  $$WorkoutSessionsTableProcessedTableManager get workoutSessionsRefs {
    final manager =
        $$WorkoutSessionsTableTableManager($_db, $_db.workoutSessions)
            .filter((f) => f.typeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_workoutSessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WorkoutTypesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutTypesTable> {
  $$WorkoutTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  Expression<bool> exercisesRefs(
      Expression<bool> Function($$ExercisesTableFilterComposer f) f) {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.typeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableFilterComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> workoutSessionsRefs(
      Expression<bool> Function($$WorkoutSessionsTableFilterComposer f) f) {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workoutSessions,
        getReferencedColumn: (t) => t.typeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutSessionsTableFilterComposer(
              $db: $db,
              $table: $db.workoutSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorkoutTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutTypesTable> {
  $$WorkoutTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));
}

class $$WorkoutTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutTypesTable> {
  $$WorkoutTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> exercisesRefs<T extends Object>(
      Expression<T> Function($$ExercisesTableAnnotationComposer a) f) {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.typeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableAnnotationComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> workoutSessionsRefs<T extends Object>(
      Expression<T> Function($$WorkoutSessionsTableAnnotationComposer a) f) {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workoutSessions,
        getReferencedColumn: (t) => t.typeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.workoutSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorkoutTypesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutTypesTable,
    WorkoutType,
    $$WorkoutTypesTableFilterComposer,
    $$WorkoutTypesTableOrderingComposer,
    $$WorkoutTypesTableAnnotationComposer,
    $$WorkoutTypesTableCreateCompanionBuilder,
    $$WorkoutTypesTableUpdateCompanionBuilder,
    (WorkoutType, $$WorkoutTypesTableReferences),
    WorkoutType,
    PrefetchHooks Function({bool exercisesRefs, bool workoutSessionsRefs})> {
  $$WorkoutTypesTableTableManager(_$AppDatabase db, $WorkoutTypesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
          }) =>
              WorkoutTypesCompanion(
            id: id,
            name: name,
            icon: icon,
            sortOrder: sortOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> icon = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
          }) =>
              WorkoutTypesCompanion.insert(
            id: id,
            name: name,
            icon: icon,
            sortOrder: sortOrder,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkoutTypesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {exercisesRefs = false, workoutSessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (exercisesRefs) db.exercises,
                if (workoutSessionsRefs) db.workoutSessions
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (exercisesRefs)
                    await $_getPrefetchedData<WorkoutType, $WorkoutTypesTable,
                            Exercise>(
                        currentTable: table,
                        referencedTable: $$WorkoutTypesTableReferences
                            ._exercisesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorkoutTypesTableReferences(db, table, p0)
                                .exercisesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.typeId == item.id),
                        typedResults: items),
                  if (workoutSessionsRefs)
                    await $_getPrefetchedData<WorkoutType, $WorkoutTypesTable,
                            WorkoutSession>(
                        currentTable: table,
                        referencedTable: $$WorkoutTypesTableReferences
                            ._workoutSessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorkoutTypesTableReferences(db, table, p0)
                                .workoutSessionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.typeId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WorkoutTypesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkoutTypesTable,
    WorkoutType,
    $$WorkoutTypesTableFilterComposer,
    $$WorkoutTypesTableOrderingComposer,
    $$WorkoutTypesTableAnnotationComposer,
    $$WorkoutTypesTableCreateCompanionBuilder,
    $$WorkoutTypesTableUpdateCompanionBuilder,
    (WorkoutType, $$WorkoutTypesTableReferences),
    WorkoutType,
    PrefetchHooks Function({bool exercisesRefs, bool workoutSessionsRefs})>;
typedef $$ExercisesTableCreateCompanionBuilder = ExercisesCompanion Function({
  required String id,
  required String name,
  Value<int?> typeId,
  Value<String?> category,
  Value<int> defaultSets,
  Value<int> defaultReps,
  Value<double?> defaultWeight,
  Value<int?> defaultDuration,
  Value<String?> note,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ExercisesTableUpdateCompanionBuilder = ExercisesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int?> typeId,
  Value<String?> category,
  Value<int> defaultSets,
  Value<int> defaultReps,
  Value<double?> defaultWeight,
  Value<int?> defaultDuration,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutTypesTable _typeIdTable(_$AppDatabase db) =>
      db.workoutTypes.createAlias(
          $_aliasNameGenerator(db.exercises.typeId, db.workoutTypes.id));

  $$WorkoutTypesTableProcessedTableManager? get typeId {
    final $_column = $_itemColumn<int>('type_id');
    if ($_column == null) return null;
    final manager = $$WorkoutTypesTableTableManager($_db, $_db.workoutTypes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_typeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$WorkoutSetsTable, List<WorkoutSet>>
      _workoutSetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.workoutSets,
          aliasName:
              $_aliasNameGenerator(db.exercises.id, db.workoutSets.exerciseId));

  $$WorkoutSetsTableProcessedTableManager get workoutSetsRefs {
    final manager = $$WorkoutSetsTableTableManager($_db, $_db.workoutSets)
        .filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutSetsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get defaultSets => $composableBuilder(
      column: $table.defaultSets, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get defaultReps => $composableBuilder(
      column: $table.defaultReps, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get defaultWeight => $composableBuilder(
      column: $table.defaultWeight, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get defaultDuration => $composableBuilder(
      column: $table.defaultDuration,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$WorkoutTypesTableFilterComposer get typeId {
    final $$WorkoutTypesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.typeId,
        referencedTable: $db.workoutTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutTypesTableFilterComposer(
              $db: $db,
              $table: $db.workoutTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> workoutSetsRefs(
      Expression<bool> Function($$WorkoutSetsTableFilterComposer f) f) {
    final $$WorkoutSetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workoutSets,
        getReferencedColumn: (t) => t.exerciseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutSetsTableFilterComposer(
              $db: $db,
              $table: $db.workoutSets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get defaultSets => $composableBuilder(
      column: $table.defaultSets, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get defaultReps => $composableBuilder(
      column: $table.defaultReps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get defaultWeight => $composableBuilder(
      column: $table.defaultWeight,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get defaultDuration => $composableBuilder(
      column: $table.defaultDuration,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$WorkoutTypesTableOrderingComposer get typeId {
    final $$WorkoutTypesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.typeId,
        referencedTable: $db.workoutTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutTypesTableOrderingComposer(
              $db: $db,
              $table: $db.workoutTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get defaultSets => $composableBuilder(
      column: $table.defaultSets, builder: (column) => column);

  GeneratedColumn<int> get defaultReps => $composableBuilder(
      column: $table.defaultReps, builder: (column) => column);

  GeneratedColumn<double> get defaultWeight => $composableBuilder(
      column: $table.defaultWeight, builder: (column) => column);

  GeneratedColumn<int> get defaultDuration => $composableBuilder(
      column: $table.defaultDuration, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$WorkoutTypesTableAnnotationComposer get typeId {
    final $$WorkoutTypesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.typeId,
        referencedTable: $db.workoutTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutTypesTableAnnotationComposer(
              $db: $db,
              $table: $db.workoutTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> workoutSetsRefs<T extends Object>(
      Expression<T> Function($$WorkoutSetsTableAnnotationComposer a) f) {
    final $$WorkoutSetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workoutSets,
        getReferencedColumn: (t) => t.exerciseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutSetsTableAnnotationComposer(
              $db: $db,
              $table: $db.workoutSets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExercisesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExercisesTable,
    Exercise,
    $$ExercisesTableFilterComposer,
    $$ExercisesTableOrderingComposer,
    $$ExercisesTableAnnotationComposer,
    $$ExercisesTableCreateCompanionBuilder,
    $$ExercisesTableUpdateCompanionBuilder,
    (Exercise, $$ExercisesTableReferences),
    Exercise,
    PrefetchHooks Function({bool typeId, bool workoutSetsRefs})> {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int?> typeId = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<int> defaultSets = const Value.absent(),
            Value<int> defaultReps = const Value.absent(),
            Value<double?> defaultWeight = const Value.absent(),
            Value<int?> defaultDuration = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExercisesCompanion(
            id: id,
            name: name,
            typeId: typeId,
            category: category,
            defaultSets: defaultSets,
            defaultReps: defaultReps,
            defaultWeight: defaultWeight,
            defaultDuration: defaultDuration,
            note: note,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<int?> typeId = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<int> defaultSets = const Value.absent(),
            Value<int> defaultReps = const Value.absent(),
            Value<double?> defaultWeight = const Value.absent(),
            Value<int?> defaultDuration = const Value.absent(),
            Value<String?> note = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ExercisesCompanion.insert(
            id: id,
            name: name,
            typeId: typeId,
            category: category,
            defaultSets: defaultSets,
            defaultReps: defaultReps,
            defaultWeight: defaultWeight,
            defaultDuration: defaultDuration,
            note: note,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExercisesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({typeId = false, workoutSetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (workoutSetsRefs) db.workoutSets],
              addJoins: <
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
                      dynamic>>(state) {
                if (typeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.typeId,
                    referencedTable:
                        $$ExercisesTableReferences._typeIdTable(db),
                    referencedColumn:
                        $$ExercisesTableReferences._typeIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutSetsRefs)
                    await $_getPrefetchedData<Exercise, $ExercisesTable,
                            WorkoutSet>(
                        currentTable: table,
                        referencedTable: $$ExercisesTableReferences
                            ._workoutSetsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExercisesTableReferences(db, table, p0)
                                .workoutSetsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.exerciseId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ExercisesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExercisesTable,
    Exercise,
    $$ExercisesTableFilterComposer,
    $$ExercisesTableOrderingComposer,
    $$ExercisesTableAnnotationComposer,
    $$ExercisesTableCreateCompanionBuilder,
    $$ExercisesTableUpdateCompanionBuilder,
    (Exercise, $$ExercisesTableReferences),
    Exercise,
    PrefetchHooks Function({bool typeId, bool workoutSetsRefs})>;
typedef $$WorkoutSessionsTableCreateCompanionBuilder = WorkoutSessionsCompanion
    Function({
  required String id,
  required int typeId,
  required DateTime date,
  Value<String?> note,
  Value<String> status,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$WorkoutSessionsTableUpdateCompanionBuilder = WorkoutSessionsCompanion
    Function({
  Value<String> id,
  Value<int> typeId,
  Value<DateTime> date,
  Value<String?> note,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$WorkoutSessionsTableReferences extends BaseReferences<
    _$AppDatabase, $WorkoutSessionsTable, WorkoutSession> {
  $$WorkoutSessionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutTypesTable _typeIdTable(_$AppDatabase db) =>
      db.workoutTypes.createAlias(
          $_aliasNameGenerator(db.workoutSessions.typeId, db.workoutTypes.id));

  $$WorkoutTypesTableProcessedTableManager get typeId {
    final $_column = $_itemColumn<int>('type_id')!;

    final manager = $$WorkoutTypesTableTableManager($_db, $_db.workoutTypes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_typeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$WorkoutSetsTable, List<WorkoutSet>>
      _workoutSetsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.workoutSets,
              aliasName: $_aliasNameGenerator(
                  db.workoutSessions.id, db.workoutSets.sessionId));

  $$WorkoutSetsTableProcessedTableManager get workoutSetsRefs {
    final manager = $$WorkoutSetsTableTableManager($_db, $_db.workoutSets)
        .filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutSetsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$WorkoutTypesTableFilterComposer get typeId {
    final $$WorkoutTypesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.typeId,
        referencedTable: $db.workoutTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutTypesTableFilterComposer(
              $db: $db,
              $table: $db.workoutTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> workoutSetsRefs(
      Expression<bool> Function($$WorkoutSetsTableFilterComposer f) f) {
    final $$WorkoutSetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workoutSets,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutSetsTableFilterComposer(
              $db: $db,
              $table: $db.workoutSets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$WorkoutTypesTableOrderingComposer get typeId {
    final $$WorkoutTypesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.typeId,
        referencedTable: $db.workoutTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutTypesTableOrderingComposer(
              $db: $db,
              $table: $db.workoutTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$WorkoutTypesTableAnnotationComposer get typeId {
    final $$WorkoutTypesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.typeId,
        referencedTable: $db.workoutTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutTypesTableAnnotationComposer(
              $db: $db,
              $table: $db.workoutTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> workoutSetsRefs<T extends Object>(
      Expression<T> Function($$WorkoutSetsTableAnnotationComposer a) f) {
    final $$WorkoutSetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workoutSets,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutSetsTableAnnotationComposer(
              $db: $db,
              $table: $db.workoutSets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorkoutSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutSessionsTable,
    WorkoutSession,
    $$WorkoutSessionsTableFilterComposer,
    $$WorkoutSessionsTableOrderingComposer,
    $$WorkoutSessionsTableAnnotationComposer,
    $$WorkoutSessionsTableCreateCompanionBuilder,
    $$WorkoutSessionsTableUpdateCompanionBuilder,
    (WorkoutSession, $$WorkoutSessionsTableReferences),
    WorkoutSession,
    PrefetchHooks Function({bool typeId, bool workoutSetsRefs})> {
  $$WorkoutSessionsTableTableManager(
      _$AppDatabase db, $WorkoutSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> typeId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutSessionsCompanion(
            id: id,
            typeId: typeId,
            date: date,
            note: note,
            status: status,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int typeId,
            required DateTime date,
            Value<String?> note = const Value.absent(),
            Value<String> status = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutSessionsCompanion.insert(
            id: id,
            typeId: typeId,
            date: date,
            note: note,
            status: status,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkoutSessionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({typeId = false, workoutSetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (workoutSetsRefs) db.workoutSets],
              addJoins: <
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
                      dynamic>>(state) {
                if (typeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.typeId,
                    referencedTable:
                        $$WorkoutSessionsTableReferences._typeIdTable(db),
                    referencedColumn:
                        $$WorkoutSessionsTableReferences._typeIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutSetsRefs)
                    await $_getPrefetchedData<WorkoutSession, $WorkoutSessionsTable,
                            WorkoutSet>(
                        currentTable: table,
                        referencedTable: $$WorkoutSessionsTableReferences
                            ._workoutSetsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorkoutSessionsTableReferences(db, table, p0)
                                .workoutSetsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WorkoutSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkoutSessionsTable,
    WorkoutSession,
    $$WorkoutSessionsTableFilterComposer,
    $$WorkoutSessionsTableOrderingComposer,
    $$WorkoutSessionsTableAnnotationComposer,
    $$WorkoutSessionsTableCreateCompanionBuilder,
    $$WorkoutSessionsTableUpdateCompanionBuilder,
    (WorkoutSession, $$WorkoutSessionsTableReferences),
    WorkoutSession,
    PrefetchHooks Function({bool typeId, bool workoutSetsRefs})>;
typedef $$WorkoutSetsTableCreateCompanionBuilder = WorkoutSetsCompanion
    Function({
  required String id,
  required String sessionId,
  required String exerciseId,
  required int setNumber,
  Value<String> weight,
  Value<int> reps,
  Value<bool> isCompleted,
  Value<int> rowid,
});
typedef $$WorkoutSetsTableUpdateCompanionBuilder = WorkoutSetsCompanion
    Function({
  Value<String> id,
  Value<String> sessionId,
  Value<String> exerciseId,
  Value<int> setNumber,
  Value<String> weight,
  Value<int> reps,
  Value<bool> isCompleted,
  Value<int> rowid,
});

final class $$WorkoutSetsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutSetsTable, WorkoutSet> {
  $$WorkoutSetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.workoutSessions.createAlias($_aliasNameGenerator(
          db.workoutSets.sessionId, db.workoutSessions.id));

  $$WorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager =
        $$WorkoutSessionsTableTableManager($_db, $_db.workoutSessions)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias(
          $_aliasNameGenerator(db.workoutSets.exerciseId, db.exercises.id));

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$ExercisesTableTableManager($_db, $_db.exercises)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$WorkoutSetsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get setNumber => $composableBuilder(
      column: $table.setNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.workoutSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutSessionsTableFilterComposer(
              $db: $db,
              $table: $db.workoutSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableFilterComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get setNumber => $composableBuilder(
      column: $table.setNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.workoutSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutSessionsTableOrderingComposer(
              $db: $db,
              $table: $db.workoutSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableOrderingComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<String> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.workoutSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.workoutSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableAnnotationComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutSetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutSetsTable,
    WorkoutSet,
    $$WorkoutSetsTableFilterComposer,
    $$WorkoutSetsTableOrderingComposer,
    $$WorkoutSetsTableAnnotationComposer,
    $$WorkoutSetsTableCreateCompanionBuilder,
    $$WorkoutSetsTableUpdateCompanionBuilder,
    (WorkoutSet, $$WorkoutSetsTableReferences),
    WorkoutSet,
    PrefetchHooks Function({bool sessionId, bool exerciseId})> {
  $$WorkoutSetsTableTableManager(_$AppDatabase db, $WorkoutSetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sessionId = const Value.absent(),
            Value<String> exerciseId = const Value.absent(),
            Value<int> setNumber = const Value.absent(),
            Value<String> weight = const Value.absent(),
            Value<int> reps = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutSetsCompanion(
            id: id,
            sessionId: sessionId,
            exerciseId: exerciseId,
            setNumber: setNumber,
            weight: weight,
            reps: reps,
            isCompleted: isCompleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sessionId,
            required String exerciseId,
            required int setNumber,
            Value<String> weight = const Value.absent(),
            Value<int> reps = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutSetsCompanion.insert(
            id: id,
            sessionId: sessionId,
            exerciseId: exerciseId,
            setNumber: setNumber,
            weight: weight,
            reps: reps,
            isCompleted: isCompleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkoutSetsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({sessionId = false, exerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (sessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessionId,
                    referencedTable:
                        $$WorkoutSetsTableReferences._sessionIdTable(db),
                    referencedColumn:
                        $$WorkoutSetsTableReferences._sessionIdTable(db).id,
                  ) as T;
                }
                if (exerciseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.exerciseId,
                    referencedTable:
                        $$WorkoutSetsTableReferences._exerciseIdTable(db),
                    referencedColumn:
                        $$WorkoutSetsTableReferences._exerciseIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$WorkoutSetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkoutSetsTable,
    WorkoutSet,
    $$WorkoutSetsTableFilterComposer,
    $$WorkoutSetsTableOrderingComposer,
    $$WorkoutSetsTableAnnotationComposer,
    $$WorkoutSetsTableCreateCompanionBuilder,
    $$WorkoutSetsTableUpdateCompanionBuilder,
    (WorkoutSet, $$WorkoutSetsTableReferences),
    WorkoutSet,
    PrefetchHooks Function({bool sessionId, bool exerciseId})>;
typedef $$WorkoutPlansTableCreateCompanionBuilder = WorkoutPlansCompanion
    Function({
  required String id,
  required String name,
  required int cycleDays,
  Value<bool> isActive,
  required DateTime startDate,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$WorkoutPlansTableUpdateCompanionBuilder = WorkoutPlansCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<int> cycleDays,
  Value<bool> isActive,
  Value<DateTime> startDate,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$WorkoutPlansTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutPlansTable> {
  $$WorkoutPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cycleDays => $composableBuilder(
      column: $table.cycleDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$WorkoutPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutPlansTable> {
  $$WorkoutPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cycleDays => $composableBuilder(
      column: $table.cycleDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$WorkoutPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutPlansTable> {
  $$WorkoutPlansTableAnnotationComposer({
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

  GeneratedColumn<int> get cycleDays =>
      $composableBuilder(column: $table.cycleDays, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WorkoutPlansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutPlansTable,
    WorkoutPlan,
    $$WorkoutPlansTableFilterComposer,
    $$WorkoutPlansTableOrderingComposer,
    $$WorkoutPlansTableAnnotationComposer,
    $$WorkoutPlansTableCreateCompanionBuilder,
    $$WorkoutPlansTableUpdateCompanionBuilder,
    (
      WorkoutPlan,
      BaseReferences<_$AppDatabase, $WorkoutPlansTable, WorkoutPlan>
    ),
    WorkoutPlan,
    PrefetchHooks Function()> {
  $$WorkoutPlansTableTableManager(_$AppDatabase db, $WorkoutPlansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> cycleDays = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutPlansCompanion(
            id: id,
            name: name,
            cycleDays: cycleDays,
            isActive: isActive,
            startDate: startDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required int cycleDays,
            Value<bool> isActive = const Value.absent(),
            required DateTime startDate,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutPlansCompanion.insert(
            id: id,
            name: name,
            cycleDays: cycleDays,
            isActive: isActive,
            startDate: startDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WorkoutPlansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkoutPlansTable,
    WorkoutPlan,
    $$WorkoutPlansTableFilterComposer,
    $$WorkoutPlansTableOrderingComposer,
    $$WorkoutPlansTableAnnotationComposer,
    $$WorkoutPlansTableCreateCompanionBuilder,
    $$WorkoutPlansTableUpdateCompanionBuilder,
    (
      WorkoutPlan,
      BaseReferences<_$AppDatabase, $WorkoutPlansTable, WorkoutPlan>
    ),
    WorkoutPlan,
    PrefetchHooks Function()>;
typedef $$PlanDaysTableCreateCompanionBuilder = PlanDaysCompanion Function({
  required String id,
  required String planId,
  required int dayIndex,
  Value<bool> isRestDay,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$PlanDaysTableUpdateCompanionBuilder = PlanDaysCompanion Function({
  Value<String> id,
  Value<String> planId,
  Value<int> dayIndex,
  Value<bool> isRestDay,
  Value<String?> note,
  Value<int> rowid,
});

class $$PlanDaysTableFilterComposer
    extends Composer<_$AppDatabase, $PlanDaysTable> {
  $$PlanDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get planId => $composableBuilder(
      column: $table.planId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dayIndex => $composableBuilder(
      column: $table.dayIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRestDay => $composableBuilder(
      column: $table.isRestDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));
}

class $$PlanDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanDaysTable> {
  $$PlanDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get planId => $composableBuilder(
      column: $table.planId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dayIndex => $composableBuilder(
      column: $table.dayIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRestDay => $composableBuilder(
      column: $table.isRestDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));
}

class $$PlanDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanDaysTable> {
  $$PlanDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<int> get dayIndex =>
      $composableBuilder(column: $table.dayIndex, builder: (column) => column);

  GeneratedColumn<bool> get isRestDay =>
      $composableBuilder(column: $table.isRestDay, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$PlanDaysTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlanDaysTable,
    PlanDay,
    $$PlanDaysTableFilterComposer,
    $$PlanDaysTableOrderingComposer,
    $$PlanDaysTableAnnotationComposer,
    $$PlanDaysTableCreateCompanionBuilder,
    $$PlanDaysTableUpdateCompanionBuilder,
    (PlanDay, BaseReferences<_$AppDatabase, $PlanDaysTable, PlanDay>),
    PlanDay,
    PrefetchHooks Function()> {
  $$PlanDaysTableTableManager(_$AppDatabase db, $PlanDaysTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> planId = const Value.absent(),
            Value<int> dayIndex = const Value.absent(),
            Value<bool> isRestDay = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlanDaysCompanion(
            id: id,
            planId: planId,
            dayIndex: dayIndex,
            isRestDay: isRestDay,
            note: note,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String planId,
            required int dayIndex,
            Value<bool> isRestDay = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlanDaysCompanion.insert(
            id: id,
            planId: planId,
            dayIndex: dayIndex,
            isRestDay: isRestDay,
            note: note,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PlanDaysTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlanDaysTable,
    PlanDay,
    $$PlanDaysTableFilterComposer,
    $$PlanDaysTableOrderingComposer,
    $$PlanDaysTableAnnotationComposer,
    $$PlanDaysTableCreateCompanionBuilder,
    $$PlanDaysTableUpdateCompanionBuilder,
    (PlanDay, BaseReferences<_$AppDatabase, $PlanDaysTable, PlanDay>),
    PlanDay,
    PrefetchHooks Function()>;
typedef $$DayExercisesTableCreateCompanionBuilder = DayExercisesCompanion
    Function({
  required String id,
  required String planDayId,
  required String exerciseId,
  required int orderIndex,
  required int targetSets,
  required int targetReps,
  Value<double?> targetWeight,
  Value<int> rowid,
});
typedef $$DayExercisesTableUpdateCompanionBuilder = DayExercisesCompanion
    Function({
  Value<String> id,
  Value<String> planDayId,
  Value<String> exerciseId,
  Value<int> orderIndex,
  Value<int> targetSets,
  Value<int> targetReps,
  Value<double?> targetWeight,
  Value<int> rowid,
});

class $$DayExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $DayExercisesTable> {
  $$DayExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get planDayId => $composableBuilder(
      column: $table.planDayId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetSets => $composableBuilder(
      column: $table.targetSets, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetReps => $composableBuilder(
      column: $table.targetReps, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get targetWeight => $composableBuilder(
      column: $table.targetWeight, builder: (column) => ColumnFilters(column));
}

class $$DayExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $DayExercisesTable> {
  $$DayExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get planDayId => $composableBuilder(
      column: $table.planDayId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetSets => $composableBuilder(
      column: $table.targetSets, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetReps => $composableBuilder(
      column: $table.targetReps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get targetWeight => $composableBuilder(
      column: $table.targetWeight,
      builder: (column) => ColumnOrderings(column));
}

class $$DayExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DayExercisesTable> {
  $$DayExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get planDayId =>
      $composableBuilder(column: $table.planDayId, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);

  GeneratedColumn<int> get targetSets => $composableBuilder(
      column: $table.targetSets, builder: (column) => column);

  GeneratedColumn<int> get targetReps => $composableBuilder(
      column: $table.targetReps, builder: (column) => column);

  GeneratedColumn<double> get targetWeight => $composableBuilder(
      column: $table.targetWeight, builder: (column) => column);
}

class $$DayExercisesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DayExercisesTable,
    DayExercise,
    $$DayExercisesTableFilterComposer,
    $$DayExercisesTableOrderingComposer,
    $$DayExercisesTableAnnotationComposer,
    $$DayExercisesTableCreateCompanionBuilder,
    $$DayExercisesTableUpdateCompanionBuilder,
    (
      DayExercise,
      BaseReferences<_$AppDatabase, $DayExercisesTable, DayExercise>
    ),
    DayExercise,
    PrefetchHooks Function()> {
  $$DayExercisesTableTableManager(_$AppDatabase db, $DayExercisesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> planDayId = const Value.absent(),
            Value<String> exerciseId = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<int> targetSets = const Value.absent(),
            Value<int> targetReps = const Value.absent(),
            Value<double?> targetWeight = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DayExercisesCompanion(
            id: id,
            planDayId: planDayId,
            exerciseId: exerciseId,
            orderIndex: orderIndex,
            targetSets: targetSets,
            targetReps: targetReps,
            targetWeight: targetWeight,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String planDayId,
            required String exerciseId,
            required int orderIndex,
            required int targetSets,
            required int targetReps,
            Value<double?> targetWeight = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DayExercisesCompanion.insert(
            id: id,
            planDayId: planDayId,
            exerciseId: exerciseId,
            orderIndex: orderIndex,
            targetSets: targetSets,
            targetReps: targetReps,
            targetWeight: targetWeight,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DayExercisesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DayExercisesTable,
    DayExercise,
    $$DayExercisesTableFilterComposer,
    $$DayExercisesTableOrderingComposer,
    $$DayExercisesTableAnnotationComposer,
    $$DayExercisesTableCreateCompanionBuilder,
    $$DayExercisesTableUpdateCompanionBuilder,
    (
      DayExercise,
      BaseReferences<_$AppDatabase, $DayExercisesTable, DayExercise>
    ),
    DayExercise,
    PrefetchHooks Function()>;
typedef $$DailyRecordsTableCreateCompanionBuilder = DailyRecordsCompanion
    Function({
  required String id,
  required DateTime date,
  Value<String?> planDayId,
  required String status,
  Value<String?> skipReason,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$DailyRecordsTableUpdateCompanionBuilder = DailyRecordsCompanion
    Function({
  Value<String> id,
  Value<DateTime> date,
  Value<String?> planDayId,
  Value<String> status,
  Value<String?> skipReason,
  Value<String?> note,
  Value<int> rowid,
});

class $$DailyRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyRecordsTable> {
  $$DailyRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get planDayId => $composableBuilder(
      column: $table.planDayId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get skipReason => $composableBuilder(
      column: $table.skipReason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));
}

class $$DailyRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyRecordsTable> {
  $$DailyRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get planDayId => $composableBuilder(
      column: $table.planDayId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get skipReason => $composableBuilder(
      column: $table.skipReason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));
}

class $$DailyRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyRecordsTable> {
  $$DailyRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get planDayId =>
      $composableBuilder(column: $table.planDayId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get skipReason => $composableBuilder(
      column: $table.skipReason, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$DailyRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailyRecordsTable,
    DailyRecord,
    $$DailyRecordsTableFilterComposer,
    $$DailyRecordsTableOrderingComposer,
    $$DailyRecordsTableAnnotationComposer,
    $$DailyRecordsTableCreateCompanionBuilder,
    $$DailyRecordsTableUpdateCompanionBuilder,
    (
      DailyRecord,
      BaseReferences<_$AppDatabase, $DailyRecordsTable, DailyRecord>
    ),
    DailyRecord,
    PrefetchHooks Function()> {
  $$DailyRecordsTableTableManager(_$AppDatabase db, $DailyRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String?> planDayId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> skipReason = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyRecordsCompanion(
            id: id,
            date: date,
            planDayId: planDayId,
            status: status,
            skipReason: skipReason,
            note: note,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required DateTime date,
            Value<String?> planDayId = const Value.absent(),
            required String status,
            Value<String?> skipReason = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyRecordsCompanion.insert(
            id: id,
            date: date,
            planDayId: planDayId,
            status: status,
            skipReason: skipReason,
            note: note,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DailyRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailyRecordsTable,
    DailyRecord,
    $$DailyRecordsTableFilterComposer,
    $$DailyRecordsTableOrderingComposer,
    $$DailyRecordsTableAnnotationComposer,
    $$DailyRecordsTableCreateCompanionBuilder,
    $$DailyRecordsTableUpdateCompanionBuilder,
    (
      DailyRecord,
      BaseReferences<_$AppDatabase, $DailyRecordsTable, DailyRecord>
    ),
    DailyRecord,
    PrefetchHooks Function()>;
typedef $$ExerciseRecordsTableCreateCompanionBuilder = ExerciseRecordsCompanion
    Function({
  required String id,
  required String dailyRecordId,
  required String exerciseId,
  required int actualSets,
  required String actualReps,
  required String actualWeight,
  Value<bool> isCompleted,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$ExerciseRecordsTableUpdateCompanionBuilder = ExerciseRecordsCompanion
    Function({
  Value<String> id,
  Value<String> dailyRecordId,
  Value<String> exerciseId,
  Value<int> actualSets,
  Value<String> actualReps,
  Value<String> actualWeight,
  Value<bool> isCompleted,
  Value<String?> note,
  Value<int> rowid,
});

class $$ExerciseRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseRecordsTable> {
  $$ExerciseRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dailyRecordId => $composableBuilder(
      column: $table.dailyRecordId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get actualSets => $composableBuilder(
      column: $table.actualSets, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actualReps => $composableBuilder(
      column: $table.actualReps, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actualWeight => $composableBuilder(
      column: $table.actualWeight, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));
}

class $$ExerciseRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseRecordsTable> {
  $$ExerciseRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dailyRecordId => $composableBuilder(
      column: $table.dailyRecordId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get actualSets => $composableBuilder(
      column: $table.actualSets, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actualReps => $composableBuilder(
      column: $table.actualReps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actualWeight => $composableBuilder(
      column: $table.actualWeight,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));
}

class $$ExerciseRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseRecordsTable> {
  $$ExerciseRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dailyRecordId => $composableBuilder(
      column: $table.dailyRecordId, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => column);

  GeneratedColumn<int> get actualSets => $composableBuilder(
      column: $table.actualSets, builder: (column) => column);

  GeneratedColumn<String> get actualReps => $composableBuilder(
      column: $table.actualReps, builder: (column) => column);

  GeneratedColumn<String> get actualWeight => $composableBuilder(
      column: $table.actualWeight, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$ExerciseRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExerciseRecordsTable,
    ExerciseRecord,
    $$ExerciseRecordsTableFilterComposer,
    $$ExerciseRecordsTableOrderingComposer,
    $$ExerciseRecordsTableAnnotationComposer,
    $$ExerciseRecordsTableCreateCompanionBuilder,
    $$ExerciseRecordsTableUpdateCompanionBuilder,
    (
      ExerciseRecord,
      BaseReferences<_$AppDatabase, $ExerciseRecordsTable, ExerciseRecord>
    ),
    ExerciseRecord,
    PrefetchHooks Function()> {
  $$ExerciseRecordsTableTableManager(
      _$AppDatabase db, $ExerciseRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> dailyRecordId = const Value.absent(),
            Value<String> exerciseId = const Value.absent(),
            Value<int> actualSets = const Value.absent(),
            Value<String> actualReps = const Value.absent(),
            Value<String> actualWeight = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExerciseRecordsCompanion(
            id: id,
            dailyRecordId: dailyRecordId,
            exerciseId: exerciseId,
            actualSets: actualSets,
            actualReps: actualReps,
            actualWeight: actualWeight,
            isCompleted: isCompleted,
            note: note,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String dailyRecordId,
            required String exerciseId,
            required int actualSets,
            required String actualReps,
            required String actualWeight,
            Value<bool> isCompleted = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExerciseRecordsCompanion.insert(
            id: id,
            dailyRecordId: dailyRecordId,
            exerciseId: exerciseId,
            actualSets: actualSets,
            actualReps: actualReps,
            actualWeight: actualWeight,
            isCompleted: isCompleted,
            note: note,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExerciseRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExerciseRecordsTable,
    ExerciseRecord,
    $$ExerciseRecordsTableFilterComposer,
    $$ExerciseRecordsTableOrderingComposer,
    $$ExerciseRecordsTableAnnotationComposer,
    $$ExerciseRecordsTableCreateCompanionBuilder,
    $$ExerciseRecordsTableUpdateCompanionBuilder,
    (
      ExerciseRecord,
      BaseReferences<_$AppDatabase, $ExerciseRecordsTable, ExerciseRecord>
    ),
    ExerciseRecord,
    PrefetchHooks Function()>;
typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<int> id,
  Value<String?> currentPlanId,
  Value<int> currentCycleDay,
  Value<DateTime?> lastActiveDate,
  Value<String?> skipHistory,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<int> id,
  Value<String?> currentPlanId,
  Value<int> currentCycleDay,
  Value<DateTime?> lastActiveDate,
  Value<String?> skipHistory,
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
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentPlanId => $composableBuilder(
      column: $table.currentPlanId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentCycleDay => $composableBuilder(
      column: $table.currentCycleDay,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastActiveDate => $composableBuilder(
      column: $table.lastActiveDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get skipHistory => $composableBuilder(
      column: $table.skipHistory, builder: (column) => ColumnFilters(column));
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
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentPlanId => $composableBuilder(
      column: $table.currentPlanId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentCycleDay => $composableBuilder(
      column: $table.currentCycleDay,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastActiveDate => $composableBuilder(
      column: $table.lastActiveDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get skipHistory => $composableBuilder(
      column: $table.skipHistory, builder: (column) => ColumnOrderings(column));
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
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get currentPlanId => $composableBuilder(
      column: $table.currentPlanId, builder: (column) => column);

  GeneratedColumn<int> get currentCycleDay => $composableBuilder(
      column: $table.currentCycleDay, builder: (column) => column);

  GeneratedColumn<DateTime> get lastActiveDate => $composableBuilder(
      column: $table.lastActiveDate, builder: (column) => column);

  GeneratedColumn<String> get skipHistory => $composableBuilder(
      column: $table.skipHistory, builder: (column) => column);
}

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> currentPlanId = const Value.absent(),
            Value<int> currentCycleDay = const Value.absent(),
            Value<DateTime?> lastActiveDate = const Value.absent(),
            Value<String?> skipHistory = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            id: id,
            currentPlanId: currentPlanId,
            currentCycleDay: currentCycleDay,
            lastActiveDate: lastActiveDate,
            skipHistory: skipHistory,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> currentPlanId = const Value.absent(),
            Value<int> currentCycleDay = const Value.absent(),
            Value<DateTime?> lastActiveDate = const Value.absent(),
            Value<String?> skipHistory = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            id: id,
            currentPlanId: currentPlanId,
            currentCycleDay: currentCycleDay,
            lastActiveDate: lastActiveDate,
            skipHistory: skipHistory,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkoutTypesTableTableManager get workoutTypes =>
      $$WorkoutTypesTableTableManager(_db, _db.workoutTypes);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$WorkoutSetsTableTableManager get workoutSets =>
      $$WorkoutSetsTableTableManager(_db, _db.workoutSets);
  $$WorkoutPlansTableTableManager get workoutPlans =>
      $$WorkoutPlansTableTableManager(_db, _db.workoutPlans);
  $$PlanDaysTableTableManager get planDays =>
      $$PlanDaysTableTableManager(_db, _db.planDays);
  $$DayExercisesTableTableManager get dayExercises =>
      $$DayExercisesTableTableManager(_db, _db.dayExercises);
  $$DailyRecordsTableTableManager get dailyRecords =>
      $$DailyRecordsTableTableManager(_db, _db.dailyRecords);
  $$ExerciseRecordsTableTableManager get exerciseRecords =>
      $$ExerciseRecordsTableTableManager(_db, _db.exerciseRecords);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
