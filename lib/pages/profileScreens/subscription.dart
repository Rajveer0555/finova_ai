import 'package:finova_ai/providers/app_flow_providers.dart';
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ref.read(appFlowProvider.notifier).state = AppStatus.upgrade_pro;
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
          ],
        ),
      ),
    );
  }
}
