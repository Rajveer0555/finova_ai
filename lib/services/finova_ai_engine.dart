import 'dart:math' as math;

import 'package:finova_ai/utils/formatters.dart';

class AiInputTransaction {
  final String title;
  final String categoryKey;
  final double amount;
  final DateTime date;

  const AiInputTransaction({
    required this.title,
    required this.categoryKey,
    required this.amount,
    required this.date,
  });
}

class AiFactorItem {
  final String title;
  final double amount;

  const AiFactorItem({required this.title, required this.amount});
}

class AiForecastPoint {
  final String label;
  final double amount;

  const AiForecastPoint({required this.label, required this.amount});
}

class AiForecastCategory {
  final String categoryKey;
  final String title;
  final double recentAmount;
  final double predictedAmount;
  final double changeAmount;
  final double changePercent;

  const AiForecastCategory({
    required this.categoryKey,
    required this.title,
    required this.recentAmount,
    required this.predictedAmount,
    required this.changeAmount,
    required this.changePercent,
  });
}

class AiInsightResult {
  final bool hasTransactions;
  final String focusCategoryKey;
  final String focusCategoryTitle;
  final String currentMonthLabel;
  final String previousMonthLabel;
  final double currentMonthSpend;
  final double previousMonthSpend;
  final double monthlyDelta;
  final double monthlyDeltaPercent;
  final double currentMonthCategorySpend;
  final double previousMonthCategorySpend;
  final double monthlyCategoryDelta;
  final double monthlyCategoryDeltaPercent;
  final double currentCategorySpend;
  final double previousCategorySpend;
  final double categoryDelta;
  final double categoryDeltaPercent;
  final double current30Total;
  final double previous30Total;
  final double totalChangePercent;
  final int confidence;
  final List<String> analysisPoints;
  final List<AiFactorItem> topFactors;
  final double predictedNextMonthSpend;
  final List<AiForecastPoint> forecastSeries;
  final List<AiForecastCategory> forecastCategories;
  final double suggestedCategoryBudget;
  final double currentCategoryBudget;
  final String homePreviewText;
  final String analyticsPreviewText;

  const AiInsightResult({
    required this.hasTransactions,
    required this.focusCategoryKey,
    required this.focusCategoryTitle,
    required this.currentMonthLabel,
    required this.previousMonthLabel,
    required this.currentMonthSpend,
    required this.previousMonthSpend,
    required this.monthlyDelta,
    required this.monthlyDeltaPercent,
    required this.currentMonthCategorySpend,
    required this.previousMonthCategorySpend,
    required this.monthlyCategoryDelta,
    required this.monthlyCategoryDeltaPercent,
    required this.currentCategorySpend,
    required this.previousCategorySpend,
    required this.categoryDelta,
    required this.categoryDeltaPercent,
    required this.current30Total,
    required this.previous30Total,
    required this.totalChangePercent,
    required this.confidence,
    required this.analysisPoints,
    required this.topFactors,
    required this.predictedNextMonthSpend,
    required this.forecastSeries,
    required this.forecastCategories,
    required this.suggestedCategoryBudget,
    required this.currentCategoryBudget,
    required this.homePreviewText,
    required this.analyticsPreviewText,
  });

  factory AiInsightResult.empty() {
    return const AiInsightResult(
      hasTransactions: false,
      focusCategoryKey: 'food',
      focusCategoryTitle: 'Food',
      currentMonthLabel: 'This Month',
      previousMonthLabel: 'Last Month',
      currentMonthSpend: 0,
      previousMonthSpend: 0,
      monthlyDelta: 0,
      monthlyDeltaPercent: 0,
      currentMonthCategorySpend: 0,
      previousMonthCategorySpend: 0,
      monthlyCategoryDelta: 0,
      monthlyCategoryDeltaPercent: 0,
      currentCategorySpend: 0,
      previousCategorySpend: 0,
      categoryDelta: 0,
      categoryDeltaPercent: 0,
      current30Total: 0,
      previous30Total: 0,
      totalChangePercent: 0,
      confidence: 0,
      analysisPoints: [
        'Add a few expenses to unlock insight analysis.',
        'We use your real transactions to detect category patterns.',
        'Predictions improve as your history grows over time.',
      ],
      topFactors: [],
      predictedNextMonthSpend: 0,
      forecastSeries: [
        AiForecastPoint(label: 'Week 1', amount: 0),
        AiForecastPoint(label: 'Week 2', amount: 0),
        AiForecastPoint(label: 'Week 3', amount: 0),
        AiForecastPoint(label: 'Week 4', amount: 0),
      ],
      forecastCategories: [],
      suggestedCategoryBudget: 0,
      currentCategoryBudget: 0,
      homePreviewText: 'Add a few expenses to unlock AI insights.',
      analyticsPreviewText: 'Your next 30 day forecast will appear here.',
    );
  }
}

