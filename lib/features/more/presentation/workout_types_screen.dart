import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/features/workout/data/workout_repository.dart';
import 'package:xworkout/features/workout/data/workout_providers.dart';

class WorkoutTypesScreen extends ConsumerStatefulWidget {
  const WorkoutTypesScreen({super.key});

  @override
  ConsumerState<WorkoutTypesScreen> createState() => _WorkoutTypesScreenState();
}

class _WorkoutTypesScreenState extends ConsumerState<WorkoutTypesScreen> {
  static const int maxTypes = 8;

  @override
  Widget build(BuildContext context) {
    final typesAsync = ref.watch(workoutTypesProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('训练类型'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('完成'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add),
          onPressed: () => _showAddTypeDialog(context),
        ),
      ),
      child: SafeArea(
        child: typesAsync.when(
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (err, stack) => Center(child: Text('错误: $err')),
          data: (types) {
            final canAdd = types.length < maxTypes;
            return ListView(
              children: [
                CupertinoListSection.insetGrouped(
                  header: Text(
                    '共 ${types.length}/$maxTypes 种类型',
                    style: const TextStyle(fontSize: 13),
                  ),
                  children: [
                    ...types.map((type) {
                      final isReadOnly = type.name == '通用';
                      return CupertinoListTile(
                        title: Text(type.name),
                        trailing: isReadOnly ? null : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: const Icon(CupertinoIcons.pencil, size: 22),
                              onPressed: () => _showRenameTypeDialog(context, type.id, type.name),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: const Icon(
                                CupertinoIcons.delete,
                                size: 22,
                                color: CupertinoColors.destructiveRed,
                              ),
                              onPressed: types.length > 1
                                  ? () => _showDeleteTypeDialog(context, type.id, type.name)
                                  : null,
                            ),
                          ],
                        ),
                      );
                    }),
                    if (!canAdd)
                      const CupertinoListTile(
                        title: Text(
                          '已达到最大数量 (8)',
                          style: TextStyle(color: CupertinoColors.systemGrey),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '提示：至少需要保留一种训练类型。删除类型不会影响已有的训练记录。',
                    style: TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showAddTypeDialog(BuildContext context) {
    final types = ref.read(workoutTypesProvider).valueOrNull ?? [];
    if (types.length >= maxTypes) {
      _showAlert(context, '提示', '已达到最大训练类型数量 ($maxTypes)');
      return;
    }

    final controller = TextEditingController();
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('添加训练类型'),
        content: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: CupertinoTextField(
            controller: controller,
            placeholder: '输入类型名称',
            autofocus: true,
            maxLength: 20,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('添加'),
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) {
                return;
              }
              await ref.read(workoutTypeRepositoryProvider).addType(name);
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showRenameTypeDialog(BuildContext context, int id, String currentName) {
    final controller = TextEditingController(text: currentName);
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('重命名训练类型'),
        content: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: CupertinoTextField(
            controller: controller,
            placeholder: '输入类型名称',
            autofocus: true,
            maxLength: 20,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('保存'),
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) {
                return;
              }
              await ref.read(workoutTypeRepositoryProvider).updateType(id, name);
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteTypeDialog(BuildContext context, int id, String name) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('删除训练类型'),
        content: Text('确定要删除 "$name" 吗？'),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('删除'),
            onPressed: () async {
              await ref.read(workoutTypeRepositoryProvider).deleteType(id);
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showAlert(BuildContext context, String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
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
}
