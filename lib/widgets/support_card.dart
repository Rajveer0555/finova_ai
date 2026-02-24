import 'package:finova_ai/pages/profileScreens/faq_screen.dart';
import 'package:finova_ai/pages/profileScreens/privacy_policy.dart';
import 'package:finova_ai/pages/profileScreens/support_screen.dart';
import 'package:finova_ai/pages/profileScreens/terms_condtions.dart';
import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SupportCard extends ConsumerStatefulWidget {
  const SupportCard({super.key});

  @override
  ConsumerState<SupportCard> createState() => _SupportCardState();
}

class _SupportCardState extends ConsumerState<SupportCard> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black12, spreadRadius: 0.5, blurRadius: 0.5),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      width: screenWidth * 0.9,
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FaqScreen()),
              );
            },
            child: Row(
              children: [
                SizedBox(width: screenWidth * 0.08),
                Icon(Icons.quiz_rounded, size: 28),
                SizedBox(width: screenWidth * 0.08),
                RichText(
                  text: TextSpan(
                    text: "FAQ's",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SFProText',
                    ),
                  ),
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                SizedBox(width: screenWidth * 0.08),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Divider(),
          ),
          SizedBox(height: screenHeight * 0.01),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SupportScreen()),
              );
            },
            child: Row(
              children: [
                SizedBox(width: screenWidth * 0.08),
                Icon(Icons.support_agent_rounded, size: 28),
                SizedBox(width: screenWidth * 0.08),
                RichText(
                  text: TextSpan(
                    text: 'Help & Support',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SFProText',
                    ),
                  ),
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                SizedBox(width: screenWidth * 0.08),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Divider(),
          ),

          SizedBox(height: screenHeight * 0.01),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PrivacyPolicy()),
              );
            },
            child: Row(
              children: [
                SizedBox(width: screenWidth * 0.08),
                Icon(Icons.privacy_tip_rounded, size: 28),
                SizedBox(width: screenWidth * 0.08),
                RichText(
                  text: TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SFProText',
                    ),
                  ),
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                SizedBox(width: screenWidth * 0.08),
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Divider(),
          ),
          SizedBox(height: screenHeight * 0.01),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TermsConditions()),
              );
            },
            child: Row(
              children: [
                SizedBox(width: screenWidth * 0.08),
                Icon(Icons.article_rounded, size: 28),
                SizedBox(width: screenWidth * 0.08),
                RichText(
                  text: TextSpan(
                    text: 'Terms & Conditions',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SFProText',
                    ),
                  ),
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                SizedBox(width: screenWidth * 0.08),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }
}
