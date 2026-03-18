import 'dart:async';
import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (currentIndex < loadingTexts.length - 1) {
        setState(() {
          currentIndex++;
        });
      }
    });

    // After 6 seconds → move to Info screen
    Future.delayed(const Duration(seconds: 6), () {
      if (!mounted) return;
      timer?.cancel();
      ref.read(appFlowProvider.notifier).state = AppStatus.infoscreen;
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
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: 1.0,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.elasticOut,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 1500),
                    child: SvgPicture.asset(
                      'assets/AppLogo.svg',
                      width: 66,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 8),
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 1500),
                    child: RichText(
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
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 2000),
              child: const CircularProgressIndicator(
                color: Color.fromARGB(255, 46, 150, 255),
                strokeWidth: 3,
                strokeAlign: 8,
              ),
            ),

            const SizedBox(height: 30),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.5),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: RichText(
                key: ValueKey(currentIndex),
                text: TextSpan(
                  text: loadingTexts[currentIndex],
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'SFDisplay',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
