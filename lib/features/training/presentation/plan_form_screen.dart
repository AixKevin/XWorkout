import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Icon;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/features/training/presentation/providers/plan_provider.dart';

class PlanFormScreen extends ConsumerStatefulWidget {
  const PlanFormScreen({super.key});

  @override
  ConsumerState<PlanFormScreen> createState() => _PlanFormScreenState();
}

class _PlanFormScreenState extends ConsumerState<PlanFormScreen> {
  final _nameController = TextEditingController();
  int _cycleDays = 3;
  DateTime _startDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showError('请输入计划名称');
      return;
    }
    
    try {
      await ref.read(planNotifierProvider.notifier).createPlan(
        name: name,
        cycleDays: _cycleDays,
        startDate: _startDate,
      );
      
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      _showError('创建失败: $e');
    }
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('新建计划'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('取消'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _save,
          child: const Text('创建'),
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
                  placeholder: '计划名称',
                  prefix: const Text('名称'),
                ),
              ],
            ),
            CupertinoFormSection.insetGrouped(
              header: const Text('训练周期'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('循环天数'),
                      Text('$_cycleDays 天'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CupertinoSlider(
                    value: _cycleDays.toDouble(),
                    min: 2,
                    max: 7,
                    divisions: 5,
                    onChanged: (value) {
                      setState(() {
                        _cycleDays = value.round();
                      });
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '选择训练计划需要多少天完成一个循环。例如：3天循环意味着第1、2、3天训练后，第4天开始新的循环。',
                    style: TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ),
              ],
            ),
            CupertinoFormSection.insetGrouped(
              header: const Text('起始日期'),
              children: [
                CupertinoListTile(
                  title: const Text('开始日期'),
                  additionalInfo: Text(
                    '${_startDate.year}-${_startDate.month.toString().padLeft(2, '0')}-${_startDate.day.toString().padLeft(2, '0')}',
                  ),
                  trailing: const Icon(Icons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                  onTap: () => _showDatePicker(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: const Text('取消'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoButton(
                  child: const Text('确定'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _startDate,
                onDateTimeChanged: (date) {
                  setState(() {
                    _startDate = date;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
