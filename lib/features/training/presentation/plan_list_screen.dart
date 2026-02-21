import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/features/training/presentation/providers/plan_provider.dart';
import 'package:xworkout/features/training/presentation/plan_form_screen.dart';
import 'package:xworkout/features/training/presentation/plan_detail_screen.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PlanListScreen extends ConsumerWidget {
  const PlanListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(planListProvider);
    final activePlanAsync = ref.watch(activePlanProvider);
    
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('健身计划'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(PhosphorIcons.plus()),
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
                      PhosphorIcons.chartBar(),
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
                        ? PhosphorIcons.checkmarkCircle(PhosphorIconsStyle.fill)
                        : PhosphorIcons.chartBar(),
                    color: isActive ? CupertinoColors.activeGreen : null,
                  ),
                  trailing: const CupertinoListTileChevron(),
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
