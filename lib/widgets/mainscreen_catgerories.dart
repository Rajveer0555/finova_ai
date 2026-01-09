import 'package:flutter/material.dart';

class MainscreenCatgerories extends StatelessWidget {
  final String title;
  final String subTitle;
  final String money;
  final String perc;
  final String imagePath2;
  final Color color;
  const MainscreenCatgerories({
    super.key,
    required this.imagePath2,
    required this.title,
    required this.subTitle,
    required this.money,
    required this.perc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(31, 112, 112, 112),
            blurRadius: 12.0,
            spreadRadius: 1,
          ),
        ],
      ),
      width: screenWidth * 1,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.022),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(imagePath2),
              fit: BoxFit.contain,
              height: screenHeight * 0.06,
              width: screenWidth * 0.15,
            ),
            SizedBox(width: screenWidth * 0.08),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: title,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'SFProText',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.004),
                RichText(
                  text: TextSpan(
                    text: subTitle,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'SFProText',
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: screenWidth * 0.14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RichText(
                  text: TextSpan(
                    text: money,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'SFProText',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.001),
                RichText(
                  text: TextSpan(
                    text: perc,
                    style: TextStyle(
                      color: color,
                      fontFamily: 'SFProText',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
