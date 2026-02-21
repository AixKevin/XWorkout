import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/features/training/presentation/providers/exercise_provider.dart';
import 'package:xworkout/features/training/presentation/exercise_form_screen.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:xworkout/core/database/database.dart';

class ExerciseListScreen extends ConsumerWidget {
  const ExerciseListScreen({super.key});

  void _confirmDelete(BuildContext context, WidgetRef ref, Exercise exercise) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除"${exercise.name}"吗？'),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('删除'),
            onPressed: () {
              ref.read(exerciseNotifierProvider.notifier).deleteExercise(exercise.id);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exerciseListProvider);
    
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('训练项目'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(PhosphorIcons.plus),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => const ExerciseFormScreen(),
              ),
            );
          },
        ),
      ),
      child: SafeArea(
        child: exercisesAsync.when(
          data: (exercises) {
            if (exercises.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      PhosphorIcons.barbell,
                      size: 64,
                      color: CupertinoColors.systemGrey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '暂无训练项目',
                      style: TextStyle(
                        fontSize: 17,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CupertinoButton(
                      child: const Text('添加第一个项目'),
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => const ExerciseFormScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            
            return ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return CupertinoListTile(
                  title: Text(exercise.name),
                  subtitle: Text(
                    '${exercise.defaultSets}组 × ${exercise.defaultReps}次${exercise.defaultWeight != null ? ' ${exercise.defaultWeight}kg' : ''}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(
                          CupertinoIcons.delete,
                          color: CupertinoColors.destructiveRed,
                          size: 22,
                        ),
                        onPressed: () => _confirmDelete(context, ref, exercise),
                      ),
                      const CupertinoListTileChevron(),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => ExerciseFormScreen(exercise: exercise),
                      ),
                    );
                  },
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
}
