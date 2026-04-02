import 'dart:math' as math;

import 'package:finova_ai/pages/ai_prediction_screen.dart';
import 'package:finova_ai/providers/ai_insight_provider.dart';
import 'package:finova_ai/services/finova_ai_engine.dart';
import 'package:finova_ai/utils/formatters.dart';
import 'package:finova_ai/utils/page_transitions.dart';
import 'package:finova_ai/widgets/elevated_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiInsightsScreen extends ConsumerWidget {
  const AiInsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ai = ref.watch(aiInsightProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final deltaAmount = ai.monthlyCategoryDelta.abs();
    final comparisonMax =
        math.max(
          1.0,
          math.max(
            ai.previousMonthCategorySpend,
            ai.currentMonthCategorySpend,
          ),
        ).toDouble();

    final headline =
        ai.hasTransactions
            ? ai.monthlyCategoryDelta >= 0
                ? 'You spent ${formatCurrency(deltaAmount)} more on ${ai.focusCategoryTitle} in ${ai.currentMonthLabel}'
                : 'You spent ${formatCurrency(deltaAmount)} less on ${ai.focusCategoryTitle} in ${ai.currentMonthLabel}'
            : 'Add a few expenses to unlock your AI spending insights';

    final budgetHint =
        ai.suggestedCategoryBudget > 0
            ? 'Set a ${ai.focusCategoryTitle.toLowerCase()} budget near ${formatCurrency(ai.suggestedCategoryBudget)} to manage your spending.'
            : 'Create budgets for your categories to unlock sharper AI suggestions.';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.black,
        ),
        surfaceTintColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        toolbarHeight: 84,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Column(
          children: [
            const Text(
              'Ai Insights',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                fontFamily: 'SFProText',
              ),
            ),
            Text(
              ai.hasTransactions
                  ? '${ai.previousMonthLabel} vs ${ai.currentMonthLabel}'
                  : 'Based on your recent spending',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'SFProText',
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.05),
                          blurRadius: 18,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/warning.png',
                            height: 48,
                            width: 48,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  headline,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    height: 1.25,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'SFProText',
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 7,
                                  ),
                                  child: Text(
                                    _confidenceLabel(ai.confidence),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'SFProText',
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
                  const SizedBox(height: 18),
                  const Text(
                    'Spending Breakdown',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SFProText',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.05),
                          blurRadius: 18,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: screenWidth * 0.38,
                            height: 140,
                            child: BarChart(
                              BarChartData(
                                maxY: comparisonMax * 1.25,
                                alignment: BarChartAlignment.spaceAround,
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: comparisonMax / 4,
                                  getDrawingHorizontalLine:
                                      (value) => FlLine(
                                        color: Colors.grey.shade200,
                                        strokeWidth: 1,
                                      ),
                                ),
                                borderData: FlBorderData(show: false),
                                titlesData: FlTitlesData(
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 24,
                                      getTitlesWidget: (value, meta) {
                                        final labels = [
                                          ai.previousMonthLabel,
                                          ai.currentMonthLabel,
                                        ];
                                        final index = value.toInt();
                                        if (index < 0 || index >= labels.length) {
                                          return const SizedBox();
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              labels[index],
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'SFProText',
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                barGroups: [
                                  BarChartGroupData(
                                    x: 0,
                                    barRods: [
                                      BarChartRodData(
                                        toY: ai.previousMonthCategorySpend,
                                        width: 26,
                                        color: const Color(0xFF4F80E1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 1,
                                    barRods: [
                                      BarChartRodData(
                                        toY: ai.currentMonthCategorySpend,
                                        width: 26,
                                        color: const Color(0xFFFFB443),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ai.focusCategoryTitle,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'SFProText',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${formatCurrency(ai.previousMonthCategorySpend)} -> ${formatCurrency(ai.currentMonthCategorySpend)}',
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'SFProText',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${ai.monthlyCategoryDeltaPercent >= 0 ? '+' : '-'}${formatPercentage(ai.monthlyCategoryDeltaPercent.abs())}',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          ai.monthlyCategoryDeltaPercent >= 0
                                              ? const Color(0xFF4A90FF)
                                              : Colors.green,
                                      fontFamily: 'SFProDisplay',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _LegendDot(
                                        color: const Color(0xFF4F80E1),
                                        label: ai.previousMonthLabel,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _LegendDot(
                                        color: const Color(0xFFFFB443),
                                        label: ai.currentMonthLabel,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Ai Analysis',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SFProText',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.05),
                          blurRadius: 18,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children:
                            ai.analysisPoints
                                .map((point) => _BulletPoint(text: point))
                                .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Top Factors',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SFProText',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.05),
                          blurRadius: 18,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      child:
                          ai.topFactors.isEmpty
                              ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Text(
                                  'Add more ${ai.focusCategoryTitle.toLowerCase()} transactions to surface factor analysis.',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'SFProText',
                                  ),
                                ),
                              )
                              : Column(
                                children:
                                    ai.topFactors
                                        .map(
                                          (factor) => _FactorTile(
                                            title: factor.title,
                                            amount: factor.amount,
                                            categoryKey: ai.focusCategoryKey,
                                          ),
                                        )
                                        .toList(),
                              ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          aiCategoryIcon(ai.focusCategoryKey),
                          width: 18,
                          height: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            budgetHint,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'SFProText',
                              color: Colors.black87,
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
          Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                  blurRadius: 12,
                ),
              ],
            ),
            child: ElevatedButtonCust('Next', () {
              Navigator.push(
                context,
                buildSlideFromRightRoute(const AiPredictionScreen()),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontFamily: 'SFProText',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;

  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Icon(Icons.circle, size: 8, color: Colors.black87),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                height: 1.35,
                fontWeight: FontWeight.w400,
                fontFamily: 'SFProText',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FactorTile extends StatelessWidget {
  final String title;
  final double amount;
  final String categoryKey;

  const _FactorTile({
    required this.title,
    required this.amount,
    required this.categoryKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEAEAEA))),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFF4F7FB),
            child: Icon(
              _factorIcon(title, categoryKey),
              size: 18,
              color: const Color(0xFF4A90FF),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'SFProText',
              ),
            ),
          ),
          Flexible(
            child: Text(
              '+${formatCurrency(amount)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'SFProText',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _confidenceLabel(int confidence) {
  if (confidence >= 85) {
    return 'High confidence - $confidence%';
  }
  if (confidence >= 70) {
    return 'Medium confidence - $confidence%';
  }
  return 'Emerging confidence - $confidence%';
}

IconData _factorIcon(String title, String categoryKey) {
  final normalizedTitle = title.toLowerCase();
  if (normalizedTitle.contains('delivery')) return Icons.delivery_dining_rounded;
  if (normalizedTitle.contains('cafe') || normalizedTitle.contains('coffee')) {
    return Icons.local_cafe_rounded;
  }
  if (normalizedTitle.contains('dining') || normalizedTitle.contains('restaurant')) {
    return Icons.restaurant_rounded;
  }
  if (normalizedTitle.contains('flight')) return Icons.flight_takeoff_rounded;
  if (normalizedTitle.contains('fuel')) return Icons.local_gas_station_rounded;
  if (normalizedTitle.contains('fashion')) return Icons.checkroom_rounded;
  if (normalizedTitle.contains('rent')) return Icons.home_rounded;
  if (normalizedTitle.contains('utilities')) return Icons.lightbulb_outline_rounded;

  switch (categoryKey) {
    case 'food':
      return Icons.restaurant_rounded;
    case 'travel':
      return Icons.luggage_rounded;
    case 'shopping':
      return Icons.shopping_bag_rounded;
    case 'bills':
      return Icons.receipt_long_rounded;
    default:
      return Icons.insights_rounded;
  }
}


