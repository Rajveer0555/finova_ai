import 'package:finova_ai/models/app_notification_settings.dart';
import 'package:finova_ai/providers/notification_settings_provider.dart';
import 'package:finova_ai/services/notification_service.dart';
import 'package:finova_ai/utils/picker_theme.dart';
import 'package:finova_ai/widgets/alerts_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(notificationSettingsProvider);
    final settings = settingsAsync.maybeWhen(
      data: (value) => value,
      orElse: AppNotificationSettings.defaults,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.black,
        ),
        surfaceTintColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        toolbarHeight: 84,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            fontFamily: 'SFProText',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MasterNotificationCard(
              settings: settings,
              onChanged: (value) async {
                await _applySettings(
                  ref,
                  settings.copyWith(pushEnabled: value),
                );
              },
            ),
            const SizedBox(height: 20),
            _ReminderTimeCard(
              settings: settings,
              onTap: () async {
                if (!settings.pushEnabled) return;

                final selected = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: settings.reminderHour,
                    minute: settings.reminderMinute,
                  ),
                  builder: finovaPickerTheme,
                );

                if (selected == null) return;

                await _applySettings(
                  ref,
                  settings.copyWith(
                    reminderHour: selected.hour,
                    reminderMinute: selected.minute,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Alerts',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'SFProText',
              ),
            ),
            const SizedBox(height: 10),
            AlertsContainer(
              title: 'Alert on Budget Exceed',
              subTitle: 'Notify again when overall overspending gets worse',
              value: settings.budgetExceededEnabled,
              onChanged:
                  settings.pushEnabled
                      ? (value) async {
                        await _applySettings(
                          ref,
                          settings.copyWith(budgetExceededEnabled: value),
                        );
                      }
                      : null,
            ),
            const SizedBox(height: 10),
            AlertsContainer(
              title: 'Alert on Category Limit',
              subTitle: 'Notify again when a category overrun increases more',
              value: settings.categoryLimitEnabled,
              onChanged:
                  settings.pushEnabled
                      ? (value) async {
                        await _applySettings(
                          ref,
                          settings.copyWith(categoryLimitEnabled: value),
                        );
                      }
                      : null,
            ),
            const SizedBox(height: 10),
            AlertsContainer(
              title: 'AI Smart Alerts',
              subTitle: 'Forecast, unusual spending jumps, and budget risks',
              value: settings.aiAlertsEnabled,
              onChanged:
                  settings.pushEnabled
                      ? (value) async {
                        await _applySettings(
                          ref,
                          settings.copyWith(aiAlertsEnabled: value),
                        );
                      }
                      : null,
            ),
            const SizedBox(height: 16),
            Text(
              settings.pushEnabled
                  ? 'Daily reminders are scheduled at your selected time. Overspending alerts can notify again as your overrun grows.'
                  : 'Turn on notifications to enable reminders, budget alerts, and AI alerts.',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: 'SFProText',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _applySettings(
    WidgetRef ref,
    AppNotificationSettings settings,
  ) async {
    // Optimistic update — persists across navigation via the notifier.
    await ref
        .read(notificationSettingsProvider.notifier)
        .updateSettings(settings);

    // Schedule / cancel notifications based on the new settings.
    await NotificationService.instance.init();
    if (!settings.pushEnabled) {
      await NotificationService.instance.cancelAllNotifications();
      return;
    }

    await NotificationService.instance.requestPermissions();
    await NotificationService.instance.syncScheduledNotifications(
      settings: settings,
      transactions: const [],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _MasterNotificationCard extends StatelessWidget {
  const _MasterNotificationCard({
    required this.settings,
    required this.onChanged,
  });

  final AppNotificationSettings settings;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 12, spreadRadius: 1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            const Icon(Icons.notifications_active_rounded, size: 30),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Push Notifications',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SFProText',
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Control reminders, overspending alerts, and AI signals',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'SFProText',
                    ),
                  ),
                ],
              ),
            ),
            Transform.scale(
              scale: 0.9,
              child: CupertinoSwitch(
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey,
                activeTrackColor: const Color.fromARGB(255, 27, 255, 87),
                value: settings.pushEnabled,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _ReminderTimeCard extends StatelessWidget {
  const _ReminderTimeCard({required this.settings, required this.onTap});

  final AppNotificationSettings settings;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final timeLabel = localizations.formatTimeOfDay(
      TimeOfDay(hour: settings.reminderHour, minute: settings.reminderMinute),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: settings.pushEnabled ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 12, spreadRadius: 1),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 30,
                color: settings.pushEnabled ? Colors.black : Colors.grey,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Reminder Time',
                      style: TextStyle(
                        color:
                            settings.pushEnabled
                                ? Colors.black
                                : Colors.grey.shade500,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SFProText',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      settings.pushEnabled
                          ? 'Current reminder: $timeLabel'
                          : 'Enable notifications to schedule reminders',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'SFProText',
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: settings.pushEnabled ? Colors.black : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
