import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xworkout/features/data/data_export_repository.dart';

class DataManagementScreen extends ConsumerStatefulWidget {
  const DataManagementScreen({super.key});

  @override
  ConsumerState<DataManagementScreen> createState() => _DataManagementScreenState();
}

class _DataManagementScreenState extends ConsumerState<DataManagementScreen> {
  bool _isExporting = false;
  bool _isImporting = false;
  bool _autoBackupEnabled = false;
  
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _autoBackupEnabled = prefs.getBool('auto_backup') ?? false;
    });
  }

  Future<void> _toggleAutoBackup(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_backup', value);
    setState(() {
      _autoBackupEnabled = value;
    });
  }

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
            
            // Export Filter Section
            CupertinoListSection.insetGrouped(
              header: const Text('导出选项'),
              children: [
                CupertinoListTile(
                  leading: const Icon(PhosphorIcons.calendar),
                  title: const Text('日期范围'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _startDate == null 
                          ? '全部' 
                          : '${_startDate!.toString().split(' ')[0]} - ${_endDate?.toString().split(' ')[0] ?? '至今'}',
                        style: const TextStyle(color: CupertinoColors.systemGrey),
                      ),
                      const Icon(material.Icons.chevron_right, color: CupertinoColors.systemGrey3, size: 20),
                    ],
                  ),
                  onTap: _pickDateRange,
                ),
              ],
            ),

            CupertinoListSection.insetGrouped(
              header: const Text('导出数据'),
              children: [
                CupertinoListTile(
                  leading: const Icon(PhosphorIcons.fileCsv),
                  title: const Text('导出为 CSV'),
                  subtitle: const Text('表格格式，方便分析'),
                  trailing: _isExporting
                      ? const CupertinoActivityIndicator()
                      : const Icon(material.Icons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                  onTap: _isExporting ? null : () => _exportCsv(),
                ),
                CupertinoListTile(
                  leading: const Icon(PhosphorIcons.filePdf),
                  title: const Text('导出 PDF 报告'),
                  subtitle: const Text('生成训练摘要报告'),
                  trailing: _isExporting
                      ? const CupertinoActivityIndicator()
                      : const Icon(material.Icons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                  onTap: _isExporting ? null : () => _exportPdf(),
                ),
                CupertinoListTile(
                  leading: const Icon(PhosphorIcons.shareNetwork),
                  title: const Text('导出 JSON 备份'),
                  subtitle: const Text('完整数据备份'),
                  trailing: _isExporting
                      ? const CupertinoActivityIndicator()
                      : const Icon(material.Icons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                  onTap: _isExporting ? null : () => _exportJson(),
                ),
              ],
            ),
            
            CupertinoListSection.insetGrouped(
              header: const Text('导入与还原'),
              children: [
                CupertinoListTile(
                  leading: const Icon(PhosphorIcons.uploadSimple),
                  title: const Text('从备份导入'),
                  subtitle: const Text('支持 JSON 格式'),
                  trailing: _isImporting
                      ? const CupertinoActivityIndicator()
                      : const Icon(material.Icons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                  onTap: _isImporting ? null : () => _importBackup(),
                ),
              ],
            ),
            
            CupertinoListSection.insetGrouped(
              header: const Text('危险操作'),
              children: [
                CupertinoListTile(
                  leading: Icon(
                    material.Icons.delete,
                    color: CupertinoColors.destructiveRed,
                  ),
                  title: Text(
                    '清除所有数据',
                    style: TextStyle(color: CupertinoColors.destructiveRed),
                  ),
                  trailing: const Icon(material.Icons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                  onTap: () => _showClearDataDialog(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final picked = await material.showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null 
          ? material.DateTimeRange(start: _startDate!, end: _endDate!) 
          : null,
      builder: (context, child) {
        return material.Theme(
          data: material.ThemeData.light().copyWith(
            colorScheme: material.ColorScheme.light(
              primary: CupertinoColors.activeBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  ExportOptions get _currentOptions => ExportOptions(
    startDate: _startDate,
    endDate: _endDate,
  );
  
  // ... rest of the methods remain same but need to check for Icons usage
  
  Future<void> _exportJson() async {
    setState(() => _isExporting = true);
    try {
      final repo = ref.read(dataExportRepositoryProvider);
      final json = await repo.exportToJson(options: _currentOptions);
      
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/xworkout_backup_$timestamp.json');
      await file.writeAsString(json);
      
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'XWorkout 备份',
      );
      
      if (mounted) {
        _showSuccess('导出成功');
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
    setState(() => _isExporting = true);
    try {
      final repo = ref.read(dataExportRepositoryProvider);
      final csv = await repo.exportToCsv(options: _currentOptions);
      
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/xworkout_export_$timestamp.csv');
      await file.writeAsString(csv);
      
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'XWorkout 数据导出 (CSV)',
      );
      
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

  Future<void> _exportPdf() async {
    setState(() => _isExporting = true);
    try {
      final repo = ref.read(dataExportRepositoryProvider);
      final file = await repo.exportToPdf(options: _currentOptions);
      
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'XWorkout 训练报告 (PDF)',
      );
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

  Future<void> _importBackup() async {
    setState(() => _isImporting = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final repo = ref.read(dataExportRepositoryProvider);
        
        // Confirm dialog
        final confirmed = await showCupertinoDialog<bool>(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('确认导入'),
            content: const Text('导入数据将合并到当前记录中。建议在导入前先备份当前数据。'),
            actions: [
              CupertinoDialogAction(
                child: const Text('取消'),
                onPressed: () => Navigator.pop(context, false),
              ),
              CupertinoDialogAction(
                child: const Text('导入'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          await repo.importFromJson(file);
          if (mounted) {
            _showSuccess('数据导入成功');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        _showError('导入失败: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isImporting = false);
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
    _showSuccess('数据清除功能开发中...');
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
