import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finova_ai/models/app_notification_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationSettingsProvider =
    StreamProvider<AppNotificationSettings>((ref) {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return Stream.value(AppNotificationSettings.defaults());
      }

      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .map((doc) {
            final data = doc.data();
            return AppNotificationSettings.fromMap(data?['notificationSettings']);
          });
    });
