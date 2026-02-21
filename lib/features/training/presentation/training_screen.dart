import 'package:flutter/cupertino.dart';
import 'package:xworkout/features/training/presentation/exercise_list_screen.dart';
import 'package:xworkout/features/training/presentation/plan_list_screen.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('训练'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 16),
            CupertinoListSection.insetGrouped(
              header: const Text('训练项目'),
              children: [
                CupertinoListTile(
                  leading: Icon(PhosphorIcons.barbell),
                  title: const Text('我的训练项目'),
                  subtitle: const Text('自定义训练项目'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const ExerciseListScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: const Text('健身计划'),
              children: [
                CupertinoListTile(
                  leading: Icon(PhosphorIcons.chartBar),
                  title: const Text('我的健身计划'),
                  subtitle: const Text('设置训练周期'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const PlanListScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: const Text('记录'),
              children: [
                CupertinoListTile(
                  leading: Icon(PhosphorIcons.chartLineUp),
                  title: const Text('历史记录'),
                  subtitle: const Text('查看训练历史'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    // TODO: Navigate to history
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
