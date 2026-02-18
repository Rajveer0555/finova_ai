import 'package:flutter_riverpod/legacy.dart';

enum AppStatus {
  splash,
  onboarding,
  unauthenticated,
  authenticated,
  infoscreen,
  support_screen,
  faq_screen,
  userprofile,
  manage_budget,
  add_screen,
  loading_state,
  ForgetPassword,
}

final appFlowProvider = StateProvider<AppStatus>((ref) {
  return AppStatus.splash;
});
