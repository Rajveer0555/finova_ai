import 'dart:math' as math;

import 'package:finova_ai/pages/profileScreens/manage_budget.dart';
import 'package:finova_ai/providers/ai_insight_provider.dart';
import 'package:finova_ai/services/finova_ai_engine.dart';
import 'package:finova_ai/utils/formatters.dart';
import 'package:finova_ai/utils/page_transitions.dart';
import 'package:finova_ai/widgets/elevated_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiPredictionScreen extends ConsumerWidget {
  const AiPredictionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ai = ref.watch(aiInsightProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    final points =
        ai.forecastSeries.isNotEmpty
            ? ai.forecastSeries
            : const [
              AiForecastPoint(label: 'Week 1', amount: 0),
              AiForecastPoint(label: 'Week 2', amount: 0),
              AiForecastPoint(label: 'Week 3', amount: 0),
              AiForecastPoint(label: 'Week 4', amount: 0),
            ];
    final maxPoint = math.max(
      1.0,
      points.map((point) => point.amount).reduce(math.max),
    ).toDouble();

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
              'Ai Prediction',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                fontFamily: 'SFProText',
              ),
            ),
            Text(
              'Next 30 days forecast',
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'You may spend',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'SFProText',
                            ),
                          ),
                          const SizedBox(height: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: formatCurrency(ai.predictedNextMonthSpend),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'SFProDisplay',
                                    ),
                                  ),
                                  const TextSpan(
                                    text: ' next month',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'SFProText',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
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
                          const SizedBox(height: 18),
                          SizedBox(
                            height: 180,
                            child: LineChart(
                              LineChartData(
                                minX: 0,
                                maxX: 3,
                                minY: 0,
                                maxY: maxPoint * 1.15,
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  getDrawingHorizontalLine:
                                      (value) => FlLine(
                                        color: Colors.grey.shade200,
                                        strokeWidth: 1,
                                      ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 24,
                                      getTitlesWidget: (value, meta) {
                                        final index = value.toInt();
                                        if (index < 0 || index >= points.length) {
                                          return const SizedBox();
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8),
                                          child: Text(
                                            points[index].label,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'SFProText',
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: List.generate(
                                      points.length,
                                      (index) => FlSpot(
                                        index.toDouble(),
                                        points[index].amount,
                                      ),
                                    ),
                                    isCurved: true,
                                    barWidth: 3,
                                    color: const Color(0xFF4A90FF),
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, percent, bar, index) =>
                                              FlDotCirclePainter(
                                                radius: 4,
                                                color: const Color(0xFF4A90FF),
                                                strokeWidth: 2,
                                                strokeColor: Colors.white,
                                              ),
                                    ),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(
                                            0xFF4A90FF,
                                          ).withOpacity(0.22),
                                          const Color(
                                            0xFF4A90FF,
                                          ).withOpacity(0.03),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Forecast uses your last 30 days, the previous 30 days, and your older saved history. Category values below show the expected change for the next 30 days versus your recent 30 days.',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'SFProText',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Spending Forecast',
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      child:
                          ai.forecastCategories.isEmpty
                              ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  'Add more transaction history to unlock category forecasts.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'SFProText',
                                  ),
                                ),
                              )
                              : Column(
                                children:
                                    ai.forecastCategories
                                        .map(
                                          (item) => _ForecastRow(item: item),
                                        )
                                        .toList(),
                              ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      ai.currentCategoryBudget > 0
                          ? 'Current ${ai.focusCategoryTitle.toLowerCase()} budget: ${formatCurrency(ai.currentCategoryBudget)}. Suggested next step: move it closer to ${formatCurrency(ai.suggestedCategoryBudget)}.'
                          : 'Click below to review your category budgets and keep your next month forecast under control.',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'SFProText',
                      ),
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
            child: Column(
              children: [
                ElevatedButtonCust('Set Budget', () {
                  Navigator.push(
                    context,
                    buildSlideFromRightRoute(const ManageBudgetScreen()),
                  );
                }),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Ignore for now',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'SFProText',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ForecastRow extends StatelessWidget {
  final AiForecastCategory item;

  const _ForecastRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEAEAEA))),
      ),
      child: Row(
        children: [
          Image.asset(
            aiCategoryIcon(item.categoryKey),
            width: 34,
            height: 34,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              item.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'SFProText',
              ),
            ),
          ),
          Flexible(
            child: Text(
              '${item.changeAmount >= 0 ? '+' : '-'}${formatCurrency(item.changeAmount.abs())}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color:
                    item.changeAmount >= 0
                        ? const Color(0xFF4A90FF)
                        : Colors.green,
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

