import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:xworkout/core/services/notification_service.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> {
  bool _notificationsEnabled = false;
  bool _isLoading = true;
  int _reminderHour = 9;
  int _reminderMinute = 0;
  final Set<int> _selectedWeekdays = {1, 3, 5};

  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _notificationService.initialize();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('训练提醒'),
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : ListView(
                children: [
                  const SizedBox(height: 16),
                  CupertinoListSection.insetGrouped(
                    header: const Text('提醒开关'),
                    children: [
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.bell),
                        title: const Text('启用训练提醒'),
                        trailing: CupertinoSwitch(
                          value: _notificationsEnabled,
                          onChanged: (value) => _toggleNotifications(value),
                        ),
                      ),
                    ],
                  ),
                  if (_notificationsEnabled) ...[
                    CupertinoListSection.insetGrouped(
                      header: const Text('提醒时间'),
                      children: [
                        CupertinoListTile(
                          title: const Text('提醒时间'),
                          additionalInfo: Text(
                            '${_reminderHour.toString().padLeft(2, '0')}:${_reminderMinute.toString().padLeft(2, '0')}',
                          ),
                          trailing: const CupertinoListTileChevron(),
                          onTap: () => _showTimePicker(),
                        ),
                      ],
                    ),
                    CupertinoListSection.insetGrouped(
                      header: const Text('提醒日期'),
                      footer: const Text('选择每周需要提醒的日期'),
                      children: [
                        _buildWeekdayTile(1, '周一'),
                        _buildWeekdayTile(2, '周二'),
                        _buildWeekdayTile(3, '周三'),
                        _buildWeekdayTile(4, '周四'),
                        _buildWeekdayTile(5, '周五'),
                        _buildWeekdayTile(6, '周六'),
                        _buildWeekdayTile(7, '周日'),
                      ],
                    ),
                    CupertinoListSection.insetGrouped(
                      children: [
                        CupertinoListTile(
                          leading: Icon(
                            CupertinoIcons.check_mark_circled_solid,
                            color: CupertinoColors.activeGreen,
                          ),
                          title: const Text('保存设置'),
                          onTap: () => _saveSettings(),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildWeekdayTile(int weekday, String name) {
    final isSelected = _selectedWeekdays.contains(weekday);
    return CupertinoListTile(
      title: Text(name),
      trailing: isSelected
          ? const Icon(
              CupertinoIcons.checkmark,
              color: CupertinoColors.activeGreen,
            )
          : null,
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedWeekdays.remove(weekday);
          } else {
            _selectedWeekdays.add(weekday);
          }
        });
      },
    );
  }

  Future<void> _toggleNotifications(bool value) async {
    if (value) {
      final granted = await _notificationService.requestPermission();
      if (!granted) {
        _showPermissionDeniedDialog();
        return;
      }
    }
    setState(() {
      _notificationsEnabled = value;
    });
  }

  void _showPermissionDeniedDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('权限被拒绝'),
        content: const Text('请在系统设置中开启通知权限'),
        actions: [
          CupertinoDialogAction(
            child: const Text('确定'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showTimePicker() {
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
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime(2024, 1, 1, _reminderHour, _reminderMinute),
                onDateTimeChanged: (dateTime) {
                  setState(() {
                    _reminderHour = dateTime.hour;
                    _reminderMinute = dateTime.minute;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveSettings() async {
    if (_selectedWeekdays.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('提示'),
          content: const Text('请至少选择一个提醒日期'),
          actions: [
            CupertinoDialogAction(
              child: const Text('确定'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    await _notificationService.scheduleTrainingReminder(
      hour: _reminderHour,
      minute: _reminderMinute,
      weekdays: _selectedWeekdays.toList(),
    );

    if (mounted) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('保存成功'),
          content: const Text('训练提醒已设置'),
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
}
