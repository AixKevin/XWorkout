import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/core/database/database_provider.dart';
import 'package:drift/drift.dart';

final statisticsRepositoryProvider = Provider<StatisticsRepository>((ref) {
  return StatisticsRepository(databaseProvider);
});

class StatisticsRepository {
  final AppDatabase _db;

  StatisticsRepository(this._db);

  // 1. Total Workouts
  Future<int> getTotalWorkouts() async {
    final count = await (_db.selectOnly(_db.dailyRecords)
      ..addColumns([_db.dailyRecords.id.count()])
      ..where(_db.dailyRecords.status.equals('normal'))
    ).map((row) => row.read(_db.dailyRecords.id.count())).getSingle();
    return count ?? 0;
  }

  // 2. This Week Workouts
  Future<int> getThisWeekWorkouts() async {
    final now = DateTime.now();
    // Monday of this week
    final startOfWeek = DateTime(now.year, now.month, now.day - (now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    final count = await (_db.selectOnly(_db.dailyRecords)
      ..addColumns([_db.dailyRecords.id.count()])
      ..where(_db.dailyRecords.status.equals('normal') & 
              _db.dailyRecords.date.isBetweenValues(startOfWeek, endOfWeek))
    ).map((row) => row.read(_db.dailyRecords.id.count())).getSingle();
    return count ?? 0;
  }

  // 3. Streak (Consecutive days)
  Future<int> getCurrentStreak() async {
    final records = await (_db.select(_db.dailyRecords)
      ..where((tbl) => tbl.status.equals('normal'))
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
    ).get();

    if (records.isEmpty) return 0;

    int streak = 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Most recent workout date
    final lastRecordDate = DateTime(records.first.date.year, records.first.date.month, records.first.date.day);
    
    // Check if the last workout was today or yesterday. If older, streak is broken.
    final diff = today.difference(lastRecordDate).inDays;
    if (diff > 1) return 0; 

    streak = 1;
    DateTime currentDay = lastRecordDate;
    
    // Iterate through records to find consecutive days
    for (int i = 1; i < records.length; i++) {
       final nextRecordDate = DateTime(records[i].date.year, records[i].date.month, records[i].date.day);
       
       if (currentDay.difference(nextRecordDate).inDays == 1) {
         streak++;
         currentDay = nextRecordDate;
       } else if (currentDay.difference(nextRecordDate).inDays == 0) {
         // Same day, skip
         continue;
       } else {
         // Gap > 1 day, break
         break;
       }
    }
    return streak;
  }

  // 4. Trend Data (Last 30 days volume)
  Future<List<Map<String, dynamic>>> getVolumeTrend(int days) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));

    // Get daily records in range
    final dailyRecords = await (_db.select(_db.dailyRecords)
      ..where((r) => r.status.equals('normal') & r.date.isBetweenValues(startDate, endDate))
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.asc)])
    ).get();

    final result = <Map<String, dynamic>>[];

    for (final record in dailyRecords) {
      // Get exercise records for this day
      final exercises = await (_db.select(_db.exerciseRecords)
        ..where((e) => e.dailyRecordId.equals(record.id))
      ).get();

      double dailyVolume = 0;
      for (final ex in exercises) {
        final repsList = ex.actualReps.split(',').map((e) => int.tryParse(e) ?? 0).toList();
        final weightList = ex.actualWeight.split(',').map((e) => double.tryParse(e) ?? 0.0).toList();

        for (int i = 0; i < repsList.length; i++) {
          final reps = repsList[i];
          final weight = i < weightList.length ? weightList[i] : 0.0;
          // Volume = reps * weight. If weight is 0 (bodyweight), maybe count reps? 
          // For now, if weight is 0, we just use reps as volume (as a proxy).
          dailyVolume += (weight > 0 ? reps * weight : reps); 
        }
      }

      result.add({
        'date': record.date,
        'volume': dailyVolume,
      });
    }

    return result;
  }
}
