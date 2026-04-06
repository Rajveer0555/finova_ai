import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finova_ai/models/app_notification_settings.dart';
import 'package:finova_ai/providers/notification_settings_provider.dart';
import 'package:finova_ai/widgets/alerts_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
            _MasterNotificationCard(settings: settings),
            const SizedBox(height: 20),
            _ReminderTimeCard(settings: settings),
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
                        await _updateNotificationSettings(
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
                        await _updateNotificationSettings(
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
                        await _updateNotificationSettings(
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
}

class _MasterNotificationCard extends StatelessWidget {
  const _MasterNotificationCard({required this.settings});

  final AppNotificationSettings settings;

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
                onChanged: (value) async {
                  await _updateNotificationSettings(
                    settings.copyWith(pushEnabled: value),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReminderTimeCard extends StatelessWidget {
  const _ReminderTimeCard({required this.settings});

  final AppNotificationSettings settings;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final timeLabel = localizations.formatTimeOfDay(
      TimeOfDay(hour: settings.reminderHour, minute: settings.reminderMinute),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap:
          settings.pushEnabled
              ? () async {
                final selected = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: settings.reminderHour,
                    minute: settings.reminderMinute,
                  ),
                );

                if (selected == null) {
                  return;
                }

                await _updateNotificationSettings(
                  settings.copyWith(
                    reminderHour: selected.hour,
                    reminderMinute: selected.minute,
                  ),
                );
              }
              : null,
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

Future<void> _updateNotificationSettings(AppNotificationSettings settings) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return;
  }

  await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
    'notificationSettings': settings.toMap(),
  }, SetOptions(merge: true));
}
