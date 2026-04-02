import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TermsConditions extends ConsumerStatefulWidget {
  const TermsConditions({super.key});

  @override
  ConsumerState<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends ConsumerState<TermsConditions> {
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
        shadowColor: Colors.black12,
        toolbarHeight: 64,
        title: const Text(
          "Terms & Conditions",
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
                        "By accessing or using this application, you agree to comply with the following terms.",
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
                        "1. Acceptance of Terms",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "By using this app, you confirm that you accept these Terms and Conditions.",
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
                        "2. User Responsibilities",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "You agree:\n• To provide accurate information\n• Not to misuse the application\n• Not to attempt unauthorized access\n• Not to upload harmful content",
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
                        "3. Account Suspension",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "We reserve the right to suspend or terminate accounts that violate our policies.",
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
                        "4. Intellectual Property",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "All content, logos, and design elements are the property of the app owner and may not be reused without permission.",
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
                        "5. Limitation of Liability",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "We are not responsible for:\n• Service interruptions\n• Data loss\n• Any indirect damages resulting from app usage",
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
                        "6. Modifications",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "We may modify these terms at any time. Continued use of the app means acceptance of updated terms.",
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
