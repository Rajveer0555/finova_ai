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
  bool _isLoading = false;

  Future<void> _completeProfile({bool skipBudgetValidation = false}) async {
    if (!skipBudgetValidation &&
        budgetControllers.values.any((c) => c.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all budget fields")),
      );
      return;
    }

    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      print('Starting profile completion...');
      
      final user = FirebaseAuth.instance.currentUser;
      print('Current user: ${user?.uid}');
      
      if (user == null) {
        throw Exception("User not authenticated");
      }

      // Collect budget values
      Map<String, dynamic> budgets = {
        "food": double.tryParse(budgetControllers["food"]!.text) ?? 0,
        "travel": double.tryParse(budgetControllers["travel"]!.text) ?? 0,
        "shopping": double.tryParse(budgetControllers["shopping"]!.text) ?? 0,
        "bills": double.tryParse(budgetControllers["bills"]!.text) ?? 0,
        "other": double.tryParse(budgetControllers["others"]!.text) ?? 0,
      };

      print('Saving budgets: $budgets');
      
      // Set a timeout for Firebase operation
      await Future.wait([
        FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'profileCompleted': true,
          'aiEnabled': isAiEnabled,
          'budgets': budgets,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true)),
      ]).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('Firebase write timeout - proceeding anyway');
          return [];
        },
      );

      print('Profile data sent to Firebase');
      
      if (!mounted) return;

      print('Updating app state to authenticated');
      ref.read(appFlowProvider.notifier).state = AppStatus.authenticated;
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      
    } catch (e, stackTrace) {
      print('Error completing profile: $e');
      print('Stack trace: $stackTrace');
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // Still allow progressing by silently completing
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            print('Proceeding to authenticated state despite error');
            ref.read(appFlowProvider.notifier).state = AppStatus.authenticated;
          }
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
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
                    _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : ElevatedButtonCust('Get Started', () async {
                            await _completeProfile(skipBudgetValidation: false);
                          }),
                  ],
                ),
                Center(
                  child: TextButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            await _completeProfile(skipBudgetValidation: true);
                          },
                    child: RichText(
                      text: TextSpan(
                        text: 'Skip for now',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: _isLoading ? Colors.grey : Colors.black,
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
