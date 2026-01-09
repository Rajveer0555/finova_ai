import 'package:flutter/material.dart';

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/screen2.png',
              fit: BoxFit.contain,
              height: screenHeight * 0.25,
            ),
            SizedBox(height: screenHeight * 0.03),
            RichText(
              text: TextSpan(
                text: "Smart AI Insights",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'SFProText',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.001),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text:
                      "Finova AI analyzes your spending and gives smart suggestions to save more.",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'SFProText',
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
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
