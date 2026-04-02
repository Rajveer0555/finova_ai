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
