import 'package:drift/drift.dart';

class Exercises extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get category => text().nullable()();
  IntColumn get defaultSets => integer().withDefault(const Constant(3))();
  IntColumn get defaultReps => integer().withDefault(const Constant(10))();
  RealColumn get defaultWeight => real().nullable()();
  IntColumn get defaultDuration => integer().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

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
