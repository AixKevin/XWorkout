// Version 2.7.0 implementation verified by Sisyphus-Junior
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:xworkout/core/database/database.dart';
import 'package:xworkout/core/database/database_provider.dart';
import 'package:drift/drift.dart' hide Column;

class ExportOptions {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String>? exerciseIds;
  final bool includePlans;
  final bool includeRecords;

  ExportOptions({
    this.startDate,
    this.endDate,
    this.exerciseIds,
    this.includePlans = true,
    this.includeRecords = true,
  });
}

class DataExportRepository {
  final AppDatabase _db;
  
  DataExportRepository(this._db);
  
  Future<Map<String, dynamic>> exportData({ExportOptions? options}) async {
    // Determine scope based on options
    final startDate = options?.startDate;
    final endDate = options?.endDate;
    final exerciseIds = options?.exerciseIds;
    final includePlans = options?.includePlans ?? true;
    final includeRecords = options?.includeRecords ?? true;

    // Fetch Base Data
    List<Exercise> exercises = [];
    if (exerciseIds != null) {
      exercises = await (_db.select(_db.exercises)..where((t) => t.id.isIn(exerciseIds))).get();
    } else {
      exercises = await _db.select(_db.exercises).get();
    }

    List<WorkoutPlan> plans = [];
    List<PlanDay> planDays = [];
    List<DayExercise> dayExercises = [];
    if (includePlans) {
      plans = await _db.select(_db.workoutPlans).get();
      planDays = await _db.select(_db.planDays).get();
      dayExercises = await _db.select(_db.dayExercises).get();
    }

    List<DailyRecord> dailyRecords = [];
    List<ExerciseRecord> exerciseRecords = [];
    if (includeRecords) {
      var query = _db.select(_db.dailyRecords);
      if (startDate != null) {
        query = query..where((t) => t.date.isBiggerOrEqualValue(startDate));
      }
      if (endDate != null) {
        query = query..where((t) => t.date.isSmallerOrEqualValue(endDate));
      }
      dailyRecords = await query.get();

      // Fetch related exercise records
      if (dailyRecords.isNotEmpty) {
        final dailyRecordIds = dailyRecords.map((e) => e.id).toList();
        var recordQuery = _db.select(_db.exerciseRecords)..where((t) => t.dailyRecordId.isIn(dailyRecordIds));
        
        if (exerciseIds != null) {
           recordQuery = recordQuery..where((t) => t.exerciseId.isIn(exerciseIds));
        }
        
        exerciseRecords = await recordQuery.get();
      }
    }
    
    return {
      'version': '2.0',
      'exportDate': DateTime.now().toIso8601String(),
      'exercises': exercises.map((e) => {
        'id': e.id,
        'name': e.name,
        'category': e.category,
        'defaultSets': e.defaultSets,
        'defaultReps': e.defaultReps,
        'defaultWeight': e.defaultWeight,
        'defaultDuration': e.defaultDuration,
        'note': e.note,
        'createdAt': e.createdAt.toIso8601String(),
      }).toList(),
      'workoutPlans': plans.map((p) => {
        'id': p.id,
        'name': p.name,
        'cycleDays': p.cycleDays,
        'isActive': p.isActive,
        'startDate': p.startDate.toIso8601String(),
        'createdAt': p.createdAt.toIso8601String(),
      }).toList(),
      'planDays': planDays.map((d) => {
        'id': d.id,
        'planId': d.planId,
        'dayIndex': d.dayIndex,
        'isRestDay': d.isRestDay,
        'note': d.note,
      }).toList(),
      'dayExercises': dayExercises.map((e) => {
        'id': e.id,
        'planDayId': e.planDayId,
        'exerciseId': e.exerciseId,
        'orderIndex': e.orderIndex,
        'targetSets': e.targetSets,
        'targetReps': e.targetReps,
        'targetWeight': e.targetWeight,
      }).toList(),
      'dailyRecords': dailyRecords.map((r) => {
        'id': r.id,
        'date': r.date.toIso8601String(),
        'planDayId': r.planDayId,
        'status': r.status,
        'skipReason': r.skipReason,
        'note': r.note,
      }).toList(),
      'exerciseRecords': exerciseRecords.map((r) => {
        'id': r.id,
        'dailyRecordId': r.dailyRecordId,
        'exerciseId': r.exerciseId,
        'actualSets': r.actualSets,
        'actualReps': r.actualReps,
        'actualWeight': r.actualWeight,
        'isCompleted': r.isCompleted,
        'note': r.note,
      }).toList(),
    };
  }
  
