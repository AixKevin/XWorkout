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
}
