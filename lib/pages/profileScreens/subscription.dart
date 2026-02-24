import 'package:finova_ai/pages/profileScreens/billing_history.dart';
import 'package:finova_ai/pages/profileScreens/upgrade_pro.dart';
import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:finova_ai/widgets/billing_history_card.dart';
import 'package:finova_ai/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UpgradeProScreen()),
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
          "Subscription",
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
          children: [
            SizedBox(height: 20),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset("assets/crown.png", height: 25, width: 25),
                        SizedBox(width: 16),
                        Text(
                          "Finova AI Pro",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SFProText',
                          ),
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Text(
                              '₹ 249',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'SFProText',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'per month',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'SFProText',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 0.5),
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.blue.shade50,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 16,
                        ),
                        child: Text(
                          "Active",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Divider(color: Colors.grey.shade300, thickness: 1),

                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          color: Colors.black,
                          size: 25,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Next billing : Jan 31, 2026",
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
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
                    Text(
                      "Plan Benefits",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.blue.shade900,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Unlimited AI insights",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.blue.shade900,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Advanced analytics",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.blue.shade900,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Budget predictions",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.blue.shade900,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Export reports",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
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
                  children: [
                    Row(
                      children: [
                        Text(
                          "Payment Method",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Change",
                            style: TextStyle(
                              color: Color.fromARGB(255, 46, 150, 255),
                              fontSize: 12,
                              fontFamily: 'SFProText',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/credit-card.png",
                          height: 31,
                          width: 31,
                        ),
                        SizedBox(width: 26),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "**** **** **** 2217",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'SFProText',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Expires 12/28",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'SFProText',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BillingHistoryScreen()),
                );
              },
              child: Container(
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
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: [
                      Text(
                        "Billing History",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ElevatedButtonCust('Payment', () {})],
            ),
            SizedBox(height: 12),
            SizedBox(
              height: screenHeight * 0.06,
              width: screenWidth * 0.89,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(appFlowProvider.notifier).state =
                      AppStatus.authenticated;
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  backgroundColor: Colors.white,
                ),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Cancel Subscription",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'SFProText',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
