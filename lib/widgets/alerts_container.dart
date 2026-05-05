import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertsContainer extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const AlertsContainer({
    super.key,
    required this.title,
    required this.subTitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 12.0, spreadRadius: 1),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'SFProText',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.001),
                    Text(
                      subTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontFamily: 'SFProText',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Transform.scale(
                scale: 0.75,
                child: CupertinoSwitch(
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey,
                  activeTrackColor: const Color.fromARGB(255, 100, 159, 255),
                  value: value,
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
