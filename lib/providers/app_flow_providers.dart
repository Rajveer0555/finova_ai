import 'package:flutter_riverpod/legacy.dart';

enum AppStatus {
  splash,
  onboarding,
  unauthenticated,
  authenticated,
  infoscreen,
  userprofile,
  add_screen,
  loading_state,
  ForgetPassword,
}

final appFlowProvider = StateProvider<AppStatus>((ref) {
  return AppStatus.splash;
});
