import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Icon;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:xworkout/features/data/data_export_repository.dart';

class DataManagementScreen extends ConsumerStatefulWidget {
  const DataManagementScreen({super.key});

  @override
  ConsumerState<DataManagementScreen> createState() => _DataManagementScreenState();
}

class _DataManagementScreenState extends ConsumerState<DataManagementScreen> {
  bool _isExporting = false;
  bool _isBackingUp = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('数据管理'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 16),
            CupertinoListSection.insetGrouped(
              header: const Text('导出数据'),
              children: [
                CupertinoListTile(
                  leading: Icon(Icons.share),
                  title: const Text('导出为 JSON'),
                  subtitle: const Text('完整的备份格式，可用于恢复数据'),
                  trailing: _isExporting
                      ? const CupertinoActivityIndicator()
                      : const Icon(Icons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                  onTap: _isExporting ? null : () => _exportJson(),
                ),
                CupertinoListTile(
                  leading: Icon(Icons.table_chart),
                  title: const Text('导出为 CSV'),
                  subtitle: const Text('表格格式，方便在 Excel 中查看'),
                  trailing: const Icon(Icons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                  onTap: () => _exportCsv(),
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: const Text('备份'),
              children: [
                CupertinoListTile(
                  leading: Icon(Icons.cloud_download),
                  title: const Text('创建备份'),
                  subtitle: const Text('保存备份文件到本地'),
                  trailing: _isBackingUp
                      ? const CupertinoActivityIndicator()
                      : const Icon(Icons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                  onTap: _isBackingUp ? null : () => _createBackup(),
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: const Text('存储'),
              children: [
                CupertinoListTile(
                  leading: Icon(Icons.folder),
                  title: const Text('查看备份文件夹'),
                  trailing: const Icon(Icons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                  onTap: () => _openBackupFolder(),
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: const Text('危险操作'),
              children: [
                CupertinoListTile(
                  leading: Icon(
                    Icons.delete,
                    color: CupertinoColors.destructiveRed,
                  ),
                  title: Text(
                    '清除所有数据',
                    style: TextStyle(color: CupertinoColors.destructiveRed),
                  ),
                  subtitle: const Text('此操作不可恢复'),
                  trailing: const Icon(Icons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                  onTap: () => _showClearDataDialog(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportJson() async {
    setState(() => _isExporting = true);
    try {
      final repo = ref.read(dataExportRepositoryProvider);
      final json = await repo.exportToJson();
      
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/xworkout_export_$timestamp.json');
      await file.writeAsString(json);
      
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'XWorkout 数据导出',
      );
      
      if (mounted) {
        _showSuccess('JSON 导出成功');
      }
    } catch (e) {
      if (mounted) {
        _showError('导出失败: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _exportCsv() async {
    try {
      final repo = ref.read(dataExportRepositoryProvider);
      final csv = await repo.exportToCsv();
      
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/xworkout_export_$timestamp.csv');
      await file.writeAsString(csv);
      
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'XWorkout 数据导出 (CSV)',
      );
      
      if (mounted) {
        _showSuccess('CSV 导出成功');
      }
    } catch (e) {
      if (mounted) {
        _showError('导出失败: $e');
      }
    }
  }

  Future<void> _createBackup() async {
    setState(() => _isBackingUp = true);
    try {
      final repo = ref.read(dataExportRepositoryProvider);
      final backupPath = await repo.saveBackup();
      
      if (mounted) {
        _showSuccess('备份已保存到:\n$backupPath');
      }
    } catch (e) {
      if (mounted) {
        _showError('备份失败: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isBackingUp = false);
      }
    }
  }

  Future<void> _openBackupFolder() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      await Share.share(directory.path);
    } catch (e) {
      _showError('无法打开文件夹: $e');
    }
  }

  void _showClearDataDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('清除所有数据'),
        content: const Text('确定要清除所有训练数据吗？此操作不可恢复。'),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('清除'),
            onPressed: () {
              Navigator.of(context).pop();
              _clearAllData();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllData() async {
    try {
      _showSuccess('数据清除功能开发中...');
    } catch (e) {
      _showError('操作失败: $e');
    }
  }

  void _showSuccess(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('成功'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('确定'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('错误'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('确定'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