  // Backward compatibility alias
  Future<Map<String, dynamic>> exportAllData() => exportData();

  Future<String> exportToJson({ExportOptions? options}) async {
    final data = await exportData(options: options);
    return const JsonEncoder.withIndent('  ').convert(data);
  }
  
  Future<String> exportToCsv({ExportOptions? options}) async {
    final data = await exportData(options: options);
    final exercises = (data['exercises'] as List).cast<Map<String, dynamic>>();
    final dailyRecords = (data['dailyRecords'] as List).cast<Map<String, dynamic>>();
    final exerciseRecords = (data['exerciseRecords'] as List).cast<Map<String, dynamic>>();

    final buffer = StringBuffer();
    
    // Exercises Section
    buffer.writeln('--- EXERCISES ---');
    List<List<dynamic>> exerciseRows = [];
    exerciseRows.add(['ID', 'Name', 'Category', 'Def Sets', 'Def Reps', 'Def Weight', 'Created']);
    for (var e in exercises) {
      exerciseRows.add([
        e['id'], e['name'], e['category'] ?? '', e['defaultSets'], e['defaultReps'], e['defaultWeight'] ?? '', e['createdAt']
      ]);
    }
    // Simple CSV generation fallback if library fails, but try library first
    // buffer.write(const ListToCsvConverter().convert(exerciseRows));
    // Manual Implementation to avoid package issues
    for (var row in exerciseRows) {
      buffer.writeln(row.map((e) => '"${e.toString().replaceAll('"', '""')}"').join(','));
    }
    buffer.writeln('\n');

    // Daily Records Section
    buffer.writeln('--- DAILY RECORDS ---');
    List<List<dynamic>> dailyRows = [];
    dailyRows.add(['ID', 'Date', 'Plan Day ID', 'Status', 'Skip Reason', 'Note']);
    for (var r in dailyRecords) {
      dailyRows.add([
        r['id'], r['date'], r['planDayId'] ?? '', r['status'], r['skipReason'] ?? '', r['note'] ?? ''
      ]);
    }
    for (var row in dailyRows) {
      buffer.writeln(row.map((e) => '"${e.toString().replaceAll('"', '""')}"').join(','));
    }
    buffer.writeln('\n');

    // Exercise Records Section
    buffer.writeln('--- EXERCISE LOGS ---');
    List<List<dynamic>> logRows = [];
    logRows.add(['ID', 'Daily Record ID', 'Exercise ID', 'Sets', 'Reps', 'Weight', 'Completed', 'Note']);
    for (var r in exerciseRecords) {
      logRows.add([
        r['id'], r['dailyRecordId'], r['exerciseId'], r['actualSets'], r['actualReps'], r['actualWeight'], r['isCompleted'], r['note'] ?? ''
      ]);
    }
    for (var row in logRows) {
      buffer.writeln(row.map((e) => '"${e.toString().replaceAll('"', '""')}"').join(','));
    }
    
    return buffer.toString();
  }

  Future<File> exportToPdf({ExportOptions? options}) async {
    final data = await exportData(options: options);
    final exercises = (data['exercises'] as List).cast<Map<String, dynamic>>();
    final dailyRecords = (data['dailyRecords'] as List).cast<Map<String, dynamic>>();
    final exerciseRecords = (data['exerciseRecords'] as List).cast<Map<String, dynamic>>();

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('XWorkout Data Export', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Paragraph(text: 'Export Date: ${DateTime.now().toString().split('.')[0]}'),
            pw.Paragraph(
              text: 'Note: This report currently supports English characters. Chinese characters may not render correctly.',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
            ),
            pw.SizedBox(height: 20),
            
            pw.Header(level: 1, child: pw.Text('Summary')),
            pw.Bullet(text: 'Total Exercises: ${exercises.length}'),
            pw.Bullet(text: 'Total Workout Days: ${dailyRecords.length}'),
            pw.Bullet(text: 'Total Sets Completed: ${exerciseRecords.where((r) => r['isCompleted'] == true).length}'),
            
            pw.SizedBox(height: 20),
            pw.Header(level: 1, child: pw.Text('Recent Activity')),
            pw.TableHelper.fromTextArray(
              context: context,
              headers: ['Date', 'Status', 'Note'],
              data: dailyRecords.take(20).map((r) => [
                r['date'].toString().split('T')[0],
                r['status'].toString(),
                r['note']?.toString() ?? '-'
              ]).toList(),
            ),
          ];
        },
      ),
    );

    final directory = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/xworkout_report_$timestamp.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
  
  Future<String> saveBackup() async {
    final json = await exportToJson();
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/xworkout_backup_$timestamp.json');
    await file.writeAsString(json);
    return file.path;
  }

  Future<bool> importFromJson(File file) async {
    try {
      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      
      await _db.transaction(() async {
        // 1. Exercises
        final exercises = (data['exercises'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        for (var e in exercises) {
          await _db.into(_db.exercises).insertOnConflictUpdate(
            ExercisesCompanion.insert(
              id: e['id'],
              name: e['name'],
              category: Value(e['category']),
              defaultSets: Value(e['defaultSets'] ?? 3),
              defaultReps: Value(e['defaultReps']),
              defaultWeight: Value(e['defaultWeight']),
              defaultDuration: Value(e['defaultDuration']),
              note: Value(e['note']),
              createdAt: DateTime.parse(e['createdAt']),
            )
          );
        }

        // 2. Plans
        final plans = (data['workoutPlans'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        for (var p in plans) {
          await _db.into(_db.workoutPlans).insertOnConflictUpdate(
            WorkoutPlansCompanion.insert(
              id: p['id'],
              name: p['name'],
              cycleDays: p['cycleDays'],
              isActive: Value(p['isActive'] ?? false),
              startDate: DateTime.parse(p['startDate']),
              createdAt: DateTime.parse(p['createdAt']),
            )
          );
        }

        // 3. Plan Days
        final planDays = (data['planDays'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        for (var d in planDays) {
          await _db.into(_db.planDays).insertOnConflictUpdate(
            PlanDaysCompanion.insert(
              id: d['id'],
              planId: d['planId'],
              dayIndex: d['dayIndex'],
              isRestDay: Value(d['isRestDay'] ?? false),
              note: Value(d['note']),
            )
          );
        }

        // 4. Day Exercises
        final dayExercises = (data['dayExercises'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        for (var de in dayExercises) {
          await _db.into(_db.dayExercises).insertOnConflictUpdate(
            DayExercisesCompanion.insert(
              id: de['id'],
              planDayId: de['planDayId'],
              exerciseId: de['exerciseId'],
              orderIndex: de['orderIndex'],
              targetSets: de['targetSets'] as int? ?? 3,
              targetReps: de['targetReps'] as int,
              targetWeight: Value((de['targetWeight'] as num?)?.toDouble()),
            )
          );
        }

        // 5. Daily Records
        final dailyRecords = (data['dailyRecords'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        for (var dr in dailyRecords) {
          await _db.into(_db.dailyRecords).insertOnConflictUpdate(
            DailyRecordsCompanion.insert(
              id: dr['id'],
              date: DateTime.parse(dr['date']),
              planDayId: Value(dr['planDayId']),
              status: dr['status'] as String,
              skipReason: Value(dr['skipReason'] as String?),
              note: Value(dr['note'] as String?),
            )
          );
        }

        // 6. Exercise Records
        final exerciseRecords = (data['exerciseRecords'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        for (var er in exerciseRecords) {
          await _db.into(_db.exerciseRecords).insertOnConflictUpdate(
            ExerciseRecordsCompanion.insert(
              id: er['id'],
              dailyRecordId: er['dailyRecordId'],
              exerciseId: er['exerciseId'],
              actualSets: er['actualSets'] as int? ?? 0,
              actualReps: er['actualReps'] as String,
              actualWeight: er['actualWeight'] as String,
              isCompleted: Value(er['isCompleted'] as bool? ?? false),
              note: Value(er['note'] as String?),
            )
          );
        }
      });
      
      return true;
    } catch (e) {
      debugPrint('Import failed: $e');
      rethrow;
    }
  }
}

final dataExportRepositoryProvider = Provider<DataExportRepository>((ref) {
  return DataExportRepository(databaseProvider);
});
