import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/core/database/database_provider.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

final workoutPlanRepositoryProvider = Provider<WorkoutPlanRepository>((ref) {
  return WorkoutPlanRepository(databaseProvider);
});

class WorkoutPlanRepository {
  final AppDatabase _db;
  
  WorkoutPlanRepository(this._db);
  
  Future<List<WorkoutPlan>> getAllPlans() {
    return _db.select(_db.workoutPlans).get();
  }
  
  Stream<List<WorkoutPlan>> watchAllPlans() {
    return _db.select(_db.workoutPlans).watch();
  }
  
  Stream<WorkoutPlan?> watchActivePlan() {
    return (_db.select(_db.workoutPlans)
      ..where((p) => p.isActive.equals(true)))
        .watchSingleOrNull();
  }
  
  Future<WorkoutPlan?> getPlanById(String id) {
    return (_db.select(_db.workoutPlans)..where((p) => p.id.equals(id)))
        .getSingleOrNull();
  }
  
  Future<int> insertPlan(WorkoutPlansCompanion plan) {
    return _db.into(_db.workoutPlans).insert(plan);
  }
  
  Future<bool> updatePlan(WorkoutPlansCompanion plan) {
    return _db.update(_db.workoutPlans).replace(plan);
  }
  
  Future<int> deletePlan(String id) {
    return (_db.delete(_db.workoutPlans)..where((p) => p.id.equals(id))).go();
  }
  
  Future<void> setActivePlan(String planId) async {
    await _db.transaction(() async {
      await _db.update(_db.workoutPlans)
          .write(const WorkoutPlansCompanion(isActive: Value(false)));
      await (_db.update(_db.workoutPlans)
            ..where((p) => p.id.equals(planId)))
          .write(const WorkoutPlansCompanion(isActive: Value(true)));
    });
  }
  
  Future<void> deactivatePlan() async {
    await _db.update(_db.workoutPlans)
        .write(const WorkoutPlansCompanion(isActive: Value(false)));
  }
  
  Future<void> updatePlanStartDate(String planId, DateTime startDate) async {
    await (_db.update(_db.workoutPlans)
          ..where((p) => p.id.equals(planId)))
        .write(WorkoutPlansCompanion(startDate: Value(startDate)));
  }
  
  // PlanDay operations
  Future<List<PlanDay>> getPlanDays(String planId) {
    return (_db.select(_db.planDays)
      ..where((d) => d.planId.equals(planId))
      ..orderBy([(d) => OrderingTerm.asc(d.dayIndex)]))
        .get();
  }
  
  Stream<List<PlanDay>> watchPlanDays(String planId) {
    return (_db.select(_db.planDays)
      ..where((d) => d.planId.equals(planId))
      ..orderBy([(d) => OrderingTerm.asc(d.dayIndex)]))
        .watch();
  }
  
  Future<int> insertPlanDay(PlanDaysCompanion day) {
    return _db.into(_db.planDays).insert(day);
  }
  
  Future<int> updatePlanDay(PlanDaysCompanion day) {
    return (_db.update(_db.planDays)..where((d) => d.id.equals(day.id.value)))
        .write(day);
  }
  
  Future<int> updatePlanDayRest(String planDayId, bool isRest) {
    return (_db.update(_db.planDays)..where((d) => d.id.equals(planDayId)))
        .write(PlanDaysCompanion(isRestDay: Value(isRest)));
  }
  
  Future<void> deletePlanDays(String planId) {
    return (_db.delete(_db.planDays)..where((d) => d.planId.equals(planId))).go();
  }
  
  // DayExercise operations
  Future<List<DayExercise>> getDayExercises(String planDayId) {
    return (_db.select(_db.dayExercises)
      ..where((e) => e.planDayId.equals(planDayId))
      ..orderBy([(e) => OrderingTerm.asc(e.orderIndex)]))
        .get();
  }
  
