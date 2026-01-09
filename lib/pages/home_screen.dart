import 'package:finova_ai/widgets/mainscreen_catgerories.dart';
import 'package:flutter/material.dart';
import 'package:primer_progress_bar/primer_progress_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Segment> segments = [
      Segment(
        value: 20,
        color: Colors.lightGreenAccent.shade400,
        label: Text('Food'),
      ),
      Segment(
        value: 60,
        color: Colors.lightBlueAccent.shade400,
        label: Text('Travel'),
      ),
      Segment(
        value: 10,
        color: const Color.fromARGB(255, 255, 224, 23),
        label: Text('Bills'),
      ),
      Segment(
        value: 10,
        color: Colors.redAccent.shade400,
        label: Text('Shopping'),
      ),
    ];

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
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
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.08),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Total Spendings',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'SFProText',
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.0001),
                          RichText(
                            text: TextSpan(
                              text: '₹ 28,450',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'SFProText',
                                fontSize: 42,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.0001),
                          RichText(
                            text: TextSpan(
                              text: 'This month',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'SFProText',
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('assets/circle_avatar.jpg'),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    width: screenWidth * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.002),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                            ),
                            child: RichText(
                              text: TextSpan(
                                text: 'Budgets Used',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SFProText',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.02),
                          PrimerProgressBar(segments: segments),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.025),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.035),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.92,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 251, 237),
                    border: Border.all(
                      color: Colors.amber.shade100,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.02,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/idea.png',
                          height: screenHeight * 0.04,
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'AI Insights',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'SFProText',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.001),
                            RichText(
                              text: TextSpan(
                                text:
                                    'Your food expenses are 30% higher than last\nmonth. Consider meal planning to save ₹2,000',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'SFProText',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: RichText(
                    text: TextSpan(
                      text: 'Categories',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'SFProText',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                MainscreenCatgerories(
                  imagePath2: 'assets/diet.png',
                  title: 'Food',
                  subTitle: '42 Transactions',
                  money: '₹ 8,450',
                  perc: '+ 12%',
                  color: Colors.redAccent,
                ),
                SizedBox(height: screenHeight * 0.01),
                MainscreenCatgerories(
                  imagePath2: 'assets/shopping-bag.png',
                  title: 'Shopping',
                  subTitle: '12 Transactions',
                  money: '₹ 2,250',
                  perc: '- 12%',

                  color: Colors.lightGreenAccent.shade400,
                ),
                SizedBox(height: screenHeight * 0.01),
                MainscreenCatgerories(
                  imagePath2: 'assets/travel-luggage.png',
                  title: 'Travel',
                  subTitle: '18 Transactions',
                  money: '₹ 12,000',
                  perc: '+ 2%',

                  color: Colors.lightGreenAccent.shade400,
                ),
                SizedBox(height: screenHeight * 0.01),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
