import 'package:flutter_riverpod/legacy.dart';

enum AppStatus {
  splash,
  onboarding,
  unauthenticated,
  authenticated,
  loading_state,
  ForgetPassword,
}

final appFlowProvider = StateProvider<AppStatus>((ref) {
  return AppStatus.splash;
});
