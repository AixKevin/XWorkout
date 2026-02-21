import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Icon, LinearProgressIndicator;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/core/database/database.dart';
import 'package:xworkout/features/today/presentation/providers/today_provider.dart';
import 'package:xworkout/features/training/presentation/providers/exercise_provider.dart';

class ExerciseRecordScreen extends ConsumerStatefulWidget {
  final DayExercise dayExercise;
  final String dailyRecordId;
  
  const ExerciseRecordScreen({
    super.key, 
    required this.dayExercise,
    required this.dailyRecordId,
  });

  @override
  ConsumerState<ExerciseRecordScreen> createState() => _ExerciseRecordScreenState();
}

class _ExerciseRecordScreenState extends ConsumerState<ExerciseRecordScreen> {
  late List<_SetRecord> _sets;
  
  @override
  void initState() {
    super.initState();
    // Initialize with target sets
    _sets = List.generate(
      widget.dayExercise.targetSets,
      (i) => _SetRecord(
        setNumber: i + 1,
        targetReps: widget.dayExercise.targetReps,
        targetWeight: widget.dayExercise.targetWeight ?? 0,
        actualReps: widget.dayExercise.targetReps,
        actualWeight: widget.dayExercise.targetWeight ?? 0,
        isCompleted: false,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final exerciseAsync = ref.watch(exerciseListProvider);
    
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: exerciseAsync.when(
          data: (exercises) {
            final exercise = exercises.firstWhere(
              (e) => e.id == widget.dayExercise.exerciseId,
              orElse: () => exercises.first,
            );
            return Text(exercise.name);
          },
          loading: () => const Text('记录训练'),
          error: (_, __) => const Text('记录训练'),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('保存'),
          onPressed: _saveRecords,
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            // Target info
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _InfoItem(
                    label: '目标组数',
                    value: '${widget.dayExercise.targetSets}组',
                  ),
                  _InfoItem(
                    label: '目标次数',
                    value: '${widget.dayExercise.targetReps}次',
                  ),
                  if (widget.dayExercise.targetWeight != null)
                    _InfoItem(
                      label: '目标重量',
                      value: '${widget.dayExercise.targetWeight}kg',
                    ),
                ],
              ),
            ),
            
            // Sets list
            CupertinoListSection.insetGrouped(
              header: const Text('每组记录'),
              children: _sets.asMap().entries.map((entry) {
                final index = entry.key;
                final set = entry.value;
                return _SetItem(
                  setRecord: set,
                  onChanged: (updated) {
                    setState(() {
                      _sets[index] = updated;
                    });
                  },
                );
              }).toList(),
            ),
            
            // Add set button
            Padding(
              padding: const EdgeInsets.all(16),
              child: CupertinoButton(
                color: CupertinoColors.activeBlue,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('添加一组'),
                  ],
                ),
                onPressed: () {
                  setState(() {
                    _sets.add(_SetRecord(
                      setNumber: _sets.length + 1,
                      targetReps: widget.dayExercise.targetReps,
                      targetWeight: widget.dayExercise.targetWeight ?? 0,
                      actualReps: widget.dayExercise.targetReps,
                      actualWeight: widget.dayExercise.targetWeight ?? 0,
                      isCompleted: false,
                    ));
                  });
                },
              ),
            ),
            
            // Summary
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getCompletionColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    '已完成 ${_sets.where((s) => s.isCompleted).length} / ${_sets.length} 组',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _getCompletionColor(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _sets.isEmpty ? 0 : _sets.where((s) => s.isCompleted).length / _sets.length,
                    backgroundColor: CupertinoColors.systemGrey5,
                    valueColor: AlwaysStoppedAnimation(_getCompletionColor()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getCompletionColor() {
    final completed = _sets.where((s) => s.isCompleted).length;
    if (completed == 0) return CupertinoColors.systemGrey;
    if (completed < _sets.length) return CupertinoColors.systemYellow;
    return CupertinoColors.activeGreen;
  }
  
  void _saveRecords() {
    // Save the records through the provider
    final completedSets = _sets.where((s) => s.isCompleted).toList();
    if (completedSets.isNotEmpty) {
      ref.read(todayNotifierProvider.notifier).saveExerciseRecord(
        dailyRecordId: widget.dailyRecordId,
        exerciseId: widget.dayExercise.exerciseId,
        actualSets: completedSets.length,
        actualReps: completedSets.map((s) => s.actualReps).toList(),
        actualWeight: completedSets.map((s) => s.actualWeight.toDouble()).toList(),
      );
    }
    Navigator.of(context).pop();
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  
  const _InfoItem({required this.label, required this.value});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: CupertinoColors.systemGrey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SetItem extends StatelessWidget {
  final _SetRecord setRecord;
  final Function(_SetRecord) onChanged;
  
  const _SetItem({required this.setRecord, required this.onChanged});
  
  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: setRecord.isCompleted 
              ? CupertinoColors.activeGreen 
              : CupertinoColors.systemGrey5,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${setRecord.setNumber}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: setRecord.isCompleted 
                  ? CupertinoColors.white 
                  : CupertinoColors.systemGrey,
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: CupertinoTextField(
              placeholder: '次数',
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: setRecord.actualReps.toString()),
              onChanged: (value) {
                onChanged(setRecord.copyWith(actualReps: int.tryParse(value) ?? 0));
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('次'),
          ),
          Expanded(
            child: CupertinoTextField(
              placeholder: '重量',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              controller: TextEditingController(text: setRecord.actualWeight.toString()),
              onChanged: (value) {
                onChanged(setRecord.copyWith(actualWeight: double.tryParse(value) ?? 0));
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('kg'),
          ),
        ],
      ),
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Icon(
          setRecord.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: setRecord.isCompleted 
              ? CupertinoColors.activeGreen 
              : CupertinoColors.systemGrey,
        ),
        onPressed: () {
          onChanged(setRecord.copyWith(isCompleted: !setRecord.isCompleted));
        },
      ),
    );
  }
}

class _SetRecord {
  final int setNumber;
  final int targetReps;
  final double targetWeight;
  final int actualReps;
  final double actualWeight;
  final bool isCompleted;
  
  _SetRecord({
    required this.setNumber,
    required this.targetReps,
    required this.targetWeight,
    required this.actualReps,
    required this.actualWeight,
    required this.isCompleted,
  });
  
  _SetRecord copyWith({
    int? setNumber,
    int? targetReps,
    double? targetWeight,
    int? actualReps,
    double? actualWeight,
    bool? isCompleted,
  }) {
    return _SetRecord(
      setNumber: setNumber ?? this.setNumber,
      targetReps: targetReps ?? this.targetReps,
      targetWeight: targetWeight ?? this.targetWeight,
      actualReps: actualReps ?? this.actualReps,
      actualWeight: actualWeight ?? this.actualWeight,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
