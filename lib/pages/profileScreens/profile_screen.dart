import 'package:finova_ai/widgets/account_card.dart';
import 'package:finova_ai/widgets/profiler_header.dart';
import 'package:finova_ai/widgets/support_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black,
          toolbarHeight: 58,
          title: const Text(
            "Profile",
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
        body: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  ProfilerHeader(),
                  SizedBox(height: screenHeight * 0.01),
                  RichText(
                    text: TextSpan(
                      text: 'Account',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SFProText',
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  AccountCard(),
                  SizedBox(height: screenHeight * 0.01),
                  RichText(
                    text: TextSpan(
                      text: 'Support',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SFProText',
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  SupportCard(),
                  SizedBox(height: screenHeight * 0.03),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 0.5,
                          blurRadius: 0.5,
                        ),
                      ],
                      gradient: LinearGradient(
                        colors: [
                          Colors.lightBlue.shade300,
                          Colors.blue.shade600,
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    width: screenWidth * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: 'Curent Plan',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'SFProText',
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.005),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Free Plan',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'SFProText',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Icon(
                                Icons.workspace_premium_rounded,
                                size: 40,
                                color: Colors.yellow.shade600,
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          Container(
                            width: screenWidth * 0.9,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Upgrade to Pro',
                                  style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
