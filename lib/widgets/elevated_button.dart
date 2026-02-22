import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ElevatedButtonCust extends ConsumerWidget {
  final String title;
  final VoidCallback route;
  const ElevatedButtonCust(this.title, this.route, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.06,
      width: screenWidth * 0.89,
      child: ElevatedButton(
        onPressed: route,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: Color.fromARGB(255, 46, 150, 255),
        ),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: title,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'SFProText',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
