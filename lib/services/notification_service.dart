import 'package:finova_ai/models/app_notification_settings.dart';
import 'package:finova_ai/utils/formatters.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'finova_ai_alerts',
    'Finova Alerts',
    description: 'Budget, category, and AI notifications for Finova AI.',
    importance: Importance.high,
  );

  static const int _dailyReminderId = 3001;
  static const int _monthlySummaryId = 3002;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool _timeZoneInitialized = false;

  Future<void> init() async {
    if (_initialized) {
      return;
    }

    _configureTimeZone();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(settings);

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    _initialized = true;
  }

  void _configureTimeZone() {
    if (_timeZoneInitialized) {
      return;
    }

    tzdata.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }
    _timeZoneInitialized = true;
  }

  Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> showForegroundNotification({
    required String title,
    required String body,
  }) async {
    await init();
    await _plugin.show(
      title.hashCode ^ body.hashCode,
      title,
      body,
      _notificationDetails(),
    );
  }

  Future<void> cancelAllNotifications() async {
    await init();
    await _plugin.cancelAll();
  }

  Future<void> syncScheduledNotifications({
    required AppNotificationSettings settings,
    required List<Map<String, dynamic>> transactions,
  }) async {
    await init();

    if (!settings.pushEnabled) {
      await _plugin.cancel(_dailyReminderId);
      await _plugin.cancel(_monthlySummaryId);
      return;
    }

    await _scheduleDailyReminder();
    await _scheduleMonthlySummary(transactions: transactions);
  }

  Future<void> _scheduleDailyReminder() async {
    final scheduledDate = _nextTimeOfDay(hour: 20, minute: 0);

    await _plugin.zonedSchedule(
      _dailyReminderId,
      'Track today\'s expenses',
      'Add today\'s spending to keep your budgets and AI insights accurate.',
      scheduledDate,
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _scheduleMonthlySummary({
    required List<Map<String, dynamic>> transactions,
  }) async {
    final now = DateTime.now();
    final previousMonthStart = DateTime(now.year, now.month - 1, 1);
    final currentMonthStart = DateTime(now.year, now.month, 1);

    double total = 0.0;
    final categoryTotals = <String, double>{};

    for (final data in transactions) {
      final date = _readDate(data['date']);
      if (date == null) {
        continue;
      }
      if (date.isBefore(previousMonthStart) || !date.isBefore(currentMonthStart)) {
        continue;
      }

      final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
      final category = _normalizeCategoryKey(data['category']?.toString());
      total += amount;
      categoryTotals[category] = (categoryTotals[category] ?? 0.0) + amount;
    }

    final monthLabel = _monthLabel(previousMonthStart);
    final topCategoryEntry = categoryTotals.entries.isEmpty
        ? null
        : (categoryTotals.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
            .first;

    final title = '$monthLabel Summary';
    final body = total > 0
        ? topCategoryEntry != null
            ? 'You spent ${formatCurrency(total)} in $monthLabel. ${_titleCase(topCategoryEntry.key)} led at ${formatCurrency(topCategoryEntry.value)}.'
            : 'You spent ${formatCurrency(total)} in $monthLabel. Open Finova AI to review your monthly trends.'
        : 'No expenses were recorded in $monthLabel. Start the new month by tracking every spend.';

    await _plugin.zonedSchedule(
      _monthlySummaryId,
      title,
      body,
      _nextMonthlySummaryTime(hour: 9, minute: 0),
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  }

  Future<void> evaluateBudgetNotifications({
    required String userId,
    required AppNotificationSettings settings,
    required double monthlyIncome,
    required Map<String, double> budgets,
    required Map<String, double> spentPerCategory,
  }) async {
    await init();

    if (!settings.pushEnabled) {
      return;
    }

    final totalSpent = spentPerCategory.values.fold<double>(
      0.0,
      (sum, amount) => sum + amount,
    );
    final monthKey = _currentMonthKey();
    final prefs = await SharedPreferences.getInstance();

    if (settings.budgetExceededEnabled &&
        monthlyIncome > 0 &&
        totalSpent > monthlyIncome) {
      final budgetAlertKey = 'budget_alert_${userId}_$monthKey';
      final hasShown = prefs.getBool(budgetAlertKey) ?? false;

      if (!hasShown) {
        await _plugin.show(
          1001,
          'Budget exceeded',
          'You have spent ${formatCurrency(totalSpent)} out of ${formatCurrency(monthlyIncome)} this month.',
          _notificationDetails(),
        );
        await prefs.setBool(budgetAlertKey, true);
      }
    }

    if (!settings.categoryLimitEnabled) {
      return;
    }

    for (final entry in budgets.entries) {
      final categoryKey = entry.key.toLowerCase();
      final budget = entry.value;
      if (budget <= 0) {
        continue;
      }

      final spent = spentPerCategory[categoryKey] ?? 0.0;
      if (spent <= budget) {
        continue;
      }

      final categoryAlertKey = 'category_alert_${userId}_${monthKey}_$categoryKey';
      final hasShown = prefs.getBool(categoryAlertKey) ?? false;
      if (hasShown) {
        continue;
      }

      await _plugin.show(
        2000 + (categoryKey.hashCode.abs() % 500),
        '${_titleCase(categoryKey)} budget exceeded',
        'You have spent ${formatCurrency(spent)} against a ${formatCurrency(budget)} ${_titleCase(categoryKey).toLowerCase()} budget.',
        _notificationDetails(),
      );
      await prefs.setBool(categoryAlertKey, true);
    }
  }

  NotificationDetails _notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  tz.TZDateTime _nextTimeOfDay({required int hour, required int minute}) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  tz.TZDateTime _nextMonthlySummaryTime({
    required int hour,
    required int minute,
  }) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, 1, hour, minute);
    if (!scheduled.isAfter(now)) {
      scheduled = tz.TZDateTime(tz.local, now.year, now.month + 1, 1, hour, minute);
    }
    return scheduled;
  }

  DateTime? _readDate(dynamic raw) {
    if (raw is DateTime) {
      return raw;
    }
    if (raw != null && raw.runtimeType.toString() == 'Timestamp') {
      return (raw as dynamic).toDate() as DateTime?;
    }
    return null;
  }

  String _currentMonthKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  String _monthLabel(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[date.month - 1];
  }

  String _normalizeCategoryKey(String? value) {
    final normalized = value?.trim().toLowerCase() ?? 'other';
    if (normalized == 'others' || normalized.isEmpty) {
      return 'other';
    }
    return normalized;
  }

  String _titleCase(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized.isEmpty) {
      return 'Category';
    }

    return normalized[0].toUpperCase() + normalized.substring(1);
  }
}
