import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finova_ai/providers/transactions_stream_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      highestMonth: '',
      highestValue: 0,
      lowestMonth: '',
      lowestValue: 0,
    );
  }

  double total = 0;
  final category = <String, double>{};
  final monthly = <String, double>{};

  for (final doc in snapshot.docs) {
    final data = doc.data();
    final amount = _readAmount(data['amount']);
    final date = _readDate(data['date']);
    if (date == null) {
      continue;
    }

    final categoryName = _normalizeCategory(data['category']);
    total += amount;

    category[categoryName] = (category[categoryName] ?? 0) + amount;

    final monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    monthly[monthKey] = (monthly[monthKey] ?? 0) + amount;
  }

  final avgMonth = monthly.isEmpty ? 0.0 : total / monthly.length;

  String highestMonth = '';
  double highestValue = 0;
  String lowestMonth = '';
  double lowestValue = 0;

  if (monthly.isNotEmpty) {
    lowestValue = monthly.values.first;
  }

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

double _readAmount(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? 0.0;
}

DateTime? _readDate(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  }
  if (value is DateTime) {
    return value;
  }
  return null;
}

String _normalizeCategory(dynamic value) {
  final category = value?.toString().trim().toLowerCase() ?? 'other';
  if (category == 'others' || category.isEmpty) {
    return 'other';
  }
  return category;
}
