import 'package:flutter/cupertino.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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
                  leading: Icon(PhosphorIcons.chartLineUp()),
                  title: const Text('历史记录'),
                  subtitle: const Text('查看训练历史'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                CupertinoListTile(
                  leading: Icon(PhosphorIcons.export()),
                  title: const Text('导出数据'),
                  subtitle: const Text('导出训练记录'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: const Text('应用'),
              children: [
                CupertinoListTile(
                  leading: Icon(PhosphorIcons.gear()),
                  title: const Text('设置'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    _showSettings(context);
                  },
                ),
                CupertinoListTile(
                  leading: Icon(PhosphorIcons.info()),
                  title: const Text('关于'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    _showAbout(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'XWorkout v1.0.0',
                style: TextStyle(
                  fontSize: 13,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
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
                        title: const Text('训练提醒'),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () {},
                      ),
                      CupertinoListTile(
                        title: const Text('默认组数'),
                        additionalInfo: const Text('3'),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () {},
                      ),
                    ],
                  ),
                  CupertinoListSection.insetGrouped(
                    header: const Text('数据'),
                    children: [
                      CupertinoListTile(
                        title: const Text('清除所有数据'),
                        trailing: Icon(
                          CupertinoIcons.trash,
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
            Text('版本: 1.0.0'),
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
