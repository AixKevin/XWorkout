import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:xworkout/core/database/database.dart';
import 'package:xworkout/core/database/database_provider.dart';
import 'package:drift/drift.dart' hide Column;

class DataExportRepository {
  final AppDatabase _db;
  
  DataExportRepository(this._db);
  
  Future<Map<String, dynamic>> exportAllData() async {
    final exercises = await _db.select(_db.exercises).get();
    final plans = await _db.select(_db.workoutPlans).get();
    final planDays = await _db.select(_db.planDays).get();
    final dayExercises = await _db.select(_db.dayExercises).get();
    final dailyRecords = await _db.select(_db.dailyRecords).get();
    final exerciseRecords = await _db.select(_db.exerciseRecords).get();
    
    return {
      'version': '1.0',
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
  
  Future<String> exportToJson() async {
    final data = await exportAllData();
    return const JsonEncoder.withIndent('  ').convert(data);
  }
  
  Future<String> exportToCsv() async {
    final buffer = StringBuffer();
    
    final exercises = await _db.select(_db.exercises).get();
    buffer.writeln('Exercise ID,Name,Category,Default Sets,Default Reps,Default Weight,Created At');
    for (var e in exercises) {
      buffer.writeln('${e.id},${e.name},${e.category ?? ''},${e.defaultSets},${e.defaultReps},${e.defaultWeight ?? ''},${e.createdAt.toIso8601String()}');
    }
    
    final dailyRecords = await _db.select(_db.dailyRecords).get();
    buffer.writeln();
    buffer.writeln('Daily Record ID,Date,Plan Day ID,Status,Skip Reason,Note');
    for (var r in dailyRecords) {
      buffer.writeln('${r.id},${r.date.toIso8601String()},${r.planDayId ?? ''},${r.status},${r.skipReason ?? ''},${r.note ?? ''}');
    }
    
    return buffer.toString();
  }
  
  Future<String> saveBackup() async {
    final json = await exportToJson();
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/xworkout_backup_$timestamp.json');
    await file.writeAsString(json);
    return file.path;
  }
}

final dataExportRepositoryProvider = Provider<DataExportRepository>((ref) {
  return DataExportRepository(databaseProvider);
});
