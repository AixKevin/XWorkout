import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Icon, Material;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/features/training/presentation/providers/plan_provider.dart';
import 'package:xworkout/features/training/presentation/providers/exercise_provider.dart';
import 'package:xworkout/core/database/database.dart';
import 'package:table_calendar/table_calendar.dart';

class PlanDetailScreen extends ConsumerStatefulWidget {
  final String planId;
  
  const PlanDetailScreen({super.key, required this.planId});

  @override
  ConsumerState<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends ConsumerState<PlanDetailScreen> {
  int _selectedViewIndex = 0; // 0: List, 1: Calendar

  @override
  Widget build(BuildContext context) {
    final planAsync = ref.watch(planListProvider);
    final planDaysAsync = ref.watch(planDaysProvider(widget.planId));
    final planStatsAsync = ref.watch(planStatsProvider(widget.planId));
    
    final plan = planAsync.valueOrNull?.firstWhere(
      (p) => p.id == widget.planId,
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
                child: const Icon(Icons.more_horiz),
                onPressed: () => _showActionSheet(context, plan),
              )
            : null,
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoSlidingSegmentedControl<int>(
                  children: const {
                    0: Text('列表视图'),
                    1: Text('日历视图'),
                  },
                  groupValue: _selectedViewIndex,
                  onValueChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedViewIndex = value;
                      });
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: planDaysAsync.when(
                data: (days) {
                  return _selectedViewIndex == 0
                      ? _buildListView(context, plan, days, planStatsAsync)
                      : _buildCalendarView(context, plan, days);
                },
                loading: () => const Center(child: CupertinoActivityIndicator()),
                error: (error, stack) => Center(
                  child: Text('加载失败: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(
    BuildContext context, 
    WorkoutPlan? plan, 
    List<PlanDay> days,
    AsyncValue<Map<String, dynamic>> planStatsAsync,
  ) {
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
                Row(
                  children: [
                    Text(
                      '循环周期: ${plan.cycleDays}天',
                      style: const TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    planStatsAsync.when(
                      data: (stats) {
                         final rate = ((stats['rate'] as double) * 100).toStringAsFixed(0);
                         final completed = stats['completed'];
                         final total = stats['total'];
                          return Text(
                           '完成率: $rate% ($completed/$total次)',
                           style: const TextStyle(
                             fontSize: 14,
                             color: CupertinoColors.systemGrey,
                           ),
                         );
                      },
                      loading: () => const CupertinoActivityIndicator(radius: 8),
                      error: (_, __) => const SizedBox(),
                    ),
                  ],
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
            planId: widget.planId,
            day: day,
            dayNumber: days.indexOf(day) + 1,
          );
        }),
      ],
    );
  }

  Widget _buildCalendarView(BuildContext context, WorkoutPlan? plan, List<PlanDay> days) {
    if (plan == null) return const SizedBox();

    return Material(
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: TableCalendar(
        firstDay: plan.startDate.subtract(const Duration(days: 365)),
        lastDay: plan.startDate.add(const Duration(days: 365 * 2)),
        focusedDay: DateTime.now(),
        calendarFormat: CalendarFormat.month,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (date.isBefore(plan.startDate)) return null;
            
            final dayDiff = date.difference(plan.startDate).inDays;
            if (dayDiff < 0) return null;
            
            final dayIndex = dayDiff % plan.cycleDays;
            final normalizedDayIndex = dayIndex < 0 ? dayIndex + plan.cycleDays : dayIndex;
            
            final planDay = days.firstWhere(
              (d) => d.dayIndex == normalizedDayIndex,
              orElse: () => days.first,
            );
            
            if (planDay.isRestDay) {
              return Positioned(
                bottom: 1,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: CupertinoColors.systemGrey,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            } else {
              return Positioned(
                bottom: 1,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: CupertinoColors.activeBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }
          },
          defaultBuilder: (context, date, focusedDay) {
            if (isSameDay(date, DateTime.now())) {
               return Container(
                margin: const EdgeInsets.all(6.0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: CupertinoColors.systemGrey5,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: CupertinoColors.activeBlue),
                ),
              );
            }
            return null;
          },
        ),
      ),
    );
  }

  void _showActionSheet(BuildContext context, WorkoutPlan plan) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              if (plan.isActive) {
                _showDeactivateDialog(context, ref, plan);
              } else {
                ref.read(planNotifierProvider.notifier).activatePlan(plan.id);
              }
            },
            child: Text(
              plan.isActive ? '停用计划' : '激活计划',
              style: TextStyle(
                color: plan.isActive ? CupertinoColors.destructiveRed : CupertinoColors.activeBlue,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(planNotifierProvider.notifier).duplicatePlan(plan.id);
                if (context.mounted) {
                   await showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('复制成功'),
                      content: const Text('计划已成功复制'),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('确定'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  await showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('复制失败'),
                      content: Text(e.toString()),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('确定'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
            child: const Text('复制计划'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          isDefaultAction: true,
          child: const Text('取消'),
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
            leading: const Icon(Icons.add),
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
