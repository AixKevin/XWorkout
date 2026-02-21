import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/features/training/data/exercise_repository.dart';
import 'package:xworkout/core/database/database_provider.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

final exerciseListProvider = StreamProvider<List<Exercise>>((ref) {
  final repository = ref.watch(exerciseRepositoryProvider);
  return repository.watchAllExercises();
});

class ExerciseNotifier extends StateNotifier<AsyncValue<void>> {
  final ExerciseRepository _repository;
  
  ExerciseNotifier(this._repository) : super(const AsyncValue.data(null));
  
  Future<void> addExercise({
    required String name,
    String? category,
    int defaultSets = 3,
    int defaultReps = 10,
    double? defaultWeight,
    int? defaultDuration,
    String? note,
  }) async {
    state = const AsyncValue.loading();
    try {
      final exercise = ExercisesCompanion(
        id: Value(const Uuid().v4()),
        name: Value(name),
        category: Value(category),
        defaultSets: Value(defaultSets),
        defaultReps: Value(defaultReps),
        defaultWeight: Value(defaultWeight),
        defaultDuration: Value(defaultDuration),
        note: Value(note),
        createdAt: Value(DateTime.now()),
      );
      await _repository.insertExercise(exercise);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> updateExercise(Exercise exercise) async {
    state = const AsyncValue.loading();
    try {
      final companion = ExercisesCompanion(
        id: Value(exercise.id),
        name: Value(exercise.name),
        category: Value(exercise.category),
        defaultSets: Value(exercise.defaultSets),
        defaultReps: Value(exercise.defaultReps),
        defaultWeight: Value(exercise.defaultWeight),
        defaultDuration: Value(exercise.defaultDuration),
        note: Value(exercise.note),
        createdAt: Value(exercise.createdAt),
      );
      await _repository.updateExercise(companion);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> deleteExercise(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteExercise(id);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final exerciseNotifierProvider = StateNotifierProvider<ExerciseNotifier, AsyncValue<void>>((ref) {
  return ExerciseNotifier(ref.watch(exerciseRepositoryProvider));
});