String aiCategoryTitle(String key) {
  switch (_normalizeCategoryKey(key)) {
    case 'food':
      return 'Food';
    case 'travel':
      return 'Travel';
    case 'shopping':
      return 'Shopping';
    case 'bills':
      return 'Bills';
    default:
      return 'Others';
  }
}

String aiCategoryIcon(String key) {
  switch (_normalizeCategoryKey(key)) {
    case 'food':
      return 'assets/diet.png';
    case 'travel':
      return 'assets/travel-luggage.png';
    case 'shopping':
      return 'assets/shopping-bag.png';
    case 'bills':
      return 'assets/bill.png';
    default:
      return 'assets/delivery-box.png';
  }
}

class FinovaAiEngine {
  static AiInsightResult build({
    required List<AiInputTransaction> transactions,
    required Map<String, double> budgets,
    required double monthlyIncome,
    DateTime? now,
  }) {
    if (transactions.isEmpty) {
      return AiInsightResult.empty();
    }

    final currentNow = now ?? DateTime.now();
    final currentWindowStart = currentNow.subtract(const Duration(days: 30));
    final previousWindowStart = currentNow.subtract(const Duration(days: 60));

    final last30 =
        transactions
            .where((tx) => !tx.date.isBefore(currentWindowStart))
            .toList();
    final previous30 =
        transactions
            .where(
              (tx) =>
                  tx.date.isBefore(currentWindowStart) &&
                  !tx.date.isBefore(previousWindowStart),
            )
            .toList();
    final currentCategoryTotals = _sumByCategory(last30);
    final previousCategoryTotals = _sumByCategory(previous30);
    final allTimeCategoryTotals = _sumByCategory(transactions);
    final historyMonths = _historyMonthsCovered(transactions, currentNow);

    final currentMonthStart = DateTime(currentNow.year, currentNow.month, 1);
    final nextMonthStart = DateTime(currentNow.year, currentNow.month + 1, 1);
    final previousMonthStart = DateTime(
      currentNow.year,
      currentNow.month - 1,
      1,
    );
    final currentMonthTransactions =
        transactions
            .where(
              (tx) =>
                  !tx.date.isBefore(currentMonthStart) &&
                  tx.date.isBefore(nextMonthStart),
            )
            .toList();
    final previousMonthTransactions =
        transactions
            .where(
              (tx) =>
                  !tx.date.isBefore(previousMonthStart) &&
                  tx.date.isBefore(currentMonthStart),
            )
            .toList();
    final currentMonthCategoryTotals = _sumByCategory(currentMonthTransactions);
    final previousMonthCategoryTotals = _sumByCategory(
      previousMonthTransactions,
    );
    final currentMonthSpend = currentMonthTransactions.fold<double>(
      0,
      (sum, tx) => sum + tx.amount,
    );
    final previousMonthSpend = previousMonthTransactions.fold<double>(
      0,
      (sum, tx) => sum + tx.amount,
    );
    final monthlyDelta = currentMonthSpend - previousMonthSpend;
    final monthlyDeltaPercent =
        previousMonthSpend > 0
            ? (monthlyDelta / previousMonthSpend) * 100
            : (currentMonthSpend > 0 ? 100.0 : 0.0);
    final focusCategoryKey = _pickFocusCategory(
      currentCategoryTotals: currentMonthCategoryTotals,
      previousCategoryTotals: previousMonthCategoryTotals,
      overallCategoryTotals: allTimeCategoryTotals,
    );
    final focusCategoryTitle = aiCategoryTitle(focusCategoryKey);
    final currentMonthCategorySpend =
        currentMonthCategoryTotals[focusCategoryKey] ?? 0.0;
    final previousMonthCategorySpend =
        previousMonthCategoryTotals[focusCategoryKey] ?? 0.0;
    final monthlyCategoryDelta =
        currentMonthCategorySpend - previousMonthCategorySpend;
    final monthlyCategoryDeltaPercent =
        previousMonthCategorySpend > 0
            ? (monthlyCategoryDelta / previousMonthCategorySpend) * 100
            : (currentMonthCategorySpend > 0 ? 100.0 : 0.0);
    final currentMonthLabel = _monthLabel(currentMonthStart);
    final previousMonthLabel = _monthLabel(previousMonthStart);

    final currentCategorySpend = currentCategoryTotals[focusCategoryKey] ?? 0.0;
    final previousCategorySpend =
        previousCategoryTotals[focusCategoryKey] ?? 0.0;
    final categoryDelta = currentCategorySpend - previousCategorySpend;
    final categoryDeltaPercent =
        previousCategorySpend > 0
            ? (categoryDelta / previousCategorySpend) * 100
            : (currentCategorySpend > 0 ? 100.0 : 0.0);

    final current30Total = last30.fold<double>(0, (sum, tx) => sum + tx.amount);
    final previous30Total = previous30.fold<double>(
      0,
      (sum, tx) => sum + tx.amount,
    );
    final totalChangePercent =
        previous30Total > 0
            ? ((current30Total - previous30Total) / previous30Total) * 100
            : (current30Total > 0 ? 100.0 : 0.0);

    final predictedNextMonthSpend = _predictNextMonthSpend(
      current30Total: current30Total,
      previous30Total: previous30Total,
      historicalMonthlyAverage:
          transactions.fold<double>(0.0, (sum, tx) => sum + tx.amount) /
          historyMonths,
      monthlyIncome: monthlyIncome,
    );
    final forecastSeries = _buildForecastSeries(
      transactions: transactions,
      now: currentNow,
      predictedNextMonthSpend: predictedNextMonthSpend,
    );
    final forecastCategories = _buildForecastCategories(
      currentTotals: currentCategoryTotals,
      previousTotals: previousCategoryTotals,
      allTimeTotals: allTimeCategoryTotals,
      predictedNextMonthSpend: predictedNextMonthSpend,
      historyMonths: historyMonths,
    );
    final predictedFocusAmount = _predictedAmountForCategory(
      focusCategoryKey,
      forecastCategories,
      predictedNextMonthSpend,
      allTimeCategoryTotals,
    );

    final normalizedBudgets = <String, double>{};
    for (final entry in budgets.entries) {
      normalizedBudgets[_normalizeCategoryKey(entry.key)] = entry.value;
    }
    final currentCategoryBudget = normalizedBudgets[focusCategoryKey] ?? 0.0;
    final suggestedCategoryBudget =
        math
            .max(
              currentCategoryBudget,
              math.max(
                predictedFocusAmount * 1.08,
                currentCategorySpend > 0 ? currentCategorySpend * 1.05 : 0.0,
              ),
            )
            .toDouble();

    final focusTransactions =
        last30
            .where(
              (tx) => _normalizeCategoryKey(tx.categoryKey) == focusCategoryKey,
            )
            .toList();
    final topFactors = _buildTopFactors(focusCategoryKey, focusTransactions);
    final confidence = _buildConfidence(
      currentCount: last30.length,
      previousCount: previous30.length,
      focusCurrent: currentCategorySpend,
      focusPrevious: previousCategorySpend,
    );
    final analysisPoints = _buildAnalysisPoints(
      focusCategoryKey: focusCategoryKey,
      focusCategoryTitle: focusCategoryTitle,
      currentCategorySpend: currentCategorySpend,
      previousCategorySpend: previousCategorySpend,
      categoryDeltaPercent: categoryDeltaPercent,
      focusTransactions: focusTransactions,
      topFactors: topFactors,
      currentCategoryBudget: currentCategoryBudget,
      suggestedCategoryBudget: suggestedCategoryBudget,
      monthlyIncome: monthlyIncome,
      predictedNextMonthSpend: predictedNextMonthSpend,
      predictedFocusAmount: predictedFocusAmount,
    );

    final homePreviewText = _buildHomePreview(
      focusCategoryTitle: focusCategoryTitle,
      categoryDeltaPercent: categoryDeltaPercent,
      currentCategorySpend: currentCategorySpend,
      previousCategorySpend: previousCategorySpend,
    );
    final analyticsPreviewText = _buildAnalyticsPreview(
      predictedNextMonthSpend: predictedNextMonthSpend,
      forecastCategories: forecastCategories,
    );

    return AiInsightResult(
      hasTransactions: true,
      focusCategoryKey: focusCategoryKey,
      focusCategoryTitle: focusCategoryTitle,
      currentMonthLabel: currentMonthLabel,
      previousMonthLabel: previousMonthLabel,
      currentMonthSpend: currentMonthSpend,
      previousMonthSpend: previousMonthSpend,
      monthlyDelta: monthlyDelta,
      monthlyDeltaPercent: monthlyDeltaPercent,
      currentMonthCategorySpend: currentMonthCategorySpend,
      previousMonthCategorySpend: previousMonthCategorySpend,
      monthlyCategoryDelta: monthlyCategoryDelta,
      monthlyCategoryDeltaPercent: monthlyCategoryDeltaPercent,
      currentCategorySpend: currentCategorySpend,
      previousCategorySpend: previousCategorySpend,
      categoryDelta: categoryDelta,
      categoryDeltaPercent: categoryDeltaPercent,
      current30Total: current30Total,
      previous30Total: previous30Total,
      totalChangePercent: totalChangePercent,
      confidence: confidence,
      analysisPoints: analysisPoints,
      topFactors: topFactors,
      predictedNextMonthSpend: predictedNextMonthSpend,
      forecastSeries: forecastSeries,
      forecastCategories: forecastCategories,
      suggestedCategoryBudget: suggestedCategoryBudget,
      currentCategoryBudget: currentCategoryBudget,
      homePreviewText: homePreviewText,
      analyticsPreviewText: analyticsPreviewText,
    );
  }

