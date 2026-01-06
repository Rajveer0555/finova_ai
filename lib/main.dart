// import 'package:finova_ai/pages/onBoarding/onboarding.dart';
// import 'package:finova_ai/pages/onBoarding/screen1.dart';
// import 'package:finova_ai/pages/onBoarding/screen2.dart';
// import 'package:finova_ai/pages/onBoarding/screen3.dart';
import 'package:finova_ai/pages/splash_screen.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      home: SplashScreen(),
    );
  }
}
