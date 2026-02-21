import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

class SettingsRepository {
  // Rest Timer Keys
  static const String _keyRestTimerDuration = 'rest_timer_duration';
  static const String _keyAutoStartTimer = 'auto_start_timer';
  static const String _keySoundEnabled = 'sound_enabled';
  static const String _keyVibrationEnabled = 'vibration_enabled';

  // Display Keys
  static const String _keyWeightUnit = 'weight_unit'; // Mirrors AppSettingsRepository
  static const String _keyDateFormat = 'date_format';
  static const String _keyFirstDayOfWeek = 'first_day_of_week';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // Rest Timer
  Future<int> getRestTimerDuration() async {
    final prefs = await _prefs;
    return prefs.getInt(_keyRestTimerDuration) ?? 60;
  }

  Future<void> setRestTimerDuration(int duration) async {
    final prefs = await _prefs;
    await prefs.setInt(_keyRestTimerDuration, duration);
  }

  Future<bool> getAutoStartTimer() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyAutoStartTimer) ?? true;
  }

  Future<void> setAutoStartTimer(bool enabled) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyAutoStartTimer, enabled);
  }

  Future<bool> getSoundEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_keySoundEnabled) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    final prefs = await _prefs;
    await prefs.setBool(_keySoundEnabled, enabled);
  }

  Future<bool> getVibrationEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyVibrationEnabled) ?? true;
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyVibrationEnabled, enabled);
  }

  // Display
  Future<String> getWeightUnit() async {
    final prefs = await _prefs;
    return prefs.getString(_keyWeightUnit) ?? 'kg';
  }

  Future<void> setWeightUnit(String unit) async {
    final prefs = await _prefs;
    await prefs.setString(_keyWeightUnit, unit);
  }

  Future<String> getDateFormat() async {
    final prefs = await _prefs;
    return prefs.getString(_keyDateFormat) ?? 'yyyy-MM-dd';
  }

  Future<void> setDateFormat(String format) async {
    final prefs = await _prefs;
    await prefs.setString(_keyDateFormat, format);
  }

  Future<int> getFirstDayOfWeek() async {
    final prefs = await _prefs;
    // 1 = Monday, 7 = Sunday. Default to Monday (1)
    return prefs.getInt(_keyFirstDayOfWeek) ?? 1;
  }

  Future<void> setFirstDayOfWeek(int day) async {
    final prefs = await _prefs;
    await prefs.setInt(_keyFirstDayOfWeek, day);
  }

  // Data Management
  Future<void> resetToDefaults() async {
    final prefs = await _prefs;
    await prefs.remove(_keyRestTimerDuration);
    await prefs.remove(_keyAutoStartTimer);
    await prefs.remove(_keySoundEnabled);
    await prefs.remove(_keyVibrationEnabled);
    await prefs.remove(_keyWeightUnit);
    await prefs.remove(_keyDateFormat);
    await prefs.remove(_keyFirstDayOfWeek);
    // Add other keys if necessary or use clear() but be careful not to wipe unrelated prefs
  }
}
