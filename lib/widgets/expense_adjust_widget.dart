import 'package:flutter/material.dart';

class ExpenseAdjustWidget extends StatelessWidget {
  final String title;
  final String budget;
  final String spent;
  final String imagePath;
  final VoidCallback onTap;
  const ExpenseAdjustWidget({
    super.key,
    required this.title,
    required this.imagePath,
    required this.budget,
    required this.spent, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: 380,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(31, 112, 112, 112),
            blurRadius: 10.0,
            spreadRadius: 1,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  height: 31,
                  width: 31,
                ),
                SizedBox(width: 18),
                Padding(
                  padding: EdgeInsets.only(right: screenWidth * 0.22),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'SFProText',
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "₹$spent spent",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'SFProText',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          budget,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SFProText',
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          "Budget",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SFProText',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenWidth * 0.019),
                    SizedBox(
                      height: 18,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Colors.black, width: 0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: onTap,
                        child: Row(
                          children: [
                            Text(
                              "Adjust",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'SFProText',
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(12),
              minHeight: 8,
              value: 0.48,
              backgroundColor: Colors.grey.shade300,
              color: Color.fromARGB(255, 100, 159, 255),
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
