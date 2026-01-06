import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.unbounded(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 44,
                          ),
                        ),
                        text: "Finova Ai",
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.unbounded(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                          ),
                        ),
                        text: "Smart Expense Tracking App",
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
