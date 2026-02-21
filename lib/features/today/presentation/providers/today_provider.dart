import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

final lastExerciseRecordProvider = FutureProvider.family<ExerciseRecord?, String>((ref, exerciseId) {
  final repository = ref.watch(todayRecordRepositoryProvider);
  return repository.getLastExerciseRecord(exerciseId);
});

final personalRecordProvider = FutureProvider.family<double, String>((ref, exerciseId) {
  final repository = ref.watch(todayRecordRepositoryProvider);
  return repository.getPersonalRecord(exerciseId);
});

final workoutDurationProvider = StateNotifierProvider<WorkoutDurationNotifier, Duration>((ref) {
  return WorkoutDurationNotifier();
});

class WorkoutDurationNotifier extends StateNotifier<Duration> {
  Timer? _timer;
  static const String _startTimeKey = 'workout_start_time';
  
  WorkoutDurationNotifier() : super(Duration.zero) {
    _restoreStartTime();
  }
  
  Future<void> _restoreStartTime() async {
    final prefs = await SharedPreferences.getInstance();
    final startTimeStr = prefs.getString(_startTimeKey);
    if (startTimeStr != null) {
      final startTime = DateTime.parse(startTimeStr);
      final diff = DateTime.now().difference(startTime);
      if (diff.inHours < 12) { // Only restore if less than 12 hours ago (avoid stale workouts)
        state = diff;
        _startTimer(startTime);
      } else {
        await prefs.remove(_startTimeKey);
      }
    }
  }
  
  Future<void> start() async {
    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_startTimeKey, now.toIso8601String());
    state = Duration.zero;
    _startTimer(now);
  }
  
  void _startTimer(DateTime startTime) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = DateTime.now().difference(startTime);
    });
  }
  
  Future<void> stop() async {
    _timer?.cancel();
    _timer = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_startTimeKey);
    state = Duration.zero;
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class TodayNotifier extends StateNotifier<AsyncValue<void>> {
  final TodayRecordRepository _repository;
  final Ref _ref;
  
  TodayNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));
  
  Future<String?> startTraining(String planDayId) async {
    state = const AsyncValue.loading();
    try {
      final recordId = await _repository.createRecord(
        date: DateTime.now(),
        planDayId: planDayId,
        status: 'normal',
      );
      
      // Start duration timer
      await _ref.read(workoutDurationProvider.notifier).start();
      
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
  
  Future<void> completeTraining(String planDayId) async {
    state = const AsyncValue.loading();
    try {
      // Find today's record and mark as completed
      final record = await _repository.getRecordByDate(DateTime.now());
      if (record != null) {
        await _repository.updateRecordStatus(record.id, 'completed');
      }
      
      // Stop duration timer
      await _ref.read(workoutDurationProvider.notifier).stop();
      
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
    String? note,
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
        note: Value(note),
      );
      await _repository.saveExerciseRecord(record);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final todayNotifierProvider = StateNotifierProvider<TodayNotifier, AsyncValue<void>>((ref) {
  return TodayNotifier(ref.watch(todayRecordRepositoryProvider), ref);
});

// 计算今天是周期的第几天

int calculateCycleDay(WorkoutPlan plan) {
  final now = DateTime.now();
  final startDate = DateTime(plan.startDate.year, plan.startDate.month, plan.startDate.day);
  final today = DateTime(now.year, now.month, now.day);
  
  // 计算从开始日期到今天的天数
  final daysSinceStart = today.difference(startDate).inDays;
  
  // 如果开始日期在今天之后，返回第1天
  if (daysSinceStart < 0) {
    return 1;
  }
  
  // 如果是开始日期当天，返回第1天
  if (daysSinceStart == 0) {
    return 1;
  }
  
  // 计算周期中的第几天 (1 到 cycleDays)
  return (daysSinceStart % plan.cycleDays) + 1;
}