  Stream<List<DayExercise>> watchDayExercises(String planDayId) {
    return (_db.select(_db.dayExercises)
      ..where((e) => e.planDayId.equals(planDayId))
      ..orderBy([(e) => OrderingTerm.asc(e.orderIndex)]))
        .watch();
  }
  
  Future<int> insertDayExercise(DayExercisesCompanion dayExercise) {
    return _db.into(_db.dayExercises).insert(dayExercise);
  }
  
  Future<int> deleteDayExercise(String id) {
    return (_db.delete(_db.dayExercises)..where((e) => e.id.equals(id))).go();
  }
  
  Future<void> deleteDayExercises(String planDayId) {
    return (_db.delete(_db.dayExercises)..where((e) => e.planDayId.equals(planDayId))).go();
  }
  
  Future<String> duplicatePlan(String planId) async {
    return _db.transaction(() async {
      final originalPlan = await getPlanById(planId);
      if (originalPlan == null) throw Exception('Plan not found');

      final newPlanId = const Uuid().v4();
      final newPlan = originalPlan.toCompanion(true).copyWith(
        id: Value(newPlanId),
        name: Value('${originalPlan.name} (Copy)'),
        isActive: const Value(false),
        createdAt: Value(DateTime.now()),
      );
      
      await insertPlan(newPlan);

      final originalDays = await getPlanDays(planId);
      for (final day in originalDays) {
        final newDayId = const Uuid().v4();
        final newDay = day.toCompanion(true).copyWith(
          id: Value(newDayId),
          planId: Value(newPlanId),
        );
        await insertPlanDay(newDay);

        final exercises = await getDayExercises(day.id);
        for (final exercise in exercises) {
          final newExercise = exercise.toCompanion(true).copyWith(
            id: Value(const Uuid().v4()),
            planDayId: Value(newDayId),
          );
          await insertDayExercise(newExercise);
        }
      }
      return newPlanId;
    });
  }

  Future<Map<String, dynamic>> getPlanCompletionStats(String planId) async {
    final plan = await getPlanById(planId);
    if (plan == null) return {'completed': 0, 'total': 0, 'rate': 0.0};

    final planDays = await getPlanDays(planId);
    if (planDays.isEmpty) return {'completed': 0, 'total': 0, 'rate': 0.0};

    // Calculate completed sessions from DailyRecords
    // Join DailyRecords with PlanDays to filter by planId
    final query = _db.select(_db.dailyRecords).join([
      innerJoin(
        _db.planDays,
        _db.planDays.id.equalsExp(_db.dailyRecords.planDayId),
      ),
    ]);
    
    // Check if status is normal or completed
    query.where(_db.planDays.planId.equals(planId) & 
                (_db.dailyRecords.status.isIn(['normal', 'completed'])));
    
    final completedRecords = await query.get();
    final completedCount = completedRecords.length;

    // Calculate total expected sessions
    int expectedCount = 0;
    final now = DateTime.now();
    // Normalize dates to midnight to avoid time issues
    final startDate = DateTime(plan.startDate.year, plan.startDate.month, plan.startDate.day);
    final today = DateTime(now.year, now.month, now.day);
    
    if (today.isBefore(startDate)) {
       return {'completed': 0, 'total': 0, 'rate': 0.0};
    }

    // Iterate day by day from start date to today
    for (var date = startDate; 
         date.isBefore(today) || date.isAtSameMomentAs(today); 
         date = date.add(const Duration(days: 1))) {
      
      final dayDiff = date.difference(startDate).inDays;
      final dayIndex = dayDiff % plan.cycleDays;
      
      final planDay = planDays.firstWhere(
        (d) => d.dayIndex == dayIndex, 
        orElse: () => planDays.first
      );
      
      if (!planDay.isRestDay) {
        expectedCount++;
      }
    }

    // Ensure total is at least completed count (in case of extra records)
    final totalCount = expectedCount > completedCount ? expectedCount : completedCount;
    
    final rate = totalCount == 0 ? 0.0 : (completedCount / totalCount);

    return {
      'completed': completedCount,
      'total': totalCount,
      'rate': rate,
    };
  }
}
