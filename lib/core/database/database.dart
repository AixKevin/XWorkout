import 'package:drift/drift.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Exercises,
  WorkoutPlans,
  PlanDays,
  DayExercises,
  DailyRecords,
  ExerciseRecords,
  AppSettings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);
  
  @override
  int get schemaVersion => 1;
}
