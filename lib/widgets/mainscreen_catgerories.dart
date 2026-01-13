import 'package:finova_ai/models/category_model.dart';
import 'package:flutter/material.dart';

class MainscreenCatgerories extends StatelessWidget {
  final CategoryModel category;
  final int transactionCount;
  final VoidCallback? onTap;
  final double totalAmount;
  const MainscreenCatgerories({
    super.key,
    required this.category,
    this.onTap,
    required this.transactionCount,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(31, 112, 112, 112),
              blurRadius: 12.0,
              spreadRadius: 1,
            ),
          ],
        ),
        width: screenWidth * 1,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.020),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 40),
              Image(
                image: AssetImage(category.imagePath),
                fit: BoxFit.contain,
                height: screenHeight * 0.06,
                width: screenWidth * 0.15,
              ),
              SizedBox(width: screenWidth * 0.08),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: category.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'SFProText',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.004),
                  RichText(
                    text: TextSpan(
                      text: "$transactionCount Transactions",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'SFProText',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: screenWidth * 0.28),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "₹ ${totalAmount.toStringAsFixed(0)}",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'SFProText',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.001),
                  RichText(
                    text: TextSpan(
                      text: category.perc,
                      style: TextStyle(
                        color: Color(category.colorValue),
                        fontFamily: 'SFProText',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
