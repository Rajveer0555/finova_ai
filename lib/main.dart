import 'package:finova_ai/pages/auth_screen.dart';
import 'package:finova_ai/pages/info_screen.dart';
import 'package:finova_ai/pages/main_navigation.dart';
import 'package:finova_ai/pages/onBoarding/onboarding.dart';
import 'package:finova_ai/pages/splash_screen.dart';
import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await Supabase.initialize(
    url: 'https://gkixzsxddipioyqwcbtr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdraXh6c3hkZGlwaW95cXdjYnRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI3ODg2NTEsImV4cCI6MjA4ODM2NDY1MX0.w-h9Wbn0A5XfbuYD6B9o_z7qz4Klw54FXF3G2JLizGk',
  );

  runApp(ProviderScope(child: const MyApp()));
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
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: currentScreen,
      ),
    );
  }
}
