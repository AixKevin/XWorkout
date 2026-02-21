import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:xworkout/core/database/database.dart';
import 'package:xworkout/features/history/data/history_repository.dart';

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
                    Icon(CupertinoIcons.book, size: 64, color: CupertinoColors.systemGrey),
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
      statusIcon = CupertinoIcons.nosign;
      statusText = '请假';
    } else if (isCompleted) {
      statusColor = CupertinoColors.activeGreen;
      statusIcon = CupertinoIcons.check_mark_circled_solid;
      statusText = '完成';
    } else {
      statusColor = CupertinoColors.systemGrey;
      statusIcon = CupertinoIcons.circle;
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
      trailing: const CupertinoListTileChevron(),
      onTap: () {
        // TODO: Navigate to detail
      },
    );
  }
}
