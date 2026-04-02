import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finova_ai/models/app_notification_settings.dart';
import 'package:finova_ai/providers/budget_provider.dart';
import 'package:finova_ai/providers/income_provider.dart';
import 'package:finova_ai/providers/notification_settings_provider.dart';
import 'package:finova_ai/providers/transactions_stream_provider.dart';
import 'package:finova_ai/services/notification_service.dart';
import 'package:finova_ai/services/push_notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationBootstrap extends ConsumerStatefulWidget {
  final Widget child;

  const NotificationBootstrap({super.key, required this.child});

  @override
  ConsumerState<NotificationBootstrap> createState() =>
      _NotificationBootstrapState();
}

class _NotificationBootstrapState extends ConsumerState<NotificationBootstrap> {
  bool _permissionsRequestedThisSession = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(notificationSettingsProvider, (_, __) => _syncNotifications());
    ref.listen(budgetProvider, (_, __) => _syncNotifications());
    ref.listen(monthlyIncomeProvider, (_, __) => _syncNotifications());
    ref.listen(transactionsStreamProvider, (_, __) => _syncNotifications());

    return widget.child;
  }

  Future<void> _syncNotifications() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      await NotificationService.instance.cancelAllNotifications();
      return;
    }

    final settings = ref.read(notificationSettingsProvider).maybeWhen(
      data: (value) => value,
      orElse: AppNotificationSettings.defaults,
    );

    await NotificationService.instance.init();
    await PushNotificationService.instance.init();
    await PushNotificationService.instance.syncTokenForCurrentUser();

    if (settings.pushEnabled && !_permissionsRequestedThisSession) {
      await NotificationService.instance.requestPermissions();
      await PushNotificationService.instance.requestPermissions();
      _permissionsRequestedThisSession = true;
    } else if (!settings.pushEnabled) {
      await NotificationService.instance.cancelAllNotifications();
      return;
    }

    final transactions = ref.read(transactionsStreamProvider).value;
    final transactionMaps = <Map<String, dynamic>>[];
    if (transactions != null) {
      for (final doc in transactions.docs) {
        transactionMaps.add(doc.data());
      }
    }

    await NotificationService.instance.syncScheduledNotifications(
      settings: settings,
      transactions: transactionMaps,
    );

    final budgetDoc = ref.read(budgetProvider).value;
    final income = ref.read(monthlyIncomeProvider).maybeWhen(
      data: (value) => value,
      orElse: () => 0.0,
    );

    if (budgetDoc == null || transactions == null) {
      return;
    }

    final budgets = <String, double>{};
    final rawBudgets = budgetDoc.data()?['budgets'];
    if (rawBudgets is Map) {
      for (final entry in rawBudgets.entries) {
        budgets[entry.key.toString().toLowerCase()] =
            (entry.value as num?)?.toDouble() ?? 0.0;
      }
    }

    final spentPerCategory = <String, double>{};
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final nextMonth = DateTime(now.year, now.month + 1, 1);

    for (final doc in transactions.docs) {
      final data = doc.data();
      final rawDate = data['date'];
      if (rawDate is! Timestamp) {
        continue;
      }

      final date = rawDate.toDate();
      if (date.isBefore(startOfMonth) || !date.isBefore(nextMonth)) {
        continue;
      }

      final category = (data['category'] ?? 'other').toString().toLowerCase();
      final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
      spentPerCategory[category] = (spentPerCategory[category] ?? 0.0) + amount;
    }

    await NotificationService.instance.evaluateBudgetNotifications(
      userId: user.uid,
      settings: settings,
      monthlyIncome: income,
      budgets: budgets,
      spentPerCategory: spentPerCategory,
    );
  }
}
