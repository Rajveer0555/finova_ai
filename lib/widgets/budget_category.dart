import 'package:finova_ai/providers/budget_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetCategory extends ConsumerWidget {
  final String id;
  final String title;
  final String imagePath;
  const BudgetCategory({
    super.key,
    required this.title,
    required this.imagePath,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amount = ref.read(budgetAmountProvider(id));
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image(
          image: AssetImage(imagePath),
          fit: BoxFit.contain,
          height: screenHeight * 0.05,
          width: screenWidth * 0.15,
        ),
        SizedBox(width: screenWidth * 0.06),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: title,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'SFProText',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Container(
              height: screenHeight * 0.035,
              width: screenWidth * 0.5,
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.005,
                horizontal: screenWidth * 0.03,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade900, width: 1),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      text: "₹",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  Expanded(
                    child: TextField(
                      enableInteractiveSelection: true,
                      cursorColor: Colors.black,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (value) {
                        final parsed = double.tryParse(value) ?? 0.0;
                        ref.read(budgetAmountProvider(id).notifier).state =
                            parsed;
                      },
                      controller: TextEditingController(
                        text: amount == 0 ? "" : amount.toString(),
                      ),
                      decoration: InputDecoration(
                        hintText: "00.00",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(width: screenWidth * 0.04),
      ],
    );
  }
}
