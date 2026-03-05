import 'package:finova_ai/pages/main_navigation.dart';
import 'package:finova_ai/pages/profileScreens/subscription.dart';
import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpgradeProScreen extends ConsumerStatefulWidget {
  const UpgradeProScreen({super.key});

  @override
  ConsumerState<UpgradeProScreen> createState() => _UpgradeProScreenState();
}

class _UpgradeProScreenState extends ConsumerState<UpgradeProScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MainNavigation()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.black,
        ),
        surfaceTintColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black,
        toolbarHeight: 64,
        title: const Text(
          "Upgrade to Pro",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            fontFamily: 'SFProText',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/pro.png", height: 320, width: 340),
            SizedBox(height: 6),
            Text(
              "Elevate your finances with pro features !",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'SFProText',
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.check, color: Colors.blue.shade900, size: 20),
                SizedBox(width: 18),
                Text(
                  "Personalised Insights & Predictions",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SFProText',
                  ),
                ),
              ],
            ),

            SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.check, color: Colors.blue.shade900, size: 20),
                SizedBox(width: 18),
                Text(
                  "Custom Budget Planning",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SFProText',
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.check, color: Colors.blue.shade900, size: 20),
                SizedBox(width: 18),
                Text(
                  "Unlimited Categories & Reports",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SFProText',
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.check, color: Colors.blue.shade900, size: 20),
                SizedBox(width: 18),
                Text(
                  "Priority Support",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SFProText',
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 0.5,
                    blurRadius: 0.5,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "₹499",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SFProText',
                          ),
                        ),
                        Text(
                          "/year",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SFProText',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          "₹42/month",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'SFProText',
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "billed yearly",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'SFProText',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          "or ,",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'SFProText',
                          ),
                        ),

                        SizedBox(width: 6),
                        Text(
                          "₹79/month",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'SFProText',
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "billed yearly",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'SFProText',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.055,
                          width: screenWidth * 0.9,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SubscriptionScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Color.fromARGB(
                                255,
                                46,
                                150,
                                255,
                              ),
                            ),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Upgrade to Pro',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'SFProText',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.04,
                          child: TextButton(
                            onPressed: () {
                              ref.read(appFlowProvider.notifier).state =
                                  AppStatus.authenticated;
                            },
                            child: Text(
                              "No,maybe later",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            Divider(color: Colors.grey.shade300, thickness: 1),

            SizedBox(height: 8),
            Center(
              child: Text(
                "Cancel anytime. 7-day free trial available",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SFProText',
                ),
              ),
            ),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                "AI helps by analyzing your transactions and pending upcoming expenses.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SFProText',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
