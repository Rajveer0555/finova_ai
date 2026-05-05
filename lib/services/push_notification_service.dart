import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling background message: ${message.messageId}');
}

class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) {
      return;
    }

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((message) async {
      final notification = message.notification;
      if (notification == null) {
        return;
      }

      await NotificationService.instance.showForegroundNotification(
        title: notification.title ?? 'Finova AI',
        body: notification.body ?? 'You have a new notification.',
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('Notification tapped: ${message.messageId}');
    });

    FirebaseMessaging.instance.onTokenRefresh.listen(_saveTokenIfPossible);
    await _saveCurrentToken();

    _initialized = true;
  }

  Future<void> requestPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  Future<void> syncTokenForCurrentUser() async {
    await _saveCurrentToken();
  }

  Future<void> _saveCurrentToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    await _saveTokenIfPossible(token);
  }

  Future<void> _saveTokenIfPossible(String? token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || token == null || token.isEmpty) {
      return;
    }

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'fcmToken': token,
    }, SetOptions(merge: true));
  }
}

