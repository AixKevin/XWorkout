import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Icon;
import 'package:xworkout/features/history/presentation/history_screen.dart';
import 'package:xworkout/features/data/data_management_screen.dart';
import 'package:xworkout/features/statistics/presentation/statistics_screen.dart';
import 'package:xworkout/features/settings/notification_settings_screen.dart';
import 'package:xworkout/features/settings/settings_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('更多'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 16),
            CupertinoListSection.insetGrouped(
              header: const Text('数据'),
              children: [
                CupertinoListTile(
                  leading: Icon(Icons.show_chart),
                  title: const Text('历史记录'),
                  subtitle: const Text('查看训练历史'),
                  trailing: const Icon(Icons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const HistoryScreen(),
                      ),
                    );
                  },
                ),
                CupertinoListTile(
                  leading: Icon(Icons.bar_chart),
                  title: const Text('统计'),
                  subtitle: const Text('训练数据分析'),
                  trailing: const Icon(Icons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const StatisticsScreen(),
                      ),
                    );
                  },
                ),
                CupertinoListTile(
                  leading: Icon(Icons.data_usage),
                  title: const Text('数据管理'),
                  subtitle: const Text('导出、备份数据'),
                  trailing: const Icon(Icons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const DataManagementScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: const Text('应用'),
              children: [
                CupertinoListTile(
                  leading: Icon(Icons.settings),
                  title: const Text('设置'),
                  trailing: const Icon(Icons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
                CupertinoListTile(
                  leading: Icon(Icons.info),
                  title: const Text('关于'),
                  trailing: const Icon(Icons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                  onTap: () {
                    _showAbout(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            const             Center(
              child: Text(
                'XWorkout v1.7.0',
                style: TextStyle(
                  fontSize: 13,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                '轻量级健身记录软件',
                style: TextStyle(
                  fontSize: 13,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showComingSoon(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('即将推出'),
        content: const Text('该功能正在开发中，敬请期待！'),
        actions: [
          CupertinoDialogAction(
            child: const Text('确定'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
  
  void _showSettings(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '设置',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text('完成'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  CupertinoListSection.insetGrouped(
                    header: const Text('通用'),
                    children: [
                      CupertinoListTile(
                        title: const Text('深色模式'),
                        trailing: CupertinoSwitch(
                          value: false,
                          onChanged: (value) {
                          },
                        ),
                      ),
                      CupertinoListTile(
                        title: const Text('声音提醒'),
                        trailing: CupertinoSwitch(
                          value: true,
                          onChanged: (value) {
                          },
                        ),
                      ),
                    ],
                  ),
                  CupertinoListSection.insetGrouped(
                    header: const Text('训练'),
                    children: [
                      CupertinoListTile(
                        leading: Icon(Icons.notifications),
                        title: const Text('训练提醒'),
                        trailing: const Icon(Icons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                        onTap: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const NotificationSettingsScreen(),
                            ),
                          );
                        },
                      ),
                      CupertinoListTile(
                        title: const Text('默认组数'),
                        additionalInfo: const Text('3'),
                        trailing: const Icon(Icons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                        onTap: () {},
                      ),
                    ],
                  ),
                  CupertinoListSection.insetGrouped(
                    header: const Text('数据'),
                    children: [
                      CupertinoListTile(
                        title: const Text('清除所有数据'),
                        trailing: const Icon(
                          Icons.delete,
                          color: CupertinoColors.destructiveRed,
                        ),
                        onTap: () {
                          _showClearDataDialog(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showClearDataDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('清除所有数据'),
        content: const Text('确定要清除所有训练数据吗？此操作不可恢复。'),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('清除'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
  
  void _showAbout(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('关于 XWorkout'),
        content: const Column(
          children: [
            SizedBox(height: 16),
            Text('XWorkout'),
            Text('版本: 1.7.0'),
            SizedBox(height: 8),
            Text('轻量级健身记录软件'),
            Text('简洁、离线、跨平台'),
            SizedBox(height: 16),
            Text('基于 Flutter 开发'),
          ],
        ),
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
