import 'package:finova_ai/providers/app_flow_providers.dart';
import 'package:finova_ai/widgets/budget_category.dart';
import 'package:finova_ai/widgets/container.dart';
import 'package:finova_ai/widgets/elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InfoScreen extends ConsumerStatefulWidget {
  const InfoScreen({super.key});

  @override
  ConsumerState<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends ConsumerState<InfoScreen> {
  Future<void> _completeProfile({bool skipBudgetValidation = false}) async {
    if (!skipBudgetValidation &&
        budgetControllers.values.any((c) => c.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all budget fields")),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Collect budget values
      Map<String, dynamic> budgets = {
        "food": double.tryParse(budgetControllers["food"]!.text) ?? 0,
        "travel": double.tryParse(budgetControllers["travel"]!.text) ?? 0,
        "shopping": double.tryParse(budgetControllers["shopping"]!.text) ?? 0,
        "bills": double.tryParse(budgetControllers["bills"]!.text) ?? 0,
        "others": double.tryParse(budgetControllers["others"]!.text) ?? 0,
      };

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'profileCompleted': true,
        'aiEnabled': isAiEnabled,
        'budgets': budgets, // ✅ SAVE CATEGORY BUDGETS
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;

      ref.read(appFlowProvider.notifier).state = AppStatus.authenticated;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
    }
  }

  final Map<String, TextEditingController> budgetControllers = {
    "food": TextEditingController(),
    "travel": TextEditingController(),
    "shopping": TextEditingController(),
    "bills": TextEditingController(),
    "others": TextEditingController(),
  };

  @override
  void dispose() {
    for (var controller in budgetControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  bool isAiEnabled = true;
  @override
  Widget build(BuildContext context) {
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
                          controller: budgetControllers["food"]!,
                        ),
                        SizedBox(height: screenHeight * 0.028),
                        BudgetCategory(
                          id: "travel",
                          title: 'Travel',
                          imagePath: 'assets/travel-luggage.png',
                          controller: budgetControllers["travel"]!,
                        ),

                        SizedBox(height: screenHeight * 0.028),
                        BudgetCategory(
                          id: "shopping",
                          title: 'Shopping',
                          imagePath: 'assets/shopping-bag.png',
                          controller: budgetControllers["shopping"]!,
                        ),
                        SizedBox(height: screenHeight * 0.028),
                        BudgetCategory(
                          id: "bills",
                          title: 'Bills',
                          imagePath: 'assets/bill.png',
                          controller: budgetControllers["bills"]!,
                        ),
                        SizedBox(height: screenHeight * 0.028),
                        BudgetCategory(
                          id: "others",
                          title: 'Others',
                          imagePath: 'assets/delivery-box.png',
                          controller: budgetControllers["others"]!,
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
                            value: isAiEnabled,
                            onChanged: (value) {
                              setState(() {
                                isAiEnabled = value;
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
                  children: [
                    ElevatedButtonCust('Get Started', () async {
                      await _completeProfile(skipBudgetValidation: false);
                    }),
                  ],
                ),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      await _completeProfile(skipBudgetValidation: true);
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