  static Map<String, double> _sumByCategory(
    List<AiInputTransaction> transactions,
  ) {
    final totals = <String, double>{};
    for (final tx in transactions) {
      final key = _normalizeCategoryKey(tx.categoryKey);
      totals[key] = (totals[key] ?? 0.0) + tx.amount;
    }
    return totals;
  }

  static String _pickFocusCategory({
    required Map<String, double> currentCategoryTotals,
    required Map<String, double> previousCategoryTotals,
    required Map<String, double> overallCategoryTotals,
  }) {
    final keys = {
      ...currentCategoryTotals.keys,
      ...previousCategoryTotals.keys,
      ...overallCategoryTotals.keys,
    };
    if (keys.isEmpty) {
      return 'food';
    }

    String bestKey = keys.first;
    double bestScore = -double.infinity;
    for (final key in keys) {
      final current = currentCategoryTotals[key] ?? 0.0;
      final previous = previousCategoryTotals[key] ?? 0.0;
      final delta = current - previous;
      final score = delta > 0 ? delta + (current * 0.2) : current * 0.6;
      if (score > bestScore) {
        bestScore = score;
        bestKey = key;
      }
    }
    return bestKey;
  }

  static double _predictNextMonthSpend({
    required double current30Total,
    required double previous30Total,
    required double historicalMonthlyAverage,
    required double monthlyIncome,
  }) {
    if (current30Total <= 0 && historicalMonthlyAverage <= 0) return 0;

    final trendProjection =
        previous30Total > 0
            ? current30Total +
                (((current30Total - previous30Total) / previous30Total) *
                    current30Total *
                    0.35)
            : current30Total > 0
            ? current30Total * 1.06
            : historicalMonthlyAverage;

    double prediction =
        (current30Total * 0.55) +
        (math.max(0.0, trendProjection) * 0.25) +
        (historicalMonthlyAverage * 0.20);

    final baseline = math.max(current30Total, historicalMonthlyAverage);
    final floor = math.max(
      current30Total * 0.78,
      historicalMonthlyAverage * 0.7,
    );
    final ceiling = monthlyIncome > 0 ? monthlyIncome * 1.15 : baseline * 1.45;

    prediction = prediction.clamp(floor, ceiling).toDouble();
    return prediction;
  }

