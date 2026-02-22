import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/features/history/presentation/workout_history_screen.dart';
import 'package:xworkout/features/history/presentation/calendar_history_screen.dart';
import 'package:xworkout/features/data/data_management_screen.dart';
import 'package:xworkout/features/settings/settings_screen.dart';
import 'package:xworkout/features/more/data/settings_repository.dart';
import 'package:xworkout/features/more/presentation/workout_types_screen.dart';
import 'package:xworkout/core/database/database_provider.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('日历视图'),
                  subtitle: const Text('按日期查看训练'),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 28),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const CalendarHistoryScreen(),
                      ),
                    );
                  },
                ),
                CupertinoListTile(
                  leading: const Icon(Icons.save),
                  title: const Text('数据管理'),
                  subtitle: const Text('导出、备份数据'),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 28),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const DataManagementScreen(),
                      ),
                    );
                  },
                ),
                CupertinoListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('重置设置'),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 28),
                  onTap: () {
                    _showResetSettingsDialog(context, ref);
                  },
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: const Text('设置'),
              children: [
                CupertinoListTile(
                  leading: const Icon(Icons.phone_android),
                  title: const Text('显示设置'),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 28),
                  onTap: () {
                    _showDisplaySettings(context, ref);
                  },
                ),
                CupertinoListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('通用设置'),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 28),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
                CupertinoListTile(
                  leading: const Icon(Icons.category),
                  title: const Text('训练类型'),
                  subtitle: const Text('管理训练分类'),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 28),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const WorkoutTypesScreen(),
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
                  leading: const Icon(Icons.info),
                  title: const Text('关于'),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 28),
                  onTap: () {
                    _showAbout(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Center(
              child: Text(
                'XWorkout v4.8.0',
                style: TextStyle(
                  fontSize: 13,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Build 480',
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

  void _showRestTimerSettings(BuildContext context, WidgetRef ref) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _RestTimerSettingsSheet(),
    );
  }

  void _showDisplaySettings(BuildContext context, WidgetRef ref) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _DisplaySettingsSheet(),
    );
  }

  void _showResetSettingsDialog(BuildContext context, WidgetRef ref) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('重置设置'),
        content: const Text('确定要将所有设置恢复为默认值吗？'),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('重置'),
            onPressed: () async {
              await ref.read(settingsRepositoryProvider).resetToDefaults();
              if (context.mounted) Navigator.of(context).pop();
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
        content: Column(
          children: [
            const SizedBox(height: 16),
            const Text('XWorkout'),
            const Text('版本: 4.8.0 (Build 480)'),
            const SizedBox(height: 8),
            const Text('轻量级健身记录软件'),
            const Text('简洁、离线、跨平台'),
            const SizedBox(height: 16),
            const Text('作者: Aixkevin'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // TODO: Open project page
              },
              child: const Text(
                'https://github.com/AixKevin/XWorkout',
                style: TextStyle(color: CupertinoColors.activeBlue),
              ),
            ),
            const SizedBox(height: 16),
            const Text('基于 Flutter 开发'),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // TODO: Open privacy policy
              },
              child: const Text(
                '隐私政策',
                style: TextStyle(color: CupertinoColors.activeBlue),
              ),
            ),
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

class _RestTimerSettingsSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_RestTimerSettingsSheet> createState() => _RestTimerSettingsSheetState();
}

