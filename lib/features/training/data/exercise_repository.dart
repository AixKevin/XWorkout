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
  
  /// Get exercise history from both ExerciseRecords (new system) and WorkoutSets (old system)
  Future<List<ExerciseHistory>> getExerciseHistory(String exerciseId, {int limit = 5}) async {
    final results = <ExerciseHistory>[];
    
    // Query from ExerciseRecords (new system - 今日训练)
    try {
      final newQuery = _db.select(_db.exerciseRecords).join([
        innerJoin(_db.dailyRecords, _db.dailyRecords.id.equalsExp(_db.exerciseRecords.dailyRecordId))
      ])
        ..where(_db.exerciseRecords.exerciseId.equals(exerciseId))
        ..orderBy([OrderingTerm.desc(_db.dailyRecords.date)])
        ..limit(limit);

      final newResult = await newQuery.get();
      for (final row in newResult) {
        final record = row.readTable(_db.exerciseRecords);
        final daily = row.readTable(_db.dailyRecords);
        results.add(ExerciseHistory(
          date: daily.date,
          sets: record.actualSets,
          reps: record.actualReps,
          weight: record.actualWeight,
          note: record.note,
        ));
      }
    } catch (e) {
      // Ignore errors from this table
    }
    
    // Query from WorkoutSets (old system - 训练历史)
    try {
      final oldQuery = _db.select(_db.workoutSets).join([
        innerJoin(_db.workoutSessions, _db.workoutSessions.id.equalsExp(_db.workoutSets.sessionId))
      ])
        ..where(_db.workoutSets.exerciseId.equals(exerciseId))
        ..orderBy([OrderingTerm.desc(_db.workoutSessions.date)])
        ..limit(limit);

      final oldResult = await oldQuery.get();
      for (final row in oldResult) {
        final set = row.readTable(_db.workoutSets);
        final session = row.readTable(_db.workoutSessions);
        results.add(ExerciseHistory(
          date: session.date,
          sets: 1,
          reps: set.reps.toString(),
          weight: set.weight,
          note: null,
        ));
      }
    } catch (e) {
      // Ignore errors from this table
    }
    
    // Sort by date descending and limit
    results.sort((a, b) => b.date.compareTo(a.date));
    return results.take(limit).toList();
  }

  /// Get max weight from both ExerciseRecords and WorkoutSets
  Future<double?> getMaxWeight(String exerciseId) async {
    double maxWeight = 0;
    bool found = false;
    
    // Check ExerciseRecords (new system)
    try {
      final newQuery = _db.select(_db.exerciseRecords)
        ..where((t) => t.exerciseId.equals(exerciseId));
      
      final newRecords = await newQuery.get();
      for (final record in newRecords) {
        final weights = record.actualWeight.split(RegExp(r'[,，]'));
        for (final w in weights) {
          final val = double.tryParse(w.trim());
          if (val != null && val > 0) {
            if (val > maxWeight) maxWeight = val;
            found = true;
          }
        }
      }
    } catch (e) {
      // Ignore errors
    }
    
    // Check WorkoutSets (old system)
    try {
      final oldQuery = _db.select(_db.workoutSets)
        ..where((t) => t.exerciseId.equals(exerciseId));
      
      final oldRecords = await oldQuery.get();
      for (final set in oldRecords) {
        final weights = set.weight.split(RegExp(r'[,，]'));
        for (final w in weights) {
          final val = double.tryParse(w.trim());
          if (val != null && val > 0) {
            if (val > maxWeight) maxWeight = val;
            found = true;
          }
        }
      }
    } catch (e) {
      // Ignore errors
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