  static List<AiForecastPoint> _buildForecastSeries({
    required List<AiInputTransaction> transactions,
    required DateTime now,
    required double predictedNextMonthSpend,
  }) {
    if (predictedNextMonthSpend <= 0) {
      return const [
        AiForecastPoint(label: 'Week 1', amount: 0),
        AiForecastPoint(label: 'Week 2', amount: 0),
        AiForecastPoint(label: 'Week 3', amount: 0),
        AiForecastPoint(label: 'Week 4', amount: 0),
      ];
    }

    final start = now.subtract(const Duration(days: 28));
    final weeklyTotals = List<double>.generate(4, (index) {
      final weekStart = start.add(Duration(days: index * 7));
      final weekEnd = weekStart.add(const Duration(days: 7));
      return transactions
          .where(
            (tx) => !tx.date.isBefore(weekStart) && tx.date.isBefore(weekEnd),
          )
          .fold<double>(0, (sum, tx) => sum + tx.amount);
    });

    final total = weeklyTotals.fold<double>(0, (sum, value) => sum + value);
    final shares =
        total > 0
            ? weeklyTotals.map((value) => value / total).toList()
            : const [0.22, 0.24, 0.26, 0.28];

    final points = <AiForecastPoint>[];
    double cumulative = 0;
    for (int i = 0; i < 4; i++) {
      cumulative += predictedNextMonthSpend * shares[i];
      points.add(
        AiForecastPoint(
          label: 'Week ${i + 1}',
          amount: i == 3 ? predictedNextMonthSpend : cumulative,
        ),
      );
    }
    return points;
  }

