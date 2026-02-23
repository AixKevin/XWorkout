import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/features/training/presentation/providers/exercise_provider.dart';
import 'package:xworkout/core/database/database.dart';
import 'package:xworkout/features/workout/data/workout_providers.dart';

class ExerciseFormScreen extends ConsumerStatefulWidget {
  final Exercise? exercise;
  
  const ExerciseFormScreen({super.key, this.exercise});

  @override
  ConsumerState<ExerciseFormScreen> createState() => _ExerciseFormScreenState();
}

class _ExerciseFormScreenState extends ConsumerState<ExerciseFormScreen> {
  late TextEditingController _nameController;
  String? _selectedCategory;
  late TextEditingController _setsController;
  late TextEditingController _repsController;
  late TextEditingController _weightController;
  late TextEditingController _noteController;
  

  
  List<String> _getCategories(AsyncValue<List<WorkoutType>> typesAsync) {
    return typesAsync.when(
      data: (types) => types.map((t) => t.name).toList(),
      loading: () => ['胸部', '背部', '腿部'],
      error: (_, __) => ['胸部', '背部', '腿部'],
    );
  }

  bool get isEditing => widget.exercise != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.exercise?.name ?? '');
    _selectedCategory = widget.exercise?.category;
    _setsController = TextEditingController(
      text: widget.exercise?.defaultSets.toString() ?? '3',
    );
    _repsController = TextEditingController(
      text: widget.exercise?.defaultReps.toString() ?? '10',
    );
    _weightController = TextEditingController(
      text: widget.exercise?.defaultWeight?.toString() ?? '',
    );
    _noteController = TextEditingController(text: widget.exercise?.note ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _showCategoryPicker(List<String> categories) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('取消'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoButton(
                    child: const Text('确定'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                  magnification: 1.22,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: 32.0,
                  scrollController: FixedExtentScrollController(
                    initialItem: (_selectedCategory != null && categories.contains(_selectedCategory))
                        ? categories.indexOf(_selectedCategory!) 
                        : 0,
                  ),
                  onSelectedItemChanged: (int selectedItem) {
                    setState(() {
                      _selectedCategory = categories[selectedItem];
                    });
                  },
                  children: List<Widget>.generate(categories.length, (int index) {
                    return Center(
                      child: Text(
                        categories[index],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showError('请输入项目名称');
      return;
    }
    
    final notifier = ref.read(exerciseNotifierProvider.notifier);
    
    try {
      if (isEditing) {
        await notifier.updateExerciseWithValues(
          id: widget.exercise!.id,
          name: name,
          category: _selectedCategory,
          defaultSets: int.tryParse(_setsController.text) ?? 3,
          defaultReps: int.tryParse(_repsController.text) ?? 10,
          defaultWeight: double.tryParse(_weightController.text),
          note: _noteController.text.trim().isEmpty 
              ? null 
              : _noteController.text.trim(),
          createdAt: widget.exercise!.createdAt,
        );
      } else {
        await notifier.addExercise(
          name: name,
          category: _selectedCategory,
          defaultSets: int.tryParse(_setsController.text) ?? 3,
          defaultReps: int.tryParse(_repsController.text) ?? 10,
          defaultWeight: double.tryParse(_weightController.text),
          note: _noteController.text.trim().isEmpty 
              ? null 
              : _noteController.text.trim(),
        );
      }
      
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      _showError('保存失败: $e');
    }
  }
  
  Future<void> _delete() async {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除"${widget.exercise!.name}"吗？'),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('删除'),
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(exerciseNotifierProvider.notifier)
                  .deleteExercise(widget.exercise!.id);
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('错误'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('确定'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workoutTypesAsync = ref.watch(workoutTypesProvider);
    final categories = _getCategories(workoutTypesAsync);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(isEditing ? '编辑项目' : '新建项目'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('取消'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isEditing)
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _delete,
                child: Icon(
                  CupertinoIcons.delete,
                  color: Colors.red,
                ),
              ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _save,
              child: const Text('保存'),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoFormSection.insetGrouped(
              header: const Text('基本信息'),
              children: [
                CupertinoTextFormFieldRow(
                  controller: _nameController,
                  placeholder: '项目名称',
                  prefix: const Text('名称'),
                ),
                GestureDetector(
                  onTap: () {
                    if (_selectedCategory == null && categories.isNotEmpty) {
                      setState(() {
                        _selectedCategory = categories[0];
                      });
                    }
                    _showCategoryPicker(categories);
                  },
                  child: CupertinoFormRow(
                    prefix: const Text('分类'),
                    child: Text(
                      _selectedCategory ?? '选择分类',
                      style: TextStyle(
                        color: _selectedCategory == null 
                            ? CupertinoColors.placeholderText 
                            : CupertinoColors.label,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            CupertinoFormSection.insetGrouped(
              header: const Text('默认设置'),
              children: [
                CupertinoTextFormFieldRow(
                  controller: _setsController,
                  placeholder: '3',
                  prefix: const Text('组数'),
                  keyboardType: TextInputType.number,
                ),
                CupertinoTextFormFieldRow(
                  controller: _repsController,
                  placeholder: '10',
                  prefix: const Text('次数'),
                  keyboardType: TextInputType.number,
                ),
                CupertinoTextFormFieldRow(
                  controller: _weightController,
                  placeholder: '可选',
                  prefix: const Text('重量(kg)'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
            CupertinoFormSection.insetGrouped(
              header: const Text('备注'),
              children: [
                CupertinoTextFormFieldRow(
                  controller: _noteController,
                  placeholder: '可选备注',
                  maxLines: 3,
                ),
              ],
            ),
            if (isEditing) ...[
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CupertinoButton(
                  color: CupertinoColors.destructiveRed,
                  onPressed: _delete,
                  child: const Text('删除项目'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
