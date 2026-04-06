import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(milliseconds: 450));

    if (!mounted) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;

      late final AppStatus nextStatus;

      if (!onboardingCompleted) {
        nextStatus = AppStatus.onboarding;
      } else {
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          nextStatus = AppStatus.unauthenticated;
        } else {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          final profileCompleted = doc.data()?['profileCompleted'] ?? false;
          nextStatus =
              profileCompleted ? AppStatus.authenticated : AppStatus.infoscreen;
        }
      }

      if (!mounted) return;
      ref.read(appFlowProvider.notifier).state = nextStatus;
    } catch (_) {
      if (!mounted) return;
      ref.read(appFlowProvider.notifier).state = AppStatus.unauthenticated;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
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
                    text: 'Finova Ai',
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
                const Text(
                  'Smart Expense Tracking App',
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
        ],
      ),
    );
  }
}
