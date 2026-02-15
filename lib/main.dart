import 'package:finova_ai/pages/add_screen.dart';
import 'package:finova_ai/pages/forget_password.dart';
import 'package:finova_ai/pages/auth_screen.dart';
import 'package:finova_ai/pages/info_screen.dart';
import 'package:finova_ai/pages/loading_state.dart';
import 'package:finova_ai/pages/main_navigation.dart';
import 'package:finova_ai/pages/onBoarding/onboarding.dart';
import 'package:finova_ai/pages/profileScreens/manage_budget.dart';
import 'package:finova_ai/pages/profileScreens/user_profile.dart';
import 'package:finova_ai/pages/splash_screen.dart';
import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStatus = ref.watch(appFlowProvider);
    Widget currentScreen;

    switch (appStatus) {
      case AppStatus.splash:
        currentScreen = const SplashScreen();
        break;
      case AppStatus.onboarding:
        currentScreen = const OnboardingScreen();
        break;
      case AppStatus.unauthenticated:
        currentScreen = const AuthScreen();
        break;
      case AppStatus.ForgetPassword:
        currentScreen = const ForgetPassword();
        break;
      case AppStatus.loading_state:
        currentScreen = const LoadingState(); //
        break;
      case AppStatus.infoscreen:
        currentScreen = const InfoScreen(); //
        break;
      case AppStatus.add_screen:
        currentScreen = const AddTransactionScreen(); //
        break;
      case AppStatus.authenticated:
        currentScreen = const MainNavigation(); //
        break;
      case AppStatus.manage_budget:
        currentScreen = const ManageBudgetScreen(); //
        break;
      case AppStatus.userprofile:
        currentScreen = const UserProfile(); //
        break;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finova-Ai',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'SF Pro Text',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'SFProText'),
          bodyMedium: TextStyle(fontFamily: 'SFProText'),
          titleLarge: TextStyle(fontFamily: 'SFProDisplay'),
        ),
      ),
      home: currentScreen,
    );
  }
}
