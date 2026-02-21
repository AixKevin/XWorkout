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
}
