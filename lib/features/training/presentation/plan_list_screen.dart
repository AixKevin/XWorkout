import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/features/training/presentation/providers/plan_provider.dart';
import 'package:xworkout/features/training/presentation/plan_form_screen.dart';
import 'package:xworkout/features/training/presentation/plan_detail_screen.dart';
import 'package:xworkout/features/templates/presentation/template_list_screen.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:xworkout/core/database/database.dart';

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
          child: Icon(PhosphorIcons.plus),
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
        child: plansAsync.when(
          data: (plans) {
            if (plans.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      PhosphorIcons.chartBar,
                      size: 64,
                      color: CupertinoColors.systemGrey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '暂无健身计划',
                      style: TextStyle(
                        fontSize: 17,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CupertinoButton(
                      child: const Text('创建第一个计划'),
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => const PlanFormScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
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
                        ? PhosphorIcons.checkCircle
                        : PhosphorIcons.chartBar,
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
                      const CupertinoListTileChevron(),
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
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (error, stack) => Center(
            child: Text('加载失败: $error'),
          ),
        ),
      ),
    );
  }
}
