class AppNotificationSettings {
  final bool pushEnabled;
  final bool budgetExceededEnabled;
  final bool categoryLimitEnabled;

  const AppNotificationSettings({
    required this.pushEnabled,
    required this.budgetExceededEnabled,
    required this.categoryLimitEnabled,
  });

  factory AppNotificationSettings.defaults() {
    return const AppNotificationSettings(
      pushEnabled: true,
      budgetExceededEnabled: true,
      categoryLimitEnabled: true,
    );
  }

  AppNotificationSettings copyWith({
    bool? pushEnabled,
    bool? budgetExceededEnabled,
    bool? categoryLimitEnabled,
  }) {
    return AppNotificationSettings(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      budgetExceededEnabled:
          budgetExceededEnabled ?? this.budgetExceededEnabled,
      categoryLimitEnabled: categoryLimitEnabled ?? this.categoryLimitEnabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pushEnabled': pushEnabled,
      'budgetExceededEnabled': budgetExceededEnabled,
      'categoryLimitEnabled': categoryLimitEnabled,
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
    );
  }
}
