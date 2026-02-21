import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:xworkout/core/database/database.dart';
import 'package:xworkout/features/training/data/exercise_repository.dart';
import 'package:xworkout/features/training/presentation/exercise_form_screen.dart';
import 'package:xworkout/features/training/presentation/providers/exercise_provider.dart';

class ExerciseDetailScreen extends ConsumerWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(exerciseHistoryProvider(exercise.id));
    final maxWeightAsync = ref.watch(exerciseMaxWeightProvider(exercise.id));

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(exercise.name),
        previousPageTitle: '返回',
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('编辑'),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => ExerciseFormScreen(exercise: exercise),
              ),
            );
          },
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (exercise.category != null)
                      _buildInfoRow('分类', exercise.category!),
                    _buildInfoRow('默认设置', 
                      '${exercise.defaultSets}组 × ${exercise.defaultReps}次'
                      '${exercise.defaultWeight != null ? ' ${exercise.defaultWeight}kg' : ''}'),
                    if (exercise.note != null && exercise.note!.isNotEmpty)
                      _buildInfoRow('备注', exercise.note!),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildStatCard(
                      '最佳表现',
                      maxWeightAsync.when(
                        data: (weight) => weight != null ? '${weight}kg' : '暂无记录',
                        loading: () => '加载中...',
                        error: (_, __) => '错误',
                      ),
                      CupertinoColors.systemYellow,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '最近记录',
                  style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                ),
              ),
            ),
            historyAsync.when(
              data: (history) {
                if (history.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        '暂无训练记录',
                        style: TextStyle(color: CupertinoColors.systemGrey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final record = history[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemBackground,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: CupertinoColors.systemGrey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('yyyy-MM-dd').format(record.date),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Text('重量: ${record.weight}kg'),
                                ),
                                Expanded(
                                  child: Text('次数: ${record.reps}'),
                                ),
                                Text('${record.sets}组'),
                              ],
                            ),
                            if (record.note != null && record.note!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  '备注: ${record.note}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: CupertinoColors.systemGrey,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                    childCount: history.length,
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CupertinoActivityIndicator()),
              ),
              error: (error, _) => SliverToBoxAdapter(
                child: Center(child: Text('加载失败: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: CupertinoColors.systemGrey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: color.withOpacity(0.8), // darker shade
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color, // primary color
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
