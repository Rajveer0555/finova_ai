import 'package:finova_ai/models/transactions_model.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel2 transaction;
  final VoidCallback? onTap;

  const TransactionCard({super.key, required this.transaction, this.onTap});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: screenWidth,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.018,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(20, 0, 0, 0),
              blurRadius: 15,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image
            Image.asset(
              transaction.paymentImage,
              height: screenHeight * 0.055,
              width: screenWidth * 0.12,
              fit: BoxFit.contain,
            ),

            SizedBox(width: screenWidth * 0.06),

            // Title + Subtitle + Time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.category,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'SFProText',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                      fontFamily: 'SFProText',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${transaction.dateTime.day}/${transaction.dateTime.month}/${transaction.dateTime.year} || ${transaction.dateTime.hour}:${transaction.dateTime.minute}:${transaction.dateTime.second}",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                      color: Colors.black45,
                      fontFamily: 'SFProText',
                    ),
                  ),
                ],
              ),
            ),

            // Amount
            Text(
              "₹ ${transaction.amount.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'SFProText',
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
