import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/features/settings/app_settings_repository.dart';
import 'package:xworkout/features/more/data/settings_repository.dart';
import 'package:xworkout/shared/providers/weight_unit_provider.dart';

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  return AppSettingsRepository();
});

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isDarkMode = false;
  String _weightUnit = 'kg';
  int _defaultSets = 3;
  int _defaultReps = 10;
  bool _isLoading = true;
  String _dateFormat = 'yyyy-MM-dd';
  int _firstDay = 1;
  final _settingsRepo = SettingsRepository();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final repo = ref.read(appSettingsRepositoryProvider);
    final themeMode = await repo.getThemeMode();
    final defaultSets = await repo.getDefaultSets();
    final defaultReps = await repo.getDefaultReps();
    final dateFormat = await _settingsRepo.getDateFormat();
    final firstDay = await _settingsRepo.getFirstDayOfWeek();

    setState(() {
      _isDarkMode = themeMode == 'dark';
      _defaultSets = defaultSets;
      _defaultReps = defaultReps;
      _dateFormat = dateFormat;
      _firstDay = firstDay;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final globalWeightUnit = ref.watch(weightUnitProvider);
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('设置'),
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : ListView(
                children: [
                  const SizedBox(height: 16),
                  CupertinoListSection.insetGrouped(
                    header: const Text('外观'),
                    children: [
                      CupertinoListTile(
                        leading: Icon(Icons.dark_mode),
                        title: const Text('深色模式'),
                        trailing: CupertinoSwitch(
                          value: _isDarkMode,
                          onChanged: (value) => _setDarkMode(value),
                        ),
                      ),
                    ],
                  ),
                  CupertinoListSection.insetGrouped(
                    header: const Text('训练'),
                    children: [
                      CupertinoListTile(
                        leading: Icon(Icons.grid_view),
                        title: const Text('重量单位'),
                        additionalInfo: Text(globalWeightUnit.toUpperCase()),
                        trailing: Icon(CupertinoIcons.chevron_right,
                            color: Colors.grey[400], size: 28),
                        onTap: () => _showWeightUnitPicker(),
                      ),
                      CupertinoListTile(
                        leading: Icon(Icons.list),
                        title: const Text('默认组数'),
                        additionalInfo: Text('$_defaultSets 组'),
                        trailing: Icon(CupertinoIcons.chevron_right,
                            color: Colors.grey[400], size: 28),
                        onTap: () => _showSetsPicker(),
                      ),
                      CupertinoListTile(
                        leading: Icon(Icons.repeat),
                        title: const Text('默认次数'),
                        additionalInfo: Text('$_defaultReps 次'),
                        trailing: Icon(CupertinoIcons.chevron_right,
                            color: Colors.grey[400], size: 28),
                        onTap: () => _showRepsPicker(),
                      ),
                      CupertinoListTile(
                        leading: Icon(Icons.calendar_today),
                        title: const Text('日期格式'),
                        additionalInfo: Text(_dateFormat),
                        trailing: Icon(CupertinoIcons.chevron_right,
                            color: Colors.grey[400], size: 28),
                        onTap: () => _showDateFormatPicker(),
                      ),
                      CupertinoListTile(
                        leading: Icon(Icons.calendar_view_week),
                        title: const Text('每周首日'),
                        additionalInfo: Text(_firstDay == 1 ? '周一' : '周日'),
                        trailing: Icon(CupertinoIcons.chevron_right,
                            color: Colors.grey[400], size: 28),
                        onTap: () => _showFirstDayPicker(),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _setDarkMode(bool value) async {
    final repo = ref.read(appSettingsRepositoryProvider);
    await repo.setThemeMode(value ? 'dark' : 'light');
    setState(() {
      _isDarkMode = value;
    });
  }

  void _showWeightUnitPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('选择重量单位'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => _setWeightUnit('kg'),
            child: Text(
                '千克 (kg)${ref.read(weightUnitProvider) == 'kg' ? ' ✓' : ''}'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => _setWeightUnit('lb'),
            child: Text(
                '磅 (lb)${ref.read(weightUnitProvider) == 'lb' ? ' ✓' : ''}'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
      ),
    );
  }

  Future<void> _setWeightUnit(String unit) async {
    await ref.read(weightUnitProvider.notifier).setWeightUnit(unit);
    setState(() {
      _weightUnit = unit;
    });
    if (mounted) Navigator.of(context).pop();
  }

  void _showSetsPicker() {
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
              child: CupertinoPicker(
                itemExtent: 40,
                scrollController:
                    FixedExtentScrollController(initialItem: _defaultSets - 1),
                onSelectedItemChanged: (index) {
                  _defaultSets = index + 1;
                  ref
                      .read(appSettingsRepositoryProvider)
                      .setDefaultSets(_defaultSets);
                },
                children: List.generate(
                    10, (index) => Center(child: Text('${index + 1} 组'))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRepsPicker() {
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
              child: CupertinoPicker(
                itemExtent: 40,
                scrollController:
                    FixedExtentScrollController(initialItem: _defaultReps - 1),
                onSelectedItemChanged: (index) {
                  _defaultReps = index + 1;
                  ref
                      .read(appSettingsRepositoryProvider)
                      .setDefaultReps(_defaultReps);
                },
                children: List.generate(
                    30, (index) => Center(child: Text('${index + 1} 次'))),
              ),
            ),
          ],
        ),
      ),
    );
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
    _settingsRepo.setDateFormat(format);
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
    _settingsRepo.setFirstDayOfWeek(day);
  }
}
