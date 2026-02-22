import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/features/training/presentation/providers/plan_provider.dart';
import 'package:xworkout/features/training/presentation/plan_form_screen.dart';
import 'package:xworkout/features/training/presentation/plan_detail_screen.dart';
import 'package:xworkout/features/templates/presentation/template_list_screen.dart';
import 'package:xworkout/core/database/database.dart';
import 'package:xworkout/shared/widgets/async_value_widget.dart';
import 'package:xworkout/shared/widgets/empty_state.dart';

class PlanListScreen extends ConsumerWidget {
  const PlanListScreen({super.key});
  
  void _confirmDeletePlan(BuildContext context, WidgetRef ref, WorkoutPlan plan) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除计划"${plan.name}"吗？此操作不可恢复。'),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('删除'),
            onPressed: () {
              ref.read(planNotifierProvider.notifier).deletePlan(plan.id);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(planListProvider);
    final activePlanAsync = ref.watch(activePlanProvider);
    
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('健身计划'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('模板'),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => const TemplateListScreen(),
              ),
            );
          },
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => const PlanFormScreen(),
              ),
            );
          },
        ),
      ),
      child: SafeArea(
        child: AsyncValueWidget<List<WorkoutPlan>>(
          value: plansAsync,
          data: (plans) {
            if (plans.isEmpty) {
              return EmptyStateWidget(
                icon: CupertinoIcons.circle_grid_hex_fill,
                title: '暂无健身计划',
                message: '创建您的第一个健身计划开始训练',
                actionLabel: '创建计划',
                onAction: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const PlanFormScreen(),
                    ),
                  );
                },
              );
            }
            
            return ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                final isActive = activePlanAsync.valueOrNull?.id == plan.id;
                
                return CupertinoListTile(
                  title: Text(plan.name),
                  subtitle: Text(
                    '${plan.cycleDays}天一循环${isActive ? ' · 激活中' : ''}',
                  ),
                  leading: Icon(
                    isActive 
                        ? CupertinoIcons.check_mark_circled_solid
                        : CupertinoIcons.chart_bar,
                    color: isActive ? CupertinoColors.activeGreen : null,
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
                        onPressed: () => _confirmDeletePlan(context, ref, plan),
                      ),
                      const Icon(CupertinoIcons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => PlanDetailScreen(planId: plan.id),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
