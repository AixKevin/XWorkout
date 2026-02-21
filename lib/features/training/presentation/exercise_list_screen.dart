import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/features/training/presentation/providers/exercise_provider.dart';
import 'package:xworkout/features/training/presentation/exercise_form_screen.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ExerciseListScreen extends ConsumerWidget {
  const ExerciseListScreen({super.key});

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
                  trailing: const CupertinoListTileChevron(),
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
