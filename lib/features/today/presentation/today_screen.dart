import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/features/today/presentation/providers/today_provider.dart';
import 'package:xworkout/features/today/data/today_repository.dart';
import 'package:xworkout/features/training/presentation/providers/plan_provider.dart';
import 'package:xworkout/features/training/presentation/providers/exercise_provider.dart';
import 'package:xworkout/features/training/data/exercise_repository.dart';
import 'package:xworkout/core/database/database.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';

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
        child: activePlanAsync.when(
          data: (plan) {
            if (plan == null) {
              return _buildNoPlanView(context);
            }
            
            return _buildTodayContent(context, ref, plan, todayRecordAsync);
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (error, stack) => Center(
            child: Text('加载失败: $error'),
          ),
        ),
      ),
    );
  }
  
  Widget _buildNoPlanView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.timer,
            size: 64,
            color: CupertinoColors.systemGrey,
          ),
          const SizedBox(height: 16),
          const Text(
            '暂无激活的计划',
            style: TextStyle(
              fontSize: 17,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '请先在「训练」页面创建并激活健身计划',
            style: TextStyle(
              fontSize: 13,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ],
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
    
    return planDaysAsync.when(
      data: (planDays) {
        final todayPlanDay = planDays.isNotEmpty && cycleDay <= planDays.length
            ? planDays[cycleDay - 1]
            : null;
        
        if (todayPlanDay == null) {
          return _buildNoPlanView(context);
        }
        
        final isRestDay = todayPlanDay.isRestDay;
        
        return ListView(
          children: [
            _buildPlanHeader(plan, cycleDay, isRestDay),
            if (isRestDay)
              _buildRestDayView(context, ref, todayRecordAsync)
            else
              _buildTrainingDayView(context, ref, todayPlanDay, todayRecordAsync),
          ],
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (e, _) => Center(child: Text('加载失败: $e')),
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
            children: [
               Icon(PhosphorIcons.chartBar),
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
          Icon(
            PhosphorIcons.bed,
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
                if (record != null) {
                  ref.read(todayNotifierProvider.notifier).undoSkip(record.id);
                }
              },
            ),
          ] else ...[
            CupertinoButton(
              color: CupertinoColors.destructiveRed,
              child: const Text('今天想偷懒'),
              onPressed: () => _showSkipDialog(context, ref, null),
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
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '今日训练',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              exercisesAsync.when(
                data: (exercises) {
                  if (exercises.isEmpty) {
                    return const Text(
                      '暂无训练项目，请在计划中配置',
                      style: TextStyle(color: CupertinoColors.systemGrey),
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
                loading: () => const CupertinoActivityIndicator(),
                error: (e, _) => Text('加载失败: $e'),
              ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (record?.status == 'skipped') ...[
                CupertinoButton(
                  color: CupertinoColors.activeBlue,
                  child: const Text('撤销偷懒'),
                  onPressed: () {
                    if (record != null) {
                      ref.read(todayNotifierProvider.notifier).undoSkip(record.id);
                    }
                  },
                ),
              ] else if (!isTraining) ...[
                CupertinoButton(
                  color: CupertinoColors.destructiveRed,
                  child: const Text('今天偷懒'),
                  onPressed: () => _showSkipDialog(context, ref, null),
                ),
                const SizedBox(height: 12),
                CupertinoButton.filled(
                  child: const Text('开始训练'),
                  onPressed: () async {
                    final recordId = await ref.read(todayNotifierProvider.notifier)
                        .startTraining(todayPlanDay.id);
                    if (context.mounted) {
                      _showTrainingStarted(context);
                    }
                  },
                ),
              ] else ...[
                const CupertinoButton.filled(
                  child: Text('训练中...'),
                  onPressed: null,
                ),
              ],
            ],
          ),
        ),
      ],
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
            onPressed: () {
              ref.read(todayNotifierProvider.notifier).skipTraining(
                recordId,
                reasonController.text.trim(),
              );
              Navigator.of(context).pop();
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
              onPressed: () => _showRecordDialog(context, ref),
            ),
          ],
        ],
      ),
    );
  }
  
  void _showRecordDialog(BuildContext context, WidgetRef ref) {
    final setsController = TextEditingController(text: dayExercise.targetSets.toString());
    final repsController = TextEditingController(text: dayExercise.targetReps.toString());
    final weightController = TextEditingController(
      text: dayExercise.targetWeight?.toString() ?? '',
    );
    
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('记录训练'),
        content: Column(
          children: [
            CupertinoTextField(
              controller: setsController,
              placeholder: '组数',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            CupertinoTextField(
              controller: repsController,
              placeholder: '次数',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            CupertinoTextField(
              controller: weightController,
              placeholder: '重量(kg)',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
            onPressed: () {
              if (dailyRecordId != null) {
                ref.read(todayNotifierProvider.notifier).saveExerciseRecord(
                  dailyRecordId: dailyRecordId!,
                  exerciseId: dayExercise.exerciseId,
                  actualSets: int.tryParse(setsController.text) ?? dayExercise.targetSets,
                  actualReps: [int.tryParse(repsController.text) ?? dayExercise.targetReps],
                  actualWeight: [double.tryParse(weightController.text)],
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
