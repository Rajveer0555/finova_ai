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
  bool _isSyncing = false;
  bool _syncQueued = false;
  Future<void>? _permissionRequest;

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
    if (_isSyncing) {
      _syncQueued = true;
      return;
    }

    _isSyncing = true;
    final user = FirebaseAuth.instance.currentUser;
    try {
      if (user == null) {
        await NotificationService.instance.cancelAllNotifications();
        return;
      }

      final settings = ref
          .read(notificationSettingsProvider)
          .maybeWhen(
            data: (value) => value,
            orElse: AppNotificationSettings.defaults,
          );

      await NotificationService.instance.init();
      await PushNotificationService.instance.init();
      await PushNotificationService.instance.syncTokenForCurrentUser();

      if (settings.pushEnabled) {
        await _ensurePermissionsRequested();
      } else {
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
      final income = ref
          .read(monthlyIncomeProvider)
          .maybeWhen(data: (value) => value, orElse: () => 0.0);

      if (budgetDoc == null || transactions == null) {
        return;
      }

      final budgets = <String, double>{};
      final rawBudgets = budgetDoc.data()?['budgets'];
      if (rawBudgets is Map) {
        for (final entry in rawBudgets.entries) {
          final normalizedKey = _normalizeCategoryKey(entry.key);
          budgets[normalizedKey] = (entry.value as num?)?.toDouble() ?? 0.0;
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

        final category = _normalizeCategoryKey(data['category']);
        final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
        spentPerCategory[category] =
            (spentPerCategory[category] ?? 0.0) + amount;
      }

      await NotificationService.instance.evaluateBudgetNotifications(
        userId: user.uid,
        settings: settings,
        monthlyIncome: income,
        budgets: budgets,
        spentPerCategory: spentPerCategory,
      );
    } finally {
      _isSyncing = false;
      if (_syncQueued && mounted) {
        _syncQueued = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _syncNotifications();
        });
      }
    }
  }

  Future<void> _ensurePermissionsRequested() async {
    if (_permissionsRequestedThisSession) {
      return;
    }

    if (_permissionRequest != null) {
      await _permissionRequest;
      return;
    }

    _permissionRequest = () async {
      try {
        await NotificationService.instance.requestPermissions();
        await PushNotificationService.instance.requestPermissions();
      } catch (_) {
        // Avoid crashing startup if the OS is already showing the permission dialog.
      }
      _permissionsRequestedThisSession = true;
      _permissionRequest = null;
    }();

    await _permissionRequest;
  }
}

String _normalizeCategoryKey(dynamic value) {
  final normalized = value?.toString().trim().toLowerCase() ?? 'other';
  if (normalized.isEmpty || normalized == 'others') {
    return 'other';
  }
  return normalized;
}
