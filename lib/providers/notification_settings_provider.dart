import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finova_ai/models/app_notification_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A notifier that:
/// 1. Loads settings from SharedPreferences (cache) immediately on first build.
/// 2. Then subscribes to Firestore for live updates.
/// 3. Exposes [updateSettings] for optimistic writes — the state is updated
///    in-memory instantly, so navigating away and back still shows the correct
///    time without waiting for a Firestore round-trip.
class NotificationSettingsNotifier
    extends AsyncNotifier<AppNotificationSettings> {
  @override
  Future<AppNotificationSettings> build() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return AppNotificationSettings.defaults();
    }

    // 1. Try to serve from local cache first so the UI is never empty.
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'notification_settings_${user.uid}';
    final cached = prefs.getString(cacheKey);
    AppNotificationSettings initial = AppNotificationSettings.defaults();
    if (cached != null && cached.isNotEmpty) {
      try {
        initial = AppNotificationSettings.fromMap(jsonDecode(cached));
      } catch (_) {}
    }

    // 2. Subscribe to Firestore in the background. Whenever Firestore emits a
    //    newer value, update our state and keep the cache fresh.
    final subscription = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((doc) async {
          final raw = doc.data()?['notificationSettings'];
          if (raw is Map) {
            final settings = AppNotificationSettings.fromMap(raw);
            await prefs.setString(cacheKey, jsonEncode(settings.toMap()));
            // Only update if state is not already set to something more recent
            // (i.e., an optimistic write). We compare by serialised map so we
            // avoid overwriting a pending optimistic change with stale data
            // that originated from BEFORE the optimistic write.
            if (!state.isLoading && !state.hasError) {
              final current = state.value;
              if (current == null || _isDifferent(current, settings)) {
                state = AsyncData(settings);
              }
            }
          }
        });

    // Cancel the Firestore subscription when this provider is disposed.
    ref.onDispose(subscription.cancel);

    return initial;
  }

  /// Immediately reflects [newSettings] in the UI (optimistic update), then
  /// persists to SharedPreferences and Firestore.
  Future<void> updateSettings(AppNotificationSettings newSettings) async {
    // Optimistic: update state right now so the UI shows the change instantly.
    state = AsyncData(newSettings);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'notification_settings_${user.uid}';
    await prefs.setString(cacheKey, jsonEncode(newSettings.toMap()));

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
      {'notificationSettings': newSettings.toMap()},
      SetOptions(merge: true),
    );
  }

  bool _isDifferent(
    AppNotificationSettings a,
    AppNotificationSettings b,
  ) {
    return a.pushEnabled != b.pushEnabled ||
        a.budgetExceededEnabled != b.budgetExceededEnabled ||
        a.categoryLimitEnabled != b.categoryLimitEnabled ||
        a.aiAlertsEnabled != b.aiAlertsEnabled ||
        a.reminderHour != b.reminderHour ||
        a.reminderMinute != b.reminderMinute;
  }
}

final notificationSettingsProvider =
    AsyncNotifierProvider.autoDispose<NotificationSettingsNotifier,
        AppNotificationSettings>(NotificationSettingsNotifier.new);
