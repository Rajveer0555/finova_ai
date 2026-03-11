import 'package:finova_ai/providers/analytics_provider.dart';
import 'package:finova_ai/providers/total_expense_provider.dart';
import 'package:finova_ai/widgets/graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pie_chart/pie_chart.dart';

class Analytics extends ConsumerStatefulWidget {
  const Analytics({super.key});

  @override
  ConsumerState<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends ConsumerState<Analytics> {
  final Map<String, Color> categoryColors = {
    "food": const Color.fromARGB(255, 157, 255, 46),
    "travel": Colors.red,
    "shopping": Colors.purpleAccent,
    "bills": Colors.yellow,
    "other": Colors.lightBlue,
  };
  final colorList = <Color>[
    const Color.fromARGB(255, 157, 255, 46),
    Colors.red,
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
  ];
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final analytics = ref.watch(analyticsProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              color: Color(0xFF4A90FF),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(31, 112, 112, 112),
                  blurRadius: 12.0,
                  spreadRadius: 0,
                ),
              ],
            ),
            width: screenWidth * 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.08),
                  RichText(
                    text: TextSpan(
                      text: 'Analytics',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SFProText',
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: screenWidth * 0.4,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          color: Color.fromARGB(255, 100, 159, 255),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.01,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: screenHeight * 0.002),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 6),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Total Spent',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'SFProText',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    RichText(
                                      text: TextSpan(
                                        text:
                                            '₹ ${analytics.totalSpent.toStringAsFixed(2)}', // Replace with actual total expenses
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'SFProText',
                                          fontSize: 24,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.4,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          color: Color.fromARGB(255, 100, 159, 255),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.01,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: screenHeight * 0.002),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 6),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Avg/Month',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'SFProText',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    RichText(
                                      text: TextSpan(
                                        text:
                                            '₹ ${analytics.avgPerMonth.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'SFProText',
                                          fontSize: 24,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: screenWidth * 0.92,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 237, 247, 255),
                      border: Border.all(
                        color: Colors.lightBlue.shade100,
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
                          Icon(Icons.lightbulb, color: Colors.blue, size: 30),
                          SizedBox(width: screenWidth * 0.04),
                          Expanded(
                            child: Column(
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
                                SizedBox(height: screenHeight * 0.004),
                                RichText(
                                  text: TextSpan(
                                    text:
                                        'Your spending increased by 8.5% this month.Travel is your highest expense category.',
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 0.5,
                          blurRadius: 0.5,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    width: screenWidth * 0.9,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.12,
                        vertical: screenHeight * 0.02,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Category Breakdown",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'SFPro',
                            ),
                          ),
                          SizedBox(height: 22),
                          PieChart(
                            chartValuesOptions: ChartValuesOptions(
                              showChartValueBackground: true,
                              showChartValues: false,
                              showChartValuesInPercentage: false,
                              decimalPlaces: 1,
                            ),
                            chartRadius: 180,
                            legendOptions: LegendOptions(
                              showLegends: false,
                              legendPosition: LegendPosition.bottom,
                            ),
                            dataMap: analytics.categoryMap,
                            chartType: ChartType.ring,
                            baseChartColor: Colors.grey[300]!,
                            colorList:
                                analytics.categoryMap.keys
                                    .map(
                                      (cat) =>
                                          categoryColors[cat] ?? Colors.grey,
                                    )
                                    .toList(),
                          ),
                          SizedBox(height: 22),
                          Column(
                            children:
                                analytics.categoryMap.entries.map((entry) {
                                  double percent =
                                      (entry.value / analytics.totalSpent) *
                                      100;

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 8,
                                          backgroundColor:
                                              categoryColors[entry.key] ??
                                              Colors.grey,
                                        ),
                                        SizedBox(width: 28),

                                        Text(
                                          entry.key,
                                          style: TextStyle(fontSize: 14),
                                        ),

                                        Spacer(),

                                        Text(
                                          "${percent.toStringAsFixed(1)}%",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 0.5,
                          blurRadius: 0.5,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    width: screenWidth * 0.9,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.12,
                        vertical: screenHeight * 0.02,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Monthly Trend",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'SFPro',
                            ),
                          ),
                          SizedBox(height: 22),
                          MonthlyBarGraph(),
                          SizedBox(height: 12),
                          Divider(),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Highest",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "₹ ${analytics.highestValue.toStringAsFixed(0)} (${analytics.highestMonth})",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Lowest",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "₹ ${analytics.lowestValue.toStringAsFixed(0)} (${analytics.lowestMonth})",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
