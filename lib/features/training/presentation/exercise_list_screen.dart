import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Icon;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/features/training/presentation/providers/exercise_provider.dart';
import 'package:xworkout/features/training/presentation/exercise_form_screen.dart';
import 'package:xworkout/features/training/presentation/exercise_detail_screen.dart';
import 'package:xworkout/core/database/database.dart';
import 'package:xworkout/shared/widgets/async_value_widget.dart';
import 'package:xworkout/shared/widgets/empty_state.dart';

class ExerciseListScreen extends ConsumerStatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  ConsumerState<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends ConsumerState<ExerciseListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;

  final List<String> _categories = [
    '胸部', '背部', '肩部', '手臂', '腿部', '核心', '有氧', '其他'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exerciseListProvider);
    
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('训练项目'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(Icons.add),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: '搜索训练项目',
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _buildCategoryChip('全部', _selectedCategory == null, () {
                      setState(() {
                        _selectedCategory = null;
                      });
                    }),
                  ),
                  ..._categories.map((category) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _buildCategoryChip(category, _selectedCategory == category, () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    }),
                  )),
                ],
              ),
            ),
            Expanded(
              child: AsyncValueWidget<List<Exercise>>(
                value: exercisesAsync,
                data: (exercises) {
                  final filteredExercises = exercises.where((exercise) {
                    final matchesSearch = exercise.name.toLowerCase().contains(_searchQuery.toLowerCase());
                    final matchesCategory = _selectedCategory == null || exercise.category == _selectedCategory;
                    return matchesSearch && matchesCategory;
                  }).toList();

                  // Sort by category then name
                  filteredExercises.sort((a, b) {
                    if (a.category != b.category) {
                       if (a.category == null) return 1;
                       if (b.category == null) return -1;
                       return a.category!.compareTo(b.category!);
                    }
                    return a.name.compareTo(b.name);
                  });

                  if (filteredExercises.isEmpty) {
                    if (exercises.isEmpty) {
                      return EmptyStateWidget(
                        icon: Icons.fitness_center,
                        title: '暂无训练项目',
                        message: '添加您的第一个训练项目',
                        actionLabel: '添加项目',
                        onAction: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const ExerciseFormScreen(),
                            ),
                          );
                        },
                      );
                    } else {
                      return const EmptyStateWidget(
                        icon: Icons.search_off,
                        title: '未找到匹配项目',
                        message: '尝试调整搜索关键词或分类',
                      );
                    }
                  }
                  
                  return ListView.builder(
                    itemCount: filteredExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = filteredExercises[index];
                      // Show header if category changes
                      final bool showHeader = index == 0 || 
                          exercise.category != filteredExercises[index - 1].category;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showHeader)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Text(
                                exercise.category ?? '未分类',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                            ),
                          CupertinoListTile(
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
                                    Icons.delete,
                                    color: CupertinoColors.destructiveRed,
                                    size: 22,
                                  ),
                                  onPressed: () => _confirmDelete(context, ref, exercise),
                                ),
                                const Icon(Icons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => ExerciseDetailScreen(exercise: exercise),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? CupertinoColors.activeBlue : CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? CupertinoColors.white : CupertinoColors.label,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
