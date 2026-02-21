import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/features/training/data/plan_repository.dart';
import 'package:xworkout/core/database/database_provider.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

final planListProvider = StreamProvider<List<WorkoutPlan>>((ref) {
  final repository = ref.watch(workoutPlanRepositoryProvider);
  return repository.watchAllPlans();
});

final activePlanProvider = StreamProvider<WorkoutPlan?>((ref) {
  final repository = ref.watch(workoutPlanRepositoryProvider);
  return repository.watchActivePlan();
});

final planDaysProvider = StreamProvider.family<List<PlanDay>, String>((ref, planId) {
  final repository = ref.watch(workoutPlanRepositoryProvider);
  return repository.watchPlanDays(planId);
});

final dayExercisesProvider = StreamProvider.family<List<DayExercise>, String>((ref, planDayId) {
  final repository = ref.watch(workoutPlanRepositoryProvider);
  return repository.watchDayExercises(planDayId);
});

class PlanNotifier extends StateNotifier<AsyncValue<void>> {
  final WorkoutPlanRepository _repository;
  
  PlanNotifier(this._repository) : super(const AsyncValue.data(null));
  
  Future<String> createPlan({
    required String name,
    required int cycleDays,
  }) async {
    state = const AsyncValue.loading();
    try {
      final planId = const Uuid().v4();
      final plan = WorkoutPlansCompanion(
        id: Value(planId),
        name: Value(name),
        cycleDays: Value(cycleDays),
        isActive: const Value(false),
        startDate: Value(DateTime.now()),
        createdAt: Value(DateTime.now()),
      );
      await _repository.insertPlan(plan);
      
      for (int i = 0; i < cycleDays; i++) {
        final dayId = const Uuid().v4();
        await _repository.insertPlanDay(PlanDaysCompanion(
          id: Value(dayId),
          planId: Value(planId),
          dayIndex: Value(i),
          isRestDay: const Value(false),
        ));
      }
      
      state = const AsyncValue.data(null);
      return planId;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
  
  Future<void> updatePlanDay(PlanDay day) async {
    state = const AsyncValue.loading();
    try {
      final companion = PlanDaysCompanion(
        id: Value(day.id),
        planId: Value(day.planId),
        dayIndex: Value(day.dayIndex),
        isRestDay: Value(day.isRestDay),
        note: Value(day.note),
      );
      await _repository.updatePlanDay(companion);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> setPlanDayAsRest(String planDayId, bool isRest) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updatePlanDayRest(planDayId, isRest);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> addExerciseToDay({
    required String planDayId,
    required String exerciseId,
    required int targetSets,
    required int targetReps,
    double? targetWeight,
  }) async {
    state = const AsyncValue.loading();
    try {
      final exercises = await _repository.getDayExercises(planDayId);
      final dayExercise = DayExercisesCompanion(
        id: Value(const Uuid().v4()),
        planDayId: Value(planDayId),
        exerciseId: Value(exerciseId),
        orderIndex: Value(exercises.length),
        targetSets: Value(targetSets),
        targetReps: Value(targetReps),
        targetWeight: Value(targetWeight),
      );
      await _repository.insertDayExercise(dayExercise);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> removeExerciseFromDay(String dayExerciseId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteDayExercise(dayExerciseId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> activatePlan(String planId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.setActivePlan(planId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> deletePlan(String planId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deletePlanDays(planId);
      await _repository.deletePlan(planId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final planNotifierProvider = StateNotifierProvider<PlanNotifier, AsyncValue<void>>((ref) {
  return PlanNotifier(ref.watch(workoutPlanRepositoryProvider));
});
