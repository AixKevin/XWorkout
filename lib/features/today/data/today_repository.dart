import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/core/database/database_provider.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final todayRecordRepositoryProvider = Provider<TodayRecordRepository>((ref) {
  return TodayRecordRepository(databaseProvider);
});

class TodayRecordRepository {
  final AppDatabase _db;
  
  TodayRecordRepository(this._db);
  
  // 计算当前应该显示哪天的计划
  WorkoutPlan? _activePlan;
  List<PlanDay> _planDays = [];
  
  PlanDay? getTodayPlanDay() {
    if (_activePlan == null || _planDays.isEmpty) return null;
    
    final daysSinceStart = DateTime.now().difference(_activePlan!.startDate).inDays;
    final cycleIndex = daysSinceStart % _activePlan!.cycleDays;
    return _planDays.firstWhere(
      (d) => d.dayIndex == cycleIndex,
      orElse: () => _planDays.first,
    );
  }
  
  Future<void> loadActivePlan() async {
    final plans = await (_db.select(_db.workoutPlans)
      ..where((p) => p.isActive.equals(true)))
        .get();
    
    if (plans.isEmpty) {
      _activePlan = null;
      return;
    }
    
    _activePlan = plans.first;
    _planDays = await (_db.select(_db.planDays)
      ..where((d) => d.planId.equals(_activePlan!.id))
      ..orderBy([(d) => OrderingTerm.asc(d.dayIndex)]))
        .get();
  }
  
  Stream<WorkoutPlan?> watchActivePlan() {
    return (_db.select(_db.workoutPlans)
      ..where((p) => p.isActive.equals(true)))
        .watchSingleOrNull();
  }
  
  Future<List<DayExercise>> getTodayExercises(String planDayId) {
    return (_db.select(_db.dayExercises)
      ..where((e) => e.planDayId.equals(planDayId))
      ..orderBy([(e) => OrderingTerm.asc(e.orderIndex)]))
        .get();
  }
  
  Stream<List<DayExercise>> watchTodayExercises(String planDayId) {
    return (_db.select(_db.dayExercises)
      ..where((e) => e.planDayId.equals(planDayId))
      ..orderBy([(e) => OrderingTerm.asc(e.orderIndex)]))
        .watch();
  }
  
  // Daily Record operations
  Future<DailyRecord?> getRecordByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return (_db.select(_db.dailyRecords)
      ..where((r) => r.date.isBetweenValues(startOfDay, endOfDay)))
        .getSingleOrNull();
  }
  
  Stream<DailyRecord?> watchTodayRecord() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return (_db.select(_db.dailyRecords)
      ..where((r) => r.date.isBetweenValues(startOfDay, endOfDay)))
        .watchSingleOrNull();
  }
  
  Future<String> createRecord({
    required DateTime date,
    required String? planDayId,
    required String status,
    String? skipReason,
  }) async {
    final id = const Uuid().v4();
    await _db.into(_db.dailyRecords).insert(DailyRecordsCompanion(
      id: Value(id),
      date: Value(DateTime(date.year, date.month, date.day)),
      planDayId: Value(planDayId),
      status: Value(status),
      skipReason: Value(skipReason),
    ));
    return id;
  }
  
  Future<void> updateRecordStatus(String recordId, String status, {String? skipReason}) {
    return (_db.update(_db.dailyRecords)
      ..where((r) => r.id.equals(recordId)))
        .write(DailyRecordsCompanion(
          status: Value(status),
          skipReason: Value(skipReason),
        ));
  }
  
  // Exercise Record operations
  Future<List<ExerciseRecord>> getExerciseRecords(String dailyRecordId) {
    return (_db.select(_db.exerciseRecords)
      ..where((r) => r.dailyRecordId.equals(dailyRecordId)))
        .get();
  }
  
  Stream<List<ExerciseRecord>> watchExerciseRecords(String dailyRecordId) {
    return (_db.select(_db.exerciseRecords)
      ..where((r) => r.dailyRecordId.equals(dailyRecordId)))
        .watch();
  }
  
  Future<void> saveExerciseRecord(ExerciseRecordsCompanion record) {
    return _db.into(_db.exerciseRecords).insert(record);
  }
  
  Future<void> updateExerciseRecord(ExerciseRecordsCompanion record) {
    return _db.update(_db.exerciseRecords).replace(record);
  }
  
  // 撤销偷懒
  Future<void> undoSkip(String recordId) async {
    await (_db.delete(_db.dailyRecords)..where((r) => r.id.equals(recordId))).go();
  }
  
  // App Settings
  Future<AppSetting?> getSettings() {
    return (_db.select(_db.appSettings)..where((s) => s.id.equals(1)))
        .getSingleOrNull();
  }
  
  Future<void> saveSettings(AppSettingsCompanion settings) async {
    await _db.into(_db.appSettings).insertOnConflictUpdate(settings);
  }
}

String formatDate(DateTime date) {
  return DateFormat('yyyy年M月d日 EEEE', 'zh_CN').format(date);
}
