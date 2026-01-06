import 'dart:async';

import 'package:finova_ai/pages/onBoarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/AppLogo.svg',
                      width: 66,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      "Finova AI",
                      style: GoogleFonts.unbounded(
                        textStyle: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      "Smart Expense Tracking App",
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'SFProText',
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/SplashImage.svg',
                  fit: BoxFit.fitHeight,
                  height: screenHeight * 0.46,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
