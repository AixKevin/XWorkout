import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xworkout/shared/utils/weight_unit_utils.dart';

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  return AppSettingsRepository();
});

class AppSettingsRepository {
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyWeightUnit = 'weight_unit';
  static const String _keyDefaultSets = 'default_sets';
  static const String _keyDefaultReps = 'default_reps';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<String> getThemeMode() async {
    final prefs = await _prefs;
    return prefs.getString(_keyThemeMode) ?? 'system';
  }

  Future<void> setThemeMode(String mode) async {
    final prefs = await _prefs;
    await prefs.setString(_keyThemeMode, mode);
  }

  /// Convert theme mode string to CupertinoThemeBrightness
  Future<Brightness?> getThemeBrightness() async {
    final mode = await getThemeMode();
    switch (mode) {
      case 'light':
        return Brightness.light;
      case 'dark':
        return Brightness.dark;
      case 'system':
      default:
        return null; // null means follow system
    }
  }

  Future<String> getWeightUnit() async {
    final prefs = await _prefs;
    return WeightUnitUtils.normalizeUnit(
      prefs.getString(_keyWeightUnit) ?? 'kg',
    );
  }

  Future<void> setWeightUnit(String unit) async {
    final prefs = await _prefs;
    await prefs.setString(_keyWeightUnit, WeightUnitUtils.normalizeUnit(unit));
  }

  Future<int> getDefaultSets() async {
    final prefs = await _prefs;
    return prefs.getInt(_keyDefaultSets) ?? 3;
  }

  Future<void> setDefaultSets(int sets) async {
    final prefs = await _prefs;
    await prefs.setInt(_keyDefaultSets, sets);
  }

  Future<int> getDefaultReps() async {
    final prefs = await _prefs;
    return prefs.getInt(_keyDefaultReps) ?? 10;
  }

  Future<void> setDefaultReps(int reps) async {
    final prefs = await _prefs;
    await prefs.setInt(_keyDefaultReps, reps);
  }

  Future<Map<String, dynamic>> getAllSettings() async {
    return {
      'themeMode': await getThemeMode(),
      'weightUnit': await getWeightUnit(),
      'defaultSets': await getDefaultSets(),
      'defaultReps': await getDefaultReps(),
    };
  }
}

// Theme mode provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, String>((ref) {
  return ThemeModeNotifier(ref.read(appSettingsRepositoryProvider));
});

class ThemeModeNotifier extends StateNotifier<String> {
  final AppSettingsRepository _settingsRepository;

  ThemeModeNotifier(this._settingsRepository) : super('system') {
    _load();
  }

  Future<void> _load() async {
    final mode = await _settingsRepository.getThemeMode();
    state = mode;
  }

  Future<void> setThemeMode(String mode) async {
    await _settingsRepository.setThemeMode(mode);
    state = mode;
  }
}
