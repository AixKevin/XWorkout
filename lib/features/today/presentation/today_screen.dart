import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/features/today/presentation/providers/today_provider.dart';
import 'package:xworkout/features/today/data/today_repository.dart';
import 'package:xworkout/features/today/presentation/exercise_record_screen.dart';
import 'package:xworkout/features/training/presentation/providers/plan_provider.dart';
import 'package:xworkout/features/training/presentation/providers/exercise_provider.dart';
import 'package:xworkout/core/database/database.dart';
import 'package:xworkout/shared/widgets/async_value_widget.dart';
import 'package:xworkout/shared/widgets/empty_state.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activePlanAsync = ref.watch(todayActivePlanProvider);
    final todayRecordAsync = ref.watch(todayRecordProvider);
    final selectedDate = DateTime.now();
    
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(formatDate(selectedDate)),
      ),
      child: SafeArea(
        child: AsyncValueWidget<WorkoutPlan?>(
          value: activePlanAsync,
          data: (plan) {
            if (plan == null) {
              return const EmptyStateWidget(
                icon: Icons.timer,
                title: '暂无激活的计划',
                message: '请先在「训练」页面创建并激活健身计划',
              );
            }
            
            return _buildTodayContent(context, ref, plan, todayRecordAsync);
          },
        ),
      ),
    );
  }
  

  
  Widget _buildTodayContent(
    BuildContext context,
    WidgetRef ref,
    WorkoutPlan plan,
    AsyncValue<DailyRecord?> todayRecordAsync,
  ) {
    final cycleDay = calculateCycleDay(plan);
    final planDaysAsync = ref.watch(planDaysProvider(plan.id));
    
    return AsyncValueWidget<List<PlanDay>>(
      value: planDaysAsync,
      data: (planDays) {
        if (planDays.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.bar_chart,
            title: '暂无训练日',
            message: '请在计划中添加训练日',
          );
        }
        
        // Get today's plan day - cycleDay is 1-indexed
        final dayIndex = (cycleDay - 1) % planDays.length;
        final todayPlanDay = planDays[dayIndex];
        
        final isRestDay = todayPlanDay.isRestDay;
        
        return ListView(
          padding: const EdgeInsets.only(bottom: 100),
          children: [
            _buildPlanHeader(plan, cycleDay, isRestDay),
            if (isRestDay)
              _buildRestDayView(context, ref, todayRecordAsync)
            else
              _buildTrainingDayView(context, ref, todayPlanDay, todayRecordAsync),
          ],
        );
      },
    );
  }
  
  Widget _buildPlanHeader(WorkoutPlan plan, int cycleDay, bool isRestDay) {
    return Container(
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
              Row(
                children: [
                   const Icon(Icons.bar_chart),
                  const SizedBox(width: 8),
                  Text(
                    plan.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '第 $cycleDay / ${plan.cycleDays} 天 · ${isRestDay ? "休息日" : "训练日"}',
            style: const TextStyle(
              fontSize: 15,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRestDayView(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<DailyRecord?> todayRecordAsync,
  ) {
    final record = todayRecordAsync.valueOrNull;
    final isSkipped = record?.status == 'skipped';
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Icon(
            Icons.bed,
            size: 64,
            color: CupertinoColors.systemGrey,
          ),
          const SizedBox(height: 16),
          const Text(
            '今天休息',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          if (isSkipped) ...[
            CupertinoButton(
              color: CupertinoColors.activeBlue,
              child: const Text('撤销偷懒'),
              onPressed: () {
                HapticFeedback.selectionClick();
                if (record != null) {
                  ref.read(todayNotifierProvider.notifier).undoSkip(record.id);
                }
              },
            ),
          ] else ...[
            CupertinoButton(
              color: CupertinoColors.destructiveRed,
              child: const Text('今天想偷懒'),
              onPressed: () {
                HapticFeedback.selectionClick();
                _showSkipDialog(context, ref, null);
              },
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildTrainingDayView(
    BuildContext context,
    WidgetRef ref,
    PlanDay todayPlanDay,
    AsyncValue<DailyRecord?> todayRecordAsync,
  ) {
    final exercisesAsync = ref.watch(todayDayExercisesProvider(todayPlanDay.id));
    final record = todayRecordAsync.valueOrNull;
    final isTraining = record?.status == 'normal';
    final isCompleted = record?.status == 'completed';
    final isSkipped = record?.status == 'skipped';
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '今日训练',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: CupertinoColors.activeGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '已完成',
                        style: TextStyle(
                          fontSize: 13,
                          color: CupertinoColors.activeGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              AsyncValueWidget<List<DayExercise>>(
                value: exercisesAsync,
                data: (exercises) {
                  if (exercises.isEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.grid_view,
                      title: '暂无训练项目',
                      message: '请在计划中添加训练项目',
                    );
                  }
                  
                  return Column(
                    children: exercises.map((de) {
                      return _ExerciseCard(
                        dayExercise: de,
                        isRecording: isTraining,
                        dailyRecordId: record?.id,
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (isSkipped) ...[
                CupertinoButton(
                  color: CupertinoColors.activeBlue,
                  child: const Text('撤销偷懒'),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    if (record != null) {
                      ref.read(todayNotifierProvider.notifier).undoSkip(record.id);
                    }
                  },
                ),
              ] else if (isCompleted) ...[
                // Training completed - show completion status
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.activeGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: CupertinoColors.activeGreen,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '训练已完成',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.activeGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (isTraining) ...[
                 // Training in progress - show Complete button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: CupertinoColors.activeGreen,
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.activeGreen.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check, color: CupertinoColors.white, size: 28),
                        SizedBox(width: 8),
                        Text(
                          '完成训练',
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      _showCompleteDialog(context, ref, todayPlanDay.id);
                    },
                  ),
                ),
              ] else ...[
                CupertinoButton(
                  color: CupertinoColors.destructiveRed,
                  child: const Text('今天偷懒'),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    _showSkipDialog(context, ref, null);
                  },
                ),
                const SizedBox(height: 24),
                // Quick Start Workout Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [CupertinoColors.activeBlue, Color(0xFF0055FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.activeBlue.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow, color: CupertinoColors.white, size: 28),
                        SizedBox(width: 8),
                        Text(
                          '开始训练',
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      HapticFeedback.mediumImpact();
                      await ref.read(todayNotifierProvider.notifier)
                          .startTraining(todayPlanDay.id);
                      if (context.mounted) {
                        _showTrainingStarted(context);
                      }
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
  
  void _showCompleteDialog(BuildContext context, WidgetRef ref, String planDayId) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('完成训练'),
        content: const Text('确认完成今天的训练吗？完成后将无法继续记录。'),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('确认完成'),
            onPressed: () async {
              await ref.read(todayNotifierProvider.notifier).completeTraining(planDayId);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  
  void _showSkipDialog(BuildContext context, WidgetRef ref, String? recordId) {
    final reasonController = TextEditingController();
    
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('确认偷懒'),
        content: Column(
          children: [
            const Text('今天真的要偷懒吗？'),
            const SizedBox(height: 12),
            CupertinoTextField(
              controller: reasonController,
              placeholder: '偷懒原因（可选）',
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('确认'),
            onPressed: () async {
              await ref.read(todayNotifierProvider.notifier).skipTraining(
                recordId,
                reasonController.text.trim(),
              );
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
  
  void _showTrainingStarted(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('开始训练'),
        content: const Text('记录你的训练成果吧！'),
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

class _ExerciseCard extends ConsumerWidget {
  final DayExercise dayExercise;
  final bool isRecording;
  final String? dailyRecordId;
  
  const _ExerciseCard({
    required this.dayExercise,
    required this.isRecording,
    this.dailyRecordId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseAsync = ref.watch(exerciseListProvider);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          exerciseAsync.when(
            data: (exercises) {
              if (exercises.isEmpty) {
                return const Text(
                  '未知训练项目',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }
              final exercise = exercises.firstWhere(
                (e) => e.id == dayExercise.exerciseId,
                orElse: () => exercises.first,
              );
              return Text(
                exercise.name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
            loading: () => const Text('加载中...'),
            error: (_, __) => const Text('训练项目'),
          ),
          const SizedBox(height: 8),
          Text(
            '${dayExercise.targetSets}组 × ${dayExercise.targetReps}次${dayExercise.targetWeight != null ? ' ${dayExercise.targetWeight}kg' : ''}',
            style: const TextStyle(
              fontSize: 15,
              color: CupertinoColors.systemGrey,
            ),
          ),
          if (isRecording && dailyRecordId != null) ...[
            const SizedBox(height: 12),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Text('记录'),
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => ExerciseRecordScreen(
                      dayExercise: dayExercise,
                      dailyRecordId: dailyRecordId!,
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
