import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/features/training/data/exercise_repository.dart';
import 'package:xworkout/core/database/database_provider.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

final exerciseListProvider = StreamProvider<List<Exercise>>((ref) {
  final repository = ref.watch(exerciseRepositoryProvider);
  return repository.watchAllExercises();
});

final exerciseHistoryProvider = FutureProvider.family<List<ExerciseHistory>, String>((ref, id) {
  final repository = ref.watch(exerciseRepositoryProvider);
  return repository.getExerciseHistory(id);
});

final exerciseMaxWeightProvider = FutureProvider.family<double?, String>((ref, id) {
  final repository = ref.watch(exerciseRepositoryProvider);
  return repository.getMaxWeight(id);
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
    await _updateExercise(
      id: exercise.id,
      name: exercise.name,
      category: exercise.category,
      defaultSets: exercise.defaultSets,
      defaultReps: exercise.defaultReps,
      defaultWeight: exercise.defaultWeight,
      defaultDuration: exercise.defaultDuration,
      note: exercise.note,
      createdAt: exercise.createdAt,
    );
  }
  
  Future<void> updateExerciseWithValues({
    required String id,
    required String name,
    String? category,
    int defaultSets = 3,
    int defaultReps = 10,
    double? defaultWeight,
    int? defaultDuration,
    String? note,
    DateTime? createdAt,
  }) async {
    await _updateExercise(
      id: id,
      name: name,
      category: category,
      defaultSets: defaultSets,
      defaultReps: defaultReps,
      defaultWeight: defaultWeight,
      defaultDuration: defaultDuration,
      note: note,
      createdAt: createdAt,
    );
  }
  
  Future<void> _updateExercise({
    required String id,
    required String name,
    String? category,
    int defaultSets = 3,
    int defaultReps = 10,
    double? defaultWeight,
    int? defaultDuration,
    String? note,
    DateTime? createdAt,
  }) async {
    state = const AsyncValue.loading();
    try {
      final companion = ExercisesCompanion(
        id: Value(id),
        name: Value(name),
        category: Value(category),
        defaultSets: Value(defaultSets),
        defaultReps: Value(defaultReps),
        defaultWeight: Value(defaultWeight),
        defaultDuration: Value(defaultDuration),
        note: Value(note),
        createdAt: Value(createdAt ?? DateTime.now()),
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
