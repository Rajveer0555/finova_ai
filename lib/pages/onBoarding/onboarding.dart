import 'package:finova_ai/pages/onBoarding/screen1.dart';
import 'package:finova_ai/pages/onBoarding/screen2.dart';
import 'package:finova_ai/pages/onBoarding/screen3.dart';
import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:finova_ai/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      ElevatedButtonCust('Get Started', () async {
                        // Mark onboarding as completed
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('onboardingCompleted', true);
                        
                        if (mounted) {
                          ref.read(appFlowProvider.notifier).state =
                              AppStatus.unauthenticated;
                        }
                      }),
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
