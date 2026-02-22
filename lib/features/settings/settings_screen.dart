import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:xworkout/features/settings/app_settings_repository.dart';

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

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final repo = ref.read(appSettingsRepositoryProvider);
    final themeMode = await repo.getThemeMode();
    final weightUnit = await repo.getWeightUnit();
    final defaultSets = await repo.getDefaultSets();
    final defaultReps = await repo.getDefaultReps();

    setState(() {
      _isDarkMode = themeMode == 'dark';
      _weightUnit = weightUnit;
      _defaultSets = defaultSets;
      _defaultReps = defaultReps;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        leading: Icon(CupertinoIcons.moon_fill),
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
                        leading: Icon(CupertinoIcons.circle_grid_hex_fill),
                        title: const Text('重量单位'),
                        additionalInfo: Text(_weightUnit.toUpperCase()),
                        trailing: const Icon(CupertinoIcons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                        onTap: () => _showWeightUnitPicker(),
                      ),
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.list_bullet),
                        title: const Text('默认组数'),
                        additionalInfo: Text('$_defaultSets 组'),
                        trailing: const Icon(CupertinoIcons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                        onTap: () => _showSetsPicker(),
                      ),
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.repeat),
                        title: const Text('默认次数'),
                        additionalInfo: Text('$_defaultReps 次'),
                        trailing: const Icon(CupertinoIcons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                        onTap: () => _showRepsPicker(),
                      ),
                    ],
                  ),
                  CupertinoListSection.insetGrouped(
                    header: const Text('关于'),
                    children: [
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.chevron_left_slash_chevron_right),
                        title: const Text('开源许可'),
                        trailing: const Icon(CupertinoIcons.chevron_right, color: CupertinoColors.systemGrey3, size: 28),
                        onTap: () => _showLicenses(),
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
            child: Text('千克 (kg)${_weightUnit == 'kg' ? ' ✓' : ''}'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => _setWeightUnit('lbs'),
            child: Text('磅 (lbs)${_weightUnit == 'lbs' ? ' ✓' : ''}'),
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
    final repo = ref.read(appSettingsRepositoryProvider);
    await repo.setWeightUnit(unit);
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
                scrollController: FixedExtentScrollController(initialItem: _defaultSets - 1),
                onSelectedItemChanged: (index) {
                  _defaultSets = index + 1;
                  ref.read(appSettingsRepositoryProvider).setDefaultSets(_defaultSets);
                },
                children: List.generate(10, (index) => Center(child: Text('${index + 1} 组'))),
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
                scrollController: FixedExtentScrollController(initialItem: _defaultReps - 1),
                onSelectedItemChanged: (index) {
                  _defaultReps = index + 1;
                  ref.read(appSettingsRepositoryProvider).setDefaultReps(_defaultReps);
                },
                children: List.generate(30, (index) => Center(child: Text('${index + 1} 次'))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLicenses() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('开源许可'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text('XWorkout 基于 MIT 许可证开源。'),
              SizedBox(height: 8),
              Text('使用的开源库:'),
              Text('- Flutter'),
              Text('- Riverpod'),
              Text('- Drift'),
              Text('- fl_chart'),
              Text('- and more...'),
            ],
          ),
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
