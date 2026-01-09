import 'package:finova_ai/widgets/quickbtn.dart';
import 'package:flutter/material.dart';

class BudgetCategory extends StatelessWidget {
  final String title;
  final String imagePath;
  const BudgetCategory({
    super.key,
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(imagePath),
          fit: BoxFit.contain,
          height: screenHeight * 0.05,
          width: screenWidth * 0.15,
        ),
        SizedBox(width: screenWidth * 0.03),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'SFProText',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Container(
              height: screenHeight * 0.035,
              width: screenWidth * 0.3,
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.005,
                horizontal: screenWidth * 0.03,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade900, width: 1.5),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const Text(
                    "₹",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),

                  Expanded(
                    child: TextField(
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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
        Column(
          children: [
            Quickbtn(text: '₹5k'),
            SizedBox(height: screenHeight * 0.008),
            Quickbtn(text: '₹15k'),
          ],
        ),
        SizedBox(width: screenWidth * 0.005),
        Column(
          children: [
            Quickbtn(text: '₹10k'),
            SizedBox(height: screenHeight * 0.008),
            Quickbtn(text: '₹20k'),
          ],
        ),
      ],
    );
  }
}
