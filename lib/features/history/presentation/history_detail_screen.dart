import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Icon;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:xworkout/core/database/database.dart';
import 'package:xworkout/features/training/presentation/providers/exercise_provider.dart';

class HistoryDetailScreen extends ConsumerWidget {
  final DailyRecord record;
  
  const HistoryDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseAsync = ref.watch(exerciseListProvider);
    
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(DateFormat('MM月dd日', 'zh_CN').format(record.date)),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
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
                        DateFormat('yyyy年M月d日 EEEE', 'zh_CN').format(record.date),
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
            if (record.status == 'skipped' && record.skipReason != null)
              CupertinoListSection.insetGrouped(
                header: const Text('偷懒原因'),
                children: [
                  CupertinoListTile(
                    title: Text(record.skipReason!),
                  ),
                ],
              ),
            
            // Exercise records
            CupertinoListSection.insetGrouped(
              header: const Text('训练记录'),
              children: [
                // This would need to fetch the exercise records for this day
                // For now, showing placeholder
                CupertinoListTile(
                  leading: const Icon(Icons.fitness_center),
                  title: const Text('查看详细记录'),
                  subtitle: const Text('点击查看每组训练数据'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Navigate to exercise detail
                  },
                ),
              ],
            ),
            
            // Note
            if (record.note != null)
              CupertinoListSection.insetGrouped(
                header: const Text('备注'),
                children: [
                  CupertinoListTile(
                    title: Text(record.note!),
                  ),
                ],
              ),
            
            // Actions
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  leading: const Icon(Icons.edit, color: CupertinoColors.activeBlue),
                  title: const Text('编辑记录'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Edit record
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getStatusColor() {
    switch (record.status) {
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
    switch (record.status) {
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
    switch (record.status) {
      case 'completed':
        return '训练完成';
      case 'normal':
        return '已完成';
      case 'skipped':
        return '请假';
      default:
        return record.status;
    }
  }
}
