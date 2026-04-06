class AppNotificationSettings {
  final bool pushEnabled;
  final bool budgetExceededEnabled;
  final bool categoryLimitEnabled;
  final bool aiAlertsEnabled;
  final int reminderHour;
  final int reminderMinute;

  const AppNotificationSettings({
    required this.pushEnabled,
    required this.budgetExceededEnabled,
    required this.categoryLimitEnabled,
    required this.aiAlertsEnabled,
    required this.reminderHour,
    required this.reminderMinute,
  });

  factory AppNotificationSettings.defaults() {
    return const AppNotificationSettings(
      pushEnabled: true,
      budgetExceededEnabled: true,
      categoryLimitEnabled: true,
      aiAlertsEnabled: true,
      reminderHour: 20,
      reminderMinute: 0,
    );
  }

  AppNotificationSettings copyWith({
    bool? pushEnabled,
    bool? budgetExceededEnabled,
    bool? categoryLimitEnabled,
    bool? aiAlertsEnabled,
    int? reminderHour,
    int? reminderMinute,
  }) {
    return AppNotificationSettings(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      budgetExceededEnabled:
          budgetExceededEnabled ?? this.budgetExceededEnabled,
      categoryLimitEnabled: categoryLimitEnabled ?? this.categoryLimitEnabled,
      aiAlertsEnabled: aiAlertsEnabled ?? this.aiAlertsEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pushEnabled': pushEnabled,
      'budgetExceededEnabled': budgetExceededEnabled,
      'categoryLimitEnabled': categoryLimitEnabled,
      'aiAlertsEnabled': aiAlertsEnabled,
      'reminderHour': reminderHour,
      'reminderMinute': reminderMinute,
    };
  }

  factory AppNotificationSettings.fromMap(dynamic raw) {
    if (raw is! Map) {
      return AppNotificationSettings.defaults();
    }

    return AppNotificationSettings(
      pushEnabled: raw['pushEnabled'] is bool ? raw['pushEnabled'] as bool : true,
      budgetExceededEnabled:
          raw['budgetExceededEnabled'] is bool
              ? raw['budgetExceededEnabled'] as bool
              : true,
      categoryLimitEnabled:
          raw['categoryLimitEnabled'] is bool
              ? raw['categoryLimitEnabled'] as bool
              : true,
      aiAlertsEnabled:
          raw['aiAlertsEnabled'] is bool
              ? raw['aiAlertsEnabled'] as bool
              : true,
      reminderHour:
          raw['reminderHour'] is int
              ? raw['reminderHour'] as int
              : raw['reminderHour'] is num
              ? (raw['reminderHour'] as num).toInt()
              : 20,
      reminderMinute:
          raw['reminderMinute'] is int
              ? raw['reminderMinute'] as int
              : raw['reminderMinute'] is num
              ? (raw['reminderMinute'] as num).toInt()
              : 0,
    );
  }
}
