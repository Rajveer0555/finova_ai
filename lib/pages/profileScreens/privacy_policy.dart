import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrivacyPolicy extends ConsumerStatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  ConsumerState<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends ConsumerState<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.black,
        ),
        surfaceTintColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black,
        toolbarHeight: 64,
        title: const Text(
          "Privacy Policy",
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 0.5,
                      blurRadius: 0.5,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                width: screenWidth * 0.9,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Effective Date: 22/12/2026",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Welcome to our application. Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your information.",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 18),
                      Divider(color: Colors.grey.shade300),
                      Text(
                        "1. Information We Collect",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "We may collect the following information: \n• Personal Information (Name, Email, Phone number)\n• Account credentials\n• App usage data\n• Device information\n• Uploaded content (if any)",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 18),
                      Divider(color: Colors.grey.shade300),
                      Text(
                        "2. How We Use Your Information",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "We use your information to:\n• Provide and improve our services\n• Manage your account\n• Send notifications and updates\n• Enhance user experience\n• Ensure security and prevent fraud",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 18),
                      Divider(color: Colors.grey.shade300),
                      Text(
                        "3. Data Security",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "We implement appropriate security measures to protect your personal data. However, no method of transmission over the internet is 100% secure.",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 18),
                      Divider(color: Colors.grey.shade300),
                      Text(
                        "4. Data Sharing",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "We do not sell your personal information.\nWe may share information only:\n• To comply with legal obligations\n• With trusted service providers (if required)",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 18),
                      Divider(color: Colors.grey.shade300),
                      Text(
                        "5. User Rights",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "You have the right to:\n• Access your data\n• Update or delete your account\n• Request data removal",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 18),
                      Divider(color: Colors.grey.shade300),
                      Text(
                        "6. Changes to This Policy",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "We may update this Privacy Policy from time to time. Changes will be reflected within the app.",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
