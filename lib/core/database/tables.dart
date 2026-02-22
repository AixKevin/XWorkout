import 'package:drift/drift.dart';

// 训练类型表
class WorkoutTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 20)(); // '胸部', '背部', '腿部'
  TextColumn get icon => text().withDefault(const Constant('fitness_center'))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

// 动作表
class Exercises extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get typeId => integer().nullable().references(WorkoutTypes, #id)(); // 关联训练类型 (新)
  TextColumn get category => text().nullable()(); // 分类 (兼容旧)
  IntColumn get defaultSets => integer().withDefault(const Constant(3))();
  IntColumn get defaultReps => integer().withDefault(const Constant(10))();
  RealColumn get defaultWeight => real().nullable()(); // 兼容旧
  IntColumn get defaultDuration => integer().nullable()(); // 兼容旧
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// 训练会话表
class WorkoutSessions extends Table {
  TextColumn get id => text()();
  IntColumn get typeId => integer().references(WorkoutTypes, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('completed'))(); // 'completed', 'in_progress'
  DateTimeColumn get createdAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// 训练组表（重量字段改为 text）
class WorkoutSets extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text().references(WorkoutSessions, #id)();
  TextColumn get exerciseId => text().references(Exercises, #id)();
  IntColumn get setNumber => integer()(); // 组序号
  TextColumn get weight => text().withDefault(const Constant(''))(); // 重量文本，支持任意格式
  IntColumn get reps => integer().withDefault(const Constant(0))(); // 次数
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  
  @override
  Set<Column> get primaryKey => {id};
}

// ============ 兼容旧表（保留但不使用）============

class WorkoutPlans extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get cycleDays => integer()();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

class PlanDays extends Table {
  TextColumn get id => text()();
  TextColumn get planId => text()();
  IntColumn get dayIndex => integer()();
  BoolColumn get isRestDay => boolean().withDefault(const Constant(false))();
  TextColumn get note => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

class DayExercises extends Table {
  TextColumn get id => text()();
  TextColumn get planDayId => text()();
  TextColumn get exerciseId => text()();
  IntColumn get orderIndex => integer()();
  IntColumn get targetSets => integer()();
  IntColumn get targetReps => integer()();
  RealColumn get targetWeight => real().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

class DailyRecords extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get planDayId => text().nullable()();
  TextColumn get status => text()();
  TextColumn get skipReason => text().nullable()();
  TextColumn get note => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

class ExerciseRecords extends Table {
  TextColumn get id => text()();
  TextColumn get dailyRecordId => text()();
  TextColumn get exerciseId => text()();
  IntColumn get actualSets => integer()();
  TextColumn get actualReps => text()();
  TextColumn get actualWeight => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get note => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

class AppSettings extends Table {
  IntColumn get id => integer()();
  TextColumn get currentPlanId => text().nullable()();
  IntColumn get currentCycleDay => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastActiveDate => dateTime().nullable()();
  TextColumn get skipHistory => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}