class _RestTimerSettingsSheetState extends ConsumerState<_RestTimerSettingsSheet> {
  int _duration = 60;
  bool _autoStart = true;
  bool _sound = true;
  bool _vibration = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final repo = ref.read(settingsRepositoryProvider);
    final duration = await repo.getRestTimerDuration();
    final autoStart = await repo.getAutoStartTimer();
    final sound = await repo.getSoundEnabled();
    final vibration = await repo.getVibrationEnabled();
    if (mounted) {
      setState(() {
        _duration = duration;
        _autoStart = autoStart;
        _sound = sound;
        _vibration = vibration;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
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
                  '休息计时器',
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
                  header: const Text('时长'),
                  children: [
                    CupertinoListTile(
                      title: const Text('默认时长'),
                      additionalInfo: Text('$_duration 秒'),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () => _showDurationPicker(),
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  header: const Text('行为'),
                  children: [
                    CupertinoListTile(
                      title: const Text('自动开始'),
                      trailing: CupertinoSwitch(
                        value: _autoStart,
                        onChanged: (v) {
                          setState(() => _autoStart = v);
                          ref.read(settingsRepositoryProvider).setAutoStartTimer(v);
                        },
                      ),
                    ),
                    CupertinoListTile(
                      title: const Text('声音提醒'),
                      trailing: CupertinoSwitch(
                        value: _sound,
                        onChanged: (v) {
                          setState(() => _sound = v);
                          ref.read(settingsRepositoryProvider).setSoundEnabled(v);
                        },
                      ),
                    ),
                    CupertinoListTile(
                      title: const Text('震动反馈'),
                      trailing: CupertinoSwitch(
                        value: _vibration,
                        onChanged: (v) {
                          setState(() => _vibration = v);
                          ref.read(settingsRepositoryProvider).setVibrationEnabled(v);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDurationPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  child: const Text('完成'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 32,
                scrollController: FixedExtentScrollController(
                  initialItem: [60, 90, 120, 180].indexOf(_duration),
                ),
                onSelectedItemChanged: (index) {
                  final val = [60, 90, 120, 180][index];
                  setState(() => _duration = val);
                  ref.read(settingsRepositoryProvider).setRestTimerDuration(val);
                },
                children: const [
                  Text('60 秒'),
                  Text('90 秒'),
                  Text('120 秒'),
                  Text('180 秒'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DisplaySettingsSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_DisplaySettingsSheet> createState() => _DisplaySettingsSheetState();
}

class _DisplaySettingsSheetState extends ConsumerState<_DisplaySettingsSheet> {
  String _weightUnit = 'kg';
  String _dateFormat = 'yyyy-MM-dd';
  int _firstDay = 1;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final repo = ref.read(settingsRepositoryProvider);
    final weightUnit = await repo.getWeightUnit();
    final dateFormat = await repo.getDateFormat();
    final firstDay = await repo.getFirstDayOfWeek();
    if (mounted) {
      setState(() {
        _weightUnit = weightUnit;
        _dateFormat = dateFormat;
        _firstDay = firstDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
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
                  '显示设置',
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
                  children: [
                    CupertinoListTile(
                      title: const Text('重量单位'),
                      additionalInfo: Text(_weightUnit.toUpperCase()),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () => _showWeightUnitPicker(),
                    ),
                    CupertinoListTile(
                      title: const Text('日期格式'),
                      additionalInfo: Text(_dateFormat),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () => _showDateFormatPicker(),
                    ),
                    CupertinoListTile(
                      title: const Text('每周首日'),
                      additionalInfo: Text(_firstDay == 1 ? '周一' : '周日'),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () => _showFirstDayPicker(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showWeightUnitPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('选择重量单位'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              _setWeightUnit('kg');
              Navigator.pop(context);
            },
            child: const Text('千克 (kg)'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              _setWeightUnit('lbs');
              Navigator.pop(context);
            },
            child: const Text('磅 (lbs)'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
      ),
    );
  }

  void _setWeightUnit(String unit) {
    setState(() => _weightUnit = unit);
    ref.read(settingsRepositoryProvider).setWeightUnit(unit);
  }

  void _showDateFormatPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('选择日期格式'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              _setDateFormat('yyyy-MM-dd');
              Navigator.pop(context);
            },
            child: const Text('yyyy-MM-dd'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              _setDateFormat('MM/dd/yyyy');
              Navigator.pop(context);
            },
            child: const Text('MM/dd/yyyy'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              _setDateFormat('dd/MM/yyyy');
              Navigator.pop(context);
            },
            child: const Text('dd/MM/yyyy'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
      ),
    );
  }

  void _setDateFormat(String format) {
    setState(() => _dateFormat = format);
    ref.read(settingsRepositoryProvider).setDateFormat(format);
  }

  void _showFirstDayPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('选择每周首日'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              _setFirstDay(1);
              Navigator.pop(context);
            },
            child: const Text('周一'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              _setFirstDay(7);
              Navigator.pop(context);
            },
            child: const Text('周日'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
      ),
    );
  }

  void _setFirstDay(int day) {
    setState(() => _firstDay = day);
    ref.read(settingsRepositoryProvider).setFirstDayOfWeek(day);
  }
}

