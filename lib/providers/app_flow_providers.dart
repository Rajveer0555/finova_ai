import 'package:flutter_riverpod/legacy.dart';

enum AppStatus {
  splash,
  onboarding,
  unauthenticated,
  authenticated,
  infoscreen,
}

final appFlowProvider = StateProvider<AppStatus>((ref) {
  return AppStatus.splash;
});

// Provider for push notification toggle
final pushNotificationProvider = StateProvider<bool>((ref) {
  return true;
});
