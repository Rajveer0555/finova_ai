import 'package:flutter_riverpod/legacy.dart';

enum AppStatus {
  splash,
  onboarding,
  unauthenticated,
  authenticated,
  infoscreen,
  privacy_policy,
  terms_conditions,
  support_screen,
  faq_screen,
  billing_history,
  subscription,
  userprofile,
  manage_budget,
  add_screen,
  upgrade_pro,
  loading_state,
  ForgetPassword,
}

final appFlowProvider = StateProvider<AppStatus>((ref) {
  return AppStatus.splash;
});
