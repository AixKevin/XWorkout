import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:xworkout/features/templates/data/plan_templates.dart';
import 'package:xworkout/features/training/presentation/providers/plan_provider.dart';
import 'package:xworkout/features/training/presentation/providers/exercise_provider.dart';
import 'package:xworkout/features/training/data/plan_repository.dart';
import 'package:xworkout/features/training/data/exercise_repository.dart';
import 'package:xworkout/core/database/database.dart';
import 'package:xworkout/core/database/database_provider.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:uuid/uuid.dart';

final workoutPlanRepositoryProvider = Provider<WorkoutPlanRepository>((ref) {
  return WorkoutPlanRepository(databaseProvider);
});

final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  return ExerciseRepository(databaseProvider);
});

class TemplateListScreen extends ConsumerWidget {
  const TemplateListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('选择模板'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 16),
            CupertinoListSection.insetGrouped(
              header: const Text('推荐模板'),
              children: planTemplates.map((template) {
                return CupertinoListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: CupertinoColors.activeBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      CupertinoIcons.chart_bar_square,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                  title: Text(template.name),
                  subtitle: Text('${template.cycleDays}天循环 · ${template.description}'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => _showTemplateDetail(context, ref, template),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showTemplateDetail(BuildContext context, WidgetRef ref, PlanTemplate template) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
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
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text('取消'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    template.name,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text('使用'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await _applyTemplate(context, ref, template);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  CupertinoListSection.insetGrouped(
                    header: const Text('模板信息'),
                    children: [
                      CupertinoListTile(
                        title: const Text('描述'),
                        additionalInfo: Text(template.description),
                      ),
                      CupertinoListTile(
                        title: const Text('训练周期'),
                        additionalInfo: Text('${template.cycleDays}天'),
                      ),
                      CupertinoListTile(
                        title: const Text('训练日'),
                        additionalInfo: Text('${template.days.where((d) => !d.isRestDay).length}天'),
                      ),
                      CupertinoListTile(
                        title: const Text('休息日'),
                        additionalInfo: Text('${template.days.where((d) => d.isRestDay).length}天'),
                      ),
                    ],
                  ),
                  ...template.days.map((day) {
                    return CupertinoListSection.insetGrouped(
                      header: Text(day.isRestDay ? '休息日' : '训练日 ${day.dayIndex + 1}'),
                      children: day.isRestDay
                          ? [
                              const CupertinoListTile(
                                title: Text('休息'),
                                leading: Icon(CupertinoIcons.bed_double),
                              ),
                            ]
                          : day.exercises.map((exercise) {
                              return CupertinoListTile(
                                title: Text(exercise.name),
                                subtitle: Text(
                                  '${exercise.targetSets}组 × ${exercise.targetReps}次${exercise.targetWeight != null ? ' × ${exercise.targetWeight}kg' : ''}',
                                ),
                                leading: Icon(CupertinoIcons.sportscourt),
                              );
                            }).toList(),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _applyTemplate(BuildContext context, WidgetRef ref, PlanTemplate template) async {
    try {
      final exerciseList = await ref.read(exerciseListProvider.future);
      
      final exerciseMap = <String, Exercise>{};
      for (var e in exerciseList) {
        exerciseMap[e.name] = e;
      }

      final planId = const Uuid().v4();
      final plan = WorkoutPlansCompanion(
        id: Value(planId),
        name: Value(template.name),
        cycleDays: Value(template.cycleDays),
        isActive: const Value(false),
        startDate: Value(DateTime.now()),
        createdAt: Value(DateTime.now()),
      );

      final planRepo = ref.read(workoutPlanRepositoryProvider);
      await planRepo.insertPlan(plan);

      for (var dayTemplate in template.days) {
        final dayId = const Uuid().v4();
        await planRepo.insertPlanDay(PlanDaysCompanion(
          id: Value(dayId),
          planId: Value(planId),
          dayIndex: Value(dayTemplate.dayIndex),
          isRestDay: Value(dayTemplate.isRestDay),
        ));

        if (!dayTemplate.isRestDay) {
          for (var exTemplate in dayTemplate.exercises) {
            var exercise = exerciseMap[exTemplate.name];
            if (exercise == null) {
              final exerciseId = const Uuid().v4();
              final newExercise = ExercisesCompanion(
                id: Value(exerciseId),
                name: Value(exTemplate.name),
                category: Value(exTemplate.category),
                defaultSets: Value(exTemplate.targetSets),
                defaultReps: Value(exTemplate.targetReps),
                defaultWeight: Value(exTemplate.targetWeight),
                createdAt: Value(DateTime.now()),
              );
              
              final exerciseRepo = ref.read(exerciseRepositoryProvider);
              await exerciseRepo.insertExercise(newExercise);
              
              exercise = Exercise(
                id: exerciseId,
                name: exTemplate.name,
                category: exTemplate.category,
                defaultSets: exTemplate.targetSets,
                defaultReps: exTemplate.targetReps,
                defaultWeight: exTemplate.targetWeight,
                createdAt: DateTime.now(),
              );
              exerciseMap[exTemplate.name] = exercise;
            }

            final exercises = await planRepo.getDayExercises(dayId);
            await planRepo.insertDayExercise(DayExercisesCompanion(
              id: Value(const Uuid().v4()),
              planDayId: Value(dayId),
              exerciseId: Value(exercise.id),
              orderIndex: Value(exercises.length),
              targetSets: Value(exTemplate.targetSets),
              targetReps: Value(exTemplate.targetReps),
              targetWeight: Value(exTemplate.targetWeight),
            ));
          }
        }
      }

      if (context.mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('创建成功'),
            content: Text('已使用"${template.name}"模板创建计划'),
            actions: [
              CupertinoDialogAction(
                child: const Text('确定'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('创建失败'),
            content: Text('错误: $e'),
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
  }
}
