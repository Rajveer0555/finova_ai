import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Screen1.png',
              fit: BoxFit.contain,
              height: screenHeight * 0.25,
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              "Track Your Expenses Easily",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'SFProText',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: screenHeight * 0.001),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Text(
                textAlign: TextAlign.center,
                "Record your daily spending and keep everything organized in one place.",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'SFProText',
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
