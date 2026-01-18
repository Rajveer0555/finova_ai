import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:finova_ai/widgets/budget_category.dart';
import 'package:finova_ai/widgets/container.dart';
import 'package:finova_ai/widgets/elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InfoScreen extends ConsumerStatefulWidget {
  const InfoScreen({super.key});

  @override
  ConsumerState<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends ConsumerState<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    bool isSwitched2 = true;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.01),
                RichText(
                  text: TextSpan(
                    text: "Let's set things up",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'SFProText',
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Container2(),
                SizedBox(height: screenHeight * 0.01),
                Container(
                  width: screenWidth * 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12.0,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        RichText(
                          text: TextSpan(
                            text: 'Set Your Budget',
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
                            text:
                                'This helps Finova AI give you personalized insights.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'SFProText',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        BudgetCategory(
                          id: "food",
                          title: 'Food',
                          imagePath: 'assets/diet.png',
                        ),
                        SizedBox(height: screenHeight * 0.028),
                        BudgetCategory(
                          id: "travel",
                          title: 'Travel',
                          imagePath: 'assets/travel-luggage.png',
                        ),

                        SizedBox(height: screenHeight * 0.028),
                        BudgetCategory(
                          id: "shopping",
                          title: 'Shopping',
                          imagePath: 'assets/shopping-bag.png',
                        ),
                        SizedBox(height: screenHeight * 0.028),
                        BudgetCategory(
                          id: "bills",
                          title: 'Bills',
                          imagePath: 'assets/bill.png',
                        ),
                        SizedBox(height: screenHeight * 0.028),
                        BudgetCategory(
                          id: "others",
                          title: 'Others',
                          imagePath: 'assets/delivery-box.png',
                        ),

                        SizedBox(height: screenHeight * 0.028),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.015),
                Container(
                  width: screenWidth * 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12.0,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.015),
                            RichText(
                              text: TextSpan(
                                text: 'Enable AI Insights',
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
                                text:
                                    'Get smart alerts, predictions, and saving tips.',
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
                          scale: 0.9,
                          child: CupertinoSwitch(
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Colors.grey,
                            activeTrackColor: const Color.fromARGB(
                              255,
                              27,
                              255,
                              87,
                            ),
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
                ),
                SizedBox(height: screenHeight * 0.015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ElevatedButtonCust('Get Started', () {})],
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      ref.read(appFlowProvider.notifier).state =
                          AppStatus.authenticated;
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Skip for now',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'SFProText',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
