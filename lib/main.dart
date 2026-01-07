// import 'package:finova_ai/pages/onBoarding/onboarding.dart';
// import 'package:finova_ai/pages/onBoarding/screen1.dart';
// import 'package:finova_ai/pages/onBoarding/screen2.dart';
// import 'package:finova_ai/pages/onBoarding/screen3.dart';
import 'package:finova_ai/pages/forget_password.dart';
import 'package:finova_ai/pages/login_screen.dart';
import 'package:finova_ai/pages/onBoarding/onboarding.dart';
import 'package:finova_ai/pages/splash_screen.dart';
import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/app_flow_providers.dart';

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
      case AppStatus.authenticated:
        currentScreen = const Scaffold(body: Center(child: Text('HomeScreen')));
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