  static List<AiForecastCategory> _buildForecastCategories({
    required Map<String, double> currentTotals,
    required Map<String, double> previousTotals,
    required Map<String, double> allTimeTotals,
    required double predictedNextMonthSpend,
    required double historyMonths,
  }) {
    if (predictedNextMonthSpend <= 0) {
      return const [];
    }

    final keys = {
      ...currentTotals.keys,
      ...previousTotals.keys,
      ...allTimeTotals.keys,
    };
    if (keys.isEmpty) {
      return const [];
    }

    final rawPredictions = <String, double>{};
    for (final key in keys) {
      final recent = currentTotals[key] ?? 0.0;
      final previous = previousTotals[key] ?? 0.0;
      final historyAverage = (allTimeTotals[key] ?? 0.0) / historyMonths;

      double trendProjection;
      if (recent > 0 && previous > 0) {
        trendProjection = recent + ((recent - previous) * 0.35);
      } else if (recent > 0) {
        trendProjection = recent * 1.05;
      } else if (previous > 0) {
        trendProjection = previous * 0.82;
      } else {
        trendProjection = historyAverage;
      }

      final rawPrediction = math.max(
        0.0,
        (recent * 0.55) +
            (math.max(0.0, trendProjection) * 0.25) +
            (historyAverage * 0.20),
      );
      if (rawPrediction > 0) {
        rawPredictions[key] = rawPrediction.toDouble();
      }
    }

    if (rawPredictions.isEmpty) {
      return const [];
    }

    final rawTotal = rawPredictions.values.fold<double>(
      0.0,
      (sum, value) => sum + value,
    );
    if (rawTotal <= 0) {
      return const [];
    }

    final scale = predictedNextMonthSpend / rawTotal;
    final categories = <AiForecastCategory>[];
    for (final entry in rawPredictions.entries) {
      final recent = currentTotals[entry.key] ?? 0.0;
      final predicted = (entry.value * scale).toDouble();
      final changeAmount = predicted - recent;
      final changePercent =
          recent > 0
              ? ((changeAmount / recent) * 100).toDouble()
              : (predicted > 0 ? 100.0 : 0.0);

      categories.add(
        AiForecastCategory(
          categoryKey: entry.key,
          title: aiCategoryTitle(entry.key),
          recentAmount: recent,
          predictedAmount: predicted,
          changeAmount: changeAmount,
          changePercent: changePercent,
        ),
      );
    }

    categories.sort((a, b) {
      final byMovement = b.changeAmount.abs().compareTo(a.changeAmount.abs());
      if (byMovement != 0) {
        return byMovement;
      }
      return b.predictedAmount.compareTo(a.predictedAmount);
    });

    return categories.take(3).toList();
  }

