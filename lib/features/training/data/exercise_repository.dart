import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:xworkout/core/database/database_provider.dart';

final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  return ExerciseRepository(databaseProvider);
});

class ExerciseRepository {
  final AppDatabase _db;
  
  ExerciseRepository(this._db);
  
  Future<List<Exercise>> getAllExercises() {
    return _db.select(_db.exercises).get();
  }
  
  Stream<List<Exercise>> watchAllExercises() {
    return _db.select(_db.exercises).watch();
  }
  
  Future<Exercise?> getExerciseById(String id) {
    return (_db.select(_db.exercises)..where((e) => e.id.equals(id)))
        .getSingleOrNull();
  }
  
  Future<int> insertExercise(ExercisesCompanion exercise) {
    return _db.into(_db.exercises).insert(exercise);
  }
  
  Future<bool> updateExercise(ExercisesCompanion exercise) {
    return _db.update(_db.exercises).replace(exercise);
  }

  Future<int> deleteExercise(String id) {
    return (_db.delete(_db.exercises)..where((e) => e.id.equals(id))).go();
  }
  
  Future<List<ExerciseHistory>> getExerciseHistory(String exerciseId, {int limit = 5}) async {
    final query = _db.select(_db.exerciseRecords).join([
      innerJoin(_db.dailyRecords, _db.dailyRecords.id.equalsExp(_db.exerciseRecords.dailyRecordId))
    ])
      ..where(_db.exerciseRecords.exerciseId.equals(exerciseId))
      ..orderBy([OrderingTerm.desc(_db.dailyRecords.date)])
      ..limit(limit);

    final result = await query.get();
    
    return result.map((row) {
      final record = row.readTable(_db.exerciseRecords);
      final daily = row.readTable(_db.dailyRecords);
      return ExerciseHistory(
        date: daily.date,
        sets: record.actualSets,
        reps: record.actualReps,
        weight: record.actualWeight,
        note: record.note,
      );
    }).toList();
  }

  Future<double?> getMaxWeight(String exerciseId) async {
    final query = _db.select(_db.exerciseRecords)
      ..where((t) => t.exerciseId.equals(exerciseId));
    
    final records = await query.get();
    double maxWeight = 0;
    bool found = false;
    
    for (final record in records) {
      // Parse weights (handling comma separated or single values)
      final weights = record.actualWeight.split(RegExp(r'[,，]'));
      for (final w in weights) {
        final val = double.tryParse(w.trim());
        if (val != null) {
          if (val > maxWeight) maxWeight = val;
          found = true;
        }
      }
    }
    
    return found ? maxWeight : null;
  }
}

class ExerciseHistory {
  final DateTime date;
  final int sets;
  final String reps;
  final String weight;
  final String? note;

  ExerciseHistory({
    required this.date,
    required this.sets,
    required this.reps,
    required this.weight,
    this.note,
  });
}
