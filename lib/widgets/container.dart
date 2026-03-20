import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finova_ai/providers/income_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Container2 extends ConsumerStatefulWidget {
  const Container2({super.key});

  @override
  ConsumerState<Container2> createState() => _Container2State();
}

class _Container2State extends ConsumerState<Container2> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    // Keep the controller in sync with the provider.
    ref.listen<AsyncValue<double>>(monthlyIncomeProvider, (previous, next) {
      next.whenData((value) {
        final textValue = value == 0 ? "" : value.toStringAsFixed(0);
        if (_controller.text != textValue) {
          _controller.text = textValue;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final incomeAsync = ref.watch(monthlyIncomeProvider);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 12.0, spreadRadius: 1),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02),
            RichText(
              text: TextSpan(
                text: 'Monthly Income',
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
                text: 'This helps Finova AI give you personalized insights.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.01),

            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade900, width: 1.5),
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      text: "₹",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: TextField(
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (value) {
                        final parsed = double.tryParse(value) ?? 0.0;
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({"monthlyIncome": parsed});
                      },
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "0",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.028),
          ],
        ),
      ),
    );
  }
}