  static double _predictedAmountForCategory(
    String key,
    List<AiForecastCategory> forecastCategories,
    double predictedNextMonthSpend,
    Map<String, double> overallCategoryTotals,
  ) {
    for (final item in forecastCategories) {
      if (_normalizeCategoryKey(item.categoryKey) == key) {
        return item.predictedAmount;
      }
    }

    final total = overallCategoryTotals.values.fold<double>(
      0,
      (sum, v) => sum + v,
    );
    if (total <= 0) return 0;
    final share = (overallCategoryTotals[key] ?? 0.0) / total;
    return predictedNextMonthSpend * share;
  }

  static double _historyMonthsCovered(
    List<AiInputTransaction> transactions,
    DateTime now,
  ) {
    if (transactions.isEmpty) {
      return 1.0;
    }

    DateTime oldest = transactions.first.date;
    for (final tx in transactions.skip(1)) {
      if (tx.date.isBefore(oldest)) {
        oldest = tx.date;
      }
    }

    final coveredDays = math.max(1, now.difference(oldest).inDays + 1);
    return math.max(1.0, coveredDays / 30.0).toDouble();
  }

  static List<AiFactorItem> _buildTopFactors(
    String focusCategoryKey,
    List<AiInputTransaction> transactions,
  ) {
    if (transactions.isEmpty) return const [];

    final grouped = <String, double>{};
    for (final tx in transactions) {
      final factor = _classifyFactor(focusCategoryKey, tx.title);
      grouped[factor] = (grouped[factor] ?? 0.0) + tx.amount;
    }

    final entries =
        grouped.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return entries.take(3).map((entry) {
      return AiFactorItem(title: entry.key, amount: entry.value);
    }).toList();
  }

  static String _classifyFactor(String categoryKey, String rawTitle) {
    final title = rawTitle.trim().toLowerCase();
    switch (categoryKey) {
      case 'food':
        if (_containsAny(title, [
          'zomato',
          'swiggy',
          'uber eats',
          'delivery',
        ])) {
          return 'Delivery Apps';
        }
        if (_containsAny(title, ['cafe', 'coffee', 'tea', 'starbucks'])) {
          return 'Cafes';
        }
        if (_containsAny(title, ['burger', 'pizza', 'restaurant', 'dining'])) {
          return 'Dining Out';
        }
        return 'Dining Out';
      case 'travel':
        if (_containsAny(title, ['flight', 'air', 'airport'])) {
          return 'Flights';
        }
        if (_containsAny(title, ['uber', 'ola', 'cab', 'taxi', 'auto'])) {
          return 'Local Travel';
        }
        if (_containsAny(title, ['fuel', 'petrol', 'diesel'])) {
          return 'Fuel';
        }
        return 'Travel Costs';
      case 'shopping':
        if (_containsAny(title, ['amazon', 'flipkart', 'online'])) {
          return 'Online Shopping';
        }
        if (_containsAny(title, ['mall', 'fashion', 'shirt', 'clothes'])) {
          return 'Fashion';
        }
        if (_containsAny(title, ['grocery', 'mart', 'supermarket'])) {
          return 'Essentials';
        }
        return 'Shopping';
      case 'bills':
        if (_containsAny(title, ['rent'])) {
          return 'Rent';
        }
        if (_containsAny(title, ['electric', 'water', 'gas'])) {
          return 'Utilities';
        }
        if (_containsAny(title, ['phone', 'mobile', 'internet', 'wifi'])) {
          return 'Connectivity';
        }
        return 'Bills';
      default:
        return title.isEmpty ? 'Miscellaneous' : _titleCase(rawTitle);
    }
  }

