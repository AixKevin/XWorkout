import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/shared/utils/weight_unit_utils.dart';

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
  static const String _keyWeightUnit =
      'weight_unit'; // Mirrors AppSettingsRepository
  static const String _keyDateFormat = 'date_format';
  static const String _keyFirstDayOfWeek = 'first_day_of_week';

  // Notification Keys
  static const String _keyNotificationEnabled = 'notification_enabled';
  static const String _keyReminderHour = 'reminder_hour';
  static const String _keyReminderMinute = 'reminder_minute';
  static const String _keyReminderDays =
      'reminder_days'; // Stored as CSV string "1,2,3"
  static const String _keySmartNotificationEnabled =
      'smart_notification_enabled';
  static const String _keyWeeklySummaryEnabled = 'weekly_summary_enabled';
  static const String _keyStreakReminderEnabled = 'streak_reminder_enabled';
  static const String _keyRestDayReminderEnabled = 'rest_day_reminder_enabled';
  static const String _keyAchievementNotificationEnabled =
      'achievement_notification_enabled';

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
    return WeightUnitUtils.normalizeUnit(
      prefs.getString(_keyWeightUnit) ?? 'kg',
    );
  }

  Future<void> setWeightUnit(String unit) async {
    final prefs = await _prefs;
    await prefs.setString(_keyWeightUnit, WeightUnitUtils.normalizeUnit(unit));
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

  // Notification Settings
  Future<bool> getNotificationEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyNotificationEnabled) ?? true;
  }

  Future<void> setNotificationEnabled(bool enabled) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyNotificationEnabled, enabled);
  }

  Future<int> getReminderHour() async {
    final prefs = await _prefs;
    return prefs.getInt(_keyReminderHour) ?? 19; // Default 19:00 (7 PM)
  }

  Future<void> setReminderHour(int hour) async {
    final prefs = await _prefs;
    await prefs.setInt(_keyReminderHour, hour);
  }

  Future<int> getReminderMinute() async {
    final prefs = await _prefs;
    return prefs.getInt(_keyReminderMinute) ?? 0;
  }

  Future<void> setReminderMinute(int minute) async {
    final prefs = await _prefs;
    await prefs.setInt(_keyReminderMinute, minute);
  }

  Future<List<int>> getReminderDays() async {
    final prefs = await _prefs;
    final csv = prefs.getString(_keyReminderDays);
    if (csv == null || csv.isEmpty) {
      // Default: Mon, Wed, Fri
      return [1, 3, 5];
    }
    return csv
        .split(',')
        .map((e) => int.tryParse(e) ?? 0)
        .where((e) => e > 0)
        .toList();
  }

  Future<void> setReminderDays(List<int> days) async {
    final prefs = await _prefs;
    final csv = days.join(',');
    await prefs.setString(_keyReminderDays, csv);
  }

  Future<bool> getSmartNotificationEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_keySmartNotificationEnabled) ?? false;
  }

  Future<void> setSmartNotificationEnabled(bool enabled) async {
    final prefs = await _prefs;
    await prefs.setBool(_keySmartNotificationEnabled, enabled);
  }

  Future<bool> getWeeklySummaryEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyWeeklySummaryEnabled) ?? true;
  }

  Future<void> setWeeklySummaryEnabled(bool enabled) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyWeeklySummaryEnabled, enabled);
  }

  Future<bool> getStreakReminderEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyStreakReminderEnabled) ?? true;
  }

  Future<void> setStreakReminderEnabled(bool enabled) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyStreakReminderEnabled, enabled);
  }

  Future<bool> getRestDayReminderEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyRestDayReminderEnabled) ?? false;
  }

  Future<void> setRestDayReminderEnabled(bool enabled) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyRestDayReminderEnabled, enabled);
  }

  Future<bool> getAchievementNotificationEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyAchievementNotificationEnabled) ?? true;
  }

  Future<void> setAchievementNotificationEnabled(bool enabled) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyAchievementNotificationEnabled, enabled);
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
    await prefs.remove(_keyNotificationEnabled);
    await prefs.remove(_keyReminderHour);
    await prefs.remove(_keyReminderMinute);
    await prefs.remove(_keyReminderDays);
    await prefs.remove(_keySmartNotificationEnabled);
    await prefs.remove(_keyWeeklySummaryEnabled);
    await prefs.remove(_keyStreakReminderEnabled);
    await prefs.remove(_keyAchievementNotificationEnabled);
  }
}
