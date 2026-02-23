import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Colors;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:xworkout/core/database/database.dart';
import 'package:xworkout/features/training/presentation/providers/exercise_provider.dart';
import 'package:xworkout/features/today/data/today_repository.dart';
import 'package:xworkout/features/today/presentation/providers/today_provider.dart';
import 'package:xworkout/core/database/database_provider.dart';
import 'package:xworkout/core/database/database.dart';
import 'package:drift/drift.dart' show Value;

final exerciseRecordsProvider = StreamProvider.family<List<ExerciseRecord>, String>((ref, dailyRecordId) {
  final repository = ref.watch(todayRecordRepositoryProvider);
  return repository.watchExerciseRecords(dailyRecordId);
});

class HistoryDetailScreen extends ConsumerStatefulWidget {
  final DailyRecord record;
  
  const HistoryDetailScreen({super.key, required this.record});

  @override
  ConsumerState<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends ConsumerState<HistoryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final exerciseAsync = ref.watch(exerciseListProvider);
    final exerciseRecordsAsync = ref.watch(exerciseRecordsProvider(widget.record.id));
    
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(DateFormat('MM月dd日', 'zh_CN').format(widget.record.date)),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('返回'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _showDeleteDialog(context),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            // Status header
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getStatusColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _getStatusIcon(),
                    color: _getStatusColor(),
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStatusText(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(),
                        ),
                      ),
                      Text(
                        DateFormat('yyyy年M月d日 EEEE', 'zh_CN').format(widget.record.date),
                        style: const TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Skip reason if skipped
            if (widget.record.status == 'skipped' && widget.record.skipReason != null)
              CupertinoListSection.insetGrouped(
                header: const Text('偷懒原因'),
                children: [
                  CupertinoListTile(
                    title: Text(widget.record.skipReason!),
                  ),
                ],
              ),
            
            // Exercise records
            CupertinoListSection.insetGrouped(
              header: const Text('训练记录'),
              children: exerciseRecordsAsync.when(
                data: (records) {
                  if (records.isEmpty) {
                    return [
                      const CupertinoListTile(
                        leading: const Icon(Icons.grid_view),
                        title: Text('暂无记录'),
                      ),
                    ];
                  }
                  return records.map((record) {
                    return exerciseAsync.when(
                      data: (exercises) {
                        final exercise = exercises.firstWhere(
                          (e) => e.id == record.exerciseId,
                          orElse: () => exercises.first,
                        );
                        return CupertinoListTile(
                          leading: const Icon(Icons.grid_view),
                          title: Text(exercise.name),
                          subtitle: Text('${record.actualSets}组 - ${record.actualReps}次 ${record.actualWeight.isNotEmpty ? record.actualWeight.split(',').where((w) => w.isNotEmpty).map((w) => '${w}kg').join(' / ') : ''}'),
                          trailing: const Icon(CupertinoIcons.chevron_right),
                        );
                      },
                      loading: () => const CupertinoListTile(
                        title: Text('加载中...'),
                      ),
                      error: (_, __) => const CupertinoListTile(
                        title: Text('加载失败'),
                      ),
                    );
                  }).toList();
                },
                loading: () => [
                  const CupertinoListTile(
                    title: Text('加载中...'),
                  ),
                ],
                error: (_, __) => [
                  const CupertinoListTile(
                    title: Text('加载失败'),
                  ),
                ],
              ),
            ),
            
            // Note
            if (widget.record.note != null)
              CupertinoListSection.insetGrouped(
                header: const Text('备注'),
                children: [
                  CupertinoListTile(
                    title: Text(widget.record.note!),
                  ),
                ],
              ),
            
            // Actions
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  leading: const Icon(Icons.edit, color: Colors.blue),
                  title: const Text('编辑记录'),
                  trailing: const Icon(CupertinoIcons.chevron_right),
                  onTap: () {
                    _showEditDialog(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _showDeleteDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('删除记录'),
        content: const Text('确定要删除这条训练记录吗？此操作不可恢复。'),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('删除'),
            onPressed: () async {
              Navigator.of(context).pop(); // Close dialog
              await _deleteRecord();
              // Use a slight delay to ensure the dialog is fully closed
              await Future.delayed(const Duration(milliseconds: 100));
              if (mounted) {
                Navigator.of(context).pop(); // Go back to history list
              }
            },
          ),
        ],
      ),
    );
  }
  
  Future<void> _deleteRecord() async {
    final db = databaseProvider;
    await (db.delete(db.exerciseRecords)..where((t) => t.dailyRecordId.equals(widget.record.id))).go();
    await (db.delete(db.dailyRecords)..where((t) => t.id.equals(widget.record.id))).go();
  }
  
  void _showEditDialog(BuildContext context) {
    final noteController = TextEditingController(text: widget.record.note ?? '');
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('编辑备注'),
        content: Column(
          children: [
            const SizedBox(height: 12),
            CupertinoTextField(
              controller: noteController,
              placeholder: '添加备注',
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            child: const Text('保存'),
            onPressed: () async {
              Navigator.of(context).pop();
              final db = databaseProvider;
              await (db.update(db.dailyRecords)
                ..where((t) => t.id.equals(widget.record.id)))
                .write(DailyRecordsCompanion(note: Value(noteController.text.trim())));
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
  
  Color _getStatusColor() {
    switch (widget.record.status) {
      case 'completed':
        return CupertinoColors.activeGreen;
      case 'normal':
        return CupertinoColors.activeGreen;
      case 'skipped':
        return CupertinoColors.systemRed;
      default:
        return CupertinoColors.systemGrey;
    }
  }
  
  IconData _getStatusIcon() {
    switch (widget.record.status) {
      case 'completed':
        return Icons.check_circle;
      case 'normal':
        return Icons.check_circle;
      case 'skipped':
        return Icons.cancel;
      default:
        return Icons.radio_button_unchecked;
    }
  }
  
  String _getStatusText() {
    switch (widget.record.status) {
      case 'completed':
        return '训练完成';
      case 'normal':
        return '已完成';
      case 'skipped':
        return '请假';
      default:
        return widget.record.status;
    }
  }
}
