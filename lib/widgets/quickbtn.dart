import 'package:flutter/material.dart';

class Quickbtn extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  const Quickbtn({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: screenHeight * 0.03,
        width: screenWidth * 0.13,
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.001),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 1.5),
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromARGB(255, 203, 239, 255),
        ),
        child: Center(
          child: RichText(
            text: TextSpan(
              text: text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
