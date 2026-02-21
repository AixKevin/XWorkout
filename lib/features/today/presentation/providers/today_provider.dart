import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/features/today/data/today_repository.dart';
import 'package:xworkout/features/training/data/plan_repository.dart';
import 'package:xworkout/core/database/database_provider.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

final todayActivePlanProvider = StreamProvider<WorkoutPlan?>((ref) {
  final repository = ref.watch(todayRecordRepositoryProvider);
  return repository.watchActivePlan();
});

final todayPlanDaysProvider = StreamProvider.family<List<PlanDay>, String>((ref, planId) {
  final repository = ref.watch(workoutPlanRepositoryProvider);
  return repository.watchPlanDays(planId);
});

final todayDayExercisesProvider = StreamProvider.family<List<DayExercise>, String>((ref, planDayId) {
  final repository = ref.watch(todayRecordRepositoryProvider);
  return repository.watchTodayExercises(planDayId);
});

final todayRecordProvider = StreamProvider<DailyRecord?>((ref) {
  final repository = ref.watch(todayRecordRepositoryProvider);
  return repository.watchTodayRecord();
});

final todayExerciseRecordsProvider = StreamProvider.family<List<ExerciseRecord>, String>((ref, dailyRecordId) {
  final repository = ref.watch(todayRecordRepositoryProvider);
  return repository.watchExerciseRecords(dailyRecordId);
});

class TodayNotifier extends StateNotifier<AsyncValue<void>> {
  final TodayRecordRepository _repository;
  
  TodayNotifier(this._repository) : super(const AsyncValue.data(null));
  
  Future<String?> startTraining(String planDayId) async {
    state = const AsyncValue.loading();
    try {
      final recordId = await _repository.createRecord(
        date: DateTime.now(),
        planDayId: planDayId,
        status: 'normal',
      );
      state = const AsyncValue.data(null);
      return recordId;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
  
  Future<void> skipTraining(String? recordId, String reason) async {
    state = const AsyncValue.loading();
    try {
      if (recordId != null) {
        await _repository.updateRecordStatus(recordId, 'skipped', skipReason: reason);
      } else {
        await _repository.createRecord(
          date: DateTime.now(),
          planDayId: null,
          status: 'skipped',
          skipReason: reason,
        );
      }
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> undoSkip(String recordId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.undoSkip(recordId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> saveExerciseRecord({
    required String dailyRecordId,
    required String exerciseId,
    required int actualSets,
    required List<int> actualReps,
    required List<double?> actualWeight,
  }) async {
    state = const AsyncValue.loading();
    try {
      final record = ExerciseRecordsCompanion(
        id: Value(const Uuid().v4()),
        dailyRecordId: Value(dailyRecordId),
        exerciseId: Value(exerciseId),
        actualSets: Value(actualSets),
        actualReps: Value(actualReps.join(',')),
        actualWeight: Value(actualWeight.map((w) => w?.toString() ?? '').join(',')),
        isCompleted: const Value(true),
      );
      await _repository.saveExerciseRecord(record);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final todayNotifierProvider = StateNotifierProvider<TodayNotifier, AsyncValue<void>>((ref) {
  return TodayNotifier(ref.watch(todayRecordRepositoryProvider));
});

// 计算今天是周期的第几天
int calculateCycleDay(WorkoutPlan plan) {
  final daysSinceStart = DateTime.now().difference(plan.startDate).inDays;
  return (daysSinceStart % plan.cycleDays) + 1;
}
