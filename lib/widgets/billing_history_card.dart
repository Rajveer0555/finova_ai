import 'package:flutter/material.dart';

class BillingHistoryCard extends StatelessWidget {
  final String payMethod;
  final String imagePath;
  final String date;
  const BillingHistoryCard({
    super.key,
    required this.payMethod,
    required this.imagePath,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black12, spreadRadius: 0.5, blurRadius: 0.5),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/crown.png", height: 25, width: 25),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Finova AI Pro",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SFProText',
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '$date •',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(width: 4),
                        Image.asset(imagePath, height: 14, width: 14),

                        SizedBox(width: 4),
                        Text(
                          payMethod,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline_outlined,
                          size: 14,
                          color: Colors.green,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Paid",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  '₹ 249',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            Divider(color: Colors.grey.shade300, thickness: 1),
            SizedBox(height: 8),
            InkWell(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.my_library_books_rounded,
                    size: 17,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 6),
                  Text(
                    "Download Invoice",
                    style: TextStyle(
                      height: 0.6,
                      color: Colors.blue,
                      fontSize: 14,
                      fontFamily: 'SFProText',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
