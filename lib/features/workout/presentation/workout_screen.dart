import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Icon, Divider, ExpansionTile;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/core/database/database_provider.dart';
import 'package:xworkout/features/workout/data/workout_providers.dart';
import 'package:xworkout/features/workout/data/workout_repository.dart';
import 'package:xworkout/features/training/presentation/providers/exercise_provider.dart';
import 'package:uuid/uuid.dart';

class WorkoutScreen extends ConsumerStatefulWidget {
  const WorkoutScreen({super.key});

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    final workoutTypesAsync = ref.watch(workoutTypesProvider);
    final currentSession = ref.watch(currentSessionProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(currentSession != null ? '训练中' : '开始训练'),
        leading: currentSession != null
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('取消'),
                onPressed: () => _showCancelDialog(context),
              )
            : null,
      ),
      child: SafeArea(
        child: workoutTypesAsync.when(
          data: (types) {
            if (currentSession != null) {
              return _WorkoutRecordingView(session: currentSession);
            }
            return _TypeSelectionView(types: types);
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (e, _) => Center(child: Text('错误: $e')),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('取消训练'),
        content: const Text('确定要取消本次训练吗？'),
        actions: [
          CupertinoDialogAction(
            child: const Text('继续训练'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('取消'),
            onPressed: () async {
              Navigator.pop(context);
              await _cancelTraining();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _cancelTraining() async {
    final session = ref.read(currentSessionProvider);
    if (session != null) {
      await workoutSessionRepositoryProvider.deleteSession(session.id);
      ref.read(currentSessionProvider.notifier).state = null;
    }
  }
}

class _TypeSelectionView extends ConsumerWidget {
  final List<WorkoutType> types;

  const _TypeSelectionView({required this.types});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 32),
        const Text(
          '选择今天的训练类型',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          '选择后开始记录训练',
          style: TextStyle(color: CupertinoColors.systemGrey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ...types.map((type) => _TypeCard(type: type)),
      ],
    );
  }
}

class _TypeCard extends ConsumerWidget {
  final WorkoutType type;

  const _TypeCard({required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => _startWorkout(context, ref),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _getTypeColors(type.name),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _getTypeColors(type.name).first.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Icon(_getTypeIcon(type.name), color: CupertinoColors.white, size: 40),
              const SizedBox(width: 16),
              Text(
                type.name,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Icon(CupertinoIcons.chevron_right, color: CupertinoColors.white),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _getTypeColors(String name) {
    switch (name) {
      case '胸部':
        return [const Color(0xFFFF6B6B), const Color(0xFFFF8E8E)];
      case '背部':
        return [const Color(0xFF4ECDC4), const Color(0xFF44A08D)];
      case '腿部':
        return [const Color(0xFF667EEA), const Color(0xFF764BA2)];
      default:
        return [CupertinoColors.systemGrey, CupertinoColors.systemGrey2];
    }
  }

  IconData _getTypeIcon(String name) {
    switch (name) {
      case '胸部':
        return Icons.fitness_center;
      case '背部':
        return Icons.accessibility_new;
      case '腿部':
        return Icons.directions_run;
      default:
        return Icons.fitness_center;
    }
  }

  Future<void> _startWorkout(BuildContext context, WidgetRef ref) async {
    // 创建新训练会话
    final sessionId = await workoutSessionRepositoryProvider.createSession(
      typeId: type.id,
      date: DateTime.now(),
    );

    // 获取最后同类型训练并复制组数据
    final lastSession = await workoutSessionRepositoryProvider.getLastSessionByType(type.id);
    if (lastSession != null) {
      await workoutSetRepositoryProvider.copySetsFromLastSession(lastSession.id, sessionId);
    }

    // 获取新创建的会话
    final session = await workoutSessionRepositoryProvider.getSessionById(sessionId);
    if (session != null) {
      ref.read(currentSessionProvider.notifier).state = session;
    }
  }
}

class _WorkoutRecordingView extends ConsumerStatefulWidget {
  final WorkoutSession session;

  const _WorkoutRecordingView({required this.session});

  @override
  ConsumerState<_WorkoutRecordingView> createState() => _WorkoutRecordingViewState();
}

class _WorkoutRecordingViewState extends ConsumerState<_WorkoutRecordingView> {
  final Map<String, List<_SetData>> _exerciseSets = {};
  String? _note;

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exerciseListProvider);
    final workoutTypesAsync = ref.watch(workoutTypesProvider);
    final setsAsync = ref.watch(sessionSetsProvider(widget.session.id));

    return Column(
      children: [
        // 顶部信息
        Container(
          padding: const EdgeInsets.all(16),
          color: CupertinoColors.systemGrey6,
          child: Row(
            children: [
              workoutTypesAsync.when(
                data: (types) {
                  final type = types.where((t) => t.id == widget.session.typeId).firstOrNull;
                  return Text(type?.name ?? '训练', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
                },
                loading: () => const Text('加载中...'),
                error: (_, __) => const Text('训练'),
              ),
              const Spacer(),
              Text(
                '${DateTime.now().month}月${DateTime.now().day}日',
                style: const TextStyle(color: CupertinoColors.systemGrey),
              ),
            ],
          ),
        ),

        // 上次训练参考
        _LastTrainingReference(sessionId: widget.session.id),

        // 训练动作列表
        Expanded(
          child: setsAsync.when(
            data: (sets) => _buildExerciseList(sets, exercisesAsync),
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (e, _) => Center(child: Text('错误: $e')),
          ),
        ),

        // 底部按钮
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground,
            border: Border(top: BorderSide(color: CupertinoColors.systemGrey5)),
          ),
          child: Column(
            children: [
              // 添加动作按钮
              CupertinoButton(
                color: CupertinoColors.activeBlue,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.add, color: CupertinoColors.white),
                    SizedBox(width: 8),
                    Text('添加动作', style: TextStyle(color: CupertinoColors.white)),
                  ],
                ),
                onPressed: () => _showAddExerciseDialog(context, exercisesAsync),
              ),
              const SizedBox(height: 12),
              // 完成训练按钮
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  color: CupertinoColors.activeGreen,
                  child: const Text('完成训练', style: TextStyle(color: CupertinoColors.white)),
                  onPressed: () => _completeWorkout(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseList(List<WorkoutSet> sets, AsyncValue<List<Exercise>> exercisesAsync) {
    // 按动作分组
    final groupedSets = <String, List<WorkoutSet>>{};
    for (final set in sets) {
      groupedSets.putIfAbsent(set.exerciseId, () => []).add(set);
    }

    if (groupedSets.isEmpty) {
      return const Center(
        child: Text(
          '点击下方添加动作开始训练',
          style: TextStyle(color: CupertinoColors.systemGrey),
        ),
      );
    }

    return exercisesAsync.when(
      data: (exercises) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: groupedSets.length,
        itemBuilder: (context, index) {
          final exerciseId = groupedSets.keys.elementAt(index);
          final exerciseSets = groupedSets[exerciseId]!;
          final exercise = exercises.where((e) => e.id == exerciseId).firstOrNull;

          return _ExerciseCard(
            exerciseName: exercise?.name ?? '未知动作',
            exerciseId: exerciseId,
            sets: exerciseSets,
            onAddSet: () => _addSet(exerciseId),
            onDeleteSet: (setId) => _deleteSet(setId),
            onUpdateSet: (setId, weight, reps) => _updateSet(setId, weight, reps),
          );
        },
      ),
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (e, _) => Center(child: Text('错误: $e')),
    );
  }

  Future<void> _addSet(String exerciseId) async {
    // 获取当前最大组号
    final sets = ref.read(sessionSetsProvider(widget.session.id)).valueOrNull ?? [];
    final exerciseSets = sets.where((s) => s.exerciseId == exerciseId).toList();
    final maxSetNumber = exerciseSets.isEmpty ? 0 : exerciseSets.map((s) => s.setNumber).reduce((a, b) => a > b ? a : b);

    await workoutSetRepositoryProvider.addSet(
      sessionId: widget.session.id,
      exerciseId: exerciseId,
      setNumber: maxSetNumber + 1,
    );
  }

  Future<void> _deleteSet(String setId) async {
    await workoutSetRepositoryProvider.deleteSet(setId);
  }

  Future<void> _updateSet(String setId, String weight, int reps) async {
    await workoutSetRepositoryProvider.updateSet(setId, weight: weight, reps: reps);
  }

  void _showAddExerciseDialog(BuildContext context, AsyncValue<List<Exercise>> exercisesAsync) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _AddExerciseSheet(
        sessionId: widget.session.id,
        exercisesAsync: exercisesAsync,
      ),
    );
  }

  void _completeWorkout(BuildContext context) {
    final noteController = TextEditingController();
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('完成训练'),
        content: Column(
          children: [
            const Text('确定要完成本次训练吗？'),
            const SizedBox(height: 12),
            CupertinoTextField(
              controller: noteController,
              placeholder: '添加备注（可选）',
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            child: const Text('完成'),
            onPressed: () async {
              Navigator.pop(context);
              await workoutSessionRepositoryProvider.completeSession(
                widget.session.id,
                note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
              );
              ref.read(currentSessionProvider.notifier).state = null;
            },
          ),
        ],
      ),
    );
  }
}

class _LastTrainingReference extends ConsumerWidget {
  final String sessionId;

  const _LastTrainingReference({required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(currentSessionProvider);
    if (session == null) return const SizedBox.shrink();

    final lastSessionAsync = ref.watch(lastSessionByTypeProvider(session.typeId));

    return lastSessionAsync.when(
      data: (lastSession) {
        if (lastSession == null) {
          return Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(CupertinoIcons.info_circle, color: CupertinoColors.systemGrey),
                SizedBox(width: 8),
                Text('暂无同类型历史记录', style: TextStyle(color: CupertinoColors.systemGrey)),
              ],
            ),
          );
        }

        final setsAsync = ref.watch(sessionSetsProvider(lastSession.id));
        return setsAsync.when(
          data: (sets) => _buildReferenceCard(sets),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildReferenceCard(List<WorkoutSet> sets) {
    // 按动作分组
    final groupedSets = <String, List<WorkoutSet>>{};
    for (final set in sets) {
      groupedSets.putIfAbsent(set.exerciseId, () => []).add(set);
    }

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemBlue.withValues(alpha: 0.3)),
      ),
      child: ExpansionTile(
        leading: const Icon(CupertinoIcons.doc_text, color: CupertinoColors.systemBlue),
        title: const Text(
          '上次训练参考',
          style: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${sets.length}组动作',
          style: const TextStyle(fontSize: 12),
        ),
        children: groupedSets.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '动作: ${entry.key}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  entry.value.map((s) => '${s.setNumber}. ${s.weight.isEmpty ? "-" : s.weight} × ${s.reps}次').join(' | '),
                  style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
                ),
                const Divider(),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ExerciseCard extends StatefulWidget {
  final String exerciseName;
  final String exerciseId;
  final List<WorkoutSet> sets;
  final VoidCallback onAddSet;
  final Function(String) onDeleteSet;
  final Function(String, String, int) onUpdateSet;

  const _ExerciseCard({
    required this.exerciseName,
    required this.exerciseId,
    required this.sets,
    required this.onAddSet,
    required this.onDeleteSet,
    required this.onUpdateSet,
  });

  @override
  State<_ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<_ExerciseCard> {
  final Map<String, TextEditingController> _weightControllers = {};
  final Map<String, TextEditingController> _repsControllers = {};

  @override
  void dispose() {
    for (final c in _weightControllers.values) {
      c.dispose();
    }
    for (final c in _repsControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.exerciseName,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minSize: 24,
                  child: const Icon(CupertinoIcons.add_circled, color: CupertinoColors.activeBlue),
                  onPressed: widget.onAddSet,
                ),
              ],
            ),
          ),
          // 组列表
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // 表头
                const Row(
                  children: [
                    SizedBox(width: 40, child: Text('组', style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 13))),
                    Expanded(child: Text('重量', style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 13))),
                    Expanded(child: Text('次数', style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 13))),
                    SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 8),
                // 组数据
                ...widget.sets.map((set) {
                  _weightControllers.putIfAbsent(set.id, () => TextEditingController(text: set.weight));
                  _repsControllers.putIfAbsent(set.id, () => TextEditingController(text: set.reps.toString()));

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Text('${set.setNumber}', style: const TextStyle(fontWeight: FontWeight.w500)),
                        ),
                        Expanded(
                          child: CupertinoTextField(
                            controller: _weightControllers[set.id],
                            placeholder: '重量',
                            suffix: CupertinoButton(
                              padding: EdgeInsets.zero,
                              minSize: 24,
                              child: const Text('kg', style: TextStyle(fontSize: 12)),
                              onPressed: () {
                                final current = _weightControllers[set.id]!.text;
                                _weightControllers[set.id]!.text = current.endsWith('kg') ? current : '$current kg';
                                widget.onUpdateSet(set.id, _weightControllers[set.id]!.text, int.tryParse(_repsControllers[set.id]!.text) ?? 0);
                              },
                            ),
                            onChanged: (value) => widget.onUpdateSet(set.id, value, int.tryParse(_repsControllers[set.id]!.text) ?? 0),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CupertinoTextField(
                            controller: _repsControllers[set.id],
                            placeholder: '次数',
                            keyboardType: TextInputType.number,
                            onChanged: (value) => widget.onUpdateSet(set.id, _weightControllers[set.id]!.text, int.tryParse(value) ?? 0),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            minSize: 24,
                            child: const Icon(CupertinoIcons.delete, color: CupertinoColors.destructiveRed, size: 20),
                            onPressed: () => widget.onDeleteSet(set.id),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddExerciseSheet extends ConsumerStatefulWidget {
  final String sessionId;
  final AsyncValue<List<Exercise>> exercisesAsync;

  const _AddExerciseSheet({required this.sessionId, required this.exercisesAsync});

  @override
  ConsumerState<_AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends ConsumerState<_AddExerciseSheet> {
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Container(
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
                const Text('添加动作', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Text('关闭'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CupertinoSearchTextField(
              placeholder: '搜索动作',
              onChanged: (value) => setState(() => _searchText = value),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: widget.exercisesAsync.when(
              data: (exercises) {
                final filtered = exercises
                    .where((e) => e.name.toLowerCase().contains(_searchText.toLowerCase()))
                    .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('未找到动作'),
                        const SizedBox(height: 16),
                        CupertinoButton(
                          child: const Text('新建动作'),
                          onPressed: () => _showCreateExerciseDialog(context),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final exercise = filtered[index];
                    return CupertinoListTile(
                      title: Text(exercise.name),
                      subtitle: exercise.category != null ? Text(exercise.category!) : null,
                      trailing: const Icon(CupertinoIcons.add),
                      onTap: () => _addExercise(exercise.id),
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
    );
  }

  Future<void> _addExercise(String exerciseId) async {
    // 添加第一个组
    await workoutSetRepositoryProvider.addSet(
      sessionId: widget.sessionId,
      exerciseId: exerciseId,
      setNumber: 1,
    );
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _showCreateExerciseDialog(BuildContext context) {
    final nameController = TextEditingController();
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('新建动作'),
        content: Column(
          children: [
            const SizedBox(height: 12),
            CupertinoTextField(
              controller: nameController,
              placeholder: '动作名称',
              autofocus: true,
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            child: const Text('创建'),
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty) {
                // 创建新动作
                final exerciseId = const Uuid().v4();
                final now = DateTime.now();
                await databaseProvider.into(databaseProvider.exercises).insert(
                  ExercisesCompanion.insert(
                    id: exerciseId,
                    name: nameController.text.trim(),
                    createdAt: now,
                  ),
                );
                if (mounted) {
                  Navigator.pop(context);
                  // 添加新创建的动作到训练
                  await _addExercise(exerciseId);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

// 临时类用于本地状态
class _SetData {
  String weight;
  int reps;
  _SetData({this.weight = '', this.reps = 0});
}
