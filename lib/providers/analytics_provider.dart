import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finova_ai/providers/transactions_stream_provider.dart';

class AnalyticsData {
  final double totalSpent;
  final double avgPerMonth;
  final Map<String, double> categoryMap;
  final Map<String, double> monthlyMap;
  final String highestMonth;
  final double highestValue;
  final String lowestMonth;
  final double lowestValue;

  AnalyticsData({
    required this.totalSpent,
    required this.avgPerMonth,
    required this.categoryMap,
    required this.monthlyMap,
    required this.highestMonth,
    required this.highestValue,
    required this.lowestMonth,
    required this.lowestValue,
  });
}

final analyticsProvider = Provider<AnalyticsData>((ref) {
  final snapshotAsync = ref.watch(transactionsStreamProvider);

  final snapshot = snapshotAsync.value;

  if (snapshot == null) {
    return AnalyticsData(
      totalSpent: 0,
      avgPerMonth: 0,
      categoryMap: {},
      monthlyMap: {},
      highestMonth: "",
      highestValue: 0,
      lowestMonth: "",
      lowestValue: 0,
    );
  }

  double total = 0;
  Map<String, double> category = {};
  Map<String, double> monthly = {};

  /// 🔹 Convert snapshot → documents
  for (var doc in snapshot.docs) {
    final data = doc.data();

    double amount = (data['amount'] ?? 0).toDouble();
    String categoryName = data['category'] ?? "Other";

    DateTime date = (data['date']).toDate();

    total += amount;

    /// CATEGORY
    category[categoryName] = (category[categoryName] ?? 0) + amount;

    /// MONTHLY
    String monthKey = "${date.year}-${date.month}";
    monthly[monthKey] = (monthly[monthKey] ?? 0) + amount;
  }

  double avgMonth = monthly.isEmpty ? 0 : total / monthly.length;

  String highestMonth = "";
  double highestValue = 0;

  String lowestMonth = "";
  double lowestValue = double.infinity;

  monthly.forEach((month, value) {
    if (value > highestValue) {
      highestValue = value;
      highestMonth = month;
    }

    if (value < lowestValue) {
      lowestValue = value;
      lowestMonth = month;
    }
  });

  return AnalyticsData(
    totalSpent: total,
    avgPerMonth: avgMonth,
    categoryMap: category,
    monthlyMap: monthly,
    highestMonth: highestMonth,
    highestValue: highestValue,
    lowestMonth: lowestMonth,
    lowestValue: lowestValue,
  );
});
