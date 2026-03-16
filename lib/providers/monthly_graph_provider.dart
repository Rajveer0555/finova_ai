import 'package:finova_ai/models/monthly_graph.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finova_ai/providers/transactions_stream_provider.dart';

final lastSixMonthsExpenseProvider = Provider<List<double>>((ref) {
  final transactionsAsync = ref.watch(transactionsStreamProvider);

  final snapshot = transactionsAsync.value;

  if (snapshot == null) return List.filled(6, 0);

  Map<String, double> monthlyTotals = {};

  for (var doc in snapshot.docs) {
    final data = doc.data();

    double amount = (data['amount'] ?? 0).toDouble();

    DateTime date = (data['date'] as Timestamp).toDate();

    String key = "${date.year}-${date.month.toString().padLeft(2, '0')}";

    monthlyTotals[key] = (monthlyTotals[key] ?? 0) + amount;
  }

  /// generate last 6 months
  List<double> result = [];

  DateTime now = DateTime.now();

  for (int i = 5; i >= 0; i--) {
    DateTime month = DateTime(now.year, now.month - i);

    String key = "${month.year}-${month.month.toString().padLeft(2, '0')}";

    result.add(monthlyTotals[key] ?? 0);
  }

  return result;
});
final lastSixMonthLabelsProvider = Provider<List<String>>((ref) {
  List<String> labels = [];

  DateTime now = DateTime.now();

  for (int i = 5; i >= 0; i--) {
    DateTime month = DateTime(now.year, now.month - i);

    labels.add(
      [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ][month.month - 1],
    );
  }

  return labels;
});
final monthlyGraphProvider = Provider<MonthlyGraphData>((ref) {
  final transactionsAsync = ref.watch(transactionsStreamProvider);
  final snapshot = transactionsAsync.value;

  if (snapshot == null) {
    return MonthlyGraphData(
      values: List.filled(6, 0),
      labels: List.filled(6, ''),
      highestValue: 0,
      highestMonth: '',
      lowestValue: 0,
      lowestMonth: '',
    );
  }

  Map<String, double> monthlyTotals = {};

  for (var doc in snapshot.docs) {
    final data = doc.data();

    double amount = (data['amount'] ?? 0).toDouble();
    DateTime date = (data['date'] as Timestamp).toDate();

    String key = "${date.year}-${date.month.toString().padLeft(2, '0')}";

    monthlyTotals[key] = (monthlyTotals[key] ?? 0) + amount;
  }

  List<double> values = [];
  List<String> labels = [];

  DateTime now = DateTime.now();

  for (int i = 5; i >= 0; i--) {
    DateTime month = DateTime(now.year, now.month - i);

    String key = "${month.year}-${month.month.toString().padLeft(2, '0')}";

    double value = monthlyTotals[key] ?? 0;

    values.add(value);

    labels.add(
      [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ][month.month - 1],
    );
  }

  /// Highest & Lowest calculation
  double highest = values.first;
  double lowest = values.first;

  int highestIndex = 0;
  int lowestIndex = 0;

  for (int i = 0; i < values.length; i++) {
    if (values[i] > highest) {
      highest = values[i];
      highestIndex = i;
    }

    if (values[i] < lowest) {
      lowest = values[i];
      lowestIndex = i;
    }
  }

  return MonthlyGraphData(
    values: values,
    labels: labels,
    highestValue: highest,
    highestMonth: labels[highestIndex],
    lowestValue: lowest,
    lowestMonth: labels[lowestIndex],
  );
});
