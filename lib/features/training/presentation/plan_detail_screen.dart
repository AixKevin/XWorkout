import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Icon;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/features/training/presentation/providers/plan_provider.dart';
import 'package:xworkout/features/training/presentation/providers/exercise_provider.dart';
import 'package:xworkout/core/database/database.dart';

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
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
            return ListView(
              children: [
                // Plan info header
                if (plan != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '起始日期',
                              style: TextStyle(
                                fontSize: 15,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              minSize: 0,
                              child: const Text('修改'),
                              onPressed: () => _showDatePicker(context, ref, plan),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${plan.startDate.year}-${plan.startDate.month.toString().padLeft(2, '0')}-${plan.startDate.day.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '循环周期: ${plan.cycleDays}天',
                          style: const TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Training days
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    '训练日',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ),
                ...days.map((day) {
                  return _DayDetailTile(
                    planId: planId,
                    day: day,
                    dayNumber: days.indexOf(day) + 1,
                  );
                }),
              ],
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
  
  void _showDatePicker(BuildContext context, WidgetRef ref, WorkoutPlan plan) {
    DateTime selectedDate = plan.startDate;
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: const Text('取消'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoButton(
                  child: const Text('确定'),
                  onPressed: () async {
                    await ref.read(planNotifierProvider.notifier).updatePlanStartDate(plan.id, selectedDate);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: plan.startDate,
                onDateTimeChanged: (date) {
                  selectedDate = date;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeactivateDialog(BuildContext context, WidgetRef ref, WorkoutPlan plan) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('确认停用'),
        content: Text('确定要停用"${plan.name}"吗？'),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('停用'),
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(planNotifierProvider.notifier).deactivatePlan();
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
                        Icons.remove_circle,
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
            leading: Icon(Icons.add),
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
