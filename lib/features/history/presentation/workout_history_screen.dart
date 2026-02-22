import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Colors;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:xworkout/core/database/database_provider.dart';
import 'package:xworkout/features/workout/data/workout_providers.dart';
import 'package:xworkout/features/workout/data/workout_repository.dart';
import 'package:xworkout/features/training/presentation/providers/exercise_provider.dart';

// 筛选类型Provider
final historyFilterProvider = StateProvider<int?>((ref) => null);

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(workoutSessionsProvider);
    final typesAsync = ref.watch(workoutTypesProvider);
    final filterTypeId = ref.watch(historyFilterProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('训练历史'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 类型筛选
            typesAsync.when(
              data: (types) => _FilterChips(
                types: types,
                selectedId: filterTypeId,
                onSelected: (id) {
                  ref.read(historyFilterProvider.notifier).state = id;
                },
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            // 历史列表
            Expanded(
              child: sessionsAsync.when(
                data: (sessions) {
                  // 筛选
                  final filtered = filterTypeId != null
                      ? sessions.where((s) => s.typeId == filterTypeId).toList()
                      : sessions;

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('暂无训练记录', style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 8),
                          Text('开始你的第一次训练吧！', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final session = filtered[index];
                      return typesAsync.when(
                        data: (types) {
                          final type = types.where((t) => t.id == session.typeId).firstOrNull;
                          return _SessionCard(
                            session: session,
                            typeName: type?.name ?? '训练',
                            onTap: () => _showSessionDetail(context, session),
                            onDelete: () => _deleteSession(context, ref, session),
                          );
                        },
                        loading: () => _SessionCard(
                          session: session,
                          typeName: '加载中...',
                          onTap: () {},
                          onDelete: () {},
                        ),
                        error: (_, __) => _SessionCard(
                          session: session,
                          typeName: '训练',
                          onTap: () {},
                          onDelete: () {},
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CupertinoActivityIndicator()),
                error: (e, _) => Center(child: Text('错误: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSessionDetail(BuildContext context, WorkoutSession session) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => _SessionDetailScreen(session: session),
      ),
    );
  }

  void _deleteSession(BuildContext context, WidgetRef ref, WorkoutSession session) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('删除记录'),
        content: const Text('确定要删除这条训练记录吗？'),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('删除'),
            onPressed: () async {
              Navigator.pop(context);
              await workoutSessionRepositoryProvider.deleteSession(session.id);
            },
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final List<WorkoutType> types;
  final int? selectedId;
  final Function(int?) onSelected;

  const _FilterChips({
    required this.types,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _Chip(
            label: '全部',
            isSelected: selectedId == null,
            onTap: () => onSelected(null),
          ),
          ...types.map((type) => _Chip(
            label: type.name,
            isSelected: selectedId == type.id,
            onTap: () => onSelected(type.id),
          )),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        color: isSelected ? Colors.blue : Colors.grey[200],
        minSize: 32,
        borderRadius: BorderRadius.circular(16),
        onPressed: onTap,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final WorkoutSession session;
  final String typeName;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SessionCard({
    required this.session,
    required this.typeName,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MM月dd日 EEEE', 'zh_CN').format(session.date);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: CupertinoColors.systemGrey5),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: CupertinoColors.activeBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.grid_view, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      typeName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateStr,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    if (session.note != null && session.note!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        session.note!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 32,
                child: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: onDelete,
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionDetailScreen extends ConsumerWidget {
  final WorkoutSession session;

  const _SessionDetailScreen({required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setsAsync = ref.watch(sessionSetsProvider(session.id));
    final exercisesAsync = ref.watch(exerciseListProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(DateFormat('MM月dd日', 'zh_CN').format(session.date)),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(Icons.delete),
          onPressed: () => _showDeleteDialog(context, ref),
        ),
      ),
      child: SafeArea(
        child: setsAsync.when(
          data: (sets) {
            // 按动作分组
            final grouped = <String, List<WorkoutSet>>{};
            for (final set in sets) {
              grouped.putIfAbsent(set.exerciseId, () => []).add(set);
            }

            if (grouped.isEmpty) {
              return const Center(child: Text('暂无训练数据'));
            }

            return exercisesAsync.when(
              data: (exercises) => ListView(
                padding: const EdgeInsets.all(16),
                children: grouped.entries.map((entry) {
                  final exerciseId = entry.key;
                  final exercise = exercises.where((e) => e.id == exerciseId).firstOrNull;
                  return _ExerciseDetailCard(
                    exerciseName: exercise?.name ?? '未知动作',
                    sets: entry.value,
                  );
                }).toList(),
              ),
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (e, _) => Center(child: Text('错误: $e')),
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (e, _) => Center(child: Text('错误: $e')),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('删除记录'),
        content: const Text('确定要删除这条训练记录吗？'),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('删除'),
            onPressed: () async {
              Navigator.pop(context);
              await workoutSessionRepositoryProvider.deleteSession(session.id);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ExerciseDetailCard extends StatelessWidget {
  final String exerciseName;
  final List<WorkoutSet> sets;

  const _ExerciseDetailCard({
    required this.exerciseName,
    required this.sets,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exerciseName,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...sets.map((set) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Text(
                    '${set.setNumber}.',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${set.weight.isEmpty ? "-" : set.weight} × ${set.reps}次',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
