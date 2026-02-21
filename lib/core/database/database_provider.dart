import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'database.dart';

export 'database.dart' show AppDatabase, Exercise, ExercisesCompanion, WorkoutPlan, WorkoutPlansCompanion, PlanDay, PlanDaysCompanion, DayExercise, DayExercisesCompanion, DailyRecord, DailyRecordsCompanion, ExerciseRecord, ExerciseRecordsCompanion, AppSetting, AppSettingsCompanion;

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'xworkout.db'));
    return NativeDatabase.createInBackground(file);
  });
}

final databaseProvider = AppDatabase.forMobile();
