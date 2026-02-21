import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
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
  
  AppDatabase.forMobile() : super(_openConnection());
  
  @override
  int get schemaVersion => 2;
  
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _createIndexes(m);
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await _createIndexes(m);
        }
      },
    );
  }

  Future<void> _createIndexes(Migrator m) async {
    // Indexes for PlanDays
    await customStatement('CREATE INDEX IF NOT EXISTS idx_plan_days_plan_id ON plan_days (plan_id);');
    
    // Indexes for DayExercises
    await customStatement('CREATE INDEX IF NOT EXISTS idx_day_exercises_plan_day_id ON day_exercises (plan_day_id);');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_day_exercises_exercise_id ON day_exercises (exercise_id);');

    // Indexes for DailyRecords
    await customStatement('CREATE INDEX IF NOT EXISTS idx_daily_records_date ON daily_records (date);');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_daily_records_plan_day_id ON daily_records (plan_day_id);');

    // Indexes for ExerciseRecords
    await customStatement('CREATE INDEX IF NOT EXISTS idx_exercise_records_daily_record_id ON exercise_records (daily_record_id);');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_exercise_records_exercise_id ON exercise_records (exercise_id);');
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'xworkout.db'));
    return NativeDatabase.createInBackground(file);
  });
}
