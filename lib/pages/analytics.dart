import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:finova_ai/pages/ai_prediction_screen.dart';
import 'package:finova_ai/pages/statesScreens/error_state.dart';
import 'package:finova_ai/pages/statesScreens/loading_state.dart';
import 'package:finova_ai/pages/statesScreens/no_internet_screen.dart';
import 'package:finova_ai/providers/ai_insight_provider.dart';
import 'package:finova_ai/providers/analytics_provider.dart';
import 'package:finova_ai/providers/connectivity_provider.dart';
import 'package:finova_ai/providers/monthly_graph_provider.dart';
import 'package:finova_ai/providers/transactions_stream_provider.dart';
import 'package:finova_ai/utils/formatters.dart';
import 'package:finova_ai/utils/page_transitions.dart';
import 'package:finova_ai/widgets/graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pie_chart/pie_chart.dart';

String formatMonth(String key) {
  if (key.isEmpty || !key.contains('-')) return key;

  final parts = key.split('-');
  if (parts.length != 2) return key;

  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  if (year == null || month == null || month < 1 || month > 12) {
    return key;
  }

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[month - 1]} $year';
}

class Analytics extends ConsumerWidget {
  const Analytics({super.key});

  static const Map<String, Color> _categoryColors = {
    'food': Color.fromARGB(255, 157, 255, 46),
    'travel': Colors.red,
    'shopping': Colors.purpleAccent,
    'bills': Colors.yellow,
    'other': Colors.lightBlue,
    'others': Colors.lightBlue,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final transactionsAsync = ref.watch(transactionsStreamProvider);
    final connectivityAsync = ref.watch(connectivityProvider);

    return transactionsAsync.when(
      data: (snapshot) {
        final analytics = ref.watch(analyticsProvider);
        final ai = ref.watch(aiInsightProvider);
        final graph = ref.watch(monthlyGraphProvider);

        final hasCategoryData = analytics.categoryMap.isNotEmpty;
        final pieData =
            hasCategoryData ? analytics.categoryMap : const {'No Data': 1.0};
        final pieColors =
            hasCategoryData
                ? pieData.keys
                    .map((cat) => _categoryColors[cat] ?? Colors.grey)
                    .toList()
                : [Colors.grey.shade300];

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                  color: Color(0xFF4A90FF),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(31, 112, 112, 112),
                      blurRadius: 12.0,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                width: screenWidth,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.08),
                      const Text(
                        'Analytics',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SFProText',
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _SummaryCard(
                            width: screenWidth * 0.4,
                            title: 'Total Spent',
                            value: formatCurrency(analytics.totalSpent),
                          ),
                          _SummaryCard(
                            width: screenWidth * 0.4,
                            title: 'Avg/Month',
                            value: formatCurrency(analytics.avgPerMonth),
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
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            buildSlideFromRightRoute(
                              const AiPredictionScreen(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
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
                                const Icon(
                                  Icons.lightbulb,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                                SizedBox(width: screenWidth * 0.04),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'AI Prediction',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: 'SFProText',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.004),
                                      Text(
                                        ai.analyticsPreviewText,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontFamily: 'SFProText',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: const [
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
                              const Text(
                                'Category Breakdown',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'SFPro',
                                ),
                              ),
                              const SizedBox(height: 22),
                              PieChart(
                                chartValuesOptions: const ChartValuesOptions(
                                  showChartValueBackground: true,
                                  showChartValues: false,
                                  showChartValuesInPercentage: false,
                                  decimalPlaces: 1,
                                ),
                                chartRadius: 180,
                                legendOptions: const LegendOptions(
                                  showLegends: false,
                                  legendPosition: LegendPosition.bottom,
                                ),
                                dataMap: pieData,
                                chartType: ChartType.ring,
                                baseChartColor: Colors.grey[300]!,
                                colorList: pieColors,
                              ),
                              const SizedBox(height: 22),
                              if (!hasCategoryData)
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    'No expenses yet',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              if (hasCategoryData)
                                Column(
                                  children: [
                                    for (final entry
                                        in (analytics.categoryMap.entries.toList()
                                          ..sort(
                                            (a, b) =>
                                                b.value.compareTo(a.value),
                                          )))
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 8,
                                              backgroundColor:
                                                  _categoryColors[entry.key] ??
                                                  Colors.grey,
                                            ),
                                            const SizedBox(width: 28),
                                            Text(
                                              _formatCategoryName(entry.key),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "${(analytics.totalSpent == 0 ? 0 : (entry.value / analytics.totalSpent) * 100).toStringAsFixed(1)}%",
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: const [
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
                              const Text(
                                'Monthly Trend',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'SFPro',
                                ),
                              ),
                              const SizedBox(height: 22),
                              const MonthlyBarGraph(),
                              const SizedBox(height: 12),
                              const Divider(),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Highest',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "${formatCurrency(graph.highestValue)} (${formatMonth(graph.highestMonth)})",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'Lowest',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "${formatCurrency(graph.lowestValue)} (${formatMonth(graph.lowestMonth)})",
                                        style: const TextStyle(
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
      },
      loading: () => const LoadingState(),
      error: (e, _) {
        return connectivityAsync.when(
          data: (connectivity) {
            if (connectivity == ConnectivityResult.none) {
              return NoInternetScreen(
                onRetry: () => ref.invalidate(transactionsStreamProvider),
              );
            }

            return ErrorStateScreen(
              onRetry: () => ref.invalidate(transactionsStreamProvider),
            );
          },
          loading: () => const LoadingState(),
          error: (_, __) => ErrorStateScreen(
            onRetry: () => ref.invalidate(transactionsStreamProvider),
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final double width;
  final String title;
  final String value;

  const _SummaryCard({
    required this.width,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        color: const Color.fromARGB(255, 100, 159, 255),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'SFProText',
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'SFProText',
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatCategoryName(String key) {
  if (key.isEmpty) return 'Other';
  final normalized = key == 'others' ? 'other' : key;
  return normalized[0].toUpperCase() + normalized.substring(1);
}
