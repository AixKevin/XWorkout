import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Icon;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:xworkout/core/database/database.dart';
import 'package:xworkout/features/history/data/history_repository.dart';
import 'package:xworkout/features/history/presentation/history_detail_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyStreamProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('历史记录'),
      ),
      child: SafeArea(
        child: historyAsync.when(
          data: (records) {
            if (records.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.book, size: 64, color: CupertinoColors.systemGrey),
                    SizedBox(height: 16),
                    Text('暂无训练记录', style: TextStyle(color: CupertinoColors.systemGrey)),
                  ],
                ),
              );
            }

            // 按月份分组
            final grouped = <String, List<DailyRecord>>{};
            for (var record in records) {
              final month = DateFormat('yyyy年M月', 'zh_CN').format(record.date);
              if (!grouped.containsKey(month)) {
                grouped[month] = [];
              }
              grouped[month]!.add(record);
            }

            return CustomScrollView(
              slivers: grouped.entries.map((entry) {
                return SliverToBoxAdapter(
                  child: CupertinoListSection.insetGrouped(
                    header: Text(entry.key),
                    children: entry.value.map((record) {
                      return _HistoryItem(record: record);
                    }).toList(),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (error, stack) => Center(child: Text('加载失败: $error')),
        ),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final DailyRecord record;

  const _HistoryItem({required this.record});

  @override
  Widget build(BuildContext context) {
    final isCompleted = record.status == 'normal' || record.status == 'completed';
    final isSkipped = record.status == 'skipped';
    
    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (isSkipped) {
      statusColor = CupertinoColors.systemRed;
      statusIcon = Icons.cancel;
      statusText = '请假';
    } else if (isCompleted) {
      statusColor = CupertinoColors.activeGreen;
      statusIcon = Icons.check_circle;
      statusText = '完成';
    } else {
      statusColor = CupertinoColors.systemGrey;
      statusIcon = Icons.radio_button_unchecked;
      statusText = record.status;
    }

    return CupertinoListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(statusIcon, color: statusColor, size: 20),
      ),
      title: Text(
        DateFormat('MM月dd日 EEEE', 'zh_CN').format(record.date),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        isSkipped ? (record.skipReason ?? '无理由') : statusText,
        style: TextStyle(
          color: isSkipped ? CupertinoColors.systemRed : CupertinoColors.secondaryLabel,
          fontSize: 13,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => HistoryDetailScreen(record: record),
          ),
        );
      },
    );
  }
}
