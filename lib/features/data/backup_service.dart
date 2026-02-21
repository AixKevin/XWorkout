import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xworkout/features/data/data_export_repository.dart';

final backupServiceProvider = Provider((ref) => BackupService(ref));

class BackupService {
  final Ref _ref;
  static const String _prefAutoBackup = 'auto_backup';
  static const String _prefLastBackup = 'last_backup_date';
  static const int _maxBackups = 7; // Keep last 7 backups

  BackupService(this._ref);

  Future<void> init() async {
    // Run backup check in background to not block UI
    Future.microtask(() => _checkAndPerformBackup());
  }

  Future<void> _checkAndPerformBackup() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final enabled = prefs.getBool(_prefAutoBackup) ?? false;
      
      if (!enabled) return;

      final lastBackupStr = prefs.getString(_prefLastBackup);
      final todayStr = DateTime.now().toIso8601String().split('T')[0];

      if (lastBackupStr != todayStr) {
        debugPrint('Performing auto-backup for $todayStr...');
        final repo = _ref.read(dataExportRepositoryProvider);
        
        // 1. Save new backup
        await repo.saveBackup();
        
        // 2. Update last backup date
        await prefs.setString(_prefLastBackup, todayStr);
        
        // 3. Cleanup old backups
        await _cleanupOldBackups();
        
        debugPrint('Auto-backup completed successfully.');
      }
    } catch (e) {
      debugPrint('Auto-backup failed: $e');
    }
  }

  Future<void> _cleanupOldBackups() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync()
          .where((f) => f.path.contains('xworkout_backup_') && f.path.endsWith('.json'))
          .toList();

      if (files.length > _maxBackups) {
        // Sort by modification time (oldest first)
        files.sort((a, b) => a.statSync().modified.compareTo(b.statSync().modified));
        
        // Delete oldest files
        final filesToDelete = files.sublist(0, files.length - _maxBackups);
        for (var file in filesToDelete) {
          try {
            file.deleteSync();
            debugPrint('Deleted old backup: ${file.path}');
          } catch (e) {
            debugPrint('Failed to delete old backup: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Backup cleanup failed: $e');
    }
  }
}
