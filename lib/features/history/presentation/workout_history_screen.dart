import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Colors;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:xworkout/core/database/database_provider.dart';
import 'package:xworkout/features/workout/data/workout_providers.dart';
import 'package:xworkout/features/workout/data/workout_repository.dart';
import 'package:xworkout/features/training/presentation/providers/exercise_provider.dart';
import 'package:xworkout/shared/providers/weight_unit_provider.dart';
import 'package:xworkout/shared/utils/weight_unit_utils.dart';

// 筛选类型Provider
final historyFilterProvider = StateProvider<int?>((ref) => null);

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(workoutSessionsProvider);
    final typesAsync = ref.watch(workoutTypesProvider);
    final filterTypeId = ref.watch(historyFilterProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('训练历史'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 类型筛选
            typesAsync.when(
              data: (types) => _FilterChips(
                types: types,
                selectedId: filterTypeId,
                onSelected: (id) {
                  ref.read(historyFilterProvider.notifier).state = id;
                },
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            // 历史列表
            Expanded(
              child: sessionsAsync.when(
                data: (sessions) {
                  // 筛选
                  final filtered = filterTypeId != null
                      ? sessions.where((s) => s.typeId == filterTypeId).toList()
                      : sessions;

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('暂无训练记录', style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 8),
                          Text('开始你的第一次训练吧！',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final session = filtered[index];
                      return typesAsync.when(
                        data: (types) {
                          final type = types
                              .where((t) => t.id == session.typeId)
                              .firstOrNull;
                          return _SessionCard(
                            session: session,
                            typeName: type?.name ?? '训练',
                            onTap: () => _showSessionDetail(context, session),
                            onDelete: () =>
                                _deleteSession(context, ref, session),
                          );
                        },
                        loading: () => _SessionCard(
                          session: session,
                          typeName: '加载中...',
                          onTap: () {},
                          onDelete: () {},
                        ),
                        error: (_, __) => _SessionCard(
                          session: session,
                          typeName: '训练',
                          onTap: () {},
                          onDelete: () {},
                        ),
                      );
                    },
                  );
                },
                loading: () =>
                    const Center(child: CupertinoActivityIndicator()),
                error: (e, _) => Center(child: Text('错误: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSessionDetail(BuildContext context, WorkoutSession session) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => _SessionDetailScreen(session: session),
      ),
    );
  }

  void _deleteSession(
      BuildContext context, WidgetRef ref, WorkoutSession session) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('删除记录'),
        content: const Text('确定要删除这条训练记录吗？'),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('删除'),
            onPressed: () async {
              Navigator.pop(context);
              await workoutSessionRepositoryProvider.deleteSession(session.id);
            },
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final List<WorkoutType> types;
  final int? selectedId;
  final Function(int?) onSelected;

  const _FilterChips({
    required this.types,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _Chip(
            label: '全部',
            isSelected: selectedId == null,
            onTap: () => onSelected(null),
          ),
          ...types.where((type) => type.name != '通用').map((type) => _Chip(
                label: type.name,
                isSelected: selectedId == type.id,
                onTap: () => onSelected(type.id),
              )),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        color: isSelected ? Colors.blue : Colors.grey[200],
        minSize: 32,
        borderRadius: BorderRadius.circular(16),
        onPressed: onTap,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final WorkoutSession session;
  final String typeName;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SessionCard({
    required this.session,
    required this.typeName,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MM月dd日 EEEE', 'zh_CN').format(session.date);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: CupertinoColors.systemGrey5),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: CupertinoColors.activeBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.grid_view, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      typeName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateStr,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    if (session.note != null && session.note!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        session.note!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 32,
                child: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: onDelete,
              ),
              const Icon(CupertinoIcons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionDetailScreen extends ConsumerWidget {
  final WorkoutSession session;

  const _SessionDetailScreen({required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setsAsync = ref.watch(sessionSetsProvider(session.id));
    final exercisesAsync = ref.watch(exerciseListProvider);
    final weightUnit = ref.watch(weightUnitProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(DateFormat('MM月dd日', 'zh_CN').format(session.date)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(Icons.edit),
              onPressed: () => _openEditScreen(context),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(context, ref),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            // Note display
            if (session.note != null && session.note!.isNotEmpty)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.note, size: 20, color: CupertinoColors.systemGrey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        session.note!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            // Sets list
            setsAsync.when(
              data: (sets) {
                // 按动作分组
                final grouped = <String, List<WorkoutSet>>{};
                for (final set in sets) {
                  grouped.putIfAbsent(set.exerciseId, () => []).add(set);
                }

                if (grouped.isEmpty) {
                  return const Center(child: Text('暂无训练数据'));
                }

                return exercisesAsync.when(
                  data: (exercises) => ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: grouped.entries.map((entry) {
                      final exerciseId = entry.key;
                      final exercise =
                          exercises.where((e) => e.id == exerciseId).firstOrNull;
                      return _ExerciseDetailCard(
                        exerciseName: exercise?.name ?? '未知动作',
                        sets: entry.value,
                        weightUnit: weightUnit,
                      );
                    }).toList(),
                  ),
                  loading: () => const Center(child: CupertinoActivityIndicator()),
                  error: (e, _) => Center(child: Text('错误: $e')),
                );
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (e, _) => Center(child: Text('错误: $e')),
            ),
          ],
        ),
      ),
    );
  }

  void _openEditScreen(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => _SessionEditScreen(session: session),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('删除记录'),
        content: const Text('确定要删除这条训练记录吗？'),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('删除'),
            onPressed: () async {
              Navigator.pop(context);
              await workoutSessionRepositoryProvider.deleteSession(session.id);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    final noteController = TextEditingController(text: session.note ?? '');
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('编辑备注'),
        content: Column(
          children: [
            const SizedBox(height: 12),
            CupertinoTextField(
              controller: noteController,
              placeholder: '添加备注',
              maxLines: 3,
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
            onPressed: () async {
              Navigator.of(context).pop();
              await workoutSessionRepositoryProvider.updateNote(
                session.id,
                noteController.text.trim(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ExerciseDetailCard extends StatelessWidget {
  final String exerciseName;
  final List<WorkoutSet> sets;
  final String weightUnit;

  const _ExerciseDetailCard({
    required this.exerciseName,
    required this.sets,
    required this.weightUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exerciseName,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...sets.map((set) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: Text(
                        '${set.setNumber}.',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${_formatWeight(set.weight)} × ${set.reps}次',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  String _formatWeight(String raw) {
    // Get the unit stored with the weight (e.g., "10|kg" -> "kg")
    final storedUnit = WeightUnitUtils.parseStoredUnit(raw) ?? weightUnit;
    final kg = WeightUnitUtils.parseStoredToKg(raw);
    if (kg == null) {
      return '-';
    }
    return '${WeightUnitUtils.formatKgToDisplay(kg, storedUnit)}$storedUnit';
  }
}

// ==================== Edit Screen ====================

class _SessionEditScreen extends ConsumerStatefulWidget {
  final WorkoutSession session;

  const _SessionEditScreen({required this.session});

  @override
  ConsumerState<_SessionEditScreen> createState() => _SessionEditScreenState();
}

class _SessionEditScreenState extends ConsumerState<_SessionEditScreen> {
  final Map<String, TextEditingController> _weightControllers = {};
  final Map<String, TextEditingController> _repsControllers = {};
  final Map<String, String> _setUnits = {};
  late TextEditingController _noteController;
  bool _isLoading = true;
  List<WorkoutSet> _sets = [];
  List<Exercise> _exercises = [];

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.session.note ?? '');
    _loadData();
  }

  @override
  void dispose() {
    for (final controller in _weightControllers.values) {
      controller.dispose();
    }
    for (final controller in _repsControllers.values) {
      controller.dispose();
    }
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final setsAsync = await ref.read(sessionSetsProvider(widget.session.id).future);
    final exercisesAsync = await ref.read(exerciseListProvider.future);
    
    // Initialize controllers
    for (final set in setsAsync) {
      _weightControllers[set.id] = TextEditingController(
        text: WeightUnitUtils.formatKgToDisplay(
          WeightUnitUtils.parseStoredToKg(set.weight) ?? 0,
          _getStoredUnit(set.weight),
        ),
      );
      _repsControllers[set.id] = TextEditingController(text: set.reps.toString());
      _setUnits[set.id] = _getStoredUnit(set.weight);
    }
    
    setState(() {
      _sets = setsAsync;
      _exercises = exercisesAsync;
      _isLoading = false;
    });
  }

  String _getStoredUnit(String weight) {
    return WeightUnitUtils.parseStoredUnit(weight) ?? 'kg';
  }

  String _unitOf(String setId) {
    return _setUnits[setId] ?? 'kg';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('编辑训练'),
        ),
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    // Group sets by exercise
    final grouped = <String, List<WorkoutSet>>{};
    for (final set in _sets) {
      grouped.putIfAbsent(set.exerciseId, () => []).add(set);
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('编辑训练'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('取消'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('保存'),
          onPressed: () => _saveAndExit(),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Note editing
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('备注', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: _noteController,
                    placeholder: '添加备注',
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Sets grouped by exercise
            ...grouped.entries.map((entry) {
              final exerciseId = entry.key;
              final exercise = _exercises.where((e) => e.id == exerciseId).firstOrNull;
              final sets = entry.value;
              
              return _EditExerciseCard(
                exerciseName: exercise?.name ?? '未知动作',
                sets: sets,
                weightControllers: _weightControllers,
                repsControllers: _repsControllers,
                setUnits: _setUnits,
                onUnitChanged: _changeSetUnit,
                onWeightChanged: (setId, weight) => _updateSet(setId),
                onRepsChanged: (setId, reps) => _updateSet(setId),
                onDeleteSet: (setId) => _deleteSet(setId),
                onAddSet: () => _addSet(exerciseId),
              );
            }),
            // Add exercise button
            const SizedBox(height: 16),
            CupertinoButton(
              color: CupertinoColors.activeBlue,
              onPressed: () => _showAddExerciseSheet(),
              child: const Text('添加动作'),
            ),
          ],
        ),
      ),
    );
  }

  void _changeSetUnit(String setId, String nextUnitRaw) {
    final nextUnit = WeightUnitUtils.normalizeUnit(nextUnitRaw);
    final currentUnit = _unitOf(setId);
    if (nextUnit == currentUnit) return;

    final controller = _weightControllers[setId];
    if (controller != null && controller.text.trim().isNotEmpty) {
      final kg = WeightUnitUtils.parseDisplayToKg(controller.text, currentUnit);
      controller.text = kg == null ? '' : WeightUnitUtils.formatKgToDisplay(kg, nextUnit);
    }

    setState(() {
      _setUnits[setId] = nextUnit;
    });
    _updateSet(setId);
  }

  Future<void> _updateSet(String setId) async {
    final weight = _weightControllers[setId]?.text ?? '';
    final repsText = _repsControllers[setId]?.text ?? '0';
    final reps = int.tryParse(repsText) ?? 0;
    final unit = _unitOf(setId);
    
    final kg = WeightUnitUtils.parseDisplayToKg(weight, unit);
    final storedWeight = kg == null ? '' : WeightUnitUtils.formatStoredWeight(kg, unit);
    
    await workoutSetRepositoryProvider.updateSet(
      setId,
      weight: storedWeight,
      reps: reps,
    );
  }

  Future<void> _deleteSet(String setId) async {
    await workoutSetRepositoryProvider.deleteSet(setId);
    _weightControllers[setId]?.dispose();
    _repsControllers[setId]?.dispose();
    _weightControllers.remove(setId);
    _repsControllers.remove(setId);
    _setUnits.remove(setId);
    
    setState(() {
      _sets.removeWhere((s) => s.id == setId);
    });
  }

  Future<void> _addSet(String exerciseId) async {
    // Find max set number for this exercise
    int maxSetNumber = 0;
    for (final set in _sets) {
      if (set.exerciseId == exerciseId && set.setNumber > maxSetNumber) {
        maxSetNumber = set.setNumber;
      }
    }
    
    final newSetId = await workoutSetRepositoryProvider.addSet(
      sessionId: widget.session.id,
      exerciseId: exerciseId,
      setNumber: maxSetNumber + 1,
      weight: '0|kg',
      reps: 10,
    );
    
    _weightControllers[newSetId] = TextEditingController(text: '0');
    _repsControllers[newSetId] = TextEditingController(text: '10');
    _setUnits[newSetId] = 'kg';
    
    final newSet = WorkoutSet(
      id: newSetId,
      sessionId: widget.session.id,
      exerciseId: exerciseId,
      setNumber: maxSetNumber + 1,
      weight: '0|kg',
      reps: 10,
      isCompleted: false,
    );
    
    setState(() {
      _sets.add(newSet);
    });
  }

  void _showAddExerciseSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _AddExerciseToEditSheet(
        exercises: _exercises,
        existingExerciseIds: _sets.map((s) => s.exerciseId).toSet(),
        onAdd: (exerciseId) {
          Navigator.pop(context);
          _addSet(exerciseId);
        },
      ),
    );
  }

  Future<void> _saveAndExit() async {
    // Save note
    await workoutSessionRepositoryProvider.updateNote(
      widget.session.id,
      _noteController.text.trim(),
    );
    
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _EditExerciseCard extends StatelessWidget {
  final String exerciseName;
  final List<WorkoutSet> sets;
  final Map<String, TextEditingController> weightControllers;
  final Map<String, TextEditingController> repsControllers;
  final Map<String, String> setUnits;
  final Function(String, String) onUnitChanged;
  final Function(String, String) onWeightChanged;
  final Function(String, String) onRepsChanged;
  final Function(String) onDeleteSet;
  final VoidCallback onAddSet;

  const _EditExerciseCard({
    required this.exerciseName,
    required this.sets,
    required this.weightControllers,
    required this.repsControllers,
    required this.setUnits,
    required this.onUnitChanged,
    required this.onWeightChanged,
    required this.onRepsChanged,
    required this.onDeleteSet,
    required this.onAddSet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CupertinoColors.activeBlue.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  exerciseName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  child: const Icon(CupertinoIcons.add_circled, size: 24),
                  onPressed: onAddSet,
                ),
              ],
            ),
          ),
          // Sets
          ...sets.map((set) => _EditSetRow(
            setNumber: set.setNumber,
            setId: set.id,
            weightController: weightControllers[set.id],
            repsController: repsControllers[set.id],
            unit: setUnits[set.id] ?? 'kg',
            onUnitChanged: (unit) => onUnitChanged(set.id, unit),
            onWeightChanged: (value) => onWeightChanged(set.id, value),
            onRepsChanged: (value) => onRepsChanged(set.id, value),
            onDelete: () => onDeleteSet(set.id),
          )),
        ],
      ),
    );
  }
}

class _EditSetRow extends StatelessWidget {
  final int setNumber;
  final String setId;
  final TextEditingController? weightController;
  final TextEditingController? repsController;
  final String unit;
  final Function(String) onUnitChanged;
  final Function(String) onWeightChanged;
  final Function(String) onRepsChanged;
  final VoidCallback onDelete;

  const _EditSetRow({
    required this.setNumber,
    required this.setId,
    this.weightController,
    this.repsController,
    required this.unit,
    required this.onUnitChanged,
    required this.onWeightChanged,
    required this.onRepsChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Set number
          SizedBox(
            width: 30,
            child: Text(
              '$setNumber.',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          // Weight input
          Expanded(
            child: CupertinoTextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              placeholder: '0',
              suffix: GestureDetector(
                onTap: () => _showUnitPicker(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(unit, style: const TextStyle(color: CupertinoColors.activeBlue)),
                ),
              ),
              onChanged: onWeightChanged,
            ),
          ),
          const SizedBox(width: 8),
          // Reps input
          SizedBox(
            width: 60,
            child: CupertinoTextField(
              controller: repsController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              placeholder: '0',
              onChanged: onRepsChanged,
            ),
          ),
          const Text(' 次'),
          const SizedBox(width: 8),
          // Delete button
          CupertinoButton(
            padding: EdgeInsets.zero,
            minSize: 0,
            child: const Icon(CupertinoIcons.delete, color: CupertinoColors.destructiveRed, size: 20),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  void _showUnitPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('选择重量单位'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              onUnitChanged('kg');
            },
            child: Text('千克 (kg)${unit == 'kg' ? ' ✓' : ''}'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              onUnitChanged('lb');
            },
            child: Text('磅 (lb)${unit == 'lb' ? ' ✓' : ''}'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              onUnitChanged('片');
            },
            child: Text('片 (plate)${unit == '片' ? ' ✓' : ''}'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
      ),
    );
  }
}

class _AddExerciseToEditSheet extends StatelessWidget {
  final List<Exercise> exercises;
  final Set<String> existingExerciseIds;
  final Function(String) onAdd;

  const _AddExerciseToEditSheet({
    required this.exercises,
    required this.existingExerciseIds,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    // Filter out existing exercises
    final availableExercises = exercises.where((e) => !existingExerciseIds.contains(e.id)).toList();
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              '添加动作',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: availableExercises.length,
              itemBuilder: (context, index) {
                final exercise = availableExercises[index];
                return CupertinoListTile(
                  title: Text(exercise.name),
                  subtitle: exercise.category != null ? Text(exercise.category!) : null,
                  trailing: const Icon(CupertinoIcons.add_circled),
                  onTap: () => onAdd(exercise.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
