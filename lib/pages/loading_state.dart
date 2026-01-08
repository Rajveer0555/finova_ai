import 'dart:async';
import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadingState extends ConsumerStatefulWidget {
  const LoadingState({super.key});

  @override
  ConsumerState<LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends ConsumerState<LoadingState> {
  Timer? timer;
  int currentIndex = 0;

  final List<String> loadingTexts = [
    "Loading your data",
    "Analyzing your finances",
    "Preparing AI insights",
    "Almost there...",
  ];

  @override
  void initState() {
    super.initState();

    // Change text every 2 seconds
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (currentIndex < loadingTexts.length - 1) {
        setState(() {
          currentIndex++;
        });
      }
    });

    // After 8 seconds → move to Home screen
    Future.delayed(const Duration(seconds: 8), () {
      timer?.cancel();
      ref.read(appFlowProvider.notifier).state = AppStatus.authenticated;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/AppLogo.svg',
              width: 66,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 10),

            const Text(
              "Finova AI",
              style: TextStyle(fontSize: 44, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 20),

            const CircularProgressIndicator(
              color: Color.fromARGB(255, 46, 150, 255),
              strokeWidth: 3,
              strokeAlign: 8,
            ),

            const SizedBox(height: 30),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                loadingTexts[currentIndex],
                key: ValueKey(currentIndex),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'SFDisplay',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
