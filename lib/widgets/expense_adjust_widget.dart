import 'package:flutter/material.dart';

class ExpenseAdjustWidget extends StatelessWidget {
  final String title;
  final double budget;
  final double spent;
  final String imagePath;
  final VoidCallback onTap;

  const ExpenseAdjustWidget({
    super.key,
    required this.title,
    required this.imagePath,
    required this.budget,
    required this.spent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = budget == 0 ? 0 : (spent / budget).clamp(0, 1);

    final Color progressColor =
        progress < 0.5
            ? Colors.green
            : progress < 0.8
            ? Colors.orange
            : Colors.red;

    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(31, 112, 112, 112),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        children: [
          /// MAIN ROW
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                /// ICON
                Image.asset(imagePath, height: 32, width: 32),

                const SizedBox(width: 14),

                /// TITLE + SPENT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'SFProText',
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        "₹${spent.toStringAsFixed(0)} spent",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'SFProText',
                        ),
                      ),
                    ],
                  ),
                ),

                /// BUDGET + BUTTON
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          "₹${budget.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SFProText',
                          ),
                        ),

                        const SizedBox(width: 4),

                        const Text(
                          "Budget",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SFProText',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    SizedBox(
                      height: 22,
                      child: OutlinedButton(
                        onPressed: onTap,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          side: const BorderSide(color: Colors.black12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          "Adjust",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'SFProText',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// PROGRESS BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(12),
              backgroundColor: Colors.grey.shade300,
              color: progressColor,
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
