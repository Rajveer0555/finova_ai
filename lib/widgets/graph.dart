import 'package:finova_ai/providers/income_provider.dart';
import 'package:finova_ai/providers/monthly_graph_provider.dart';
import 'package:finova_ai/utils/formatters.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finova_ai/providers/budget_provider.dart';

class MonthlyBarGraph extends ConsumerWidget {
  const MonthlyBarGraph({super.key});
  String formatYAxis(double value) {
    if (value >= 1000) {
      double kValue = value / 1000;

      if (kValue % 1 == 0) {
        return "₹${kValue.toInt()}k";
      } else {
        return "₹${kValue.toStringAsFixed(1)}k";
      }
    }

    return "₹${value.toInt()}";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetAsync = ref.watch(budgetProvider);
    final values = ref.watch(lastSixMonthsExpenseProvider);
    final labels = ref.watch(lastSixMonthLabelsProvider);
    final incomeAsync = ref.watch(monthlyIncomeProvider);

    final income = incomeAsync.maybeWhen(
      data: (value) => value,
      orElse: () => 0.0,
    );

    final totalBudget = budgetAsync.maybeWhen(
      data: (budgetDoc) {
        final budgets = Map<String, dynamic>.from(
          budgetDoc.data()?['budgets'] ?? {},
        );

        return budgets.values.fold<double>(
          0.0,
          (sum, item) => sum + (item ?? 0),
        );
      },
      orElse: () => 0.0,
    );

    /// find highest value for scaling graph
    final double maxExpense =
        values.isEmpty
            ? 0.0
            : values.reduce((a, b) => a > b ? a : b).toDouble();
    final double maxY = income > 0 ? income.toDouble() : 100.0;
    return SizedBox(
      height: 200,
      child: BarChart(
        swapAnimationDuration: const Duration(milliseconds: 500),
        BarChartData(
          maxY: maxY,

          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),

          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

            /// Y AXIS
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 42,
                showTitles: true,
                interval: maxY / 4,
                getTitlesWidget: (value, meta) {
                  if (value % (maxY / 4) != 0) return const SizedBox();

                  return Text(
                    formatYAxis(value),
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  );
                },
              ),
            ),

            /// X AXIS
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();

                  if (index >= labels.length) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      labels[index],
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.lightBlue,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  formatCurrency(rod.toY),
                  const TextStyle(color: Colors.white),
                );
              },
            ),
          ),

          /// BARS
          barGroups: List.generate(values.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: values[index] > maxY ? maxY : values[index],
                  width: 16,
                  borderRadius: BorderRadius.circular(6),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF4A90E2)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
