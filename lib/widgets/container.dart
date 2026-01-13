import 'package:finova_ai/providers/income_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Container2 extends ConsumerWidget {
  const Container2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final income = ref.watch(monthlyIncomeProvider);

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
                        ref.read(monthlyIncomeProvider.notifier).state = parsed;
                      },
                      controller: TextEditingController(
                        text: income == 0 ? "" : income.toString(),
                      ),
                      decoration: InputDecoration(
                        hintText: "00.00",
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
