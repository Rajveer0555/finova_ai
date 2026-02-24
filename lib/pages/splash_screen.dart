import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    _initializeApp();
  }

  Future<void> checkUserStatus(WidgetRef ref) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ref.read(appFlowProvider.notifier).state = AppStatus.unauthenticated;
      return;
    }

    final userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    final profileCompleted = userDoc.data()?['profileCompleted'] ?? false;

    if (profileCompleted) {
      ref.read(appFlowProvider.notifier).state = AppStatus.authenticated;
    } else {
      ref.read(appFlowProvider.notifier).state = AppStatus.infoscreen;
    }
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));

    final flowNotifier = ref.read(appFlowProvider.notifier);
    final user = FirebaseAuth.instance.currentUser;

    final isFirstLaunch = await checkIfFirstLaunch();

    if (isFirstLaunch) {
      if (!mounted) return;
      flowNotifier.state = AppStatus.onboarding;
      return;
    }

    if (user == null) {
      if (!mounted) return;
      flowNotifier.state = AppStatus.unauthenticated;
      return;
    }

    // User exists → check profile completion
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    final profileCompleted = doc.data()?['profileCompleted'] ?? false;

    if (!mounted) return;

    flowNotifier.state =
        profileCompleted ? AppStatus.authenticated : AppStatus.infoscreen;
  }

  Future<bool> checkIfFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();

    final isFirstLaunch = prefs.getBool('isFirstLaunch');

    if (isFirstLaunch == null) {
      await prefs.setBool('isFirstLaunch', false);
      return true;
    }

    return false;
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
