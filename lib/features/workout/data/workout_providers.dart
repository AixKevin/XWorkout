import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/core/database/database_provider.dart';
import 'package:xworkout/features/workout/data/workout_repository.dart';

// 训练类型Provider
final workoutTypesProvider = StreamProvider<List<WorkoutType>>((ref) {
  return workoutTypeRepositoryProvider.watchAllTypes();
});

// 当前选中的训练类型
final selectedTypeIdProvider = StateProvider<int?>((ref) => null);

// 当前训练会话
final currentSessionProvider = StateProvider<WorkoutSession?>((ref) => null);

// 训练会话列表Provider
final workoutSessionsProvider = StreamProvider<List<WorkoutSession>>((ref) {
  return workoutSessionRepositoryProvider.watchAllSessions();
});

// 根据类型筛选的训练会话
final sessionsByTypeProvider = FutureProvider.family<List<WorkoutSession>, int>((ref, typeId) {
  return workoutSessionRepositoryProvider.getSessionsByType(typeId);
});

// 最后一次同类型训练
final lastSessionByTypeProvider = FutureProvider.family<WorkoutSession?, int>((ref, typeId) {
  return workoutSessionRepositoryProvider.getLastSessionByType(typeId);
});

// 当前会话的训练组
final sessionSetsProvider = StreamProvider.family<List<WorkoutSet>, String>((ref, sessionId) {
  return workoutSetRepositoryProvider.watchSetsBySession(sessionId);
});

// 动作历史记录
final exerciseHistoryProvider = FutureProvider.family<List<WorkoutSet>, String>((ref, exerciseId) {
  return workoutSetRepositoryProvider.getSetsByExercise(exerciseId);
});
