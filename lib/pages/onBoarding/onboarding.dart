import 'package:finova_ai/pages/onBoarding/screen1.dart';
import 'package:finova_ai/pages/onBoarding/screen2.dart';
import 'package:finova_ai/pages/onBoarding/screen3.dart';
import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: const [Screen1(), Screen2(), Screen3()],
          ),
          // Three dots
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 600),
              Column(
                children: [
                  const SizedBox(width: 20),
                  SmoothPageIndicator(
                    axisDirection: Axis.horizontal,
                    effect: SlideEffect(
                      spacing: 8,
                      radius: 5,
                      dotWidth: 9,
                      dotHeight: 9,
                      paintStyle: PaintingStyle.fill,
                      strokeWidth: 1.5,
                      dotColor: Colors.grey.shade400,
                      offset: 20,
                      activeDotColor: Color.fromARGB(255, 46, 150, 255),
                    ),
                    controller: _controller,
                    count: 3,
                  ),
                  SizedBox(height: screenHeight * 0.08),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: screenHeight * 0.06,
                        width: screenWidth * 0.9,
                        child: ElevatedButton(
                          onPressed: () {
                            ref.read(appFlowProvider.notifier).state =
                                AppStatus.unauthenticated;
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            backgroundColor: Color.fromARGB(255, 46, 150, 255),
                          ),
                          child: Text(
                            textAlign: TextAlign.center,
                            "Get Started",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'SFProText',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
