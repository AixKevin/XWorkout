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

  // 5. Top Exercises (Most frequent)
  Future<List<Map<String, dynamic>>> getTopExercises(int limit) async {
    final query = _db.select(_db.exerciseRecords).join([
      innerJoin(_db.exercises, _db.exercises.id.equalsExp(_db.exerciseRecords.exerciseId))
    ]);
    
    final result = await (query
      ..addColumns([_db.exercises.name, _db.exercises.id, _db.exerciseRecords.id.count()])
      ..groupBy([_db.exercises.id, _db.exercises.name])
      ..orderBy([OrderingTerm(expression: _db.exerciseRecords.id.count(), mode: OrderingMode.desc)])
      ..limit(limit)
    ).get();

    return result.map((row) {
      return {
        'name': row.read(_db.exercises.name),
        'id': row.read(_db.exercises.id),
        'count': row.read(_db.exerciseRecords.id.count()),
      };
    }).toList();
  }

  // 6. Exercise Stats (Volume & Max Weight)
  Future<Map<String, dynamic>> getExerciseStats(String exerciseId) async {
    final records = await (_db.select(_db.exerciseRecords)
      ..where((t) => t.exerciseId.equals(exerciseId))
    ).join([
      innerJoin(_db.dailyRecords, _db.dailyRecords.id.equalsExp(_db.exerciseRecords.dailyRecordId))
    ]).get();

    // Sort by date
    records.sort((a, b) {
      final dateA = a.read(_db.dailyRecords.date)!;
      final dateB = b.read(_db.dailyRecords.date)!;
      return dateA.compareTo(dateB);
    });

    double maxWeight = 0;
    double totalVolume = 0;
    final volumeTrend = <Map<String, dynamic>>[];
    final maxWeightTrend = <Map<String, dynamic>>[];

    for (final row in records) {
      final record = row.readTable(_db.exerciseRecords);
      final date = row.readTable(_db.dailyRecords).date;

      final repsList = record.actualReps.split(',').map((e) => int.tryParse(e) ?? 0).toList();
      final weightList = record.actualWeight.split(',').map((e) => double.tryParse(e) ?? 0.0).toList();

      double dailyVolume = 0;
      double dailyMaxWeight = 0;

      for (int i = 0; i < repsList.length; i++) {
        final reps = repsList[i];
        final weight = i < weightList.length ? weightList[i] : 0.0;
        
        if (weight > maxWeight) maxWeight = weight;
        if (weight > dailyMaxWeight) dailyMaxWeight = weight;

        dailyVolume += (weight > 0 ? reps * weight : reps);
      }
      totalVolume += dailyVolume;

      volumeTrend.add({'date': date, 'value': dailyVolume});
      maxWeightTrend.add({'date': date, 'value': dailyMaxWeight});
    }

    return {
      'maxWeight': maxWeight,
      'totalVolume': totalVolume,
      'volumeTrend': volumeTrend,
      'maxWeightTrend': maxWeightTrend,
      'count': records.length,
    };
  }

  // 7. Weekly Goal (Default 3 workouts/week)
  Future<Map<String, dynamic>> getWeeklyGoalProgress({int target = 3}) async {
    final count = await getThisWeekWorkouts();
    return {
      'current': count,
      'target': target,
      'progress': (count / target).clamp(0.0, 1.0),
    };
  }

  // 8. Body Weight Trend
  Future<List<Map<String, dynamic>>> getBodyWeightTrend() async {
    final records = await (_db.select(_db.dailyRecords)
      ..where((t) => t.note.isNotNull())
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.asc)])
    ).get();

    final trend = <Map<String, dynamic>>[];
    final regex = RegExp(r'(?:weight|体重)[:\s]*(\d+(\.\d+)?)', caseSensitive: false);

    for (final record in records) {
      if (record.note == null) continue;
      
      final match = regex.firstMatch(record.note!);
      if (match != null) {
        final weightStr = match.group(1);
        if (weightStr != null) {
          final weight = double.tryParse(weightStr);
          if (weight != null) {
            trend.add({
              'date': record.date,
              'weight': weight,
            });
          }
        }
      }
    }
    return trend;
  }
}
