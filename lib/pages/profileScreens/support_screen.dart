import 'package:finova_ai/pages/main_navigation.dart';
import 'package:finova_ai/pages/profileScreens/faq_screen.dart';
import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:finova_ai/widgets/help_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  Future<void> _contactSupport() async {
    final Uri emailUri = Uri.parse('mailto:rivexstudio22@gmail.com?subject=${Uri.encodeComponent('Contact Support')}');
    try {
      await launchUrl(emailUri);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch email app')),
      );
    }
  }

  Future<void> _emailSupport() async {
    final Uri emailUri = Uri.parse('mailto:rivexstudio22@gmail.com?subject=${Uri.encodeComponent('Email Support')}');
    try {
      await launchUrl(emailUri);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch email app')),
      );
    }
  }

  Future<void> _reportProblem() async {
    final Uri emailUri = Uri.parse('mailto:rivexstudio22@gmail.com?subject=${Uri.encodeComponent('Problem Report')}');
    try {
      await launchUrl(emailUri);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch email app')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
          "Help & Support",
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  gradient: LinearGradient(
                    colors: [
                      Colors.lightBlue.shade500,
                      const Color.fromARGB(255, 8, 82, 147),
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
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
                        "We’re here to help",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "We're here to help you with any questions or issues you may have. Choose an option below to get started.",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              HelpCard(
                "Contact Support",
                "Chat with our support team",
                "assets/comments.png",
                () => _contactSupport(),
              ),

              SizedBox(height: 10),
              HelpCard(
                "Email Support",
                "Send us an email",
                "assets/gmail.png",
                () => _emailSupport(),
              ),

              SizedBox(height: 10),
              HelpCard(
                "Report a Problem",
                "Let us know about any issues",
                "assets/error.png",
                () => _reportProblem(),
              ),

              SizedBox(height: 10),
              HelpCard(
                "FAQs",
                "Browse frequently asked questions",
                "assets/faq.png",
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FaqScreen()),
                  );
                },
              ),
              SizedBox(height: 10),
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
                        "Support Details",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Email Address",
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "rivexstudio22@gmail.com",
                        style: TextStyle(
                          fontFamily: 'SFProTexts',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 85, 150, 255),
                        ),
                      ),
                      SizedBox(height: 16),
                      Divider(color: Colors.black12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.lightGreenAccent,
                            ),
                          ),
                          SizedBox(width: 18),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Response Time",
                                style: TextStyle(
                                  fontFamily: 'SFProText',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Usually responds within 24 hours",
                                style: TextStyle(
                                  fontFamily: 'SFProText',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Divider(color: Colors.black12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(width: 18),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Support Hours",
                                style: TextStyle(
                                  fontFamily: 'SFProText',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Monday - Friday: 9:00 AM - 6:00 PM IST",
                                style: TextStyle(
                                  fontFamily: 'SFProText',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
