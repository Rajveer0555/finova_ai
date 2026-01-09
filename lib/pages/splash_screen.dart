import 'dart:async';
import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      ref.read(appFlowProvider.notifier).state = AppStatus.onboarding;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// 🔽 Bottom Background Image
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/SplashImage.svg',
              fit: BoxFit.fitHeight,
              height: screenHeight * 0.46,
            ),
          ),

          /// 🔝 Center Logo & Text
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/AppLogo.svg',
                  width: 66,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 8),

                RichText(
                  text: TextSpan(
                    text: "Finova Ai",
                    style: GoogleFonts.unbounded(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 44,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    text: "Smart Expense Tracking App",
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'SFProText',
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
