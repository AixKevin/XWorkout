import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload == 'snooze') {
       // Handle snooze logic if needed, but actions are better handled in background
       // For simple snooze, we might just re-schedule
       _snoozeLastNotification();
    }
  }

  Future<void> _snoozeLastNotification() async {
     // Implementation depends on tracking the last notification
  }

  Future<bool> requestPermission() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }
    return true;
  }

  Future<void> scheduleTrainingReminder({
    required int hour,
    required int minute,
    required List<int> weekdays,
    String? title,
    String? body,
  }) async {
    await cancelAll();

    for (var weekday in weekdays) {
      final id = weekday;
      await _scheduleWeekly(id, hour, minute, weekday, title ?? '训练提醒', body ?? '今天该训练了！');
    }
  }

  Future<void> scheduleRestDayReminders({
    required int hour,
    required int minute,
    required List<int> trainingWeekdays,
    String? title,
    String? body,
  }) async {
    // Rest days are days NOT in trainingWeekdays
    final allDays = [1, 2, 3, 4, 5, 6, 7];
    final restDays = allDays.where((day) => !trainingWeekdays.contains(day)).toList();

    for (var weekday in restDays) {
      final id = weekday; // Use same ID range (1-7) as training reminders
      await _scheduleWeekly(
        id,
        hour,
        minute,
        weekday,
        title ?? '休息日提醒',
        body ?? '今天是休息日，注意放松恢复！',
        channelId: 'rest_day_reminder',
        channelName: '休息日提醒',
        channelDescription: '休息日的提醒通知',
      );
    }
  }

  Future<void> _scheduleWeekly(
    int id,
    int hour,
    int minute,
    int weekday,
    String title,
    String body, {
    String channelId = 'training_reminder',
    String channelName = '训练提醒',
    String channelDescription = '每日训练提醒通知',
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    while (scheduledDate.weekday != weekday || scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> scheduleWeeklySummary() async {
    // Schedule for Sunday at 8 PM
    await _scheduleWeekly(
      100, // ID for weekly summary
      20, // 8 PM
      0,
      7, // Sunday
      '本周总结',
      '查看你本周的训练进度和成就！',
      channelId: 'weekly_summary',
      channelName: '每周总结',
      channelDescription: '每周日晚的训练进度总结',
    );
  }

  Future<void> scheduleStreakReminder(int currentStreak) async {
    // Schedule for tomorrow if user is on a streak
    final now = tz.TZDateTime.now(tz.local);
    // Find next day 10:00 AM
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      10, // 10 AM
      0,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    } else {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      101, // ID for streak reminder
      '保持连胜！',
      '你已经连续训练 $currentStreak 天了，继续保持！',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'streak_reminder',
          '连胜提醒',
          channelDescription: '提醒用户保持训练连胜',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> showAchievementNotification(String achievementName) async {
    await _notifications.show(
      0,
      '解锁新成就！',
      '恭喜你解锁成就：$achievementName',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'achievement_notification',
          '成就通知',
          channelDescription: '获得新成就时的通知',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> snooze(int id, Duration duration, String? title, String? body) async {
    await _notifications.cancel(id);
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = now.add(duration);

    await _notifications.zonedSchedule(
      id,
      title ?? '训练提醒',
      body ?? '该训练了！(已推迟)',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'training_reminder',
          '训练提醒',
          channelDescription: '每日训练提醒通知',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelTrainingReminders() async {
    for (var i = 1; i <= 7; i++) {
      await _notifications.cancel(i);
    }
  }

  Future<void> cancelWeeklySummary() async {
    await _notifications.cancel(100);
  }

  Future<void> cancelStreakReminder() async {
    await _notifications.cancel(101);
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }
}