  static List<String> _buildAnalysisPoints({
    required String focusCategoryKey,
    required String focusCategoryTitle,
    required double currentCategorySpend,
    required double previousCategorySpend,
    required double categoryDeltaPercent,
    required List<AiInputTransaction> focusTransactions,
    required List<AiFactorItem> topFactors,
    required double currentCategoryBudget,
    required double suggestedCategoryBudget,
    required double monthlyIncome,
    required double predictedNextMonthSpend,
    required double predictedFocusAmount,
  }) {
    final points = <String>[];

    if (previousCategorySpend > 0) {
      final direction = categoryDeltaPercent >= 0 ? 'up' : 'down';
      points.add(
        '$focusCategoryTitle spending is $direction ${categoryDeltaPercent.abs().toStringAsFixed(0)}% versus the previous 30 days.',
      );
    } else {
      points.add(
        '$focusCategoryTitle became a noticeable spending category in the last 30 days.',
      );
    }

    final weekendShare = _weekendShare(focusTransactions);
    if (weekendShare >= 0.45) {
      points.add('Most of this spending happened on weekends.');
    } else if (topFactors.isNotEmpty) {
      points.add(
        '${topFactors.first.title} is the biggest driver inside this category.',
      );
    } else {
      points.add(
        'Multiple transactions in this category pushed the total higher.',
      );
    }

    if (currentCategoryBudget > 0 &&
        predictedFocusAmount > currentCategoryBudget) {
      points.add(
        'At the current pace, next month could exceed your ${focusCategoryTitle.toLowerCase()} budget by ${formatCurrency(predictedFocusAmount - currentCategoryBudget)}.',
      );
    } else if (suggestedCategoryBudget > 0) {
      points.add(
        'A budget near ${formatCurrency(suggestedCategoryBudget)} can help you control ${focusCategoryTitle.toLowerCase()} spending.',
      );
    } else if (monthlyIncome > 0 && predictedNextMonthSpend > monthlyIncome) {
      points.add(
        'Your projected monthly spend is close to your recorded income.',
      );
    }

    return points.take(3).toList();
  }

  static int _buildConfidence({
    required int currentCount,
    required int previousCount,
    required double focusCurrent,
    required double focusPrevious,
  }) {
    final raw =
        55 +
        math.min(20, currentCount * 2) +
        math.min(10, previousCount) +
        (focusPrevious > 0 ? 7 : 0) +
        (focusCurrent > 0 ? 5 : 0);
    return raw.clamp(55, 92).toInt();
  }

  static double _weekendShare(List<AiInputTransaction> transactions) {
    if (transactions.isEmpty) return 0;
    final weekendTotal = transactions
        .where(
          (tx) =>
              tx.date.weekday == DateTime.saturday ||
              tx.date.weekday == DateTime.sunday,
        )
        .fold<double>(0, (sum, tx) => sum + tx.amount);
    final total = transactions.fold<double>(0, (sum, tx) => sum + tx.amount);
    if (total <= 0) return 0;
    return weekendTotal / total;
  }

  static bool _containsAny(String value, List<String> tokens) {
    for (final token in tokens) {
      if (value.contains(token)) return true;
    }
    return false;
  }

  static String _monthLabel(DateTime date) {
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

    return months[date.month - 1];
  }

  static String _titleCase(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Miscellaneous';
    return trimmed
        .split(RegExp(r'\s+'))
        .map((word) {
          if (word.isEmpty) return word;
          final lower = word.toLowerCase();
          return lower[0].toUpperCase() + lower.substring(1);
        })
        .join(' ');
  }

  static String _buildHomePreview({
    required String focusCategoryTitle,
    required double categoryDeltaPercent,
    required double currentCategorySpend,
    required double previousCategorySpend,
  }) {
    if (currentCategorySpend <= 0 && previousCategorySpend <= 0) {
      return 'Add a few expenses to unlock AI insights.';
    }

    if (previousCategorySpend > 0) {
      final direction = categoryDeltaPercent >= 0 ? 'higher' : 'lower';
      return 'Your ${focusCategoryTitle.toLowerCase()} expenses are ${categoryDeltaPercent.abs().toStringAsFixed(0)}% $direction than the previous 30 days.';
    }

    return '$focusCategoryTitle became one of your biggest spending categories recently.';
  }

  static String _buildAnalyticsPreview({
    required double predictedNextMonthSpend,
    required List<AiForecastCategory> forecastCategories,
  }) {
    if (predictedNextMonthSpend <= 0) {
      return 'Your next 30 day forecast will appear here.';
    }

    if (forecastCategories.isEmpty) {
      return 'You may spend ${formatCurrency(predictedNextMonthSpend)} over the next 30 days.';
    }

    final topMover = forecastCategories.first;
    final direction = topMover.changeAmount >= 0 ? 'increase' : 'decrease';
    return 'You may spend ${formatCurrency(predictedNextMonthSpend)} next month. ${topMover.title} may $direction by ${formatCurrency(topMover.changeAmount.abs())}.';
  }
}

String _normalizeCategoryKey(String key) {
  final normalized = key.trim().toLowerCase();
  if (normalized == 'others') return 'other';
  if (normalized.isEmpty) return 'other';
  return normalized;
}
