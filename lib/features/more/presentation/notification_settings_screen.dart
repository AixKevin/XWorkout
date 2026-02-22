import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/core/services/notification_service.dart';
import 'package:xworkout/features/more/data/settings_repository.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> {
  bool _notificationEnabled = true;
  int _reminderHour = 19;
  int _reminderMinute = 0;
  List<int> _reminderDays = [1, 3, 5];
  bool _smartNotificationEnabled = false;
  bool _restDayReminderEnabled = false;
  bool _weeklySummaryEnabled = true;
  bool _streakReminderEnabled = true;
  bool _achievementNotificationEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final repo = ref.read(settingsRepositoryProvider);
    final notificationEnabled = await repo.getNotificationEnabled();
    final reminderHour = await repo.getReminderHour();
    final reminderMinute = await repo.getReminderMinute();
    final reminderDays = await repo.getReminderDays();
    final smartNotificationEnabled = await repo.getSmartNotificationEnabled();
    final restDayReminderEnabled = await repo.getRestDayReminderEnabled();
    final weeklySummaryEnabled = await repo.getWeeklySummaryEnabled();
    final streakReminderEnabled = await repo.getStreakReminderEnabled();
    final achievementNotificationEnabled = await repo.getAchievementNotificationEnabled();

    if (mounted) {
      setState(() {
        _notificationEnabled = notificationEnabled;
        _reminderHour = reminderHour;
        _reminderMinute = reminderMinute;
        _reminderDays = reminderDays;
        _smartNotificationEnabled = smartNotificationEnabled;
        _restDayReminderEnabled = restDayReminderEnabled;
        _weeklySummaryEnabled = weeklySummaryEnabled;
        _streakReminderEnabled = streakReminderEnabled;
        _achievementNotificationEnabled = achievementNotificationEnabled;
      });
    }
  }

  Future<void> _saveSettings() async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.setNotificationEnabled(_notificationEnabled);
    await repo.setReminderHour(_reminderHour);
    await repo.setReminderMinute(_reminderMinute);
    await repo.setReminderDays(_reminderDays);
    await repo.setSmartNotificationEnabled(_smartNotificationEnabled);
    await repo.setRestDayReminderEnabled(_restDayReminderEnabled);
    await repo.setWeeklySummaryEnabled(_weeklySummaryEnabled);
    await repo.setStreakReminderEnabled(_streakReminderEnabled);
    await repo.setAchievementNotificationEnabled(_achievementNotificationEnabled);

    final notificationService = NotificationService();
    
    // Manage reminders
    await notificationService.cancelTrainingReminders();
    if (_notificationEnabled) {
      if (_reminderDays.isNotEmpty) {
        await notificationService.scheduleTrainingReminder(
          hour: _reminderHour,
          minute: _reminderMinute,
          weekdays: _reminderDays,
        );
      }
      
      if (_restDayReminderEnabled) {
        await notificationService.scheduleRestDayReminders(
          hour: _reminderHour,
          minute: _reminderMinute,
          trainingWeekdays: _reminderDays,
        );
      }
    }
    
    // Manage weekly summary
    await notificationService.cancelWeeklySummary();
    if (_notificationEnabled && _weeklySummaryEnabled) {
      await notificationService.scheduleWeeklySummary();
    }
    
    // Manage streak reminder
    if (!_notificationEnabled || !_streakReminderEnabled) {
      await notificationService.cancelStreakReminder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('通知设置'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 16),
            CupertinoListSection.insetGrouped(
              header: const Text('通用'),
              children: [
                CupertinoListTile(
                  title: const Text('允许通知'),
                  trailing: CupertinoSwitch(
                    value: _notificationEnabled,
                    onChanged: (v) {
                      setState(() => _notificationEnabled = v);
                      _saveSettings();
                    },
                  ),
                ),
              ],
            ),
            if (_notificationEnabled) ...[
              CupertinoListSection.insetGrouped(
                header: const Text('训练提醒'),
                children: [
                  CupertinoListTile(
                    title: const Text('提醒时间'),
                    additionalInfo: Text(
                      '${_reminderHour.toString().padLeft(2, '0')}:${_reminderMinute.toString().padLeft(2, '0')}',
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () => _showTimePicker(),
                  ),
                  CupertinoListTile(
                    title: const Text('重复'),
                    additionalInfo: Text(_getWeekdaysString()),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () => _showWeekdaysPicker(),
                  ),
                  CupertinoListTile(
                    title: const Text('休息日提醒'),
                    subtitle: const Text('在非训练日提醒休息'),
                    trailing: CupertinoSwitch(
                      value: _restDayReminderEnabled,
                      onChanged: (v) {
                        setState(() => _restDayReminderEnabled = v);
                        _saveSettings();
                      },
                    ),
                  ),
                ],
              ),
              CupertinoListSection.insetGrouped(
                header: const Text('智能与进度'),
                footer: const Text('智能跳过休息日仅在固定周期计划下生效。'),
                children: [
                  CupertinoListTile(
                    title: const Text('智能跳过休息日'),
                    trailing: CupertinoSwitch(
                      value: _smartNotificationEnabled,
                      onChanged: (v) {
                        setState(() => _smartNotificationEnabled = v);
                        _saveSettings();
                      },
                    ),
                  ),
                  CupertinoListTile(
                    title: const Text('每周总结'),
                    trailing: CupertinoSwitch(
                      value: _weeklySummaryEnabled,
                      onChanged: (v) {
                        setState(() => _weeklySummaryEnabled = v);
                        _saveSettings();
                      },
                    ),
                  ),
                  CupertinoListTile(
                    title: const Text('连胜提醒'),
                    trailing: CupertinoSwitch(
                      value: _streakReminderEnabled,
                      onChanged: (v) {
                        setState(() => _streakReminderEnabled = v);
                        _saveSettings();
                      },
                    ),
                  ),
                  CupertinoListTile(
                    title: const Text('成就通知'),
                    trailing: CupertinoSwitch(
                      value: _achievementNotificationEnabled,
                      onChanged: (v) {
                        setState(() => _achievementNotificationEnabled = v);
                        _saveSettings();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getWeekdaysString() {
    if (_reminderDays.isEmpty) return '无';
    if (_reminderDays.length == 7) return '每天';
    
    final weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    _reminderDays.sort();
    return _reminderDays.map((d) => weekdays[d - 1]).join(', ');
  }

  void _showTimePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250,
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
                  child: const Text('完成'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _saveSettings();
                  },
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                initialDateTime: DateTime(2023, 1, 1, _reminderHour, _reminderMinute),
                onDateTimeChanged: (date) {
                  setState(() {
                    _reminderHour = date.hour;
                    _reminderMinute = date.minute;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWeekdaysPicker() {
    final weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 400,
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
                    '选择重复时间',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text('完成'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _saveSettings();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: StatefulBuilder(
                builder: (context, setModalState) {
                  return ListView.builder(
                    itemCount: weekdays.length,
                    itemBuilder: (context, index) {
                      final day = index + 1;
                      final isSelected = _reminderDays.contains(day);
                      return CupertinoListTile(
                        title: Text(weekdays[index]),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: Colors.blue)
                            : null,
                        onTap: () {
                          setModalState(() {
                            if (isSelected) {
                              _reminderDays.remove(day);
                            } else {
                              _reminderDays.add(day);
                            }
                            setState(() {}); // Update parent state immediately for feedback
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
