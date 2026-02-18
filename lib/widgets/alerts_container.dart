import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertsContainer extends StatefulWidget {
  final String title;
  final String subTitle;
  const AlertsContainer({super.key, required this.title, required this.subTitle});

  @override
  State<AlertsContainer> createState() => _AlertsContainerState();
}

class _AlertsContainerState extends State<AlertsContainer> {
  @override
  Widget build(BuildContext context) {
    bool isSwitched2 = true;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 12.0, spreadRadius: 1),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.015),
                RichText(
                  text: TextSpan(
                    text: widget.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'SFProText',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.001),
                RichText(
                  text: TextSpan(
                    text: widget.subTitle,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontFamily: 'SFProText',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),
              ],
            ),
            Spacer(),
            Transform.scale(
              scale: 0.75,
              child: CupertinoSwitch(
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey,
                activeTrackColor: Color.fromARGB(255, 100, 159, 255),
                value: isSwitched2,
                onChanged: (value) {
                  setState(() {
                    isSwitched2 = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
