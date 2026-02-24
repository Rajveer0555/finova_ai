import 'package:finova_ai/pages/auth_screen.dart';
import 'package:finova_ai/pages/info_screen.dart';
import 'package:finova_ai/pages/main_navigation.dart';
import 'package:finova_ai/pages/onBoarding/onboarding.dart';
import 'package:finova_ai/pages/splash_screen.dart';
import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

      case AppStatus.infoscreen:
        currentScreen = const InfoScreen();
        break;

      case AppStatus.authenticated:
        currentScreen = const MainNavigation();
        break;

      default:
        currentScreen = const SplashScreen();
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
