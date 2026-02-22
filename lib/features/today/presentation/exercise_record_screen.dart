import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show LinearProgressIndicator, Icons, Colors;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/core/database/database.dart';
import 'package:xworkout/features/today/presentation/providers/today_provider.dart';
import 'package:xworkout/features/training/presentation/providers/exercise_provider.dart';
import 'dart:async';
import 'dart:ui';

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
  int _restSeconds = 90;
  double? _personalRecord;
  final _noteController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _initializeSets();
    _loadHistory();
  }
  
  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
  
  void _initializeSets() {
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
  
  Future<void> _loadHistory() async {
    // Load PR
    try {
      final pr = await ref.read(personalRecordProvider(widget.dayExercise.exerciseId).future);
      setState(() {
        _personalRecord = pr;
      });
    } catch (e) {
      debugPrint('Error loading PR: $e');
    }

    // Auto-fill from last session
    try {
      final lastRecord = await ref.read(lastExerciseRecordProvider(widget.dayExercise.exerciseId).future);
      if (lastRecord != null && mounted) {
        final lastWeights = lastRecord.actualWeight.split(',').map((w) => double.tryParse(w)).toList();
        final lastReps = lastRecord.actualReps.split(',').map((r) => int.tryParse(r)).toList();
        
        if (lastRecord.note != null && lastRecord.note!.isNotEmpty) {
          _noteController.text = lastRecord.note!;
        }

        setState(() {
          for (int i = 0; i < _sets.length; i++) {
            if (i < lastWeights.length && lastWeights[i] != null) {
              _sets[i] = _sets[i].copyWith(actualWeight: lastWeights[i]!);
            }
            if (i < lastReps.length && lastReps[i] != null) {
              _sets[i] = _sets[i].copyWith(actualReps: lastReps[i]!);
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Error auto-filling: $e');
    }
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
          child: const Text('关闭'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('保存'),
          onPressed: _saveRecords,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            ListView(
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
                
                // PR Badge
                if (_personalRecord != null && _personalRecord! > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '历史最佳: ${_personalRecord}kg',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.w600,
                          ),
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
                    final isPR = _personalRecord != null && set.actualWeight > _personalRecord!;
                    
                    return _SetItem(
                      setRecord: set,
                      isPR: isPR,
                      onChanged: (updated) {
                        setState(() {
                          _sets[index] = updated;
                        });
                        
                        // Check for completion to trigger timer
                        if (updated.isCompleted && !set.isCompleted) {
                          _showRestTimerDialog();
                        }
                      },
                    );
                  }).toList(),
                ),
                
                // Add set button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: CupertinoButton(
                    color: Colors.blue,
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
                        // Inherit values from last set
                        final lastSet = _sets.last;
                        _sets.add(_SetRecord(
                          setNumber: _sets.length + 1,
                          targetReps: widget.dayExercise.targetReps,
                          targetWeight: widget.dayExercise.targetWeight ?? 0,
                          actualReps: lastSet.actualReps,
                          actualWeight: lastSet.actualWeight,
                          isCompleted: false,
                        ));
                      });
                    },
                  ),
                ),

                // Quick Notes
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: CupertinoTextField(
                    controller: _noteController,
                    placeholder: '添加备注 (例如: 座椅高度5)',
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.edit, color: Colors.grey),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: CupertinoColors.systemGrey5),
                    ),
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
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation(_getCompletionColor()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getCompletionColor() {
    final completed = _sets.where((s) => s.isCompleted).length;
    if (completed == 0) return Colors.grey;
    if (completed < _sets.length) return Colors.amber;
    return Colors.green;
  }
  
  void _showRestTimerDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => _RestTimerDialog(
        initialSeconds: _restSeconds,
        onSkip: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _saveRecords() {
    // Save the records through the provider
    final completedSets = _sets.where((s) => s.isCompleted).toList();
    if (completedSets.isNotEmpty) {
      HapticFeedback.heavyImpact();
      ref.read(todayNotifierProvider.notifier).saveExerciseRecord(
        dailyRecordId: widget.dailyRecordId,
        exerciseId: widget.dayExercise.exerciseId,
        actualSets: completedSets.length,
        actualReps: completedSets.map((s) => s.actualReps).toList(),
        actualWeight: completedSets.map((s) => s.actualWeight.toDouble()).toList(),
        note: _noteController.text.isNotEmpty ? _noteController.text : null,
      );
    }
    Navigator.of(context).pop();
  }
}

class _RestTimerDialog extends StatefulWidget {
  final int initialSeconds;
  final VoidCallback onSkip;
  
  const _RestTimerDialog({
    required this.initialSeconds,
    required this.onSkip,
  });
  
  @override
  State<_RestTimerDialog> createState() => _RestTimerDialogState();
}

class _RestTimerDialogState extends State<_RestTimerDialog> {
  late int _remainingSeconds;
  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;
    _startTimer();
  }
  
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('休息一下'),
      content: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            _formatTime(_remainingSeconds),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: _remainingSeconds / widget.initialSeconds,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation(Colors.blue),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('+30s'),
                onPressed: () {
                  setState(() {
                    _remainingSeconds += 30;
                  });
                },
              ),
              const SizedBox(width: 24),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('-10s'),
                onPressed: () {
                  setState(() {
                    if (_remainingSeconds > 10) _remainingSeconds -= 10;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text('跳过'),
          onPressed: widget.onSkip,
        ),
      ],
    );
  }
  
  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
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
            color: Colors.grey,
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
  final bool isPR;
  final Function(_SetRecord) onChanged;
  
  const _SetItem({
    required this.setRecord, 
    this.isPR = false,
    required this.onChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(setRecord.setNumber),
      direction: DismissDirection.horizontal,
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16),
        child: const Icon(Icons.check, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: setRecord.isCompleted ? Colors.grey : Colors.green,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: Icon(
          setRecord.isCompleted ? Icons.replay : Icons.check,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        await HapticFeedback.lightImpact();
        onChanged(setRecord.copyWith(isCompleted: !setRecord.isCompleted));
        return false;
      },
      child: CupertinoListTile(
        leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: setRecord.isCompleted 
              ? Colors.green 
              : Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${setRecord.setNumber}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: setRecord.isCompleted 
                  ? Colors.white 
                  : Colors.grey,
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
              suffix: isPR ? const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.star, color: Colors.amber, size: 16),
              ) : null,
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
          setRecord.isCompleted ? Icons.check_circle : Icons.circle_outlined,
          color: setRecord.isCompleted 
              ? Colors.green 
              : Colors.grey,
        ),
        onPressed: () {
          onChanged(setRecord.copyWith(isCompleted: !setRecord.isCompleted));
        },
      ),
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
