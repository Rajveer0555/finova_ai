import 'dart:async';
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
    'Loading your data',
    'Analyzing your finances',
    'Preparing AI insights',
    'Almost there...',
  ];

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (currentIndex < loadingTexts.length - 1) {
        setState(() {
          currentIndex++;
        });
      }
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
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/AppLogo.svg',
              width: 42,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 18),
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 46, 150, 255),
                strokeWidth: 2.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              loadingTexts[currentIndex],
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
