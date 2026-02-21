import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/features/training/presentation/providers/plan_provider.dart';
import 'package:xworkout/features/training/presentation/providers/exercise_provider.dart';
import 'package:xworkout/core/database/database.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PlanDetailScreen extends ConsumerWidget {
  final String planId;
  
  const PlanDetailScreen({super.key, required this.planId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(planListProvider);
    final planDaysAsync = ref.watch(planDaysProvider(planId));
    
    final plan = planAsync.valueOrNull?.firstWhere(
      (p) => p.id == planId,
      orElse: () => throw Exception('Plan not found'),
    );
    
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(plan?.name ?? '计划详情'),
        trailing: plan != null
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(
                  plan.isActive ? '已激活' : '激活',
                  style: TextStyle(
                    color: plan.isActive 
                        ? CupertinoColors.activeGreen 
                        : CupertinoColors.activeBlue,
                  ),
                ),
                onPressed: () {
                  if (plan.isActive) {
                    _showDeactivateDialog(context, ref, plan);
                  } else {
                    ref.read(planNotifierProvider.notifier).activatePlan(planId);
                  }
                },
              )
            : null,
      ),
      child: SafeArea(
        child: planDaysAsync.when(
          data: (days) {
            return ListView.builder(
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                return _DayDetailTile(
                  planId: planId,
                  day: day,
                  dayNumber: index + 1,
                );
              },
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (error, stack) => Center(
            child: Text('加载失败: $error'),
          ),
        ),
      ),
    );
  }
  
  void _showDeactivateDialog(BuildContext context, WidgetRef ref, WorkoutPlan plan) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('取消激活'),
        content: Text('确定要取消激活"${plan.name}"吗？'),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('确认'),
            onPressed: () {
              ref.read(planNotifierProvider.notifier).deactivatePlan();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class _DayDetailTile extends ConsumerWidget {
  final String planId;
  final PlanDay day;
  final int dayNumber;
  
  const _DayDetailTile({
    required this.planId,
    required this.day,
    required this.dayNumber,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(dayExercisesProvider(day.id));
    final allExercisesAsync = ref.watch(exerciseListProvider);
    
    return CupertinoListSection.insetGrouped(
      header: Text('第 $dayNumber 天${day.isRestDay ? ' · 休息日' : ''}'),
      children: [
        CupertinoListTile(
          title: Text(day.isRestDay ? '休息日' : '训练日'),
          trailing: CupertinoSwitch(
            value: day.isRestDay,
            onChanged: (value) {
              ref.read(planNotifierProvider.notifier).setPlanDayAsRest(day.id, value);
            },
          ),
        ),
        if (!day.isRestDay) ...[
          exercisesAsync.when(
            data: (exercises) {
              if (exercises.isEmpty) {
                return const CupertinoListTile(
                  title: Text(
                    '暂无训练项目',
                    style: TextStyle(color: CupertinoColors.systemGrey),
                  ),
                );
              }
              return Column(
                children: exercises.map((de) {
                  // Look up exercise name from all exercises
                  final exerciseName = allExercisesAsync.whenOrNull(
                    data: (exercises) {
                      final exercise = exercises.where((e) => e.id == de.exerciseId).firstOrNull;
                      return exercise?.name ?? '未知项目';
                    },
                  ) ?? '加载中...';
                  
                  return CupertinoListTile(
                    title: Text('训练项目: $exerciseName'),
                    subtitle: Text('${de.targetSets}组 × ${de.targetReps}次'),
                    trailing: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(
                        CupertinoIcons.minus_circle,
                        color: CupertinoColors.destructiveRed,
                      ),
                      onPressed: () {
                        ref.read(planNotifierProvider.notifier)
                            .removeExerciseFromDay(de.id);
                      },
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(
              child: CupertinoActivityIndicator(),
            ),
            error: (_, __) => const CupertinoListTile(
              title: Text('加载失败'),
            ),
          ),
          CupertinoListTile(
            leading: Icon(PhosphorIcons.plus),
            title: const Text('添加训练项目'),
            onTap: () {
              _showAddExerciseDialog(context, ref);
            },
          ),
        ],
      ],
    );
  }
  
  void _showAddExerciseDialog(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.read(exerciseListProvider);
    
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '选择训练项目',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text('完成'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: exercisesAsync.when(
                data: (exercises) {
                  if (exercises.isEmpty) {
                    return const Center(
                      child: Text('请先创建训练项目'),
                    );
                  }
                  return ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      return CupertinoListTile(
                        title: Text(exercise.name),
                        subtitle: Text('${exercise.defaultSets}组 × ${exercise.defaultReps}次'),
                        onTap: () {
                          ref.read(planNotifierProvider.notifier)
                              .addExerciseToDay(
                                planDayId: day.id,
                                exerciseId: exercise.id,
                                targetSets: exercise.defaultSets,
                                targetReps: exercise.defaultReps,
                                targetWeight: exercise.defaultWeight,
                              );
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CupertinoActivityIndicator()),
                error: (e, _) => Center(child: Text('加载失败: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
