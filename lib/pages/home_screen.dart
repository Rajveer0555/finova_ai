import 'package:finova_ai/providers/category_provider.dart';
import 'package:finova_ai/providers/category_summary_provider.dart';
import 'package:finova_ai/providers/total_expense_provider.dart';
import 'package:finova_ai/widgets/mainscreen_catgerories.dart';
import 'package:finova_ai/widgets/userAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primer_progress_bar/primer_progress_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final categorySummary = ref.watch(categorySummaryProvider);

    final totalExpense = ref.watch(totalExpenseProvider);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
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
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.08),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Total Spendings',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SFProText',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.0001),
                            RichText(
                              text: TextSpan(
                                text: '₹ ${totalExpense.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SFProText',
                                  fontSize: 38,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.0001),
                            RichText(
                              text: TextSpan(
                                text: 'This month',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SFProText',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        UserAvatar(radius: 28),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      width: screenWidth * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.01,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.002),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'Budgets Used',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SFProText',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                RichText(
                                  text: TextSpan(
                                    text: '75 %',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SFProText',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenWidth * 0.02),
                            LinearProgressIndicator(
                              borderRadius: BorderRadius.circular(12),
                              minHeight: 10,
                              value: 0.75,
                              backgroundColor: Colors.grey.shade300,
                              color: Color.fromARGB(255, 61, 233, 67),
                            ),
                            SizedBox(height: screenWidth * 0.02),
                            RichText(
                              text: TextSpan(
                                text: '₹ 9,550 remaining of ₹ 38,000',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.025),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.035),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: screenWidth * 0.92,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 251, 237),
                      border: Border.all(
                        color: Colors.amber.shade100,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.02,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/idea.png',
                            height: screenHeight * 0.04,
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'AI Insights',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'SFProText',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.001),
                              RichText(
                                text: TextSpan(
                                  text:
                                      'Your food expenses are 30% higher than last\nmonth. Consider meal planning to save ₹2,000',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'SFProText',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: RichText(
                      text: TextSpan(
                        text: 'Categories',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'SFProText',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  SingleChildScrollView(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];

                          final summary = categorySummary[category.title];

                          final int transactionCount = summary?.count ?? 0;
                          final double totalAmount =
                              summary?.totalAmount ?? 0.0;
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: MainscreenCatgerories(
                              category: categories[index],
                              transactionCount: transactionCount,
                              totalAmount: totalAmount,
                              onTap: () {},
                            ),
                          );
                        },
                      ),
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
